# HOI4 Mod Workspace Agents Notes

## Read Order

This file governs the outer HOI4 `mod` folder. Before working inside any child
mod, first read this file, then read the nearest child `AGENTS.md` if one exists.

`Japan_rework/AGENTS.md` is the most important project entrypoint. For any work
inside `Japan_rework`, read and follow that file before inspecting or editing
game files.

## Workspace Map

- `Japan_rework/` is the test version and the main working mod. Its launcher
  descriptor is the outer `Japan_rework.mod`.
- `rance_jap_chinese/`, `rance_jap_english/`, and `rance_jap_japenese/` are the
  formal three-language release copies. Their launcher descriptors are the outer
  `rance_jap_chinese.mod`, `rance_jap_english.mod`, and
  `rance_jap_japenese.mod`. Maintain these mainly during major mod updates or
  when the user explicitly asks for formal-version sync.
- `rookie_basic/`, `rookie_ENG/`, `rookie_GER/`, `rookie_ITA/`, and
  `rookie_SOV/` are the sister Rookie mod family. When the user says "菜鸟mod",
  this refers to these mods. Treat them as separate sibling mods, not part of
  the Japan outer repository scope, unless the user explicitly asks to edit them.
- Other folders and `ugc_*.mod` files in this outer directory are external mods,
  launcher records, or references. Treat them as out of scope unless explicitly
  named by the user.

## Outer Git Scope

The outer Git repository is intentionally a whitelist repository. It should track
only:

- this `AGENTS.md`, the root `.gitignore`, and the root `.gitattributes`
- `Japan_rework/` and `Japan_rework.mod`
- `rance_jap_chinese/` and `rance_jap_chinese.mod`
- `rance_jap_english/` and `rance_jap_english.mod`
- `rance_jap_japenese/` and `rance_jap_japenese.mod`

All other sibling mods, workshop descriptor files, local launcher files, and
reference folders are ignored by the outer repository.

Several child mods already contain their own `.git/` directories. Do not delete,
move, rewrite, or stage those inner Git directories unless the user explicitly
asks. The outer `.gitignore` excludes `**/.git/` so these histories do not get
mixed into the outer repository.

## Editing Rules

- Prefer live file inspection over memory or assumptions.
- When a request is read-only and asks to investigate or report on a complex
  vanilla/mod system, prefer spawning sub-agents for well-bounded parallel
  evidence gathering when available. Keep each sub-agent read-only, assign
  non-overlapping file or mechanic slices, and have the main agent verify and
  synthesize conclusions from live files.
- Preserve each target file's current encoding and line endings.
- For `Japan_rework`, follow its root `AGENTS.md` and any deeper directory
  `AGENTS.md` before editing.
- For formal release copies, keep edits tightly synced with the requested
  language/version scope and avoid broad maintenance unless the user asks for a
  release update.
