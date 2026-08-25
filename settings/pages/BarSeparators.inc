    PanelSeparator {
        width: parent.width
    }

    PanelSectionHeader {
        width: parent.width
        text: "SEPARATORS"
        foreground: panel.contentForeground
        fontFamily: panel.contentFontFamily
    }

    SettingToggle {
        host: panel
        settingKey: "leadingSeparator"
        settingLabel: "Leading separator"
        fallbackValue: false
    }

    SettingToggle {
        host: panel
        settingKey: "sectionSeparator"
        settingLabel: "Pinned / running separator"
        fallbackValue: true
    }
