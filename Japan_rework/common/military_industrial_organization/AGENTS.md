# Military Industrial Organization Agents Notes

## Scope

Applies to files under `common/military_industrial_organization/`.

## Required References

- Detailed MIO authoring notes migrated from this AGENTS file: `Reference/mio/mio_authoring_reference.md`
- Trait naming: `Reference/mio/trait_naming_reference.md`
- Trait icons: `Reference/mio/trait_gfx_reference.md`
- Equipment stats: `Reference/mio/equipment_stat_reference.md`
- Smart layout workflow: `Reference/mio/smart_layout_mio_template_workflow.md`
- Concrete MIO adaptation workflow: `Reference/mio/actual_mio_template_adaptation_workflow.md`
- Tree header text and positions: `Reference/mio/tree_header_text_reference.md`, `Reference/mio/tree_header_position_reference.md`
- Reusable coordinate skeletons: `Reference/mio/tree_coordinate_template_reference.md`

`Reference/mio/infantry_tank_template_workflow.md` is deprecated historical context; do not use it as the default workflow for new MIO reset work.

## Operating Rules

- Before making or resetting a project template MIO, read the smart layout workflow.
- Before adapting a playable country MIO to a Rance template, read the concrete adaptation workflow.
- When planning total-stat blocks, list relevant applicable `equipment_bonus` fields from the equipment stat reference, including explicit zero placeholders where useful.
- Do not add `mutually_exclusive = { ... }` to template MIOs unless explicitly requested.
- Keep `_documentation.md` as reference material, not active gameplay definition storage.
- Preserve UTF-8 without BOM and LF unless an existing file proves otherwise.
