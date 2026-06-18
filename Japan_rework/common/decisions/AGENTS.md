# Decisions Agents Notes

## Scope

Applies to files under `common/decisions/`.

## Required References

- Decision structure, targeted decisions, missions, state map behavior, and timing notes: `common/decisions/Decision_Reference/decision_authoring_reference.md`
- Decision icons: `Reference/decision_icon_reference.md`
- State and province membership: `Reference/state_name_reference.md`, `Reference/state_province_reference.md`
- Buildings, railways, and supply hubs: `Reference/building_reference.md`
- War-readiness construction workflow: `Reference/war_readiness_construction_decision_workflow_reference.md`
- Commerce ministry workflow: `Reference/commerce_ministry_decision_workflow_reference.md`
- Route/difficulty triggers and variables: `Reference/route_difficulty_scripted_trigger.md`, `Reference/variable_syntax_reference.md`

## Encoding

`common/decisions/JAP.txt` is a documented exception: preserve UTF-8 without BOM and CRLF line endings.

For other decision files, verify current encoding and line endings before editing and preserve them unless the user explicitly requests conversion.

## Operating Rules

- Keep decision categories, icons, visibility, availability, costs, cooldowns, and AI logic consistent with nearby project patterns.
- For map-click decisions, confirm `state_target`, `target_trigger`, and `on_map_mode` behavior against existing examples.
- Do not add unsupported railway parameters such as `instant_build = yes` unless vanilla syntax or the project reference is updated to support them.
- When a decision uses `custom_trigger_tooltip`, ensure the referenced `.tt` localization key exists and stays concise.
