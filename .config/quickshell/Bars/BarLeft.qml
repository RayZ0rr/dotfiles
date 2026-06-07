import QtQuick

import qs.Config
import qs.Components

Row {
    id: root
    anchors.left: parent.left
    anchors.leftMargin: Config.barMarginX
    anchors.verticalCenter: parent.verticalCenter
    spacing: Config.spacing

    Workspace{}
}
