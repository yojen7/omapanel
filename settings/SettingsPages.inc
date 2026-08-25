            StackLayout {
                width: parent.width
                height: children[currentIndex] ? children[currentIndex].implicitHeight : 0
                currentIndex: settingsPopup.pageIndex

                SettingsHub {
                    panel: settingsPopup
                    Layout.fillWidth: true
                }

                ApplicationsPage {
                    panel: settingsPopup
                    Layout.fillWidth: true
                }

                ClicksPage {
                    panel: settingsPopup
                    Layout.fillWidth: true
                }

                ContentPage {
                    panel: settingsPopup
                    Layout.fillWidth: true
                }

                ChipLayoutPage {
                    panel: settingsPopup
                    Layout.fillWidth: true
                }

                BarPage {
                    panel: settingsPopup
                    Layout.fillWidth: true
                }

                ColorsPage {
                    panel: settingsPopup
                    Layout.fillWidth: true
                }

                IndicatorPage {
                    panel: settingsPopup
                    Layout.fillWidth: true
                }

                PreviewsPage {
                    panel: settingsPopup
                    Layout.fillWidth: true
                }
            }

            Item {
                width: 1
                height: Style.space(2)
            }
