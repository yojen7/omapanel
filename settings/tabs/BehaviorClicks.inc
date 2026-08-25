    PanelSeparator {
        width: parent.width
    }

    PanelSectionHeader {
        width: parent.width
        text: "CLICK ACTIONS"
        foreground: panel.contentForeground
        fontFamily: panel.contentFontFamily
    }

    Row {
        width: parent.width
        spacing: Style.space(10)

        SettingDropdown {
            host: panel
            width: (parent.width - parent.spacing) / 2
            settingKey: "leftClickAction"
            settingLabel: "Left click"
            fallbackValue: "Focus or Launch"
            settingOptions: behaviorTab.actionOptions
        }

        SettingDropdown {
            host: panel
            width: (parent.width - parent.spacing) / 2
            settingKey: "rightClickAction"
            settingLabel: "Right click"
            fallbackValue: "Open Context Menu"
            settingOptions: behaviorTab.actionOptions
        }

    }

    Row {
        width: parent.width
        spacing: Style.space(10)

        SettingDropdown {
            host: panel
            width: (parent.width - parent.spacing) / 2
            settingKey: "middleClickAction"
            settingLabel: "Middle click"
            fallbackValue: "Do Nothing"
            settingOptions: behaviorTab.actionOptions
        }

        SettingDropdown {
            host: panel
            width: (parent.width - parent.spacing) / 2
            settingKey: "ctrlClickAction"
            settingLabel: "Ctrl + left click"
            fallbackValue: "Focus or Launch"
            settingOptions: behaviorTab.actionOptions
        }

    }

    Row {
        width: parent.width
        spacing: Style.space(10)

        SettingDropdown {
            host: panel
            width: (parent.width - parent.spacing) / 2
            settingKey: "shiftClickAction"
            settingLabel: "Shift + left click"
            fallbackValue: "Focus or Launch"
            settingOptions: behaviorTab.actionOptions
        }

        SettingDropdown {
            host: panel
            width: (parent.width - parent.spacing) / 2
            settingKey: "altClickAction"
            settingLabel: "Alt + left click"
            fallbackValue: "Focus or Launch"
            settingOptions: behaviorTab.actionOptions
        }

    }

    Text {
        width: parent.width
        text: "For combined modifiers, Ctrl takes priority over Shift, then Alt."
        color: Util.alpha(panel.contentForeground, 0.58)
        font.family: panel.contentFontFamily
        font.pixelSize: Style.font.caption
        wrapMode: Text.WordWrap
    }
