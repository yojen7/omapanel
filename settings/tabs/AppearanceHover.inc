        Column {
            width: parent.columnWidth
            spacing: Style.space(8)

            Text {
                width: parent.width
                text: "HOVER"
                color: panel.contentForeground
                font.family: panel.contentFontFamily
                font.pixelSize: Style.font.caption
                font.bold: true
            }

            SettingText {
                host: panel
                width: parent.width
                settingKey: "hoverColor"
                settingLabel: "Foreground"
                placeholder: "Normal or #RRGGBB"
            }

            SettingText {
                host: panel
                width: parent.width
                settingKey: "hoverBackgroundColor"
                settingLabel: "Background"
                placeholder: "Theme or #RRGGBBAA"
            }

            SettingNumber {
                host: panel
                width: parent.width
                settingKey: "hoverFontWeight"
                settingLabel: "Weight"
                fallbackValue: 500
                minimumValue: 1
                maximumValue: 1000
                stepValue: 50
            }

            SettingNumber {
                host: panel
                width: parent.width
                settingKey: "hoverOpacity"
                settingLabel: "Opacity (%)"
                fallbackValue: 100
                minimumValue: 0
                maximumValue: 100
                stepValue: 5
            }

        }
