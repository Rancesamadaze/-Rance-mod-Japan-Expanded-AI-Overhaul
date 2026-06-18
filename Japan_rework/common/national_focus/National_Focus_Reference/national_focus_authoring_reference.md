# National Focus Authoring Reference

Source: `common/national_focus/AGENTS.md`.
Applies to: `common/national_focus/`.

This file preserves detailed authoring notes migrated out of `common/national_focus/AGENTS.md`. Keep the corresponding `AGENTS.md` file as a concise operating entrypoint, and update this reference when long examples, syntax notes, workflows, or lookup explanations need to be maintained.

## Migrated Notes

# National Focus Directory Notes

## Scope

This `AGENTS.md` applies to files under `common/national_focus/`.

When writing or modifying HOI4 national focus scripts in this directory, prioritize:

- correct block structure
- correct field placement by scope
- correct `id` references
- consistent prerequisite / mutual exclusion / position logic

If a field or syntax is uncertain, do not invent it.

## Structure Distinctions

Do not mix these structures together:

- `focus_tree`
- `focus`
- `shared_focus`
- `joint_focus`
- `continuous_focus_palette`

They are related, but they are not the same level of object.

## Focus Tree Basics

A normal national focus file is typically built around:

```txt
focus_tree = {
    id = MOD_focus_tree
    country = { ... }
    default = no
    continuous_focus_position = { x = 1200 y = 100 }

    focus = { ... }
}
```

Common expectations:

- `country = { ... }` decides which country uses the tree
- `default = no` is usually used for country-specific trees
- `continuous_focus_position` controls the continuous focus button position

## Normal Focus Rules

A standard focus usually includes:

```txt
focus = {
    id = MOD_example_focus
    icon = GFX_goal_generic_construct_civilian
    x = 0
    y = 0
    cost = 10
    prerequisite = { focus = MOD_prev_focus }
    available = { }
    completion_reward = { }
}
```

When adding or editing a focus, check at minimum:

- `id`
- `icon`
- `x/y` or `relative_position_id`
- `cost`
- `prerequisite`
- `completion_reward`

## Focus Icon Registration

National focus scripts should reference a registered sprite name:

```txt
icon = GFX_focus_MOD_example
```

Do not point `icon` directly at a `.dds`, `.png`, or other image file.

For a custom national focus icon, one raw image file is normally enough, but the focus needs two sprite registrations:

- the regular sprite, for example `GFX_focus_MOD_example`
- the shine sprite with the exact `_shine` suffix, for example `GFX_focus_MOD_example_shine`

In the original focus shine template, the same image path is written once in the regular sprite and three times in the shine sprite (`texturefile` plus two `animationmaskfile` entries), so one focus icon image path commonly appears in four registration fields total.

For this mod's custom Japan focus icons, keep raw assets under `gfx/interface/goals/` and register them in `interface/rance_jap_focus.gfx`. Reuse the same raw image for the regular and `_shine` sprites unless the user explicitly asks for a separate shine mask.

## Positioning

Prefer relative positioning when extending an existing branch:

```txt
x = 1
y = 0
relative_position_id = MOD_base_focus
```

This is safer than hardcoding absolute coordinates across a large tree.

`offset = { ... }` is a conditional position adjustment layered on top of base coordinates, but it usually does not refresh in real time.

## Prerequisite Semantics

Be careful: these two forms do not mean the same thing.

One `prerequisite` block with multiple `focus =` entries usually means OR:

```txt
prerequisite = {
    focus = MOD_focus_a
    focus = MOD_focus_b
}
```

Multiple `prerequisite` blocks usually mean AND:

```txt
prerequisite = { focus = MOD_focus_a }
prerequisite = { focus = MOD_focus_b }
```

This is one of the easiest mistakes to make.

## Mutual Exclusion

When two focuses are mutually exclusive, write the relation in both directions when possible:

```txt
mutually_exclusive = {
    focus = MOD_other_focus
}
```

If A excludes B, prefer B excluding A as well.

## Availability And Visibility

For normal focuses:

- `available` controls whether the focus can be clicked
- `allow_branch` controls whether the branch/focus is shown

For continuous focuses:

- `available` controls visibility
- `enable` controls clickability

Do not mix these meanings.

## Dynamic Content Refresh

The following often do not update in real time:

- dynamic `icon`
- `offset`
- `allow_branch`

If the layout or display must refresh after completion, use:

```txt
completion_reward = {
    mark_focus_tree_layout_dirty = yes
}
```

## Cost Semantics

Do not confuse:

