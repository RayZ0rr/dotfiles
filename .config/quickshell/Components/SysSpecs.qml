import QtQuick
import QtQuick.Shapes

import Quickshell
import Quickshell.Io

import qs.Config

Item {
    id: root
    property real marginSizeX: 30
    property real marginSizeY: 6
    property real strokeWidth: 4
    readonly property real usableHeight: Math.max(0, Config.height - marginSizeY)
    readonly property real radiusY: Math.max(0, (usableHeight - strokeWidth) / 2)
    property real radiusX: this.radiusY
    property real radiusInnerOffset: this.radiusX * 0.6
    property real ringWidth: 2*this.radiusX + this.strokeWidth
    property real ringHeight: 2*this.radiusY + this.strokeWidth
    property real centerX: (this.ringWidth) / 2
    property real centerY: (this.ringHeight) / 2
    implicitWidth: sysSpecs.implicitWidth
    implicitHeight: Config.height
    Component.onCompleted: root.refresh()

    function refresh() {
        Config.startIfIdle(procCpu)
        Config.startIfIdle(procBat)
    }

    Row {
        id: sysSpecs
        spacing: Config.spacing
        Rectangle{
            id: cpuSpecsBox
            color: Config.colorBg
            implicitWidth: cpuSpecs.implicitWidth + root.marginSizeX
            implicitHeight: Config.height
            radius: Config.radius
            Shape {
                id: cpuSpecs
                anchors.centerIn: cpuSpecsBox
                implicitWidth: root.ringWidth
                implicitHeight: root.ringHeight
                preferredRendererType: Shape.CurveRenderer
                property real centerX: root.centerX
                property real centerY: root.centerY
                property color color: "#e0b089"
                ShapePath {
                    strokeColor: cpuSpecs.color
                    fillColor: "transparent"
                    strokeWidth: root.strokeWidth
                    capStyle: ShapePath.RoundCap

                    PathAngleArc {
                        radiusX: root.radiusX
                        radiusY: root.radiusY
                        centerX: cpuSpecs.centerX
                        centerY: cpuSpecs.centerY
                        startAngle: 0
                        sweepAngle: ((info_cpu.usedMem/info_cpu.totalMem) * 360)
                    }
                }
                ShapePath {
                    strokeColor: "gray"
                    fillColor: "transparent"
                    strokeWidth: root.strokeWidth

                    PathAngleArc {
                        radiusX: root.radiusX
                        radiusY: root.radiusY
                        centerX: cpuSpecs.centerX
                        centerY: cpuSpecs.centerY
                        startAngle: ((info_cpu.usedMem/info_cpu.totalMem) * 360)
                        sweepAngle: 360 - ((info_cpu.usedMem/info_cpu.totalMem) * 360)
                    }
                }
                ShapePath {
                    fillColor: cpuSpecs.color
                    strokeWidth: 0
                    capStyle: ShapePath.RoundCap

                    PathAngleArc {
                        radiusX: root.radiusX - root.radiusInnerOffset
                        radiusY: root.radiusY - root.radiusInnerOffset
                        centerX: cpuSpecs.centerX
                        centerY: cpuSpecs.centerY
                        startAngle: 0
                        sweepAngle: 360
                    }
                }
            }
        }
        Rectangle{
            id: batSpecsBox
            color: Config.colorBg
            implicitWidth: batSpecs.implicitWidth + root.marginSizeX
            implicitHeight: Config.height
            radius: Config.radius
            Shape {
                id: batSpecs
                anchors.centerIn: batSpecsBox
                implicitWidth: root.ringWidth
                implicitHeight: root.ringHeight
                preferredRendererType: Shape.CurveRenderer
                property real centerX: root.centerX
                property real centerY: root.centerY
                property color color: "#afbea2"
                ShapePath {
                    strokeColor: batSpecs.color
                    fillColor: "transparent"
                    strokeWidth: root.strokeWidth
                    capStyle: ShapePath.RoundCap

                    PathAngleArc {
                        radiusX: root.radiusX
                        radiusY: root.radiusY
                        centerX: batSpecs.centerX
                        centerY: batSpecs.centerY
                        startAngle: 0
                        sweepAngle: ((info_bat.charge/100) * 360)
                    }
                }
                ShapePath {
                    strokeColor: "gray"
                    fillColor: "transparent"
                    strokeWidth: root.strokeWidth

                    PathAngleArc {
                        radiusX: root.radiusX
                        radiusY: root.radiusY
                        centerX: batSpecs.centerX
                        centerY: batSpecs.centerY
                        startAngle: ((info_bat.charge/100) * 360)
                        sweepAngle: 360 - ((info_bat.charge/100) * 360)
                    }
                }
                ShapePath {
                    fillColor: batSpecs.color
                    strokeWidth: 0
                    capStyle: ShapePath.RoundCap

                    PathAngleArc {
                        radiusX: root.radiusX - root.radiusInnerOffset
                        radiusY: root.radiusY - root.radiusInnerOffset
                        centerX: batSpecs.centerX
                        centerY: batSpecs.centerY
                        startAngle: 0
                        sweepAngle: 360
                    }
                }
            }
        }
        QtObject {
            id: info_cpu
            property real totalMem: 0
            property real usedMem: 0
            property real freeMem: 0
        }

        Process {
            id: procCpu
            command: ["sh", "-c", "free -m | grep Mem | awk '{printf \"%s\\n%s\\n%s\", $2, $3, $4}'"]
            running: true

            stdout: StdioCollector {
                onStreamFinished: {
                    const lines = text.trim().split("\n")
                    info_cpu.totalMem = Number(lines[0] || 0)
                    info_cpu.usedMem = Number(lines[1] || 0)
                    info_cpu.freeMem = Number(lines[2] || 0)
                }
            }
        }

        Timer {
            running: true
            repeat: true
            interval: 1000 * 5
            onTriggered: procCpu.running = true
        }

        QtObject {
            id: info_bat
            property real charge: 0
        }

        Process {
            id: procBat
            command: ["sh", "-c", Quickshell.shellPath("Scripts/battery.sh") + " get"]
            running: true

            stdout: StdioCollector {
                onStreamFinished: {
                    info_bat.charge = Number(text.trim() || 0)
                }
            }
        }

        Timer {
            running: true
            repeat: true
            interval: 1000 * 60
            onTriggered: procBat.running = true
        }
    }
}
