# National Focus Directory Notes

## Scope

Applies to files under `common/national_focus/`.

## Required References

- Focus tree syntax, positioning, prerequisites, shared/joint/continuous focuses, and templates: `common/national_focus/National_Focus_Reference/national_focus_authoring_reference.md`
- Focus localized names: `Reference/focus_name.md`
- Focus time linkage: `Reference/focus_time_linkage_reference.md`
- Japan focus reward tiers: `Reference/JAP_focus_reward_tier_workflow_reference.md`
- `JAP_add_or_modify_*` scripted effects and dynamic modifier reward checklist: `Reference/JAP_add_or_modify_scripted_effect_reference.md`
- Character recruitment or promotion from focuses: `common/characters/AGENTS.md`

## Operating Rules

- Prefer localized Chinese focus names in user-facing explanations.
- Keep focus ids, prerequisites, mutual exclusions, positions, icons, availability, AI weighting, and rewards consistent with existing `japan.txt` patterns.
- For tiered Japan focus rewards, use `Rance_jap_return_to_peak_standard = yes` for standard pre-nerf values and `else` for reduced default values unless the user changes the workflow.
- When adding dynamic modifier variable rewards, update the reward writer, dynamic modifier mapping, history initialization, and tooltip/localization support together.
- Preserve UTF-8 without BOM and LF unless an existing file proves otherwise.
