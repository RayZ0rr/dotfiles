import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets as QW
import Quickshell.Services.SystemTray

Item {
    id: root
    readonly property real marginSizeX: 40
    readonly property real marginSizeY: 16
    readonly property real iconSize: 25
    property real commonSpacing: 0
    property real commonHeight: 0
    property real commonRadius: 10
    property color commonBg: "black"
    property real commonPopupGap: 5
    implicitWidth: sysTrayToggle.implicitWidth
    height: this.commonHeight
    component ShowHideAnimation : SmoothedAnimation {
        velocity: 10
    }
    Rectangle {
        id: sysTrayToggle
        anchors.centerIn: root
        color: root.commonBg
        implicitWidth: sysTrayToggleText.text.length + root.marginSizeX
        height: root.height
        radius: root.commonRadius
        Text {
            id: sysTrayToggleText
            anchors.centerIn: parent
            text: sysTrayLoader.active ? "󰁣 " : "󰁋 "
            color: {
                let c = "#576A8F"
                if(sysTrayLoader.popupRunning) {
                    c = "yellow"
                } else if (sysTrayLoader.active) {
                    c = "green"
                }
                return c
            }
            font.pointSize: parent.height - root.marginSizeY
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (sysTrayLoader.item && sysTrayLoader.item.opened) {
                    sysTrayLoader.item.close()
                } else {
                    sysTrayLoader.active = true
                }
            }
        }
    }

    Loader {
        id: sysTrayLoader
        property bool popupRunning: false
        active: false
        sourceComponent: sysTrayComp
    }
    Component{
        id: sysTrayComp
        Popup{
            property real posBottom: 0
            visible: true
            focus: false
            y: root.height + root.commonPopupGap
            popupType: Popup.Window
            closePolicy: Popup.NoAutoClose
            padding: 0

            onClosed: {
                sysTrayLoader.active = false
            }
            enter: Transition{
                SequentialAnimation {
                    SmoothedAnimation {
                        target: sysTrayBox
                        property: "implicitHeight"
                        from: 0
                        to: sysTrayBox.childHeight
                        velocity: 100
                        easing.type: Easing.OutCubic
                    }
                }
            }

            exit: Transition{
                SequentialAnimation {
                    SmoothedAnimation {
                        target: sysTrayBox
                        property: "implicitHeight"
                        from: sysTrayBox.childHeight
                        to: 0
                        velocity: 100
                        easing.type: Easing.InCubic
                    }
                    NumberAnimation {property: "opacity"; from: 1.0; to: 0.0; duration: 10; easing.type: Easing.OutCubic}
                }
            }

            contentItem: Rectangle {
                id: sysTrayBox
                readonly property real itemMarginSizeX: 1
                readonly property real itemMarginSizeY: 5
                readonly property real itemSpacing: 5
                property real childHeight: sysTray.implicitHeight + root.marginSizeY
                implicitWidth: root.implicitWidth
                implicitHeight: 0
                // implicitHeight: this.childHeight
                radius: root.commonRadius
                color: "#574964"
                clip: true
                Column {
                    id: sysTray
                    anchors.top: parent.top
                    anchors.topMargin: root.marginSizeY / 2
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: sysTrayBox.itemSpacing
                    Repeater {
                        model: SystemTray.items

                        Rectangle {
                            id: sysTrayItem
                            required property SystemTrayItem modelData
                            implicitWidth: sysTrayBox.implicitWidth
                            implicitHeight: sysTrayItemIcon.implicitHeight + sysTrayBox.itemMarginSizeY
                            color: sysTrayBox.color

                            QW.IconImage {
                                id: sysTrayItemIcon
                                anchors.centerIn: sysTrayItem
                                implicitWidth: sysTrayItem.implicitWidth - sysTrayBox.itemMarginSizeX
                                implicitHeight: root.iconSize
                                source: {
                                    sysTrayItem.modelData.icon
                                }
                            }

                            QsMenuAnchor {
                                id: menuAnchor
                                menu: sysTrayItem.modelData.menu
                                anchor.item: sysTrayToggle
                                anchor.onAnchoring: {
                                    const window = sysTrayToggle.Window.window;
                                    const widgetRect = window.contentItem.mapFromItem(sysTrayToggle, sysTrayToggle.width, sysTrayToggle.height + sysTrayItem.height, 0, 0);
                                    menuAnchor.anchor.rect = widgetRect
                                }
                                onClosed: {
                                    console.log("id:", sysTrayItem.modelData.id)
                                    console.log("has mouse:", mouseArea.containsMouse)
                                }
                            }
                            MouseArea {
                                id: mouseArea
                                anchors.fill: sysTrayItem
                                hoverEnabled: true
                                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                                onClicked: function (mouse) {
                                    if (sysTrayItem.modelData.onlyMenu || mouse.button == Qt.RightButton) {
                                        menuAnchor.open();
                                    }
                                    else if (mouse.button == Qt.LeftButton){
                                        sysTrayItem.modelData.activate();
                                    }
                                    else {
                                        sysTrayItem.modelData.secondaryActivate();
                                    }
                                    mouse.accepted = true
                                }
                            }
                            Loader {
                                id: tooltip
                                y: sysTrayItem.y + sysTrayItem.height
                                active: false
                                sourceComponent: Rectangle {
                                    visible: tooltip.active
                                    border.color: "grey"
                                    color: "black"
                                    radius: 5
                                    implicitWidth: 100
                                    implicitHeight: 100
                                    Text {
                                        anchors.fill: parent
                                        text: sysTrayItem.modelData.tooltipTitle
                                        font.pixelSize: 10
                                        color: "white"
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
