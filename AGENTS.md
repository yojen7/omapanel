# Agent notes

`BarWidget.qml` is generated. Do not edit it.

OmaPanel’s plugin entry point is built by `scripts/bundle-qml.py` from:

- `src/BarWidget.qml` and `src/*.inc` — settings, window lists, interaction
- `taskbar/*.qml` and `taskbar/*.inc` — chrome, chips, menus, previews
- `settings/**/*.qml` and `settings/**/*.inc` — settings panel, tabs, fields
- `TaskHelpers.js` and `TaskMatch.js` — sibling JS imports (not bundled)

`// @include relative/path.inc` in a QML file is replaced with that file’s
contents at bundle time. Source files (including `.inc` fragments) must stay
at most 150 lines.

Edits to `BarWidget.qml` are discarded the next time the bundle script runs.
Change the sources above, then rebuild:

```bash
python3 scripts/bundle-qml.py
```

Use `--watch` while iterating, and `--check` to confirm the committed file
matches the sources.
