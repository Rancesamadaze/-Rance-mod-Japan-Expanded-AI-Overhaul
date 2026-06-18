# HOI4 MIO Smart Layout Template Authoring Workflow

## Purpose

This workflow is the default smart-layout MIO template authoring workflow.

In Chinese project discussions, this workflow means:

```txt
智能排版MIO模板制作工作流
```

It supersedes the older `infantry_tank_template_workflow.md` path.

Use this path when the user wants a project MIO tree designed from node meaning instead of choosing a fixed coordinate template first.
For current project MIO rewrites, this should be treated as the primary workflow unless the user explicitly asks to use a fixed coordinate template.

The default mode is now assistant-proposed semantic layout:

1. the assistant classifies nodes
2. the assistant creates an unconnected draft layout
3. the user accepts, revises, or sends it back for manual coordinate editing
4. only after layout approval does the assistant write connections

The original template-based workflow is deprecated for normal project MIO work.
Older template-coordinate references may still be useful as layout inspiration, but they should not decide the tree skeleton before node meaning is understood.

## Core Principle

Separate the MIO process into three phases:

1. assistant-led stat and node preparation
2. assistant-led semantic layout proposal
3. user approval or user-led coordinate correction

The assistant should prepare meaningful nodes with names and icons, propose a clean layout from role categories, and leave the tree unconnected until the layout is accepted.

## Workflow

### 1. Lock The Stat Plan

First define or confirm the intended total bonuses.

Keep the same three-layer split used elsewhere in project MIO work:

1. `equipment_bonus`
2. `production_bonus`
3. `organization_modifier`

For rewrites, read the actual live script first and use it as the current source of truth.

When rewriting or resetting a project template MIO, do not inherit the old trait-level stat allocation by default.
Old traits may be useful for understanding the previous theme, but their node split should not decide the new node split.
Instead, find the total-stat planning block near the top of the file and redistribute those totals into a fresh node plan.
If the top-level total plan and the live implementation disagree, report the discrepancy before editing and ask which source should win unless the user has already specified one.

When creating or revising a total-stat planning block, consult `Reference/mio/equipment_stat_reference.md` for the intended equipment scope before choosing `equipment_bonus` fields.
The planning block should include all relevant applicable fields from that reference, including fields that currently have zero or placeholder values.
Use explicit zero placeholders such as `+0.00` or `0` for undecided fields so the user can revise the plan later without reopening the field reference.
Only omit fields that are clearly irrelevant to the intended scope or explicitly excluded by the user.

### 2. Split Stats Into Nodes In Conversation

After the stat plan is known, the assistant proposes a node split in the chat before editing the script.

This split should:

- group stats by theme
- preserve intended totals
- avoid unnecessary node count inflation
- not follow the old "prefer more nodes" rule by default
- avoid making ordinary nodes feel too numerically heavy

The user may approve, revise, merge, or split nodes before implementation.

### 2.1 Keep Node Weight Readable

Manual-layout trees should feel like a set of readable incremental upgrades.

Do not compress many bonuses into one node just because the workflow no longer prefers maximum node count.

Use this sense of scale:

- small, closely related stats may share one node
- medium stats often deserve their own node
- large stats should usually be split unless the user accepts them as a special case
- strongly bound themes may stay together when separating them would make the tree less readable

Accepted special cases from the infantry tank reset:

- the fixed organization baseline may stay bundled in one foundation node
- a resource / material economy node may carry `production_resource_need_factor` as its main heavy value
- production economy nodes may combine a small design-cost bonus with production-cost or resource bonuses if the theme is clear

When unsure, prefer a slightly finer split and let the user merge nodes during the conversation.

### 3. Classify Nodes For Semantic Layout

After node split is accepted, classify every non-foundation node into one of three primary layout lanes:

1. production lane
2. bonus direction A
3. bonus direction B

The foundation node is separate from these lanes.

The production lane should stay industrial by default.
Prefer placing only manufacturing, tooling, production rhythm, standardization, maintenance workflow, cost, resource, and other clearly production-facing bonuses there.
Avoid putting ordinary combat-performance bonuses into the production lane merely to balance coordinates or fill the center column.
If a node mixes production with equipment stats, the equipment stats should be minor, tightly tied to the production theme, and explained before writing the skeleton.
When in doubt, keep equipment-performance nodes in bonus direction A or B instead of the production lane.

Typical foundation nodes:

- research bureau
- design bureau
- command bureau
- coordination office
- general assembly department
- basic committee

