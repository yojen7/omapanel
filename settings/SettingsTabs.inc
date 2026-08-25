            SettingsTabBar {
                width: parent.width
                panel: settingsPopup
                tabs: settingsPopup.tabs
            }

            StackLayout {
                width: parent.width
                height: children[currentIndex] ? children[currentIndex].implicitHeight : 0
                currentIndex: settingsPopup.currentTab

                GeneralTab {
                    panel: settingsPopup
                    Layout.fillWidth: true
                }

                BehaviorTab {
                    panel: settingsPopup
                    Layout.fillWidth: true
                }

                LayoutTab {
                    panel: settingsPopup
                    Layout.fillWidth: true
                }

                AppearanceTab {
                    panel: settingsPopup
                    Layout.fillWidth: true
                }
            }

            Item {
                width: 1
                height: Style.space(2)
            }
