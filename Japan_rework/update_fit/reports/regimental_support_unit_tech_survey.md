# 团属支援连单位与科技调查

调查时间：2026-06-14

范围：原版 v1.19 团属支援连定义、模板写法、单位数值风格、科技加成路径。本文只做资料整理，不涉及 live 玩法文件改动。

参考来源：

- 原版本机目录：`D:\SteamLibrary\steamapps\common\Hearts of Iron IV`
- `update_fit/vanilla_v1.19/common/ai_templates/templates_JAP.txt`
- `D:\SteamLibrary\steamapps\common\Hearts of Iron IV\common\defines\00_defines.lua`
- `D:\SteamLibrary\steamapps\common\Hearts of Iron IV\documentation\effects_documentation.md`
- `D:\SteamLibrary\steamapps\common\Hearts of Iron IV\history\units\CZE_1936.txt`
- 已有分类倒查：`update_fit/reports/regimental_support_category_trace.md`

## 1. 单位定义语法

团属支援连仍写在 `common/units/*.txt` 的 `sub_units` 中，不是新的顶层文件格式。核心结构是：

```txt
sub_units = {
    unit_key = {
        group = support
        type = { support ... }
        categories = { category_support_battalions category_regimental_support_battalions ... }
        divisional = no
        combat_width = 0
        allowed_battalion_groups = { ... }
        need = { ... }
        manpower = ...
        ...
    }
}
```

关键点：

- 团属槽位单位统一使用 `group = support`，并以 `divisional = no` 表示不走普通师属支援连槽位。
- 普通团属支援连有 `combat_width = 0`；装甲团属支援连同样是零宽支援槽位，但部分定义没有显式写 `combat_width = 0`。
- 基础分类至少包含 `category_support_battalions`、`category_regimental_support_battalions`、`category_army`。
- `allowed_battalion_groups` 决定该团属连能进入哪些编制组。例如普通火力/炮组主要允许 `infantry mobile combat_support`；摩托化火力支援额外允许 `mobile_combat_support armor armor_combat_support`；装甲团属坦歼/自行防空只允许 `armor mobile_combat_support armor_combat_support`。
- `active = yes/no` 与 `enable_subunits` 配合使用。普通火力支援、摩托化火力支援本体是 `active = no`，由 `support_weapons` 科技解锁；野战炮组、防空炮组、反坦炮组也有科技 `enable_subunits` 挂钩。

## 2. 模板语法

AI 模板中新增独立槽位：

```txt
target_template = {
    support = { ... }
    regimental_support = {
        unit_key = count
    }
    regiments = { ... }
}
```

原版日本 AI 模板已经使用该槽位，常见写法：

- 装甲模板：`anti_air_battery = 1`、`fire_support = 1`
- 摩托化/机械化模板：`anti_tank_battery = 1`、`mot_fire_support = 1`
- 步兵/海军陆战队模板：`fire_support = 1`、`field_guns = 2`
- 后期步兵模板：`fire_support = 1`、`anti_tank_battery = 1`、`anti_air_battery = 1`

数量值是同一模板中该团属支援连的数量。当前日本原版模板示例主要使用 `1` 或 `2`。

具体 `division_template` 则使用坐标写法，`x` 是团属支援挂在哪一列主力团下，`y` 是团属支援行。原版捷克 1936 模板示例：

```txt
regiments = {
    light_armor = { x = 0 y = 0 }
    light_armor = { x = 0 y = 1 }
    cavalry = { x = 1 y = 0 }
    cavalry = { x = 1 y = 1 }
    cavalry = { x = 1 y = 2 }
}

regimental_support = {
    field_guns = { x = 1 y = 0 }
}
```

这里 `field_guns` 放在第 2 列，因为第 2 列有 3 个 `cavalry`。`cavalry` 的 `group = mobile`，而 `field_guns` 允许 `mobile` 列。

`add_units_to_division_template` 的文档写法略简化，使用 `unit_key = column_index`，例如 `regimental_support = { field_guns = 1 }` 表示把该团属支援加到第 2 列的第一个可用团属支援格。

## 3. 列位与放置限制

团属支援不是自由摆放。公开脚本侧能控制的放置条件主要有三层：

1. 团属支援区域尺寸。
   `common/defines/00_defines.lua` 中原版 v1.19 为 `MAX_REGIMENTAL_SUPPORT_WIDTH = 5`、`MAX_REGIMENTAL_SUPPORT_HEIGHT = 1`。也就是最多 5 列、每列 1 个团属支援格。
2. 每个团属支援格要求同列主力团有足够营数。
   `REGIMENTAL_SUPPORT_REQUIRED_BATTALIONS = { 3 }` 表示第 1 行团属支援要求同列至少 3 个主力营。因为当前高度只有 1 行，所以实际就是“该列至少 3 个营才能挂 1 个团属支援”。
3. 团属支援单位自己的 `allowed_battalion_groups`。
   这个字段引用的是同列主力营的 `group`，不是 `categories`。如果同列主力团的组不在允许列表里，该团属支援不能放在该列下。

公开文件中没有找到单独的“团属支援列规则表”；UI 文件只画出 `regiments_grid` 与 `regiment_support_grid`，尺寸来自 defines。实际可放置判定应由引擎读取上述 defines、同列主力营数量、主力营 `group`、团属单位 `allowed_battalion_groups` 后完成。

原版主力营 `group` 概览：

