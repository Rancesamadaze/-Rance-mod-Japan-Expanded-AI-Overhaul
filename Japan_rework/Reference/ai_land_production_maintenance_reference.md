# AI 陆军生产系统维护参考

更新日期：2026-05-26。

本文只维护当前落地口径，用来快速判断“应该改哪一层”。旧版长篇开发归档已经压缩为本文末尾的历史口径摘要；实际维护时以当前脚本为准。

## 快速入口

| 要做的事 | 优先改哪里 | 还要同步检查 |
| --- | --- | --- |
| 改补装备模式阈值 | `history/countries/JAP - Japan.txt` 的 `JAP_ai_land_production_high_demand_*` / `low_demand_*` | `common/on_actions/JAP_rework_focus_on_actions.txt` 的月度复制变量 |
| 改扩军模式库存率阈值 | `common/scripted_triggers/JAP_ai_land_production_scripted_triggers.txt` 中各装备 `stockpile_ratio ratio` | 本文“扩军模式库存率阈值”表 |
| 改某装备增产/减产触发时机 | `common/scripted_triggers/JAP_ai_land_production_scripted_triggers.txt` | 对应设计 flag、难度门槛、是否只减产 |
| 改某装备产线力度 | `common/ai_strategy/JAP_rework_ai_land_production_v2.txt` | baseline / increase / decline 三类块是否一起需要调整 |
| 改编制训练倾向 | `common/ai_strategy/JAP_rework_ai_template_v2.txt` | 正向 `role_ratio` 与抑制负值是否等额 |
| 改编制阶段推进 | `common/decisions/JAP_rework_ai_decision.txt`、`common/scripted_triggers/JAP_rework_scripted_triggers.txt` | 阶段 flag、阶段互斥、阶段替换抑制 |
| 新增 AI 编制或装备需求 | `common/ai_templates/templates_JAP.txt` | `Reference/template_JAP_equipment_requirements.md`、`Reference/ai_land_production_difficulty_equipment_reference.md` |
| 调试库存率 | `common/scripted_triggers/JAP_rework_debug_scripted_triggers.txt`、`common/decisions/JAP_rework_debug_decisions.txt` | `localisation/simp_chinese/JAP_debug_l_simp_chinese.yml` |

## 当前链路

陆军生产系统由五段组成：

| 层级 | 作用 | 主要文件 |
| --- | --- | --- |
| 参数初始化 | 初始化阈值、工厂档位、动态工厂比例、旧变量兼容值 | `history/countries/JAP - Japan.txt` |
| 循环入口 | 启动 15 天装备循环和 45 天编制抑制循环 | `common/decisions/JAP_rework_equipment_design_decision.txt` |
| 状态判定 | 用 scripted trigger 判断装备是否应增产/减产、编制是否应暂停训练 | `common/scripted_triggers/JAP_ai_land_production_scripted_triggers.txt`、`common/scripted_triggers/JAP_rework_scripted_triggers.txt` |
| 状态执行 | 由 scripted effect 设置或清除 country flag | `common/scripted_effects/JAP_equipment_scripted_effects.txt` |
| AI 消费 | AI strategy 读取 flag，改变产线、编制训练和部分前线行为 | `common/ai_strategy/JAP_rework_ai_land_production_v2.txt`、`common/ai_strategy/JAP_rework_ai_template_v2.txt`、`common/ai_strategy/Jap_rework_kodoha_mil.txt` |

运行路径：

1. `JAP_ai_land_production_loop_start` 在军工大于 `100` 后启动循环。
2. `JAP_ai_land_production_equipment_cycle_mission` 每 15 天调用动态工厂变量更新与装备调产 flag 更新。
3. `JAP_ai_land_production_template_suppression_cycle_mission` 每 45 天调用编制训练抑制 flag 更新，并在额外装备未关闭时调用陆空额外装备发放。
4. `on_monthly` 每月按战争/和平状态切换当前生效的补装备阈值变量。
5. AI strategy 消费增产、减产、补装备模式和训练抑制 flag。

## 两套口径

当前调产不是旧的一套总装备率，而是双模式。

| 模式 | flag | 口径 | 用途 |
| --- | --- | --- | --- |
| 扩军模式 | 没有 `JAP_ai_land_production_replenishment_mode` | `stockpile_ratio`，即库存 / 已使用装备；已使用装备包含已部署和训练中装备 | 扩编时看库存相对训练消耗是否够 |
| 补装备模式 | 有 `JAP_ai_land_production_replenishment_mode` | `(库存 / 1000 + 已部署装备k) / (已部署目标装备k + 0.01)` | 部队已经缺装时按现役填充率补短板 |

两类阈值的本质不同：

- 扩军模式阈值是“库存安全垫 / 扩编余量”阈值。它不直接回答现役师是否满编，而是回答：在已经部署和训练中的装备消耗之外，库存还剩多少缓冲，够不够继续扩军。
- 补装备模式阈值是“现役满编率 / 缺装恢复线”阈值。它不关心训练队列已经吃掉多少库存，而是回答：已经部署在前线的部队，距离目标装备需求还差多少。

现役填充率公式：

```txt
现役填充率 = (库存数量 / 1000 + 现役已装备数量k) / (现役目标装备数量k + 0.01)
```

对应脚本写法，以 `infantry_equipment` 为例：

```txt
set_temp_variable = { r_ratio = num_equipment@infantry_equipment }
divide_temp_variable = { r_ratio = 1000 }
add_to_temp_variable = { r_ratio = num_equipment_in_armies_k@infantry_equipment }
set_temp_variable = { r_denom = num_target_equipment_in_armies_k@infantry_equipment }
add_to_temp_variable = { r_denom = 0.01 }
divide_temp_variable = { r_ratio = r_denom }
```

`num_equipment@...` 是库存件数；`num_equipment_in_armies_k@...` 和 `num_target_equipment_in_armies_k@...` 是千件口径，所以库存必须先除以 `1000`。分母加 `0.01` 是防止目标需求为 `0` 时除零；真正落地时仍应通过有效装备门槛避免尚未启用的装备参与全局补装备判断。

