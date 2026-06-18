# MIO Authoring Reference

Source: `common/military_industrial_organization/AGENTS.md`.
Applies to: `common/military_industrial_organization/`.

This file preserves detailed authoring notes migrated out of `common/military_industrial_organization/AGENTS.md`. Keep the corresponding `AGENTS.md` file as a concise operating entrypoint, and update this reference when long examples, syntax notes, workflows, or lookup explanations need to be maintained.

## Migrated Notes

# Military Industrial Organization Agents Notes

## Scope

These instructions apply to files under `common/military_industrial_organization/`.

In this document, `MIO` means `Military Industrial Organization`.

## Directory Structure

Common subdirectories:

- `common/military_industrial_organization/organizations/`
- `common/military_industrial_organization/policies/`

Common usage:
- `organizations/`: concrete MIO organization definitions
- `policies/`: MIO policy definitions

If the task is to write or modify an MIO tree, inspect the actual script under `organizations/` first instead of relying only on `_documentation.md`.

## File Encoding

Before writing or editing files, confirm the correct encoding first.

For this directory, follow the project default unless the user explicitly requests otherwise:

- script / markdown files: `UTF-8`
- localization files: `UTF-8 with BOM`

If Chinese text appears garbled, first verify the read path and encoding instead of immediately rewriting the content.
If a non-localization script accidentally uses BOM, HOI4 may report errors such as `Unexpected token`.

## Trait Naming Lookup

When naming MIO traits, use `Reference/mio/trait_naming_reference.md` as the primary naming reference.

- Prefer vanilla naming style instead of copying raw keys mechanically
- Decide whether the node is structural, functional, industrial, specialization-oriented, or organization-growth-oriented before naming it
- Template traits should prefer neutral, reusable, engineering-style names

## Trait Icon Lookup

When assigning MIO trait icons through `icon = GFX_...`, use `Reference/mio/trait_gfx_reference.md` as the primary lookup reference.

- Check whether the trait mainly gives `equipment_bonus`, `production_bonus`, or `organization_modifier`
- If one trait mixes several effects, choose the icon based on the dominant effect
- If no icon is clearly suitable, `GFX_generic_mio_trait_icon_unique` is an acceptable fallback

For template foundation nodes that mainly carry early `organization_modifier` baseline content such as research / growth / development setup:

- do not use `GFX_organization_modifier_icon`
- prefer `GFX_generic_mio_department_icon_facilities`

Reason:

- `GFX_organization_modifier_icon` visually overlaps badly with the lower mini-badge area in the trait UI
- `GFX_generic_mio_department_icon_facilities` reads more like a research / development / technical department icon while staying visually cleaner

## Equipment Stat Lookup

When writing `equipment_bonus = { ... }` for MIO traits, use `Reference/mio/equipment_stat_reference.md` as the primary lookup reference.

- This reference is based on `script_enum_equipment_stat`
- It is also supplemented by `common/military_industrial_organization/MIO_documentation_zh.md`
- Use it to confirm which stats can be used in MIOs
- Use it to identify fields that exist but are not recommended
- Use it to note DLC, module, or equipment-specific restrictions
- Use it to check finer per-equipment-type field coverage such as support equipment, artillery, anti-air, anti-tank, rocket artillery, mechanized, armored cars, trains, and railway guns

When equipment stat usage is uncertain, do not rely on enum presence alone.
Cross-check:

1. `script_enum_equipment_stat`
2. MIO usability notes such as `Cannot be used with MIOS`
3. the per-equipment lists and notes in `Reference/mio/equipment_stat_reference.md`

## Tree Layout Lookup

When designing MIO tree headers, use these references first:

- `Reference/mio/smart_layout_mio_template_workflow.md` for the default project workflow when making or resetting smart-layout template MIOs
- `Reference/mio/actual_mio_template_adaptation_workflow.md` for adapting concrete playable MIOs to Rance model templates
- `Reference/mio/tree_header_text_reference.md` for choosing `tree_header_text.text`
- `Reference/mio/tree_header_position_reference.md` for choosing absolute `tree_header_text.x`
- `Reference/mio/tree_coordinate_template_reference.md` for project-side reusable 15-node coordinate skeletons
- `Reference/mio/infantry_tank_template_workflow.md` only as deprecated historical context for the old fixed-template workflow

