# Actual MIO Template Adaptation Workflow

This workflow is for adapting concrete, playable MIO organizations to the project's Rance model templates.

It applies to files such as:

- `common/military_industrial_organization/organizations/JAP_organization.txt`
- country-specific MIO files that include reusable template organizations

It is not the primary workflow for writing or resetting template files such as `Rance_model_organization.txt`.
For template files, use `Reference/mio/smart_layout_mio_template_workflow.md` first.

## Goal

When adapting a real MIO, keep country-specific identity and unlock logic local to the real organization, while moving the generic tree structure to the matching Rance template.

In practice:

- the Rance template provides the common trait tree
- the actual MIO keeps its icon, allowed logic, organization identity, special traits, focus gates, faction gates, flags, and scripted effects
- do not copy the full template tree into the actual MIO unless the user explicitly asks for a standalone override

## Step 1: Read One Full MIO Block

Work one organization at a time.

Before editing, read the full block for the target organization and identify:

- current `include`
- `icon`, `allowed`, `visible`, and `available`
- whether an explicit `initial_trait` exists
- every trait with `special_trait_background = yes`
- each special trait's `visible`, `available`, `on_complete`, bonuses, flags, and position logic
- any `relative_position_id`, `mutually_exclusive`, `parent`, `any_parent`, or `all_parents`

Do not rely only on the selected IDE fragment when surrounding trait structure may change the meaning.

## Step 2: Select The Matching Rance Template

Replace the old vanilla or generic include with the closest matching Rance model template.

Examples:

| Original role | Preferred Rance template |
| --- | --- |
| general tank / armor manufacturer | `Rance_model_armor_manufacturer_organization` |
| medium tank manufacturer | `Rance_model_medium_tank_manufacturer_organization` |
| infantry tank designer | `Rance_model_infantry_tank_organization` |
| artillery manufacturer | `Rance_model_artillery_manufacturer_organization` |
| high-agility fighter aircraft manufacturer | `Rance_model_high_agility_fighter_aircraft_manufacturer_organization` |
| heavy aircraft manufacturer | `Rance_model_heavy_aircraft_manufacturer_organization` |
| naval aircraft manufacturer | `Rance_model_naval_aircraft_manufacturer_organization` |
| medium aircraft manufacturer | `Rance_model_medium_aircraft_manufacturer_organization` |
| CAS aircraft manufacturer | `Rance_model_cas_aircraft_manufacturer_organization` |
| battle-line ship manufacturer | `Rance_model_battle_line_ship_manufacturer_organization` |
| task-force ship manufacturer | `Rance_model_task_force_ship_manufacturer_organization` |
| raider ship manufacturer | `Rance_model_raider_ship_manufacturer_organization` |
| carrier raider ship manufacturer | `Rance_model_carrier_raider_ship_manufacturer_organization` |
| submarine manufacturer | `Rance_model_submarine_manufacturer_organization` |
| escort fleet manufacturer | `Rance_model_escort_fleet_manufacturer_organization` |

If the role is unclear, inspect the old include, equipment scope, organization name, and nearby vanilla / old-mod reference before choosing.

## Step 3: Add A Dedicated Initial Trait

Every actual MIO adapted to a Rance template should define a dedicated `initial_trait`, even when it has no current gameplay effect.

Preferred pattern:

```txt
initial_trait = {
    name = JAP_example_organization_initial_trait
}
```

Use a specific key for the actual organization, not a shared generic key.

Localization placement:

- use `localisation/simp_chinese/JAP_mio_l_simp_chinese.yml` for Japan MIO localization unless a more specific MIO localization file already exists
- keep localization files as UTF-8 with BOM
- use orange text for actual MIO initial trait names

Example:

```yml
 JAP_example_organization_initial_trait:0 "§O中型战车工厂§!"
```

## Step 4: Reposition Special Traits

For traits with `special_trait_background = yes`:

- remove vanilla-template-dependent `relative_position_id`
- remove `parent`, `any_parent`, and `all_parents`
- use absolute `position`
- start from `position = { x = 0 y = 0 }`
- increment `x` to place additional special traits
- avoid `x = 4` by default because Rance templates commonly reserve it for the core foundation node
- adjust only when the active Rance template has a different occupied top-row layout

Example:

```txt
position = { x = 0 y = 0 }
```

then:

```txt
position = { x = 1 y = 0 }
```

Do not keep `relative_position_id` merely because the vanilla organization had one; after switching templates, those IDs often refer to absent or semantically unrelated nodes.

Special traits are independent overlay nodes in actual MIO adaptations. Do not connect them to template nodes or to other special traits with parent relationships.

## Step 5: Preserve And Adapt Special Logic

Special traits should preserve the actual MIO's country-specific logic unless the user asks to redesign it.

Use these sources in priority order:

1. the active target organization file
2. the old mod MIO file, especially for special trait condition and effect changes
3. the vanilla MIO file for original behavior
4. the Rance template only for generic tree structure

Typical logic to preserve:

- focus gates
- faction / influence gates
- one-per-family taken flags
- character, idea, or advisor swaps
- special tooltips
- country-specific production, research, or equipment bonuses

For special trait numeric bonuses, prefer the vanilla value by default.
Old-mod numeric changes are reference material and should not be copied into the active file unless the user explicitly asks for that change or confirms it during the current adaptation.

## Step 6: Add AI Exemptions To Player-Only Constraints

Use `Rance_is_jap_ai = yes` as the standard Japan AI exemption trigger.

This trigger covers:

- Japan controlled by AI
- Japan player with the AI assistance flag enabled

Add this exemption to player-facing constraints that would otherwise block AI progression or AI-assisted test runs.

Common examples:

- one-per-family taken flags
- faction influence checks such as `JAP_zaibatsu_faction_is_at_least_influential = yes`
- army / navy faction checks such as `JAP_army_faction_is_not_subdued = yes`

For taken-flag availability checks, prefer:

```txt
available = {
    FROM = {
        has_completed_focus = JAP_some_focus
        OR = {
            Rance_is_jap_ai = yes
            NOT = { has_country_flag = JAP_some_taken_flag }
        }
    }
}
```

For taken-flag write effects, do not set the flag for AI-exempt cases:

```txt
on_complete = {
    FROM = {
        if = {
            limit = {
                Rance_is_jap_ai = no
            }
            custom_effect_tooltip = generic_trait_will_not_be_available_in_other_organizations
            set_country_flag = JAP_some_taken_flag
        }
    }
}
```

For faction / influence gates, wrap the original condition:

```txt
available = {
    FROM = {
        OR = {
            Rance_is_jap_ai = yes
            JAP_zaibatsu_faction_is_at_least_influential = yes
        }
    }
}
```

Keep the original condition visible inside the `OR` so the non-AI player behavior remains traceable.

## Step 7: Encoding Rules

Before writing, confirm encoding:

- script and markdown files: UTF-8, no BOM unless the project explicitly requires otherwise
- localization files: UTF-8 with BOM

Do not rewrite entire files because terminal output appears garbled. Confirm the read path and encoding first.

## Step 8: Verify The Adapted MIO

After each organization, check:

- the `include` points to the intended Rance template
- the organization has a dedicated `initial_trait`
- the initial trait has orange Simplified Chinese localization
- special traits no longer depend on old `relative_position_id`
- special traits do not have `parent`, `any_parent`, or `all_parents`
- special trait absolute positions do not collide with the template top-row core node
- one-per-family flags have AI exemption where intended
- AI-exempt cases do not write player-only taken flags
- faction / influence gates include AI exemption where intended
- localization file still has UTF-8 BOM

Prefer completing one organization cleanly before moving to the next.