| group | 示例单位 |
| --- | --- |
| `infantry` | 步兵、海军陆战队、山地步兵、伞兵、民兵、惩戒营等 |
| `mobile` | 骑兵、摩托化、机械化、装甲车、两栖机械化等 |
| `combat_support` | 线列炮兵、线列反坦、线列防空、线列火箭炮 |
| `mobile_combat_support` | 摩托化炮兵、摩托化反坦、摩托化防空、摩托化火箭炮 |
| `armor` | 轻/中/重/现代坦克、两栖坦克等 |
| `armor_combat_support` | 自行火炮、自行防空、坦歼等装甲衍生线列营 |

原版团属支援的允许列组：

| 团属支援 | `allowed_battalion_groups` | 实际含义 |
| --- | --- | --- |
| `fire_support` | `infantry mobile combat_support` | 可挂步兵、机动、线列炮兵/反坦/防空/火箭炮列 |
| `field_guns` / `rocket_battery` | `infantry mobile combat_support` | 同上 |
| `anti_air_battery` / `anti_tank_battery` | `infantry mobile combat_support` | 同上 |
| `mot_fire_support` | `infantry mobile combat_support mobile_combat_support armor armor_combat_support` | 几乎所有普通主力列均可挂，包括装甲列 |
| `*_tank_destroyer_support` | `armor mobile_combat_support armor_combat_support` | 只能挂装甲列、机动火力支援列、装甲火力支援列 |
| `*_sp_anti_air_support` | `armor mobile_combat_support armor_combat_support` | 同上 |

注意事项：

- `allowed_battalion_groups` 和 modifier 用的 `categories` 是两套东西。给单位加 `category_all_armor` 不会让它能挂在装甲列下；能否挂装甲列取决于 `allowed_battalion_groups` 里有没有 `armor` 或相关组。
- 如果某列混放规则由引擎按“团/列 group”处理，实际有效组应以该列主力团所属 group 为准。脚本侧能做的是确保想挂的团属支援包含对应 `allowed_battalion_groups`。
- 静态模板手写 `regimental_support = { key = { x = ... y = ... } }` 时，建议保证目标列至少有 3 个主力营，并且该列主力营 group 被该团属支援允许；不要依赖游戏自动纠错。
- AI `target_template` 中的 `regimental_support = { key = count }` 只表达数量目标，AI 会再按可用列组与列容量寻找位置。若日本自建团属连允许列组过窄，AI 可能研究/生产了装备却很难塞进目标模板。

## 4. 原版团属支援连 key

普通/步兵侧：

| key | 定位 | 核心分类 |
| --- | --- | --- |
| `fire_support` | 普通火力支援 | `category_regimental_support_battalions` |
| `mot_fire_support` | 摩托化火力支援 | `category_regimental_support_battalions` |
| `field_guns` | 团属野战炮组 | `category_regimental_support_artillery` |
| `rocket_battery` | 团属火箭炮组 | `category_regimental_support_artillery` |
| `anti_air_battery` | 团属防空炮组 | `category_anti_air` |
| `anti_tank_battery` | 团属反坦克炮组 | `category_anti_tank`、`category_mobile_anti_tank` |

装甲侧：

| key | 定位 | 核心分类 |
| --- | --- | --- |
| `light_tank_destroyer_support` 等 | 团属坦歼 | `category_all_armor`、`category_tank_destroyers`、`category_tank_destroyer_regimental_support` |
| `light_sp_anti_air_support` 等 | 团属自行防空 | `category_all_armor`、`category_self_propelled_anti_air`、`category_self_propelled_anti_air_regimental_support` |

原版没有通用 `tank_destroyer_battery` 或 `self_propelled_anti_air_battery` key；装甲团属支援连按轻/中/重/现代底盘分别建 key。超重型坦歼/自行防空仍是旧式支援或线列体系，没有对应团属支援 key。

## 5. 数值风格

总体风格：团属支援连是小规模、零宽、低人员/低装备/低强度单位，靠装备和科技补出角色属性，同时用单位级惩罚控制强度。

### 普通火力与炮组

| 单位 | 装备 | 人力 | 组织 | 强度 | 补给 | 主要惩罚 |
| --- | --- | ---: | ---: | ---: | ---: | --- |
| `fire_support` | 30 步兵装备 + 5 支援装备 | 240 | 20 | 0.4 | 0.06 | 防御 -0.25，软/硬攻 -0.5 |
| `mot_fire_support` | 上述 + 5 摩托化装备 | 240 | 20 | 0.4 | 0.06 | 防御/突破 -0.25，软/硬攻 -0.5 |
| `field_guns` | 4 炮兵装备 | 180 | 0 | 0.1 | 0.1 | 防御 -0.8，突破/硬攻 -0.6，软攻 -0.7 |
| `rocket_battery` | 4 火箭炮装备 | 180 | 0 | 0.1 | 0.1 | 同 `field_guns` |

与线列炮兵相比：

- `field_guns` / `rocket_battery` 使用 4 门装备，线列炮兵/火箭炮营使用 24 门，即约 1/6。
- 人力 180 对 500，约 36%。
- 强度 0.1 对 0.6，约 1/6。
- 补给 0.1 对线列炮兵 0.21、火箭炮 0.22，约 45%-48%。
- 团属炮组不直接复制线列炮兵的战斗力；它通过很小的装备量和明显单位惩罚形成“附属火力”定位。

