# AI Strategy Authoring Reference

Source: `common/ai_strategy/AGENTS.md`.
Applies to: `common/ai_strategy/`.

This file preserves detailed authoring notes migrated out of `common/ai_strategy/AGENTS.md`. Keep the corresponding `AGENTS.md` file as a concise operating entrypoint, and update this reference when long examples, syntax notes, workflows, or lookup explanations need to be maintained.

## Migrated Notes

# AI Strategy Agents Notes

## Scope

These instructions apply to files under `common/ai_strategy/`.

## Purpose

This directory defines reusable AI strategy blocks for the mod.

These blocks are usually used to guide AI behavior for production, research, advisors, construction, supply, military composition, and similar long-term priorities.

## File Encoding

Before editing, confirm the file encoding first.

- AI strategy script files under `common/ai_strategy/`: `UTF-8`

Do not introduce BOM into AI strategy script files.

## Minimal Template

A minimal AI strategy block in this project usually looks like:

```txt
my_ai_strategy_name = {
	allowed = {
		tag = JAP
	}
	enable = {
		always = yes
	}
	abort_when_not_enabled = yes

	ai_strategy = {
		type = some_strategy_type
		id = some_target_id
		value = 100
	}
}
```

## Common Parts

In general, an AI strategy block commonly contains:

- a strategy name
- `allowed`
- `enable`
- either `abort` or `abort_when_not_enabled`
- one or more `ai_strategy = { ... }` entries

Not every block needs every field, but this is the usual baseline structure.

## Field Roles

### Strategy name

The outer key is the strategy block name.

Use a name that clearly indicates the purpose, time window, route, or difficulty bracket.

### `allowed`

This is the setup gate.

Use it for broad restrictions such as:

- country tag
- original tag
- high-level ownership or route identity

### `enable`

This is the live activation condition.

Use it for conditions that determine when the strategy should currently apply, such as:

- date windows
- difficulty checks
- route checks
- war / peace state
- focus completion
- government state

### `abort`

Use `abort` when the strategy should remain active until an explicit stop condition is met.

This is common when a strategy should end after:

- a date passes
- a tech is researched
- a target count is reached
- a route state changes

### `abort_when_not_enabled`

Use this when the strategy should simply stop as soon as `enable` is no longer true.

This is the more compact pattern for many time-window or difficulty-window strategies.

### `ai_strategy`

This is the actual behavior payload.

A block can contain one or many `ai_strategy = { ... }` entries.

Each entry usually contains:

- `type`
- `id` when that strategy type needs a target
- `value`

## Common Project Patterns

From the current project files, common patterns include:

- `type = role_ratio`
- `type = research_weight_factor`
- `type = pp_spend_priority`
- `type = min_wanted_supply_trains`
- `type = template_prio`
- `type = equipment_production_factor`
- `type = equipment_production_min_factories`
- `type = equipment_production_min_factories_archetype`

When adding a new strategy, follow the existing local style for the specific `type` you are working with.

## Air Production Syntax Notes

### Equipment count plus deployed aircraft

Use this pattern when an AI strategy needs to test the total amount of an aircraft archetype, including both stored equipment and already deployed planes:

```txt
set_temp_variable = { f_total = num_equipment@small_plane_airframe }
add_to_temp_variable = { var = f_total value = num_deployed_planes_with_type@small_plane_airframe }
check_variable = { f_total > Rance_fighter_high_threshold }
```

Meaning:

- `num_equipment@small_plane_airframe` reads the current equipment count for the target archetype.
- `num_deployed_planes_with_type@small_plane_airframe` reads deployed planes of the same archetype.
- `set_temp_variable` stores the first value in a temporary variable for this trigger/effect evaluation.
- `add_to_temp_variable` adds the deployed-plane count to that temporary variable.
- `check_variable = { f_total > Rance_fighter_high_threshold }` compares the computed total against another variable threshold.

### Air unit `type` overlap

In `common/units/air.txt`, many old air production strategy targets are based on the `type` field from air `sub_units`.

Known overlap:

```txt
fighter = {
	type = fighter
	need = { small_plane_airframe = 1 }
}

mothership = {
	type = fighter
	need = { mothership_equipment = 1 }
}
```

`mothership` and `fighter` both use `type = fighter`.

Planned handling for air production v2:

After the future conditions are defined, add a separate mothership production-reduction strategy and use AI strategies of these forms to reduce mothership production:

```txt
ai_strategy = {
	type = equipment_variant_production_factor
	id = mothership_equipment
	value = -999
}

ai_strategy = {
	type = equipment_production_min_factories_archetype
	id = mothership_equipment
	value = -999
}
```

The exact conditions and values may differ from the current old strategy.

### Standard air production increase syntax

