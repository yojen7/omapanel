import QtQuick
import qs.Commons
import qs.Ui

Column {
    required property var host
    required property string settingKey
    required property string settingLabel
    property string fallbackValue: ""
    property string placeholder: ""

    width: parent ? parent.width : 0
    spacing: Style.space(5)

    Text {
        width: parent.width
        text: parent.settingLabel
        color: host.contentForeground
        font.family: host.contentFontFamily
        font.pixelSize: Style.font.caption
        font.bold: true
    }

    TextField {
        width: parent.width
        text: host.stringValue(parent.settingKey, parent.fallbackValue)
        placeholderText: parent.placeholder
        foreground: host.contentForeground
        accent: Color.accent
        font.family: host.contentFontFamily
        onEditingFinished: host.change(parent.settingKey, text.trim())
    }

}