不要再把 `START_TRAINING_EQUIPMENT_LEVEL = 0.65` 或旧方案里的 `1.25` 当成本系统阈值。它们只属于历史背景，不是当前脚本的主判断。

`JAP_ai_land_production_replenishment_mode` 的切换规则：

| 动作 | trigger | 逻辑 |
| --- | --- | --- |
| 进入补装备模式 | `JAP_ai_land_production_should_start_replenishment_mode` | 任一“当前有效 high_demand 装备”低于训练抑制启动线 |
| 退出补装备模式 | `JAP_ai_land_production_should_stop_replenishment_mode` | 所有“当前有效 high_demand 装备”都恢复到训练抑制停止线以上，或该装备不再有效 |

补装备模式还有一个额外消费者：`common/ai_strategy/Jap_rework_kodoha_mil.txt` 的 `JAP_kodoha_replenishment_mode_pause_fronts` 会在皇道派 AI 战时暂停陆上推进，避免进攻继续扩大装备缺口。

## 参数和阈值

### 初始化变量

`history/countries/JAP - Japan.txt`

| 变量组 | 当前用途 |
| --- | --- |
| `JAP_ai_land_production_min_military_factories` | 启动陆军生产调控的最低军工数，当前 `100` |
| `JAP_ai_land_production_high_demand_*` | 当前生效的 high_demand 补装备模式现役填充率阈值 |
| `JAP_ai_land_production_low_demand_*` | 当前生效的 low_demand 补装备模式现役填充率阈值 |
| `*_peace_*` / `*_war_*` | 和平/战争两套补装备阈值；当前数值相同，但仍由 monthly on_action 复制 |
| `JAP_ai_land_production_template_suppression_start` / `stop` | 编制装备短缺训练抑制阈值，当前 `0.90 / 1.05` |
| `JAP_ai_land_production_min_factories_*` | 产线策略参数档位遗留缓存 |
| `JAP_ai_land_production_increase_min_ratio_*` | 动态增产保底比例，用于每 15 天计算缓存变量 |
| `JAP_ai_land_production_increase_min_factories_*` | 动态计算后的增产保底工厂缓存；当前 v2 strategy 已使用固定分支，不直接读取这些变量 |
| `Rance_critical_*` / `Rance_non_critical_*` | 旧陆军生产策略兼容变量；旧策略完全清理前不要随手删除 |

### 补装备模式现役填充率阈值

实际值在 `history/countries/JAP - Japan.txt`。当前 peace / war 与开局当前值一致。

| 装备层级 | 增产启动 | 增产终止 | 减产启动 | 减产终止 |
| --- | ---: | ---: | ---: | ---: |
| `high_demand` | 1.00 | 1.05 | 1.15 | 1.05 |
| `low_demand` | 0.85 | 1.00 | 1.10 | 1.00 |

### 扩军模式库存率阈值

实际值固定写在 `JAP_ai_land_production_<equipment>_should_*` 的 `stockpile_ratio` 分支中。

| 战争状态 | 装备层级 | 增产启动 | 增产终止 | 减产启动 | 减产终止 |
| --- | --- | ---: | ---: | ---: | ---: |
| 和平 | `high_demand` | 0.12 | 0.25 | 0.30 | 0.22 |
| 和平 | `low_demand` | 0.08 | 0.20 | 0.40 | 0.30 |
| 战争 | `high_demand` | 0.08 | 0.18 | 0.25 | 0.18 |
| 战争 | `low_demand` | 0.06 | 0.15 | 0.35 | 0.25 |

只减产装备也使用 `low_demand` 的减产启动/终止阈值，但没有增产 trigger。

### 编制训练抑制阈值

| 变量 | 当前值 | 说明 |
| --- | ---: | --- |
| `JAP_ai_land_production_template_suppression_start` | 0.90 | 战争中，低于该现役填充率时设置对应编制的装备短缺抑制 flag |
| `JAP_ai_land_production_template_suppression_stop` | 1.05 | 和平或高于该现役填充率时清除对应编制的装备短缺抑制 flag |

训练抑制只在战争中设置；和平会清除装备短缺抑制 flag。阶段替换抑制不依赖战争状态。

## 装备分层

### high_demand

这些装备参与调产，也参与训练抑制，并可影响全局补装备模式。

| 装备 key | 说明 | 有效 high_demand 门槛 |
| --- | --- | --- |
| `infantry_equipment` | 步兵装备 | 始终有效 |
| `mechanized_equipment` | 机械化装备 | `Rance_nd_more_than_easy = yes` + `JAP_has_cr_mechanized_equipment_design = yes` |
| `amphibious_mechanized_equipment` | 两栖机械化装备 | `Rance_nd_more_than_easy = yes` + `JAP_has_cr_amphibious_mechanized_equipment_design = yes` |
| `medium_tank_chassis` | 中型坦克底盘 | `JAP_has_cr_medium_tank_chassis_design = yes` |
| `heavy_tank_chassis` | 重型坦克底盘 | `Rance_nd_more_than_hard = yes` + `JAP_has_cr_heavy_tank_chassis_design = yes` |
| `modern_tank_chassis` | 现代坦克底盘 | `Rance_nd_more_than_easy = yes` + 设计 flag + `JAP_ai_land_production_modern_tank_template_created` |
| `medium_tank_amphibious_chassis` | 中型两栖坦克底盘 | `Rance_nd_more_than_normal = yes` + 设计 flag |
| `heavy_tank_amphibious_chassis` | 重型两栖坦克底盘 | `Rance_nd_more_than_hard = yes` + 设计 flag |
| `land_cruiser_chassis` | 陆地巡洋舰底盘 | `Rance_nd_more_than_lunatic = yes` + 设计 flag |

有效 high_demand 门槛写在 `JAP_ai_land_production_<equipment>_is_effective_high_demand`。新增主战装备时必须先决定它是否参与全局补装备模式。

### low_demand：允许增产和减产

这些装备进入完整增产/减产状态机，但不触发编制训练抑制，也不决定全局补装备模式。

