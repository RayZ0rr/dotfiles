import QtQuick
import QtQuick.Controls

import Quickshell
import Quickshell.Io

import qs.Config
import qs.Components

Item {
    id: root
    readonly property real marginSizeX: 30
    readonly property real marginSizeY: 19
    readonly property real popupMarginSizeX: 40
    readonly property real popupMarginSizeY: 30
    readonly property real iconSize: 25
    readonly property real textSize: 15
    property real tooltipHeight: 0
    property real commonPopupGap: 5
    property string netName: "UNKOWN"
    property string netType: "UNKOWN"
    property string iconText: "ﲁ"
    property color iconColor: this.disconnected ? "darkgrey" : "#F8BC2F"
    property string tooltipText: "Disconnected"
    property string speed: "UNKNOWN"
    property bool disconnected: false
    readonly property string cmd: Quickshell.shellPath("Scripts/network.sh")
    implicitWidth: childrenRect.width
    implicitHeight: Config.height
    Component.onCompleted: root.refresh()

    function refresh() {
        Config.startIfIdle(procNetworkName)
        Config.startIfIdle(procNetworkIcon)
        Config.startIfIdle(procNetworkStatus)
        Config.startIfIdle(procNetworkTooltip)
        if (networkInfoPopLoader.active) {
            Config.startIfIdle(procNetworkSpeed)
        }
    }

    Timer {
        running: true
        repeat: true
        interval: 5000
        onTriggered: root.refresh()
    }
    Process {
        id: procNetworkExec
        running: true
        stdout: StdioCollector {
            onStreamFinished: root.refresh()
        }
    }
    Process {
        id: procNetworkName
        command: ["sh", "-lc", `${root.cmd} name`]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const name = text.trim()
                root.netName = name
            }
        }
    }
    Process {
        id: procNetworkType
        command: ["sh", "-lc", `${root.cmd} type`]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const name = text.trim()
                root.netType = name
            }
        }
    }
    Process {
        id: procNetworkIcon
        command: ["sh", "-lc", `${root.cmd} icon`]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const name = text.trim()
                root.iconText = name
            }
        }
    }
    Process {
        id: procNetworkStatus
        command: ["sh", "-lc", `${root.cmd} status`]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const name = text.trim()
                root.disconnected = name == "disconnected"
            }
        }
    }
    Process {
        id: procNetworkTooltip
        command: ["sh", "-lc", `${root.cmd} description`]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const name = text.trim()
                root.tooltipText = name
            }
        }
    }
    Process {
        id: procNetworkSpeed
        command: ["sh", "-lc", `${root.cmd} speed`]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const name = text.trim()
                root.speed = name
            }
        }
    }

    Rectangle {
        id: networkIconBox
        color: Config.colorBg
        implicitWidth: networkIcon.implicitWidth + root.marginSizeX
        implicitHeight: Config.height
        radius: Config.radius
        Text {
            id: networkIcon
            anchors.centerIn: parent
            text: root.iconText + "  "
            color: root.iconColor
            font.pixelSize: parent.height - root.marginSizeY
        }
    }
    MouseArea {
        anchors.fill: root
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        cursorShape: Qt.WhatsThisCursor
        hoverEnabled: true
        onClicked: function (mouse) {
            if (mouse.button == Qt.LeftButton){
                if (networkInfoPopLoader.item && networkInfoPopLoader.item.opened) {
                    networkInfoPopLoader.active = false
                } else {
                    networkInfoPopLoader.active = true
                }
            } else if (mouse.button == Qt.RightButton) {
                procNetworkExec.exec(["sh", "-lc", `alacritty -t nmtui -e bash $HOME/.local/bin/nmtui.sh &`])
            }
            mouse.accepted = true
        }
        onContainsMouseChanged: {
            if (this.containsMouse && !tooltip.popTimer.running && !tooltip.enter.running) {
                tooltip.popTimer.running = true
            }
            if (!this.containsMouse) {
                if (tooltip.enter.running || tooltip.opened || tooltip.popTimer.running) {
                    tooltip.popTimer.running = false
                    tooltip.close()
                }
            }
        }
    }
    MyTooltip {
        id: tooltip
        rootItem: root
        delay: 500
        contentItem: Rectangle {
            id: networkTextBox
            implicitWidth: networkText.implicitWidth + root.popupMarginSizeX
            implicitHeight: networkText.implicitHeight + root.popupMarginSizeY
            radius: Config.radius
            color: Config.colorBg
            Text {
                id: networkText
                anchors.centerIn: parent
                text: root.netName
                color: "white"
                font.pixelSize: 15
            }
        }
    }
    Loader {
        id: networkInfoPopLoader
        active: false
        sourceComponent: networkInfoPopComp
    }
    Component{
        id: networkInfoPopComp
        Popup {
            padding: 0
            visible: true
            focus: true
            y: Config.height + root.tooltipHeight + root.commonPopupGap
            popupType: Popup.Window
            closePolicy: Popup.CloseOnPressOutsideParent | Popup.NoAutoClose
            // transformOrigin: Popup.Top

            onClosed: {
                networkInfoPopLoader.active = false
            }

            Rectangle {
                color: "#111111"
                radius: 12
                border.color: "#333333"
                border.width: 1
                implicitWidth: networkInfoBox.implicitWidth + root.popupMarginSizeX
                implicitHeight: networkInfoBox.implicitHeight + root.popupMarginSizeY
                Column {
                    id: networkInfoBox
                    readonly property color textColor: "lightgrey"
                    anchors.centerIn: parent
                    spacing: Config.spacing

                    Row {
                        spacing: 20
                        anchors.horizontalCenter: networkInfoBox.horizontalCenter
                        Text {
                            text: root.iconText
                            color: "orange"
                            font.pixelSize: root.textSize
                        }
                        Text {
                            text: "Conn. type: " + root.netType
                            color: networkInfoBox.textColor
                            font.pixelSize: root.textSize
                        }
                    }
                    Row {
                        spacing: 20
                        anchors.horizontalCenter: networkInfoBox.horizontalCenter
                        Text {
                            text: "󰓅 "
                            color: "lightblue"
                            font.pixelSize: root.textSize
                        }
                        Text {
                            text: "Speed: " + root.speed
                            color: networkInfoBox.textColor
                            font.pixelSize: root.textSize
                        }
                    }
                    Text {
                        anchors.horizontalCenter: networkInfoBox.horizontalCenter
                        property color ssidColor: root.disconnected ? "darkred" : "darkgreen"
                        text: `<font color="${this.ssidColor}">SSID</font>: <font color="${networkInfoBox.textColor}">` + root.netName + "</font>"
                        color: networkInfoBox.textColor
                        font.pixelSize: root.textSize
                    }
                }
            }
        }
    }
}
