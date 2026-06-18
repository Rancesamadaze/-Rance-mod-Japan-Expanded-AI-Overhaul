# On Actions Directory Notes

## Scope

Applies to files under `common/on_actions/`.

## Operating Rules

- Every on-action hook in this directory must be nested under one top-level `on_actions = { ... }` block. Do not leave loose hooks such as `on_startup = { ... }` or `on_unit_leader_created = { ... }` at file root.
- Keep startup initialization effects centralized in the existing matching initialization file when possible, rather than scattering one-off startup hooks across unrelated files.
- Preserve UTF-8 without BOM and LF unless an existing file proves otherwise.
