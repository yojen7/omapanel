        Column {
            width: parent.columnWidth
            spacing: Style.space(8)

            Text {
                width: parent.width
                text: "NORMAL"
                color: panel.contentForeground
                font.family: panel.contentFontFamily
                font.pixelSize: Style.font.caption
                font.bold: true
            }

            SettingText {
                host: panel
                width: parent.width
                settingKey: "normalColor"
                settingLabel: "Foreground"
                placeholder: "Theme or #RRGGBB"
            }

            SettingText {
                host: panel
                width: parent.width
                settingKey: "normalBackgroundColor"
                settingLabel: "Background"
                placeholder: "Off or #RRGGBBAA"
            }

            SettingNumber {
                host: panel
                width: parent.width
                settingKey: "normalFontWeight"
                settingLabel: "Weight"
                fallbackValue: 400
                minimumValue: 1
                maximumValue: 1000
                stepValue: 50
            }

            SettingNumber {
                host: panel
                width: parent.width
                settingKey: "normalOpacity"
                settingLabel: "Opacity (%)"
                fallbackValue: 100
                minimumValue: 0
                maximumValue: 100
                stepValue: 5
            }

        }