Interpretation rules:
- Before making or resetting a project template MIO, read `Reference/mio/smart_layout_mio_template_workflow.md` first unless the user explicitly asks for the deprecated fixed-template workflow
- Before adapting a real country MIO to a Rance template, read `Reference/mio/actual_mio_template_adaptation_workflow.md` first
- Use `tree_header_text_reference.md` to choose a suitable header text
- Use `tree_header_position_reference.md` to choose a suitable absolute header position
- Use `tree_coordinate_template_reference.md` when you want a reusable local node skeleton instead of borrowing one from vanilla
- Do not use `infantry_tank_template_workflow.md` as the default workflow for new MIO reset work
- Treat `tree_header_text.x` as the center position of the header, not a boundary

If the task is to build or revise an infantry tank template MIO for this project, consult `Reference/mio/smart_layout_mio_template_workflow.md` before redistributing nodes or rewriting branch meaning.

When resetting an existing template MIO, do not rely on the old node-level stat allocation by default.
Use the total-stat planning block near the top of the active template file as the source for a fresh node allocation, unless the user explicitly asks to preserve old nodes.
Old nodes may inform theme vocabulary, but they should not control the new stat split.

When creating or revising a total-stat planning block, consult `Reference/mio/equipment_stat_reference.md` for the intended equipment type before choosing `equipment_bonus` fields.
List all relevant applicable fields from that reference in the planning block, even when the current placeholder value is zero.
Use explicit zero placeholders such as `+0.00` or `0` so the user can fill or revise values later without reopening the reference manually.
Only omit fields that are clearly irrelevant to the intended equipment scope or explicitly excluded by the user, such as submarine-specific stats for a surface-raider template.

For smart-layout templates, keep the production lane mostly production-facing.
Avoid placing ordinary combat-performance bonuses in the production tree just to fill the center column.
Production-lane nodes should usually be about tooling, line expansion, production rhythm, standardization, maintenance workflow, cost, or resource economy.

When planning project templates from vanilla MIO references:

- summarize vanilla totals first
- by default, count totals while ignoring `mutually_exclusive`
- during early planning, equipment-type restrictions may also be ignored temporarily if the goal is only to compare vanilla identity and rough total direction
- when vanilla totals overlap with the project's default template baselines, use the higher planned value unless the user explicitly requests otherwise
- when adding placeholder stat lines, merge them into the active planning section instead of duplicating fields in a separate dump block
- place placeholder stat lines in the correct category order so defined values and undecided values stay readable together
- when reusing a vanilla skeleton, borrow only the node layout and connection logic unless the user explicitly asks to inherit vanilla route identity
- do not carry over vanilla specialization labels, profession labels, branch ideology, or route semantics by default

## MIO Basics

A complete MIO usually has these layers:

1. `allowed / visible / available`
2. `equipment_type` and `research_categories`
3. `initial_trait` plus multiple `trait = { ... }` blocks

When authoring an MIO, first distinguish whether the change belongs to:

- an organization root field
- an equipment or production bonus on a trait
- an `organization_modifier` for MIO growth behavior

## Minimal Organization Template

Prefer starting from a minimal valid structure like this:

```txt
MY_MIO = {
    icon = GFX_MY_MIO
    allowed = {
        original_tag = JAP
    }
    visible = { always = yes }
    available = { always = yes }

    equipment_type = {
        infantry
    }

    research_categories = {
        infantry_weapons
    }

    initial_trait = {
        name = MY_MIO_initial_trait
        equipment_bonus = {
            reliability = 0.05
        }
    }

    trait = {
        token = upgrade_1
        any_parent = { initial_trait }
        position = { x = 0 y = 1 }
        equipment_bonus = {
            soft_attack = 0.05
        }
        production_bonus = {
            production_cost_factor = -0.05
        }
    }
}
```

Minimum structure reminders:
- do not omit `allowed`
- a tree should include at least an `initial_trait` and one follow-up trait
- do not omit `position`
- make sure `equipment_type` and `research_categories` match the intended equipment scope

## Organization-Level Fields

Important fields at MIO root:

- `name`
- `icon`
- `background`
- `allowed`
- `visible`
- `available`
- `equipment_type`
- `research_categories`
- `research_bonus`
- `task_capacity`
- `ai_will_do`
- `tree_header_text`
- `initial_trait`
- `trait`

