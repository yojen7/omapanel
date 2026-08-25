import QtQuick
import qs.Commons
import qs.Ui

Item {
    width: parent ? parent.width : Style.space(280)
    implicitHeight: visible ? Style.space(11) : 0

    Rectangle {
        anchors.left: parent.left
        anchors.leftMargin: Style.space(8)
        anchors.right: parent.right
        anchors.rightMargin: Style.space(8)
        anchors.verticalCenter: parent.verticalCenter
        height: 1
        color: Color.popups.border
        opacity: 0.5
    }

}
