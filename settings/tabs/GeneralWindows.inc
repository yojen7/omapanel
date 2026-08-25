    PanelSeparator {
        width: parent.width
    }

    PanelSectionHeader {
        width: parent.width
        text: "WINDOWS & LABELS"
        foreground: panel.contentForeground
        fontFamily: panel.contentFontFamily
    }

    SettingToggle {
        host: panel
        settingKey: "showRunning"
        settingLabel: "Show running windows"
        settingDescription: "Append non-pinned Hyprland windows."
        fallbackValue: true
    }

    SettingToggle {
        host: panel
        settingKey: "groupRunningByWorkspace"
        settingLabel: "Group by workspace"
        settingDescription: "Sort dynamic windows and separate workspace groups."
        fallbackValue: true
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
