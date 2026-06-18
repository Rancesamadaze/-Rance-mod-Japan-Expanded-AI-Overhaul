# Asset Sources Notes

## Scope

Applies to files under `asset_sources/`.

## Purpose

This directory stores source, preview, and editable image assets that are not directly loaded by HOI4 registrations.

## Operating Rules

- Do not reference files here from `.gfx` registrations or gameplay script.
- Keep only the game-ready file actually referenced by `.gfx` under game-loaded paths such as `gfx/`.
- Preserve recognizable topic paths, for example `asset_sources/officer_corp/spirits/`.
