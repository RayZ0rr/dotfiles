import QtQuick
import QtQuick.Controls

import Quickshell

import qs.Config

Item {
    id: root
    readonly property real marginSizeX: 30
    readonly property real marginSizeY: 17
    readonly property real popupMarginSizeX: 40
    readonly property real popupMarginSizeY: 30
    readonly property real iconSize: 25
    readonly property real textSize: 15
    property real tooltipHeight: 0
    property real commonPopupGap: 5
    property color textColor: "#FBC3C1"
    property string tooltipText: "Disconnected"
    implicitWidth: childrenRect.width
    implicitHeight: Config.height

    SystemClock {
        id: dateTime
        precision: SystemClock.Seconds
    }
    Rectangle {
        id: timeBox
        color: Config.colorBg
        implicitWidth: timeText.implicitWidth + root.marginSizeX
        implicitHeight: root.height
        radius: Config.radius
        Text {
            id: timeText
            anchors.centerIn: parent
            text: Qt.formatDateTime(dateTime.date, "hh:mm:ss")
            color: root.textColor
            font.pixelSize: parent.height - root.marginSizeY
        }
    }
    HoverHandler {
        acceptedDevices: PointerDevice.Mouse
        cursorShape: Qt.WhatsThisCursor
        onHoveredChanged: {
            if (this.hovered && !tooltip.popTimer.running && !tooltip.enter.running) {
                tooltip.popTimer.running = true
            }
            if (!this.hovered) {
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
            id: dateInfoBox
            // anchors.centerIn: parent
            implicitWidth: dateInfo.implicitWidth + root.marginSizeX
            implicitHeight: dateInfo.implicitHeight + root.marginSizeY
            radius: Config.radius
            color: Config.colorBg
            Column {
                id: dateInfo
                anchors.centerIn: dateInfoBox
                spacing: Config.spacing
                Text {
                    id: dateInfo1
                    text: Qt.formatDateTime(dateTime.date, "dd/MM/yyyy")
                    color: root.textColor
                    font.pixelSize: 15
                }
                Text {
                    id: dateInfo2
                    text: Qt.formatDateTime(dateTime.date, "dddd MMMM")
                    color: root.textColor
                    font.pixelSize: 15
                }
            }
        }
    }
}
