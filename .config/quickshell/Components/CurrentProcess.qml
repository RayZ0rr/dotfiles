import QtQuick
import QtQuick.Controls

import Quickshell.Io

import qs.Config
import qs.Components

Item {
    id: root
    property real marginSizeX: 30
    property real marginSizeY: 16
    readonly property real popupMarginSizeX: 40
    readonly property real popupMarginSizeY: 30
    property real commonPopupGap: 5
    property string currentName: "UNKNOWN"
    property int currentPID: -1
    property string currentIcon: ""
    readonly property color iconColor: Config.colorBg
    readonly property color textColor: "#81A6C6"
    implicitWidth: currentInfoBox.implicitWidth
    implicitHeight: Config.height
    Component.onCompleted: root.refresh()

    function refresh() {
        Config.startIfIdle(procName)
        Config.startIfIdle(procPID)
    }

    Rectangle {
        id: currentInfoBox
        readonly property real itemMarginSizeX: 15
        readonly property real itemMarginSizeY: 5
        anchors.centerIn: root
        color: root.textColor
        implicitWidth: currentInfo.implicitWidth + root.marginSizeX
        implicitHeight: Config.height
        radius: Config.radius
        Row {
            id: currentInfo
            anchors.centerIn: currentInfoBox
            spacing: 10
            Text {
                id: currentIcon
                text: root.currentIcon
                color: Config.colorBg
                font.pixelSize: 25 - currentInfoBox.itemMarginSizeY
                horizontalAlignment: Text.AlignHCenter
            }
            Text {
                id: currentName
                text: root.currentName
                color: Config.colorBg
                font.pixelSize: 20 - currentInfoBox.itemMarginSizeY
                elide: Text.ElideRight
                width: Math.max(currentName.contentWidth, 100)
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
    MouseArea {
        id: mouseControls
        anchors.fill: root
        cursorShape: Qt.WhatsThisCursor
        hoverEnabled: true
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
        property real maxHeight: 0
        delay: 500
        contentItem: Rectangle {
            id: currentPIDBox
            implicitWidth: Math.max(currentPID.implicitWidth + root.popupMarginSizeX, currentInfoBox.implicitWidth)
            implicitHeight: currentPID.implicitHeight + root.popupMarginSizeY
            radius: Config.radius
            color: Config.colorBg
            Text {
                id: currentPID
                anchors.centerIn: parent
                text: String(root.currentPID)
                color: "white"
                font.pixelSize: 15
            }
        }
    }
    Process {
        id: procName
        command: ["sh", "-c", "xdotool getwindowfocus getwindowname | awk '{print $1,$2}'"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                root.currentName = text.trim()
            }
        }
    }
    Process {
        id: procPID
        command: ["sh", "-c", "xdotool getwindowfocus"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                root.currentPID = parseInt(text.trim())
            }
        }
    }

    Timer {
        running: true
        repeat: true
        interval: 1000 * 5
        onTriggered: root.refresh()
    }
}
