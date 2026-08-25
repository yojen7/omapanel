import QtQuick
import qs.Commons
import qs.Ui

NumberField {
    required property var host
    required property string settingKey
    required property string settingLabel
    required property int fallbackValue
    required property int minimumValue
    required property int maximumValue
    property int stepValue: 1

    label: settingLabel
    value: Math.round(host.numberValue(settingKey, fallbackValue))
    from: minimumValue
    to: maximumValue
    stepSize: stepValue
    fieldWidth: width
    foreground: host.contentForeground
    accent: Color.accent
    fontFamily: host.contentFontFamily
    onModified: function (nextValue) {
        host.change(settingKey, nextValue);
    }
}
