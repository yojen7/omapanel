# Settings reference

OmaPanel stores its configuration in the `xava.app-taskbar` widget entry in:

```text
~/.config/omarchy/shell.json
```

The values in `manifest.json` are the plugin defaults. The settings panel
writes toggle, dropdown, number, and text changes immediately. Press Escape to
close the panel. Pinned applications are managed through the right-click menu
instead of editing raw JSON in the form.

## Behavior

| Key | Type | Default | Description |
|---|---:|---:|---|
| `pinnedApps` | JSON string | Zen, Cursor | Pinned application descriptors |
| `showRunning` | boolean | `true` | Show non-pinned running windows |
| `groupRunningByWorkspace` | boolean | `true` | Sort running windows by workspace and separate groups |
| `showIcons` | boolean | `true` | Show application icons |
| `showLabels` | boolean | `true` | Show application labels |
| `iconOnlyWhenClosed` | boolean | `true` | Keep closed pinned applications compact |
| `labelFormat` | string | `[APP_NAME] - [WINDOW_TITLE]` | Label template for open windows |
| `maxRunningWindows` | integer | `12` | Maximum dynamic windows; range 1–30 |
| `excludedClasses` | string | empty | Comma-separated, case-insensitive class regular expressions |

### Label placeholders

`labelFormat` supports:

- `[APP_NAME]`: the desktop-entry name or a name derived from the window
  class;
- `[WINDOW_TITLE]`: the Quickshell title, falling back to the Hyprland IPC
  title.

```text
[APP_NAME] - [WINDOW_TITLE] -> Ghostty - ~/Projects/omapanel
[WINDOW_TITLE]              -> ~/Projects/omapanel
[WINDOW_TITLE] · [APP_NAME] -> ~/Projects/omapanel · Ghostty
```

If no window title is available, OmaPanel displays only the application name.

## Width and typography

| Key | Type | Default | Range or options | Description |
|---|---:|---:|---|---|
| `widthMode` | enum | `Adaptive` | `Adaptive`, `Fixed` | Item width behavior |
| `fixedItemWidth` | integer | `160` | 32–480 | Width of open items in Fixed mode |
| `maxAdaptiveWidth` | integer | `280` | 32–640 | Maximum item width in Adaptive mode |
| `maxLabelLength` | integer | `14` | 4–40 | Character limit applied before measuring |
| `fontSize` | integer | `12` | 8–24 | Label font size |
| `normalFontWeight` | integer | `400` | 1–1000 | Normal label weight |
| `hoverFontWeight` | integer | `500` | 1–1000 | Hovered label weight |
| `activeFontWeight` | integer | `600` | 1–1000 | Active label weight |

Adaptive mode follows the measured content up to `maxAdaptiveWidth`. Fixed
mode assigns `fixedItemWidth` to open items. Overflowing labels are
ellipsized in both modes. Closed icon-only pinned applications remain compact.

## Size and spacing

| Key | Type | Default | Range | Description |
|---|---:|---:|---:|---|
| `itemSpacing` | integer | `4` | 0–24 | Space between application items |
| `itemHorizontalPadding` | integer | `8` | 0–24 | Left and right item padding |
| `itemVerticalPadding` | integer | `12` | 0–16 | Top and bottom item padding |
| `iconLabelSpacing` | integer | `8` | 0–20 | Gap between icon and label |
| `iconSize` | integer | `18` | 8–32 | Application icon size |

These values pass through Omarchy's `Style.space()` scaling so they follow the
active shell density.

## State colors

| Key | Default | Description |
|---|---:|---|
| `normalColor` | empty | Normal label and fallback-icon foreground |
| `normalBackgroundColor` | empty | Normal item background; empty disables it |
| `hoverColor` | empty | Hovered label and fallback-icon foreground |
| `hoverBackgroundColor` | empty | Hovered item background |
| `activeColor` | empty | Active label and fallback-icon foreground |
| `activeBackgroundColor` | empty | Active item background; empty disables it |
| `indicatorColor` | empty | Active-window indicator color |

Colors accept `#RRGGBB` and `#RRGGBBAA`. The final two digits in the
eight-digit form are alpha: `00` is transparent and `ff` is opaque.

Empty foreground values inherit the bar or previous state. An empty hover
background uses the theme hover fill. Normal and active backgrounds are
disabled when their values are empty.

The background uses a single visual layer with this priority:

```text
hover > active > normal
```

This prevents state colors from blending. When the pointer leaves an active
item, the active background is restored.

```json
{
  "normalColor": "#a6adc8",
  "normalBackgroundColor": "#18182580",
  "hoverColor": "#11111b",
  "hoverBackgroundColor": "#89b4fa",
  "activeColor": "#ffffff",
  "activeBackgroundColor": "#45475a",
  "indicatorColor": "#89b4fa"
}
```

## Active-window indicator

| Key | Type | Default | Range or options | Description |
|---|---:|---:|---|---|
| `activeIndicator` | enum | `Underline` | `Underline`, `Top`, `Dot`, `None` | Indicator style and position |
| `indicatorThickness` | integer | `2` | 1–8 | Line thickness |
| `indicatorSize` | integer | `4` | 2–16 | Dot diameter |
| `indicatorLength` | integer | `0` | 0–80 | Line length; 0 follows item width |
| `indicatorMargin` | integer | `2` | 0–12 | Distance from the top or bottom edge |

The indicator appears only on the item that matches Hyprland's active
toplevel.

## Separators

| Key | Default | Description |
|---|---:|---|
| `leadingSeparator` | `false` | Draw a separator before pinned applications |
| `sectionSeparator` | `true` | Separate pinned and dynamic sections |
| `groupRunningByWorkspace` | `true` | Separate adjacent workspace groups |

Workspace numbers are not rendered as text. Windows from the same workspace
remain adjacent, and a line marks each workspace transition.

## `pinnedApps` format

The shell settings schema stores the array as a JSON-encoded string:

```json
{
  "pinnedApps": "[{\"label\":\"Zen\",\"match\":\"^zen$\",\"launch\":\"omarchy-launch-browser\",\"icon\":\"zen-browser\",\"desktopId\":\"zen\"}]"
}
```

Each object supports:

| Field | Required | Description |
|---|---:|---|
| `label` | Yes | User-facing application name |
| `match` | Yes | Regular expression for Hyprland class or app ID |
| `launch` | No | Command used when no window is open |
| `icon` | No | Freedesktop icon name, `file://` URL, or absolute path |
| `desktopId` | No | Desktop entry used for actions and New Window |

Invalid regular expressions are ignored and reported in the shell log.
Right-click pin and unpin actions normalize the array and write it back to
`shell.json`.
