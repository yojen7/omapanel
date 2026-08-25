    PanelSeparator {
        width: parent.width
    }

    PanelSectionHeader {
        width: parent.width
        text: "PADDING & GAPS"
        foreground: panel.contentForeground
        fontFamily: panel.contentFontFamily
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

    SettingNumber {
        host: panel
        settingKey: "itemSpacing"
        settingLabel: "Item spacing"
        fallbackValue: 4
        minimumValue: 0
        maximumValue: 24
    }

    SettingToggle {
        host: panel
        settingKey: "trimEdgeItemGaps"
        settingLabel: "Trim start/end item gaps"
        settingDescription: "Keep item spacing between chips only, not at the bar edges."
        fallbackValue: true
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
