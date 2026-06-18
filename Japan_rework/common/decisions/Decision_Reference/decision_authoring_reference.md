# Decision Authoring Reference

Source: `common/decisions/AGENTS.md`.
Applies to: `common/decisions/`.

This file preserves detailed authoring notes migrated out of `common/decisions/AGENTS.md`. Keep the corresponding `AGENTS.md` file as a concise operating entrypoint, and update this reference when long examples, syntax notes, workflows, or lookup explanations need to be maintained.

## Migrated Notes

# Decisions Agents Notes

## Scope

These instructions apply to files under `common/decisions/`, including:

- decision definition files such as `common/decisions/*.txt`
- decision category files such as `common/decisions/categories/*.txt`

## Purpose

This directory defines decision categories, regular decisions, targeted decisions, and mission-style decisions for the mod.

When editing here, keep structure, trigger responsibility, icon references, and map behavior consistent with existing mod patterns.

## File Encoding

Before editing, confirm the file encoding first.

- Decision script files under `common/decisions/`: `UTF-8`
- Localization files referenced by decisions: `UTF-8 with BOM`

Do not introduce BOM into script files under `common/decisions/`.

## Category Structure

A decision category will usually define:

- `icon`
- `picture` when decorative artwork is actually needed
- `scripted_gui` only when the category is designed to use one
- `allowed`
- `visible`
- `available`
- `priority` when ordering matters
- `visible_when_empty` when the category should remain visible without visible child decisions

Keep category blocks conservative and avoid adding fields that are not needed by the design.

When working on decisions inside an existing decision group, always check the matching category definition under `common/decisions/categories/*.txt` before adding per-decision gates. Many groups in this mod define category-level `visible`, `allowed`, `available`, icons, or `visible_when_empty` there, while the child decisions live in `common/decisions/*.txt`.

Do not assume a decision group lacks category-level logic just because the decision definition file begins directly with a category block and child decisions. Search `common/decisions/categories/` for the same category key first.

If a category already gates visibility for AI, route, unlock state, or ownership, do not duplicate that same `visible` condition on every child decision unless the child decision intentionally needs a narrower condition. Keep child `available` focused on the actual click/completion requirements.

## Icon Rules

When editing decision category icons or regular decision icons:

- verify that `icon = GFX_...` points to a real vanilla or modded sprite key
- do not assume a near-miss key is valid just because the spelling looks plausible
- if the icon is uncertain, check the matching `.gfx` registration or vanilla decision category definitions first

Use `Reference/decision_icon_reference.md` as the primary quick lookup for common `decision type -> icon code` matching.

When adding a new decision, choose an icon based on the decision's actual theme from that reference before falling back to `GFX_decision_generic_decision`. For example, prefer military, naval, air, research, industry, or political generic icons when they match the content.

When fixing an icon key, verify both parts:

- the script-side `icon = GFX_...` reference
- the actual registered `GFX_...` name

## Decision Structure

A regular decision will commonly use:

- `icon`
- `cost`
- `days_remove`
- `fire_only_once`
- `days_re_enable`
- `allowed`
- `visible`
- `available`
- `remove_trigger`
- `cancel_trigger`
- `modifier` or `targeted_modifier`
- `complete_effect`
- `remove_effect`
- `cancel_effect`
- `ai_will_do`

Prefer keeping the responsibility split clear:

- `allowed`: opening or setup-time restriction, not something that should constantly flicker
- `visible`: whether the player should currently see the decision
- `available`: whether the visible decision is currently clickable or completable
- `cancel_trigger`: cancellation condition for an active timed decision, and it takes priority over `remove_trigger`
- `remove_trigger`: condition that removes an active decision while it is running

## State And Province Shorthand

When the user writes shorthand such as `s609`, interpret it as state ID `609`.

When the user writes shorthand such as `p12043`, interpret it as province ID `12043` in most decision-building contexts.

Before writing effects or triggers from these shorthand forms:

