# Scripted Triggers Agents Notes

## Scope

Applies to files under `common/scripted_triggers/`.

## Required References

- Trigger style, negation, reuse, localization, and scope discipline: `common/scripted_triggers/Scripted_Trigger_Reference/scripted_trigger_authoring_reference.md`
- Route and difficulty trigger usage: `Reference/route_difficulty_scripted_trigger.md`
- Localization formatting: `Reference/localisation_formatting_reference.md`

## Operating Rules

- Prefer reusable scripted triggers when the condition is shared or user-facing.
- Keep negation style readable and consistent with nearby project examples.
- When using `custom_trigger_tooltip`, ensure the referenced `.tt` localization key exists and is concise enough for repeated UI use.
- Preserve UTF-8 without BOM and LF unless an existing file proves otherwise.