| 装备 key | 说明 |
| --- | --- |
| `support_equipment` | 支援装备 |
| `helicopter_equipment` | 直升机装备 |
| `armored_support_vehicle` | 装甲支援车辆 |
| `medium_tank_destroyer_chassis` | 中型坦克歼击车底盘 |
| `heavy_tank_destroyer_chassis` | 重型坦克歼击车底盘 |
| `modern_tank_destroyer_chassis` | 现代坦克歼击车底盘 |
| `medium_tank_artillery_chassis` | 中型自行火炮底盘 |
| `heavy_tank_artillery_chassis` | 重型自行火炮底盘 |
| `modern_tank_artillery_chassis` | 现代自行火炮底盘 |
| `medium_tank_aa_chassis` | 中型自行防空底盘 |
| `heavy_tank_aa_chassis` | 重型自行防空底盘 |
| `modern_tank_aa_chassis` | 现代自行防空底盘 |
| `medium_tank_flame_chassis` | 中型喷火坦克底盘 |

### low_demand：只减产

这些装备只在明显过剩时释放产能，不生成增产 flag。

| 装备 key | 说明 |
| --- | --- |
| `artillery_equipment` | 非自行火炮 |
| `anti_tank_equipment` | 非自行反坦克炮 |
| `anti_air_equipment` | 非自行防空炮 |

### 不属于双模式调产状态机

| 装备 key | 当前状态 |
| --- | --- |
| `motorized_equipment` | 已移出陆军双模式调产体系；`JAP_rework_ai_land_production_v2.txt` 中仍有旧式赤字应急生产块，库存 `< 0` 启动、`> 2500` 停止 |
| `train_equipment` | 不属于陆军双模式调产体系；v2 文件中仍有旧式赤字应急生产块，库存 `< 0` 启动、`> 500` 停止 |

卡车、火车、补给、铁路、后勤类特殊装备后续应单独设计，不要默认套用 high_demand / low_demand 状态机。

## 装备调产状态机

`common/scripted_triggers/JAP_ai_land_production_scripted_triggers.txt`

常规装备 trigger 命名：

| trigger | 含义 |
| --- | --- |
| `JAP_ai_land_production_<equipment>_should_start_increase` | 应进入增产 |
| `JAP_ai_land_production_<equipment>_should_stop_increase` | 应退出增产 |
| `JAP_ai_land_production_<equipment>_should_start_decline` | 应进入减产 |
| `JAP_ai_land_production_<equipment>_should_stop_decline` | 应退出减产 |

只减产装备只有 `should_start_decline` 和 `should_stop_decline`。

`common/scripted_effects/JAP_equipment_scripted_effects.txt`

`JAP_ai_land_production_update_equipment_flags` 的顺序：

1. 先维护全局 `JAP_ai_land_production_replenishment_mode`。
2. 对每个装备，已有增产 flag 时先判断是否停止增产。
3. 已有减产 flag 时先判断是否停止减产。
4. 清除旧 flag 后，同轮允许重新进入增产或减产。
5. 常规装备同一时间只能是增产、减产、无 flag 三种状态之一。
6. 只减产装备只维护 decline flag。

装备 flag 命名：

| flag | 含义 |
| --- | --- |
| `JAP_ai_land_production_<equipment>_increase` | 该装备当前进入增产 |
| `JAP_ai_land_production_<equipment>_decline` | 该装备当前进入减产 |

## 产线 AI strategy

`common/ai_strategy/JAP_rework_ai_land_production_v2.txt`

该文件消费装备调产 flag，实际改变 AI 产线倾向。旧 `common/ai_strategy/JAP_rework_ai_land_production.txt` 当前没有未注释 strategy 块，只作为旧方案参考，不要继续往里新增逻辑。

主要块类型：

| 块 | 作用 |
| --- | --- |
| `<equipment>_baseline` | 常驻保底，通常需要 `num_of_military_factories > 200` |
| `<equipment>_increase_100_299` | 军工 `101-299` 时的增产策略 |
| `<equipment>_increase_300_699` | 军工 `300-699` 时的增产策略 |
| `<equipment>_increase_700_plus` | 军工 `700+` 时的增产策略 |
| `<equipment>_decline` | 减产策略 |

常用策略类型：

| ai_strategy type | 用途 |
| --- | --- |
| `equipment_production_min_factories_archetype` | 最低工厂数，主要用于 baseline 和增产保底 |
| `equipment_variant_production_factor` | 百分比修正，主要用于增产加权和减产 |

注意点：

- 当前 v2 的 `value` 使用固定数字，不直接读取变量。
- 中坦和中型两栖坦克在 `LUNATIC` 及以上有减半分支。
- 现代坦克、现代坦歼、现代自火、现代自防空 baseline 需要 `JAP_ai_land_production_modern_tank_template_created`。
- `operations_equipment_management_JAP_motorized_equipment_increase` 和 `operations_equipment_management_JAP_train_equipment_increase` 是遗留赤字应急块，不属于双模式 flag 状态机。

## 编制阶段和训练抑制

### 阶段 trigger

`common/scripted_triggers/JAP_rework_scripted_triggers.txt`

| trigger | 含义 |
| --- | --- |
| `JAP_ai_template_stage_opening_infantry` | 未创建试验装甲、正式装甲、陆巡、现代坦克、现代陆巡 |
| `JAP_ai_template_stage_experimental_armor` | 已创建试验步坦，未进入正式装甲及之后 |
| `JAP_ai_template_stage_regular_armor_easy` | 正式装甲阶段，难度 `EASY` |
| `JAP_ai_template_stage_regular_armor_normal` | 正式装甲阶段，难度 `NORMAL` |
| `JAP_ai_template_stage_regular_armor_hard` | 正式装甲阶段，难度 `HARD` |
| `JAP_ai_template_stage_regular_armor_lunatic` | 正式装甲阶段，难度 `LUNATIC` |
| `JAP_ai_template_stage_regular_armor_extra` | 正式装甲阶段，难度 `EXTRA` 或 `PHANTASM` |
| `JAP_ai_template_stage_land_cruiser` | 已创建陆巡，未进入现代坦克 |
| `JAP_ai_template_stage_modern_tank` | 已创建普通现代机坦或现代陆巡，未创建现代陆巡 |
| `JAP_ai_template_stage_modern_land_cruiser` | 已创建陆巡海陆现代机坦 |