The foundation node should stay at the top center.

### 3.1 Balance The Two Bonus Lanes

Bonus direction A and bonus direction B should have the same number of nodes whenever practical.

Production nodes do not count toward left-right balance.

If A and B are uneven, rebalance by:

- splitting a heavy node
- merging light adjacent nodes
- moving a node whose theme can reasonably belong to the other direction
- moving a neutral node into the production lane if it is more about manufacturing than combat performance

Do not force balance by making nonsense semantic assignments.
If perfect balance would damage meaning, explain the exception before writing the skeleton.

### 3.1.1 Reduce Vertical Pressure In Large Lanes

When one bonus lane has more than three nodes, avoid placing it as a long single vertical chain by default.

Prefer parallel and branch structures to reduce `y`-axis pressure.

Useful patterns:

- `2-1`: two entry nodes converge into one later node
- `2-2`: two entry nodes continue into two matched later nodes
- `2-2-1`: two entry nodes, two branch developments, one lane-level capstone

When both A and B have the same high node count, prefer matching their internal rhythm.

Example:

```txt
left A:   2-2-1
right B:  2-2-1
```

This keeps left and right trees visually balanced while avoiding overly tall lanes.

Only use a pure vertical chain when the lane is clearly a strict linear progression.

### 3.2 Decide Whether A Convergence Node Exists

A bottom-center convergence node is optional.

Use one when the node theme is naturally final or integrative, such as:

- final improvement
- integrated optimization
- mass-production conversion
- resource saving
- material simplification
- standardization
- total system integration
- final model / final package

Do not create or force a convergence node if the current stat plan has no suitable final concept.

### 4. Build An Unconnected Semantic Skeleton

After the node split is accepted, the assistant writes a temporary skeleton into the script.

The skeleton should include:

- `token`
- `name`
- `icon`
- `position`
- bonus blocks

The skeleton should not include:

- `any_parent`
- `all_parents`
- `parent`
- `mutually_exclusive`

Initial coordinates are only a staging layout.

Default lane layout:

- bonus direction A goes on the left tree
- production goes on the middle tree
- bonus direction B goes on the right tree

The general visual structure is:

```txt
            foundation

left bonus A     production     right bonus B
left bonus A     production     right bonus B
left bonus A     production     right bonus B

           optional convergence
```

Left and right bonus nodes should appear in matched `y` layers when practical.
The production lane may have its own vertical rhythm and does not need to mirror either side.

For smart-layout trees with a clear three-lane structure, prefer three accurate `tree_header_text` blocks instead of one lazy center header.

Recommended header placement:

- left A header near the center x of the left lane
- production header near the center x of the production lane
- right B header near the center x of the right lane

Use custom project header keys when vanilla headers are too vague or would mislead the player.
Add localization for every custom header key.

Current manual-layout staging rule:

- the fixed organization-modifier foundation node may stay near the top
- if the user wants to manually reshape the tree, all other temporary skeleton nodes should start at `y >= 5` where practical
- if the assistant is proposing the first semantic layout, use real candidate coordinates directly

The user then either:

- accepts the assistant layout and asks for connections
- asks the assistant to revise the layout
- manually adjusts `position = { x = ? y = ? }` in the script until the tree shape is satisfactory

After writing a smart-layout skeleton, the assistant must explain the intended structure before the user starts manual adjustment.

This explanation should include:

- which nodes are in bonus direction A, production, and bonus direction B
- which nodes are meant to be entry nodes
- which nodes are meant to be branch developments
- which nodes are meant to be lane capstones or convergence nodes
- what progression each lane is trying to express
- whether any node order depends on a specific semantic chain

If the assistant thinks some nodes may need to be swapped to preserve the intended progression, say so before the user manually edits coordinates.

The goal is to prevent the user from accidentally breaking an implicit design idea that was only visible to the assistant.

The temporary skeleton comment should mark the block as unfinished, for example:

```txt
## Smart layout skeleton.
## Connections are intentionally left empty until layout is approved.
```

### 5. Finalize After Layout Approval

After the user accepts the assistant layout or finishes manual coordinate adjustment, the assistant performs a finalization pass.

Finalization includes:

1. reorder trait blocks by visual row scan
2. write parent connections
3. verify totals
4. verify naming, icons, and localization coverage
5. update the block comment to show that smart layout is finalized

Row-scan ordering means:

1. lower `y` values come first
2. within the same `y`, lower `x` values come first

After finalization, use a clear comment such as:

```txt
## Smart layout finalized.
```

