# 路线与难度相关脚本条件指引

> 来源：`common/scripted_triggers/JAP_rework_scripted_triggers.txt`、`events/Rance_jap_events.txt`、`common/on_actions/JAP_rework_initialization_on_actions.txt` 与 `common/scripted_effects/JAP_game_rule_scripted_effects.txt`

## 使用方式

脚本条件的调用方式通常写为：

- `SCRIPTED_TRIGGER = yes`
- `SCRIPTED_TRIGGER = no`

## 现有条件

## MOD 难度分级

本 MOD 当前使用 `variable_rance_nandu` 作为日本 AI 难度变量。

变量来源：

- 通过 `events/Rance_jap_events.txt` 中的难度选择事件写入
- 通过开局规则 `rance_japan_ai_difficulty` 预设时，由 `common/on_actions/JAP_rework_initialization_on_actions.txt` 调用 `common/scripted_effects/JAP_game_rule_scripted_effects.txt` 中的 `JAP_apply_preselected_ai_difficulty_from_game_rule` 写入
- 写入位置为 `JAP = { set_variable = { variable_rance_nandu = X } }`

当前 6 档难度与变量值对应如下：

| 变量值 | 难度名 | 说明 |
| --- | --- | --- |
| `1` | `EASY` | 白雪纷飞的程度 |
| `2` | `NORMAL` | 漫天风霜的程度 |
| `3` | `HARD` | 暴雪蔽日的程度 |
| `4` | `LUNATIC` | 雪虐风饕的程度 |
| `5` | `EXTRA` | 波谲云诡的程度 |
| `6` | `PHANTASM` | 樱花烂漫的程度 |

## 难度判定方式

### 精确判定当前难度

用于“仅某一档难度可用”的场景。

| 脚本条件 | 含义 |
| --- | --- |
| `Rance_nd_is_easy = yes` | 当前难度为 `EASY` |
| `Rance_nd_is_normal = yes` | 当前难度为 `NORMAL` |
| `Rance_nd_is_hard = yes` | 当前难度为 `HARD` |
| `Rance_nd_is_lunatic = yes` | 当前难度为 `LUNATIC` |
| `Rance_nd_is_extra = yes` | 当前难度为 `EXTRA` |
| `Rance_nd_is_phantasm = yes` | 当前难度为 `PHANTASM` |

这些条件底层都等价于：

```txt
JAP = {
    check_variable = {
        var = variable_rance_nandu
        value = X
        compare = equals
    }
}
```

常见用法示例：

```txt
available = {
    Rance_nd_is_hard = yes
}
```

### 判定难度是否高于某档

用于“更高难度额外解锁”“高难度追加加权”的场景。

| 脚本条件 | 含义 |
| --- | --- |
| `Rance_nd_more_than_easy = yes` | 当前难度高于 `EASY` |
| `Rance_nd_more_than_normal = yes` | 当前难度高于 `NORMAL` |
| `Rance_nd_more_than_hard = yes` | 当前难度高于 `HARD` |
| `Rance_nd_more_than_lunatic = yes` | 当前难度高于 `LUNATIC` |
| `Rance_nd_more_than_extra = yes` | 当前难度高于 `EXTRA` |

这些条件底层都等价于：

```txt
JAP = {
    check_variable = {
        var = variable_rance_nandu
        value = X
        compare = greater_than
    }
}
```

常见用法示例：

```txt
modifier = {
    factor = 1.5
    Rance_nd_more_than_normal = yes
}
```

## AI 编制分配草案

> 本节记录 AI 模板/起始部队决议重写时的难度分配草案。当前仅用于决议逻辑讨论，不代表 `common/ai_strategy/` 生产策略已经同步调整。

规划原则：

- 每种编制由独立 AI 决议控制。
- 难度只决定该编制是否应当在当前难度出现。
- 具体解锁还需要额外满足时间线条件，或满足该编制主要装备已经创建的脚本条件。
- 各难度编制表使用确切枚举，不使用“在上一难度基础上追加”的省略写法。
- `PHANTASM` 当前包含 `EXTRA` 的全部编制；未来可能加入专属特色编制。

