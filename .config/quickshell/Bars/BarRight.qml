import QtQuick

import qs.Config
import qs.Components

Row {
    id: root
    anchors.right: parent.right
    anchors.rightMargin: Config.barMarginX
    anchors.verticalCenter: parent.verticalCenter
    spacing: Config.spacing

    Network{}
    DateTime{}
    SysSpecs{
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (sysMenu.item && sysMenu.item.opened) {
                    sysMenu.active = false
                } else {
                    sysMenu.active = true
                }
            }
        }
        SysMenu{
            id: sysMenu
            x: 0
            y: parent.height + 10
        }
    }
    SysTray{
        commonHeight: Config.height
        commonSpacing: Config.spacing
        commonBg: Config.colorBg
    }
}
