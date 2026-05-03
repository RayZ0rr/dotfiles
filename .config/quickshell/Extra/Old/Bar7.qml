import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets as QW
import "Components"

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

        PanelWindow {
            id: bar_left
            color: "transparent"
            required property var modelData

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
                spacing: 5
                implicitHeight: 50
                // anchors.fill: parent
                // anchors.verticalCenter: parent
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
                    implicitHeight: row_left.implicitHeight
                    // Layout.maximumHeight: 50
                    Text {
                        id: text_id1
                        text: row_left.implicitWidth + ", " + bar_left.implicitWidth + ", " + rect2.x
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
                    sourceComponent: SysTray{}
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
                                bar_left.implicitWidth = bar_left.implicitWidth + 100
                            } else {
                                // faderbox.Layout.preferredWidth = 0
                                // bar_left.implicitWidth = bar_left.implicitWidth - 100
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
                        bar_left.implicitWidth = bar_left.implicitWidth - 100
                    }
                }
                SmoothedAnimation {
                    id: increaseWidth
                    target: bar_left
                    properties: "implicitWidth"
                    to: bar_left.implicitWidth + 100
                    velocity: 1000
                }
                SmoothedAnimation {
                    id: decreaseWidth
                    target: bar_left
                    properties: "implicitWidth"
                    to: bar_left.implicitWidth - 100
                    velocity: 1000
                }
            }
        }
    }
}
