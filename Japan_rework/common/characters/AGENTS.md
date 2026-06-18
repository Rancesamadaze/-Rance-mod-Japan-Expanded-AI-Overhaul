# Characters Agents Notes

## Scope

Applies to files under `common/characters/` and to related recruitment or promotion logic in `history/countries/`, `common/national_focus/`, and `events/`.

## Required References

- Character structure, role blocks, advisor weighting, recruitment hooks, and promotion patterns: `common/characters/Character_Reference/character_authoring_reference.md`
- Character localized names: `Reference/character_name.md`
- Advisor trait sprites: `Reference/advisor_trait_sprite_reference.md`
- Standard advisor unlock tooltips: `Reference/advisor_unlock_tooltip_reference.md`
- Modifiers and trait modifiers: `Reference/modifier_trans.md`

## Operating Rules

- Prefer localized Chinese character names in user-facing explanations.
- Do not prefill `country_leader = { ... }` for an alternate leader unless the character should hold that role at game start.
- When a focus, event, or effect promotes an alternate leader, keep leader `traits` and `desc` handling consistent with the promotion reference.
- Prefer `allowed = { original_tag = JAP }` for Japan-origin advisors when that is the intended scope.
- Preserve existing file encoding and line endings unless the user explicitly asks for conversion.
