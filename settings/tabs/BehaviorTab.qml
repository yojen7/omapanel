import QtQuick
import qs.Commons
import qs.Ui
import "../fields"

Column {
    id: behaviorTab

    required property var panel
    readonly property var actionOptions: ["Focus or Launch", "Open Context Menu", "New Window", "Close Window", "Close All Windows", "Toggle Pin", "Open Settings", "Do Nothing"]

    width: parent.width
    spacing: Style.space(12)

    // @include BehaviorClicks.inc

    // @include BehaviorPreviews.inc

}
