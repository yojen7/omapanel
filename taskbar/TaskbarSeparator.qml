import QtQuick
import qs.Commons
import qs.Ui

Item {
    required property var taskbar

    width: Style.space(9)
    height: taskbar ? taskbar.panelHeight : 24

    Rectangle {
        width: Math.max(1, Style.spaceReal(1))
        height: Math.min(parent.height * 0.42, Style.space(16))
        anchors.centerIn: parent
        color: taskbar && taskbar.bar ? taskbar.bar.barForeground : Color.foreground
        opacity: 0.3
        radius: width / 2
    }

}
