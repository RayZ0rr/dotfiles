import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Shapes
import Quickshell
import Quickshell.Widgets as QW
import Quickshell.Io
import "Components"

Scope {
    id: root
    // no more time object

    // component ShowHideAnimation : NumberAnimation {
    //    easing {
    //       type: Easing.Linear
    //    }
    // }
    component ShowHideAnimation : SmoothedAnimation {
        velocity: 100
    }

    readonly property real common_width: 100
    readonly property real common_spacing: 5
    readonly property real common_height: 40
    readonly property real common_radius: 10

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
                implicitWidth = row_left.implicitWidth
                implicitHeight = row_left.implicitHeight + 5
            }

            RowLayout {
                id: row_left
                spacing: root.common_spacing
                implicitHeight: rect1.implicitHeight
                Rectangle {
                    id: rect1
                    color: "black"
                    anchors.leftMargin: 10
                    implicitWidth: root.common_width
                    implicitHeight: root.common_height
                    topLeftRadius: 8
                    bottomLeftRadius: 8
                    border.color: "plum"
                    border.width: 0
                    Text {
                        id: text_id1
                        anchors.centerIn: parent
                        text: info_cpu.freeMem
                        font.pointSize: 20
                        color: "green"
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (pop_test.visible == false) {
                                pop_test.visible = true
                                console.log(`pop_test:\nwidth: ${pop_test.width}`)
                                console.log(`height: ${pop_test.height}`)
                                console.log(`control_item:\nwidth: ${control_item.width}`)
                                console.log(`height: ${control_item.height}`)
                                print(control_item.childrenRect)
                                console.log(`height: ${control_text.height}`)
                                console.log(`height: ${control.height}`)
                            } else {
                                pop_test.visible = false
                            }
                        }
                    }
                }
                Popup {
                    id: pop_test
                    x: rect1.x
                    y: rect1.height + 10
                    implicitWidth: pop_text.implicitWidth
                    implicitHeight: pop_text.implicitHeight
                    visible: false
                    popupType: Popup.Window
                    ColumnLayout {
                        id: pop_text
                        Text {
                            text: info_cpu.totalMem
                            font.pointSize: 20
                            color: "green"
                        }
                        Text {
                            text: info_cpu.usedMem
                            font.pointSize: 20
                            color: "green"
                        }
                        Item {
                            id: control_item
                            implicitWidth: childrenRect.width
                            implicitHeight: childrenRect.height
                            Text {
                                id: control_text
                                text: info_cpu.freeMem
                                font.pointSize: 20
                                color: "green"
                            }
                            Slider {
                                id: control
                                value: 0.5
                                anchors.left: control_text.right
                                implicitHeight: 50

                                background: Rectangle {
                                    x: control.leftPadding
                                    y: control.topPadding + control.availableHeight / 2 - height / 2
                                    implicitWidth: 200
                                    implicitHeight: 4
                                    width: control.availableWidth
                                    height: implicitHeight
                                    radius: 2
                                    color: "#bdbebf"

                                    Rectangle {
                                        width: control.visualPosition * parent.width
                                        height: parent.height
                                        color: "#21be2b"
                                        radius: 2
                                    }
                                }

                                handle: Rectangle {
                                    x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
                                    y: control.topPadding + control.availableHeight / 2 - height / 2
                                    implicitWidth: 26
                                    implicitHeight: 26
                                    radius: 13
                                    color: control.pressed ? "#f0f0f0" : "#f6f6f6"
                                    border.color: "#bdbebf"
                                }
                            }
                        }
                    }
                }
                Shape {
                    width: 200
                    height: 50
                    ShapePath {
                        strokeColor: "green"
                        fillColor: "transparent"
                        strokeWidth: 10
                        capStyle: ShapePath.RoundCap

                        PathAngleArc {
                            id: outer_circle
                            radiusX: 15
                            radiusY: 15
                            centerX: 20
                            centerY: 20
                            startAngle: 0
                            sweepAngle: ((info_cpu.usedMem/info_cpu.totalMem) * 360)
                        }
                    }
                    ShapePath {
                        fillColor: "green"
                        // strokeColor: "green"
                        strokeWidth: 0
                        capStyle: ShapePath.RoundCap

                        PathAngleArc {
                            id: inner_circle
                            radiusX: 6
                            radiusY: 6
                            centerX: 20
                            centerY: 20
                            startAngle: 0
                            sweepAngle: 360
                        }
                    }
                }

                Loader {
                    id: faderbox
                    active: false
                    visible: active
                    property real prev_width: 0
                    Layout.preferredWidth: 0
                    Layout.fillHeight: true
                    clip: true
                    source: "Components/SysTray.qml"
                    onLoaded: {
                        faderbox.prev_width = faderbox.item.child_size
                        anim_show.start()
                    }
                    SequentialAnimation {
                        id: anim_hide
                        ShowHideAnimation {target: faderbox; property: "Layout.preferredWidth"; to: 0}
                        PropertyAction {target: faderbox; property: "active"; value: false}
                        PropertyAction {target: bar_left; property: "implicitWidth"; value: (bar_left.implicitWidth - faderbox.prev_width)}
                    }
                    SequentialAnimation {
                        id: anim_show
                        PropertyAction {target: bar_left; property: "implicitWidth"; value: (bar_left.implicitWidth + faderbox.prev_width)}
                        SmoothedAnimation {target: faderbox; property: "Layout.preferredWidth"; to: faderbox.prev_width}
                    }
                }


                Rectangle {
                    id: rect2
                    color: "blue"
                    Layout.preferredWidth: 100
                    Layout.fillHeight: true
                    Behavior on Layout.preferredWidth {
                        ShowHideAnimation {}
                    }
                    // Behavior on Layout.preferredWidth { SmoothedAnimation { easing.type: Easing.Linear; velocity: 500 } }

                    // Behavior on x {
                    //     ShowHideAnimation {}
                    // }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (faderbox.active == false) {
                                faderbox.active = true
                            } else {
                                anim_hide.start()
                            }
                        }
                    }
                }

                Rectangle {
                    id: rect3
                    color: "teal"
                    Layout.preferredWidth: 100
                    Layout.fillHeight: true
                    Behavior on x {
                        ShowHideAnimation {}
                    }
                    Text {
                        text: row_left.implicitWidth + ", " + bar_left.implicitWidth + ", " + rect2.x
                        anchors.centerIn: rect3
                    }
                    // Text {
                    //     id: text_id
                    //     text: rect2.x + ", " + rect2_1.x
                    //     anchors.centerIn: rect3
                    // }
                }
                SmoothedAnimation {
                    id: destroyObj
                    target: faderbox
                    properties: "Layout.preferredWidth"
                    to: 0
                    velocity: 100
                    onFinished: {
                        faderbox.active = false
                        bar_left.implicitWidth = bar_left.implicitWidth - faderbox.prev_width
                    }
                }
            }
        }
    }

    Rectangle {
        id: info_cpu

        property real totalMem
        property real usedMem
        property real freeMem

        Process {
            id: cpuProc
            command: ["sh", "-c", "free -m | grep Mem | awk '{printf \"%s\\n%s\\n%s\", $2, $3, $4}'"]
            running: true
            stdout: StdioCollector {
                onStreamFinished: {
                    const [total, used, free] = text.split("\n");
                    info_cpu.totalMem = total;
                    info_cpu.usedMem = used;
                    info_cpu.freeMem = free;
                }
            }
        }

        Timer {
            running: true
            repeat: true
            interval: 500
            onTriggered: cpuProc.running = true
        }
    }

}
