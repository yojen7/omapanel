import QtQuick
import qs.Commons
import qs.Ui

Button {
    required property var host

    anchors.verticalCenter: parent.verticalCenter
    foreground: host.contentForeground
    accent: Color.accent
    fontFamily: host.contentFontFamily
    horizontalPadding: Style.space(8)
    verticalPadding: Style.space(5)
}
