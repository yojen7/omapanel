import QtQuick
import QtQuick.Controls as QQC
import qs.Commons
import qs.Ui

KeyboardPanel {
  id: settingsPopup

  property var values: ({})
  property int currentTab: 0
  readonly property color contentForeground: bar ? bar.barForeground : Color.foreground
  readonly property string contentFontFamily: bar ? bar.fontFamily : Style.font.family

  signal settingChanged(string key, var value)
  signal resetRequested()

  padding: Style.space(12)
  contentWidth: fittedContentWidth(Style.space(460))
  contentHeight: fittedContentHeight(settingsColumn.implicitHeight, Style.space(680))
  focusTarget: settingsFlick

  function value(key, fallback) {
    var current = values ? values[key] : undefined
    return current === undefined || current === null ? fallback : current
  }

  function boolValue(key, fallback) {
    return value(key, fallback) === true
  }

  function numberValue(key, fallback) {
    var current = Number(value(key, fallback))
    return isNaN(current) ? fallback : current
  }

  function stringValue(key, fallback) {
    return String(value(key, fallback))
  }

  function change(key, nextValue) {
    settingChanged(key, nextValue)
  }

  function selectTab(index) {
    currentTab = index
    settingsFlick.contentY = 0
  }

  Flickable {
    id: settingsFlick
    anchors.fill: parent
    activeFocusOnTab: true
    contentWidth: width
    contentHeight: settingsColumn.implicitHeight

    Keys.onEscapePressed: function(event) {
      settingsPopup.close()
      event.accepted = true
    }
    clip: true
    boundsBehavior: Flickable.StopAtBounds
    flickableDirection: Flickable.VerticalFlick
    interactive: contentHeight > height

    QQC.ScrollBar.vertical: QQC.ScrollBar {
      id: verticalBar
      policy: QQC.ScrollBar.AsNeeded
    }

    Column {
      id: settingsColumn
      width: Math.max(1, settingsFlick.width - (verticalBar.visible ? Style.space(10) : 0))
      spacing: Style.space(12)

      Item {
        width: parent.width
        implicitHeight: Math.max(settingsTitleColumn.implicitHeight, closeButton.implicitHeight)

        Column {
          id: settingsTitleColumn
          anchors.left: parent.left
          anchors.right: resetButton.left
          anchors.rightMargin: Style.space(12)
          spacing: Style.space(2)

          Text {
            width: parent.width
            text: "OmaPanel Settings"
            color: settingsPopup.contentForeground
            font.family: settingsPopup.contentFontFamily
            font.pixelSize: Style.font.title
            font.bold: true
            elide: Text.ElideRight
          }

          Text {
            width: parent.width
            text: "Changes are saved instantly"
            color: Util.alpha(settingsPopup.contentForeground, 0.58)
            font.family: settingsPopup.contentFontFamily
            font.pixelSize: Style.font.caption
          }
        }

        Button {
          id: resetButton
          anchors.right: closeButton.left
          anchors.rightMargin: Style.space(6)
          anchors.verticalCenter: parent.verticalCenter
          text: "Reset defaults"
          iconText: "\uf0e2"
          foreground: settingsPopup.contentForeground
          accent: Color.accent
          fontFamily: settingsPopup.contentFontFamily
          horizontalPadding: Style.space(9)
          verticalPadding: Style.space(6)
          tooltipText: "Restore manifest defaults"
          onClicked: settingsPopup.resetRequested()
        }

        Button {
          id: closeButton
          anchors.right: parent.right
          anchors.verticalCenter: parent.verticalCenter
          iconText: "\uf00d"
          foreground: settingsPopup.contentForeground
          accent: Color.accent
          fontFamily: settingsPopup.contentFontFamily
          horizontalPadding: Style.space(9)
          verticalPadding: Style.space(6)
          tooltipText: "Close settings"
          onClicked: settingsPopup.close()
        }
      }

      Row {
        width: parent.width
        spacing: Style.space(6)

        Button {
          width: (parent.width - parent.spacing * 3) / 4
          text: "General"
          selected: settingsPopup.currentTab === 0
          focusable: true
          bordered: true
          foreground: settingsPopup.contentForeground
          accent: Color.accent
          fontFamily: settingsPopup.contentFontFamily
          onClicked: settingsPopup.selectTab(0)
        }

        Button {
          width: (parent.width - parent.spacing * 3) / 4
          text: "Behavior"
          selected: settingsPopup.currentTab === 1
          focusable: true
          bordered: true
          foreground: settingsPopup.contentForeground
          accent: Color.accent
          fontFamily: settingsPopup.contentFontFamily
          onClicked: settingsPopup.selectTab(1)
        }

        Button {
          width: (parent.width - parent.spacing * 3) / 4
          text: "Layout"
          selected: settingsPopup.currentTab === 2
          focusable: true
          bordered: true
          foreground: settingsPopup.contentForeground
          accent: Color.accent
          fontFamily: settingsPopup.contentFontFamily
          onClicked: settingsPopup.selectTab(2)
        }

        Button {
          width: (parent.width - parent.spacing * 3) / 4
          text: "Appearance"
          selected: settingsPopup.currentTab === 3
          focusable: true
          bordered: true
          foreground: settingsPopup.contentForeground
          accent: Color.accent
          fontFamily: settingsPopup.contentFontFamily
          onClicked: settingsPopup.selectTab(3)
        }
      }

      Column {
        id: generalTab
        visible: settingsPopup.currentTab === 0
        width: parent.width
        spacing: Style.space(12)

        PanelSeparator { width: parent.width }
        PanelSectionHeader {
          width: parent.width
          text: "WINDOWS & LABELS"
          foreground: settingsPopup.contentForeground
          fontFamily: settingsPopup.contentFontFamily
        }

      SettingToggle {
        settingKey: "showRunning"
        settingLabel: "Show running windows"
        settingDescription: "Append non-pinned Hyprland windows."
        fallbackValue: true
      }

      SettingToggle {
        settingKey: "groupRunningByWorkspace"
        settingLabel: "Group by workspace"
        settingDescription: "Sort dynamic windows and separate workspace groups."
        fallbackValue: true
      }

      SettingToggle {
        settingKey: "iconOnlyWhenClosed"
        settingLabel: "Icon only when closed"
        settingDescription: "Expand pinned apps when a matching window opens."
        fallbackValue: true
      }

      Row {
        width: parent.width
        spacing: Style.space(10)

        SettingToggle {
          width: (parent.width - parent.spacing) / 2
          settingKey: "showIcons"
          settingLabel: "Icons"
          fallbackValue: true
        }

        SettingToggle {
          width: (parent.width - parent.spacing) / 2
          settingKey: "showLabels"
          settingLabel: "Labels"
          fallbackValue: true
        }
      }

      SettingToggle {
        settingKey: "invertIconColors"
        settingLabel: "Invert icon colors"
        settingDescription: "Invert application icon pixels while preserving transparency."
        fallbackValue: false
      }

      SettingText {
        settingKey: "labelFormat"
        settingLabel: "Label format"
        fallbackValue: "[APP_NAME] - [WINDOW_TITLE]"
        placeholder: "[APP_NAME] - [WINDOW_TITLE]"
      }

      PanelSeparator { width: parent.width }
      PanelSectionHeader {
        width: parent.width
        text: "WIDTH & LIMITS"
        foreground: settingsPopup.contentForeground
        fontFamily: settingsPopup.contentFontFamily
      }

      SettingDropdown {
        settingKey: "widthMode"
        settingLabel: "Item width mode"
        fallbackValue: "Adaptive"
        settingOptions: ["Adaptive", "Fixed"]
      }

      Row {
        width: parent.width
        spacing: Style.space(10)

        SettingNumber {
          width: (parent.width - parent.spacing) / 2
          settingKey: "fixedItemWidth"
          settingLabel: "Fixed width"
          fallbackValue: 160
          minimumValue: 32
          maximumValue: 480
          stepValue: 4
        }

        SettingNumber {
          width: (parent.width - parent.spacing) / 2
          settingKey: "maxAdaptiveWidth"
          settingLabel: "Adaptive max"
          fallbackValue: 280
          minimumValue: 32
          maximumValue: 640
          stepValue: 4
        }
      }

      Row {
        width: parent.width
        spacing: Style.space(10)

        SettingNumber {
          width: (parent.width - parent.spacing) / 2
          settingKey: "maxLabelLength"
          settingLabel: "Max label chars"
          fallbackValue: 14
          minimumValue: 4
          maximumValue: 40
        }

        SettingNumber {
          width: (parent.width - parent.spacing) / 2
          settingKey: "maxRunningWindows"
          settingLabel: "Max windows"
          fallbackValue: 12
          minimumValue: 1
          maximumValue: 30
        }
      }

      }

      Column {
        id: behaviorTab
        visible: settingsPopup.currentTab === 1
        width: parent.width
        spacing: Style.space(12)

        readonly property var actionOptions: [
          "Focus or Launch", "Open Context Menu", "New Window", "Close Window",
          "Close All Windows", "Toggle Pin", "Open Settings", "Do Nothing"
        ]

        PanelSeparator { width: parent.width }
        PanelSectionHeader {
          width: parent.width
          text: "CLICK ACTIONS"
          foreground: settingsPopup.contentForeground
          fontFamily: settingsPopup.contentFontFamily
        }

        Row {
          width: parent.width
          spacing: Style.space(10)

          SettingDropdown {
            width: (parent.width - parent.spacing) / 2
            settingKey: "leftClickAction"
            settingLabel: "Left click"
            fallbackValue: "Focus or Launch"
            settingOptions: behaviorTab.actionOptions
          }

          SettingDropdown {
            width: (parent.width - parent.spacing) / 2
            settingKey: "rightClickAction"
            settingLabel: "Right click"
            fallbackValue: "Open Context Menu"
            settingOptions: behaviorTab.actionOptions
          }
        }

        Row {
          width: parent.width
          spacing: Style.space(10)

          SettingDropdown {
            width: (parent.width - parent.spacing) / 2
            settingKey: "middleClickAction"
            settingLabel: "Middle click"
            fallbackValue: "Do Nothing"
            settingOptions: behaviorTab.actionOptions
          }

          SettingDropdown {
            width: (parent.width - parent.spacing) / 2
            settingKey: "ctrlClickAction"
            settingLabel: "Ctrl + left click"
            fallbackValue: "Focus or Launch"
            settingOptions: behaviorTab.actionOptions
          }
        }

        Row {
          width: parent.width
          spacing: Style.space(10)

          SettingDropdown {
            width: (parent.width - parent.spacing) / 2
            settingKey: "shiftClickAction"
            settingLabel: "Shift + left click"
            fallbackValue: "Focus or Launch"
            settingOptions: behaviorTab.actionOptions
          }

          SettingDropdown {
            width: (parent.width - parent.spacing) / 2
            settingKey: "altClickAction"
            settingLabel: "Alt + left click"
            fallbackValue: "Focus or Launch"
            settingOptions: behaviorTab.actionOptions
          }
        }

        Text {
          width: parent.width
          text: "For combined modifiers, Ctrl takes priority over Shift, then Alt."
          color: Util.alpha(settingsPopup.contentForeground, 0.58)
          font.family: settingsPopup.contentFontFamily
          font.pixelSize: Style.font.caption
          wrapMode: Text.WordWrap
        }
      }

      Column {
        id: layoutSizeTab
        visible: settingsPopup.currentTab === 2
        width: parent.width
        spacing: Style.space(12)

        PanelSeparator { width: parent.width }
        PanelSectionHeader {
          width: parent.width
          text: "SIZE & SPACING"
          foreground: settingsPopup.contentForeground
          fontFamily: settingsPopup.contentFontFamily
        }

      Row {
        width: parent.width
        spacing: Style.space(10)

        SettingNumber {
          width: (parent.width - parent.spacing) / 2
          settingKey: "iconSize"
          settingLabel: "Icon size"
          fallbackValue: 18
          minimumValue: 8
          maximumValue: 32
        }

        SettingOptionalNumber {
          width: (parent.width - parent.spacing) / 2
          settingKey: "fontSize"
          settingLabel: "Font size"
          minimumValue: 8
          maximumValue: 24
          placeholder: "Auto"
        }
      }

      Row {
        width: parent.width
        spacing: Style.space(10)

        SettingNumber {
          width: (parent.width - parent.spacing) / 2
          settingKey: "itemHorizontalPadding"
          settingLabel: "Horizontal padding"
          fallbackValue: 8
          minimumValue: 0
          maximumValue: 24
        }

        SettingNumber {
          width: (parent.width - parent.spacing) / 2
          settingKey: "itemVerticalPadding"
          settingLabel: "Vertical padding"
          fallbackValue: 12
          minimumValue: 0
          maximumValue: 16
        }
      }

      Row {
        width: parent.width
        spacing: Style.space(10)

        SettingNumber {
          width: (parent.width - parent.spacing) / 2
          settingKey: "itemSpacing"
          settingLabel: "Item spacing"
          fallbackValue: 4
          minimumValue: 0
          maximumValue: 24
        }

        SettingNumber {
          width: (parent.width - parent.spacing) / 2
          settingKey: "iconLabelSpacing"
          settingLabel: "Icon / label gap"
          fallbackValue: 8
          minimumValue: 0
          maximumValue: 20
        }
      }

      SettingOptionalNumber {
        width: parent.width
        settingKey: "itemCornerRadius"
        settingLabel: "Item rounding"
        minimumValue: 0
        maximumValue: 32
        placeholder: "Theme"
      }

      }

      Column {
        id: appearanceTab
        visible: settingsPopup.currentTab === 3
        width: parent.width
        spacing: Style.space(12)

        PanelSeparator { width: parent.width }
        PanelSectionHeader {
          width: parent.width
          text: "ACTIVE ITEM"
          foreground: settingsPopup.contentForeground
          fontFamily: settingsPopup.contentFontFamily
        }

      Row {
        width: parent.width
        spacing: Style.space(10)
        readonly property real columnWidth: (width - spacing * 2) / 3

        Column {
          width: parent.columnWidth
          spacing: Style.space(8)

          Text {
            width: parent.width
            text: "NORMAL"
            color: settingsPopup.contentForeground
            font.family: settingsPopup.contentFontFamily
            font.pixelSize: Style.font.caption
            font.bold: true
          }

          SettingText {
            width: parent.width
            settingKey: "normalColor"
            settingLabel: "Foreground"
            placeholder: "Theme or #RRGGBB"
          }

          SettingText {
            width: parent.width
            settingKey: "normalBackgroundColor"
            settingLabel: "Background"
            placeholder: "Off or #RRGGBBAA"
          }

          SettingNumber {
            width: parent.width
            settingKey: "normalFontWeight"
            settingLabel: "Weight"
            fallbackValue: 400
            minimumValue: 1
            maximumValue: 1000
            stepValue: 50
          }

          SettingNumber {
            width: parent.width
            settingKey: "normalOpacity"
            settingLabel: "Opacity (%)"
            fallbackValue: 100
            minimumValue: 0
            maximumValue: 100
            stepValue: 5
          }
        }

        Column {
          width: parent.columnWidth
          spacing: Style.space(8)

          Text {
            width: parent.width
            text: "HOVER"
            color: settingsPopup.contentForeground
            font.family: settingsPopup.contentFontFamily
            font.pixelSize: Style.font.caption
            font.bold: true
          }

          SettingText {
            width: parent.width
            settingKey: "hoverColor"
            settingLabel: "Foreground"
            placeholder: "Normal or #RRGGBB"
          }

          SettingText {
            width: parent.width
            settingKey: "hoverBackgroundColor"
            settingLabel: "Background"
            placeholder: "Theme or #RRGGBBAA"
          }

          SettingNumber {
            width: parent.width
            settingKey: "hoverFontWeight"
            settingLabel: "Weight"
            fallbackValue: 500
            minimumValue: 1
            maximumValue: 1000
            stepValue: 50
          }

          SettingNumber {
            width: parent.width
            settingKey: "hoverOpacity"
            settingLabel: "Opacity (%)"
            fallbackValue: 100
            minimumValue: 0
            maximumValue: 100
            stepValue: 5
          }
        }

        Column {
          width: parent.columnWidth
          spacing: Style.space(8)

          Text {
            width: parent.width
            text: "ACTIVE"
            color: settingsPopup.contentForeground
            font.family: settingsPopup.contentFontFamily
            font.pixelSize: Style.font.caption
            font.bold: true
          }

          SettingText {
            width: parent.width
            settingKey: "activeColor"
            settingLabel: "Foreground"
            placeholder: "Theme or #RRGGBB"
          }

          SettingText {
            width: parent.width
            settingKey: "activeBackgroundColor"
            settingLabel: "Background"
            placeholder: "Active or #RRGGBBAA"
          }

          SettingNumber {
            width: parent.width
            settingKey: "activeFontWeight"
            settingLabel: "Weight"
            fallbackValue: 600
            minimumValue: 1
            maximumValue: 1000
            stepValue: 50
          }

          SettingNumber {
            width: parent.width
            settingKey: "activeOpacity"
            settingLabel: "Opacity (%)"
            fallbackValue: 100
            minimumValue: 0
            maximumValue: 100
            stepValue: 5
          }
        }
      }

      PanelSeparator { width: parent.width }
      PanelSectionHeader {
        width: parent.width
        text: "INDICATOR"
        foreground: settingsPopup.contentForeground
        fontFamily: settingsPopup.contentFontFamily
      }

      SettingDropdown {
        settingKey: "activeIndicator"
        settingLabel: "Indicator style"
        fallbackValue: "Underline"
        settingOptions: ["Underline", "Top", "Dot", "None"]
      }

      SettingText {
        settingKey: "indicatorColor"
        settingLabel: "Indicator color"
        placeholder: "Theme accent or #RRGGBB"
      }

      Row {
        width: parent.width
        spacing: Style.space(10)

        SettingNumber {
          width: (parent.width - parent.spacing) / 2
          settingKey: "indicatorThickness"
          settingLabel: "Line thickness"
          fallbackValue: 2
          minimumValue: 1
          maximumValue: 8
        }

        SettingNumber {
          width: (parent.width - parent.spacing) / 2
          settingKey: "indicatorSize"
          settingLabel: "Dot size"
          fallbackValue: 4
          minimumValue: 2
          maximumValue: 16
        }
      }

      Row {
        width: parent.width
        spacing: Style.space(10)

        SettingNumber {
          width: (parent.width - parent.spacing) / 2
          settingKey: "indicatorLength"
          settingLabel: "Line length (0 = auto)"
          fallbackValue: 0
          minimumValue: 0
          maximumValue: 80
        }

        SettingNumber {
          width: (parent.width - parent.spacing) / 2
          settingKey: "indicatorMargin"
          settingLabel: "Edge margin"
          fallbackValue: 2
          minimumValue: 0
          maximumValue: 12
        }
      }

      }

      Column {
        id: layoutFilterTab
        visible: settingsPopup.currentTab === 2
        width: parent.width
        spacing: Style.space(12)

        PanelSeparator { width: parent.width }
        PanelSectionHeader {
          width: parent.width
          text: "SEPARATORS & FILTERS"
          foreground: settingsPopup.contentForeground
          fontFamily: settingsPopup.contentFontFamily
        }

      SettingToggle {
        settingKey: "leadingSeparator"
        settingLabel: "Leading separator"
        fallbackValue: false
      }

      SettingToggle {
        settingKey: "sectionSeparator"
        settingLabel: "Pinned / running separator"
        fallbackValue: true
      }

      SettingText {
        settingKey: "excludedClasses"
        settingLabel: "Excluded classes"
        placeholder: "Comma-separated regular expressions"
      }

      Rectangle {
        width: parent.width
        implicitHeight: pinHint.implicitHeight + Style.space(20)
        radius: Math.max(2, Style.cornerRadius)
        color: Style.hoverFillFor(settingsPopup.contentForeground, Color.accent)

        Text {
          id: pinHint
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.verticalCenter: parent.verticalCenter
          anchors.leftMargin: Style.space(10)
          anchors.rightMargin: Style.space(10)
          text: "Pinned applications are managed from each app's right-click menu."
          color: settingsPopup.contentForeground
          font.family: settingsPopup.contentFontFamily
          font.pixelSize: Style.font.caption
          wrapMode: Text.WordWrap
        }
      }

      }

      Item { width: 1; height: Style.space(2) }
    }
  }

  component SettingToggle: Toggle {
    required property string settingKey
    required property string settingLabel
    property string settingDescription: ""
    property bool fallbackValue: false

    width: settingsColumn.width
    label: settingLabel
    description: settingDescription
    checked: settingsPopup.boolValue(settingKey, fallbackValue)
    foreground: settingsPopup.contentForeground
    accent: Color.accent
    fontFamily: settingsPopup.contentFontFamily
    onClicked: settingsPopup.change(settingKey, !checked)
  }

  component SettingDropdown: Dropdown {
    required property string settingKey
    required property string settingLabel
    required property var settingOptions
    property string fallbackValue: ""

    width: settingsColumn.width
    label: settingLabel
    value: settingsPopup.stringValue(settingKey, fallbackValue)
    options: settingOptions
    foreground: settingsPopup.contentForeground
    background: Color.popups.background
    popupBorder: Color.popups.border
    accent: Color.accent
    fontFamily: settingsPopup.contentFontFamily
    onChanged: function(nextValue) { settingsPopup.change(settingKey, nextValue) }
  }

  component SettingNumber: NumberField {
    required property string settingKey
    required property string settingLabel
    required property int fallbackValue
    required property int minimumValue
    required property int maximumValue
    property int stepValue: 1

    label: settingLabel
    value: Math.round(settingsPopup.numberValue(settingKey, fallbackValue))
    from: minimumValue
    to: maximumValue
    stepSize: stepValue
    fieldWidth: width
    foreground: settingsPopup.contentForeground
    accent: Color.accent
    fontFamily: settingsPopup.contentFontFamily
    onModified: function(nextValue) { settingsPopup.change(settingKey, nextValue) }
  }

  component SettingOptionalNumber: Column {
    required property string settingKey
    required property string settingLabel
    required property int minimumValue
    required property int maximumValue
    property string placeholder: "Auto"

    spacing: Style.spacing.md

    Text {
      width: parent.width
      text: parent.settingLabel
      color: Qt.darker(settingsPopup.contentForeground, 1.4)
      font.family: settingsPopup.contentFontFamily
      font.pixelSize: Style.font.bodySmall
    }

    TextField {
      width: parent.width
      text: {
        var current = settingsPopup.value(parent.settingKey, "")
        return current === undefined || current === null ? "" : String(current).trim()
      }
      placeholderText: parent.placeholder
      foreground: settingsPopup.contentForeground
      accent: Color.accent
      font.family: settingsPopup.contentFontFamily
      horizontalAlignment: TextInput.AlignHCenter
      inputMethodHints: Qt.ImhDigitsOnly
      maximumLength: String(parent.maximumValue).length
      onTextEdited: {
        if (text.trim() === "") settingsPopup.change(parent.settingKey, "")
      }
      onEditingFinished: {
        var nextValue = text.trim()
        if (nextValue === "") {
          settingsPopup.change(parent.settingKey, "")
          return
        }

        var parsed = Number(nextValue)
        if (isNaN(parsed)) {
          text = ""
          settingsPopup.change(parent.settingKey, "")
          return
        }

        var clamped = Math.max(parent.minimumValue,
          Math.min(parent.maximumValue, Math.round(parsed)))
        text = String(clamped)
        settingsPopup.change(parent.settingKey, String(clamped))
      }
    }
  }

  component SettingText: Column {
    required property string settingKey
    required property string settingLabel
    property string fallbackValue: ""
    property string placeholder: ""

    width: settingsColumn.width
    spacing: Style.space(5)

    Text {
      width: parent.width
      text: parent.settingLabel
      color: Util.alpha(settingsPopup.contentForeground, 0.72)
      font.family: settingsPopup.contentFontFamily
      font.pixelSize: Style.font.caption
      font.bold: true
    }

    TextField {
      width: parent.width
      text: settingsPopup.stringValue(parent.settingKey, parent.fallbackValue)
      placeholderText: parent.placeholder
      foreground: settingsPopup.contentForeground
      accent: Color.accent
      font.family: settingsPopup.contentFontFamily
      onEditingFinished: settingsPopup.change(parent.settingKey, text.trim())
    }
  }
}
