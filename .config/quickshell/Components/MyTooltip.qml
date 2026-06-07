import QtQuick
import QtQuick.Controls

import qs.Config

Popup {
    id: tooltip
    property real maxHeight: 0
    property Item rootItem
    property real delay: 1000
    property real timeout: 2000
    property Timer popTimer: Timer {
        interval: tooltip.delay
        running: false
        onTriggered: {
            if (tooltip.opened) {
                tooltip.close()
                this.running = false
            } else {
                this.running = false
                tooltip.open()
            }
        }
    }
    padding: 0
    focus: false
    y: Config.height + rootItem.commonPopupGap
    implicitWidth: tooltip.contentItem.implicitWidth
    implicitHeight: 0
    popupType: Popup.Window
    closePolicy: Popup.NoAutoClose
    transformOrigin: Popup.Top
    onOpened: {
        popTimer.interval = tooltip.timeout
        popTimer.running = true
    }
    onClosed: {
        popTimer.running = false
        popTimer.interval = tooltip.delay
    }

    enter: Transition{
        SequentialAnimation {
            ParallelAnimation {
                NumberAnimation {property: "opacity"; from: 0.0; to: 1.0; duration: 500; easing.type: Easing.OutCubic}
                NumberAnimation {target: tooltip; property: "implicitWidth"; from: 0; to: tooltip.contentItem.implicitWidth; duration: 500; easing.type: Easing.OutBack}
                NumberAnimation {target: tooltip; property: "implicitHeight"; from: 0; to: tooltip.contentItem.implicitHeight; duration: 500; easing.type: Easing.OutBack}
            }
            ScriptAction {script: {
                tooltip.maxHeight = tooltip.height + rootItem.commonPopupGap
                rootItem.tooltipHeight = rootItem.tooltipHeight + tooltip.maxHeight
            }}
        }
    }
    exit: Transition{
        SequentialAnimation {
            ParallelAnimation {
                NumberAnimation {target: tooltip; property: "opacity"; from: 1.0; to: 0.0; duration: 500; easing.type: Easing.OutCubic}
                NumberAnimation {target: tooltip; property: "implicitWidth"; to: 0.0; duration: 500; easing.type: Easing.OutBack}
                NumberAnimation {target: tooltip; property: "implicitHeight"; to: 0.0; duration: 500; easing.type: Easing.OutBack}
            }
            ScriptAction {script: {
                rootItem.tooltipHeight = rootItem.tooltipHeight - tooltip.maxHeight
            }}
        }
    }
}
