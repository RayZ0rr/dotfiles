import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Quickshell
import Quickshell.Io

Loader{
    id: root
    readonly property real marginSizeX: 30
    readonly property real marginSizeY: 10
    readonly property real spacing: 10
    readonly property real itemMarginSizeX: 20
    readonly property real itemMarginSizeY: 10
    readonly property color iconColor: "#A1BDCE"
    readonly property color sliderColor: "#A1BDCE"
    readonly property color sliderColorBg: "#101217"
    readonly property color handleColor: "#A1BDC1"
    readonly property real iconSize: 24
    active: false
    x: 0
    y: 0
    function startIfIdle(proc) {
        if (!proc.running) {
            proc.running = true
        }
    }
    property list<QtObject> menuItems: [
        QtObject {
            id: menuItemBrightness
            readonly property string key: "brightness"
            readonly property string label: "Brightness"
            readonly property int minValue: 10
            readonly property int maxValue: 100
            readonly property string cmd: Quickshell.shellPath("Scripts/brightness.sh")
            property string iconText: "☀"
            property color iconColor: root.iconColor
            property string tooltipText: "Default brightness"
            property int value: 60
            function applyValue(v) {
                const next = Math.round(v)
                procBrightExec.exec(["sh", "-lc", `${this.cmd} set-silent ${next}`])
            }
            property bool hasRefreshFn: true
            function refresh() {
                startIfIdle(procBrightPercent)
                startIfIdle(procBrightIcon)
                startIfIdle(procBrightTooltip)
            }
            property bool hasBodyClickFn: false
            property bool hasRightClickFn: false
            function onRightClick() {
                console.log("volume right click")
            }
        },
        QtObject {
            id: menuItemVolume
            readonly property string key: "volume"
            readonly property string label: "Volume"
            readonly property int minValue: 0
            readonly property int maxValue: 100
            readonly property string cmd: "$HOME/.local/bin/pulseaudio-control"
            property string iconText: "󰕾"
            property color iconColor: this.muted ? "darkgrey" : root.iconColor
            property string tooltipText: "Default sink"
            property int value: 35
            property bool muted: false
            function applyValue(v) {
                const next = Math.round(v)
                procVolumeExec.exec(["sh", "-lc", `${this.cmd} set-silent ${next}`])
            }
            property bool hasRefreshFn: true
            function refresh() {
                startIfIdle(procVolumePercent)
                startIfIdle(procVolumeIcon)
                startIfIdle(procVolumeMute)
                startIfIdle(procVolumeTooltip)
            }
            property bool hasBodyClickFn: true
            function onBodyClick() {
                procVolumeExec.exec(["sh", "-lc", `${this.cmd} togmute`])
            }
            property bool hasRightClickFn: true
            function onRightClick() {
                Quickshell.execDetached(["pavucontrol"])
            }
        }
    ]
    Timer {
        running: true
        repeat: true
        interval: 5000
        onTriggered: menuItemVolume.refresh()
    }
    Process {
        id: procVolumeExec
        running: true
        stdout: StdioCollector {
            onStreamFinished: menuItemVolume.refresh()
        }
    }
    Process {
        id: procVolumePercent
        command: ["sh", "-lc", `${menuItemVolume.cmd} vol`]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const next = Number(text.trim() || 0)
                if (!Number.isNaN(next)) {
                    menuItemVolume.value = next
                }
            }
        }
    }
    Process {
        id: procVolumeIcon
        command: ["sh", "-lc", `${menuItemVolume.cmd} get-icon`]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                menuItemVolume.iconText = text.trim()
            }
        }
    }
    Process {
        id: procVolumeMute
        command: ["sh", "-lc", `${menuItemVolume.cmd} get-mute`]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                menuItemVolume.muted = text.trim() == "true"
            }
        }
    }
    Process {
        id: procVolumeTooltip
        command: ["sh", "-lc", `${menuItemVolume.cmd} get-description`]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                menuItemVolume.tooltipText = text.trim()
            }
        }
    }
    Timer {
        running: true
        repeat: true
        interval: 5000
        onTriggered: menuItemBrightness.refresh()
    }
    Process {
        id: procBrightExec
        running: true
        stdout: StdioCollector {
            onStreamFinished: menuItemBrightness.refresh()
        }
    }
    Process {
        id: procBrightPercent
        command: ["sh", "-lc", `${menuItemBrightness.cmd} get-percent`]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const next = Number(text.trim() || 0)
                if (!Number.isNaN(next)) {
                    menuItemBrightness.value = next
                }
            }
        }
    }
    Process {
        id: procBrightIcon
        command: ["sh", "-lc", `${menuItemBrightness.cmd} icon`]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                menuItemBrightness.iconText = text.trim()
            }
        }
    }
    Process {
        id: procBrightTooltip
        command: ["sh", "-lc", `${menuItemBrightness.cmd} get`]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                menuItemBrightness.tooltipText = "Current brightness " +  text.trim()
            }
        }
    }

    sourceComponent: Component{
        Popup {
            visible: true
            focus: true
            popupType: Popup.Window
            padding: 8
            closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

            onClosed: {
                root.active = false
            }

            background: Rectangle {
                color: "#111111"
                radius: 12
                border.color: "#333333"
                border.width: 1
                implicitWidth: sysMenuBox.implicitWidth + root.marginSizeX
                implicitHeight: sysMenuBox.implicitHeight + root.marginSizeY
            }

            contentItem: Column {
                id: sysMenuBox
                spacing: root.spacing

                Repeater {
                    model: root.menuItems

                    delegate: Rectangle {
                        required property var modelData

                        implicitWidth: sysMenuItem.implicitWidth + root.itemMarginSizeX
                        implicitHeight: sysMenuItem.implicitHeight + root.itemMarginSizeY
                        radius: 8
                        color: "#1b1b1b"
                        border.color: "#2d2d2d"
                        border.width: 1
                        Component.onCompleted: {
                            modelData.refresh()
                        }

                        MouseArea {
                            id: bodyMouse
                            anchors.fill: parent
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            ToolTip.visible: bodyMouse.containsMouse
                            ToolTip.delay: 300
                            ToolTip.text: modelData.tooltipText

                            onClicked: function(mouse) {
                                if (mouse.button == Qt.RightButton && modelData.hasRightClickFn) {
                                    modelData.onRightClick()
                                }

                                if (mouse.button == Qt.LeftButton && modelData.hasBodyClickFn) {
                                    modelData.onBodyClick()
                                }
                                mouse.accepted = true
                            }
                        }

                        Row {
                            id: sysMenuItem
                            anchors.centerIn: parent
                            spacing: 10

                            Text {
                                anchors.verticalCenter: sysMenuItem.verticalCenter
                                text: modelData.iconText
                                color: modelData.iconColor
                                font.pixelSize: root.iconSize
                            }

                            Slider {
                                id: rowSlider
                                // implicitWidth: 120
                                // implicitHeight: 40
                                anchors.verticalCenter: sysMenuItem.verticalCenter

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
                                    color: root.sliderColorBg
                                    border.width: 1
                                    border.color: "#1b1f27"

                                    Rectangle {
                                        width: rowSlider.visualPosition * (parent.width - 4)
                                        height: parent.height - 4
                                        radius: height / 2
                                        anchors.left: parent.left
                                        anchors.leftMargin: 2
                                        anchors.verticalCenter: parent.verticalCenter
                                        color: root.sliderColor
                                    }
                                }

                                handle: Rectangle {
                                    implicitWidth: 16
                                    implicitHeight: 16
                                    radius: width / 2
                                    color: root.handleColor
                                    border.width: 1
                                    border.color: "#1b1f27"

                                    x: rowSlider.leftPadding + rowSlider.visualPosition * (rowSlider.availableWidth - width)
                                    y: rowSlider.topPadding + (rowSlider.availableHeight - height) / 2
                                }
                            }

                            TextField {
                                id: valueField
                                implicitWidth: 44
                                anchors.verticalCenter: sysMenuItem.verticalCenter
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
