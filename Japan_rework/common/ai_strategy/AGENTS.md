# AI Strategy Agents Notes

## Scope

Applies to files under `common/ai_strategy/`.

## Required References

- General AI strategy syntax and project patterns: `common/ai_strategy/AI_Strategy_Reference/ai_strategy_authoring_reference.md`
- Building strategy: `common/ai_strategy/AI_Strategy_Reference/AI_building_strategy_reference.md`
- Diplomacy strategy: `common/ai_strategy/AI_Strategy_Reference/AI_diplomacy_strategy_reference.md`
- War strategy: `common/ai_strategy/AI_Strategy_Reference/AI_war_strategy_reference.md`
- Kodoha war strategy: `common/ai_strategy/AI_Strategy_Reference/JAP_kodoha_war_strategy_reference.md`
- Post-China Kodoha AI area planning: `common/ai_strategy/AI_Strategy_Reference/JAP_kodoha_post_china_ai_area_plan.md`

Use `Reference/building_reference.md`, `Reference/strategic_region_reference.md`, `Reference/variable_syntax_reference.md`, and `Reference/route_difficulty_scripted_trigger.md` when those topics appear in strategy work.

## Operating Rules

- Keep strategy entries gated with clear `allowed`, `enable`, and `abort` logic.
- Prefer existing Japan AI helpers, focus-completion flags, and project route/difficulty triggers instead of inventing parallel gates.
- For Kodoha military strategy values, targets, flags, or front-control priorities, update the Kodoha reference in the same change.
- Store AI strategy notes, examples, extracted references, and learning material under `common/ai_strategy/AI_Strategy_Reference/`, not inside live strategy files.
- Preserve UTF-8 without BOM and LF unless an existing file proves otherwise.
