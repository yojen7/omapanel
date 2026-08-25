import QtQuick
import qs.Commons
import qs.Ui

Item {
    id: chrome

    required property var taskbar

    anchors.centerIn: parent
    implicitWidth: content.implicitWidth + (taskbar ? taskbar.barPadHorizontal : 0) * 2
    implicitHeight: content.implicitHeight + (taskbar ? taskbar.barPadTop + taskbar.barPadBottom : 0)
    width: implicitWidth
    height: implicitHeight
    readonly property bool trimEdges: !!(taskbar && taskbar.trimEdgeItemGaps)
    readonly property int pinnedCount: taskbar && taskbar.pinnedItems ? taskbar.pinnedItems.length : 0
    readonly property int runningCount: taskbar && taskbar.runningWindows ? taskbar.runningWindows.length : 0

    Rectangle {
        anchors.fill: parent
        radius: taskbar ? taskbar.barCornerRadius : 0
        color: taskbar ? taskbar.barBackgroundColor : "transparent"
        visible: taskbar && taskbar.barBackgroundEnabled
    }

    Row {
        id: content

        x: taskbar ? taskbar.barPadHorizontal : 0
        y: taskbar ? taskbar.barPadTop : 0
        spacing: 0

        TaskbarSeparator {
            taskbar: taskbar
            visible: !!(taskbar && taskbar.leadingSeparator && taskbar.pinnedApps && taskbar.pinnedApps.length > 0)
        }

        Repeater {
            model: taskbar ? taskbar.pinnedItems : []

            AppChip {
                required property int index
                required property var modelData

                taskbar: taskbar
                app: modelData && modelData.app ? modelData.app : null
                appWindow: modelData ? modelData.window : null
                pinned: true
                includeLeadingHitPadding: !chrome.trimEdges || index > 0
                includeTrailingHitPadding: !chrome.trimEdges || index < chrome.pinnedCount - 1 || chrome.runningCount > 0
            }

        }

        TaskbarSeparator {
            taskbar: taskbar
            visible: !!(taskbar && taskbar.sectionSeparator && taskbar.pinnedApps && taskbar.pinnedApps.length > 0 && taskbar.runningWindows && taskbar.runningWindows.length > 0)
        }

        Repeater {
            model: taskbar ? taskbar.runningWindows : []

            Row {
                required property int index
                required property var modelData

                spacing: 0

                TaskbarSeparator {
                    taskbar: taskbar
                    visible: !!(taskbar && taskbar.startsWorkspaceGroup(parent.index, parent.modelData))
                }

                AppChip {
                    taskbar: taskbar
                    app: null
                    appWindow: parent.modelData
                    pinned: false
                    includeLeadingHitPadding: !chrome.trimEdges || parent.index > 0 || chrome.pinnedCount > 0
                    includeTrailingHitPadding: !chrome.trimEdges || parent.index < chrome.runningCount - 1
                }

            }

        }

    }

}
