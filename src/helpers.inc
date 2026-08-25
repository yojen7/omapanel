    function boolSetting(key, fallback) {
        return setting(key, fallback) === true;
    }

    function clampedInt(key, fallback, minValue, maxValue) {
        var parsed = Number(setting(key, fallback));
        if (isNaN(parsed))
            parsed = fallback;

        parsed = Math.round(parsed);
        if (maxValue === undefined || maxValue === null)
            return Math.max(minValue, parsed);

        return Math.max(minValue, Math.min(maxValue, parsed));
    }

    function resolvedFontSize(rawValue) {
        return Helpers.resolvedFontSize(rawValue, automaticFontSize);
    }

    function resolvedOpacity(rawValue) {
        return Helpers.resolvedOpacity(rawValue);
    }

    function resolvedItemCornerRadius(rawValue) {
        return Helpers.resolvedItemCornerRadius(rawValue, Math.max(2, Style.cornerRadius));
    }

    function hexColorValue(value) {
        var text = value === undefined || value === null ? "" : String(value).trim();
        if (/^#[0-9a-f]{6}$/i.test(text) || /^#[0-9a-f]{8}$/i.test(text))
            return text;

        return "";
    }

    function normalizedClickAction(value, fallback) {
        return Helpers.normalizedClickAction(value, fallback);
    }

    function parsePinnedApps(raw) {
        return Helpers.parsePinnedApps(raw);
    }

    function asPlainUiText(value) {
        return Helpers.asPlainUiText(value);
    }

    function sanitizeClassValue(value) {
        return Helpers.sanitizeClassValue(value);
    }

    function isPlausibleAppId(value) {
        return Helpers.isPlausibleAppId(value);
    }

    function normalizeDesktopId(value) {
        return Helpers.normalizeDesktopId(value);
    }

    function clampedLaunch(value) {
        return Helpers.clampedLaunch(value);
    }

    function isRemoteIconSource(value) {
        return Helpers.isRemoteIconSource(value);
    }

    function sanitizeIconName(icon) {
        return Helpers.sanitizeIconName(icon);
    }

    function fallbackIconSource() {
        return Quickshell.iconPath(fallbackIconName, true);
    }

    function isUnsafeClassPattern(pattern) {
        return Match.isUnsafeClassPattern(pattern);
    }

    function windowCandidates(toplevel) {
        return Match.windowCandidates(toplevel);
    }

    function patternMatches(pattern, values) {
        return Match.patternMatches(pattern, values);
    }

    function regexEscape(value) {
        return Match.regexEscape(value);
    }

    function shortenedLabel(label) {
        return Match.shortenedLabel(label, maxLabelLength);
    }

    function configuredColor(value, fallback) {
        return Match.configuredColor(value, fallback);
    }

    function formattedWindowLabel(appName, toplevel) {
        return Match.formattedWindowLabel(appName, windowTitle(toplevel), labelFormat);
    }

    function normalizedAddress(toplevel) {
        return Match.normalizedAddress(toplevel);
    }