### 阶段 flag

`common/decisions/JAP_rework_ai_decision.txt`

| flag | 设置时机 | 用途 |
| --- | --- | --- |
| `JAP_ai_template_experimental_armor_created` | 试验步坦师创建后 | 进入试验装甲阶段 |
| `JAP_ai_template_regular_armor_created` | 任一正式装甲编制创建后 | 进入正式装甲阶段 |
| `JAP_ai_template_land_cruiser_created` | 陆巡两栖重机坦师创建后 | 进入陆巡阶段 |
| `JAP_ai_land_production_modern_tank_template_created` | 普通现代机坦或现代陆巡创建后 | 现代装甲产线保底与现代坦克阶段 |
| `JAP_ai_template_modern_land_cruiser_created` | 陆巡海陆现代机坦师创建后 | 进入现代陆巡阶段 |

### 编制装备短缺抑制

高需求装备抑制 trigger：

- `JAP_ai_template_<equipment>_should_start_equipment_suppression`
- `JAP_ai_template_<equipment>_should_stop_equipment_suppression`

编制级抑制 trigger：

- `JAP_ai_template_<role>_should_start_equipment_suppression`
- `JAP_ai_template_<role>_should_stop_equipment_suppression`

编制级 start 通常是任一相关 high_demand 装备短缺即启动；stop 通常是所有相关 high_demand 装备恢复后才停止。

`JAP_ai_template_update_training_suppression_flags` 同时维护两类 flag：

| flag | 来源 | 说明 |
| --- | --- | --- |
| `JAP_ai_template_<role>_phase_suppressed` | 阶段替换 | 例如现代坦克出现后压制旧机械化编制 |
| `JAP_ai_template_<role>_equipment_suppressed` | 装备短缺 | 仅战争中设置，和平或恢复到停止阈值后清除 |

### 编制训练 AI strategy

`common/ai_strategy/JAP_rework_ai_template_v2.txt`

结构：

1. 前半部分是阶段正向块，只写非负 `role_ratio`。
2. 后半部分是抑制块，用等额负 `role_ratio` 抵消当前阶段已有正向倾向。

维护原则：

- `role_ratio value = 0` 不会覆盖已有正向倾向，不能当作抑制。
- 抑制块必须只在当前阶段确实存在对应正向值时启用。
- 负值必须等额抵消，不能超过当前阶段正向值，避免总倾向变成负数。
- 同一 role 在不同阶段正向值不同，应拆不同抑制块。
- `ai_wanted_divisions_factor` 独立于 `role_ratio`，用于提高总扩军欲望；本项目用难度基础值加装备充足 flag 的方式叠加。

扩军欲望层：

- `JAP_ai_land_production_loop_active` 作为生效门闩，避免编制策略早于 AI 装备循环启动。
- 基础 `ai_wanted_divisions_factor` 按精确难度递增：EASY 不写、NORMAL `20`、HARD `40`、LUNATIC `60`、EXTRA `90`、PHANTASM `120`。
- `JAP_ai_template_expansion_desire_active` 额外提供 `ai_wanted_divisions_factor = 100`。
- 该 flag 在 45 天循环的陆空装备包发放后更新；任一有效非步兵主装备的现役填充率 `> 1.50` 时开启，所有有效项回到 `<= 1.20` 时关闭。
- 现役填充率只读 `num_equipment_in_armies_k / (num_target_equipment_in_armies_k + 0.01)`，不读取库存盈余；无设计、难度不启用或目标为 `0` 的装备不参与判定。

当前正向倾向速查：

| 阶段 | role_ratio |
| --- | --- |
| 开局步兵 | `JAP_basic_infantry 100`、`JAP_infantry 100` |
| 试验装甲 | `JAP_basic_infantry 100`、`JAP_infantry 100`、`JAP_experimental_infantry_tank 30` |
| 正式装甲 EASY | `JAP_infantry 50`、`JAP_infantry_tank 100`、`JAP_special_infantry_tank 50` |
| 正式装甲 NORMAL | `JAP_infantry 50`、`JAP_special_infantry_tank 50`、`JAP_mechanized_tank 100` |
| 正式装甲 HARD | NORMAL + `JAP_amphibious_mechanized 150` |
| 正式装甲 LUNATIC / EXTRA / PHANTASM | HARD + `JAP_mechanized_heavy_tank 50`、`JAP_heavy_amphibious_mechanized 100` |
| 陆巡 | `JAP_infantry 50`、`JAP_special_infantry_tank 50`、`JAP_mechanized_tank 100`、`JAP_amphibious_mechanized 150`、`JAP_land_crushier 200` |
| 现代坦克 | `JAP_infantry 50`、`JAP_special_infantry_tank 50`、`JAP_marine_modern_mech_tank 200` |
| 现代陆巡 | `JAP_infantry 50`、`JAP_special_infantry_tank 50`、`JAP_lc_marine_modern_mech_tank 200` |

## 调试入口

### 动态变量读取

`common/decisions/JAP_rework_debug_decisions.txt`

| 决议 | 用途 |
| --- | --- |
| `JAP_debug_infantry_equipment_dynamic_variables` | 在当前国家读取步兵装备库存、现役、目标动态变量 |
| `JAP_debug_fra_infantry_equipment_dynamic_variables` | 在法国头上读取同组变量，用于确认 ROOT 作用域 |
| `JAP_debug_motorized_equipment_stockpile` | 读取卡车库存变量 |
| `JAP_debug_grant_50k_infantry_equipment` | 发放 `50,000` 件 `infantry_equipment_0` 用于压测库存判断 |

### stockpile_ratio 区间

`common/scripted_triggers/JAP_rework_debug_scripted_triggers.txt`

当前只覆盖 `infantry_equipment`，区间：

