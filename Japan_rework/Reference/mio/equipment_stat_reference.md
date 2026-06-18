# HOI4 MIO Equipment Stat Reference

> 目的：整理 `script_enum_equipment_stat` 中出现的装备属性字段，作为编写 MIO `equipment_bonus = { ... }` 时的速查参考。
>
> 主要来源：
> - `common/script_enums.txt`
> - `common/military_industrial_organization/organizations/_documentation.md`
>
> 重点：
> - 哪些字段存在于枚举中
> - 哪些字段可用于 MIO
> - 哪些字段虽然存在，但不应在 MIO 中使用
> - 哪些字段只对特定装备或 DLC / 模块生效

## 一、使用原则

- `script_enum_equipment_stat` 列出的是“装备属性字段全集”，不是“都适合写进 MIO”的白名单。
- 优先使用：
  - 原版 `script_enums.txt` 中未标注 `Cannot be used with MIOS` 的字段
  - 且在 `_documentation.md` 中被确认能对对应装备类型生效的字段
- 如果某字段在枚举里存在，但原版明确写了 `Cannot be used with MIOS`，默认不要写进 MIO。
- 如果某字段依赖 DLC、模块或特定装备，必须在设计里明确这一前提。

## 二、MIO 可用性快速分级

### A. 可直接优先用于 MIO

这些是最常见、最稳定、最推荐直接用于 MIO 的字段：

- `defense`
- `breakthrough`
- `hardness`
- `soft_attack`
- `hard_attack`
- `maximum_speed`
- `armor_value`
- `ap_attack`
- `reliability`
- `build_cost_ic`
- `fuel_consumption`
- `air_attack`
- `air_agility`
- `air_range`
- `air_defence`
- `air_ground_attack`
- `air_bombing`
- `air_superiority`
- `naval_speed`
- `naval_range`
- `surface_detection`
- `sub_detection`
- `surface_visibility`
- `sub_visibility`
- `lg_attack`
- `lg_armor_piercing`
- `hg_attack`
- `hg_armor_piercing`
- `torpedo_attack`
- `sub_attack`
- `anti_air_attack`
- `naval_light_gun_hit_chance_factor`
- `naval_heavy_gun_hit_chance_factor`
- `naval_torpedo_hit_chance_factor`
- `naval_torpedo_damage_reduction_factor`
- `naval_torpedo_enemy_critical_chance_factor`
- `naval_strike_attack`
- `naval_strike_targetting`

### B. 可用，但必须看装备 / DLC / 模块

- `entrenchment`
- `fuel_capacity`
- `mines_planting`
- `mines_sweeping`
- `weight`
- `thrust`
- `strategic_attack`
- `carrier_size`
- `railway_gun_annex_ratio`
- `railway_gun_hours_between_redistribution`
- `naval_weather_penalty_factor`

### C. 枚举里有，但默认不要用于 MIO

这些在原版 `script_enums.txt` 已明确标注不适合 MIO：

- `default_morale`
- `recon`
- `initiative`
- `casualty_trickleback`
- `supply_consumption_factor`
- `supply_consumption`
- `suppression`
- `suppression_factor`
- `experience_loss_factor`
- `equipment_capture_factor`
- `railway_gun_attack`
- `max_organisation`
- `acclimatization_hot_climate_gain_factor`
- `acclimatization_cold_climate_gain_factor`
- `night_penalty`

## 三、字段总表

### 1. 陆战 / 地面装备常用字段

