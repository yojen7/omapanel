        Column {
            width: parent.columnWidth
            spacing: Style.space(8)

            Text {
                width: parent.width
                text: "ACTIVE"
                color: panel.contentForeground
                font.family: panel.contentFontFamily
                font.pixelSize: Style.font.caption
                font.bold: true
            }

            SettingText {
                host: panel
                width: parent.width
                settingKey: "activeColor"
                settingLabel: "Foreground"
                placeholder: "Theme or #RRGGBB"
            }

            SettingText {
                host: panel
                width: parent.width
                settingKey: "activeBackgroundColor"
                settingLabel: "Background"
                placeholder: "Active or #RRGGBBAA"
            }

            SettingNumber {
                host: panel
                width: parent.width
                settingKey: "activeFontWeight"
                settingLabel: "Weight"
                fallbackValue: 600
                minimumValue: 1
                maximumValue: 1000
                stepValue: 50
            }

            SettingNumber {
                host: panel
                width: parent.width
                settingKey: "activeOpacity"
                settingLabel: "Opacity (%)"
                fallbackValue: 100
                minimumValue: 0
                maximumValue: 100
                stepValue: 5
            }

        }
