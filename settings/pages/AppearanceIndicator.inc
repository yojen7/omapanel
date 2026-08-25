    PanelSeparator {
        width: parent.width
    }

    PanelSectionHeader {
        width: parent.width
        text: "INDICATOR"
        foreground: panel.contentForeground
        fontFamily: panel.contentFontFamily
    }

    SettingDropdown {
        host: panel
        settingKey: "activeIndicator"
        settingLabel: "Indicator style"
        fallbackValue: "Underline"
        settingOptions: ["Underline", "Top", "Dot", "None"]
    }

    SettingText {
        host: panel
        settingKey: "indicatorColor"
        settingLabel: "Indicator color"
        placeholder: "Theme accent or #RRGGBB"
    }

    Row {
        width: parent.width
        spacing: Style.space(10)

        SettingNumber {
            host: panel
            width: (parent.width - parent.spacing) / 2
            settingKey: "indicatorThickness"
            settingLabel: "Line thickness"
            fallbackValue: 2
            minimumValue: 1
            maximumValue: 8
        }

        SettingNumber {
            host: panel
            width: (parent.width - parent.spacing) / 2
            settingKey: "indicatorSize"
            settingLabel: "Dot size"
            fallbackValue: 4
            minimumValue: 2
            maximumValue: 16
        }

    }

    Row {
        width: parent.width
        spacing: Style.space(10)

        SettingNumber {
            host: panel
            width: (parent.width - parent.spacing) / 2
            settingKey: "indicatorLength"
            settingLabel: "Line length (0 = auto)"
            fallbackValue: 0
            minimumValue: 0
            maximumValue: 80
        }

        SettingNumber {
            host: panel
            width: (parent.width - parent.spacing) / 2
            settingKey: "indicatorMargin"
            settingLabel: "Edge margin"
            fallbackValue: 2
            minimumValue: 0
            maximumValue: 12
        }

    }
