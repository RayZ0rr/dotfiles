import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets as QW
import Quickshell.Services.SystemTray

Item {
    id: root
    required property QtObject panel
    readonly property real marginSizeX: 30
    readonly property real marginSizeY: 10
    readonly property real iconSize: 25
    property real commonSpacing: 0
    property real commonHeight: 0
    property real commonRadius: 10
    property color commonBg: "black"
    implicitWidth: sysTrayModule.implicitWidth
    height: this.commonHeight
    component ShowHideAnimation : SmoothedAnimation {
        velocity: 100
    }
    Row {
        id: sysTrayModule
        anchors.centerIn: root
        spacing: root.commonSpacing
        // anchors.verticalCenter: root.verticalCenter

        Rectangle{
            id: sysTrayLoaderBox
            property real item_width: 0
            property real root_width_extend: 0
            property int complete: 0
            color: "transparent"
            implicitWidth: 0
            height: root.height
            radius: root.commonRadius
            clip: true
            visible: sysTrayLoader.active
            Loader {
                id: sysTrayLoader
                anchors.fill: sysTrayLoaderBox
                active: false
                sourceComponent: sysTrayComp
                onLoaded: {
                    sysTrayLoaderBox.item_width = sysTrayLoader.item.implicitWidth
                    sysTrayLoaderBox.root_width_extend = root.commonSpacing + sysTrayLoaderBox.item_width
                    anim_show.start()
                }
                SequentialAnimation {
                    id: anim_hide
                    PropertyAction {target: sysTrayLoaderBox; property: "complete"; value: 1}
                    ShowHideAnimation {target: sysTrayLoaderBox; property: "implicitWidth"; to: sysTrayLoaderBox.implicitWidth - sysTrayLoaderBox.item_width}
                    PropertyAction {target: sysTrayLoader; property: "active"; value: false}
                    PropertyAction {target: sysTrayLoaderBox; property: "complete"; value: 0}
                    PropertyAction {target: panel; property: "implicitWidth"; value: (panel.implicitWidth - sysTrayLoaderBox.root_width_extend)}
                }
                SequentialAnimation {
                    id: anim_show
                    PropertyAction {target: panel; property: "implicitWidth"; value: (panel.implicitWidth + sysTrayLoaderBox.root_width_extend)}
                    PropertyAction {target: sysTrayLoaderBox; property: "complete"; value: 1}
                    ShowHideAnimation {target: sysTrayLoaderBox; property: "implicitWidth"; to: sysTrayLoaderBox.implicitWidth + sysTrayLoaderBox.item_width}
                    PropertyAction {target: sysTrayLoaderBox; property: "complete"; value: 2}
                }
            }
        }
        Rectangle {
            id: sysTrayToggle
            color: root.commonBg
            implicitWidth: sysTrayToggleText.width + root.marginSizeX
            height: root.height
            radius: root.commonRadius
            Text {
                id: sysTrayToggleText
                anchors.centerIn: parent
                text: sysTrayLoader.active ? "◁ " : "▷ "
                color: {
                    let c = "#e06c75"
                    switch(sysTrayLoaderBox.complete) {
                    case 2:
                        c = "green"
                        break
                    case 1:
                        c = "yellow"
                        break
                    }
                    return c
                }
                font.pixelSize: parent.height - root.marginSizeY
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (sysTrayLoader.active == false) {
                        sysTrayLoader.active = true
                    } else {
                        anim_hide.start()
                    }
                }
            }
        }

    }
    Component{
        id: sysTrayComp
        Rectangle {
            id: sysTrayBox
            readonly property real itemMarginSizeX: 10
            readonly property real itemMarginSizeY: 5
            readonly property real itemSpacing: 5
            implicitWidth: sysTray.implicitWidth + root.marginSizeX
            height: root.height
            clip: false
            radius: root.commonRadius
            color: "#9F8383"
            Row {
                id: sysTray
                anchors.centerIn: sysTrayBox
                spacing: sysTrayBox.itemSpacing
                Repeater {
                    model: SystemTray.items

                    Rectangle {
                        id: sysTrayItem
                        required property SystemTrayItem modelData
                        implicitWidth: sysTrayItemIcon.implicitWidth + sysTrayBox.itemMarginSizeX
                        height: sysTrayBox.height
                        color: sysTrayBox.color

                        QW.IconImage {
                            id: sysTrayItemIcon
                            anchors.centerIn: sysTrayItem
                            // implicitWidth: this.implicitHeight
                            implicitWidth: root.iconSize
                            height: sysTrayItem.height - sysTrayBox.itemMarginSizeY
                            source: {
                                console.log(sysTrayItem.modelData.icon)
                                sysTrayItem.modelData.icon
                            }
                        }

                        QsMenuAnchor {
                            id: menuAnchor
                            menu: sysTrayItem.modelData.menu
                            anchor.window: sysTrayItem.QsWindow.window
                            anchor.onAnchoring: {
                                const window = sysTrayItem.QsWindow.window;
                                const widgetRect = window.contentItem.mapFromItem(sysTrayItem, 0, sysTrayItem.height, sysTrayItem.width, sysTrayItem.height);
                                menuAnchor.anchor.rect = widgetRect;
                            }
                            onClosed: {
                                console.log("id:", sysTrayItem.modelData.id)
                                console.log("has mouse:", sysTrayItemBox.containsMouse)
                                // menuAnchor.open();
                            }
                        }
                        MouseArea {
                            id: mouseArea
                            anchors.fill: sysTrayItem
                            hoverEnabled: true
                            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                            onClicked: function (mouse) {
                                if (sysTrayItem.modelData.onlyMenu || mouse.button == Qt.RightButton) {
                                    menuAnchor.open();
                                    // sysTrayItem.modelData.display(menuAnchor.QsWindow.window, sysTrayItem.width, sysTrayItem.height);
                                    // sysTrayItem.modelData.display(sysTrayItem.QsWindow.window, 100, 100)
                                }
                                else if (mouse.button == Qt.LeftButton){
                                    sysTrayItem.modelData.activate();
                                }
                                else {
                                    sysTrayItem.modelData.secondaryActivate();
                                }
                                mouse.accepted = true
                            }
                            // onHoveredChanged: {
                            //     if (sysTrayItem.modelData.tooltipTitle != "")
                            //     tooltip.active = !tooltip.active;
                            //     menuPopup.visible = !menuPopup.visible;
                            // }
                        }
                        // Popup {
                        //     id: menuPopup
                        //     visible: false
                        //     focus: visible
                        //     popupType: Popup.Window
                        //     padding: 8
                        //     closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
                        //     y: sysTrayItem.y + sysTrayItem.height

                        //     background: Rectangle {
                        //         color: "#111111"
                        //         radius: 12
                        //         border.color: "#333333"
                        //         border.width: 1
                        //     }

                        //     contentItem: Rectangle {
                        //         implicitWidth: 320
                        //         implicitHeight: 40
                        //         radius: 8
                        //         color: "#1b1fff"
                        //         border.color: "#2d2d2d"
                        //         border.width: 1
                        //         Text {
                        //             anchors.fill: parent
                        //             text: sysTrayItem.modelData.tooltipTitle
                        //             font.pixelSize: 10
                        //             color: "white"
                        //         }
                        //     }
                        // }

                        Loader {
                            id: tooltip
                            y: sysTrayItem.y + sysTrayItem.height
                            active: false
                            sourceComponent: Rectangle {
                                visible: tooltip.active
                                border.color: "grey"
                                color: "black"
                                radius: 5
                                implicitWidth: 100
                                implicitHeight: 100
                                Text {
                                    anchors.fill: parent
                                    text: sysTrayItem.modelData.tooltipTitle
                                    font.pixelSize: 10
                                    color: "white"
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
