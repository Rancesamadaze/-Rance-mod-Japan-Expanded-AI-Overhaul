# AI Template Authoring Reference

Source: `common/ai_templates/AGENTS.md`.
Applies to: `common/ai_templates/`.

This file preserves detailed authoring notes migrated out of `common/ai_templates/AGENTS.md`. Keep the corresponding `AGENTS.md` file as a concise operating entrypoint, and update this reference when long examples, syntax notes, workflows, or lookup explanations need to be maintained.

## Migrated Notes

# AI Template Notes

These notes apply to files under `common/ai_templates/`.

## Code Structure

Keep each AI template block in this shape:

```hoi4
TEMPLATE_GROUP_KEY = {
	available_for = {
		JAP
	}
	role = ROLE_KEY
	upgrade_prio = {
		base = 0
	}
	TEMPLATE_VARIANT_KEY = {
		upgrade_prio = {
			base = 0
		}
		target_template = {
			regiments = {
				BATTALION_KEY = COUNT
			}
			support = {
				SUPPORT_KEY = 1
			}
		}
	}
}
```

Each division design must use its own independent outer code block.

Use one outer template group per intended AI role, and one inner template variant for the concrete target composition. A single `role` should carry only one division design.

Unless the user explicitly asks to revise an existing template, preserve existing blocks. Add new division designs as new outer blocks with a new `role`; role names are free-form and may be named after the new division design.

Order related templates from lower-tier to higher-tier designs. For example, place a basic infantry division before a larger or more advanced infantry division.

## Upgrade Priority

For normal Japanese AI combat templates, both `upgrade_prio` blocks must be forced to zero:

- outer template group: `upgrade_prio = { base = 0 }`
- inner template variant: `upgrade_prio = { base = 0 }`

Do not raise these values casually. If a template intentionally needs non-zero priority, document the reason next to that block.

## Tank Template Front Role

Tank and armored attack templates must include:（除非有特殊说明）

```hoi4
front_role_override = offence
```

Place it near the top-level `role = ...` line of the outer template group. This applies to tank, mechanized tank, heavy tank, amphibious armor, and land cruiser style offensive templates.

## Scripted Effect Companion

After adding a new AI division template, add a matching scripted effect in `common/scripted_effects/JAP_templates_scripted_effects.txt` unless the user explicitly says not to.

Use this shape:

```hoi4
JAP_create_TEMPLATE_KEY_template = {
	division_template = {
		name = "本地化师名"
		is_locked = no
		obsolete = no
		regiments = {
			BATTALION_KEY = { x = 0 y = 0 }
		}
		support = {
			SUPPORT_KEY = { x = 0 y = 0 }
		}
	}
}
```

The scripted effect must mirror the AI template composition exactly. Lay out line battalions by columns with `x = 0..4` and rows with `y = 0..4`; support companies use support slots at `x = 0`, increasing `y` from top to bottom.

Preserve existing scripted effects unless the user asks to revise them. Add the new effect near the most related existing template effect.

When a related `JAP_start_*` create-unit series exists in the same scripted effect file, add or update the matching start effect so the new division template can be spawned by script. Keep the division name string identical to the `division_template` name.
