# Changelog

All notable changes to OmaPanel are documented here.

## 1.9.0

- Changed the permanent plugin ID from `xava.app-taskbar` to
  `atagulalan.omapanel` to match the publisher namespace and product name.

## 1.8.0

- Renamed the user-facing plugin and settings panel to OmaPanel.
- Split settings into General, Layout, and Appearance tabs.
- Added a manifest-backed Reset defaults action.
- Moved the settings gear to the upper-right corner of the context-menu header.
- Placed Close N Windows above Close Window.
- Organized Normal, Hover, and Active appearance settings into three columns.
- Added background and font-weight controls for all three visual states.
- Removed the active-background mode selector; a non-empty active background
  color now enables the fill automatically.
- Fixed live switching for Top and Dot indicators.
- Removed opacity reduction from closed pinned applications.
- Updated default size, spacing, and separator values.

## 1.7.3

- Changed eight-digit color input to `#RRGGBBAA` and converted values to Qt's
  internal alpha-first format before assignment.
- Unified active and hover backgrounds in one drawing layer.
- Ensured hover replaces the active background instead of blending with it.

## 1.7.1

- Separated active-background and pointer-hover color resolution.
- Made Hover active mode derive its fill from the active foreground.
- Restricted Custom mode to `activeBackgroundColor`.

## 1.7.0

- Added independent hover foreground and background settings.
- Gave hover state priority over normal and active colors.
- Kept custom active backgrounds independent from pointer hover.

## 1.6.1

- Migrated settings to Omarchy's keyboard-aware `KeyboardPanel`.
- Fixed text-field input, Tab navigation, and Escape-to-close behavior.

## 1.6.0

- Added the built-in OmaPanel Settings interface.
- Added controls for behavior, layout, colors, typography, indicators,
  separators, and filters.
- Persisted form changes immediately with `updateEntryInline()`.
- Kept pinned-application editing in the safer context-menu flow.

## 1.5.0

- Added independent active foreground and background behavior.
- Added None, Hover, and Custom active-background modes.
- Allowed active state to remain visible without an indicator.

## 1.4.2

- Added a theme-aware hover fill across the complete clickable item.
- Kept the hover surface fully visible while closed pinned content was dimmed.

## 1.4.1

- Added `lastIpcObject.title` as a Hyprland title fallback.
- Fixed combined application and window titles for applications such as
  Ghostty.

## 1.4.0

- Added workspace grouping for dynamic windows.
- Added separators between adjacent workspace groups.

## 1.3.0

- Added Adaptive and Fixed item-width modes.
- Added fixed-width and maximum-adaptive-width settings.
- Ellipsized labels that exceed their pixel limit.
- Kept closed icon-only pinned items compact.

## 1.2.0

- Added icon-only mode for closed pinned applications.
- Added `[APP_NAME]` and `[WINDOW_TITLE]` label placeholders.
- Added item spacing, padding, icon-size, and font-size settings.
- Added normal and active color and font-weight settings.
- Added indicator style, color, thickness, length, size, and margin settings.

## 1.1.0

- Added a Dash to Panel-inspired application context menu.
- Added window lists, New Window, desktop actions, pin/unpin, and close actions.
- Persisted pin/unpin changes to `shell.json`.

## 1.0.0

- Added pinned launch-or-focus applications.
- Added dynamic display of unpinned Hyprland windows.
- Added an active-window indicator.
- Added address-based Hyprland focus behavior.
