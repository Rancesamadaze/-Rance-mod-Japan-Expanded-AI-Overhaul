# HOI4 MIO Rewrite And Authoring Workflow

> Deprecated: this older MIO template workflow has been superseded by
> `Reference/mio/smart_layout_mio_template_workflow.md`.
>
> Keep this file only as historical context for the first infantry tank reset.
> For new MIO authoring or future MIO resets, use the smart-layout workflow by default.

## Purpose

This reference summarizes the reusable workflow established while rewriting the project infantry tank template MIO.

It now serves two use cases:

1. rewriting an existing MIO that already has script content
2. authoring a new project MIO from planning to implementation

This file is not limited to infantry tanks anymore.
The infantry tank pass is the example that produced the rules, but the workflow is intended to be reused across project MIO work.

## Current Example

Current working example:

- `common/military_industrial_organization/organizations/Rance_model_organization.txt`

Current reference tree:

- `Rance_model_infantry_tank_organization`

## Core Principle

When rewriting or authoring a project MIO, separate four things clearly:

1. total stat plan
2. node count and coordinate skeleton
3. connection rules
4. naming / icon / localization sync

Do not mix these into one step.

The infantry tank rewrite showed that most cleanup problems happen when people jump directly from old nodes to new names without first locking totals, skeleton, and connection rules.

## Scope Split: Rewrite vs Authoring

### Rewrite Existing MIO

Use the rewrite path when:

- the MIO already exists in script
- nodes already have bonuses
- you need to redistribute, rename, or reconnect the tree

Rewrite priority:

1. count actual totals first
2. compare them with planning comments
3. lock the new target structure
4. only then rewrite script

### Author New MIO

Use the authoring path when:

- the MIO does not exist yet
- or only planning comments exist
- or you are starting from a fresh template

Authoring priority:

1. define target totals
2. choose node count
3. choose coordinate skeleton
4. assign node meaning
5. write script
6. localize after structure stabilizes

## Recommended Workflow

### 1. Read The Actual Script First

Before modifying an MIO:

- read the full MIO block
- do not rely only on comments
- do not rely only on selected lines
- inspect the actual `trait = { ... }` content before planning changes

If the MIO already exists, script truth is the source of truth for current implementation.

### 2. Audit Actual Totals Before Redesign

If the task is a rewrite, first summarize actual implemented totals from the live script.

Always audit these three layers separately:

1. `equipment_bonus`
2. `production_bonus`
3. `organization_modifier`

Then compare:

- actual totals
- planning comments
- intended new totals

Do not start node redistribution until you know whether the old implementation already matches the intended totals.

The infantry tank rewrite confirmed an important habit:

- if current actual totals already match the intended plan, keep the totals and only rewrite structure

### 3. Lock The Stat Plan First

After the audit, freeze the working totals before touching the tree.

For project templates and rewrites, distinguish three layers:

1. equipment totals
2. organization baseline
3. production baseline

