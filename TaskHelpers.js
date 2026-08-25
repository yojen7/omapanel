.pragma library

var maxUntrustedTextLength = 512
var maxClassLength = 96
var maxRegexPatternLength = 256
var maxLaunchLength = 4096
var maxIconLength = 512
var maxDesktopIdLength = 128
var fallbackIconName = "application-x-executable"

function resolvedFontSize(rawValue, automaticFontSize) {
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

function resolvedItemCornerRadius(rawValue, themeRadius) {
  if (rawValue === undefined || rawValue === null
      || String(rawValue).trim() === "") {
    return themeRadius
  }

  var parsed = Number(rawValue)
  return isNaN(parsed)
    ? themeRadius : Math.max(0, Math.min(32, Math.round(parsed)))
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
