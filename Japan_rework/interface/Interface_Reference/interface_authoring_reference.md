# Interface Authoring Reference

Source: `interface/AGENTS.md`.
Applies to: `interface/`.

This file preserves detailed authoring notes migrated out of `interface/AGENTS.md`. Keep the corresponding `AGENTS.md` file as a concise operating entrypoint, and update this reference when long examples, syntax notes, workflows, or lookup explanations need to be maintained.

## Migrated Notes

# Interface Agents Notes

## Scope

These instructions apply to files under `interface/`.

## Purpose

This directory is used to register UI and content art assets for the mod, especially `.gfx` sprite registrations such as:

- national focus icons
- government or character portraits
- idea icons
- event artwork

## Basic Registration Pattern

When adding a new registered sprite, use this structure:

```txt
spriteTypes = {
    spriteType = {
        name = "GFX_SPRITE_NAME"
        texturefile = "gfx/path/to/file.png"
    }
}
```

Each registered asset should normally be one `spriteType = { ... }` block.

## Current Project Standard

For new edits in this mod, prefer this newer formatting style:

- `name` uses quotes
- `texturefile` uses lowercase
- asset paths use forward slashes

Example:

```txt
spriteType = {
    name = "GFX_focus_JAP_kaguya_princess"
    texturefile = "gfx/interface/goals/JAP_kaguya_princess.png"
}
```

Older files may still contain legacy variants such as unquoted `name`, `textureFile`, or backslash-based paths.

When adding or updating entries, follow the newer standard unless the user explicitly wants exact legacy formatting preserved.

## Naming Relationship

Prefer keeping the asset file name and registered `GFX_...` name easy to map one-to-one.

Typical pattern:

```txt
raw file:      JAP_kaguya_princess.png
registered as: GFX_JAP_kaguya_princess
```

For focus icons, prefer the existing project style:

```txt
name = "GFX_focus_JAP_some_focus"
texturefile = "gfx/interface/goals/JAP_some_focus.png"
```

If the user already established a naming scheme for a content set, follow the user-provided scheme instead of renaming it.

## Path Conventions

- `texturefile` should point to the actual asset path under `gfx/`.
- Keep file extensions explicit, usually `.png`.
- Prefer forward slashes in newly written paths, for example `gfx/interface/goals/JAP_kaguya_princess.png`.
- Older files may still use `textureFile` or backslash-style paths; treat those as legacy formatting, not the preferred default.

## Editing Rules

- Preserve the root `spriteTypes = { ... }` structure.
- Add new `spriteType` entries without disturbing unrelated existing registrations.
- Keep registrations compact and conservative: only add fields that are actually needed.
- Do not invent extra sprite fields unless the design truly requires them.

## File Role Habits In This Mod

Based on current project usage:

- `rance_jap_focus.gfx` is for focus icon registrations.
- `rance_jap_government.gfx` is for government and character portrait registrations.
- `rance_jap_ideas.gfx` is for idea icon registrations.
- `rance_jap_event.gfx` is for event artwork registrations.

When adding a registration, place it in the file whose existing content role matches the new asset.

## Reuse Rule

When the user has already created and named the raw asset file, reuse that exact file name and register it directly rather than inventing a second naming layer.

In short:

1. confirm the raw file path under `gfx/`
2. register it in the matching `.gfx` file
3. reference the registered `GFX_...` name from script files

## Generated Source Asset Storage

When a generated image produces both a game-ready file and source or preview companions, keep the game-loaded directories lean:

- If a `.gfx` registration points to a `.dds`, place only the referenced `.dds` under `gfx/`.
- Move same-subject preview `.png`, large `_source.png`, and other non-direct-use generated files to `asset_sources/<domain>/...`.
- Keep the relative topic path recognizable. For officer corps spirits, use `asset_sources/officer_corp/spirits/`.
- Do not move existing `.png` assets merely because they are PNG files; many project registrations legitimately use PNG directly.
- Before moving a companion image out of `gfx/`, confirm no `.gfx`, script, or localisation entry references that exact path.
