# HOI4 MIO Trait GFX Key Reference

> 目的：记录 MIO trait 在 `icon = ...` 中常用的 `GFX_...` 键，作为编写 `common/military_industrial_organization/organizations/*.txt` 时的速查参考。
>
> 来源：原版 `interface/military_industrial_organization/industrial_organization_policies_and_traits_icons.gfx`。
>
> 说明：本表优先整理“trait 效果/属性 -> 推荐图标键”的对应关系，不追求把所有 department icon 或 policy icon 一并收进来。

## 使用规则

- 当 trait 的核心效果就是某个 `equipment_bonus` / `production_bonus` 属性时，优先直接使用该属性对应的通用图标键。
- 当多个属性共用同一张原版贴图时，本表会特别标注，便于统一风格。
- 如果 trait 是“组织成长”“研究能力”“任务容量”这类 `organization_modifier` 型效果，可优先使用通用组织图标，或在后续为项目补充自定义图标。

## 一、设计属性图标（equipment_bonus 常用）

| trait 效果 / 属性 | 推荐 GFX key | 备注 |
| --- | --- | --- |
| `ap_attack` | `GFX_generic_mio_trait_icon_ap_attack` | 穿甲 |
| `hard_attack` | `GFX_generic_mio_trait_icon_hard_attack` | 对硬攻击 |
| `soft_attack` | `GFX_generic_mio_trait_icon_soft_attack` | 对软攻击 |
| `breakthrough` | `GFX_generic_mio_trait_icon_breakthrough` | 突破 |
| `defense` | `GFX_generic_mio_trait_icon_defense` | 防御 |
| `build_cost_ic` | `GFX_generic_mio_trait_icon_build_cost_ic` | 造价 |
| `fuel_consumption` | `GFX_generic_mio_trait_icon_fuel_consumption` | 燃油消耗 |
| `maximum_speed` | `GFX_generic_mio_trait_icon_maximum_speed` | 最高速度 |
| `reliability` | `GFX_generic_mio_trait_icon_reliability` | 可靠性 |
| `armor_value` | `GFX_generic_mio_trait_icon_armor_value` | 装甲值 |
| `hardness` | `GFX_generic_mio_trait_icon_hardness` | 硬度 |
| `air_attack` | `GFX_generic_mio_trait_icon_air_attack` | 与防空图标共用同一贴图 |
| `anti_air_attack` | `GFX_generic_mio_trait_icon_anti_air_attack` | 与 `air_attack` 视觉一致 |
| `entrenchment` | `GFX_generic_mio_trait_icon_entrenchment` | 堑壕 |
| `supply_consumption` | `GFX_generic_mio_trait_icon_supply_consumption` | 补给消耗 |
| `air_defence` | `GFX_generic_mio_trait_icon_air_defence` | 实际共用 `defense` 贴图 |
| `air_agility` | `GFX_generic_mio_trait_icon_air_agility` | 空中机动 |
| `air_range` | `GFX_generic_mio_trait_icon_air_range` | 实际共用 `naval_range` 贴图 |
| `weight` | `GFX_generic_mio_trait_icon_weight` | BBA 飞机重量 |
| `air_superiority` | `GFX_generic_mio_trait_icon_air_superiority` | 空优 |
| `night_penalty` | `GFX_generic_mio_trait_icon_night_penalty` | 夜战/夜航相关 |
| `air_ground_attack` | `GFX_generic_mio_trait_icon_air_ground_attack` | 对地攻击 |
| `naval_strike_attack` | `GFX_generic_mio_trait_icon_naval_strike_attack` | 实际共用鱼雷攻击图标 |
| `naval_strike_targetting` | `GFX_generic_mio_trait_icon_naval_strike_targetting` | 对海打击索敌/命中倾向 |
| `strategic_attack` | `GFX_generic_mio_trait_icon_strategic_attack` | 战略轰炸 |
| `surface_detection` | `GFX_generic_mio_trait_icon_surface_detection` | 水面探测 |
| `sub_detection` | `GFX_generic_mio_trait_icon_sub_detection` | 反潜探测 |
| `surface_detection + sub_detection` | `GFX_generic_mio_trait_icon_detection` | 原版注明为“双探测通用图标” |
| `mines_planting` / `mines_sweeping` | `GFX_generic_mio_trait_icon_mines` | 布雷 / 扫雷共用 |
| `naval_range` | `GFX_generic_mio_trait_icon_naval_range` | 航程 / 舰船航程 |
| `naval_speed` | `GFX_generic_mio_trait_icon_naval_speed` | 航速 |
| `max_strength` | `GFX_generic_mio_trait_icon_max_strength` | 最大强度 |
| `naval_torpedo_damage_reduction_factor` | `GFX_generic_mio_trait_icon_naval_torpedo_damage_reduction_factor` | 鱼雷减伤 |
| `hg_attack` | `GFX_generic_mio_trait_icon_hg_attack` | 重炮攻击 |
| `lg_attack` | `GFX_generic_mio_trait_icon_lg_attack` | 轻炮攻击 |
| `naval_light_gun_hit_chance_factor` / `naval_heavy_gun_hit_chance_factor` | `GFX_generic_mio_trait_icon_batteries_hit_chance` | 原版统一为 batteries hit chance 图标 |
| `torpedo_attack` | `GFX_generic_mio_trait_icon_torpedo_attack` | 鱼雷攻击 |
| `sub_attack` | `GFX_generic_mio_trait_icon_sub_attack` | 反潜攻击 |
| `sub_visibility` | `GFX_generic_mio_trait_icon_sub_visibility` | 潜艇可见度 |
| `naval_torpedo_hit_chance_factor` | `GFX_generic_mio_trait_icon_naval_torpedo_hit_chance_factor` | 鱼雷命中 |
| `surface_visibility` | `GFX_generic_mio_trait_icon_surface_visibility` | 水面可见度 |

