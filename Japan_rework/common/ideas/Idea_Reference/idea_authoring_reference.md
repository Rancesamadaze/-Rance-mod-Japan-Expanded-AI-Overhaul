# Idea Authoring Reference

Source: `common/ideas/AGENTS.md`.
Applies to: `common/ideas/`.

This file preserves detailed authoring notes migrated out of `common/ideas/AGENTS.md`. Keep the corresponding `AGENTS.md` file as a concise operating entrypoint, and update this reference when long examples, syntax notes, workflows, or lookup explanations need to be maintained.

## Migrated Notes

# Ideas Directory Notes

## Scope

This `AGENTS.md` applies to files under `common/ideas/`.

When writing or modifying HOI4 idea scripts in this directory, prioritize:

- correct top-level category selection
- correct file placement by idea type
- correct separation between persistent modifiers and instant effects
- correct use of project-specific scripted triggers and idea naming

If idea syntax is uncertain, check `HOI4_idea_grammar_for_AI_compact.md` first.

## Primary Reference

Use `common/ideas/HOI4_idea_grammar_for_AI_compact.md` as the primary quick reference for:

- `ideas = { ... }` overall structure
- `hidden_ideas`
- `country`
- manufacturers / concerns
- `modifier`
- `equipment_bonus`
- `research_bonus`
- `allowed / visible / available`
- `on_add / on_remove / do_effect / cancel`

Do not invent unsupported fields when the reference does not cover them.

## File Placement In This Project

Prefer placing ideas according to the current project split:

- `JAP_hidden_ideas.txt`: hidden ideas and backend mechanic ideas
- `JAP_rework_ideas.txt`: normal country spirits and project-wide special spirits
- `JAP_rework_law_idea.txt`: law-type ideas such as economy / trade / mobilization laws
- `JAP_rework_decision_idea.txt`: lightweight country spirits granted from decisions or small utility systems
- `japan.txt`: legacy or vanilla-adjacent idea content already living there

When adding a new idea, prefer extending the most specific existing file instead of creating a new file.

## Top-Level Category Choice

Choose the category before writing the body.

- Use `hidden_ideas` for backend-only effects, hidden state tracking, or ideas that should only be script-applied.
- Use `country` for normal national spirits granted by focuses, events, or decisions.
- Use law / manufacturer / concern categories only when the idea is actually meant to appear in those systems.

Do not place hidden backend effects in `country` just because they are easy to add with script.

## Hidden Idea Conventions

In this project, hidden ideas commonly follow these patterns:

- `allowed = { always = yes }` so they can be safely granted by script
- `removal_cost = -1` when they should not be manually removed
- `allowed_civil_war = { always = yes }` when they should persist cleanly through civil war splits

Unless there is a clear reason not to, idea definitions in this project should default to:

- `allowed_civil_war = { always = yes }`

This should be treated as the default baseline for both hidden ideas and normal country spirits, especially for script-granted ideas.

If the hidden idea is meant to be script-only and never player-facing, prefer putting it in `JAP_hidden_ideas.txt`.

When a hidden idea is added through a focus / event / decision and the UI text should stay concise, prefer:

```txt
custom_effect_tooltip = SOME_TT
hidden_effect = {
    add_ideas = SOME_HIDDEN_IDEA
}
```

## Modifier Layering

Keep these layers distinct:

- `modifier`: persistent national modifier values
- `equipment_bonus`: equipment or category-specific persistent bonuses
- `research_bonus`: research-category bonuses
- `on_add` / `on_remove`: one-time effects triggered when the idea is added or removed

Do not put one-time script effects inside `modifier`.
Do not use `on_add` as a substitute for a permanent modifier.

## Conditions

Use the right condition field for the right job:

- `allowed`: baseline legal scope or tag eligibility
- `visible`: whether the player can see the idea in selection UI
- `available`: whether the idea can currently be chosen
- `cancel`: when the idea should be removed
- `do_effect`: when the idea should actively function

Do not mix `visible` and `available`.
Do not put route- or difficulty-gating logic into `allowed` unless it is truly a hard ownership constraint.

## Route And Difficulty Checks

When idea availability depends on route or difficulty, reuse the project scripted triggers instead of rewriting raw variable logic.

Primary reference:

- `Reference/route_difficulty_scripted_trigger.md`

Prefer using:

- `Rance_is_jap_ai`
- `Rance_is_jap_lecture_ai`
- `Rance_is_jap_kodoha_ai`
- `Rance_nd_is_*`
- `Rance_nd_more_than_*`

If tooltip behavior matters, prefer direct `SCRIPTED_TRIGGER = yes/no` usage over wrapping those checks in `NOT = { ... }` unless you have verified the display behavior.

## Naming

Prefer consistent prefixes:

- Japan-specific ideas: `JAP_...`
- Rework systems: `JAP_rework_...` where appropriate
- Hidden backend ideas: descriptive names such as `JAP_hidden_...`

For script-only helper ideas, make the purpose obvious from the id.

## Idea Picture Reference Special Case

This project has a local special case for many Japan idea icons defined in `interface/rance_jap_ideas.gfx`.

When a sprite is registered there as:

```txt
spriteType = {
    name = "GFX_idea_JAP_some_icon"
    texturefile = "gfx/ideas/JAP/JAP_some_icon.png"
}
```

then the corresponding `picture =` value in `common/ideas/*.txt` should usually be written as:

```txt
picture = JAP_some_icon
```

That is: for these idea pictures, drop the `GFX_idea_` prefix when writing the `picture` field.

Example:

- sprite registration: `GFX_idea_JAP_ai_buff`
- idea script usage: `picture = JAP_ai_buff`

Do not automatically assume this prefix-dropping rule applies to every system in the mod. Treat it as a project-specific convention mainly for country spirit / idea picture references in `common/ideas/*.txt`, and verify existing local patterns before using the full `GFX_idea_...` form.

## Existing Project Patterns To Reuse

Patterns already present in this directory include:

- hidden naval route backend ideas in `JAP_hidden_ideas.txt`
- fixed AI difficulty spirits in `JAP_rework_ideas.txt`
- law ideas with `visible` / `available` route checks in `JAP_rework_law_idea.txt`
- small decision-granted spirits in `JAP_rework_decision_idea.txt`

Prefer following these patterns before introducing a new style.

## Common Mistakes

- putting a hidden mechanic idea into the wrong top-level category
- mixing `allowed`, `visible`, and `available`
- writing instant script effects inside `modifier`
- inventing modifier keys without checking references
- forgetting `allowed = { always = yes }` on script-granted hidden ideas
- forgetting `removal_cost = -1` on permanent hidden ideas
- forgetting `allowed_civil_war = { always = yes }` on ideas that should survive civil war splits
- scattering similar ideas across multiple files without a reason

## Modifier Lookup

If a modifier name is uncertain, check:

- `Reference/modifier_trans.md`

For example, night land combat modifiers should be verified there before use.

## Encoding

Before editing, confirm file encoding.

- idea script files in this directory should be treated as `UTF-8`

## Minimal Checklist

When adding a new idea, verify at minimum:

- correct target file
- correct top-level category
- correct id naming
- correct condition fields
- correct modifier keys
- whether it should be hidden or visible
- whether it needs `removal_cost`
- whether it needs `allowed_civil_war`

Default assumption:

- add `allowed_civil_war = { always = yes }` unless the idea is specifically designed not to persist through civil war
