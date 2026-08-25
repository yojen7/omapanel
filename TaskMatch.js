.pragma library
.import "TaskHelpers.js" as Helpers

function isUnsafeClassPattern(pattern) {
  if (!pattern || pattern.length > Helpers.maxRegexPatternLength) return true
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
    return Helpers.sanitizeClassValue(value)
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

function regexEscape(value) {
  return String(value || "").replace(/[.*+?^${}()|[\]\\]/g, "\\$&")
}

function shortenedLabel(label, maxLabelLength) {
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

function formattedWindowLabel(appName, title, labelFormat) {
  var app = Helpers.asPlainUiText(String(appName || "App").trim()) || "App"
  var format = String(labelFormat || "").trim() || "[APP_NAME]"
  if (format.length > Helpers.maxUntrustedTextLength)
    format = format.slice(0, Helpers.maxUntrustedTextLength)

  if (!title) return app

  var result = Helpers.asPlainUiText(format
    .replace(/\[APP_NAME\]/gi, app)
    .replace(/\[WINDOW_TITLE\]/gi, title)
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
