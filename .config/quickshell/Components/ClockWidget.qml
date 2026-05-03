import QtQuick
import Quickshell.Widgets as QW

Item {
    id: root
    required property real p_width
    QW.MarginWrapperManager { margin: 1}
    QW.WrapperRectangle {
        color: "#44ff22"
        // color: "#80000000"
        child: Text {
            lineHeight: 0.0
            padding: 3.0
            // directly access the time property from the Time singleton
            text: Time.time
            // text: "[" + p_width + "]"
        }
    }
}