| 字段 | 中文理解 | MIO建议 | 备注 |
| --- | --- | --- | --- |
| `defense` | 防御 | 可用 | 常见于坦克、步兵装备、炮兵装备等 |
| `breakthrough` | 突破 | 可用 | 坦克、机动类、部分火炮装备常用 |
| `hardness` | 硬度 | 可用 | 装甲/机动装备较常见 |
| `soft_attack` | 对软攻击 | 可用 | 最常用输出字段之一 |
| `hard_attack` | 对硬攻击 | 可用 | 反坦、坦克、火炮常见 |
| `maximum_speed` | 最高速度 | 可用 | 坦克、摩托化、机械化、部分飞机 |
| `armor_value` | 装甲值 | 可用 | 坦克、机动装备、部分舰船等 |
| `ap_attack` | 穿甲攻击 | 可用 | 反坦、坦克主炮类常见 |
| `reliability` | 可靠性 | 可用 | 几乎所有装备系常用 |
| `reliability_factor` | 可靠性系数 | 谨慎 | 枚举中存在，但原版 MIO极少直接用，优先用 `reliability` |
| `build_cost_ic` | 工业成本 / 造价 | 可用 | 最常见经济向字段之一 |
| `fuel_consumption` | 燃油消耗 | 可用 | 坦克、机动、飞机、舰船常见 |
| `fuel_consumption_factor` | 燃油消耗系数 | 谨慎 | 枚举存在，但优先确认实际装备是否读取 |
| `fuel_capacity` | 燃油容量 | 条件可用 | NSB 坦克模块前提 |
| `entrenchment` | 堑壕 | 条件可用 | 原版说明：仅坦克推土铲模块有效，不适用于步兵 |
| `amphibious_defense` | 两栖防御 | 谨慎 | 仅少数特化装备可考虑 |
| `recovery` | 恢复 | 谨慎 | 枚举存在，但项目里写 MIO 前应先核实目标装备是否实际读取 |
| `additional_collateral_damage` | 附加连带伤害 | 谨慎 | 非常少用，写前先确认设计目标 |

### 2. 海军装备字段

| 字段 | 中文理解 | MIO建议 | 备注 |
| --- | --- | --- | --- |
| `lg_attack` | 轻炮攻击 | 可用 | 需舰船模块支持 |
| `lg_armor_piercing` | 轻炮穿甲 | 可用 | 需舰船模块支持 |
| `hg_attack` | 重炮攻击 | 可用 | 需舰船模块支持 |
| `hg_armor_piercing` | 重炮穿甲 | 可用 | 需舰船模块支持 |
| `torpedo_attack` | 鱼雷攻击 | 可用 | 常见舰船 / 海轰相关 |
| `sub_attack` | 反潜攻击 | 可用 | 需模块支持 |
| `anti_air_attack` | 防空攻击 | 可用 | 舰船和陆军防空装备都常见 |
| `max_strength` | 最大强度 | 可用 | 原版潜艇等舰船 MIO 有实际用例；非舰船模板仍应先核对目标装备是否实际读取 |
| `naval_speed` | 航速 | 可用 | 舰船核心字段 |
| `naval_range` | 航程 | 可用 | 舰船核心字段 |
| `surface_detection` | 水面探测 | 可用 | 舰船、飞机部分可用 |
| `sub_detection` | 对潜探测 | 可用 | 舰船、飞机部分可用 |
| `surface_visibility` | 水面可见度 | 可用 | 水面舰艇有效 |
| `sub_visibility` | 潜艇可见度 | 可用 | 仅潜艇有效 |
| `mines_planting` | 布雷 | 条件可用 | 需 MTG / 模块 |
| `mines_sweeping` | 扫雷 | 条件可用 | 需 MTG / 模块 |
| `naval_light_gun_hit_chance_factor` | 轻炮命中 | 可用 | 需模块支持 |
| `naval_heavy_gun_hit_chance_factor` | 重炮命中 | 可用 | 需模块支持 |
| `naval_torpedo_hit_chance_factor` | 鱼雷命中 | 可用 | 需模块支持 |
| `naval_torpedo_damage_reduction_factor` | 鱼雷减伤 | 可用 | 部分模块/设计可支持 |
| `naval_torpedo_enemy_critical_chance_factor` | 敌方鱼雷暴击概率修正 | 可用 | 原版舰船 MIO有用例 |
| `convoy_raiding_coordination` | 破交协同 | 谨慎 | 枚举存在，但常规 MIO 较少使用 |
| `patrol_coordination` | 巡逻协同 | 谨慎 | 同上 |
| `search_and_destroy_coordination` | 搜歼协同 | 谨慎 | 同上 |
| `carrier_size` | 航母机库容量 | 条件可用 | 原版就有，但非常敏感，慎用 |
| `submarine_carrier_size` | 潜母容量 | 条件可用 | 极少见，慎用 |
| `carrier_surface_detection` | 航母水面探测 | 条件可用 | 极少见，需确认目标装备 |
| `carrier_sub_detection` | 航母对潜探测 | 条件可用 | 极少见，需确认目标装备 |
| `naval_weather_penalty_factor` | 海军天气惩罚修正 | 条件可用 | 枚举存在，但建议先做原版验证再写 |