### 团属防空/反坦与师属支援连

| 对比 | 团属版本 | 师属支援版本 | 风格 |
| --- | --- | --- | --- |
| 防空装备 | `anti_air_battery` 12 | `anti_air` 20 | 60% 装备 |
| 防空人力 | 120 | 300 | 40% 人力 |
| 防空强度 | 0.1 | 0.2 | 50% 强度 |
| 防空补给 | 0.06 | 0.1 | 60% 补给 |
| 反坦装备 | `anti_tank_battery` 16 | `anti_tank` 24 | 67% 装备 |
| 反坦人力 | 120 | 300 | 40% 人力 |
| 反坦强度 | 0.1 | 0.2 | 50% 强度 |
| 反坦补给 | 0.06 | 0.08 | 75% 补给 |

团属防空/反坦的单位惩罚比师属支援版本更重。例如防空炮组有突破/软攻/硬攻 -0.8，空攻 -0.6；师属防空支援连对应惩罚约 -0.4，空攻 -0.2。反坦炮组也比师属反坦支援连更偏“小炮组、低宽度、低综合能力”。

### 步兵/炮兵编制可选团属支援评价

本节用于后续调整日本步兵 AI 编制。候选对象限定为原版可挂在 `infantry`、`mobile`、`combat_support` 列下的团属支援连；装甲团属坦歼和自行防空只允许 `armor mobile_combat_support armor_combat_support`，不列入步兵/普通炮兵列的直接候选。

| key | 简中名称 | `allowed_battalion_groups` | 定位 |
| --- | --- | --- | --- |
| `fire_support` | 重武器连 | `infantry mobile combat_support` | 通用重武器，组织/强度较好 |
| `mot_fire_support` | 摩托化重武器连 | `infantry mobile combat_support mobile_combat_support armor armor_combat_support` | 泛用机动版，可挂范围很广 |
| `field_guns` | 步兵炮 | `infantry mobile combat_support` | 低成本团属炮兵 |
| `rocket_battery` | 团属火箭炮连 | `infantry mobile combat_support` | 火箭炮版团属炮兵 |
| `anti_air_battery` | 团属防空炮组 | `infantry mobile combat_support` | 低成本防空工具位 |
| `anti_tank_battery` | 反坦克炮兵连 | `infantry mobile combat_support` | 低成本穿甲/反装甲工具位 |

原版简中 `anti_air_battery` 文本疑似误写为“反坦克炮兵连”，分析时应以 key 和实际装备为准。

| key | 装备 | 人力 | 组织 | 强度 | 补给 | 主要单位惩罚 |
| --- | --- | ---: | ---: | ---: | ---: | --- |
| `fire_support` | 30 步兵装备 + 5 支援装备 | 240 | 20 | 0.4 | 0.06 | 防御 -0.25，软/硬攻 -0.5 |
| `mot_fire_support` | 30 步兵装备 + 5 支援装备 + 5 摩托化 | 240 | 20 | 0.4 | 0.06 | 防御 -0.25，突破 -0.25，软/硬攻 -0.5 |
| `field_guns` | 4 炮兵装备 | 180 | 0 | 0.1 | 0.1 | 防御 -0.8，突破 -0.6，软攻 -0.7，硬攻 -0.6 |
| `rocket_battery` | 4 火箭炮装备 | 180 | 0 | 0.1 | 0.1 | 防御 -0.8，突破 -0.6，软攻 -0.7，硬攻 -0.6 |
| `anti_air_battery` | 12 防空炮 | 120 | 0 | 0.1 | 0.06 | 防御 -0.6，突破/软/硬攻 -0.8，空攻 -0.6 |
| `anti_tank_battery` | 16 反坦克炮 | 120 | 0 | 0.1 | 0.06 | 防御 -0.6，突破/软攻 -0.8，硬攻 -0.65，穿甲 -0.2 |

后续给日本步兵模板加团属支援时的优先级建议：

1. `field_guns`：最适合作为普通步兵的默认补火力项。只需 4 门火炮，并且吃 `category_regimental_support_artillery` 学说加成。
2. `fire_support`：最稳的通用项。有 20 组织、0.4 强度和低补给，适合防守步兵或低成本模板。
3. `anti_air_battery`：防空工具位。成本低、补给低，适合敌空军压力较大或模板不稳定带师属防空时使用。
4. `anti_tank_battery`：反装甲工具位。主要价值是保留较多穿甲，硬攻输出有限，适合后期或特定反装甲模板。
5. `rocket_battery`：可作为火箭炮产线成型后的进攻步兵火力选项；若没有火箭炮产线，不如 `field_guns` 经济。
6. `mot_fire_support`：不建议给纯步兵优先使用。它的优势是可挂范围极广，但对步兵/普通炮兵列来说比 `fire_support` 多吃 5 摩托化装备，并多一个突破惩罚。

初步模板方向：普通步兵可优先试 `field_guns` + `fire_support`，在有空军压力时加入 `anti_air_battery`；进攻步兵可考虑 `field_guns` + `rocket_battery` 或 `field_guns` + `fire_support`；`anti_tank_battery` 作为后期反装甲或对苏/对盟军装甲压力模板的备选。

### 装甲团属支援连

与同底盘线列坦歼/自行防空营相比：

