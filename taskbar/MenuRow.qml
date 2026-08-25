import QtQuick
import qs.Commons
import qs.Ui

Item {
    id: menuRow

    required property var taskbar
    property string text: ""
    property string iconText: ""
    property bool destructive: false

    signal triggered()

    width: parent ? parent.width : Style.space(280)
    implicitHeight: Style.space(32)
    opacity: enabled ? 1 : 0.4

    Rectangle {
        anchors.fill: parent
        radius: Math.max(2, Style.cornerRadius)
        color: menuMouse.containsMouse && menuRow.enabled ? Style.hoverFillFor(menuRow.destructive ? Color.urgent : (taskbar && taskbar.bar ? taskbar.bar.barForeground : Color.foreground), Color.accent) : "transparent"
    }

    Text {
        anchors.left: parent.left
        width: Style.space(30)
        anchors.verticalCenter: parent.verticalCenter
        horizontalAlignment: Text.AlignHCenter
        text: menuRow.iconText
        color: {
            if (menuRow.destructive)
                return Color.urgent;

            if (taskbar && taskbar.bar)
                return taskbar.bar.barForeground;

            return Color.foreground;
        }
        font.family: {
            if (taskbar && taskbar.bar)
                return taskbar.bar.fontFamily;

            return Style.font.family;
        }
        font.pixelSize: Style.font.bodySmall
    }

    Text {
        anchors.left: parent.left
        anchors.leftMargin: Style.space(34)
        anchors.right: parent.right
        anchors.rightMargin: Style.space(10)
        anchors.verticalCenter: parent.verticalCenter
        text: menuRow.text
        textFormat: Text.PlainText
        color: {
            if (menuRow.destructive)
                return Color.urgent;

            if (taskbar && taskbar.bar)
                return taskbar.bar.barForeground;

            return Color.foreground;
        }
        font.family: {
            if (taskbar && taskbar.bar)
                return taskbar.bar.fontFamily;

            return Style.font.family;
        }
        font.pixelSize: Style.font.bodySmall
        elide: Text.ElideRight
    }

    MouseArea {
        id: menuMouse

        anchors.fill: parent
        enabled: menuRow.enabled
        hoverEnabled: true
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: menuRow.triggered()
    }

}
