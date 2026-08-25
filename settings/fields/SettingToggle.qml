import QtQuick
import qs.Commons
import qs.Ui

Toggle {
    required property var host
    required property string settingKey
    required property string settingLabel
    property string settingDescription: ""
    property bool fallbackValue: false

    width: parent ? parent.width : 0
    label: settingLabel
    description: settingDescription
    checked: host.boolValue(settingKey, fallbackValue)
    foreground: host.contentForeground
    accent: Color.accent
    fontFamily: host.contentFontFamily
    onClicked: host.change(settingKey, !checked)
}
