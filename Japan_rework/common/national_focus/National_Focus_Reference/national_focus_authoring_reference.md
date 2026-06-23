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

## 国策树布局大局观

写新树或重排旧树时，先把 `focus_tree` 当成整张画布的配置，而不是普通国策的容器。树级字段解决的是“谁使用这棵树、打开时看哪里、界面附加元素放哪里”；普通 `focus` 的 `x/y` 才解决节点本身的位置。

`country = { ... }` 是树选择权重。专属树通常用 `factor = 0`，再在 `modifier` 里用 `tag`、DLC、游戏规则、国家 flag、主体/属国关系等条件给目标国家加权。若同一国家可能命中多棵树，应让条件互斥或权重明显，避免树选择结果依赖文件加载和权重细节。

`default = yes` 只留给通用树；国家专属树、特殊路线树、属国专用树一般写 `default = no`。如果是在替换原版树，优先复用原版 `focus_tree` id 和原版根布局；如果是并存新树，必须确认 `country` 条件不会和旧树同时命中。

节点坐标与界面坐标不是一套东西：

- 普通 `focus` 的 `x/y` 是国策网格坐标。
- 没有 `relative_position_id` 的节点是绝对坐标，通常只用于第一排根节点或大分支根节点。
- 有 `relative_position_id` 的节点是相对坐标，应作为扩展现有分支的默认写法。
- `continuous_focus_position` 是持续性国策按钮在界面中的位置，不是节点网格坐标。
- `shortcut`、`inlay_window`、`override_position` 属于国策界面附加元素，它们的位置也不应拿来推导普通国策节点坐标。

第一枚或第一排根国策的绝对坐标不能随手写 `x = 0 y = 0`。根节点的 `x` 应该由整棵树向左展开的宽度决定：

```txt
root_x = 根节点左侧最大展开格数 + 左侧安全边距
root_y = 0
```

如果树只有一条中线，且不会向左展开，`x = 0` 可以成立；如果根节点下方会向左展开 3 格，根节点至少应放在 `x = 3` 或更右。原版满洲国树的第一枚国策放在 `x = 6 y = 0`，日本树第一枚大路线节点放在 `x = 12 y = 0`，通用树则把陆军、空军、海军、工业、政治等第一排分支分别放在不同绝对 `x` 上。这里的数字体现的是整棵树的横向预留，而不是语法默认值。

多根树或横向大树要先划“泳道”。例如先决定政治、经济、陆军、海军、空军等大分支从左到右的顺序，再给每个大分支根节点一个绝对 `x`，后续分支全部相对对应根节点展开。不要一边写一边让每个新节点独立使用绝对坐标；这种写法短期能显示，长期很难维护。

`initial_show_position = { focus = ... }` 可用于指定打开国策界面时的初始视角。根节点不在视觉中心、第一枚文件顺序国策不是玩家应先看的国策、或树有多个顶层分支时，可以用它把视角锚到自然起点。没有特殊需求时可以省略。

`continuous_focus_position` 要按整棵树的纵向高度预留。小树可以放得靠上，大树应放得更低，避免持续性国策按钮遮挡节点或连线。修改树高度后要重新检查这个位置。

推荐设计流程：

1. 先确定树是替换原版、扩展原版，还是并存新树。
2. 再确定 `country` 命中条件，避免同一国家同时匹配多棵树。
3. 画出顶层泳道和每条路线向左/向右的最大展开宽度。
4. 根据左侧最大展开宽度选择第一枚或第一排根国策的绝对 `x/y`。
5. 根节点以下优先使用 `relative_position_id`。
6. 若使用隐藏分支、动态偏移、动态图标或路线切换，检查是否需要 `mark_focus_tree_layout_dirty = yes`。
7. 最后检查 `initial_show_position` 和 `continuous_focus_position` 是否仍然指向玩家自然视角。

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