## 二、生产属性图标（production_bonus 常用）

| trait 效果 / 属性 | 推荐 GFX key | 备注 |
| --- | --- | --- |
| `production_capacity_factor` | `GFX_generic_mio_trait_icon_production_capacity` | 产能 |
| `efficiency_cap_factor` | `GFX_generic_mio_trait_icon_efficiency_cap` | 效率上限 |
| `efficiency_gain_factor` | `GFX_generic_mio_trait_icon_efficiency_gain` | 效率增长 |
| `conversion_speed_factor` | `GFX_generic_mio_trait_icon_conversion_speed` | 转产速度 |
| `resources` | `GFX_generic_mio_trait_icon_resources` | 资源消耗 / 原材料倾向 |
| `production_cost_factor` | `GFX_generic_mio_trait_icon_build_cost_ic` | 原版没有单独 production_cost 图标，通常复用造价图标 |

## 三、组织修正与泛用图标

| 用途 | 推荐 GFX key | 备注 |
| --- | --- | --- |
| 泛用特殊 trait / 难归类 trait | `GFX_generic_mio_trait_icon_unique` | 适合“专属”、“特色路线”、“特殊机制” |
| `organization_modifier` 为主的 trait | `GFX_organization_modifier_icon` | 通用组织修正图标 |

适用场景示例：

- `military_industrial_organization_research_bonus`
- `military_industrial_organization_task_capacity`
- `military_industrial_organization_funds_gain`
- `military_industrial_organization_design_team_assign_cost`
- `military_industrial_organization_design_team_change_cost`
- `military_industrial_organization_industrial_manufacturer_assign_cost`
- `military_industrial_organization_size_up_requirement`

如果一个 trait 主要表达“这家公司更会研发 / 更会扩编 / 更会积累资金”，而不是某个具体装备属性，优先考虑上面这两类图标。

## 四、几个需要特别记住的贴图复用关系

这些键名不同，但原版实际用了同一张或近似用途的贴图：

| GFX key | 实际贴图来源 | 说明 |
| --- | --- | --- |
| `GFX_generic_mio_trait_icon_air_attack` | `generic_mio_trait_icon_anti_air_attack.dds` | 空袭攻击与防空攻击共图 |
| `GFX_generic_mio_trait_icon_anti_air_attack` | `generic_mio_trait_icon_anti_air_attack.dds` | 同上 |
| `GFX_generic_mio_trait_icon_air_defence` | `generic_mio_trait_icon_defense.dds` | 空防复用防御图 |
| `GFX_generic_mio_trait_icon_air_range` | `generic_mio_trait_icon_naval_range.dds` | 航程复用海程图 |
| `GFX_generic_mio_trait_icon_naval_strike_attack` | `generic_mio_trait_icon_torpedo_attack.dds` | 对海攻击复用鱼雷图 |

## 五、编写建议

- trait 同时含多个效果时，优先按“最核心、最先被玩家识别”的效果选图标。
- 如果是一整条分支都围绕同一主题，可以刻意统一图标风格，强化树的可读性。
- 如果你需要的是“部门/分支标题图标”，不要误用本表，应转去查 `generic_mio_department_icon_...`。
- 如果后续项目开始使用自定义 MIO trait 图标，建议继续在本表追加“原版通用键 / 项目自定义键 / 适用场景”三列。

## 六、推荐工作流

编写一个新 trait 时，建议按下面顺序判断：

1. 先看 trait 核心是 `equipment_bonus`、`production_bonus` 还是 `organization_modifier`
2. 如果是单属性，优先直接用该属性对应的通用 GFX key
3. 如果是多属性混合，按主主题选图标
4. 如果原版没有特别合适的图标，先用 `GFX_generic_mio_trait_icon_unique`
5. 若后续该 trait 很关键，再考虑补项目自定义图标