Default template baseline remains:

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
    production_efficiency_gain_factor = 0.10
    production_resource_need_factor = -0.25
}
```

Important project rule established during the infantry tank rewrite:

- the three organization baseline modifiers are fixed together as one starting node by default

That means:

- do not split them into multiple nodes unless the user explicitly asks
- do not scatter them across the tree by default

### 4. Choose Node Count Before Choosing Names

Before writing or rewriting node names, determine the target node count.

Current project preference:

- default to keeping more nodes when practical
- avoid compressing too early unless the user explicitly wants a tighter tree

When reducing a 15-node template, use:

- `Reference/mio/tree_coordinate_template_reference.md`

Current trimming preference:

1. prefer higher retained counts when possible
2. if trimming is needed, remove from `y = 3` first
3. then remove from `y = 1`
4. within one layer, trim symmetrically from the center outward
5. avoid touching `y = 2` and `y = 4` early

### 5. Choose The Coordinate Skeleton

After node count is locked:

- choose the most suitable coordinate template
- then apply the trim rules

Use:

- `Reference/mio/tree_coordinate_template_reference.md`

Interpretation:

- coordinate templates define visual skeleton only
- they do not define route meaning automatically
- they do not define connection logic automatically
- current active template pool is `B / D / E`
- treat `A / C / F` as deprecated unless the project rules change again

For the infantry tank rewrite, a later pass showed that a 13-node tree looked better than an 11-node tree because the added spacing preserved the lower structure more cleanly.

This established a practical lesson:

- if the tree feels cramped or visually awkward, test a higher retained node count before over-optimizing names or links

### 6. Allocate Stats To Nodes By Theme

After totals and node count are fixed, assign bonuses to node themes.

Use semantic grouping, not arbitrary packing.

Current project rules established during the infantry tank rewrite:

- if the same stat is small (`<= 0.10`), do not split it by default
- if the same stat is large (`> 0.15`), it may be split if the structure benefits from it
- `production_resource_need_factor` is a special case and should not be split by default
- if multiple fields are placed in one node, prefer semantically adjacent fields

Examples from the infantry tank rewrite:

- `reliability +0.10` stayed concentrated
- `defense +0.05` stayed concentrated
- `maximum_speed +0.10` stayed concentrated
- `hard_attack +0.10` and `ap_attack +0.15` stayed grouped as one anti-armor node
- `armor_value +0.25` remained split because the armor line naturally supports staged progression
- `production_resource_need_factor -0.25` remained one node even though the value is large

### 7. Apply The Standard Connection Rules

Once the node meanings are locked, wire the tree.

Current standard project connection rules:

1. node connections should be as symmetrical as practical
2. direct prerequisites should come only from the immediately previous layer
3. center-axis nodes (`x = 4`) should use `all_parents`
4. those `all_parents` should come from previous-layer nodes whose `x` falls in the `3 ~ 5` band
5. non-center nodes should default to `any_parent`
6. do not use `mutually_exclusive` by default in project templates

This means:

- layout first
- layer discipline second
- then connection type

Do not keep old cross-layer links just because they existed before the rewrite.

### 8. Rewrite Script Before Localization

When the tree is being rewritten:

- first update `token`
- then update `name`
- then update coordinates and parents
- then update bonus distribution

Only after the script structure is stable should you rewrite localization.

Do not localize too early.

### 9. Sync Names, Icons, And Meaning Together

When a node meaning changes, update all of these together:

- `token`
- localization key in `name =`
- icon
- bonus content
- parent logic if the role changed

Do not leave old names attached to new meanings.

The infantry tank rewrite specifically showed that this cleanup is essential.
A structurally rewritten tree with old token names quickly becomes misleading.

### 10. Localize In The Correct File

For this project:

- script files use `UTF-8`
- localization files use `UTF-8 with BOM`

When adding or revising MIO localization:

- prefer `localisation/simp_chinese/JAP_mio_l_simp_chinese.yml` for Japan MIO content
- do not dump unrelated localization into `SEA_focus_l_simp_chinese.yml`

Before writing localization:

- confirm encoding
- preserve BOM in the localization file

### 11. Verify The Rewrite After Implementation

After script changes are written, verify at least:

1. node count matches the intended target
2. actual totals still match the intended totals
3. center-axis nodes follow the `all_parents` rule
4. non-center nodes use `any_parent` unless there is a justified exception
5. direct prerequisites come only from the previous layer
6. naming, icon, and node meaning remain aligned
7. localization covers every active node key

If the task was a rewrite, also verify:

- no stale old keys remain in script references
- no obsolete localizations remain for removed nodes in the active segment

## Rewrite Checklist

Use this checklist when rewriting an existing MIO:

1. Read the full current block
2. Count actual totals from live script
3. Compare with planning comments
4. Freeze target totals
5. Pick target node count
6. Pick coordinate skeleton and trim if needed
7. Reassign node themes
8. Apply standard connection rules
9. Rewrite tokens, names, and icons
10. Update localization after script stabilizes
11. Recount totals and verify links

## Authoring Checklist

Use this checklist when writing a new MIO from scratch:

1. Define total stat plan
2. Separate equipment / production / organization layers
3. Lock target node count
4. Choose coordinate skeleton
5. Assign node themes conservatively
6. Apply standard connection rules
7. Write script
8. Align names and icons
9. Write localization in the correct file and encoding
10. Verify totals and link rules

## Infantry Tank Lessons To Reuse

The infantry tank rewrite established these reusable lessons:

- actual totals should be audited before any redesign
- if current totals are already correct, restructure without changing totals
- organization baseline should stay bundled in the starting node
- larger trees may look better than over-compressed trees
- coordinate trimming and connection rules should be explicit, not improvised
- connection symmetry and previous-layer-only prerequisites noticeably improve readability
- token renaming should be treated as structural cleanup, not optional polish

## Archive Status

This file is no longer the default workflow for project MIO refactors or authoring.

Treat it as:

- historical context for the first infantry tank workflow pass
- an archive of older fixed-template and rewrite habits
- secondary background only when reading older project notes

For active work, use:

- `Reference/mio/smart_layout_mio_template_workflow.md`