- strip the leading `s` or `p` when inserting numeric IDs into script
- verify province-to-state membership with `Reference/state_province_reference.md` when it affects control checks, placement, or localization
- if a `p...` value could plausibly mean something other than a province ID in context, confirm from nearby wording or ask before writing

## RAS Railway And Supply Hub Shorthand

When the user says:

`ras <province_a> to <province_b>`

interpret it as a request to add a railway-and-supply construction decision:

- build a level 5 railway from province `<province_a>` to province `<province_b>`
- add one supply hub in province `<province_b>`
- keep the surrounding decision category, trigger style, timed decision style, AI behavior, formatting, encoding, and line endings consistent with the edited file

When the user says:

`rail <province_a> to <province_b>`

interpret it as a request to add only a level 5 railway from province `<province_a>` to province `<province_b>`, with no supply hub added.

Accept minor shorthand variants such as `RAIL <province_a> <province_b>` as equivalent to `RAIL <province_a> to <province_b>` when the intent is clear.

When working on the “军需省——战备建设局” decision series, also use:

- `Reference/war_readiness_construction_decision_workflow_reference.md`

That reference records the project-specific workflow for war-readiness construction decisions, including when to use one-time decisions, staged decisions, RAIL/RAS effects, control checks, localization placement, and when explicit railway `path = { ... }` should or should not be used.

Before writing a RAS or RAIL decision:

- check `Reference/state_province_reference.md` for the state containing `<province_a>` and the state containing `<province_b>`
- check `Reference/building_reference.md` for current railway and supply hub construction syntax
- use the localized Chinese state names in user-facing explanations when state identity matters

Default control rule:

- require control or full control of the start province's state and the destination province's state
- if both provinces are in the same state, one state check is enough
- do not infer intermediate-state requirements by default; if the railway should also require control of states along the route, wait for the user to provide those intermediate states or provinces

Default naming rule:

- decision key: `JAP_war_readiness_build_railway_<province_a>_to_<province_b>_supply_<province_b>`
- completion flag: `JAP_war_readiness_railway_<province_a>_to_<province_b>_supply_<province_b>_completed`
- keep existing prefix patterns if the surrounding decision group already uses a clearer, more specific prefix

Default RAS effect pattern:

```txt
build_railway = {
	level = 5
	build_only_on_allied = yes
	fallback = yes
	start_province = <province_a>
	target_province = <province_b>
}
<destination_state_id> = {
	add_building_construction = {
		type = supply_node
		level = 1
		province = <province_b>
		instant_build = yes
	}
}
```

Default RAIL effect pattern:

```txt
build_railway = {
	level = 5
	build_only_on_allied = yes
	fallback = yes
	start_province = <province_a>
	target_province = <province_b>
}
```

`build_railway` is already an immediate effect in the script layer, so do not add `instant_build = yes` to it unless vanilla syntax or the project reference is later updated to support that parameter.

Localization rule:

- add the decision title and description to the most appropriate decision-related localization file
- do not add unrelated RAS localization to `localisation/simp_chinese/SEA_focus_l_simp_chinese.yml` unless the user explicitly requests that file

## Mission-Style Decisions

When writing mission-style decisions, keep the mission flow explicit:

- `days_mission_timeout`: mission duration
- `allowed`: setup-time display gate
- `activation`: condition for the mission to appear
- `available`: mission completion condition
- `timeout_effect`: effect when the mission expires without completion
- `complete_effect`: effect when the mission is completed
- `cancel_trigger` and `cancel_effect`: explicit cancellation path

Use `selectable_mission = yes` only when the mission should require an explicit player click instead of acting like a passive timed mission.

Use `is_good = yes/no` intentionally, because it changes the mission progress bar color and therefore player expectation.

## Reset And Repeat Logic

When implementing repeatable or resettable decisions, be explicit about which behavior you want:

- use `fire_only_once = yes` for true one-time decisions
- use `days_re_enable` when a decision should become available again after a cooldown
- use mission `activation` plus completion or timeout effects when the content should re-enter through a mission loop instead of a normal cooldown

