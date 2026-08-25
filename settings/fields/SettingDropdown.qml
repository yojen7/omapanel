import QtQuick
import qs.Commons
import qs.Ui

Dropdown {
    required property var host
    required property string settingKey
    required property string settingLabel
    required property var settingOptions
    property string fallbackValue: ""

    width: parent ? parent.width : 0
    label: settingLabel
    value: host.stringValue(settingKey, fallbackValue)
    options: settingOptions
    foreground: host.contentForeground
    background: Color.popups.background
    popupBorder: Color.popups.border
    accent: Color.accent
    fontFamily: host.contentFontFamily
    onChanged: function(nextValue) {
        host.change(settingKey, nextValue);
    }
}
