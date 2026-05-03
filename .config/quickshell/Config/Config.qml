pragma Singleton

import QtQuick

import Quickshell

Singleton {
    id: root
    readonly property real barMarginX: 10
    readonly property real barMarginY: 5
    readonly property real width: 100
    readonly property real spacing: 5
    readonly property real height: 33
    readonly property real radius: 10
    readonly property color colorBg: "#282828"
    readonly property Component showHideAnimation: SmoothedAnimation {
        velocity: 100
    }

    function startIfIdle(proc) {
        if (!proc.running)
            proc.running = true
    }
}
