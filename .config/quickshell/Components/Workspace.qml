import QtQuick

import Quickshell
import Quickshell.Io

import qs.Config

Item {
    id: root
    property int monitorIndex: 0
    readonly property real marginSizeX: 40
    readonly property real marginSizeY: 16
    readonly property real textSize: 12
    property color currentColor: "#A1BDCE"
    property color currentUnfocusedColor: "#b9c8ff"
    property color openedColor: "#3E424F"
    property color urgentColor: "#ff7a7a"
    property var workspaces: []
    readonly property string cmd: Quickshell.shellPath("Scripts/workspace.sh")
    Component.onCompleted: {
        root.refresh()
    }

    implicitWidth: workspacesModuleBox.implicitWidth
    implicitHeight: Config.height

    function refresh() {
        root.Config.startIfIdle(workspaceProc)
    }
    function shellQuote(s) {
        return "'" + String(s).replace(/'/g, "'\"'\"'") + "'"
    }
    function activate(tagName) {
        Quickshell.execDetached([
            "sh", "-lc",
            "herbstclient focus_monitor " + monitorIndex +
            "; herbstclient use " + shellQuote(tagName)
        ])
    }

    function parseInfo(text) {
        const trimmed = String(text).trim()
        if (trimmed === "") {
            workspaces = []
            return
        }

        const next = []
        const lines = trimmed.split("\n")

        for (const line of lines) {
            const parts = line.split("\t")
            if (parts.length < 2)
                continue

            const state = parts[0]
            const name = parts.slice(1).join("\t")
            var hasNumber = /\d/;
            const ck = hasNumber.test(name);
            if (!ck && !state.includes("current")) {
                continue
            }

            next.push({
                state: state,
                name: name
            })
        }

        workspaces = next
    }

    function stateColor(state) {
        switch (state) {
        case "current":
            return currentColor
        case "current_unfocused":
            return currentUnfocusedColor
        case "urgent":
            return urgentColor
        default:
            return openedColor
        }
    }

    function useUnderline(state) {
        return state === "current" || state === "current_unfocused"
    }

    Process {
        id: workspaceProc
        command: ["sh", "-lc", root.cmd + " " + root.monitorIndex]
        running: true

        stdout: StdioCollector {
            onStreamFinished: root.parseInfo(text)
        }
    }

    Timer {
        running: true
        repeat: true
        interval: 100
        onTriggered: root.refresh()
    }

    Rectangle {
        id: workspacesModuleBox
        readonly property real itemMarginSizeX: 0
        readonly property real itemMarginSizeY: 17
        readonly property real textSize: Math.max(root.textSize, Config.height - this.itemMarginSizeY)
        implicitWidth: workspacesModule.implicitWidth + root.marginSizeX
        implicitHeight: Config.height
        radius: Config.radius
        color: Config.colorBg
        Row {
            id: workspacesModule
            anchors.centerIn: workspacesModuleBox
            spacing: 15

            Repeater {
                model: root.workspaces

                delegate: Rectangle {
                    id: workspacesBox
                    required property var modelData

                    implicitWidth: wsText.implicitWidth + workspacesModuleBox.itemMarginSizeX
                    implicitHeight: Config.height
                    color: Config.colorBg

                    Text {
                        id: wsText
                        anchors.centerIn: parent
                        text: modelData.name
                        color: root.stateColor(modelData.state)
                        font.pixelSize: workspacesModuleBox.textSize
                    }

                    Rectangle {
                        anchors.left: wsText.left
                        anchors.right: wsText.right
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 5
                        height: 1.5
                        radius: 1
                        color: wsText.color
                        visible: root.useUnderline(modelData.state)
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.activate(modelData.name)
                    }
                }
            }
        }
    }
}
