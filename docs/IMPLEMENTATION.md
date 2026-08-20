# Implementation overview

This document summarizes OmaPanel's runtime behavior, data flow, and important
implementation decisions.

## Architecture

OmaPanel is a single Omarchy `bar-widget` plugin:

```text
manifest.json
    └── BarWidget.qml
            └── TaskbarSettings.qml
```

`BarWidget.qml` owns window discovery, pinned applications, rendering,
interaction, persistence, and both popouts. `TaskbarSettings.qml` provides the
keyboard-aware settings interface.

The plugin runs inside the existing Omarchy Shell process. It never starts a
second Quickshell instance.

## Window data flow

```text
Hyprland.toplevels
       │
       ├─ read class / initialClass / appId
       ├─ remove windows matched by pinned applications
       ├─ apply excludedClasses filters
       ├─ sort by workspace when grouping is enabled
       ├─ enforce maxRunningWindows
       └─ create AppChip delegates
```

`Hyprland.onRawEvent` increments a local revision counter. Opening, closing,
moving, retitling, or changing the workspace of a window therefore recomputes
the derived lists.

## Window matching

A pinned application's `match` regular expression is tested against:

1. `lastIpcObject.class`
2. `lastIpcObject.initialClass`
3. `wayland.appId`

A matched pinned window is excluded from the dynamic list. If more than one
window matches, the active one is preferred; otherwise the first match is used.
The context menu uses the same descriptor to list every matching window.

## Launch, focus, and close

A closed pinned application runs its configured `launch` command through the
Omarchy bar helper.

Open windows are focused by normalized Hyprland address:

```text
hyprctl dispatch hl.dsp.focus({ window = "address:0x..." })
```

Address-based dispatch avoids unreliable generic toplevel activation. Closing
uses the equivalent `hl.dsp.window.close` dispatch. When several matching
windows exist, **Close N Windows** appears above **Close Window**.

## Titles and icons

Application names are resolved from the desktop entry first, then from a
terminal tag, the final class segment, or the window title.

Window titles use:

1. `HyprlandToplevel.title`
2. `HyprlandToplevel.lastIpcObject.title`

The second source handles applications whose IPC title is available before
Quickshell exposes its title.

Icons use:

1. the pinned application's explicit `icon`;
2. the desktop-entry icon;
3. `application-x-executable`.

Freedesktop names, `image://` URLs, `file://` URLs, and absolute paths are
accepted. If loading fails, the first letter of the application name is shown.

## Workspace grouping

Only the dynamic section is sorted by workspace. Original order is preserved
within a workspace. A `TaskbarSeparator` is inserted before every delegate
whose workspace differs from the preceding delegate.

Pinned applications remain workspace-independent:

```text
pinned | workspace 1 windows | workspace 5 windows | workspace 9 windows
```

## Width calculation

An item's natural width is:

```text
horizontal padding + icon + icon/label gap + measured label
```

- Adaptive mode clamps natural width to `maxAdaptiveWidth`.
- Fixed mode uses `fixedItemWidth`.
- Closed icon-only pinned items keep only padding and the icon.
- Required icon and padding space is never clipped by a smaller configured
  width.

The remaining label width is passed to `Text.ElideRight`.
`maxLabelLength` also shortens unusually long strings before measurement.

## Visual states

Normal, hover, and active states each expose foreground, background, and font
weight settings.

Foreground and weight priority:

```text
hover > active > normal
```

Backgrounds share one rectangle with the same priority. Empty normal and active
background values disable those persistent fills; an empty hover background
falls back to the theme hover fill. State colors never blend.

Closed pinned applications use full opacity. `iconOnlyWhenClosed` can hide
their labels while keeping icons visible, even when the general icon toggle is
off.

The active indicator is rendered only for the chip whose window equals
`Hyprland.activeToplevel`. Underline, Top, and Dot positions use direct
geometry instead of conditional anchors, which makes live style switching
reliable.

Eight-digit user colors use `#RRGGBBAA`. `configuredColor()` converts them
to Qt's internal alpha-first representation before assignment.

## Context menu

The context menu is a `PopupCard` anchored to the clicked item. It builds:

- application title and icon;
- all matching open windows;
- desktop-entry New Window behavior;
- desktop actions other than `new-window`;
- pin or unpin state;
- single-window and multi-window close actions.

The settings gear is placed in the upper-right corner of the menu header.

Pin and unpin operations copy the current settings object, serialize the
normalized `pinnedApps` array, and call
`bar.shell.updateEntryInline()`.

## Settings panel

The settings gear opens a `KeyboardPanel` with three tabs:

- General
- Layout
- Appearance

The panel uses Omarchy's `Toggle`, `Dropdown`, `NumberField`,
`TextField`, `PanelSectionHeader`, and `PanelSeparator` components.
Keyboard focus works with pointer clicks and Tab; Escape closes the panel.

Each control emits `settingChanged(key, value)`. The bar copies its current
settings object, updates one field, and persists it through
`updateEntryInline()`. No Save button is required.

**Reset defaults** reads `barWidget.defaults` from the plugin manifest and
replaces the widget settings with that object.

The context menu and settings panel share the same owner/coordinator identity,
so they cooperate with other Omarchy popouts and close normally on outside
clicks.

## Scope

- OmaPanel supports horizontal bars and hides itself on vertical bars.
- Every dynamic window is represented by its own chip.
- Left-click chooses the active matching pinned window, or the first match when
  none is active. Other matches remain accessible from the context menu.
- Workspace IDs are represented by separators rather than text.
- `launch` is a user-provided shell command and is treated as trusted
  configuration.

## Validation

The repository is checked with:

```bash
jq empty manifest.json examples/shell-entry.json
qmlformat -n BarWidget.qml >/dev/null
qmlformat -n TaskbarSettings.qml >/dev/null
omarchy plugin validate .
omarchy restart shell
omarchy-shell shell ping
```

Runtime verification also checks the current Quickshell log for OmaPanel load
errors.
