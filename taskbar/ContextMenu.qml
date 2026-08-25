import QtQuick
import QtQuick.Controls as QQC
import qs.Commons
import qs.Ui

PopupCard {
    id: contextPopup

    required property var taskbar

    anchorItem: {
        if (!taskbar)
            return null;

        return taskbar.contextAnchor || taskbar;
    }
    owner: taskbar
    bar: taskbar ? taskbar.bar : null
    open: !!(taskbar && taskbar.contextMenuOpen)
    padding: Style.space(8)
    contentWidth: contextPopup.fittedContentWidth(Style.space(300))
    contentHeight: contextPopup.fittedContentHeight(contextMenuColumn.implicitHeight, Style.space(480))

    Flickable {
        anchors.fill: parent
        contentWidth: width
        contentHeight: contextMenuColumn.implicitHeight
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        flickableDirection: Flickable.VerticalFlick
        interactive: contentHeight > height

        Column {
            id: contextMenuColumn

            width: parent.width
            spacing: 0

            // @include ContextHeader.inc

            // @include ContextActions.inc

        }

        QQC.ScrollBar.vertical: QQC.ScrollBar {
            policy: QQC.ScrollBar.AsNeeded
        }

    }

}
