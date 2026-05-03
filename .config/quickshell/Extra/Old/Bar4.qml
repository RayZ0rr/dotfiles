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
        velocity: 500
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

            RowLayout {
                id: row_layout
                spacing: 5
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
                    Layout.maximumHeight: 50
                    Text {
                        id: text_id1
                        text: row_layout.implicitWidth + ", " + toplevel.implicitWidth
                        anchors.centerIn: rect1
                    }
                }
                Rectangle {
                    id: rect2
                    color: "transparent"
                    Layout.preferredWidth: rect2_1.width
                    Layout.preferredHeight: rect2_1.height
                    Layout.maximumHeight: 50
                    Behavior on Layout.preferredWidth {
                        ShowHideAnimation {}
                    }
                    // Behavior on Layout.preferredWidth { SmoothedAnimation { easing.type: Easing.Linear; velocity: 500 } }

                    Rectangle {
                        id: rect2_1
                        width: 100
                        height: 50
                        color: "blue"
                        Behavior on x {
                            ShowHideAnimation {}
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if (faderbox.active == false) {
                                    faderbox.active = true
                                } else {
                                    // animate_col_hide.start();
                                    rect2_1.x = faderbox.x
                                    animate_pos_hide1.start();
                                    // animate_pos_hide2.start();
                                    // rect2.Layout.preferredWidth = rect2_1.width
                                    // toplevel.implicitWidth = toplevel.implicitWidth - faderbox.width
                                    faderbox.active = false
                                }
                            }
                        }
                    }

                    Loader {
                        id: faderbox
                        active: false
                        opacity: 0.0
                        sourceComponent: Component {
                            Rectangle {
                                id: fader
                                color: "red"
                                width: 100
                                height: 50
                                // Behavior on x { SmoothedAnimation { easing.type: Easing.Linear; velocity: 200 } }
                            }

                        }
                        onLoaded: {
                            faderbox.x = rect2_1.x
                            // rect2.Layout.preferredWidth = rect2.Layout.preferredWidth * 2
                            toplevel.implicitWidth = toplevel.implicitWidth + faderbox.width
                            rect2.Layout.preferredWidth = rect2_1.width + faderbox.width
                            rect2_1.x = faderbox.x + faderbox.width
                            // animate_pos_show.start();
                            // animate_col_show.start();
                        }
                    }

                }
                Rectangle {
                    id: rect3
                    color: "teal"
                    Layout.preferredWidth: 100
                    Layout.preferredHeight: 50
                    Behavior on x {
                        ShowHideAnimation {}
                    }
                    // Text {
                    //     id: text_id
                    //     text: rect2.x + ", " + rect2_1.x
                    //     anchors.centerIn: rect3
                    // }
                }
                PropertyAnimation {
                    id: animate_col_show;
                    target: faderbox;
                    properties: "opacity";
                    to: 1.0;
                    duration: 1000
                    // onFinished: {
                    //     text_id.text = faderbox.item.x + ", " + rect2.x + ", " + rect2_1.x
                    // }
                }
                PropertyAnimation {
                    id: animate_col_hide;
                    target: faderbox;
                    properties: "opacity";
                    to: 0.0;
                    duration: 1000
                    onFinished: {
                        // text_id.text = faderbox.item.x + ", " + rect2.x + ", " + rect2_1.x
                        faderbox.active = false
                        // rect2.Layout.preferredWidth = rect2.Layout.preferredWidth / 2
                    }
                }
                SmoothedAnimation {
                    id: animate_pos_show
                    target: rect2_1
                    properties: "x"
                    from: rect2.x
                    to: faderbox.x + faderbox.width
                    velocity: 100
                }
                SmoothedAnimation {
                    id: animate_pos_hide1
                    target: rect2
                    properties: "Layout.preferredWidth"
                    to: rect2_1.width
                    velocity: 500
                    onFinished: {
                        toplevel.implicitWidth = toplevel.implicitWidth - faderbox.width
                    }
                }
                SmoothedAnimation {
                    id: animate_pos_hide2
                    target: toplevel
                    properties: "implicitWidth"
                    to: toplevel.implicitWidth - faderbox.width
                    velocity: 500
                }
            }
            Component.onCompleted: implicitWidth = row_layout.implicitWidth
        }
    }
}
