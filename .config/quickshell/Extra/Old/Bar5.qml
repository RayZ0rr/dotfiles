import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets as QW

Scope {
    // no more time object

    // component ShowHideAnimation : NumberAnimation {
    //    easing {
    //       type: Easing.Linear
    //    }
    // }
    component ShowHideAnimation : SmoothedAnimation {
        velocity: 100
    }

    Variants {
        model: [1]

        // FloatingWindow {
        PanelWindow {
            id: toplevel
            color: "transparent"
            required property var modelData

            anchors {
                top: true
                left: true
            }
            // margins {
            //     top: 1
            // }
            // exclusionMode: ExclusionMode.Normal
            // QW.MarginWrapperManager {
            //     margin: 5
            //     child: clock
            //     wrapper: panel_window
            // }
            // implicitHeight: row_layout.implicitHeight + 10
            implicitHeight: 60
            // implicitWidth: row_layout.implicitWidth
            // Behavior on implicitWidth {
            //     ShowHideAnimation {}
            // }

            // ClockWidget {
            //     id: clock
            //     anchors.centerIn: parent
            //     p_width: panel_window.implicitWidth


            //     // no more time binding
            // }

            // PopupWindow {
            //     anchor.window: toplevel
            //     anchor.rect.x: parentWindow.width / 2 - width / 2
            //     anchor.rect.y: parentWindow.height
            //     implicitWidth: 100
            //     implicitHeight: 100
            //     visible: true
            // }
            // Behavior on implicitWidth {
            //     ShowHideAnimation {}
            // }

            RowLayout {
                id: row_layout
                spacing: 5
                // anchors.fill: parent
                anchors.verticalCenter: parent
                Behavior on implicitWidth {
                    ShowHideAnimation {}
                }
                Behavior on width {
                    ShowHideAnimation {}
                }
                Behavior on x {
                    ShowHideAnimation {}
                }
                Rectangle {
                    id: rect1
                    color: "plum"
                    Layout.preferredWidth: 100
                    Layout.preferredHeight: 50
                    Layout.fillHeight: true
                    // Layout.maximumHeight: 50
                    Text {
                        id: text_id1
                        text: row_layout.implicitWidth + ", " + toplevel.implicitWidth + ", " + rect2.x
                        anchors.centerIn: rect1
                    }
                }

                Loader {
                    id: faderbox
                    active: false
                    visible: active
                    Layout.preferredWidth: 0
                    Layout.minimumWidth: 0
                    Layout.fillHeight: true
                    // Behavior on Layout.preferredWidth {
                    //     ShowHideAnimation {}
                    // }
                    sourceComponent: Component {
                        Rectangle {
                            id: fader
                            color: "red"
                            // Behavior on x { SmoothedAnimation { easing.type: Easing.Linear; velocity: 200 } }
                        }

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
                                // faderbox.Layout.preferredWidth = 100
                                // increaseWidth.start()
                                createObj.start()
                                toplevel.implicitWidth = toplevel.implicitWidth + 100
                            } else {
                                // faderbox.Layout.preferredWidth = 0
                                // toplevel.implicitWidth = toplevel.implicitWidth - 100
                                destroyObj.start()
                                // decreaseWidth.start()
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
                    // Text {
                    //     id: text_id
                    //     text: rect2.x + ", " + rect2_1.x
                    //     anchors.centerIn: rect3
                    // }
                }
                SmoothedAnimation {
                    id: createObj
                    target: faderbox
                    properties: "Layout.preferredWidth"
                    to: 100
                    velocity: 100
                }
                SmoothedAnimation {
                    id: destroyObj
                    target: faderbox
                    properties: "Layout.preferredWidth"
                    to: 0
                    velocity: 100
                    onFinished: {
                        faderbox.active = false
                        toplevel.implicitWidth = toplevel.implicitWidth - 100
                    }
                }
                SmoothedAnimation {
                    id: increaseWidth
                    target: toplevel
                    properties: "implicitWidth"
                    to: toplevel.implicitWidth + 100
                    velocity: 1000
                }
                SmoothedAnimation {
                    id: decreaseWidth
                    target: toplevel
                    properties: "implicitWidth"
                    to: toplevel.implicitWidth - 100
                    velocity: 1000
                }
            }
            Component.onCompleted: implicitWidth = row_layout.implicitWidth
        }
    }
}
