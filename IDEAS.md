# OmaPanel Ideas

Prioritized ideas for future releases. The list favors features that improve
daily window management without making the default taskbar more complicated.

## High priority

### 1. Pinned group display modes

Let each pinned application choose how multiple matching windows are shown:

- **Separate:** one adjacent item per window, matching the current behavior.
- **Grouped:** one application item with a window-count badge.
- **Cycle:** one item that cycles through its windows when activated.

The context menu should always expose every window regardless of display mode.

### 2. Hover window previews

Show a live thumbnail when hovering over a running window. For grouped pinned
applications, show all thumbnails in a compact horizontal picker with focus and
close controls.

Preview delay, size, and enable/disable state should be configurable.

### 3. Per-application overrides

Allow pinned entries to override global behavior where needed:

- display mode;
- click actions;
- icon, label format, and width;
- maximum visible windows;
- launch command and desktop ID.

Global settings remain the fallback so existing pinned entries keep working.

### 4. Mouse-wheel actions

Add configurable wheel-up and wheel-down actions. The primary use case is
cycling through windows belonging to the hovered application, with optional
focus-next, focus-previous, workspace, or no-op mappings.

### 5. Drag-and-drop pin management

Support direct manipulation of the taskbar:

- reorder pinned applications by dragging;
- drag a running item into the pinned section to pin it;
- drag a pinned item out to unpin it;
- preserve ordering immediately in `shell.json`.

## Medium priority

### 6. Workspace and monitor scope

Provide independent visibility modes for running and pinned windows:

- all workspaces or active workspace only;
- all monitors or current monitor only;
- optionally dim off-workspace windows;
- optionally move a selected window to the active workspace or monitor.

### 7. Minimize and restore actions

Add `Minimize`, `Restore`, and `Minimize or Restore` to the Behavior action
list. An optional taskbar-style mode can minimize the active window when its
item is clicked again.

### 8. Application picker

Replace manual pinned-app JSON editing with a searchable desktop-application
picker. Selecting an application should populate its name, icon, desktop ID,
launch command, and a safe initial match expression.

### 9. Urgent-state indication

Highlight applications requesting attention with configurable color,
animation, and badge behavior. Animations must respect a global disabled or
reduced-motion setting.

## Design principles

- Preserve current behavior when new settings are absent.
- Keep potentially destructive actions opt-in.
- Prefer per-application overrides with global fallbacks.
- Avoid duplicating a window between pinned and dynamic sections.
- Keep all actions usable without thumbnails or animations enabled.
