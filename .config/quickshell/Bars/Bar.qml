import QtQuick

import Quickshell

import qs.Config
import qs.Components

Scope {
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
            implicitHeight: Config.height + Config.barMarginY

            Item {
                id: root
                // anchors.fill: parent
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                // anchors.horizontalCenter: parent.horizontalCenter

                BarLeft {
                    id: barLeft
                }
                BarRight {
                    id: barRight
                }
                BarCenter {
                    barLeft: barLeft
                    barRight: barRight
                    screen: bar.screen
                }

            }
        }
    }
}
