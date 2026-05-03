import QtQuick
import QtQuick.Layouts
import Quickshell
import "Components"

Scope {
    id: root
    component ShowHideAnimation : SmoothedAnimation {
        velocity: 100
    }

    readonly property real barMarginX: 10
    readonly property real barMarginY: 10
    readonly property real commonWidth: 100
    readonly property real commonSpacing: 5
    readonly property real commonHeight: 30
    readonly property real commonRadius: 12
    readonly property color commonBg: "#282828"

    Variants {
        model: Quickshell.screens;

        PanelWindow {
            id: barWin
            required property var modelData
            screen: modelData
            color: "transparent"

            anchors {
                top: true
                left: true
                right: true
            }
            implicitHeight: root.commonHeight + root.barMarginX

            Item {
                id: bar
                anchors.fill: parent

                Row {
                    id: barLeft
                    anchors.left: bar.left
                    anchors.leftMargin: root.barMarginX
                    anchors.verticalCenter: bar.verticalCenter
                    spacing: root.commonSpacing

                    Workspace{
                        commonHeight: root.commonHeight
                        commonRadius: root.commonRadius
                        commonSpacing: root.commonSpacing
                        commonBg: root.commonBg
                    }
                }

                Row {
                    id: barRight
                    anchors.right: bar.right
                    anchors.rightMargin: root.barMarginX
                    anchors.verticalCenter: bar.verticalCenter
                    spacing: root.commonSpacing

                    Network{
                        commonHeight: root.commonHeight
                        commonSpacing: root.commonSpacing
                        commonBg: root.commonBg
                    }
                    DateTime{
                        commonHeight: root.commonHeight
                        commonSpacing: root.commonSpacing
                        commonBg: root.commonBg
                    }
                    SysSpecs{
                        commonSpacing: root.commonSpacing
                        commonHeight: root.commonHeight
                        commonBg: root.commonBg
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if (sysMenuLoader1.item && sysMenuLoader1.item.opened) {
                                    sysMenuLoader1.active = false
                                } else {
                                    sysMenuLoader1.active = true
                                }
                            }
                        }
                        SysMenu{
                            x: 0
                            y: parent.height + 10
                        }
                    }
                    SysTray{
                        commonHeight: root.commonHeight
                        commonSpacing: root.commonSpacing
                        commonBg: root.commonBg
                    }
                }

                Row {
                    id: barCenter
                    readonly property real centerX: (screen.width - this.width)/2
                    readonly property real rightX: Math.max(0, (this.centerX + this.width + root.commonSpacing) - barRight.x)
                    readonly property real leftX: Math.max(0, (barLeft.x + barLeft.width + root.commonSpacing) - this.centerX)
                    x: this.centerX - this.rightX + this.leftX
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: root.commonSpacing

                    Rectangle {
                        color: "#059669"
                        radius: root.commonRadius
                        implicitWidth: 200
                        implicitHeight: root.commonHeight

                        Text {
                            anchors.centerIn: parent
                            text: "Placeholder"
                            color: "white"
                            font.pixelSize: 14
                        }
                    }
                }
            }
        }
    }
}
