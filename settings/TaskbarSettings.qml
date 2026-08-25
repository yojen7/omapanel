import QtQuick
import QtQuick.Controls as QQC
import QtQuick.Layouts
import qs.Commons
import qs.Ui
import "pages"

KeyboardPanel {
    id: settingsPopup

    property var values: ({})
    property string currentPage: ""
    // @include SettingsCatalog.inc
    readonly property color contentForeground: Color.popups.text
    readonly property string contentFontFamily: bar ? bar.fontFamily : Style.font.family
    readonly property var pinnedAppsModel: {
        var raw = stringValue("pinnedApps", "[]");
        try {
            var parsed = JSON.parse(raw);
            return Array.isArray(parsed) ? parsed : [];
        } catch (exception) {
            return [];
        }
    }

    signal settingChanged(string key, var value)
    signal resetRequested

    function value(key, fallback) {
        var current = values ? values[key] : undefined;
        return current === undefined || current === null ? fallback : current;
    }

    function boolValue(key, fallback) {
        return value(key, fallback) === true;
    }

    function numberValue(key, fallback) {
        var current = Number(value(key, fallback));
        return isNaN(current) ? fallback : current;
    }

    function stringValue(key, fallback) {
        return String(value(key, fallback));
    }

    function change(key, nextValue) {
        settingChanged(key, nextValue);
    }

    function openPage(pageId) {
        currentPage = pageId;
        settingsFlick.contentY = 0;
    }

    function goHome() {
        currentPage = "";
        settingsFlick.contentY = 0;
    }

    function movePinnedApp(index, delta) {
        var apps = pinnedAppsModel.slice();
        var next = index + delta;
        if (next < 0 || next >= apps.length)
            return;

        var item = apps[index];
        apps[index] = apps[next];
        apps[next] = item;
        change("pinnedApps", JSON.stringify(apps));
    }

    padding: Style.space(12)
    contentWidth: fittedContentWidth(Style.space(460))
    contentHeight: fittedContentHeight(settingsColumn.implicitHeight, Style.space(680))
    focusTarget: settingsFlick

    Flickable {
        id: settingsFlick

        anchors.fill: parent
        activeFocusOnTab: true
        contentWidth: width
        contentHeight: settingsColumn.implicitHeight
        Keys.onEscapePressed: function (event) {
            if (settingsPopup.currentPage !== "") {
                settingsPopup.goHome();
                event.accepted = true;
                return;
            }
            settingsPopup.close();
            event.accepted = true;
        }
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        flickableDirection: Flickable.VerticalFlick
        interactive: contentHeight > height

        Column {
            id: settingsColumn

            width: Math.max(1, settingsFlick.width - (verticalBar.visible ? Style.space(10) : 0))
            spacing: Style.space(12)

            // @include SettingsHeader.inc

            // @include SettingsPages.inc

        }

        QQC.ScrollBar.vertical: QQC.ScrollBar {
            id: verticalBar

            policy: QQC.ScrollBar.AsNeeded
        }
    }
}
