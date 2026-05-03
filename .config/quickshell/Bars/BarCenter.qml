import QtQuick

import Quickshell

import qs.Config
import qs.Components

Row {
    id: root
    required property Row barLeft
    required property Row barRight
    required property ShellScreen screen
    readonly property real centerX: (screen.width - this.width)/2
    readonly property real rightX: Math.max(0, (this.centerX + this.width + Config.spacing) - barRight.x)
    readonly property real leftX: Math.max(0, (barLeft.x + barLeft.width + Config.spacing) - this.centerX)
    x: this.centerX - this.rightX + this.leftX
    anchors.verticalCenter: parent.verticalCenter
    spacing: Config.spacing

    CurrentProcess{}
}