### 3. 空军装备字段

| 字段 | 中文理解 | MIO建议 | 备注 |
| --- | --- | --- | --- |
| `air_range` | 航程 | 可用 | 飞机常用 |
| `air_defence` | 空中防御 | 可用 | 飞机常用 |
| `air_attack` | 对空攻击 | 可用 | 飞机常用 |
| `air_agility` | 空中机动 | 可用 | 飞机核心字段 |
| `air_bombing` | 轰炸 | 可用 | 战略/战术轰炸可用 |
| `air_superiority` | 空优 | 可用 | 战斗机/截击机常用 |
| `naval_strike_attack` | 对海攻击 | 可用 | 海军航空常用 |
| `naval_strike_targetting` | 对海瞄准 | 可用 | 海军航空常用 |
| `air_ground_attack` | 对地攻击 | 可用 | CAS / 战术机常用 |
| `air_visibility_factor` | 空中可见度系数 | 谨慎 | 枚举有，但原版 MIO几乎不常写 |
| `weight` | 重量 | 条件可用 | BBA 相关 |
| `thrust` | 推力 | 条件可用 | BBA 相关，原版也提醒谨慎 |
| `strategic_attack` | 战略攻击 | 条件可用 | 主要对应战略轰炸 |

### 4. 铁路炮 / 特殊平台字段

| 字段 | 中文理解 | MIO建议 | 备注 |
| --- | --- | --- | --- |
| `railway_gun_attack` | 铁道炮攻击 | 可用 | 适用于 railway_gun_equipment，写入前确认目标装备范围 |
| `railway_gun_attack_range_index_in_define` | 铁道炮射程定义索引 | 不用于MIO | 只能用于装备定义，不用于 MIO |
| `railway_gun_annex_ratio` | 铁道炮吞并比率 / 影响系数 | 条件可用 | 枚举存在，但应谨慎验证 |
| `railway_gun_hours_between_redistribution` | 铁道炮重新部署间隔 | 条件可用 | 极少用，先验证再写 |

### 5. 枚举中存在但默认不要写入 MIO 的字段

| 字段 | 中文理解 | 原版备注 |
| --- | --- | --- |
| `default_morale` | 默认士气 | `Cannot be used with MIOS` |
| `recon` | 侦察 | `Cannot be used with MIOS` |
| `initiative` | 主动性 | `Cannot be used with MIOS` |
| `casualty_trickleback` | 伤亡回流 | `Cannot be used with MIOS` |
| `supply_consumption_factor` | 补给消耗系数 | `Cannot be used with MIOS` |
| `supply_consumption` | 补给消耗 | `Cannot be used with MIOS` |
| `suppression` | 镇压 | `Cannot be used with MIOS` |
| `suppression_factor` | 镇压系数 | `Cannot be used with MIOS` |
| `experience_loss_factor` | 经验损失 | `Cannot be used with MIOS` |
| `equipment_capture_factor` | 装备缴获 | `Cannot be used with MIOS` |
| `max_organisation` | 最大组织度 | `Cannot be used with MIOS` |
| `acclimatization_hot_climate_gain_factor` | 炎热适应增长 | `Cannot be used with MIOS` |
| `acclimatization_cold_climate_gain_factor` | 寒冷适应增长 | `Cannot be used with MIOS` |
| `night_penalty` | 夜间惩罚 | `Cannot be used with MIOS` |

## 四、按装备类型查最常用字段

### 坦克 / 装甲车辆

优先关注：

- `maximum_speed`
- `reliability`
- `defense`
- `breakthrough`
- `armor_value`
- `soft_attack`
- `hard_attack`
- `ap_attack`
- `build_cost_ic`
- `fuel_consumption`
- `hardness`

条件字段：

- `entrenchment`
- `fuel_capacity`

### 舰船

优先关注：

