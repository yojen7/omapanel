    PanelSeparator {
        width: parent.width
    }

    PanelSectionHeader {
        width: parent.width
        text: "PINNED APPS"
        foreground: panel.contentForeground
        fontFamily: panel.contentFontFamily
    }

    Text {
        width: parent.width
        visible: panel.pinnedAppsModel.length === 0
        text: "No pinned applications. Pin apps from the right-click menu."
        color: Util.alpha(panel.contentForeground, 0.58)
        font.family: panel.contentFontFamily
        font.pixelSize: Style.font.caption
        wrapMode: Text.WordWrap
    }

    Repeater {
        model: panel.pinnedAppsModel

        Row {
            id: pinnedRow

            required property int index
            required property var modelData

            width: parent.width
            spacing: Style.space(6)

            Text {
                width: parent.width - Style.space(84)
                anchors.verticalCenter: parent.verticalCenter
                text: String(pinnedRow.modelData && pinnedRow.modelData.label ? pinnedRow.modelData.label : "App")
                textFormat: Text.PlainText
                color: panel.contentForeground
                font.family: panel.contentFontFamily
                font.pixelSize: Style.font.body
                elide: Text.ElideRight
            }

            PinnedMoveButton {
                host: panel
                iconText: "\uf077"
                enabled: pinnedRow.index > 0
                tooltipText: "Move up"
                onClicked: panel.movePinnedApp(pinnedRow.index, -1)
            }

            PinnedMoveButton {
                host: panel
                iconText: "\uf078"
                enabled: pinnedRow.index < panel.pinnedAppsModel.length - 1
                tooltipText: "Move down"
                onClicked: panel.movePinnedApp(pinnedRow.index, 1)
            }

        }

    }
