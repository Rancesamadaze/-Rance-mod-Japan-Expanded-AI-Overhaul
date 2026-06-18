# Scripted Trigger Authoring Reference

Source: `common/scripted_triggers/AGENTS.md`.
Applies to: `common/scripted_triggers/`.

This file preserves detailed authoring notes migrated out of `common/scripted_triggers/AGENTS.md`. Keep the corresponding `AGENTS.md` file as a concise operating entrypoint, and update this reference when long examples, syntax notes, workflows, or lookup explanations need to be maintained.

## Migrated Notes

# Scripted Triggers Agents Notes

## Scope

These instructions apply to files under `common/scripted_triggers/`.

## Purpose

This directory defines reusable trigger logic for the mod.

When editing here, prefer patterns that are easy to reuse from decisions, focuses, events, ideas, and other scripted content.

## File Encoding

Before editing, confirm the file encoding first.

- Scripted trigger files under `common/scripted_triggers/`: `UTF-8`

Do not introduce BOM into scripted trigger files.

## Trigger Style

When a scripted trigger is intended to be shown to players in decision, focus, or event UI, prefer defining the tooltip directly inside the scripted trigger.

Preferred pattern:

```txt
my_scripted_trigger = {
    custom_trigger_tooltip = {
        tooltip = my_scripted_trigger.tt
        ...
    }
}
```

This keeps the actual logic and its player-facing explanation in one place.

## Negation Style

When negating a scripted trigger, prefer:

```txt
my_scripted_trigger = no
```

Do not prefer wrapping the trigger with:

```txt
NOT = { my_scripted_trigger = yes }
```

Use the `= no` form unless there is a special structural reason that requires `NOT`.

## Reuse Rules

When a condition is likely to be used in more than one place, prefer moving it into a scripted trigger instead of duplicating the same `AND` / `OR` block.

Typical good candidates:

- route state checks
- political situation checks
- post-civil-war or stabilized-government checks
- repeated industrial or military readiness checks
- reusable gating logic for decisions and focuses

## Localization Habit

When a scripted trigger uses `custom_trigger_tooltip`, make sure the referenced `.tt` localization key exists and stays concise enough for repeated UI use.

Prefer using a dedicated tooltip key named after the scripted trigger when practical.

## Scope Discipline

Be explicit about which scope the scripted trigger expects.

If a trigger only works in a country scope, write it so that assumption is clear.

If a trigger depends on state scope, province scope, or another special scope, structure it so the expected scope is obvious from the script.

## Editing Rules

- keep scripted triggers reusable rather than one-off where possible
- keep tooltip text and trigger logic aligned
- avoid duplicating large trigger blocks when one named scripted trigger would do
- keep naming consistent with existing project conventions such as `JAP_...` and `Rance_...`