- 装备量：10 辆对 40 辆，固定 25%。
- 人力：180 对 500，约 36%。
- 训练时间：多数 120 天，线列装甲衍生营 180 天。
- 燃油：`own_equipment_fuel_consumption_mult = 0.33`，约按三分之一燃油消耗处理。
- 战斗宽度：团属为零宽支援槽位，线列坦歼/自行防空为 2 宽。

自行防空：

| 底盘 | 团属装备/线列装备 | 团属强度/线列强度 | 团属补给/线列补给 | 团属重量/线列重量 |
| --- | --- | --- | --- | --- |
| 轻型 | 10/40 | 0.3/0.6 | 0.05/0.1 | 0.3/1 |
| 中型 | 10/40 | 0.3/0.6 | 0.06/0.1 | 0.4/1.25 |
| 重型 | 10/40 | 0.2/0.6 | 0.07/0.1 | 0.5/1.5 |
| 现代 | 10/40 | 0.2/0.6 | 0.06/0.1 | 0.5/1.5 |

坦歼：

| 底盘 | 团属装备/线列装备 | 团属强度/线列强度 | 团属补给/线列补给 | 团属重量/线列重量 |
| --- | --- | --- | --- | --- |
| 轻型 | 10/40 | 0.2/0.6 | 0.06/0.2 | 0.3/1 |
| 中型 | 10/40 | 0.2/0.6 | 0.07/0.22 | 0.4/1.25 |
| 重型 | 10/40 | 0.2/0.6 | 0.09/0.3 | 0.5/1.5 |
| 现代 | 10/40 | 0.2/0.6 | 0.08/0.25 | 0.5/1.5 |

装甲团属支援连不是简单把线列装甲营最终属性乘 25%。它同时：

- 减少装备量。
- 降低组织/恢复定位，团属坦歼默认士气 0.1，而线列坦歼为 0.3。
- 使用单位级惩罚，例如突破 -0.75 到 -0.6、防御 -0.25、软/硬攻 -0.33、装甲 -0.33。
- 保留 `category_all_armor`、`category_tank_destroyers` 或 `category_self_propelled_anti_air`，让旧装甲分类奖励能够继续命中。

## 6. 科技加成路径

结论：科技对团属支援连的加成是混合模式。原版科技很少使用 `category_regimental_support_battalions` 或 `category_regimental_support_artillery` 这种团属总分类；它更多使用“具体单位 key”加成，或沿用旧角色分类让团属连间接受益。

### 解锁

| 科技 | 写法 | 解锁对象 |
| --- | --- | --- |
| `support_weapons` | `enable_subunits` | `fire_support`、`mot_fire_support` |
| `gw_artillery` | `enable_subunits` | `field_guns` |
| `interwar_antiair` | `enable_subunits` | `anti_air_battery` |
| `interwar_antitank` | `enable_subunits` | `anti_tank_battery` |

未检出 `rocket_battery` 的 `enable_subunits`。它的可用性主要跟火箭炮装备/科技链和 `active = yes` 配合，而后续火箭技术直接给它软攻。

### 直接加到具体团属支援连

| 科技 | 命中对象 | 加成 |
| --- | --- | --- |
| `infantry_at` | `fire_support`、`mot_fire_support` | 硬攻 +0.15，穿甲 +0.5 |
| `infantry_at2` | `fire_support`、`mot_fire_support` | 硬攻 +0.15，穿甲 +0.5 |
| `support_weapons2/3/4` | `field_guns` | 防御 +0.1，软攻 +0.1 |
| `support_weapons2/3/4` | `fire_support` | 防御 +0.15，突破 +0.15，软攻 +0.1 |
| `support_weapons2/3/4` | `mot_fire_support` | 防御 +0.15，突破 +0.05，软攻 +0.1 |
| `motorised_infantry` | `mot_fire_support` | 突破 +0.1 |
| `mechanised_infantry/2/3` | `mot_fire_support` | 突破 +0.1，软攻 +0.05 |
| `rocket_artillery2/3` | `rocket_battery` | 软攻 +0.15 |
| `sp_rockets_improved_guidance` | `rocket_battery` | 软攻 +0.1 |
| `antiair1/3/4` | `anti_air_battery` | 空攻 +0.1 |
| `sp_land_large_caliber_kinetic_energy_sabot_gd_tech` | `field_guns` | 穿甲 +0.1 |
| `sp_land_large_caliber_kinetic_energy_sabot_no_gd_tech` | `field_guns` | 穿甲 +0.1 |
| `sp_advance_sabot_shells` | `anti_tank_battery` | 穿甲 +0.15 |

### 通过旧分类间接加成