| 区间 trigger | 对应显示 |
| --- | --- |
| `JAP_debug_stockpile_ratio_infantry_equipment_lt_025` | `< 0.25` |
| `JAP_debug_stockpile_ratio_infantry_equipment_025_050` | `0.25-0.50` |
| `JAP_debug_stockpile_ratio_infantry_equipment_050_065` | `0.50-0.65` |
| `JAP_debug_stockpile_ratio_infantry_equipment_065_075` | `0.65-0.75` |
| `JAP_debug_stockpile_ratio_infantry_equipment_075_100` | `0.75-1.00` |
| `JAP_debug_stockpile_ratio_infantry_equipment_100_125` | `1.00-1.25` |
| `JAP_debug_stockpile_ratio_infantry_equipment_125_150` | `1.25-1.50` |
| `JAP_debug_stockpile_ratio_infantry_equipment_150_200` | `1.50-2.00` |
| `JAP_debug_stockpile_ratio_infantry_equipment_gte_200` | `>= 2.00` |

新增其他装备 debug 时，需要同步改：

- `common/scripted_triggers/JAP_rework_debug_scripted_triggers.txt`
- `common/decisions/JAP_rework_debug_decisions.txt`
- `localisation/simp_chinese/JAP_debug_l_simp_chinese.yml`

## 常见维护流程

### 调整补装备模式阈值

1. 改 `history/countries/JAP - Japan.txt` 中当前值、`*_peace_*`、`*_war_*`。
2. 检查 `common/on_actions/JAP_rework_focus_on_actions.txt` 是否仍复制同名变量。
3. 同步本文“补装备模式现役填充率阈值”表。
4. 不需要改 AI strategy，除非产线数值也要变。

### 调整扩军模式库存率阈值

1. 在 `JAP_ai_land_production_<equipment>_should_*` 中找无补装备模式 flag 的 `stockpile_ratio` 分支。
2. 按战争/和平与 high_demand / low_demand 改固定 `ratio`。
3. 同步本文“扩军模式库存率阈值”表。
4. 如果是测试库存口径，优先扩展 debug 区间，而不是盲目调大阈值。

### 调整某装备产线强度

1. 在本文装备分层和 `Reference/ai_land_production_difficulty_equipment_reference.md` 中确认装备定位。
2. 改 `JAP_rework_ai_land_production_v2.txt` 中对应 baseline、increase、decline。
3. 如果触发时机也变，改 `JAP_ai_land_production_scripted_triggers.txt`。
4. 如果 flag 状态机也变，改 `JAP_equipment_scripted_effects.txt` 的 `JAP_ai_land_production_update_equipment_flags`。

### 新增纳入调产体系的装备

1. 确认装备已经出现在 `Reference/template_JAP_equipment_requirements.md`。
2. 在 `Reference/ai_land_production_difficulty_equipment_reference.md` 记录最低出现难度和来源编制。
3. 决定分类：high_demand、允许增减产 low_demand、只减产 low_demand、或暂不纳入。
4. 在 `JAP_ai_land_production_scripted_triggers.txt` 添加调产 trigger。
5. 在 `JAP_equipment_scripted_effects.txt` 添加 flag 状态机。
6. 在 `JAP_rework_ai_land_production_v2.txt` 添加 baseline / increase / decline 策略块。
7. 如果是 high_demand，还要补有效 high_demand trigger、装备短缺 trigger、编制级抑制 trigger、45 天循环 flag 维护，以及 template v2 的等额负倾向。

### 修改 AI 编制训练倾向

1. 先看 `common/ai_templates/templates_JAP.txt` 确认 role key。
2. 看 `Reference/template_JAP_equipment_requirements.md` 确认装备需求。
3. 看 `JAP_rework_scripted_triggers.txt` 确认该编制在哪些阶段出现。
4. 改 `JAP_rework_ai_template_v2.txt` 中阶段正向 `role_ratio`。
5. 如果正向值变化，同步检查抑制块中的等额负值。
6. 如果依赖的 high_demand 装备变化，同步更新编制级装备短缺抑制 trigger。

### 新增 AI 编制阶段

1. 在创建编制的决议或 scripted effect 中设置新的阶段 flag。
2. 在 `JAP_rework_scripted_triggers.txt` 新增阶段 trigger，并保证阶段互斥。
3. 在 `JAP_rework_ai_template_v2.txt` 新增阶段正向 role_ratio 块。
4. 检查旧阶段是否需要阶段替换抑制 flag。
5. 对所有新增正向 role_ratio 写对应装备短缺抑制块，或明确它们不需要战争训练抑制。

## 维护注意事项

- `JAP_rework_ai_land_production_v2.txt` 和 `JAP_rework_ai_template_v2.txt` 是当前落地文件；旧 land production / template 文件已经整体注释，仅作参考。
- `common/ai_strategy/Jap_rework_ai_production.txt` 里的文件名注释仍指向旧文件，不作为加载关系或当前入口判断依据。
- 现代装甲装备的常驻保底和有效 high_demand 门槛要特别看 `JAP_ai_land_production_modern_tank_template_created`。
- `PHANTASM` 当前暂时等同 `EXTRA`；如果后续新增专属编制，需要同步难度装备参考。
- `motorized_equipment`、`train_equipment` 现在只有旧式赤字应急块，不要误纳入 `JAP_ai_land_production_<equipment>_increase/decline` 状态机。
- 额外装备发放系统另见 `Reference/ai_extra_equipment_maintenance_reference.md`，不要把额外发放数量和 AI 产线倾向混成同一套参数。

## 快速检查命令

```powershell
rg -n "JAP_ai_land_production_(loop_start|equipment_cycle_mission|template_suppression_cycle_mission)" common/decisions
rg -n "JAP_ai_land_production_high_demand|JAP_ai_land_production_low_demand|JAP_ai_land_production_template_suppression" history/countries common/on_actions
rg -n "^JAP_ai_land_production_.*(should|is_effective)" common/scripted_triggers/JAP_ai_land_production_scripted_triggers.txt
rg -n "JAP_ai_land_production_replenishment_mode|JAP_ai_land_production_.*_(increase|decline)" common/scripted_effects common/ai_strategy
rg -n "^JAP_ai_template_stage_|^JAP_ai_template_should_suppress_" common/scripted_triggers/JAP_rework_scripted_triggers.txt
rg -n "role_ratio|value = -" common/ai_strategy/JAP_rework_ai_template_v2.txt
rg -n "JAP_debug_stockpile_ratio|JAP_debug_infantry_equipment_dynamic_variables" common/decisions common/scripted_triggers localisation/simp_chinese
```

