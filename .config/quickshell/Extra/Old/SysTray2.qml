import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets as QW
import Quickshell.Services.SystemTray

Rectangle {
    id: root_sys_tray

    component ShowHideAnimation : SmoothedAnimation {
        velocity: 100
    }
    readonly property real common_icon_size: 30
    readonly property real sys_tray_item_size: 50
    property int n_sys_tray_items: SystemTray.items.values.length
    readonly property real child_size: sys_tray.implicitWidth
    property real child_width: 0
    radius: 10
    color: "transparent"
    border.color: "green"
    border.width: 3
    Behavior on width {
        ShowHideAnimation {}
    }
    clip: true
    implicitHeight: 10
    // implicitWidth: sys_tray.implicitWidth + 1
    // implicitWidth: 100
    width: 0
    // Layout.maximumWidth: 0
    Component.onCompleted: {
        width = 0
    }

    Row {
        id: sys_tray
        // anchors.centerIn: parent
        anchors.fill: root_sys_tray
        width: parent.child_width
        Layout.maximumWidth: 0
        Repeater {
            model: SystemTray.items.values
            // width: 0

            Rectangle {
                id: sys_tray_item
                required property SystemTrayItem modelData
                property var app: sys_tray_item.modelData
                implicitWidth: root_sys_tray.sys_tray_item_size
                implicitHeight: root_sys_tray.implicitHeight
                // Layout.preferredWidth: root_sys_tray.sys_tray_item_size
                // Layout.preferredHeight: root_sys_tray.implicitHeight
                color: "transparent"

                QW.IconImage {
                    anchors.centerIn: sys_tray_item
                    implicitSize: root_sys_tray.common_icon_size
                    source: sys_tray_item.app.icon
                }

                QsMenuAnchor {
                    id: menu_anchor
                    menu: sys_tray_item.app.menu
                    anchor.window: sys_tray_item.QsWindow.window
                    anchor.onAnchoring: {
                        const window = sys_tray_item.QsWindow.window;
                        const widgetRect = window.contentItem.mapFromItem(sys_tray_item, 0, sys_tray_item.height, sys_tray_item.width, sys_tray_item.height);

                        menu_anchor.anchor.rect = widgetRect;
                    }
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: sys_tray_item
                    hoverEnabled: true
                    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                    onClicked: function (mouse) {
                        if (sys_tray_item.app.onlyMenu || mouse.button === Qt.RightButton)
                        menu_anchor.open();
                        else if (mouse.button === Qt.LeftButton)
                        sys_tray_item.app.activate();
                        else
                        sys_tray_item.app.secondaryActivate();
                    }
                    onHoveredChanged: {
                        if (sys_tray_item.app.tooltipTitle != "")
                        tooltip.active = !tooltip.active;
                    }
                }

                Loader {
                    id: tooltip
                    y: sys_tray_item.y + sys_tray_item.height
                    // anchors.topMargin: 50
                    // anchors.top: sys_tray_item.bottom
                    // anchors.left: sys_tray_item.right
                    active: false
                    sourceComponent: Rectangle {
                        visible: tooltip.active
                        border.color: "grey"
                        color: "black"
                        radius: 5
                        implicitHeight: 100
                        implicitWidth: 100
                        Text {
                            anchors.fill: parent
                            text: sys_tray_item.app.tooltipTitle
                            font.pixelSize: 10
                            color: "white"
                        }
                    }
                }
            }
        }
    }
}
