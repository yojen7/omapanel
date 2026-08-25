import QtQuick
import qs.Commons
import qs.Ui
import "../fields"

Column {
    required property var panel

    width: parent.width
    spacing: Style.space(12)

    PanelSeparator {
        width: parent.width
    }

    PanelSectionHeader {
        width: parent.width
        text: "ACTIVE ITEM"
        foreground: panel.contentForeground
        fontFamily: panel.contentFontFamily
    }

    SettingToggle {
        host: panel
        settingKey: "hoverOverridesActive"
        settingLabel: "Hover overrides active"
        settingDescription: "Use hover colors when the pointer is over the focused window."
        fallbackValue: true
    }

    Row {
        readonly property real columnWidth: (width - spacing * 2) / 3

        width: parent.width
        spacing: Style.space(10)

        // @include AppearanceNormal.inc
        // @include AppearanceHover.inc
        // @include AppearanceActive.inc
    }
}