- `lg_attack`
- `lg_armor_piercing`
- `hg_attack`
- `hg_armor_piercing`
- `torpedo_attack`
- `sub_attack`
- `anti_air_attack`
- `naval_speed`
- `naval_range`
- `surface_detection`
- `sub_detection`
- `surface_visibility`
- `sub_visibility`
- `build_cost_ic`
- `fuel_consumption`

条件字段：

- `mines_planting`
- `mines_sweeping`
- `carrier_size`
- 各种命中率相关 factor

### 飞机

优先关注：

- `air_superiority`
- `reliability`
- `naval_strike_attack`
- `naval_strike_targetting`
- `fuel_consumption`
- `build_cost_ic`
- `maximum_speed`
- `air_range`
- `air_agility`
- `air_attack`
- `air_defence`
- `surface_detection`
- `sub_detection`
- `air_ground_attack`
- `air_bombing`

条件字段：

- `weight`
- `thrust`
- `mines_planting`
- `mines_sweeping`

### 步兵装备

优先关注：

- `reliability`
- `maximum_speed`
- `defense`
- `breakthrough`
- `soft_attack`
- `hard_attack`
- `ap_attack`
- `build_cost_ic`

不建议依赖：

- `hardness`
- `armor_value`
- `air_attack`

这些在脚本里虽存在，但基础值通常为 0，游戏里也常不显示。

### 支援装备

优先关注：

- `reliability`
- `build_cost_ic`

### 火炮 / 反坦 / 防空 / 火箭炮

优先关注：

- `reliability`
- `defense`
- `breakthrough`
- `hardness`
- `armor_value`
- `soft_attack`
- `hard_attack`
- `ap_attack`
- `air_attack`
- `build_cost_ic`

### 摩托化 / 机械化

优先关注：

- `maximum_speed`
- `reliability`
- `hardness`
- `breakthrough`
- `build_cost_ic`
- `fuel_consumption`

机械化额外常见：

- `defense`
- `armor_value`
- `ap_attack`
- `air_attack`

### 列车

优先关注：

- `armor_value`
- `build_cost_ic`
- `air_attack`

### 铁道炮

优先关注：

- `reliability`
- `maximum_speed`
- `build_cost_ic`

不要默认在 MIO 里依赖：

- `railway_gun_attack`

## 五、推荐工作流

写一个新的 `equipment_bonus` 时，建议按这几步判断：

1. 先看字段是否存在于 `script_enum_equipment_stat`
2. 再看原版是否标明 `Cannot be used with MIOS`
3. 再看 `_documentation.md` 中该装备类型是否真的列出这个字段
4. 若涉及 DLC / 模块 / 特殊装备，再补确认触发条件
5. 最后再决定图标，转去查 `Reference/mio/trait_gfx_reference.md`

## 六、给本项目的默认约束

在本项目里，若用户没有特别要求：

- 不要把 `Cannot be used with MIOS` 的字段写进模板组织
- 不要把“脚本里有但基础值常为 0、UI也不显示”的字段当成核心卖点
- 对 `carrier_size`、`thrust`、`railway_gun_*` 这类敏感字段，默认先查原版用例再动笔

## 七、补正：参考 `MIO_documentation_zh.md`

以下内容是根据 `common/military_industrial_organization/MIO_documentation_zh.md` 补入的项目补正，用来修正或补全本参考里之前覆盖不足的字段与装备类型对应关系。

### 1. 额外应记录的可写字段

这些字段在模板设计时应明确纳入“可检查字段”范围：

- `production_resource_penalty_factor`
- `manpower`
- `resources`
- `naval_dominance_factor`
- `air_visibility_factor`
- `submarine_carrier_size`
- `carrier_surface_detection`
- `carrier_sub_detection`

使用建议：

- `production_resource_penalty_factor`：可视为一种生产资源惩罚修正字段，航空原型中已出现，写生产型 MIO 时应纳入检查范围
- `manpower`：文档列出于舰船、飞机等类型中，属于条件可用字段，写入前优先查原版实例
- `resources`：文档列于飞机字段中，属于谨慎字段，写入前优先查原版实例
- `naval_dominance_factor`：文档列于舰船字段中，属于谨慎字段，除非明确需要，否则不要当作基础模板核心字段
- `air_visibility_factor`：可写但应谨慎，原版 MIO 基本不常写
- `submarine_carrier_size`、`carrier_surface_detection`、`carrier_sub_detection`：属于极少见航母/潜母相关字段，默认只做记录，不作为模板常规字段

