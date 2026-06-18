# AI Equipment Authoring Reference

Source: `common/ai_equipment/AGENTS.md`.
Applies to: `common/ai_equipment/`.

This file preserves detailed authoring notes migrated out of `common/ai_equipment/AGENTS.md`. Keep the corresponding `AGENTS.md` file as a concise operating entrypoint, and update this reference when long examples, syntax notes, workflows, or lookup explanations need to be maintained.

## Migrated Notes

# AI Equipment Notes

## Equipment Design Priority

For this mod, AI equipment designs are not created or upgraded directly by AI template preference.

The mod disables AI self-created equipment variants and AI self-upgraded equipment variants. Equipment designs are instead issued through scripted effects and related scripted workflows.

Because of this, when adding or revising AI equipment entries in this directory, do not add priority modifiers whose only purpose is to reduce the design tendency to zero after a later chassis, weapon, or related technology is researched.

If an older AI equipment entry already has this zeroing priority logic, do not remove it just because of this rule. Leave existing zeroing logic in place unless the user explicitly asks to clean it up or the current task requires changing that priority block.

For example, new equipment entries do not need patterns like:

```hoi4
priority = {
    factor = 1000
    modifier = {
        factor = 0
        has_tech = improved_medium_tank_chassis
    }
}
```

Keep `priority.factor` only when it is useful for ordering or documenting the scripted equipment design sequence.

## Target Variant Match Value

`target_variant.match_value` affects which design the AI chooses to produce within the same equipment group.

When adding multiple designs to one equipment group, set `match_value` in ascending order by equipment advancement. Earlier or less advanced designs should use lower values, and later or more advanced designs should use higher values.

Use `1000` as the baseline value for the first or most basic design in a group, so the AI still has a clear production choice if something unexpected happens.

## Adding New AI Equipment Designs

When creating a new AI equipment design, update all related workflow pieces together:

1. Add the design to the appropriate AI equipment file under `common/ai_equipment/`.
2. Add or update the scripted effect that lets the AI create the equipment design.
3. Add or update the place that grants the AI equipment design through that scripted effect.
4. By default, the grant path is a military-province decision. Only use a history file for early/default equipment when the user explicitly says that design should be granted from history.
5. Add or update the related localization for any decision and any new user-facing text.
6. After creating new equipment-related content, report any inferred details in the user-facing summary so the user can tune them. This usually includes inferred unlock technologies and fallback decision timing.

For newly created equipment scripted effects, do not grant the unlock technologies with `set_technology` just to make the design creatable. Instead, place `allow_without_tech = yes` inside the new `create_equipment_variant` block. Do not retroactively apply this to older existing equipment scripted effects unless the user explicitly asks for that wider migration.

## Decision Unlock Conditions

Do not casually infer military-province decision trigger technologies only from equipment modules.

Decision `visible` and `available` technology checks must use techs that are actually obtainable through the current project/game version's normal progression. If a module is unlocked by a special project, event, or other non-technology path, do not add a `has_tech` check for an obsolete or inaccessible technology key just to match the module.

For tank equipment decisions, the normal default is to use only the chassis tech and main gun tech as unlock conditions. Do not add extra module-derived unlock techs unless a reliable existing project pattern or explicit user request calls for them.

Do not infer fallback decision timing from the main gun technology year by itself. When a new equipment decision needs a fallback date, align it with existing equipment of the same tier or the closest reliable project pattern. Modern equipment derivatives should normally align with the existing modern tank timing unless the user asks for a different schedule.

When a decision unlock condition is inferred rather than copied from an existing reliable project pattern, report that inference in the user-facing summary. If a condition is uncertain or would add unnecessary friction, prefer a lighter unlock condition.

## Session Persistence Tracking

When importing or comparing newly created equipment designs, refer to the local tracking file as the "装备伪设计蓝图" (equipment pseudo-design blueprint). Its path is:

`C:\Users\Administrator\Documents\Paradox Interactive\Hearts of Iron IV\session_persistence\equipment_designs\equipment_designs.txt`

The user uses this file as a convenient scratchpad for equipment pseudo-designs. New designs and changes to old designs may appear here first.

When asked to add or revise AI equipment, read the relevant `equipment={...}` block from this file and convert its information into the code needed by the target AI equipment entry, scripted effect, grant path, and localization.

When comparing a scratchpad design against project code:

- Treat `design_team="..."` in the scratchpad as an important field for the scripted effect, converting it to `design_team = mio:...`.
- Do not automatically migrate scratchpad-only display fields such as `override_sprite="..."` or `folder="..."` into project code. Existing project equipment scripted effects generally do not use those fields.
- For the AI equipment entry, compare and convert the `target_variant` data: `match_value`, `type`, `modules`, `upgrades`, and corresponding `allowed_modules`.
- For the scripted effect, compare and convert the actual `create_equipment_variant` design: `type`, `name`, `design_team`, `modules`, and `upgrades`.

Treat this as a generated/session-persistence source for equipment design data. Preserve its outer structure (`version`, `tank_designs`, `ship_designs`, `plane_designs`) when pruning temporary equipment blocks.
