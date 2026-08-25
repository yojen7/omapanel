import QtQuick
import qs.Commons
import qs.Ui

Column {
    id: settingsHub

    required property var panel

    width: parent.width
    spacing: Style.space(4)

    Repeater {
        model: settingsHub.panel.pages.length

        Item {
            id: categoryRow

            required property int index
            readonly property var page: settingsHub.panel.pages[index]
            readonly property string pageId: page && page.id ? String(page.id) : ""
            readonly property string pageLabel: page && page.label ? String(page.label) : ""
            readonly property string pageDescription: page && page.description ? String(page.description) : ""

            width: parent.width
            implicitHeight: Style.space(52)

            Rectangle {
                anchors.fill: parent
                radius: Math.max(2, Style.cornerRadius)
                color: rowMouse.containsMouse ? Style.hoverFillFor(settingsHub.panel.contentForeground, Color.accent) : "transparent"
            }

            Column {
                anchors.left: parent.left
                anchors.right: chevron.left
                anchors.leftMargin: Style.space(10)
                anchors.rightMargin: Style.space(8)
                anchors.verticalCenter: parent.verticalCenter
                spacing: Style.space(2)

                Text {
                    width: parent.width
                    text: categoryRow.pageLabel
                    color: settingsHub.panel.contentForeground
                    font.family: settingsHub.panel.contentFontFamily
                    font.pixelSize: Style.font.body
                    elide: Text.ElideRight
                }

                Text {
                    width: parent.width
                    text: categoryRow.pageDescription
                    color: Util.alpha(settingsHub.panel.contentForeground, 0.58)
                    font.family: settingsHub.panel.contentFontFamily
                    font.pixelSize: Style.font.caption
                    elide: Text.ElideRight
                }

            }

            Text {
                id: chevron

                anchors.right: parent.right
                anchors.rightMargin: Style.space(10)
                anchors.verticalCenter: parent.verticalCenter
                text: "\uf054"
                color: Util.alpha(settingsHub.panel.contentForeground, 0.45)
                font.family: settingsHub.panel.contentFontFamily
                font.pixelSize: Style.font.caption
            }

            MouseArea {
                id: rowMouse

                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: settingsHub.panel.openPage(categoryRow.pageId)
            }

        }

    }

}
