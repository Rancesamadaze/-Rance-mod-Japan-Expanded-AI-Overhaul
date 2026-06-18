# Interface Agents Notes

## Scope

Applies to files under `interface/`.

## Required Reference

Read `interface/Interface_Reference/interface_authoring_reference.md` before adding or revising sprite registrations, `spriteType` blocks, `texturefile` paths, or script-side `GFX_...` references.

## Operating Rules

- Keep interface definitions as registrations, not gameplay logic.
- Register a stable `GFX_...` name in interface files, then reference that name from script files.
- Reuse existing project naming and path patterns before creating a new convention.
- When a sprite registration uses `.dds`, keep non-direct preview/source PNGs outside game-loaded `gfx/` paths under `asset_sources/`.
- Preserve existing file encoding and line endings unless the user explicitly asks for conversion.
