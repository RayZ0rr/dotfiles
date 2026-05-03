import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Loader{
    id: sysMenuLoader
    active: false
    x: 0
    y: 0
    property list<QtObject> menuItems: [
        QtObject {
            id: menuItemBrightness
            property string key: "brightness"
            property string label: "Brightness"
            property string iconText: "☀"
            property string tooltipText: "Default brightness"
            property int value: 60
            property int prevValue: 50
            property int minValue: 10
            property int maxValue: 100
            function applyValue(v) {
                const next = Math.round(v)
                menuItemBrightness.value = next

                if (next > 0) {
                    menuItemBrightness.prevValue = next
                }

                menuItemBrightness.tooltipText = "New brightness"
                console.log("brightness applyValue:", v)
            }
            property bool hasBodyClickFn: false
            property bool hasRightClickFn: false
            function onRightClick() {
                console.log("volume right click")
            }
        },
        QtObject {
            id: menuItemVolume
            property string key: "volume"
            property string label: "Volume"
            property string iconText: "󰕾"
            property string tooltipText: "Default sink"
            property int value: 35
            property int prevValue: 50
            property int minValue: 0
            property int maxValue: 100
            property bool muted: false
            function applyValue(v) {
                const next = Math.round(v)
                menuItemVolume.value = next

                if (next > 0) {
                    menuItemVolume.prevValue = next
                }

                menuItemVolume.muted = next === 0
                menuItemVolume.iconText = menuItemVolume.muted ? "󰝟" : "󰕾"
                menuItemVolume.tooltipText = menuItemVolume.muted ? "Muted" : "Default sink"
                console.log("volume applyValue:", next)
            }
            property bool hasBodyClickFn: true
            function onBodyClick() {
                if (menuItemVolume.muted || menuItemVolume.value === 0) {
                    menuItemVolume.muted = false
                    menuItemVolume.value = menuItemVolume.prevValue > 0 ? menuItemVolume.prevValue : 35
                } else {
                    menuItemVolume.prevValue = menuItemVolume.value > 0 ? menuItemVolume.value : menuItemVolume.prevValue
                    menuItemVolume.muted = true
                    menuItemVolume.value = 0
                }
                menuItemVolume.iconText = menuItemVolume.muted ? "󰝟" : "󰕾"
                menuItemVolume.tooltipText = menuItemVolume.muted ? "Muted" : "Default sink"
            }
            property bool hasRightClickFn: true
            function onRightClick() {
                console.log("volume right click")
            }
        }
    ]

    sourceComponent: Component{
        Popup {
            id: pop_test
            visible: true
            focus: true
            popupType: Popup.Window
            padding: 8
            closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

            onClosed: {
                sysMenuLoader.active = false
            }

            background: Rectangle {
                color: "#111111"
                radius: 12
                border.color: "#333333"
                border.width: 1
            }

            contentItem: ColumnLayout {
                spacing: 6

                Repeater {
                    model: sysMenuLoader.menuItems

                    delegate: Rectangle {
                        required property var modelData

                        Layout.fillWidth: true
                        implicitWidth: 320
                        implicitHeight: 40
                        radius: 8
                        color: "#1b1b1b"
                        border.color: "#2d2d2d"
                        border.width: 1

                        MouseArea {
                            id: bodyMouse
                            anchors.fill: parent
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            ToolTip.visible: bodyMouse.containsMouse
                            ToolTip.delay: 300
                            ToolTip.text: modelData.tooltipText

                            onClicked: function(mouse) {
                                if (mouse.button === Qt.RightButton && modelData.hasRightClickFn) {
                                    modelData.onRightClick()
                                    return
                                }

                                if (mouse.button === Qt.LeftButton && modelData.hasBodyClickFn) {
                                    modelData.onBodyClick()
                                }
                            }
                        }

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 10
                            anchors.rightMargin: 10
                            spacing: 10

                            Text {
                                text: modelData.iconText
                                color: "#e8e8e8"
                                font.pixelSize: 16
                            }

                            Slider {
                                id: rowSlider
                                Layout.fillWidth: true
                                Layout.preferredWidth: 120
                                Layout.alignment: Qt.AlignVCenter

                                from: modelData.minValue
                                to: modelData.maxValue
                                value: modelData.value
                                stepSize: 1
                                padding: 0
                                live: true
                                onMoved: modelData.applyValue(value)

                                background: Rectangle {
                                    x: 0
                                    y: (rowSlider.height - height) / 2
                                    implicitWidth: 120
                                    implicitHeight: 14
                                    radius: height / 2
                                    color: "#101217"
                                    border.width: 1
                                    border.color: "#1b1f27"

                                    Rectangle {
                                        width: rowSlider.visualPosition * (parent.width - 4)
                                        height: parent.height - 4
                                        radius: height / 2
                                        anchors.left: parent.left
                                        anchors.leftMargin: 2
                                        anchors.verticalCenter: parent.verticalCenter
                                        color: "#d8c0ad"
                                    }
                                }

                                handle: Rectangle {
                                    implicitWidth: 16
                                    implicitHeight: 16
                                    radius: width / 2
                                    color: "#ead8ca"
                                    border.width: 1
                                    border.color: "#c9b39d"

                                    x: rowSlider.leftPadding + rowSlider.visualPosition * (rowSlider.availableWidth - width)
                                    y: rowSlider.topPadding + (rowSlider.availableHeight - height) / 2
                                }
                            }

                            TextField {
                                id: valueField
                                Layout.preferredWidth: 44
                                Layout.alignment: Qt.AlignVCenter

                                horizontalAlignment: TextInput.AlignHCenter
                                padding: 0
                                readOnly: false
                                selectByMouse: true
                                inputMethodHints: Qt.ImhDigitsOnly

                                validator: IntValidator {
                                    bottom: modelData.minValue
                                    top: modelData.maxValue
                                }

                                text: String(modelData.value)

                                onEditingFinished: {
                                    if (acceptableInput && text !== "")
                                    modelData.applyValue(Number(text))
                                    else
                                    text = String(modelData.value)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
