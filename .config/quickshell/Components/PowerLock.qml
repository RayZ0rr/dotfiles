import QtQuick
import QtQuick.Controls

import Quickshell.Io

import qs.Config

Item {
    id: root
    property real marginSizeX: 30
    property real marginSizeY: 16
    property string appIcon: ""
    readonly property color iconColor: "#EA7B7B"
    implicitWidth: iconBox.implicitWidth
    implicitHeight: Config.height

    Process {id: proc}

    Rectangle {
        id: iconBox
        color: root.iconColor
        implicitWidth: icon.implicitWidth + root.marginSizeX
        implicitHeight: Config.height
        radius: Config.radius
        Text {
            id: icon
            anchors.centerIn: parent
            text: root.appIcon
            color: Config.colorBg
            font.pixelSize: parent.height - root.marginSizeY
        }
    }
    MouseArea {
        id: mouseControls
        anchors.fill: root
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton
        onClicked: function (mouse) {
            if (mouse.button == Qt.LeftButton){
                proc.exec(["sh", "-lc", `~/.config/rofi/scripts/rofi-power &`])
            }
            mouse.accepted = true
        }
    }
}