### 6. Connection Rules

Connection rules are intentionally left flexible until a specific MIO pass defines them.

At finalization time, decide the rules from:

- the user's intended visual shape
- node themes
- previous-row adjacency
- route meaning

Do not assume the deprecated fixed-coordinate template workflow's connection rules automatically apply.

Default connection logic for the semantic lane layout:

1. the foundation node may connect to the starting nodes of A, production, and B
2. A-lane nodes should mainly connect within A
3. production-lane nodes should mainly connect within production
4. B-lane nodes should mainly connect within B
5. avoid cross-lane links except from the foundation or into a convergence node
6. if a convergence node exists, it may collect the final nodes from A, production, and B
7. left and right lane links should be as symmetrical as the node counts and meanings allow

This means:

- left tree A, middle tree production, right tree B
- internal route logic before cross-tree cleverness
- cross-tree links only when the node is explicitly a start or end integrator

Connection authoring remains collaborative:

- the assistant may propose a first connection pass from shape and node meaning
- the user may then correct links manually
- after user correction, treat the user's connections as the intended route logic
- do not keep reapplying a generic connection rule over the user's manual link choices

When writing connections, prefer readable direct references.

Use `all_parents` when a node is clearly intended as a convergence point.
Use `any_parent` when a node is a route continuation or optional progression.

### 7. Localization Cleanup

After the tree structure and node names stabilize, clean localization for the finished tree.

For the active MIO:

1. list every active localization key used by the organization, header, initial trait, and trait names
2. check that each active key exists in the intended localization file
3. remove stale localization keys that belonged only to removed nodes in this tree
4. check for duplicate localization keys in the same file
5. keep shared keys only once when their text is intentionally shared across multiple template MIOs
6. preserve UTF-8 with BOM for localization files

If the user wants to polish names externally, provide a compact `key: current text` list.

## Notes

- This workflow is useful for collaborative layout design.
- Temporary skeletons may be visually incomplete until the user finishes coordinate editing.
- Localization should still be written or revised only after node names stabilize.
- Script files use UTF-8.
- Localization files use UTF-8 with BOM.

## Project Example Trees

The following completed trees are project examples for this workflow:

- `Rance_model_infantry_tank_organization`
- `Rance_model_high_agility_fighter_aircraft_manufacturer_organization`
- `Rance_model_battle_line_ship_manufacturer_organization`

Use these examples as stronger references than the older fixed-coordinate template workflow.

### Shared Lessons

- the reusable pattern is not the exact coordinates, but the lane logic: left bonus A, middle production, right bonus B
- balanced A and B node counts made the left and right trees easy to mirror
- when a lane grows beyond three nodes, branch structures such as `2-2-1` reduce vertical pressure better than a straight chain
- foundation and convergence nodes are the natural exceptions to the "no cross-lane links" rule
- if the user wants to hand-shape the tree, lowering non-foundation temporary nodes to `y >= 5` can keep the main design space clear
- the final row-scan order made later reading much easier
- user-corrected links should be considered more authoritative than assistant-inferred links
- localization cleanup should happen after the link and coordinate pass, not before
- after the assistant creates a smart skeleton, it must explain its hidden progression assumptions so the user can preserve or reject them during manual adjustment

### Infantry Tank Example

`Rance_model_infantry_tank_organization` is the reference for a clean three-lane ground equipment tree:

- left lane: mobility / protection
- middle lane: production preparation
- right lane: assault firepower
- bottom convergence: material simplification

This example is useful when a tree has a clear combat-performance split and a compact production lane.

### High Agility Fighter Example

`Rance_model_high_agility_fighter_aircraft_manufacturer_organization` is the reference for a wide air-equipment tree with user-adjusted final layout:

- left lane: airframe quality, wing maneuver, light weapon, interceptor airframe
- middle lane: line expansion, rhythm optimization, standardized tooling, material / cost economy
- right lane: engine power, high-output fuel, short-wing tuning, intercept geometry
- bottom convergence: final interceptor package

This example is useful when the left and right lanes are both performance-oriented but express different engineering directions.

### Battle Line Ship Example

`Rance_model_battle_line_ship_manufacturer_organization` is the reference for a large naval tree with strong visual symmetry:

- left lane: hull protection and survivability
- middle lane: shipyard production and command workflow
- right lane: gunnery, AA, and fire-control development
- bottom convergence: material simplification

This example is useful when a lane has more than three nodes and should use parallel or branch structure to avoid excessive vertical depth.