Common interpretation:
- `allowed`: who is eligible to own the MIO
- `visible`: whether it appears in UI
- `available`: whether it can currently be used
- AI-facing logic usually should consider both `visible` and `available`

## Trait Writing Rules

Trait blocks commonly include:

- `token`
- `name`
- `icon`
- `special_trait_background`
- `parent` / `any_parent` / `all_parents`
- `mutually_exclusive`
- `visible`
- `available`
- `on_complete`
- `limit_to_equipment_type`
- `equipment_bonus`
- `production_bonus`
- `organization_modifier`
- `position`
- `relative_position_id`
- `ai_will_do`

Interpretation:
- `equipment_bonus`: equipment stat bonuses
- `production_bonus`: production stat bonuses
- `organization_modifier`: MIO growth or organization-level bonuses

When writing a trait, first decide what kind of node it is, then align name, icon, and bonus type.

## Parent And Tree Layout

Trait tree authoring rules:

- Use `parent = token` for a normal single-parent node
- Use `any_parent` for one-of-many parent access
- Use `all_parents` for merge nodes
- Use `parent = { traits = { ... } num_parents_needed = X }` for more complex gate logic
- Use `position` for absolute placement

Layout guidance:
- Keep parent-child logic readable first
- Then use `tree_header_text` and coordinates to clean up the page
- Nodes on the same layer may be staggered slightly for better rhythm, as long as the main structure stays readable

## Equipment Scope Rules

`limit_to_equipment_type` is used to narrow a trait's effect within the wider `equipment_type` scope of the MIO.

Examples:
- an MIO supports `{ armor }`, but a trait only applies to `{ light_tank }`
- an MIO supports `{ light_tank medium_tank }`, but a trait should only affect part of that set

If one MIO supports multiple equipment types and one trait should only affect a subset, prefer using `limit_to_equipment_type`.

## Initial Trait

`initial_trait` is the default starting trait of the MIO.

Typical uses:
- establish the base identity of the MIO
- act as the parent of the rest of the tree
- provide light baseline bonuses

Do not overload `initial_trait` with too many growth-stage or highly thematic effects unless the user explicitly wants that.

## Include / Override Pattern

When reusing an existing MIO, prefer `include = ...` instead of fully copying the entire tree.

Common pattern:
- `include = SOME_MIO`
- `delete_included_values = { ... }`
- `add_trait = { ... }`
- `remove_trait = { ... }`
- `override_trait = { ... }`

Guidance:
- prefer `include + override_trait` for local changes
- avoid copying a full tree when only a few nodes need adjustment
- inspect the source MIO before modifying an inherited one

## AI Rules

`ai_will_do` in MIOs and traits is used as a multiplier context, not just a flat preference note.

AI guidance:
- do not treat it as a decorative field
- consider whether the AI can see, access, and prioritize the node
- central or baseline nodes may justify steadier `ai_will_do`

## Bonus Authoring Principle

When adding bonuses:

- keep them consistent with equipment fantasy
- avoid stacking too many unrelated stats in one trait
- separate quality-oriented bonuses from industrial bonuses when possible

Additional guidance:
- one trait should usually have a clear theme
- do not casually mix distant layers like `soft_attack`, `build_cost_ic`, `research_bonus`, and `task_capacity`
- if the node is mainly about MIO growth, prefer `organization_modifier`

## Equipment Stat Verification

Not every equipment type supports every stat.

Before writing `equipment_bonus`:
- confirm the equipment type actually supports the stat
- confirm whether there is DLC, module, or version gating

Examples from the current documentation:
- tanks may use stats such as `maximum_speed`, `reliability`, `breakthrough`, `soft_attack`
- ships have many module-gated stats
- planes have several BBA-gated stats
- infantry / artillery / support equipment use different stat sets

If documents conflict, record the uncertainty and prepare to test instead of guessing.

## Naming And Readability

Prefer clear, traceable naming.

Naming guidance:
- MIO key: use a traceable style such as `TAG_context_name`
- trait token: prefer semantic names, not `reliability_1` or `production_line_2`
- loc keys and gfx keys should line up with script meaning where practical

Avoid token styles like:
- `trait_a`
- `bonus2`
- `left_branch_final_new`

## User-Facing Explanations

When explaining an MIO to the user, prefer describing:

1. what equipment it supports
2. what the main trait branches do
3. what conditions make it visible or available
4. whether it is standalone or inherited from another MIO

Prefer describing structure and gameplay meaning instead of only repeating internal keys.

## Editing Principle

When modifying an existing MIO:

- read the full MIO block first
- if adapting a concrete playable MIO to a Rance model template, follow `Reference/mio/actual_mio_template_adaptation_workflow.md`
- then inspect related traits, inherited source MIOs, and any referenced localization / gfx if needed
- do not patch only the selected lines if surrounding structure changes the meaning

Always pay special attention to:
- `include = ...`
- `override_trait = { ... }`
- `mutually_exclusive = { ... }`
- `relative_position_id = ...`
- `visible / available`

## Documentation File Rule

`_documentation.md` is reference material, not the primary place to store active gameplay definitions.

Do not treat `_documentation.md` as the long-term home of real gameplay content.
If a rule is stable, prefer moving it into `AGENTS.md` or a dedicated reference file.

## Template Organization Rules

When writing template organizations for this project, such as `Rance_model_organization` or other archetype-like model files, follow these rules by default unless the user explicitly asks otherwise.

### No Mutual Exclusivity In Templates

Template organizations should not use mutual exclusivity by default:
- do not add `mutually_exclusive = { ... }` unless explicitly requested
- archetype templates are meant to support quick derivation and later edits
- avoid locking routes too early in template stage

### Trait Count Target

The default trait count target for template organizations is `12` to `16`:
- treat `12` to `16` as the preferred range
- do not let template trees become uncontrolled long-form trees by default
- this range exists to keep templates easy to adapt later

### Standard Initial Trait Baseline

Template organizations should keep a default baseline of organization modifiers and production bonuses, but these two groups do not share the same default placement.

Recommended default content:

```txt
organization_modifier = {
    military_industrial_organization_research_bonus = 0.15
    military_industrial_organization_funds_gain = 0.15
    military_industrial_organization_size_up_requirement = -0.15
}

production_bonus = {
    production_capacity_factor = 0.05
    production_cost_factor = -0.05
    production_efficiency_cap_factor = 0.05
    production_efficiency_gain_factor = 0.1
    production_resource_need_factor = -0.25
}
```

Usage rules:
- do not place this `organization_modifier` block directly in `initial_trait` by default
- do not place this `production_bonus` block directly in `initial_trait` by default
- give `organization_modifier` on early nodes by default, even if the user did not list it in the stat plan
- treat `production_bonus` as default-given baseline, but not necessarily as an early-node-only package
- if the current template stat plan already contains the same category of `production_bonus`, use the higher value by default
- if the user has a clearer design target, follow that target

### Template Header Text Naming

For template organizations, the header field `tree_header_text.text` should default to a pattern like `RA Infantry Tank Designer`.

Usage rules:
- default pattern: `RA + equipment/category + Designer`
- for production-oriented templates, `RA + equipment/category + Manufacturer` is also acceptable
- this rule applies to the header field, not to `initial_trait`

### Template Priority

Default priority when building a template:

1. clear structure
2. clear stat plan
3. matching naming and icons

Do not sacrifice readability and later maintainability for superficial neatness.

## Template Addendum

These addendum rules apply to template MIO files such as `Rance_model_organization.txt`.

### Custom Tree Header Text

If no existing vanilla `tree_header_text.text` key is semantically suitable, it is acceptable to create a custom header key and add matching localization.

- custom header keys are allowed
- keep them traceable and maintainable
- always add localization for custom header keys

### Node Allocation Output Preference

When the user asks to split planned totals into node-level allocation:

- default to presenting the node-by-node split in the chat response
- do not automatically write the node allocation list into planning comments
- keep file comments focused on total-stat planning unless the user explicitly asks to persist node allocation in the file
- if the user wants the node plan preserved later, confirm whether it should go into comments or directly into trait implementation

When writing template planning comments for `Suggested equipment_bonus totals`:

- list equipment stats in one continuous planning block by default
- do not split the equipment stat plan into qualitative subgroups such as survivability, gun line, or utility unless the user explicitly requests that format
- include relevant applicable `equipment_bonus` fields from `Reference/mio/equipment_stat_reference.md` even if they are only zero placeholders
- use zero placeholders for undecided fields instead of omitting them, unless the field is clearly outside the intended equipment scope