Except for mothership, whose handling is still pending, other air production increase strategies use this standard form:

```txt
ai_strategy = {
	type = equipment_production_factor
	id = cas
	value = 30
}

ai_strategy = {
	type = equipment_production_min_factories
	id = cas
	value = 30
}

ai_strategy = {
	type = build_airplane
	id = cas
	value = 30
}
```

For these strategies, `id` is the aircraft `type` from `common/units/air.txt`.

The exact values will be decided later.

### Standard air production decrease syntax

Standard air production decrease strategies use this form:

```txt
ai_strategy = {
	type = equipment_production_factor
	id = cas
	value = -99
}

ai_strategy = {
	type = equipment_production_min_factories
	id = cas
	value = -99
}

ai_strategy = {
	type = build_airplane
	id = cas
	value = -99999
}
```

For these strategies, `id` is the aircraft `type` from `common/units/air.txt`.

### Air production threshold scripted triggers

For air production v2, move aircraft count checks from individual increase/decrease strategy blocks into scripted triggers.

Each aircraft should have scripted triggers for:

- total aircraft count below its low threshold variable
- total aircraft count above its high threshold variable

The threshold variables are initialized in `history/countries/JAP - Japan.txt`.

Use the old strategy threshold values as the default variable values.

Each aircraft scripted trigger should only check that aircraft's own count and threshold. Do not add aircraft-to-aircraft linkage inside these threshold triggers for now.

## Building Strategy Reference

When working on AI building behavior, building priorities, target-state construction, or mission-driven construction guidance, use:

- `common/ai_strategy/AI_Strategy_Reference/AI_building_strategy_reference.md`

For building key names and Chinese building references, also use:

- `Reference/building_reference.md`

## Diplomacy Strategy Reference

When working on AI diplomacy behavior, including alliances, faction joining or avoidance, diplomatic attitude, guarantees, military access, non-aggression pacts, volunteers, lend-lease, war declaration desire, war avoidance, or `reversed = yes` direction handling, use:

- `common/ai_strategy/AI_Strategy_Reference/AI_diplomacy_strategy_reference.md`

This includes AI strategies using types such as:

- `alliance`
- `befriend`
- `support`
- `protect`
- `diplo_action_desire`
- `diplo_action_acceptance`
- `send_volunteers_desire`
- `send_lend_lease_desire`
- `antagonize`
- `conquer`
- `declare_war`
- `prepare_for_war`
- `consider_weak`
- `contain`
- `avoid_starting_wars`
- `dont_join_wars_with`
- `ignore`
- `ignore_claim`

## War Strategy Reference

When working on AI war strategy (`war_strategy`), front control, front unit requests, invasion unit requests, naval invasion focus, garrison or area defense, unit buffers, area priority, force concentration, or theatre distribution demand, use:

- `common/ai_strategy/AI_Strategy_Reference/AI_war_strategy_reference.md`

If the user mentions `战争策略参考`, `war_strategy` reference, or military AI strategy reference, interpret that as this file.

When working specifically on the Kodoha / 皇道派 military AI strategy in `common/ai_strategy/Jap_rework_kodoha_mil.txt`, also use:

- `common/ai_strategy/AI_Strategy_Reference/JAP_kodoha_war_strategy_reference.md`

Read the general war strategy reference first for syntax, then the Kodoha reference for the current old entries, numeric values, target states, and `front_control priority` ladder. If Kodoha military strategy values, targets, flags, or front-control priorities are changed, update the Kodoha reference in the same change.

When working on post-China Kodoha war planning, custom AI areas, or later Allied/Comintern war strategy after Japan has annexed China and Tibet, also use:

- `common/ai_strategy/AI_Strategy_Reference/JAP_kodoha_post_china_ai_area_plan.md`

Use that plan to choose or add area keys before writing area-targeted `area_priority`, `put_unit_buffers`, `front_unit_request`, `invasion_unit_request`, or `front_control` strategies.

## Naming Habit

Prefer names that make the strategy window obvious, for example:

- country or route prefix
- difficulty bracket
- time bracket
- target system such as production, research, advisor, or supply

Examples of naming dimensions already used in this directory:

- `JAP_...`
- `rance_mod_...`
- `..._easy`
- `..._normal`
- `..._hard`
- `..._before_1938`

## Editing Rules

- keep formatting close to surrounding files
- do not mix unrelated AI purposes into one block unless they clearly belong together
- prefer multiple small readable strategy blocks over one oversized block
- when using many `ai_strategy` entries, group them with short comments if that improves readability
- if a strategy is tied to difficulty or route logic, reuse existing scripted triggers where possible

## Reference Folder

Use `common/ai_strategy/AI_Strategy_Reference/` for AI strategy notes, examples, extracted references, and learning materials, instead of mixing those materials into live strategy script files.