重点看：

- 当前阈值、peace 阈值、war 阈值是否成组同步。
- 新装备是否同时有 trigger、effect flag 状态机和 strategy 消费。
- 只减产装备是否没有误加增产 trigger。
- 旧 land production / template 文件是否仍没有未注释 strategy 块。
- `JAP_ai_land_production_replenishment_mode` 是否只有预期消费者。

## 遗留检查点

- 实测校准扩军模式 `stockpile_ratio` 阈值，优先补中坦、机械化、两栖机械化等 high_demand 装备的 debug 区间。
- 梳理哪些特殊编制需要创建后才能启用相关装备调产；现代坦克已经有模板创建 flag，其它特殊装备仍需按实际测试决定。
- 验证 v2 编制策略、产线 v2 和剩余旧生产策略之间是否存在重复 key、冲突 flag 或加载顺序问题。
- 决定是否把旧 `JAP_rework_ai_land_production.txt`、`JAP_rework_ai_template.txt` 的注释归档到单独历史文件，避免当前目录继续带大型旧草稿。
- 重新整理 `common/ai_strategy/Jap_rework_ai_production.txt` 里的旧文件名注释，避免以后误导入口判断。

## 历史口径摘要

- 2026-05-20 前后的旧方案曾把 AI 练兵相关 `0.65` 和撤产相关 `1.25` 直接解释为本系统口径，这已经被双模式方案替代。
- 当前确认：`num_target_equipment_in_armies_k` 与 `num_equipment_in_armies_k` 不计训练中部队；训练队列会领取库存，因此扩军阶段用 `stockpile_ratio`，补装备阶段用现役填充率。
- 旧 `Rance_critical_*` / `Rance_non_critical_*` 变量保留是为了兼容旧参考和清理过渡，不是当前 v2 调产的主要阈值。
- v2 产线策略选择固定 `value` 分支，因为 AI strategy 的 `value` 不适合直接读取变量。
- v2 编制训练抑制选择等额负 `role_ratio`，因为 `role_ratio value = 0` 不能覆盖已有正向倾向。

## 说明书：理解、调参、移植

本节写给后来的维护者和想把这套思路移到别的 MOD 的人。核心不是日本专属的装备表，而是“扩军状态”和“补装备状态”的切换，以及两种状态下采用不同生产策略。

### 1. 系统一句话

这套系统让 AI 平时按库存率支持扩军，发现现役主战装备短缺后切进补装备模式，暂停或压低会继续放大缺口的训练/进攻倾向，并把产线策略转向补齐现役装备。

### 2. 最小结构图

| 模块 | 负责什么 | 日本实现 |
| --- | --- | --- |
| 输入数据 | 军工数、库存、现役装备、目标装备、难度、装备设计、编制阶段 | 动态变量 + 难度 trigger + 设计 flag + 阶段 flag |
| 周期循环 | 固定周期更新状态，不让 AI strategy 每天复杂判断 | 15 天装备循环、45 天编制抑制循环、每月阈值切换 |
| 全局模式 flag | 判断当前是扩军还是补装备 | `JAP_ai_land_production_replenishment_mode` |
| 装备状态 flag | 判断某装备该增产、减产还是维持 | `JAP_ai_land_production_<equipment>_increase/decline` |
| 训练抑制 flag | 战时装备短缺时暂停对应编制训练 | `JAP_ai_template_<role>_equipment_suppressed` |
| 阶段抑制 flag | 更高级编制出现后压低旧编制 | `JAP_ai_template_<role>_phase_suppressed` |
| 产线消费 | 把装备状态 flag 转成 AI 生产倾向 | `JAP_rework_ai_land_production_v2.txt` |
| 编制消费 | 把阶段和抑制 flag 转成 AI 训练倾向 | `JAP_rework_ai_template_v2.txt` |

最小可用版本只需要前三层：输入数据、周期循环、全局模式 flag。完整版本再加逐装备状态机、编制训练抑制和 debug。

### 3. 两种状态怎么理解

扩军状态回答的问题是：AI 还在扩编，库存相对已经使用的装备够不够继续撑训练队列？

补装备状态回答的问题是：现役部队的目标装备是否已经补回来了？

| 状态 | 阈值本质 | 判断口径 | 适合驱动什么 |
| --- | --- | --- | --- |
| 扩军 | 库存安全垫 / 扩编余量 | `stockpile_ratio`，库存相对已使用装备的比例 | 是否继续增产、是否减产过剩、是否允许 AI 持续扩编 |
| 补装备 | 现役满编率 / 缺装恢复线 | 现役填充率，库存折算后加现役装备再除以现役目标装备 | 是否补短板、是否退出危机、是否暂停训练和推进 |

这里最重要的是不要把两套数值当成同一种“装备率”。扩军阈值里的 `0.08`、`0.12`、`0.25` 之类，是库存缓冲比例，低于它说明扩编余量变薄；补装备阈值里的 `0.90`、`1.00`、`1.05` 之类，是现役部队目标装备满足率，低于它说明前线师本身已经缺装。

现役填充率的可抄写公式：

```txt
现役填充率 = (num_equipment@装备 / 1000 + num_equipment_in_armies_k@装备) / (num_target_equipment_in_armies_k@装备 + 0.01)
```

判断 `infantry_equipment` 低于补装备启动线时，写法是：

```txt
set_temp_variable = { r_ratio = num_equipment@infantry_equipment }
divide_temp_variable = { r_ratio = 1000 }
add_to_temp_variable = { r_ratio = num_equipment_in_armies_k@infantry_equipment }
set_temp_variable = { r_denom = num_target_equipment_in_armies_k@infantry_equipment }
add_to_temp_variable = { r_denom = 0.01 }
divide_temp_variable = { r_ratio = r_denom }

check_variable = { r_ratio < <PREFIX>_ai_land_production_template_suppression_start }
```

这里的 `<PREFIX>` 是文档占位符，移植时必须替换成目标 MOD 的真实前缀；不要把尖括号原样写进脚本。

为什么要分开：训练中的部队会吃库存，但不计入 `num_equipment_in_armies_k` / `num_target_equipment_in_armies_k`。只看现役填充率会低估扩军消耗；只看库存率又会在现役已经缺装时反应不够直接。

