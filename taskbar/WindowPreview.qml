import QtQuick
import Quickshell.Wayland
import qs.Commons
import qs.Ui

PopupCard {
    id: previewCard

    required property var taskbar

    anchorItem: {
        if (!taskbar)
            return null;

        return taskbar.previewAnchor || taskbar;
    }
    owner: taskbar
    bar: taskbar ? taskbar.bar : null
    open: !!(taskbar && taskbar.showWindowPreviews && taskbar.previewToplevel !== null && taskbar.previewAnchor !== null)
    triggerMode: "hover"
    onAnchorItemChanged: {
        if (!previewCard.open)
            return ;

        Qt.callLater(function() {
            if (previewCard.open)
                previewCard.anchor.updateAnchor();
        });
    }
    padding: Style.space(8)
    contentWidth: previewCard.fittedContentWidth(Style.space(taskbar ? taskbar.previewWidth : 320))
    contentHeight: previewCard.fittedContentHeight(Style.space(taskbar ? taskbar.previewHeight : 220) + Style.space(28), Style.space(480))

    Item {
        anchors.fill: parent

        Item {
            id: previewFrame

            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: previewTitle.top
            anchors.bottomMargin: Style.space(7)
            clip: true

            Text {
                anchors.centerIn: parent
                visible: !previewView.hasContent
                text: taskbar.previewToplevel ? String(taskbar.windowLabel(taskbar.previewToplevel) || "?").charAt(0).toUpperCase() : ""
                textFormat: Text.PlainText
                color: taskbar.bar ? taskbar.bar.barForeground : Color.foreground
                font.family: taskbar.bar ? taskbar.bar.fontFamily : Style.font.family
                font.pixelSize: Style.font.title
                opacity: 0.5
            }

            ScreencopyView {
                id: previewView

                anchors.fill: parent
                captureSource: taskbar.previewToplevel ? taskbar.previewToplevel.wayland : null
                live: previewCard.open
                paintCursor: false
            }

        }

        Text {
            id: previewTitle

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            text: taskbar.previewToplevel ? taskbar.asPlainUiText(taskbar.windowTitle(taskbar.previewToplevel) || taskbar.windowLabel(taskbar.previewToplevel)) : ""
            textFormat: Text.PlainText
            color: taskbar.bar ? taskbar.bar.barForeground : Color.foreground
            font.family: taskbar.bar ? taskbar.bar.fontFamily : Style.font.family
            font.pixelSize: Style.font.caption
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignHCenter
        }

    }

}
