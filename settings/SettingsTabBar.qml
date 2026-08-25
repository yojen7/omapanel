import QtQuick
import qs.Commons
import qs.Ui

Row {
    id: root

    required property var panel
    required property var tabs

    spacing: Style.space(6)

    Repeater {
        model: root.tabs

        Button {
            required property int index
            required property var modelData

            width: (root.width - root.spacing * Math.max(0, root.tabs.length - 1)) / Math.max(1, root.tabs.length)
            text: modelData && modelData.label !== undefined ? modelData.label : String(modelData)
            selected: root.panel.currentTab === index
            focusable: true
            bordered: true
            foreground: root.panel.contentForeground
            accent: Color.accent
            fontFamily: root.panel.contentFontFamily
            onClicked: root.panel.selectTab(index)
        }
    }
}