### 4. 调参时先判断症状

| 症状 | 优先看哪里 | 常见改法 |
| --- | --- | --- |
| AI 一直缺主战装备，但不进入补装备模式 | 有效 high_demand 门槛、训练抑制 start、补装备模式 start trigger | 放宽设计/阶段门槛，或提高 `template_suppression_start` |
| AI 进入补装备模式后很久不退出 | 训练抑制 stop、有效 high_demand 是否包含暂时不该生产的装备 | 降低 `template_suppression_stop`，或让未启用装备在 `is_effective_high_demand` 中返回 no |
| 扩军期某装备总是太少 | 扩军模式 `stockpile_ratio` 增产启动/终止、baseline、increase 档位 | 提高 baseline 或增产保底，或提高扩军增产启动阈值 |
| 扩军期某装备囤太多 | 扩军模式减产启动/终止、baseline、额外装备发放 | 降低 baseline，提高减产强度，或降低减产启动阈值 |
| 补装备期产线补得不够狠 | 补装备阈值、increase strategy 的 `value` | 提高增产百分比或增产保底；必要时提高 high_demand 启动阈值 |
| AI 继续训练导致缺口越滚越大 | 编制装备短缺抑制 trigger、template v2 负 `role_ratio` | 确认对应 role 有 `equipment_suppressed` flag，并且负值等额抵消正值 |
| AI 前线进攻把缺口扩大 | 前线 AI strategy 是否消费补装备模式 flag | 参考皇道派的 `JAP_kodoha_replenishment_mode_pause_fronts` 做局部停攻 |

调参顺序建议：

1. 先确认问题发生在扩军状态还是补装备状态。
2. 再确认问题是“触发太晚/太早”还是“触发后力度不够/过头”。
3. 触发问题改 trigger 或阈值；力度问题改 AI strategy 的 `value`。
4. 每次只改一组参数，并用 debug 决议观察库存率或现役填充率。

### 5. 参数方向速查

| 参数 | 调高会怎样 | 调低会怎样 |
| --- | --- | --- |
| 扩军增产启动库存率 | 更早增产，更容易囤货 | 更晚增产，更容易短缺 |
| 扩军增产终止库存率 | 增产持续更久 | 增产更早停 |
| 扩军减产启动库存率 | 更晚减产，库存更厚 | 更早减产，产能释放更快 |
| 扩军减产终止库存率 | 减产更早停 | 减产持续更久 |
| 补装备增产启动现役填充率 | 更早进入单装备增产 | 更晚增产 |
| 补装备增产终止现役填充率 | 补得更满才停 | 稍微恢复就停 |
| 训练抑制启动现役填充率 | 更早暂停训练，也更早进入全局补装备模式 | 更晚暂停训练 |
| 训练抑制停止现役填充率 | 恢复更充分才解除抑制 | 更早恢复训练 |
| baseline 工厂数 | 平时更稳、更占产能 | 平时更省产能、更依赖增产状态 |
| increase 工厂数/百分比 | 短缺响应更强 | 短缺响应更温和 |
| decline 百分比 | 过剩时释放产能更快 | 过剩时保留更多产线 |

### 6. 完整复刻步骤

完整复刻适合大型 MOD，尤其是有自定义难度、自定义装备、自定义 AI 编制阶段的项目。

1. 列装备表

先从模板统计装备需求。把装备分成：

- high_demand：主战核心装备，短缺会影响训练和补员。
- low_demand：辅助装备，需要调产但不决定全局危机。
- decline_only：只想在过剩时撤产，不想主动增产。
- out_of_system：卡车、火车、补给类，另做后勤逻辑。

2. 定义两套阈值

扩军模式用 `stockpile_ratio`。补装备模式用现役填充率。不要一开始追求很精细，先给每层装备一套统一阈值，再按实测拆个别装备。

可直接照搬的第一版参数：

| 参数 | high_demand | low_demand |
| --- | ---: | ---: |
| 扩军增产启动 | 0.08-0.12 | 0.06-0.08 |
| 扩军增产终止 | 0.18-0.25 | 0.15-0.20 |
| 扩军减产启动 | 0.25-0.30 | 0.35-0.40 |
| 扩军减产终止 | 0.18-0.22 | 0.25-0.30 |
| 补装备增产启动 | 1.00 | 0.85 |
| 补装备增产终止 | 1.05 | 1.00 |
| 补装备减产启动 | 1.15 | 1.10 |
| 补装备减产终止 | 1.05 | 1.00 |

这些不是魔法数值：扩军阈值在问库存缓冲还剩多少，补装备阈值在问现役目标装备是否补满。移植时先按这个范围跑通，再根据目标 MOD 的工业规模和模板装备成本调整。

3. 做全局补装备模式

为所有 high_demand 装备写“是否当前有效”的 trigger。进入补装备模式时，只看当前有效装备；退出补装备模式时，无效装备应被视为不阻塞退出。

最小落地结构：

以下代码中的 `<PREFIX>` 是占位符，移植时必须统一替换成目标 MOD 前缀。

```txt
<PREFIX>_ai_land_production_infantry_equipment_is_effective_high_demand = {
    always = yes
}

<PREFIX>_ai_land_production_should_start_replenishment_mode = {
    OR = {
        AND = {
            <PREFIX>_ai_land_production_infantry_equipment_is_effective_high_demand = yes
            <PREFIX>_ai_template_infantry_equipment_should_start_equipment_suppression = yes
        }
    }
}

<PREFIX>_ai_land_production_should_stop_replenishment_mode = {
    AND = {
        OR = {
            <PREFIX>_ai_land_production_infantry_equipment_is_effective_high_demand = no
            <PREFIX>_ai_template_infantry_equipment_should_stop_equipment_suppression = yes
        }
    }
}
```

多装备时，在 start 的 `OR` 里继续加 `AND`；在 stop 的 `AND` 里继续加 `OR`。这个结构能保证“任一有效主战装备缺装则进入，全体有效主战装备恢复才退出”。

4. 做逐装备状态机

每个常规装备维护两个 flag：