Do not mix one-time, cooldown, and mission-reset behavior casually in the same design without making the intent obvious.

## Cost Rules

When using decision costs:

- use `cost` for normal political power style costs
- use `custom_cost_trigger` and `custom_cost_text` only when the cost is custom and must be explained through tooltip text
- remember that custom cost text does not deduct anything by itself, so the actual deduction must be handled in `complete_effect`

## Targeted Decisions

Targeted decisions may be generated through:

- `targets = { ... }`
- `target_array = ...`
- unrestricted scanning through `target_trigger` or `target_root_trigger`

Be deliberate about scope:

- `ROOT` is the country that owns the decision
- `FROM` is usually the target country for targeted country decisions
- for state-targeted decisions, `FROM` is typically the target state

Prefer narrower generation when possible. Avoid full-scope scanning unless there is a strong reason, because it is harder to read and can be more expensive.

## State Targets And Map Display

When writing state-targeted decisions:

- use `state_target` intentionally
- prefer narrow values such as `any_owned_state`, `any_controlled_state`, or a continent key instead of broad `any` when possible
- use `on_map_mode` deliberately so the decision appears where the player expects

Possible map display patterns include:

- `map_only`
- `decision_view_only`
- `map_and_decisions_view`

If a category or decision is supposed to guide map interaction, also consider:

- `highlight_states`
- `highlight_state_targets`
- `highlight_provinces`
- `highlight_states_trigger`
- `on_map_area`

Keep in mind that category-level map helpers and decision-level map helpers should not contradict each other.

## Effect Timing

Be clear about timing when assigning effects:

- `complete_effect`: what happens when the decision starts or is taken
- `remove_effect`: what happens when the timed decision finishes or is removed normally
- `cancel_effect`: what happens when it is canceled
- `timeout_effect`: what happens when a mission expires

If war preparation warnings are needed, use `war_with_on_complete`, `war_with_on_remove`, or `war_with_on_timeout` only when the linked effect timing actually matches the intended declaration timing.

## AI And Route Logic

When a decision depends on route logic, AI logic, or difficulty logic:

- prefer existing scripted triggers over duplicating long trigger blocks
- use `Reference/route_difficulty_scripted_trigger.md` when route or difficulty trigger usage is uncertain

## Variable Usage

When decisions use variables for costs, thresholds, counters, cooldowns, or route state:

- follow existing project variable patterns
- check `Reference/variable_syntax_reference.md` before writing uncertain variable logic
- keep temporary variables, scoped variables, and stored values clearly separated

## Commerce Ministry Workflow Reference

When working on “商工省” style decisions, especially content that follows the pattern:

- focus unlocks a decision category
- scripted trigger gates category visibility
- a starter decision records variables and activates a mission
- the mission validates construction results and gives success / timeout rewards
- AI strategies are written to help complete the mission

use:

- `Reference/commerce_ministry_decision_workflow_reference.md`

## Localization Habits

When discussing a decision or category with the user, prefer the localized Chinese name when it is easy to confirm from localization.

When writing or revising localization used by decisions:

- follow `Reference/localisation_formatting_reference.md`
- keep color codes and line breaks deliberate and readable

## Editing Rules

- preserve unrelated categories and decisions
- keep formatting close to the surrounding file
- avoid renaming decision keys or category keys unless the user explicitly wants that
- when copying a template, remove placeholder fields that are not actually used
- when writing targeted or mission logic, make the intended lifetime and removal path obvious from the script

## Vanilla HOI4 Reference

If syntax or vanilla behavior needs to be checked, inspect the user's local Hearts of Iron IV installation under its Steam library location rather than assuming a fixed absolute path.

Typical places to inspect are:

- `common/decisions/`
- `common/decisions/categories/`
- `interface/`

If the install location is not obvious from the current workspace or user context, ask the user or infer it from nearby files before citing a concrete path.