| 科技 | 分类 | 会影响的团属支援连 | 加成 |
| --- | --- | --- | --- |
| `antitank1` | `category_anti_tank` | `anti_tank_battery` | 硬攻 +0.1，穿甲 +0.2 |
| `antitank3` | `category_anti_tank` | `anti_tank_battery` | 硬攻 +0.1，穿甲 +0.1 |
| `antitank4` | `category_anti_tank` | `anti_tank_battery` | 硬攻 +0.1，穿甲 +0.1 |
| `antitank1` | `category_tank_destroyers` | 团属坦歼 | 硬攻 +0.15，穿甲 +0.2 |
| `antitank3` | `category_tank_destroyers` | 团属坦歼 | 硬攻 +0.1，穿甲 +0.05 |
| `antitank4` | `category_tank_destroyers` | 团属坦歼 | 硬攻 +0.05，穿甲 +0.05 |
| `sp_advance_sabot_shells` | `category_tank_destroyers` | 团属坦歼 | 穿甲 +0.05 |
| `uranium_tipped_bullets` | `category_tank_destroyers` | 团属坦歼 | 硬攻 +0.15，穿甲 +0.2 |
| `antiair1` | `category_self_propelled_anti_air` | 团属自行防空 | 空攻 +0.15 |
| `antiair3` | `category_self_propelled_anti_air` | 团属自行防空 | 空攻 +0.1 |
| `antiair4` | `category_self_propelled_anti_air` | 团属自行防空 | 空攻 +0.05 |
| `rocket_artillery2/3` | `category_rocket_artillery` | 不含 `rocket_battery` | 只覆盖火箭炮线列/摩托化火箭炮等旧分类 |
| `JAP_lighter_tanks` | `category_all_armor` | 团属坦歼、团属自行防空 | 丛林攻击/防御 +0.1 |

注意：`rocket_battery` 没有 `category_rocket_artillery`，所以火箭炮科技同时写 `category_rocket_artillery` 和 `rocket_battery`。这说明原版不会默认让团属炮组吃所有旧炮兵分类；需要显式检查分类是否真的存在。

### 科技未使用的团属专用分类

在原版 v1.19 技术文件中，未检出下列团属专用分类作为科技加成目标：

- `category_regimental_support_battalions`
- `category_regimental_support_artillery`
- `category_tank_destroyer_regimental_support`
- `category_self_propelled_anti_air_regimental_support`

这些分类主要在学说文件中使用。科技侧倾向于：

- 普通/摩托化火力、野战炮组、防空炮组、火箭炮组、反坦炮组：直接写单位 key。
- 反坦/坦歼/自行防空：沿用 `category_anti_tank`、`category_tank_destroyers`、`category_self_propelled_anti_air`。
- 装甲广域奖励：通过 `category_all_armor` 间接覆盖装甲团属支援连。

## 7. 对日本特殊团属支援连的设计启示

1. 如果日本特殊团属连应完整吃全军/总学说奖励，保留 `category_army` 和 `category_regimental_support_battalions`。
2. 如果它是炮兵型团属连，是否加入 `category_regimental_support_artillery` 要谨慎；这会吃学说中的团属炮兵收益，但不会自动吃 `category_rocket_artillery` 或 `category_artillery`。
3. 如果它是防空/反坦炮组变体，加入 `category_anti_air` 或 `category_anti_tank` 会让旧科技线直接命中；不加则需要在科技中写具体 key。
4. 如果它是装甲团属坦歼/自行防空变体，保留 `category_all_armor`、`category_tank_destroyers` 或 `category_self_propelled_anti_air` 会吃旧装甲/反坦/防空科技和日本隐藏装甲地形科技；这通常符合“装甲衍生车辆”直觉，但会带来额外叠加风险。
5. 若想做日本独有但不完全继承原版科技收益的团属连，优先新建专属 category，再在科技或国策中点名该 category；不要只改单位 key，否则学说适配时会很难批量管理。
6. 数值上可按原版小规模比例起步：步兵/炮组类约为线列营装备 1/6 到 2/3、人力 36%-40%、强度 1/6 到 1/2；装甲团属支援约为线列装甲衍生营装备 25%、人力 36%、燃油 33%、强度 1/3 到 1/2。
7. 装甲团属连的强度控制不只靠装备数量，还靠单位级惩罚。若日本特殊装甲团属连给更强装备或地形特化，建议同步保留或调整 `breakthrough`、`soft_attack`、`hard_attack`、`armor_value` 等惩罚项。
8. 设计日本特殊团属连时必须同时决定 `allowed_battalion_groups`。例如只想给步兵联队使用，就限制为 `infantry`；想让骑兵/摩托化也用，加入 `mobile`；想让炮兵列下也能挂，加入 `combat_support`；装甲化团属支援才加入 `armor`、`mobile_combat_support`、`armor_combat_support`。

## 8. 日本实际创建模板入口初查

当前 MOD 实际创建日本模板的入口是 `common/scripted_effects/JAP_templates_scripted_effects.txt`。该文件中的 `JAP_create_*_template` 使用静态 `division_template = { ... }` 坐标写法，而不是 AI `target_template` 的数量写法；修改前该文件尚未出现 `regimental_support` 块，目前已先在日本基础步兵师中接入。

静态模板应在 `division_template` 下与 `regiments`、`support` 同级加入：

```txt
regimental_support = {
    field_guns = { x = 1 y = 0 }
}
```

`x` 是承载列，`y` 是团属支援行。原版 v1.19 默认只有 1 行团属支援，因此同一列通常只能放 1 个团属支援连。承载列还要满足两个条件：该列主力营数量至少达到 `REGIMENTAL_SUPPORT_REQUIRED_BATTALIONS = { 3 }`，并且该列营的 `group` 被团属支援的 `allowed_battalion_groups` 允许。

### 编制调整总原则

当前日本模板调整先以“降低宽度、保留定位、用团属支援补角色”为原则：多数主力 40 宽师向 36 宽靠拢；少数早期、特种、装甲或剧情模板按定位单独处理。团属支援不应被当成免费补满全部损失火力的手段，而是用于补强师内已有角色，例如步兵师补直射火力/步兵炮、防空、反甲。