```txt
<prefix>_<equipment>_increase
<prefix>_<equipment>_decline
```

同一装备同一时间只允许一个 flag 生效。先清旧状态，再决定是否进入新状态。

5. 做 AI strategy 消费

把 strategy 拆成三类：

- baseline：平时保底。
- increase：看到 `_increase` flag 后提高产线。
- decline：看到 `_decline` flag 后压低产线。

不要指望 `value` 直接读变量；如果目标游戏版本不支持，优先用固定档位。

6. 做编制训练抑制

为每个主战编制列出关键 high_demand 装备。任一关键装备短缺就设置 `equipment_suppressed`，全部恢复后清除。AI strategy 中用等额负 `role_ratio` 抵消该阶段正向训练倾向。

7. 做编制扩军欲望

在额外装备发放后检查非步兵主装备的现役填充率。任一有效项高于扩军启动阈值时设置扩军欲望 flag；全部有效项不高于停止阈值后清除。AI strategy 用 `ai_wanted_divisions_factor` 提高总训练需求，不改变各模板 `role_ratio`。

8. 做阶段替换抑制

如果有“中坦阶段 -> 陆巡阶段 -> 现代坦克阶段”这类编制升级，给阶段写互斥 trigger。旧编制仍在当前阶段正向表里出现时，再用 `phase_suppressed` 抵消。

9. 做 debug

至少准备三个 debug：

- 读库存、现役、目标动态变量。
- 显示关键装备 `stockpile_ratio` 区间。
- 发放一批测试装备，确认进入/退出模式是否正确。

### 7. 轻量复刻方案

轻量复刻适合只想借用核心思想、不想整套搬日本系统的 MOD。

最低配置：

| 组件 | 是否必须 | 说明 |
| --- | --- | --- |
| 全局补装备模式 flag | 必须 | 这是核心 |
| high_demand 装备列表 | 必须 | 只列步枪、主坦克、机械化等少数关键装备即可 |
| 周期 mission | 必须 | 30 天或 45 天都可以；不必拆 15 天和 45 天 |
| 逐装备 increase/decline flag | 可选 | 小 MOD 可以直接让 AI strategy 在 enable 中判断短缺 |
| 编制训练抑制 | 推荐 | 没有它，AI 可能一边补装一边继续训练扩大缺口 |
| 阶段替换抑制 | 可选 | 没复杂编制升级时可以不要 |
| 和平/战争双阈值 | 可选 | 初版可以共用一套阈值 |

轻量版核心流程：

1. 每 30 或 45 天检查 high_demand 装备。
2. 任一有效 high_demand 现役填充率低于启动线，设置 `<prefix>_replenishment_mode`。
3. 全部有效 high_demand 高于停止线，清除 `<prefix>_replenishment_mode`。
4. 没有补装备模式时，AI strategy 用库存率判断是否增产或减产。
5. 有补装备模式时，AI strategy 用现役填充率给 high_demand 更高产线优先级。
6. 有补装备模式时，降低装甲/机械化等耗装编制训练倾向。

轻量版可以不写逐装备状态机，直接在 AI strategy 的 enable 中分模式判断：

```txt
my_mod_infantry_equipment_replenishment_increase = {
    enable = {
        has_country_flag = my_mod_replenishment_mode
        set_temp_variable = { r_ratio = num_equipment@infantry_equipment }
        divide_temp_variable = { r_ratio = 1000 }
        add_to_temp_variable = { r_ratio = num_equipment_in_armies_k@infantry_equipment }
        set_temp_variable = { r_denom = num_target_equipment_in_armies_k@infantry_equipment }
        add_to_temp_variable = { r_denom = 0.01 }
        divide_temp_variable = { r_ratio = r_denom }
        check_variable = { r_ratio < my_mod_high_demand_start_increase }
    }
    ai_strategy = {
        type = equipment_production_min_factories_archetype
        id = infantry_equipment
        value = 10
    }
}

my_mod_infantry_equipment_expansion_increase = {
    enable = {
        NOT = { has_country_flag = my_mod_replenishment_mode }
        stockpile_ratio = {
            archetype = infantry_equipment
            ratio < 0.10
        }
    }
    ai_strategy = {
        type = equipment_production_min_factories_archetype
        id = infantry_equipment
        value = 5
    }
}
```

这种写法少了持久 flag 的滞后/防抖，但文件更少，适合先验证思路。等确认有效后，再升级成日本这套“trigger -> effect flag -> strategy 消费”的稳定版。

### 8. 移植时最容易踩的坑

- 不要把日本装备 key 原样搬走；先统计目标 MOD 的模板真实 `need = {}`。
- 不要让尚未解锁、尚未设计、当前难度不会生产的装备阻塞补装备模式退出。
- 不要把 `stockpile_ratio` 当现役填充率；它们回答的问题不同。
- 不要用 `role_ratio value = 0` 试图压制训练；需要不写正值，或用等额负值抵消。
- 不要让补装备模式只影响产线、不影响训练；否则 AI 可能边补边继续制造缺口。
- 不要把额外装备发放数量当作生产系统参数；那是另一套补偿系统。
- 不要一开始就给所有装备做完整状态机；先把 high_demand 跑通，再扩 low_demand。

### 9. 推荐移植命名

把 `JAP` 和 `Rance` 换成目标 MOD 的统一前缀，保留语义结构：

| 日本命名 | 移植模板 |
| --- | --- |
| `JAP_ai_land_production_replenishment_mode` | `<PREFIX>_ai_land_production_replenishment_mode` |
| `JAP_ai_land_production_<equipment>_should_start_increase` | `<PREFIX>_ai_land_production_<equipment>_should_start_increase` |
| `JAP_ai_land_production_<equipment>_increase` | `<PREFIX>_ai_land_production_<equipment>_increase` |
| `JAP_ai_template_<role>_equipment_suppressed` | `<PREFIX>_ai_template_<role>_equipment_suppressed` |
| `JAP_ai_template_stage_<stage>` | `<PREFIX>_ai_template_stage_<stage>` |

命名里保留 `increase` / `decline` / `replenishment_mode` / `equipment_suppressed` 这些语义词，后续 debug 和跨文件搜索会省很多时间。
