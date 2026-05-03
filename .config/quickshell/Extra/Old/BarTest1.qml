import QtQuick
import Quickshell

Scope {
    id: root

    readonly property real commonHeight: 34
    readonly property real commonRadius: 10
    readonly property real commonSpacing: 6
    readonly property real boxWidth: 90
    readonly property real expandedWidth: 800

    property bool leftExpanded: false
    property bool rightExpanded: false

    component DemoBox: Rectangle {
        required property string label
        required property color fillColor

        color: fillColor
        radius: root.commonRadius
        implicitWidth: root.boxWidth
        implicitHeight: root.commonHeight

        Text {
            anchors.centerIn: parent
            text: parent.label
            color: "white"
            font.pixelSize: 14
        }
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar
            required property var modelData
            screen: modelData
            color: "transparent"

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: root.commonHeight + 8

            Item {
                id: content
                anchors.fill: parent

                Row {
                    id: leftGroup
                    anchors.left: parent.left
                    anchors.leftMargin: 8
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: root.commonSpacing
                    z: 2

                    DemoBox {
                        label: "L1"
                        fillColor: "#7c3aed"
                    }

                    DemoBox {
                        label: "L2"
                        fillColor: "#2563eb"
                    }

                    Rectangle {
                        color: "#059669"
                        radius: root.commonRadius
                        width: root.leftExpanded ? root.expandedWidth : root.boxWidth
                        height: root.commonHeight

                        Behavior on width {
                            SmoothedAnimation { velocity: 900 }
                        }

                        Text {
                            anchors.centerIn: parent
                            text: root.leftExpanded ? "L3 expanded" : "L3"
                            color: "white"
                            font.pixelSize: 14
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: root.leftExpanded = !root.leftExpanded
                        }
                    }
                }

                Row {
                    id: centerGroup
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: root.commonSpacing
                    z: 1

                    DemoBox {
                        label: "C1"
                        fillColor: "#dc2626"
                    }

                    DemoBox {
                        label: "C2"
                        fillColor: "#ea580c"
                    }

                    DemoBox {
                        label: "C3"
                        fillColor: "#d97706"
                    }
                }

                Row {
                    id: rightGroup
                    anchors.right: parent.right
                    anchors.rightMargin: 8
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: root.commonSpacing
                    z: 2

                    Rectangle {
                        color: "#0891b2"
                        radius: root.commonRadius
                        width: root.rightExpanded ? root.expandedWidth : root.boxWidth
                        height: root.commonHeight

                        Behavior on width {
                            SmoothedAnimation { velocity: 900 }
                        }

                        Text {
                            anchors.centerIn: parent
                            text: root.rightExpanded ? "R1 expanded" : "R1"
                            color: "white"
                            font.pixelSize: 14
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: root.rightExpanded = !root.rightExpanded
                        }
                    }

                    DemoBox {
                        label: "R2"
                        fillColor: "#4f46e5"
                    }

                    DemoBox {
                        label: "R3"
                        fillColor: "#7c3aed"
                    }
                }
            }
        }
    }
}
