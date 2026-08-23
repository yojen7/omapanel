import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Hyprland
import qs.Commons
import qs.Ui

BarWidget {
  id: taskbar

  moduleName: "atagulalan.omapanel"

  readonly property string defaultPinnedApps: '[{"label":"Zen","match":"^zen$","launch":"omarchy-launch-browser","icon":"zen-browser","desktopId":"zen"},{"label":"Cursor","match":"^cursor$","launch":"uwsm-app -- cursor","icon":"co.anysphere.cursor","desktopId":"cursor"}]'
  readonly property var pinnedApps: parsePinnedApps(setting("pinnedApps", defaultPinnedApps))
  readonly property bool showRunning: setting("showRunning", true) === true
  readonly property bool groupRunningByWorkspace: setting("groupRunningByWorkspace", true) === true
  readonly property bool showIcons: setting("showIcons", true) === true
  readonly property bool invertIconColors: setting("invertIconColors", false) === true
  readonly property bool showLabels: setting("showLabels", true) === true
  readonly property bool iconOnlyWhenClosed: setting("iconOnlyWhenClosed", true) === true
  readonly property string leftClickAction: normalizedClickAction(
    setting("leftClickAction", "Focus or Launch"), "Focus or Launch")
  readonly property string rightClickAction: normalizedClickAction(
    setting("rightClickAction", "Open Context Menu"), "Open Context Menu")
  readonly property string middleClickAction: normalizedClickAction(
    setting("middleClickAction", "Do Nothing"), "Do Nothing")
  readonly property string ctrlClickAction: normalizedClickAction(
    setting("ctrlClickAction", "Focus or Launch"), "Focus or Launch")
  readonly property string shiftClickAction: normalizedClickAction(
    setting("shiftClickAction", "Focus or Launch"), "Focus or Launch")
  readonly property string altClickAction: normalizedClickAction(
    setting("altClickAction", "Focus or Launch"), "Focus or Launch")
  readonly property string labelFormat: String(setting("labelFormat", "[APP_NAME] - [WINDOW_TITLE]"))
  readonly property string widthMode: String(setting("widthMode", "Adaptive"))
  readonly property int fixedItemWidth: Math.max(24, Number(setting("fixedItemWidth", 160)))
  readonly property int maxAdaptiveWidth: Math.max(24, Number(setting("maxAdaptiveWidth", 280)))
  readonly property string activeIndicator: String(setting("activeIndicator", "Underline"))
  readonly property int itemSpacing: Math.max(0, Number(setting("itemSpacing", 4)))
  readonly property int itemHorizontalPadding: Math.max(0, Number(setting("itemHorizontalPadding", 8)))
  readonly property int itemVerticalPadding: Math.max(0, Number(setting("itemVerticalPadding", 12)))
  readonly property real itemCornerRadius: resolvedItemCornerRadius(setting("itemCornerRadius", ""))
  readonly property int iconLabelSpacing: Math.max(0, Number(setting("iconLabelSpacing", 8)))
  readonly property int iconSize: Math.max(8, Number(setting("iconSize", 18)))
  readonly property int automaticFontSize: Math.max(1, Math.round(Style.font.body))
  readonly property int fontSize: resolvedFontSize(setting("fontSize", ""))
  readonly property int normalFontWeight: Math.max(1, Math.min(1000, Number(setting("normalFontWeight", 400))))
  readonly property int hoverFontWeight: Math.max(1, Math.min(1000, Number(setting("hoverFontWeight", 500))))
  readonly property int activeFontWeight: Math.max(1, Math.min(1000, Number(setting("activeFontWeight", 600))))
  readonly property real normalOpacity: resolvedOpacity(setting("normalOpacity", 100))
  readonly property real hoverOpacity: resolvedOpacity(setting("hoverOpacity", 100))
  readonly property real activeOpacity: resolvedOpacity(setting("activeOpacity", 100))
  readonly property color normalTextColor: configuredColor(setting("normalColor", ""),
    bar ? bar.barForeground : Color.foreground)
  readonly property string normalBackgroundValue: String(setting("normalBackgroundColor", "")).trim()
  readonly property bool normalBackgroundEnabled: normalBackgroundValue.length > 0
  readonly property color normalBackgroundColor: configuredColor(
    normalBackgroundValue, Style.normalFillFor(normalTextColor, Color.accent))
  readonly property color activeTextColor: configuredColor(setting("activeColor", ""),
    bar ? bar.barForeground : Color.foreground)
  readonly property color hoverTextColor: configuredColor(setting("hoverColor", ""),
    normalTextColor)
  readonly property color hoverBackgroundColor: configuredColor(
    setting("hoverBackgroundColor", ""), Style.hoverFillFor(hoverTextColor, Color.accent))
  readonly property color activeHoverBackgroundColor: Style.hoverFillFor(
    activeTextColor, Color.accent)
  readonly property string activeBackgroundValue: String(setting("activeBackgroundColor", "")).trim()
  readonly property bool activeBackgroundEnabled: activeBackgroundValue.length > 0
  readonly property color activeBackgroundColor: configuredColor(
    activeBackgroundValue, activeHoverBackgroundColor)
  readonly property color indicatorColor: configuredColor(setting("indicatorColor", ""), Color.accent)
  readonly property int indicatorThickness: Math.max(1, Number(setting("indicatorThickness", 2)))
  readonly property int indicatorSize: Math.max(2, Number(setting("indicatorSize", 4)))
  readonly property int indicatorLength: Math.max(0, Number(setting("indicatorLength", 0)))
  readonly property int indicatorMargin: Math.max(0, Number(setting("indicatorMargin", 2)))
  readonly property bool leadingSeparator: setting("leadingSeparator", false) === true
  readonly property bool sectionSeparator: setting("sectionSeparator", true) === true
  readonly property int maxLabelLength: Math.max(4, Number(setting("maxLabelLength", 14)))
  readonly property int maxRunningWindows: Math.max(1, Number(setting("maxRunningWindows", 12)))
  readonly property int maxUntrustedTextLength: 512
  readonly property int maxClassLength: 96
  readonly property int maxRegexPatternLength: 256
  readonly property int maxLaunchLength: 4096
  readonly property int maxIconLength: 512
  readonly property int maxDesktopIdLength: 128
  readonly property string fallbackIconName: "application-x-executable"
  readonly property string excludedClasses: String(setting("excludedClasses", ""))
  readonly property var activeWindow: Hyprland.activeToplevel
  property int hyprlandRevision: 0
  property real groupWheelAccumulator: 0
  property string groupWheelKey: ""
  property string groupWheelCursorAddress: ""
  property double groupWheelCursorDeadline: 0
  property bool contextMenuOpen: false
  property bool settingsPanelOpen: false
  property Item contextAnchor: null
  property var contextApp: null
  property var contextWindow: null
  readonly property bool opened: contextMenuOpen || settingsPanelOpen
  readonly property var contextWindows: windowsForDescriptor(contextApp, contextWindow)
  readonly property var contextEntry: desktopEntryFor(contextApp, contextWindow)
  readonly property var contextActions: {
    var actions = contextEntry && contextEntry.actions ? contextEntry.actions : []
    return actions.filter(function(action) {
      return action && String(action.id || "").toLowerCase() !== "new-window"
    })
  }
  readonly property int contextPinnedIndex: pinnedIndex(contextApp, contextWindow)
  readonly property bool contextIsPinned: contextPinnedIndex >= 0
  readonly property bool contextCanLaunch: !!(contextEntry || (contextApp && contextApp.launch))

  readonly property var pinnedItems: {
    var revision = hyprlandRevision
    var result = []

    for (var i = 0; i < pinnedApps.length; i++) {
      var app = pinnedApps[i]
      var windows = windowsForDescriptor(app, null)
      if (windows.length === 0) {
        result.push({ app: app, window: null })
        continue
      }
      for (var j = 0; j < windows.length; j++) {
        result.push({ app: app, window: windows[j] })
      }
    }
    return result
  }

  readonly property var runningWindows: {
    var revision = hyprlandRevision
    var values = Hyprland.toplevels && Hyprland.toplevels.values
      ? Hyprland.toplevels.values : []
    var result = []

    if (!showRunning) return result

    for (var i = 0; i < values.length; i++) {
      var candidate = values[i]
      if (!candidate || !windowClass(candidate)) continue
      if (isPinnedWindow(candidate) || isExcludedWindow(candidate)) continue
      result.push(candidate)
    }

    if (groupRunningByWorkspace) {
      result = result.map(function(window, index) {
        return { window: window, originalIndex: index }
      }).sort(function(left, right) {
        var workspaceDifference = windowWorkspaceId(left.window) - windowWorkspaceId(right.window)
        return workspaceDifference !== 0
          ? workspaceDifference : left.originalIndex - right.originalIndex
      }).map(function(entry) {
        return entry.window
      })
    }

    return result.slice(0, maxRunningWindows)
  }

  visible: !vertical && (pinnedApps.length > 0 || runningWindows.length > 0)
  implicitWidth: visible ? content.implicitWidth : 0
  implicitHeight: barSize

  Behavior on implicitWidth {
    NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
  }

  function resolvedFontSize(rawValue) {
    if (rawValue === undefined || rawValue === null
        || String(rawValue).trim() === "") {
      return automaticFontSize
    }

    var parsed = Number(rawValue)
    return isNaN(parsed)
      ? automaticFontSize : Math.max(8, Math.min(24, Math.round(parsed)))
  }

  function resolvedOpacity(rawValue) {
    var parsed = Number(rawValue)
    return isNaN(parsed) ? 1 : Math.max(0, Math.min(100, parsed)) / 100
  }

  function resolvedItemCornerRadius(rawValue) {
    if (rawValue === undefined || rawValue === null
        || String(rawValue).trim() === "") {
      return Math.max(2, Style.cornerRadius)
    }

    var parsed = Number(rawValue)
    return isNaN(parsed)
      ? Math.max(2, Style.cornerRadius) : Math.max(0, Math.min(32, Math.round(parsed)))
  }

  function normalizedClickAction(value, fallback) {
    var action = String(value || "")
    var allowed = [
      "Focus or Launch", "Open Context Menu", "New Window", "Close Window",
      "Close All Windows", "Toggle Pin", "Open Settings", "Do Nothing"
    ]
    return allowed.indexOf(action) >= 0 ? action : fallback
  }

  function parsePinnedApps(raw) {
    var parsed = raw

    if (typeof raw === "string") {
      try {
        parsed = JSON.parse(raw)
      } catch (exception) {
        console.warn("atagulalan.omapanel: pinnedApps is not valid JSON", exception)
        parsed = []
      }
    }

    if (!Array.isArray(parsed)) return []

    return parsed.filter(function(app) {
      return app && typeof app === "object"
        && String(app.label || "").trim() !== ""
        && String(app.match || "").trim() !== ""
    }).map(function(app) {
      return {
        label: asPlainUiText(String(app.label || "App").trim()) || "App",
        match: String(app.match || "").trim(),
        launch: clampedLaunch(app.launch),
        icon: sanitizeIconName(app.icon),
        desktopId: normalizeDesktopId(app.desktopId)
      }
    })
  }

  // Qt Text defaults to AutoText (mightBeRichText). Untrusted Hyprland titles /
  // app names must never be parsed as HTML, including in bar tooltips we do
  // not control. Replace angle brackets so tags like <img src="…"> stay literal.
  function asPlainUiText(value) {
    var text = String(value || "")
    if (text.length > maxUntrustedTextLength)
      text = text.slice(0, maxUntrustedTextLength)
    return text
      .replace(/[\u0000-\u0008\u000B\u000C\u000E-\u001F]/g, "")
      .replace(/[\r\n]+/g, " ")
      .replace(/&lt;/gi, "\uFF1C")
      .replace(/&gt;/gi, "\uFF1E")
      .replace(/&#0*60;?/gi, "\uFF1C")
      .replace(/&#x0*3c;?/gi, "\uFF1C")
      .replace(/</g, "\uFF1C")
      .replace(/>/g, "\uFF1E")
  }

  function sanitizeClassValue(value) {
    var text = String(value || "").replace(/[\u0000-\u001F]/g, "").trim()
    if (text.length > maxClassLength) text = text.slice(0, maxClassLength)
    return text
  }

  function isPlausibleAppId(value) {
    return /^[A-Za-z0-9][A-Za-z0-9._-]*$/.test(String(value || ""))
  }

  function normalizeDesktopId(value) {
    var text = String(value || "").trim()
    if (text.slice(-8).toLowerCase() === ".desktop") text = text.slice(0, -8)
    if (!text || text.length > maxDesktopIdLength) return ""
    if (text.indexOf("..") >= 0 || /[\\/]/.test(text)) return ""
    return isPlausibleAppId(text) ? text : ""
  }

  function clampedLaunch(value) {
    var text = String(value || "").trim()
    if (text.length > maxLaunchLength) text = text.slice(0, maxLaunchLength)
    return text
  }

  function isRemoteIconSource(value) {
    var text = String(value || "").trim()
    if (!text || text.length > maxIconLength) return true
    if (/[\u0000-\u001F]/.test(text)) return true
    var lower = text.toLowerCase()
    if (/^(https?|ftp|ftps|sftp|data|mailto|smb|nfs|webdav|qrc):/.test(lower)) return true
    if (lower.indexOf("file:") === 0 && lower.indexOf("file:///") !== 0) return true
    return false
  }

  function sanitizeIconName(icon) {
    var value = String(icon || "").trim()
    if (!value || isRemoteIconSource(value)) return fallbackIconName
    if (value.indexOf("image://") === 0) return value.slice(0, maxIconLength)
    if (value.indexOf("file:///") === 0 || value.charAt(0) === "/") {
      if (value.indexOf("..") >= 0) return fallbackIconName
      return value.slice(0, maxIconLength)
    }
    if (value.indexOf("/") >= 0 || value.indexOf(":") >= 0) return fallbackIconName
    return value.slice(0, maxIconLength)
  }

  function fallbackIconSource() {
    return Quickshell.iconPath(fallbackIconName, true)
  }

  function isUnsafeClassPattern(pattern) {
    if (!pattern || pattern.length > maxRegexPatternLength) return true
    if (/\{\s*\d{3,}/.test(pattern)) return true
    if (/\((?:[^()]*[+*][^()]*)\)[+*?]/.test(pattern)) return true
    return false
  }

  function windowCandidates(toplevel) {
    if (!toplevel) return []
    var ipc = toplevel.lastIpcObject || null
    var wayland = toplevel.wayland || null
    return [
      ipc && ipc.class ? ipc.class : "",
      ipc && ipc.initialClass ? ipc.initialClass : "",
      wayland && wayland.appId ? wayland.appId : ""
    ].map(function(value) {
      return sanitizeClassValue(value)
    }).filter(function(value) {
      return value !== ""
    })
  }

  function patternMatches(pattern, values) {
    var source = String(pattern || "").trim()
    if (!source || isUnsafeClassPattern(source)) {
      if (source) console.warn("atagulalan.omapanel: rejected class pattern", source)
      return false
    }
    try {
      var matcher = new RegExp(source, "i")
      for (var i = 0; i < values.length; i++) {
        if (matcher.test(values[i])) return true
      }
    } catch (exception) {
      console.warn("atagulalan.omapanel: invalid class pattern", source, exception)
    }
    return false
  }

  function appMatchesWindow(app, toplevel) {
    if (!app || !patternMatches(String(app.match || ""), windowCandidates(toplevel)))
      return false

    // When a pin declares desktopId, refuse windows whose resolved desktop entry
    // is a different app (limits broad regex + wrong Electron/.desktop pairing).
    var expected = normalizeDesktopId(app.desktopId)
    if (!expected) return true
    var entry = windowDesktopEntry(toplevel)
    if (!entry) return true
    var actual = normalizeDesktopId(entry.id)
    if (!actual) return true
    return actual === expected
  }

  function isPinnedWindow(toplevel) {
    for (var i = 0; i < pinnedApps.length; i++) {
      if (appMatchesWindow(pinnedApps[i], toplevel)) return true
    }
    return false
  }

  function isExcludedWindow(toplevel) {
    if (!excludedClasses.trim()) return false
    var patterns = excludedClasses.split(",")
    var candidates = windowCandidates(toplevel)
    for (var i = 0; i < patterns.length; i++) {
      if (patternMatches(patterns[i].trim(), candidates)) return true
    }
    return false
  }

  function windowClass(toplevel) {
    var candidates = windowCandidates(toplevel)
    return candidates.length > 0 ? candidates[0] : ""
  }

  function windowWorkspaceId(toplevel) {
    var ipc = toplevel ? (toplevel.lastIpcObject || null) : null
    var workspace = ipc ? (ipc.workspace || null) : null
    var id = workspace ? Number(workspace.id) : 0
    return isNaN(id) ? 0 : id
  }

  function startsWorkspaceGroup(index, toplevel) {
    if (!groupRunningByWorkspace || index <= 0) return false
    return windowWorkspaceId(toplevel) !== windowWorkspaceId(runningWindows[index - 1])
  }

  function windowDesktopEntry(toplevel) {
    var candidates = windowCandidates(toplevel)
    for (var i = 0; i < candidates.length; i++) {
      if (!isPlausibleAppId(candidates[i])) continue
      var entry = DesktopEntries.heuristicLookup(candidates[i])
      if (entry) return entry
    }
    return null
  }

  function windowLabel(toplevel) {
    var entry = windowDesktopEntry(toplevel)
    if (entry && entry.name) return asPlainUiText(String(entry.name))

    var ipc = toplevel ? (toplevel.lastIpcObject || null) : null
    var tags = ipc && Array.isArray(ipc.tags) ? ipc.tags : []
    for (var i = 0; i < tags.length; i++) {
      if (String(tags[i]).indexOf("terminal") === 0) return "Terminal"
    }

    var appClass = windowClass(toplevel)
    if (appClass) {
      var pieces = appClass.split(".")
      var value = pieces[pieces.length - 1].replace(/[-_]+/g, " ")
      return asPlainUiText(value.charAt(0).toUpperCase() + value.slice(1))
    }

    return windowTitle(toplevel) || "Window"
  }

  function windowTitle(toplevel) {
    if (!toplevel) return ""

    var directTitle = toplevel.title ? String(toplevel.title).trim() : ""
    if (directTitle) return asPlainUiText(directTitle)

    var ipc = toplevel.lastIpcObject || null
    return ipc && ipc.title ? asPlainUiText(String(ipc.title).trim()) : ""
  }

  function windowIcon(toplevel) {
    var entry = windowDesktopEntry(toplevel)
    return sanitizeIconName(entry && entry.icon ? entry.icon : fallbackIconName)
  }

  function regexEscape(value) {
    return String(value || "").replace(/[.*+?^${}()|[\]\\]/g, "\\$&")
  }

  function launchCommandForDesktopId(desktopId) {
    var id = normalizeDesktopId(desktopId)
    if (!id) return ""
    return "uwsm-app -- gtk-launch " + Util.shellQuote(id + ".desktop")
  }

  function descriptorFor(app, toplevel) {
    if (app) return {
      label: asPlainUiText(String(app.label || windowLabel(toplevel) || "App")) || "App",
      match: String(app.match || ""),
      launch: clampedLaunch(app.launch),
      icon: sanitizeIconName(app.icon || windowIcon(toplevel) || fallbackIconName),
      desktopId: normalizeDesktopId(app.desktopId)
    }

    var entry = windowDesktopEntry(toplevel)
    var appClass = windowClass(toplevel)
    var desktopId = normalizeDesktopId(entry ? entry.id : "")
    return {
      label: windowLabel(toplevel),
      match: appClass ? "^" + regexEscape(appClass) + "$" : "",
      launch: launchCommandForDesktopId(desktopId),
      icon: sanitizeIconName(entry && entry.icon ? entry.icon : windowIcon(toplevel)),
      desktopId: desktopId
    }
  }

  function desktopEntryFor(app, toplevel) {
    var desktopId = normalizeDesktopId(app && app.desktopId ? app.desktopId : "")
    if (desktopId) {
      var byId = DesktopEntries.byId(desktopId)
        || DesktopEntries.byId(desktopId + ".desktop")
      if (byId) return byId
    }

    if (toplevel) {
      var matched = windowDesktopEntry(toplevel)
      if (matched) return matched
    }

    if (!app || !app.label) return null
    var label = String(app.label || "").trim()
    return isPlausibleAppId(label) ? DesktopEntries.heuristicLookup(label) : null
  }

  function windowsForDescriptor(app, toplevel) {
    var revision = hyprlandRevision
    var descriptor = descriptorFor(app, toplevel)
    var values = Hyprland.toplevels && Hyprland.toplevels.values
      ? Hyprland.toplevels.values : []
    var result = []

    for (var i = 0; i < values.length; i++) {
      if (appMatchesWindow(descriptor, values[i])) result.push(values[i])
    }
    return result
  }

  function sameToplevel(left, right) {
    if (!left || !right) return false
    if (left === right) return true
    var leftAddress = normalizedAddress(left)
    var rightAddress = normalizedAddress(right)
    return leftAddress !== "" && leftAddress === rightAddress
  }

  function indexOfToplevel(windows, target) {
    for (var i = 0; i < windows.length; i++) {
      if (sameToplevel(windows[i], target)) return i
    }
    return -1
  }

  function wheelGroup(app, toplevel, pinned) {
    if (!toplevel) return { key: "", windows: [] }

    if (pinned) {
      var descriptor = descriptorFor(app, toplevel)
      return {
        key: "pinned:" + descriptor.match + ":" + descriptor.desktopId,
        windows: windowsForDescriptor(app, toplevel)
      }
    }

    if (!groupRunningByWorkspace) return { key: "", windows: [] }

    var workspaceId = windowWorkspaceId(toplevel)
    return {
      key: "workspace:" + workspaceId,
      windows: runningWindows.filter(function(candidate) {
        return windowWorkspaceId(candidate) === workspaceId
      })
    }
  }

  function resetGroupWheel() {
    groupWheelAccumulator = 0
    groupWheelKey = ""
    groupWheelCursorAddress = ""
    groupWheelCursorDeadline = 0
  }

  function cycleWindowGroup(app, toplevel, pinned, delta) {
    var group = wheelGroup(app, toplevel, pinned)
    if (group.windows.length === 0) {
      resetGroupWheel()
      return false
    }

    if (groupWheelKey !== group.key) {
      groupWheelAccumulator = 0
      groupWheelKey = group.key
      groupWheelCursorAddress = ""
      groupWheelCursorDeadline = 0
    }

    var wheel = Util.wheelSteps(groupWheelAccumulator, delta)
    groupWheelAccumulator = wheel.remainder
    if (wheel.steps === 0) return true

    var now = Date.now()
    var step = wheel.steps > 0 ? -1 : 1
    var cursorIndex = now <= groupWheelCursorDeadline
      ? group.windows.map(function(window) {
          return normalizedAddress(window)
        }).indexOf(groupWheelCursorAddress)
      : -1
    var activeIndex = indexOfToplevel(group.windows, activeWindow)
    var hoveredIndex = indexOfToplevel(group.windows, toplevel)
    var nextIndex

    if (cursorIndex >= 0) {
      nextIndex = (cursorIndex + step + group.windows.length) % group.windows.length
    } else if (activeIndex >= 0) {
      nextIndex = (activeIndex + step + group.windows.length) % group.windows.length
    } else {
      // Entering an inactive group selects exactly the chip under the pointer.
      // The following wheel step advances from this remembered cursor even if
      // Hyprland has not published the focus change yet.
      nextIndex = hoveredIndex >= 0 ? hoveredIndex : 0
    }

    groupWheelCursorAddress = normalizedAddress(group.windows[nextIndex])
    groupWheelCursorDeadline = now + 750
    activateOrLaunch(app, group.windows[nextIndex])
    return true
  }

  function pinnedIndex(app, toplevel) {
    var descriptor = descriptorFor(app, toplevel)
    for (var i = 0; i < pinnedApps.length; i++) {
      if (descriptor.match === pinnedApps[i].match) return i
      if (toplevel && appMatchesWindow(pinnedApps[i], toplevel)) return i
    }
    return -1
  }

  function resolveIconSource(icon) {
    var value = sanitizeIconName(icon)
    var resolved = ""
    if (bar && bar.shell && bar.shell.appLibrary)
      resolved = String(bar.shell.appLibrary.iconSource(value) || "")
    else if (value.indexOf("file://") === 0 || value.indexOf("image://") === 0)
      resolved = value
    else if (value.charAt(0) === "/")
      resolved = Util.fileUrl(value)
    else
      resolved = Quickshell.iconPath(value || fallbackIconName, true)

    if (!resolved || isRemoteIconSource(resolved)) return fallbackIconSource()
    return resolved
  }

  function shortenedLabel(label) {
    var value = String(label || "App")
    if (value.length <= maxLabelLength) return value
    return value.slice(0, Math.max(1, maxLabelLength - 1)) + "…"
  }

  function configuredColor(value, fallback) {
    var candidate = String(value || "").trim()
    if (!candidate) return fallback
    if (/^#[0-9a-f]{6}$/i.test(candidate)) return candidate
    if (/^#[0-9a-f]{8}$/i.test(candidate)) {
      return "#" + candidate.slice(7, 9) + candidate.slice(1, 7)
    }
    console.warn("atagulalan.omapanel: invalid color; use #RRGGBB or #RRGGBBAA", candidate)
    return fallback
  }

  function formattedWindowLabel(appName, toplevel) {
    var app = asPlainUiText(String(appName || "App").trim()) || "App"
    var title = windowTitle(toplevel)
    var format = String(labelFormat || "").trim() || "[APP_NAME]"
    if (format.length > maxUntrustedTextLength)
      format = format.slice(0, maxUntrustedTextLength)

    if (!title) return app

    var result = asPlainUiText(format
      .replace(/\[APP_NAME\]/gi, app)
      .replace(/\[WINDOW_TITLE\]/gi, title)
      .trim())
    return result || app
  }

  function normalizedAddress(toplevel) {
    if (!toplevel || !toplevel.address) return ""
    var address = String(toplevel.address).trim()
    if (address.indexOf("0x") === 0 || address.indexOf("0X") === 0)
      address = "0x" + address.slice(2)
    else
      address = "0x" + address
    if (!/^0x[0-9a-fA-F]{1,16}$/.test(address)) return ""
    return address.toLowerCase()
  }

  function runLaunch(command) {
    var value = clampedLaunch(command)
    if (!value || !bar) return
    bar.run(value)
  }

  function activateOrLaunch(app, toplevel) {
    if (toplevel) {
      var address = normalizedAddress(toplevel)
      if (address) {
        Quickshell.execDetached([
          "hyprctl",
          "dispatch",
          "hl.dsp.focus({ window = " + JSON.stringify("address:" + address) + " })"
        ])
        return
      }
    }
    if (app && app.launch) runLaunch(app.launch)
  }

  function launchNewWindow(app, toplevel) {
    var descriptor = descriptorFor(app, toplevel)
    var entry = desktopEntryFor(descriptor, toplevel)
    if (entry && bar && bar.shell && bar.shell.appLibrary) {
      var id = normalizeDesktopId(entry.id || descriptor.desktopId)
      if (id) {
        bar.shell.appLibrary.launch(
          id, asPlainUiText(String(entry.name || descriptor.label || id)))
        return
      }
    }
    if (descriptor.launch) runLaunch(descriptor.launch)
  }

  function clickAction(button, modifiers) {
    if (button === Qt.LeftButton) {
      if (modifiers & Qt.ControlModifier) return ctrlClickAction
      if (modifiers & Qt.ShiftModifier) return shiftClickAction
      if (modifiers & Qt.AltModifier) return altClickAction
      return leftClickAction
    }
    if (button === Qt.RightButton) return rightClickAction
    if (button === Qt.MiddleButton) return middleClickAction
    return "Do Nothing"
  }

  function performClickAction(action, app, toplevel, anchor) {
    if (anchor && anchor.bar) anchor.bar.hideTooltip(anchor)
    if (action === "Do Nothing") return
    if (action === "Open Context Menu") {
      openContextMenu(anchor, app, toplevel)
      return
    }
    if (action === "Open Settings") {
      contextAnchor = anchor
      openSettingsPanel()
      return
    }
    if (action === "Toggle Pin") {
      close()
      togglePinFor(app, toplevel)
      return
    }

    close()
    if (action === "Focus or Launch") {
      activateOrLaunch(app, toplevel)
    } else if (action === "New Window") {
      launchNewWindow(app, toplevel)
    } else if (action === "Close Window") {
      closeWindow(toplevel)
    } else if (action === "Close All Windows") {
      var targets = windowsForDescriptor(app, toplevel)
      for (var i = 0; i < targets.length; i++) closeWindow(targets[i])
    }
  }

  function handleConfiguredClick(app, toplevel, anchor, button, modifiers) {
    performClickAction(clickAction(button, modifiers), app, toplevel, anchor)
  }

  function openContextMenu(anchor, app, toplevel) {
    settingsPanelOpen = false
    contextAnchor = anchor
    contextApp = descriptorFor(app, toplevel)
    contextWindow = toplevel
    contextMenuOpen = true
  }

  function close() {
    contextMenuOpen = false
    settingsPanelOpen = false
  }

  function openSettingsPanel() {
    contextMenuOpen = false
    Qt.callLater(function() { settingsPanelOpen = true })
  }

  function persistSetting(key, value) {
    if (!bar || !bar.shell || typeof bar.shell.updateEntryInline !== "function") return
    var nextSettings = Object.assign({}, settings || {})
    nextSettings[key] = value
    settings = nextSettings
    bar.shell.updateEntryInline(moduleName, nextSettings)
  }

  function defaultSettings() {
    var registry = bar ? bar.barWidgetRegistry : null
    var metadata = registry && typeof registry.metadataFor === "function"
      ? registry.metadataFor(moduleName) : null
    var defaults = metadata && metadata.defaults ? metadata.defaults : ({})
    return Object.assign({}, defaults)
  }

  function resetSettings() {
    if (!bar || !bar.shell || typeof bar.shell.updateEntryInline !== "function") return
    var defaults = defaultSettings()
    settings = defaults
    bar.shell.updateEntryInline(moduleName, defaults)
  }

  function persistPinnedApps(apps) {
    if (!bar || !bar.shell || typeof bar.shell.updateEntryInline !== "function") return
    var nextSettings = Object.assign({}, settings || {})
    nextSettings.pinnedApps = JSON.stringify(apps.map(function(app) {
      return descriptorFor(app, null)
    }))
    settings = nextSettings
    bar.shell.updateEntryInline(moduleName, nextSettings)
  }

  function togglePinFor(app, toplevel) {
    var next = pinnedApps.slice()
    var descriptor = descriptorFor(app, toplevel)
    var index = pinnedIndex(descriptor, toplevel)
    if (index >= 0) next.splice(index, 1)
    else if (descriptor.match) next.push(descriptor)
    persistPinnedApps(next)
  }

  function toggleContextPin() {
    var app = contextApp
    var toplevel = contextWindow
    close()
    togglePinFor(app, toplevel)
  }

  function launchContextNewWindow() {
    var app = contextApp
    var toplevel = contextWindow
    close()
    launchNewWindow(app, toplevel)
  }

  function executeDesktopAction(action) {
    close()
    if (!action || typeof action.execute !== "function") return
    if (!contextEntry || !contextEntry.actions) return
    var allowed = false
    for (var i = 0; i < contextEntry.actions.length; i++) {
      if (contextEntry.actions[i] === action) {
        allowed = true
        break
      }
    }
    if (!allowed) return
    action.execute()
  }

  function closeWindow(toplevel) {
    var address = normalizedAddress(toplevel)
    if (!address) return
    Quickshell.execDetached([
      "hyprctl",
      "dispatch",
      "hl.dsp.window.close({ window = " + JSON.stringify("address:" + address) + " })"
    ])
  }

  function closeContextWindow() {
    var target = contextWindow
    close()
    closeWindow(target)
  }

  function closeContextWindows() {
    var targets = contextWindows.slice()
    close()
    for (var i = 0; i < targets.length; i++) closeWindow(targets[i])
  }

  Connections {
    target: Hyprland
    function onRawEvent(event) { taskbar.hyprlandRevision++ }
  }

  Row {
    id: content
    anchors.centerIn: parent
    spacing: 0

    TaskbarSeparator {
      visible: taskbar.leadingSeparator && taskbar.pinnedApps.length > 0
    }

    Repeater {
      model: taskbar.pinnedItems

      AppChip {
        required property var modelData

        app: modelData.app
        appWindow: modelData.window
        pinned: true
        displayLabel: taskbar.formattedWindowLabel(modelData.app.label, appWindow)
        iconName: modelData.app.icon || taskbar.windowIcon(appWindow)
      }
    }

    TaskbarSeparator {
      visible: taskbar.sectionSeparator
        && taskbar.pinnedApps.length > 0
        && taskbar.runningWindows.length > 0
    }

    Repeater {
      model: taskbar.runningWindows

      Row {
        required property int index
        required property var modelData
        spacing: 0

        TaskbarSeparator {
          visible: taskbar.startsWorkspaceGroup(parent.index, parent.modelData)
        }

        AppChip {
          app: null
          appWindow: parent.modelData
          pinned: false
          displayLabel: taskbar.formattedWindowLabel(
            taskbar.windowLabel(parent.modelData), parent.modelData)
          iconName: taskbar.windowIcon(parent.modelData)
        }
      }
    }
  }

  PopupCard {
    id: contextPopup
    anchorItem: taskbar.contextAnchor || taskbar
    owner: taskbar
    bar: taskbar.bar
    open: taskbar.contextMenuOpen
    padding: Style.space(8)
    contentWidth: contextPopup.fittedContentWidth(Style.space(300))
    contentHeight: contextPopup.fittedContentHeight(contextMenuColumn.implicitHeight, Style.space(480))

    Flickable {
      anchors.fill: parent
      contentWidth: width
      contentHeight: contextMenuColumn.implicitHeight
      clip: true
      boundsBehavior: Flickable.StopAtBounds
      flickableDirection: Flickable.VerticalFlick
      interactive: contentHeight > height

      ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

      Column {
        id: contextMenuColumn
        width: parent.width
        spacing: 0

        Item {
          width: parent.width
          implicitHeight: Style.space(48)

          Image {
            id: contextIcon
            anchors.left: parent.left
            anchors.leftMargin: Style.space(8)
            anchors.verticalCenter: parent.verticalCenter
            width: Style.space(24)
            height: width
            source: taskbar.resolveIconSource(taskbar.contextApp
              ? taskbar.contextApp.icon : taskbar.fallbackIconName)
            sourceSize.width: Math.round(width * Screen.devicePixelRatio)
            sourceSize.height: Math.round(height * Screen.devicePixelRatio)
            fillMode: Image.PreserveAspectFit
          }

          Button {
            id: contextSettingsButton
            anchors.right: parent.right
            anchors.rightMargin: Style.space(4)
            anchors.verticalCenter: parent.verticalCenter
            iconText: "\uf013"
            foreground: taskbar.bar ? taskbar.bar.barForeground : Color.foreground
            accent: Color.accent
            fontFamily: taskbar.bar ? taskbar.bar.fontFamily : Style.font.family
            horizontalPadding: Style.space(9)
            verticalPadding: Style.space(6)
            tooltipText: "OmaPanel settings"
            onClicked: taskbar.openSettingsPanel()
          }

          Column {
            anchors.left: contextIcon.right
            anchors.leftMargin: Style.space(10)
            anchors.right: contextSettingsButton.left
            anchors.rightMargin: Style.space(8)
            anchors.verticalCenter: parent.verticalCenter
            spacing: Style.space(2)

            Text {
              width: parent.width
              text: taskbar.contextApp ? taskbar.contextApp.label : "Application"
              textFormat: Text.PlainText
              color: taskbar.bar ? taskbar.bar.barForeground : Color.foreground
              font.family: taskbar.bar ? taskbar.bar.fontFamily : Style.font.family
              font.pixelSize: Style.font.body
              font.bold: true
              elide: Text.ElideRight
            }

            Text {
              width: parent.width
              text: taskbar.contextWindows.length === 0
                ? "Not running"
                : (taskbar.contextWindows.length === 1
                  ? "1 window" : taskbar.contextWindows.length + " windows")
              textFormat: Text.PlainText
              color: Util.alpha(taskbar.bar ? taskbar.bar.barForeground : Color.foreground, 0.55)
              font.family: taskbar.bar ? taskbar.bar.fontFamily : Style.font.family
              font.pixelSize: Style.font.caption
            }
          }
        }

        MenuSeparator { visible: taskbar.contextWindows.length > 0 }

        Repeater {
          model: taskbar.contextWindows

          MenuRow {
            required property var modelData

            text: taskbar.windowTitle(modelData) || taskbar.windowLabel(modelData)
            iconText: taskbar.activeWindow === modelData ? "\uf111" : ""
            onTriggered: {
              taskbar.close()
              taskbar.activateOrLaunch(null, modelData)
            }
          }
        }

        MenuSeparator { visible: taskbar.contextWindows.length > 0 }

        MenuRow {
          visible: taskbar.contextCanLaunch
          text: "New Window"
          iconText: "\uf2d2"
          onTriggered: taskbar.launchContextNewWindow()
        }

        Repeater {
          model: taskbar.contextActions

          MenuRow {
            required property var modelData

            text: taskbar.asPlainUiText(String(modelData.name || modelData.id || "Application Action"))
            iconText: "\uf144"
            onTriggered: taskbar.executeDesktopAction(modelData)
          }
        }

        MenuRow {
          enabled: taskbar.contextIsPinned || taskbar.contextCanLaunch
          text: taskbar.contextIsPinned ? "Unpin from Taskbar" : "Pin to Taskbar"
          iconText: taskbar.contextIsPinned ? "\uf127" : "\uf08d"
          onTriggered: taskbar.toggleContextPin()
        }

        MenuSeparator { visible: taskbar.contextWindows.length > 0 }

        MenuRow {
          visible: taskbar.contextWindows.length > 1
          text: "Close " + taskbar.contextWindows.length + " Windows"
          iconText: "\uf2d4"
          destructive: true
          onTriggered: taskbar.closeContextWindows()
        }

        MenuRow {
          visible: taskbar.contextWindow !== null && taskbar.contextWindows.length > 0
          text: "Close Window"
          iconText: "\uf00d"
          destructive: true
          onTriggered: taskbar.closeContextWindow()
        }
      }
    }
  }

  TaskbarSettings {
    id: taskbarSettings
    anchorItem: taskbar.contextAnchor || taskbar
    owner: taskbar
    bar: taskbar.bar
    open: taskbar.settingsPanelOpen
    values: taskbar.settings || ({})
    onSettingChanged: function(key, value) { taskbar.persistSetting(key, value) }
    onResetRequested: taskbar.resetSettings()
  }

  component TaskbarSeparator: Item {
    width: Style.space(9)
    height: taskbar.barSize

    Rectangle {
      width: Math.max(1, Style.spaceReal(1))
      height: Math.min(parent.height * 0.42, Style.space(16))
      anchors.centerIn: parent
      color: taskbar.bar ? taskbar.bar.barForeground : Color.foreground
      opacity: 0.3
      radius: width / 2
    }
  }

  component MenuSeparator: Item {
    width: parent ? parent.width : Style.space(280)
    implicitHeight: visible ? Style.space(11) : 0

    Rectangle {
      anchors.left: parent.left
      anchors.leftMargin: Style.space(8)
      anchors.right: parent.right
      anchors.rightMargin: Style.space(8)
      anchors.verticalCenter: parent.verticalCenter
      height: 1
      color: Color.popups.border
      opacity: 0.5
    }
  }

  component MenuRow: Item {
    id: menuRow

    property string text: ""
    property string iconText: ""
    property bool destructive: false
    signal triggered()

    width: parent ? parent.width : Style.space(280)
    implicitHeight: Style.space(32)
    opacity: enabled ? 1 : 0.4

    Rectangle {
      anchors.fill: parent
      radius: Math.max(2, Style.cornerRadius)
      color: menuMouse.containsMouse && menuRow.enabled
        ? Style.hoverFillFor(menuRow.destructive ? Color.urgent
          : (taskbar.bar ? taskbar.bar.barForeground : Color.foreground), Color.accent)
        : "transparent"
    }

    Text {
      anchors.left: parent.left
      width: Style.space(30)
      anchors.verticalCenter: parent.verticalCenter
      horizontalAlignment: Text.AlignHCenter
      text: menuRow.iconText
      color: menuRow.destructive ? Color.urgent
        : (taskbar.bar ? taskbar.bar.barForeground : Color.foreground)
      font.family: taskbar.bar ? taskbar.bar.fontFamily : Style.font.family
      font.pixelSize: Style.font.bodySmall
    }

    Text {
      anchors.left: parent.left
      anchors.leftMargin: Style.space(34)
      anchors.right: parent.right
      anchors.rightMargin: Style.space(10)
      anchors.verticalCenter: parent.verticalCenter
      text: menuRow.text
      textFormat: Text.PlainText
      color: menuRow.destructive ? Color.urgent
        : (taskbar.bar ? taskbar.bar.barForeground : Color.foreground)
      font.family: taskbar.bar ? taskbar.bar.fontFamily : Style.font.family
      font.pixelSize: Style.font.bodySmall
      elide: Text.ElideRight
    }

    MouseArea {
      id: menuMouse
      anchors.fill: parent
      enabled: menuRow.enabled
      hoverEnabled: true
      cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
      onClicked: menuRow.triggered()
    }
  }

  component AppChip: WidgetButton {
    id: chip

    required property var app
    required property var appWindow
    required property bool pinned
    required property string displayLabel
    required property string iconName
    property bool pointerHovered: false

    readonly property bool isActive: appWindow !== null && taskbar.activeWindow === appWindow
    readonly property bool isClosedPinned: pinned && appWindow === null
    readonly property bool effectiveShowIcons: taskbar.showIcons
      || (taskbar.iconOnlyWhenClosed && isClosedPinned)
    readonly property bool effectiveShowLabels: !isClosedPinned || !taskbar.iconOnlyWhenClosed
      ? (taskbar.showLabels || !effectiveShowIcons) : false
    readonly property bool fixedWidthMode: taskbar.widthMode.toLowerCase() === "fixed"
    readonly property string shortLabel: taskbar.shortenedLabel(displayLabel)
    readonly property int iconExtent: Style.space(taskbar.iconSize)
    readonly property real labelHeight: effectiveShowLabels ? labelMetrics.height : 0
    readonly property real contentSpacing: effectiveShowIcons && effectiveShowLabels
      ? Style.space(taskbar.iconLabelSpacing) : 0
    readonly property real hitHorizontalPadding: Style.space(taskbar.itemSpacing) / 2
    readonly property real hitHorizontalPaddingExtent: hitHorizontalPadding * 2
    readonly property real horizontalPaddingExtent: Style.space(taskbar.itemHorizontalPadding * 2)
    readonly property real iconContentExtent: effectiveShowIcons ? iconExtent : 0
    readonly property real nonLabelExtent: horizontalPaddingExtent + iconContentExtent + contentSpacing
    readonly property real naturalWidth: nonLabelExtent
      + (effectiveShowLabels ? labelMetrics.advanceWidth : 0)
    readonly property real compactWidth: horizontalPaddingExtent + iconContentExtent
    readonly property real calculatedWidth: isClosedPinned && taskbar.iconOnlyWhenClosed
      ? compactWidth
      : (fixedWidthMode
        ? Math.max(nonLabelExtent, Style.space(taskbar.fixedItemWidth))
        : Math.max(nonLabelExtent,
          Math.min(naturalWidth, Style.space(taskbar.maxAdaptiveWidth))))
    readonly property real labelExtent: effectiveShowLabels
      ? Math.max(0, calculatedWidth - nonLabelExtent) : 0
    readonly property real contentHeight: Math.max(effectiveShowIcons ? iconExtent : 0, labelHeight)
    readonly property color foregroundColor: pointerHovered
      ? taskbar.hoverTextColor
      : (isActive ? taskbar.activeTextColor : taskbar.normalTextColor)
    readonly property int foregroundWeight: pointerHovered
      ? taskbar.hoverFontWeight
      : (isActive ? taskbar.activeFontWeight : taskbar.normalFontWeight)
    readonly property real foregroundOpacity: pointerHovered
      ? taskbar.hoverOpacity
      : (isActive ? taskbar.activeOpacity : taskbar.normalOpacity)

    function handleBarWheel(delta) {
      return taskbar.cycleWindowGroup(app, appWindow, pinned, delta)
    }

    bar: taskbar.bar
    text: ""
    labelVisible: false
    hasVisualContent: true
    keepSpace: true
    interactive: false
    useActiveColor: false
    dimmed: false
    fixedWidth: calculatedWidth + hitHorizontalPaddingExtent
    fixedHeight: Math.min(taskbar.barSize,
      contentHeight + Style.space(taskbar.itemVerticalPadding * 2))
    tooltipText: taskbar.asPlainUiText(displayLabel)
      + (pinned && appWindow === null ? "\nClick to open" : "\nClick to focus")

    TextMetrics {
      id: labelMetrics
      font.family: taskbar.bar ? taskbar.bar.fontFamily : Style.font.family
      font.pixelSize: taskbar.fontSize
      font.weight: chip.foregroundWeight
      text: chip.shortLabel
    }

    Rectangle {
      readonly property bool persistentActive: chip.isActive
        && taskbar.activeBackgroundEnabled

      anchors.fill: parent
      anchors.topMargin: Style.space(1)
      anchors.bottomMargin: Style.space(1)
      anchors.leftMargin: chip.hitHorizontalPadding + Style.space(1)
      anchors.rightMargin: chip.hitHorizontalPadding + Style.space(1)
      radius: taskbar.itemCornerRadius
      color: chip.pointerHovered ? taskbar.hoverBackgroundColor
        : (persistentActive ? taskbar.activeBackgroundColor : taskbar.normalBackgroundColor)
      opacity: chip.pointerHovered || persistentActive || taskbar.normalBackgroundEnabled ? 1 : 0

      Behavior on opacity {
        NumberAnimation { duration: 110; easing.type: Easing.OutCubic }
      }
    }

    Row {
      anchors.centerIn: parent
      spacing: chip.contentSpacing
      opacity: chip.foregroundOpacity

      Behavior on opacity {
        NumberAnimation { duration: 110; easing.type: Easing.OutCubic }
      }

      Item {
        width: chip.iconExtent
        height: chip.iconExtent
        visible: chip.effectiveShowIcons

        Image {
          id: appIcon
          anchors.fill: parent
          source: taskbar.resolveIconSource(chip.iconName)
          sourceSize.width: Math.round(width * Screen.devicePixelRatio)
          sourceSize.height: Math.round(height * Screen.devicePixelRatio)
          fillMode: Image.PreserveAspectFit
          asynchronous: true
          smooth: true
          mipmap: true
          layer.enabled: taskbar.invertIconColors
          layer.smooth: true
          layer.effect: ShaderEffect {
            property variant source
            fragmentShader: Qt.resolvedUrl("shaders/invert.frag.qsb")
          }
        }

        Text {
          anchors.centerIn: parent
          visible: appIcon.status === Image.Error || appIcon.source.toString() === ""
          text: chip.shortLabel.charAt(0).toUpperCase()
          textFormat: Text.PlainText
          color: chip.foregroundColor
          font.family: taskbar.bar ? taskbar.bar.fontFamily : Style.font.family
          font.pixelSize: taskbar.fontSize
          font.weight: chip.foregroundWeight
        }
      }

      Text {
        visible: chip.effectiveShowLabels
        width: chip.labelExtent
        text: chip.shortLabel
        textFormat: Text.PlainText
        color: chip.foregroundColor
        font.family: taskbar.bar ? taskbar.bar.fontFamily : Style.font.family
        font.pixelSize: taskbar.fontSize
        font.weight: chip.foregroundWeight
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        maximumLineCount: 1
      }
    }

    Rectangle {
      readonly property bool dotIndicator: taskbar.activeIndicator === "Dot"
      readonly property bool topIndicator: taskbar.activeIndicator === "Top"
      readonly property real edgeMargin: Style.space(taskbar.indicatorMargin)

      visible: chip.isActive && taskbar.activeIndicator !== "None"
      width: dotIndicator
        ? Style.space(taskbar.indicatorSize)
        : (taskbar.indicatorLength > 0
          ? Math.min(chip.calculatedWidth, Style.space(taskbar.indicatorLength))
          : Math.max(Style.space(12),
            chip.calculatedWidth - Style.space(taskbar.itemHorizontalPadding * 2)))
      height: dotIndicator
        ? width : Style.space(taskbar.indicatorThickness)
      x: Math.round((parent.width - width) / 2)
      y: topIndicator
        ? edgeMargin
        : Math.max(0, parent.height - height - edgeMargin)
      z: 2
      color: taskbar.indicatorColor
      radius: height / 2

      Behavior on width {
        NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
      }
    }

    MouseArea {
      anchors.fill: parent
      z: 10
      acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      onEntered: {
        chip.pointerHovered = true
        if (chip.bar) chip.bar.showTooltip(chip, chip.tooltipText)
      }
      onExited: {
        chip.pointerHovered = false
        if (chip.bar) chip.bar.hideTooltip(chip)
      }
      onClicked: function(mouse) {
        taskbar.handleConfiguredClick(
          chip.app, chip.appWindow, chip, mouse.button, mouse.modifiers)
      }
      onWheel: function(wheel) {
        var delta = wheel.angleDelta.y !== 0
          ? wheel.angleDelta.y : wheel.angleDelta.x
        wheel.accepted = chip.handleBarWheel(delta)
      }
    }
  }
}
