    PanelSeparator {
        width: parent.width
    }

    PanelSectionHeader {
        width: parent.width
        text: "SIZE & SPACING"
        foreground: panel.contentForeground
        fontFamily: panel.contentFontFamily
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

        SettingOptionalNumber {
            host: panel
            width: (parent.width - parent.spacing) / 2
            settingKey: "fontSize"
            settingLabel: "Font size"
            minimumValue: 8
            maximumValue: 24
            placeholder: "Auto"
        }

    }

    Row {
        width: parent.width
        spacing: Style.space(10)

        SettingNumber {
            host: panel
            width: (parent.width - parent.spacing) / 2
            settingKey: "itemHorizontalPadding"
            settingLabel: "Horizontal padding"
            fallbackValue: 8
            minimumValue: 0
            maximumValue: 24
        }

        SettingNumber {
            host: panel
            width: (parent.width - parent.spacing) / 2
            settingKey: "itemVerticalPadding"
            settingLabel: "Vertical padding"
            fallbackValue: 12
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
            settingKey: "itemSpacing"
            settingLabel: "Item spacing"
            fallbackValue: 4
            minimumValue: 0
            maximumValue: 24
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
        width: parent.width
        settingKey: "itemCornerRadius"
        settingLabel: "Item rounding"
        minimumValue: 0
        maximumValue: 32
        placeholder: "Theme"
    }