### 2. 细化后的装备类型字段速查

这部分用于补足“某些装备类型在当前 ref 中覆盖太粗”的问题。

#### Support Equipment

优先关注：

- `reliability`
- `build_cost_ic`

#### Artillery Equipment

优先关注：

- `reliability`
- `defense`
- `breakthrough`
- `hardness`
- `armor_value`
- `soft_attack`
- `hard_attack`
- `ap_attack`
- `air_attack`
- `build_cost_ic`

#### Anti-Air Equipment

优先关注：

- `reliability`
- `defense`
- `breakthrough`
- `hardness`
- `armor_value`
- `soft_attack`
- `hard_attack`
- `ap_attack`
- `air_attack`
- `build_cost_ic`

#### Anti-Tank Equipment

优先关注：

- `reliability`
- `defense`
- `breakthrough`
- `hardness`
- `armor_value`
- `soft_attack`
- `hard_attack`
- `ap_attack`
- `air_attack`
- `build_cost_ic`

#### Rocket Artillery Equipment

优先关注：

- `reliability`
- `defense`
- `breakthrough`
- `hardness`
- `armor_value`
- `soft_attack`
- `hard_attack`
- `ap_attack`
- `air_attack`
- `build_cost_ic`

#### Motorized Equipment

优先关注：

- `maximum_speed`
- `reliability`
- `hardness`
- `breakthrough`
- `build_cost_ic`
- `fuel_consumption`

#### Motorized Rocket Equipment

优先关注：

- `reliability`
- `defense`
- `breakthrough`
- `hardness`
- `armor_value`
- `soft_attack`
- `hard_attack`
- `ap_attack`
- `air_attack`
- `build_cost_ic`

#### Mechanized Equipment

优先关注：

- `maximum_speed`
- `reliability`
- `defense`
- `breakthrough`
- `hardness`
- `armor_value`
- `ap_attack`
- `air_attack`
- `build_cost_ic`
- `fuel_consumption`

#### Amphibious Mechanized Equipment

优先关注：

- `maximum_speed`
- `reliability`
- `defense`
- `breakthrough`
- `hardness`
- `armor_value`
- `ap_attack`
- `air_attack`
- `build_cost_ic`
- `fuel_consumption`

#### Armored Car Equipment

优先关注：

- `maximum_speed`
- `reliability`
- `defense`
- `breakthrough`
- `hardness`
- `armor_value`
- `soft_attack`
- `hard_attack`
- `ap_attack`
- `air_attack`
- `build_cost_ic`
- `fuel_consumption`

#### Train Equipment

优先关注：

- `armor_value`
- `build_cost_ic`
- `air_attack`

#### Railway Gun Equipment

优先关注：

- `reliability`
- `maximum_speed`
- `build_cost_ic`
- `railway_gun_attack`

### 3. “脚本里有，但默认别当核心卖点”的字段

根据中文文档补正，下列字段即使存在于脚本层，也不要默认当作模板卖点：

- 步兵装备上的 `hardness`
- 步兵装备上的 `armor_value`
- 步兵装备上的 `air_attack`

原因：

- 这些字段虽然在脚本里存在，但常见基础值为 `0`
- 游戏 UI 往往也不显示
- 更适合作为特殊实验项，而不是模板核心字段

### 4. 与当前 AGENTS 配套的使用约束

今后在本项目中写 `equipment_bonus = { ... }` 时，建议按以下顺序判断：

1. 先看字段是否存在于 `script_enum_equipment_stat`
2. 再看是否被标注 `Cannot be used with MIOS`
3. 再看 `MIO_documentation_zh.md` 中对应装备类型是否列出该字段
4. 若涉及 DLC / 模块 / 特定装备前提，再确认触发条件
5. 最后再决定是否把它纳入模板总值规划

这部分流程与 `common/military_industrial_organization/AGENTS.md` 中的 Equipment Stat Lookup 规则配套使用。