| 难度 | 编制分配 |
| --- | --- |
| `EASY` | 日本步坦师、日本特种步坦师 |
| `NORMAL` | 日本特种步坦师、日本机坦师、日本海陆现代机坦师 |
| `HARD` | 日本特种步坦师、日本机坦师、日本两栖机坦师、日本海陆现代机坦师 |
| `LUNATIC` | 日本特种步坦师、日本机坦师、日本两栖机坦师、日本海陆现代机坦师、日本重型机坦师、日本两栖重机坦师 |
| `EXTRA` | 日本特种步坦师、日本机坦师、日本两栖机坦师、日本海陆现代机坦师、日本重型机坦师、日本两栖重机坦师、日本陆巡两栖重机坦师、日本陆巡海陆现代机坦师 |
| `PHANTASM` | 日本特种步坦师、日本机坦师、日本两栖机坦师、日本海陆现代机坦师、日本重型机坦师、日本两栖重机坦师、日本陆巡两栖重机坦师、日本陆巡海陆现代机坦师 |

对应模板创建效果：

| 编制 | 创建效果 |
| --- | --- |
| 日本步坦师 | `JAP_create_infantry_tank_template` |
| 日本特种步坦师 | `JAP_create_special_infantry_tank_template` |
| 日本机坦师 | `JAP_create_mechanized_tank_template` |
| 日本两栖机坦师 | `JAP_create_amphibious_mechanized_template` |
| 日本重型机坦师 | `JAP_create_mechanized_heavy_tank_template` |
| 日本两栖重机坦师 | `JAP_create_heavy_amphibious_mechanized_template` |
| 日本陆巡两栖重机坦师 | `JAP_create_land_crushier_template` |
| 日本海陆现代机坦师 | `JAP_create_marine_modern_mechanized_tank_template` |
| 日本陆巡海陆现代机坦师 | `JAP_create_land_cruiser_marine_modern_mechanized_tank_template` |

## 辉夜 AI 彩蛋国策分发

皇道派 AI 的国策队列只手动走到 `JAP_kaguya_eientei`，后续辉夜彩蛋线由 `common/decisions/JAP_rework_ai_decision.txt` 中的 `JAP_rai_complete_kaguya_*_focus` 决议即时补发。

这些决议使用 `Rance_is_jap_ai = yes`，因此同时覆盖真正日本 AI 与开局规则 `rance_japan_player_ai_cheats = ENABLED` 的日本玩家。

| 难度 | 自动补发辉夜国策 |
| --- | --- |
| `EASY` | 无 |
| `NORMAL` | `JAP_kaguya_shell` |
| `HARD` | `JAP_kaguya_shell`, `JAP_kaguya_robe` |
| `LUNATIC` | `JAP_kaguya_shell`, `JAP_kaguya_robe`, `JAP_kaguya_dragon`, `JAP_kaguya_burial`, `JAP_kaguya_return` |
| `EXTRA` | `JAP_kaguya_shell`, `JAP_kaguya_robe`, `JAP_kaguya_dragon`, `JAP_kaguya_bowl`, `JAP_kaguya_branch`, `JAP_kaguya_burial`, `JAP_kaguya_return`, `JAP_kaguya_eternity` |
| `PHANTASM` | 同 `EXTRA`；`JAP_kaguya_burial` 的 PHANTASM 强化沿用国策奖励内现有判定 |

### `Rance_is_jap_lecture_ai`

用途：
用于判定当前国家是否为日本 AI 且正在走讲座派路线。

当前判定逻辑：

- `tag = JAP`
- `is_ai = yes`
- 满足以下其一：
  - `has_country_flag = JAP_AI_RANDOM_COMMUNIST`
  - `has_game_rule = { rule = JAP_ai_behavior option = COMMUNIST }`

常见用法示例：

```txt
available = {
    Rance_is_jap_lecture_ai = yes
}
```

```txt
modifier = {
    factor = 0
    Rance_is_jap_lecture_ai = no
}
```

### `Rance_is_jap_kodoha_ai`

用途：
用于判定当前国家是否为日本 AI 且正在走皇道派路线。

当前判定逻辑：

- `tag = JAP`
- `is_ai = yes`
- 满足以下其一：
  - `has_country_flag = JAP_AI_RANDOM_NEUTRALITY`
  - `has_game_rule = { rule = JAP_ai_behavior option = NEUTRALITY }`

常见用法示例：

```txt
available = {
    Rance_is_jap_kodoha_ai = yes
}
```
