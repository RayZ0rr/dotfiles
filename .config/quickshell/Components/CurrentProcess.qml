import QtQuick
import QtQuick.Controls

import Quickshell.Io

import qs.Config

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
        readonly property real itemMarginSizeY: 17
        anchors.centerIn: root
        implicitWidth: currentInfo.implicitWidth + root.marginSizeX
        implicitHeight: Config.height
        radius: Config.radius
        Row {
            id: currentInfo
            Rectangle {
                id: currentNameBox
                color: Config.colorBg
                implicitWidth: currentName.implicitWidth + currentInfoBox.itemMarginSizeX
                implicitHeight: Config.height
                topLeftRadius: Config.radius
                bottomLeftRadius: Config.radius
                Text {
                    id: currentName
                    anchors.centerIn: parent
                    text: root.currentName
                    color: root.textColor
                    font.pixelSize: parent.height - currentInfoBox.itemMarginSizeY - 2
                }
            }
            Rectangle {
                id: currentIconBox
                color: root.textColor
                implicitWidth: currentIcon.contentWidth + currentInfoBox.itemMarginSizeX
                implicitHeight: Config.height
                topRightRadius: Config.radius
                bottomRightRadius: Config.radius
                Text {
                    id: currentIcon
                    anchors.centerIn: parent
                    elide: Text.ElideRight
                    text: root.currentIcon
                    color: Config.colorBg
                    font.pixelSize: parent.height - currentInfoBox.itemMarginSizeY
                    width: 10
                    clip: true
                }
            }
        }
    }
    MouseArea {
        id: mouseControls
        anchors.fill: root
        cursorShape: Qt.WhatsThisCursor
        hoverEnabled: true
    }
    ToolTip {
        id: tooltip
        property real maxHeight: 0
        padding: 0
        delay: 1000
        timeout: 0
        visible: mouseControls.containsMouse
        focus: false
        y: Config.height + root.commonPopupGap
        implicitWidth: currentPIDBox.implicitWidth
        implicitHeight: currentPIDBox.implicitHeight
        popupType: Popup.Window
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
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
            id: currentPIDBox
            // anchors.centerIn: parent
            implicitWidth: currentPID.implicitWidth + root.popupMarginSizeX
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
