import QtQuick
import qs.Commons
import qs.Ui

Column {
    required property var host
    required property string settingKey
    required property string settingLabel
    required property int minimumValue
    required property int maximumValue
    property string placeholder: "Auto"

    spacing: Style.spacing.md

    Text {
        width: parent.width
        text: parent.settingLabel
        color: Util.alpha(host.contentForeground, 0.72)
        font.family: host.contentFontFamily
        font.pixelSize: Style.font.bodySmall
    }

    TextField {
        width: parent.width
        text: {
            var current = host.value(parent.settingKey, "");
            return current === undefined || current === null ? "" : String(current).trim();
        }
        placeholderText: parent.placeholder
        foreground: host.contentForeground
        accent: Color.accent
        font.family: host.contentFontFamily
        horizontalAlignment: TextInput.AlignHCenter
        inputMethodHints: Qt.ImhDigitsOnly
        maximumLength: String(parent.maximumValue).length
        onTextEdited: {
            if (text.trim() === "")
                host.change(parent.settingKey, "");
        }
        onEditingFinished: {
            var nextValue = text.trim();
            if (nextValue === "") {
                host.change(parent.settingKey, "");
                return;
            }
            var parsed = Number(nextValue);
            if (isNaN(parsed)) {
                text = "";
                host.change(parent.settingKey, "");
                return;
            }
            var clamped = Math.max(parent.minimumValue, Math.min(parent.maximumValue, Math.round(parsed)));
            text = String(clamped);
            host.change(parent.settingKey, String(clamped));
        }
    }
}
