            Item {
                width: parent.width
                implicitHeight: Math.max(settingsTitleColumn.implicitHeight, closeButton.implicitHeight)

                Column {
                    id: settingsTitleColumn

                    anchors.left: parent.left
                    anchors.right: resetButton.left
                    anchors.rightMargin: Style.space(12)
                    spacing: Style.space(2)

                    Text {
                        width: parent.width
                        text: "OmaPanel Settings"
                        color: settingsPopup.contentForeground
                        font.family: settingsPopup.contentFontFamily
                        font.pixelSize: Style.font.title
                        font.bold: true
                        elide: Text.ElideRight
                    }

                    Text {
                        width: parent.width
                        text: "Changes are saved instantly"
                        color: Util.alpha(settingsPopup.contentForeground, 0.58)
                        font.family: settingsPopup.contentFontFamily
                        font.pixelSize: Style.font.caption
                    }

                }

                Button {
                    id: resetButton

                    anchors.right: closeButton.left
                    anchors.rightMargin: Style.space(6)
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Reset defaults"
                    iconText: "\uf0e2"
                    foreground: settingsPopup.contentForeground
                    accent: Color.accent
                    fontFamily: settingsPopup.contentFontFamily
                    horizontalPadding: Style.space(9)
                    verticalPadding: Style.space(6)
                    tooltipText: "Restore manifest defaults"
                    onClicked: settingsPopup.resetRequested()
                }

                Button {
                    id: closeButton

                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    iconText: "\uf00d"
                    foreground: settingsPopup.contentForeground
                    accent: Color.accent
                    fontFamily: settingsPopup.contentFontFamily
                    horizontalPadding: Style.space(9)
                    verticalPadding: Style.space(6)
                    tooltipText: "Close settings"
                    onClicked: settingsPopup.close()
                }

            }
