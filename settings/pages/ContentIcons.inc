    PanelSeparator {
        width: parent.width
    }

    PanelSectionHeader {
        width: parent.width
        text: "VISIBILITY"
        foreground: panel.contentForeground
        fontFamily: panel.contentFontFamily
    }

    SettingToggle {
        host: panel
        settingKey: "iconOnlyWhenClosed"
        settingLabel: "Icon only when closed"
        settingDescription: "Expand pinned apps when a matching window opens."
        fallbackValue: true
    }

    Row {
        width: parent.width
        spacing: Style.space(10)

        SettingToggle {
            host: panel
            width: (parent.width - parent.spacing) / 2
            settingKey: "showIcons"
            settingLabel: "Icons"
            fallbackValue: true
        }

        SettingToggle {
            host: panel
            width: (parent.width - parent.spacing) / 2
            settingKey: "showLabels"
            settingLabel: "Labels"
            fallbackValue: true
        }

    }

    SettingToggle {
        host: panel
        settingKey: "invertIconColors"
        settingLabel: "Invert icon colors"
        settingDescription: "Invert application icon pixels while preserving transparency."
        fallbackValue: false
    }

    SettingText {
        host: panel
        settingKey: "labelFormat"
        settingLabel: "Label format"
        fallbackValue: "[APP_NAME] - [WINDOW_TITLE]"
        placeholder: "[APP_NAME] - [WINDOW_TITLE]"
    }

    Row {
        width: parent.width
        spacing: Style.space(10)

        SettingNumber {
            host: panel
            width: (parent.width - parent.spacing) / 2
            settingKey: "iconSize"
            settingLabel: "Icon size"
            fallbackValue: 18
            minimumValue: 8
            maximumValue: 32
        }

        SettingNumber {
            host: panel
            width: (parent.width - parent.spacing) / 2
            settingKey: "iconLabelSpacing"
            settingLabel: "Icon / label gap"
            fallbackValue: 8
            minimumValue: 0
            maximumValue: 20
        }

    }

    SettingOptionalNumber {
        host: panel
        settingKey: "fontSize"
        settingLabel: "Font size"
        minimumValue: 8
        maximumValue: 24
        placeholder: "Auto"
    }
