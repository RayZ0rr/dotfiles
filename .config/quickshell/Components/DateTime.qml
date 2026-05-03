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
        id: hoverControls
        acceptedDevices: PointerDevice.Mouse
        cursorShape: Qt.WhatsThisCursor
    }
    ToolTip {
        id: tooltip
        property real maxHeight: 0
        padding: 0
        delay: 1000
        timeout: 0
        visible: hoverControls.hovered
        focus: false
        y: root.height + root.commonPopupGap
        implicitWidth: dateInfoBox.implicitWidth
        implicitHeight: dateInfoBox.implicitHeight
        popupType: Popup.Window
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        // closePolicy: Popup.NoAutoClose
        transformOrigin: Popup.Top

        enter: Transition{
            SequentialAnimation {
                ParallelAnimation {
                    NumberAnimation {property: "opacity"; from: 0.0; to: 1.0; duration: 110; easing.type: Easing.OutCubic}
                    NumberAnimation {property: "scale"; from: 0.18; to: 1.0; duration: 170; easing.type: Easing.OutBack}
                }
                ScriptAction {script: {
                    tooltip.maxHeight = tooltip.height + root.commonPopupGap
                    root.tooltipHeight = root.tooltipHeight + tooltip.maxHeight
                }}
            }
        }
        exit: Transition{
            SequentialAnimation {
                ParallelAnimation {
                    NumberAnimation {property: "opacity"; from: 0.0; to: 1.0; duration: 110; easing.type: Easing.OutCubic}
                    NumberAnimation {property: "scale"; from: 0.18; to: 1.0; duration: 170; easing.type: Easing.OutBack}
                }
                ScriptAction {script: {
                    root.tooltipHeight = root.tooltipHeight - tooltip.maxHeight
                }}
            }
        }
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
