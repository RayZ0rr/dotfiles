import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets as QW

Scope {
    // no more time object

    Variants {
        model: [1]

        // FloatingWindow {
        PanelWindow {
            id: toplevel
            required property var modelData

            anchors {
                bottom: true
                left: true
                right: true
            }
            // QW.MarginWrapperManager {
            //     margin: 5
            //     child: clock
            //     wrapper: panel_window
            // }
            implicitWidth: 100
            implicitHeight: 50

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

            Rectangle {
                id: flashingblob
                implicitWidth: 75; implicitHeight: 75
                color: "blue"
                opacity: 1.0

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        animateColor.start()
                        animateOpacity.start()
                        // animateColShow.start()
                        // animatePosShow.start()
                        if (faderbox.status == Loader.Ready) {
                            animate_col_hide.start();
                            animate_pos_hide.start();
                        }
                        if (faderbox.active == false) {
                            faderbox.active = true
                        }
                    }
                }


                NumberAnimation {
                    id: animateOpacity
                    target: flashingblob
                    properties: "opacity"
                    from: 0.99
                    to: 1.0
                    loops: Animation.Infinite
                    easing {type: Easing.OutBack; overshoot: 500}
                }
            }
            // function (text: string):  {
            // }
            Text {
                id: text_id
                text: "Not loaded"
                anchors.centerIn: flashingblob
            }
            PropertyAnimation {id: animateColor; target: flashingblob; properties: "color"; to: "green"; duration: 100}
            PropertyAnimation {
                id: animate_col_show;
                target: faderbox;
                properties: "opa";
                to: 1.0;
                duration: 1000
                onFinished: {
                    text_id.text = faderbox.val + ", " + faderbox.opa
                }
            }
            PropertyAnimation {
                id: animate_col_hide;
                target: faderbox;
                properties: "opa";
                to: 0.0;
                duration: 1000
                onFinished: {
                    text_id.text = faderbox.val + ", " + faderbox.opa
                    faderbox.active = false
                }
            }
            NumberAnimation {
                id: animate_pos_show
                target: faderbox
                properties: "val"
                from: flashingblob.x
                to: flashingblob.x + flashingblob.width
            }
            SmoothedAnimation {
                id: animate_pos_hide
                target: faderbox
                properties: "val"
                from: faderbox.x
                to: flashingblob.x
            }

            // Rectangle {
            //     id: fader
            //     implicitWidth: 75; implicitHeight: 75
            //     color: "blue"
            //     opacity: 0.0
            //     x: flashingblob.x

            // }


            Loader {
                id: faderbox
                active: false
                property int val: flashingblob.x
                property real opa: 0.0
                sourceComponent: Component {
                    Rectangle {
                        id: fader
                        implicitWidth: 75; implicitHeight: 75
                        color: "red"
                        opacity: faderbox.opa
                        x: faderbox.val
                        // Behavior on x { SmoothedAnimation { easing.type: Easing.Linear; velocity: 200 } }
                    }

                }
                onLoaded: {
                    animate_col_show.start();
                    animate_pos_show.start();
                }
            }

            // Rectangle {
            //     width: 800; height: 600
            //     color: "blue"

            //     Rectangle {
            //         width: 60; height: 60
            //         x: rect1.x - 5; y: rect1.y - 5
            //         color: "green"

            //         Behavior on x { SmoothedAnimation { velocity: 200 } }
            //         Behavior on y { SmoothedAnimation { velocity: 200 } }
            //     }

            //     Rectangle {
            //         id: rect1
            //         width: 50; height: 50
            //         color: "red"
            //     }

            //     focus: true
            //     Keys.onRightPressed: rect1.x = rect1.x + 100
            //     Keys.onLeftPressed: rect1.x = rect1.x - 100
            //     Keys.onUpPressed: rect1.y = rect1.y - 100
            //     Keys.onDownPressed: rect1.y = rect1.y + 100
            // }

        }
    }
}
