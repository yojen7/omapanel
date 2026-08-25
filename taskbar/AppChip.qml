import QtQuick
import qs.Commons
import qs.Ui

WidgetButton {
    id: chip

    required property var taskbar
    required property var app
    required property var appWindow
    required property bool pinned

    // @include AppChipProperties.inc

    // @include AppChipVisuals.inc

    MouseArea {
        anchors.fill: parent
        z: 10
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onEntered: chip.setPointerHovered(true)
        onExited: chip.setPointerHovered(false)
        onClicked: function(mouse) {
            taskbar.handleConfiguredClick(chip.app, chip.appWindow, chip, mouse.button, mouse.modifiers);
        }
        onWheel: function(wheel) {
            var delta = wheel.angleDelta.y !== 0 ? wheel.angleDelta.y : wheel.angleDelta.x;
            wheel.accepted = chip.handleBarWheel(delta);
        }
    }

}
