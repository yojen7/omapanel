    PanelSeparator {
        width: parent.width
    }

    PanelSectionHeader {
        width: parent.width
        text: "WIDTH"
        foreground: panel.contentForeground
        fontFamily: panel.contentFontFamily
    }

    SettingDropdown {
        host: panel
        settingKey: "widthMode"
        settingLabel: "Item width mode"
        fallbackValue: "Adaptive"
        settingOptions: ["Adaptive", "Fixed"]
    }

    Row {
        width: parent.width
        spacing: Style.space(10)

        SettingNumber {
            host: panel
            width: (parent.width - parent.spacing) / 2
            settingKey: "fixedItemWidth"
            settingLabel: "Fixed width"
            fallbackValue: 160
            minimumValue: 32
            maximumValue: 480
            stepValue: 4
        }

        SettingNumber {
            host: panel
            width: (parent.width - parent.spacing) / 2
            settingKey: "maxAdaptiveWidth"
            settingLabel: "Adaptive max"
            fallbackValue: 280
            minimumValue: 32
            maximumValue: 640
            stepValue: 4
        }

    }

    SettingNumber {
        host: panel
        settingKey: "maxLabelLength"
        settingLabel: "Max label chars"
        fallbackValue: 14
        minimumValue: 4
        maximumValue: 40
    }