执行顺序上先改具体创建模板，再同步 `common/ai_templates/templates_JAP.txt` 的目标模板；暂不触碰 AI 策略、生产策略和装备短缺压制逻辑。每个团属支援必须有合法承载列，同一列只放 1 个团属支援，且该列至少保留 3 个主力营。

### 当前步兵模板可用列

| 创建效果 | 模板名 | 当前主力列 | 可承载团属支援的列 | 备注 |
| --- | --- | --- | --- | --- |
| `JAP_create_basic_infantry_template` | 日本基础步兵师 | x0/x1/x2: 各 3 个 `Rance_JAP_A_infantry`; x0 挂 `fire_support`; x1、x2 各挂 1 个 `field_guns` | x0、x1、x2 | 已按前期轻量模板处理，从 10 步降到 9 步，宽度 20 -> 18。三列都是 `group = infantry`，刚好满足团属支援 3 营门槛，可完整放入 `fire_support + 2 field_guns`。 |
| `JAP_create_infantry_template` | 日本步兵师 | x0/x1/x2: 各 4 个 `Rance_JAP_A_infantry`; x3: 3 个 `Rance_JAP_A_infantry`; x4: 2 个 `artillery_brigade` + 1 个 `anti_air_brigade` + 1 个 `anti_tank_brigade`; x0 挂 `fire_support`; x1、x2 各挂 1 个 `field_guns`; x3 挂 `anti_air_battery`; x4 挂 `anti_tank_battery` | x0、x1、x2、x3、x4 | 已按长期豪华步兵师处理。按 MOD 线列炮 2 宽计算，旧模板为 39 宽，新模板为 36 宽。15 个步兵不减以维持组织度，线列炮兵从 3 个降到 2 个，线列反坦克从 2 个降到 1 个，并用团属支援补足火力、防空、反甲。 |
| `JAP_create_experimental_infantry_tank_template` | 日本试验步坦师 | x0/x1: 各 5 个 `Rance_JAP_M_infantry`; x2: 3 个 `Rance_JAP_M_infantry`; x3: 1 个 `artillery_brigade` + 1 个 `anti_air_brigade` + 1 个 `anti_tank_brigade`; x4: 3 个 `Rance_JAP_A_medium_armor`; x0 挂 `fire_support`; x1 挂 `field_guns`; x2 挂 `anti_air_battery`; x3 挂 `anti_tank_battery` | x0、x1、x2、x3、x4 | 已按早期试验步坦师处理。按 MOD 宽度计算，旧模板为 38 宽，新模板为 36 宽。保留 13 个特战步兵和 3 个中坦，线列炮兵从 2 个降到 1 个；暂不在装甲列挂中坦歼/自火/防空团属支援，避免早期额外底盘需求。 |
| `JAP_create_infantry_tank_template` | 日本步坦师 | x0/x1: 各 4 个 `Rance_JAP_A_infantry`; x2: 4 个 `Rance_JAP_A_medium_armor`; x3: 3 个 `Rance_JAP_A_medium_armor`; x4: 3 个 `Rance_JAP_A_medium_tankdestroyer`; x0、x1 各挂 1 个 `Rance_JAP_A_medium_anti_air_armor_support`; x2 挂 `Rance_JAP_A_medium_artillery_armor_support`; x3 挂 `Rance_JAP_A_medium_tankdestroyer_support`; x4 挂 `Rance_JAP_A_heavy_tankdestroyer_support` | x0、x1、x2、x3、x4 | 已按正规步坦歼核心处理。宽度从 40 降到 36。线列保留 8 步兵、7 中坦、3 中坦歼；防空和自火转入团属支援，重坦歼团属支援挂在中坦歼列下作为重反甲补强。 |
| `JAP_create_special_infantry_tank_template` | 日本特种步坦师 | x0/x1: 各 5 个 `Rance_JAP_M_infantry`; x2: 4 个 `Rance_JAP_A_medium_armor`; x3: 3 个 `Rance_JAP_A_medium_armor`; x4: 3 个 `Rance_JAP_A_medium_tankdestroyer`; x0 挂 `Rance_JAP_A_heavy_anti_air_armor_support`; x1 挂 `Rance_JAP_A_medium_anti_air_armor_support`; x2 挂 `Rance_JAP_A_medium_artillery_armor_support`; x3 挂 `Rance_JAP_A_medium_tankdestroyer_support`; x4 挂 `Rance_JAP_A_heavy_tankdestroyer_support` | x0、x1、x2、x3、x4 | 已按特种步坦歼核心处理。装甲配置沿用日本步坦师，步兵改为 10 个特种步兵；无特种减宽时为 40 宽，取得 `marine_raider_elements` 后因 `Rance_JAP_M_infantry combat_width = -0.2` 降为 38 宽。 |
| `JAP_create_mechanized_tank_template` | 日本机坦师 | x0/x1: 各 4 个 `Rance_JAP_A_mechanized`; x2: 4 个 `Rance_JAP_A_medium_armor`; x3: 3 个 `Rance_JAP_A_medium_armor`; x4: 3 个 `Rance_JAP_A_medium_tankdestroyer`; x0 挂 `Rance_JAP_A_heavy_anti_air_armor_support`; x1 挂 `Rance_JAP_A_medium_anti_air_armor_support`; x2 挂 `Rance_JAP_A_medium_artillery_armor_support`; x3 挂 `Rance_JAP_A_medium_tankdestroyer_support`; x4 挂 `Rance_JAP_A_heavy_tankdestroyer_support` | x0、x1、x2、x3、x4 | 已按机械化步坦歼核心处理。宽度从 40 降到 36，线列为 8 机械化、7 中坦、3 中坦歼；团属支援与特种步坦一致。 |
| `JAP_create_amphibious_mechanized_template` | 日本两栖机坦师 | x0/x1: 各 4 个 `Rance_JAP_M_mechanized`; x2: 4 个 `Rance_JAP_M_medium_armor`; x3: 3 个 `Rance_JAP_M_medium_armor`; x4: 3 个 `Rance_JAP_M_medium_tankdestroyer`; x0 挂 `Rance_JAP_A_heavy_anti_air_armor_support`; x1 挂 `Rance_JAP_A_medium_anti_air_armor_support`; x2 挂 `Rance_JAP_A_medium_artillery_armor_support`; x3 挂 `Rance_JAP_A_medium_tankdestroyer_support`; x4 挂 `Rance_JAP_A_heavy_tankdestroyer_support` | x0、x1、x2、x3、x4 | 已按两栖机械化步坦歼核心处理。宽度从 40 降到 36，线列为 8 海军特战队机械化、7 海军特战队中坦、3 海军特战队中坦歼；目前没有 M 系团属支援，团属支援沿用 A 系五件套。 |
| `JAP_create_mechanized_heavy_tank_template` | 日本重型机坦师 | x0: 5 个 `Rance_JAP_A_mechanized`; x1: 4 个 `Rance_JAP_A_mechanized`; x2/x3/x4: 各 3 个 `Rance_JAP_A_heavy_armor`; x0、x1 各挂 1 个 `Rance_JAP_A_heavy_anti_air_armor_support`; x2 挂 `Rance_JAP_A_heavy_artillery_armor_support`; x3、x4 各挂 1 个 `Rance_JAP_A_heavy_tankdestroyer_support` | x0、x1、x2、x3、x4 | 已按重坦系列口径处理。线列从旧 9 机械化 + 8 重坦 + 3 个重型变体改为 9 机械化 + 9 重坦，总宽度 36；重自防、重自火、重坦歼全部转入团属支援。 |
| `JAP_create_heavy_amphibious_mechanized_template` | 日本两栖重机坦师 | x0: 5 个 `Rance_JAP_M_mechanized`; x1: 4 个 `Rance_JAP_M_mechanized`; x2/x3/x4: 各 3 个 `Rance_JAP_M_heavy_armor`; x0、x1 各挂 1 个 `Rance_JAP_A_heavy_anti_air_armor_support`; x2 挂 `Rance_JAP_A_heavy_artillery_armor_support`; x3、x4 各挂 1 个 `Rance_JAP_A_heavy_tankdestroyer_support` | x0、x1、x2、x3、x4 | 已按两栖重型机坦处理。线列从旧 9 海军特战队机械化 + 8 海军特战队重坦 + 3 个重型变体改为 9 海军特战队机械化 + 9 海军特战队重坦，总宽度 36；目前没有 M 系团属支援，沿用 A 系重型团属支援。 |
| `JAP_create_land_crushier_template` | 日本陆巡两栖重机坦师 | x0: 5 个 `Rance_JAP_M_mechanized`; x1: 4 个 `Rance_JAP_M_mechanized`; x2/x3/x4: 各 3 个 `Rance_JAP_M_heavy_armor`; x0、x1 各挂 1 个 `Rance_JAP_A_heavy_anti_air_armor_support`; x2 挂 `Rance_JAP_A_heavy_artillery_armor_support`; x3、x4 各挂 1 个 `Rance_JAP_A_heavy_tankdestroyer_support` | x0、x1、x2、x3、x4 | 已按陆巡重型两栖机坦处理。线列与日本两栖重机坦师一致，总宽度 36；普通支援连保留 `land_cruiser` 和 `helicopter_brigade`，仅把线列重型变体转为团属支援。 |
| `JAP_create_marine_modern_mechanized_tank_template` | 日本海陆现代机坦师 | x0: 5 个 `Rance_JAP_M_mechanized`; x1: 4 个 `Rance_JAP_M_mechanized`; x2/x3/x4: 各 3 个 `Rance_JAP_M_modern_armor`; x0、x1 各挂 1 个 `Rance_JAP_M_modern_anti_air_armor_support`; x2 挂 `Rance_JAP_M_modern_artillery_armor_support`; x3、x4 各挂 1 个 `Rance_JAP_M_modern_tankdestroyer_support` | x0、x1、x2、x3、x4 | 已按现代两栖机坦处理。线列从旧 9 海军特战队机械化 + 8 现代坦 + 3 个现代变体改为 9 海军特战队机械化 + 9 现代坦，总宽度 36；现代自防、自火、坦歼转入 M 系现代团属支援。 |
| `JAP_create_land_cruiser_marine_modern_mechanized_tank_template` | 日本陆巡海陆现代机坦师 | x0: 5 个 `Rance_JAP_M_mechanized`; x1: 4 个 `Rance_JAP_M_mechanized`; x2/x3/x4: 各 3 个 `Rance_JAP_M_modern_armor`; x0、x1 各挂 1 个 `Rance_JAP_M_modern_anti_air_armor_support`; x2 挂 `Rance_JAP_M_modern_artillery_armor_support`; x3、x4 各挂 1 个 `Rance_JAP_M_modern_tankdestroyer_support` | x0、x1、x2、x3、x4 | 已按陆巡现代两栖机坦处理。线列与日本海陆现代机坦师一致，总宽度 36；普通支援连保留 `land_cruiser`，现代装甲变体全部转入 M 系现代团属支援。 |