- normal focuses: `cost`
- continuous focuses: `daily_cost`

`cost` is focus duration, not political power cost.

For normal national focuses in this project, `cost = x` means the focus lasts `x * 7` days.

## Focus Time Linkage

When working with focus duration linkage, focus time overlays, or tooltips related to focus time changes, use `Reference/focus_time_linkage_reference.md` as the primary reference.

This includes:

- `reduce_focus_completion_cost`
- `overlay = GFX_focus_fast_overlay_generic_clock`
- tooltip patterns for focus time reduction / increase
- where to store focus-time-related localization

Be careful not to mix the two `cost` meanings:

- normal focus `cost = x` means `x * 7` days
- `reduce_focus_completion_cost = { cost = x }` means exactly `x` days

## Japan Focus Reward Tiers

When the user mentions tiered Japan focus values, focus reward tiers, "国策分档数值", "分档数值工作流", "工作流里的分档数值", "重回巅峰", standard versus reduced focus rewards, or adjusting focus numbers by game rule, use `Reference/JAP_focus_reward_tier_workflow_reference.md` first.

If the active context is `common/national_focus/japan.txt` and the user says they plan to rework focus numbers with tiers or asks about the tiered value workflow, first connect that request to the "重回巅峰" reduced/standard reward workflow unless they explicitly name another workflow.

For tiered focus reward branches, check only `Rance_jap_return_to_peak_standard = yes` for the standard pre-nerf value, then use `else` as the reduced default value. Do not add or use a separate reduced-tier scripted trigger unless the user explicitly changes the workflow.

## JAP Add Or Modify Scripted Effects

When adding or editing Japan focus rewards that use `JAP_add_or_modify_*` scripted effects, use `Reference/JAP_add_or_modify_scripted_effect_reference.md` as the primary reference.

This applies especially when a national focus adds `add_to_variable` rewards to Japan dynamic modifiers. Check the reference first for:

- the correct `JAP_add_or_modify_*` scripted effect
- whether to add `custom_effect_tooltip = generic_skip_one_line_tt` before the dynamic modifier reward
- the expected variable prefix for the target dynamic modifier
- multi-state modifier behavior such as early industrialization versus economic miracle

## Shared And Joint Focuses

`shared_focus` is a reusable focus definition that can be referenced by multiple trees.

```txt
shared_focus = {
    id = SHARED_example_focus
    icon = GFX_goal_generic_construct_civilian
    x = 0
    y = 0
    relative_position_id = SHARED_root_focus
    cost = 10
    completion_reward = { }
}
```

`joint_focus` is a special shared focus with joint-country logic:

```txt
joint_focus = {
    id = JOINT_example_focus
    icon = GFX_goal_generic_alliance
    x = 0
    y = 0
    relative_position_id = JOINT_root_focus
    cost = 10
    joint_trigger = { }
    completion_reward = { }
    completion_reward_joint_originator = { }
    completion_reward_joint_member = { }
}
```

When writing `joint_focus`, keep these three reward scopes clearly separated:

- shared completion reward
- originator-only reward
- member-only reward

## Continuous Focus Palette

Continuous focuses belong to `continuous_focus_palette`, not a normal `focus_tree`.

```txt
continuous_focus_palette = {
    id = MOD_focus_palette
    country = { ... }
    position = { x = 50 y = 1000 }

    focus = {
        id = MOD_continuous_focus
        icon = GFX_goal_generic_production
        daily_cost = 0.1
        available = { }
        enable = { }
        select_effect = { }
        cancel_effect = { }
        modifier = { }
    }
}
```

## Writing Style For Changes

When generating or editing focus code in this directory:

- prefer giving complete blocks instead of isolated fields
- if patching existing code, clearly preserve existing logic that is not being changed
- if introducing dynamic icon / position / branch visibility, consider whether layout refresh is required
- keep field naming conservative and engine-safe

## Minimal Safe Templates

Normal focus:

```txt
focus = {
    id = MOD_example_focus
    icon = GFX_goal_generic_political_reform
    x = 0
    y = 0
    cost = 10
    available = { }
    completion_reward = { }
}
```

Branch focus with prerequisite and exclusion:

```txt
focus = {
    id = MOD_example_branch_focus
    icon = GFX_goal_generic_major_war
    x = 1
    y = 1
    relative_position_id = MOD_root_focus
    cost = 10

    prerequisite = {
        focus = MOD_root_focus
    }

    mutually_exclusive = {
        focus = MOD_other_branch_focus
    }

    available = { }

    ai_will_do = {
        base = 1
    }

    completion_reward = { }
}
```
