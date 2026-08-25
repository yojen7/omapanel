    PanelSeparator {
        width: parent.width
    }

    PanelSectionHeader {
        width: parent.width
        text: "SEPARATORS & FILTERS"
        foreground: panel.contentForeground
        fontFamily: panel.contentFontFamily
    }

    SettingToggle {
        host: panel
        settingKey: "leadingSeparator"
        settingLabel: "Leading separator"
        fallbackValue: false
    }

    SettingToggle {
        host: panel
        settingKey: "sectionSeparator"
        settingLabel: "Pinned / running separator"
        fallbackValue: true
    }

    SettingText {
        host: panel
        settingKey: "excludedClasses"
        settingLabel: "Excluded classes"
        placeholder: "Comma-separated regular expressions"
    }

    Rectangle {
        width: parent.width
        implicitHeight: pinHint.implicitHeight + Style.space(20)
        radius: Math.max(2, Style.cornerRadius)
        color: Style.hoverFillFor(panel.contentForeground, Color.accent)

        Text {
            id: pinHint

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: Style.space(10)
            anchors.rightMargin: Style.space(10)
            text: "Pinned applications are managed from each app's right-click menu."
            color: panel.contentForeground
            font.family: panel.contentFontFamily
            font.pixelSize: Style.font.caption
            wrapMode: Text.WordWrap
        }

    }