`Rance_JAP_A_infantry` 的 `group = infantry`；原版 `artillery_brigade`、`anti_air_brigade`、`anti_tank_brigade` 的 `group = combat_support`。普通火力支援、步兵炮、防空炮组、反坦克炮组都允许挂在 `infantry / mobile / combat_support` 列下，因此它们都能放在日本步兵师的 x0-x3 列。

### 初步放置口径

基础步兵师已按轻量补强处理：步兵列改为 3+3+3，`fire_support` 放 x0，两个 `field_guns` 分别放 x1、x2。这样保留组织和防御，同时用很少火炮补软攻，并复刻原版早期日本 AI 的 `fire_support + 2 field_guns` 团属支援口径。

日本步兵师已按“长期豪华步兵”处理：15 个步兵保留，步兵列改为 4+4+4+3；线列支援列改为 2 炮 + 1 防空 + 1 反坦克。按 MOD 线列炮 2 宽、步兵 2 宽、防空/反坦 1 宽计算，总宽度从 39 降到 36，五列都满足团属支援承载门槛。团属支援采用 `fire_support + 2 field_guns + anti_air_battery + anti_tank_battery`，即用团属步兵炮承接被砍掉的线列炮兵火力，并用团属反坦弥补少 1 个线列反坦后的反甲口径。

