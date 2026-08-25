    PanelSeparator {
        width: parent.width
    }

    PanelSectionHeader {
        width: parent.width
        text: "BAR"
        foreground: panel.contentForeground
        fontFamily: panel.contentFontFamily
    }

    Row {
        width: parent.width
        spacing: Style.space(10)

        SettingNumber {
            host: panel
            width: (parent.width - parent.spacing) / 2
            settingKey: "barTopPadding"
            settingLabel: "Top padding"
            fallbackValue: 0
            minimumValue: 0
            maximumValue: 16
        }

        SettingNumber {
            host: panel
            width: (parent.width - parent.spacing) / 2
            settingKey: "barBottomPadding"
            settingLabel: "Bottom padding"
            fallbackValue: 0
            minimumValue: 0
            maximumValue: 16
        }

    }

    Row {
        width: parent.width
        spacing: Style.space(10)

        SettingNumber {
            host: panel
            width: (parent.width - parent.spacing) / 2
            settingKey: "barHorizontalPadding"
            settingLabel: "Edge padding"
            fallbackValue: 0
            minimumValue: 0
            maximumValue: 24
        }

        SettingOptionalNumber {
            host: panel
            width: (parent.width - parent.spacing) / 2
            settingKey: "barCornerRadius"
            settingLabel: "Bar rounding"
            minimumValue: 0
            maximumValue: 32
            placeholder: "Theme"
        }

    }

    SettingText {
        host: panel
        settingKey: "barBackgroundColor"
        settingLabel: "Bar background"
        placeholder: "Off or #RRGGBBAA"
    }
