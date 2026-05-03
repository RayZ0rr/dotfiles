import QtQuick
import QtQuick.Effects
import QtQuick.Shapes

import Quickshell

import qs.Config
import qs.Components

Row {
    id: root
    required property Row barLeft
    required property Row barRight
    required property ShellScreen screen
    readonly property real centerX: (screen.width - this.width)/2
    readonly property real rightX: Math.max(0, (this.centerX + this.width + Config.spacing) - barRight.x)
    readonly property real leftX: Math.max(0, (barLeft.x + barLeft.width + Config.spacing) - this.centerX)
    x: this.centerX - this.rightX + this.leftX
    anchors.verticalCenter: parent.verticalCenter
    spacing: Config.spacing

Item {
    id: placeholderBlock

    readonly property real totalWidth: 200
    readonly property real totalHeight: Config.height

    readonly property real leftDepth: 14
    readonly property real downDepth: 5

    readonly property real faceWidth: placeholderBlock.totalWidth - placeholderBlock.leftDepth
    readonly property real faceHeight: placeholderBlock.totalHeight - placeholderBlock.downDepth

    implicitWidth: placeholderBlock.totalWidth
    implicitHeight: placeholderBlock.totalHeight

    Rectangle {
        id: backSlab
        x: 6
        y: placeholderBlock.downDepth - 1
        width: placeholderBlock.faceWidth
        height: placeholderBlock.faceHeight
        radius: Config.radius
        antialiasing: true
        color: "#000000"
        border.width: 1
        border.color: "#084f3d"
    }

    RectangularShadow {
        anchors.fill: backSlab
        radius: backSlab.radius
        blur: 12
        spread: 1
        offset: Qt.vector2d(-8, 4)
        color: "#44000000"
    }

    Rectangle {
        id: frontFace
        x: placeholderBlock.leftDepth
        y: 0
        width: placeholderBlock.faceWidth
        height: placeholderBlock.faceHeight
        radius: Config.radius
        antialiasing: true

        gradient: Gradient {
            GradientStop { position: 0.0; color: "#1fd58c" }
            GradientStop { position: 0.5; color: "#12b576" }
            GradientStop { position: 1.0; color: "#059669" }
        }

        border.width: 1
        border.color: "#6ef0bf"

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 1
            height: Math.max(2, parent.height * 0.22)
            radius: parent.radius
            color: "transparent"

            gradient: Gradient {
                GradientStop { position: 0.0; color: "#30ffffff" }
                GradientStop { position: 1.0; color: "#00ffffff" }
            }
        }

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 1
            height: Math.max(2, parent.height * 0.14)
            radius: parent.radius
            color: "#22000000"
        }

        Text {
            anchors.centerIn: parent
            text: "Placeholder"
            color: "white"
            font.pixelSize: 14
            font.bold: true
        }
    }
}
}