日本试验步坦师已按“早期试验装甲混编”处理：13 个特战步兵和 3 个中坦保留，线列炮兵从 2 个降到 1 个。按 MOD 宽度计算，总宽度从 38 降到 36。团属支援采用 `fire_support + field_guns + anti_air_battery + anti_tank_battery`；装甲列暂不挂日本特殊装甲团属支援，避免该早期模板额外要求中坦歼/自火/防空底盘。

日本步坦师已按“正规步坦歼核心”处理：线列为步兵 4+4、中坦 4+3、中坦歼 3，总宽度从 40 降到 36。团属支援采用 2 个中自行防空挂步兵列，1 个中自火、1 个中坦歼、1 个重坦歼分别挂装甲/坦歼列。该模板创建时已经进入正规步坦阶段并会触发额外装备包，因此可以开始使用日本特殊装甲团属支援。

日本特种步坦师已按“特种步坦歼核心”处理：装甲配置沿用日本步坦师的 7 中坦 + 3 中坦歼，步兵列改为 5+5 特种步兵。无特种减宽时为 40 宽；取得日本专属特种学说 `marine_raider_elements` 后，`Rance_JAP_M_infantry` 每营宽度 -0.2，模板实际降为 38 宽。团属支援中 x0 使用重自行防空支援，x1 使用中自行防空支援，其余为中自火、中坦歼、重坦歼支援。

日本机坦师已按“机械化步坦歼核心”处理：线列为 8 机械化 + 7 中坦 + 3 中坦歼，总宽度从 40 降到 36；团属支援与日本特种步坦师一致，使用重防空、中防空、中自火、中坦歼、重坦歼五件套。

日本两栖机坦师已按“海军特战队机械化步坦歼核心”处理：线列为 8 海军特战队机械化 + 7 海军特战队中坦 + 3 海军特战队中坦歼，总宽度从 40 降到 36；团属支援沿用 A 系五件套，后续若新增 M 系团属支援再替换。

重坦系列已执行：日本重型机坦师、日本两栖重机坦师、日本陆巡两栖重机坦师均采用机械化列 5+4、重坦列 3+3+3，总线列宽度 36；团属支援采用 2 个重自行防空支援、1 个重自火支援、2 个重坦歼支援。两栖与陆巡版本目前沿用 A 系重型团属支援，后续若新增 M 系团属支援再替换。

现代系列已执行：日本海陆现代机坦师、日本陆巡海陆现代机坦师均采用海军特战队机械化列 5+4、海军特战队现代坦列 3+3+3，总线列宽度 36；团属支援采用 2 个海军特战队现代防空支援、1 个海军特战队现代自火支援、2 个海军特战队现代坦歼支援。现代团属支援不从 A 系陆军特殊兵衍生，而是从现有 `Rance_JAP_M_modern_*` 两栖兵种和图标衍生，并保留 `special_forces = yes`、`marines = yes`、`category_amphibious_tanks`。

### 完成状态与待测试项

- 团属支援化适配已完成，状态为 `待测试`：创建模板、AI 目标模板、MOD 特殊团属支援单位、科技启用、相关国策加成、本地化与 interface 图标注册已同步到当前方案。
- M 系中/重团属支援是后续可选扩展：两栖机坦和两栖重机坦仍沿用 A 系中/重团属支援，不阻塞本轮团属适配完成；若后续新增 M 系中/重团属支援，再替换对应模板。
- 图像/图标游戏内显示仍待测试：已添加的 MOD 团属支援连复用现有单位图标并完成 interface 注册，但仍需要进游戏确认 counter、GFX 与编制界面显示效果。
- 模板与 AI 行为仍待测试：需要确认 5 列团属支援均能合法落位，AI 目标模板不会因列组、装备短缺或科技门槛导致异常。
