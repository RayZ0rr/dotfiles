import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets as QW
import Quickshell.Services.SystemTray
import Quickshell.Io

Item {
    id: root
    required property QtObject panel
    readonly property real marginSizeX: 30
    readonly property real marginSizeY: 15
    readonly property real iconSize: 25
    readonly property real textSize: 15
    property real commonSpacing: 0
    property real commonHeight: 0
    property real commonRadius: 10
    property color commonBg: "black"
    implicitWidth: networkModule.implicitWidth
    height: this.commonHeight
    property string netName: "UNKOWN"
    property string netType: "UNKOWN"
    property string iconText: "ﲁ"
    property color iconColor: this.disconnected ? "darkgrey" : "#F8BC2F"
    property string tooltipText: "Disconnected"
    property string speed: "UNKNOWN"
    property bool disconnected: false
    readonly property string cmd: "$HOME/.local/bin/network.sh"
    component ShowHideAnimation : SmoothedAnimation {
        velocity: 100
    }
    function startIfIdle(proc) {
        if (!proc.running) {
            proc.running = true
        }
    }
    function refresh() {
        startIfIdle(procNetworkName)
        startIfIdle(procNetworkIcon)
        startIfIdle(procNetworkStatus)
        startIfIdle(procNetworkTooltip)
        if (networkInfoPopLoader.active) {
            startIfIdle(procNetworkSpeed)
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
    Row {
        id: networkModule
        anchors.centerIn: root
        // anchors.verticalCenter: root.verticalCenter

        Rectangle{
            id: networkLoaderBox
            property real item_width: 0
            property real root_width_extend: 0
            color: "transparent"
            implicitWidth: 0
            height: root.height
            radius: root.commonRadius
            clip: true
            visible: networkLoader.active
            Loader {
                id: networkLoader
                anchors.fill: networkLoaderBox
                active: false
                sourceComponent: networkComp
                onLoaded: {
                    networkLoaderBox.item_width = networkLoader.item.implicitWidth
                    networkLoaderBox.root_width_extend = networkLoaderBox.item_width
                    anim_show.start()
                }
                SequentialAnimation {
                    id: anim_hide
                    ShowHideAnimation {target: networkLoaderBox; property: "implicitWidth"; to: networkLoaderBox.implicitWidth - networkLoaderBox.item_width}
                    PropertyAction {target: networkLoader; property: "active"; value: false}
                    PropertyAction {target: panel; property: "implicitWidth"; value: (panel.implicitWidth - networkLoaderBox.root_width_extend)}
                }
                SequentialAnimation {
                    id: anim_show
                    PropertyAction {target: panel; property: "implicitWidth"; value: (panel.implicitWidth + networkLoaderBox.root_width_extend)}
                    // PropertyAction {target: hoverControl; property: "implicitWidth"; value: (panel.implicitWidth + networkLoaderBox.root_width_extend)}
                    ShowHideAnimation {target: networkLoaderBox; property: "implicitWidth"; to: networkLoaderBox.implicitWidth + networkLoaderBox.item_width}
                }
            }
        }
        Rectangle {
            id: networkIconBox
            color: root.commonBg
            implicitWidth: networkIcon.implicitWidth + root.marginSizeX
            height: root.height
            radius: root.commonRadius
            Text {
                id: networkIcon
                anchors.centerIn: parent
                text: root.iconText + "  "
                color: root.iconColor
                font.pixelSize: parent.height - root.marginSizeY
            }
        }

    }
    HoverHandler {
        id: hoverController
        acceptedDevices: PointerDevice.Mouse
        cursorShape: Qt.CrossCursor
        onHoveredChanged: {
            if (this.hovered && !anim_hide.running) {
                if (networkLoader.active == false) {
                    root.refresh()
                    networkLoader.active = true
                }
            }
            if (!this.hovered && !anim_show.running) {
                if (networkLoader.active == true) {
                    root.refresh()
                    anim_hide.start()
                }
            }
        }
    }
    Component{
        id: networkComp
        Rectangle {
            id: networkBox
            implicitWidth: networkText.implicitWidth + root.marginSizeX
            height: root.height
            radius: root.commonRadius
            color: root.commonBg
            Text {
                id: networkText
                anchors.centerIn: parent
                text: root.netName
                color: "white"
                font.pixelSize: 15
            }
        }
    }
    MouseArea {
        anchors.fill: root
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        cursorShape: Qt.WhatsThisCursor
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
    }
    Loader {
        id: networkInfoPopLoader
        active: false
        sourceComponent: networkInfoPopComp
        x: 0
        y: root.height + 10
    }
    Component{
        id: networkInfoPopComp
        Popup {
            visible: true
            focus: false
            popupType: Popup.Window
            padding: 8
            closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

            onClosed: {
                networkInfoPopLoader.active = false
            }

            background: Rectangle {
                color: "#111111"
                radius: 12
                border.color: "#333333"
                border.width: 1
                implicitWidth: networkInfoBox.implicitWidth + root.marginSizeX
                implicitHeight: networkInfoBox.implicitHeight + root.marginSizeY
            }

            contentItem: Column {
                id: networkInfoBox
                spacing: root.commonSpacing

                Text {
                    anchors.verticalCenter: networkInfoItem.verticalCenter
                    text: "Conn. type: " + root.netType
                    color: "white"
                    font.pixelSize: root.textSize
                }

                Text {
                    anchors.verticalCenter: networkInfoItem.verticalCenter
                    text: "Speed: " + root.speed
                    color: "white"
                    font.pixelSize: root.textSize
                }

                Text {
                    id: networkText
                    anchors.horizontalCenter: networkInfoBox.horizontalCenter
                    text: "Conn. name: " + root.netName
                    color: "white"
                    font.pixelSize: root.textSize
                }
            }
        }
    }
}
