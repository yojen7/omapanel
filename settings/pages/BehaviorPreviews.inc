    PanelSeparator {
        width: parent.width
    }

    PanelSectionHeader {
        width: parent.width
        text: "WINDOW PREVIEWS"
        foreground: panel.contentForeground
        fontFamily: panel.contentFontFamily
    }

    SettingToggle {
        host: panel
        settingKey: "showWindowPreviews"
        settingLabel: "Show window previews"
        settingDescription: "Show a live thumbnail when hovering an open window."
        fallbackValue: false
    }

    SettingNumber {
        host: panel
        settingKey: "previewDelay"
        settingLabel: "Preview delay (ms)"
        fallbackValue: 350
        minimumValue: 0
        maximumValue: 1500
        stepValue: 50
    }

    Row {
        width: parent.width
        spacing: Style.space(10)

        SettingNumber {
            host: panel
            width: (parent.width - parent.spacing) / 2
            settingKey: "previewWidth"
            settingLabel: "Preview width"
            fallbackValue: 320
            minimumValue: 160
            maximumValue: 640
            stepValue: 10
        }

        SettingNumber {
            host: panel
            width: (parent.width - parent.spacing) / 2
            settingKey: "previewHeight"
            settingLabel: "Preview height"
            fallbackValue: 220
            minimumValue: 100
            maximumValue: 480
            stepValue: 10
        }

    }

    PanelSeparator {
        width: parent.width
    }

    PanelSectionHeader {
        width: parent.width
        text: "ANIMATION"
        foreground: panel.contentForeground
        fontFamily: panel.contentFontFamily
    }

    SettingNumber {
        host: panel
        settingKey: "animationDuration"
        settingLabel: "Animation duration (ms)"
        fallbackValue: 180
        minimumValue: 0
        maximumValue: 500
        stepValue: 10
    }
