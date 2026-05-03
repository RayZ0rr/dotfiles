import QtQuick
import QtQuick.Layouts
import Quickshell
import "Components"

Scope {
    id: root
    component ShowHideAnimation : SmoothedAnimation {
        velocity: 10
    }

    readonly property real commonWidth: 100
    readonly property real commonSpacing: 20
    readonly property real commonHeight: 40
    readonly property real commonRadius: 10

    Variants {
        model: [1]

        PanelWindow {
            id: bar_left
            required property var modelData
            color: "transparent"

            anchors {
                top: true
                left: true
            }
            Component.onCompleted: {
                implicitWidth = row_left.implicitWidth + 20
                implicitHeight = row_left.implicitHeight + 5
                console.log(`implicitWidth: ${implicitWidth}`)
            }
            // implicitWidth: row_left.implicitWidth + 20
            // implicitHeight: row_left.implicitHeight + 5
            Behavior on width {
                ShowHideAnimation {}
            }
            Behavior on height {
                ShowHideAnimation {}
            }

            RowLayout {
                id: row_left
                spacing: root.commonSpacing
                // implicitWidth: childrenRect.implicitWidth
                // implicitHeight: childrenRect.implicitHeight
                x: root.commonSpacing
                y: 3
                Rectangle {
                    id: rect1
                    color: "black"
                    implicitWidth: root.commonWidth
                    implicitHeight: root.commonHeight
                    topLeftRadius: 8
                    bottomLeftRadius: 8
                    border.color: "plum"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (sysMenuLoader.item && sysMenuLoader.item.opened) {
                                sysMenuLoader.active = false
                            } else {
                                sysMenuLoader.active = true
                            }
                            console.log("clicked")
                        }
                    }
                    SysMenu{
                        id: sysMenuLoader
                        x: 0
                        y: rect1.height + 10
                    }
                }
                SysSpecs{
                    id: sysSpecsItem
                    spacing: root.commonSpacing
                    implicitHeight: root.commonHeight
                    Component.onCompleted: {
                        console.log(`sysSpecs width: ${sysSpecsItem.width}`)
                        console.log(`sysSpecs height: ${sysSpecsItem.height}`)
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (sysMenuLoader1.item && sysMenuLoader1.item.opened) {
                                sysMenuLoader1.active = false
                            } else {
                                sysMenuLoader1.active = true
                            }
                            console.log("clicked")
                        }
                    }
                    SysMenu{
                        id: sysMenuLoader1
                        x: 0
                        y: sysSpecsItem.height + 10
                    }
                }
                SysTray{
                    commonHeight: root.commonHeight
                    panel: bar_left
                }
            }
        }
    }
}
