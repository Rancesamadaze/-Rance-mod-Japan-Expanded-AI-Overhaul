# AI 编制决议维护参考

## 维护定位

- 记录日本 AI 主力编制创建决议、难度编制分配、保底日期和装备判定口径。
- 难度与路线判定可交叉参考 `Reference/route_difficulty_scripted_trigger.md`。
- 编制装备需求可交叉参考 `Reference/template_JAP_equipment_requirements.md` 与 `Reference/ai_land_production_difficulty_equipment_reference.md`。

## 开发归档

> 归档时间：2026-05-22。以下内容从 `CHANGELOG` 迁入 `Reference`，用于保留设计背景、调参依据和已完成/待办记录。日常维护时可在本文前部继续补充新的维护索引。
### 来源：`CHANGELOG/ai_template_decision_rework_plan.md`

### AI 编制决议重置开发方案

> 本文件记录日本 AI 编制创建决议的重置方案。当前是开发规划，不代表 `common/ai_strategy/` 生产策略已经同步调整。

#### 目标

- 每种编制由独立 AI 决议控制。
- 难度只决定该编制是否应当在当前难度出现。
- 具体解锁需要满足时间条件，或满足该编制主要装备已经创建的复合脚本条件。
- 创建模板与发放起始部队合并在同一个编制决议中。

#### 难度编制分配

| 难度 | 编制分配 |
| --- | --- |
| `EASY` | 日本步坦师、日本特种步坦师 |
| `NORMAL` | 日本特种步坦师、日本机坦师、日本海陆现代机坦师 |
| `HARD` | 日本特种步坦师、日本机坦师、日本两栖机坦师、日本海陆现代机坦师 |
| `LUNATIC` | 日本特种步坦师、日本机坦师、日本两栖机坦师、日本海陆现代机坦师、日本重型机坦师、日本两栖重机坦师 |
| `EXTRA` | 日本特种步坦师、日本机坦师、日本两栖机坦师、日本海陆现代机坦师、日本重型机坦师、日本两栖重机坦师、日本陆巡两栖重机坦师、日本陆巡海陆现代机坦师 |
| `PHANTASM` | 日本特种步坦师、日本机坦师、日本两栖机坦师、日本海陆现代机坦师、日本重型机坦师、日本两栖重机坦师、日本陆巡两栖重机坦师、日本陆巡海陆现代机坦师 |

`PHANTASM` 当前包含 `EXTRA` 的全部编制；未来可能加入专属特色编制。

#### 模板与起始部队效果

| 编制 | 创建模板效果 | 起始部队效果 |
| --- | --- | --- |
| 日本步坦师 | `JAP_create_infantry_tank_template` | `JAP_start_infantry_tanks` |
| 日本特种步坦师 | `JAP_create_special_infantry_tank_template` | `JAP_start_special_infantry_tanks` |
| 日本机坦师 | `JAP_create_mechanized_tank_template` | `JAP_start_mechanized_tanks` |
| 日本两栖机坦师 | `JAP_create_amphibious_mechanized_template` | `JAP_start_amphibious_mechanized_tanks` |
| 日本重型机坦师 | `JAP_create_mechanized_heavy_tank_template` | `JAP_start_heavy_mechanized_tanks` |
| 日本两栖重机坦师 | `JAP_create_heavy_amphibious_mechanized_template` | `JAP_start_heavy_amphibious_mechanized_tanks` |
| 日本陆巡两栖重机坦师 | `JAP_create_land_crushier_template` | `JAP_start_land_crushier` |
| 日本海陆现代机坦师 | `JAP_create_marine_modern_mechanized_tank_template` | `JAP_start_marine_modern_mechanized_tanks` |
| 日本陆巡海陆现代机坦师 | `JAP_create_land_cruiser_marine_modern_mechanized_tank_template` | `JAP_start_land_cruiser_marine_modern_mechanized_tanks` |

#### 装备判定要求

每个编制的装备条件统一包含 `JAP_has_cr_medium_tank_flame_chassis_design`。

| 编制 | 装备设计判定 |
| --- | --- |
| 日本步坦师 | `JAP_has_cr_medium_tank_chassis_design`、`JAP_has_cr_medium_tank_destroyer_chassis_design`、`JAP_has_cr_medium_tank_artillery_chassis_design`、`JAP_has_cr_medium_tank_aa_chassis_design`、`JAP_has_cr_heavy_tank_destroyer_chassis_design`、`JAP_has_cr_medium_tank_flame_chassis_design` |
| 日本特种步坦师 | `JAP_has_cr_medium_tank_chassis_design`、`JAP_has_cr_medium_tank_destroyer_chassis_design`、`JAP_has_cr_medium_tank_artillery_chassis_design`、`JAP_has_cr_medium_tank_aa_chassis_design`、`JAP_has_cr_heavy_tank_destroyer_chassis_design`、`JAP_has_cr_heavy_tank_aa_chassis_design`、`JAP_has_cr_medium_tank_flame_chassis_design` |
| 日本机坦师 | `JAP_has_cr_mechanized_equipment_design`、`JAP_has_cr_medium_tank_chassis_design`、`JAP_has_cr_medium_tank_destroyer_chassis_design`、`JAP_has_cr_medium_tank_artillery_chassis_design`、`JAP_has_cr_medium_tank_aa_chassis_design`、`JAP_has_cr_heavy_tank_destroyer_chassis_design`、`JAP_has_cr_heavy_tank_aa_chassis_design`、`JAP_has_cr_medium_tank_flame_chassis_design` |
| 日本两栖机坦师 | `JAP_has_cr_amphibious_mechanized_equipment_design`、`JAP_has_cr_medium_tank_amphibious_chassis_design`、`JAP_has_cr_medium_tank_destroyer_chassis_design`、`JAP_has_cr_medium_tank_artillery_chassis_design`、`JAP_has_cr_medium_tank_aa_chassis_design`、`JAP_has_cr_heavy_tank_destroyer_chassis_design`、`JAP_has_cr_heavy_tank_aa_chassis_design`、`JAP_has_cr_medium_tank_flame_chassis_design` |
| 日本重型机坦师 | `JAP_has_cr_mechanized_equipment_design`、`JAP_has_cr_heavy_tank_chassis_design`、`JAP_has_cr_heavy_tank_destroyer_chassis_design`、`JAP_has_cr_heavy_tank_artillery_chassis_design`、`JAP_has_cr_heavy_tank_aa_chassis_design`、`JAP_has_cr_medium_tank_flame_chassis_design` |
| 日本两栖重机坦师 | `JAP_has_cr_amphibious_mechanized_equipment_design`、`JAP_has_cr_heavy_tank_amphibious_chassis_design`、`JAP_has_cr_heavy_tank_destroyer_chassis_design`、`JAP_has_cr_heavy_tank_artillery_chassis_design`、`JAP_has_cr_heavy_tank_aa_chassis_design`、`JAP_has_cr_medium_tank_flame_chassis_design` |
| 日本陆巡两栖重机坦师 | `JAP_has_cr_amphibious_mechanized_equipment_design`、`JAP_has_cr_heavy_tank_amphibious_chassis_design`、`JAP_has_cr_heavy_tank_destroyer_chassis_design`、`JAP_has_cr_heavy_tank_artillery_chassis_design`、`JAP_has_cr_heavy_tank_aa_chassis_design`、`JAP_has_cr_land_cruiser_chassis_design`、`JAP_has_cr_medium_tank_flame_chassis_design` |
| 日本海陆现代机坦师 | `JAP_has_cr_amphibious_mechanized_equipment_design`、`JAP_has_cr_modern_tank_chassis_design`、`JAP_has_cr_modern_tank_destroyer_chassis_design`、`JAP_has_cr_modern_tank_artillery_chassis_design`、`JAP_has_cr_modern_tank_aa_chassis_design`、`JAP_has_cr_medium_tank_flame_chassis_design` |
| 日本陆巡海陆现代机坦师 | `JAP_has_cr_amphibious_mechanized_equipment_design`、`JAP_has_cr_modern_tank_chassis_design`、`JAP_has_cr_modern_tank_destroyer_chassis_design`、`JAP_has_cr_modern_tank_artillery_chassis_design`、`JAP_has_cr_modern_tank_aa_chassis_design`、`JAP_has_cr_land_cruiser_chassis_design`、`JAP_has_cr_medium_tank_flame_chassis_design` |

推荐将每个编制所需装备设计整理为复合脚本条件，方便后续维护。

#### 保底日期梳理

日期计算规则：

- 先读取每个装备设计创建决议的保底日期。
- 同一个判定 flag 若可由多个装备创建效果设置，按最早能满足该判定的装备设计日期计算。
- 每个编制取全部所需装备判定中的最晚日期。
- 编制决议日期在最晚装备日期基础上增加 1 个月缓冲。

基础装备判定日期：

| 装备判定 | 当前对应保底日期 | 备注 |
| --- | --- | --- |
| `JAP_has_cr_medium_tank_chassis_design` | `1937.6.1` | `JAP_cr_basic_medium_tank_jap_97`；另有 `JAP_cr_improved_medium_tank_jap_97_kai` 可设置同一 flag，日期为 `1939.1.1` |
| `JAP_has_cr_medium_tank_destroyer_chassis_design` | `1938.6.1` | `JAP_cr_basic_medium_td_jap_ho_ni_1`；另有 `JAP_cr_improved_medium_td_jap_ho_ni_1_kai` 可设置同一 flag，日期为 `1939.1.1` |
| `JAP_has_cr_medium_tank_artillery_chassis_design` | `1938.6.1` | `JAP_cr_basic_medium_art_jap_type_1` |
| `JAP_has_cr_medium_tank_aa_chassis_design` | `1938.6.1` | `JAP_cr_basic_medium_aa_jap_type_1_kai` |
| `JAP_has_cr_medium_tank_amphibious_chassis_design` | `1938.6.1` | `JAP_cr_basic_amphibious_medium_tank_jap_97` |
| `JAP_has_cr_medium_tank_flame_chassis_design` | `1938.1.1` | `JAP_cr_basic_medium_flame_tank_jap_s_ki` |
| `JAP_has_cr_heavy_tank_chassis_design` | `1938.6.1` | `JAP_cr_basic_heavy_tank_jap_95` |
| `JAP_has_cr_heavy_tank_destroyer_chassis_design` | `1938.6.1` | `JAP_cr_basic_heavy_td_jap_type_3` |
| `JAP_has_cr_heavy_tank_artillery_chassis_design` | `1938.6.1` | `JAP_cr_basic_heavy_art_jap_type_1` |
| `JAP_has_cr_heavy_tank_aa_chassis_design` | `1938.6.1` | `JAP_cr_basic_heavy_aa_jap_type_1` |
| `JAP_has_cr_heavy_tank_amphibious_chassis_design` | `1938.6.1` | `JAP_cr_basic_amphibious_heavy_tank_jap_95` |
| `JAP_has_cr_mechanized_equipment_design` | `1938.6.1` | `JAP_cr_mechanized_equipment_1` |
| `JAP_has_cr_amphibious_mechanized_equipment_design` | `1938.6.1` | `JAP_cr_amphibious_mechanized_equipment_1` |
| `JAP_has_cr_land_cruiser_chassis_design` | `1940.6.1` | `JAP_cr_jap_land_cruiser_hoshiguma` |
| `JAP_has_cr_modern_tank_chassis_design` | `1943.6.1` | `JAP_cr_modern_tank_jap_type_61` |
| `JAP_has_cr_modern_tank_destroyer_chassis_design` | `1943.6.1` | `JAP_cr_modern_td_jap_type_61` |
| `JAP_has_cr_modern_tank_artillery_chassis_design` | `1943.6.1` | `JAP_cr_modern_art_jap_type_61` |
| `JAP_has_cr_modern_tank_aa_chassis_design` | `1943.6.1` | `JAP_cr_modern_aa_jap_type_61` |

编制决议建议日期：

| 编制 | 所需装备中的最晚保底日期 | 加 1 个月后的编制决议日期 | 备注 |
| --- | --- | --- | --- |
| 日本步坦师 | `1938.6.1` | `1938.7.1` | 常规线 |
| 日本特种步坦师 | `1938.6.1` | `1938.7.1` | 常规线 |
| 日本机坦师 | `1938.6.1` | `1938.7.1` | 常规线 |
| 日本两栖机坦师 | `1938.6.1` | `1938.7.1` | 常规线 |
| 日本重型机坦师 | `1938.6.1` | `1938.7.1` | 常规线 |
| 日本两栖重机坦师 | `1938.6.1` | `1938.7.1` | 常规线 |
| 日本陆巡两栖重机坦师 | `1940.6.1` | `1940.7.1` | 陆巡线 |
| 日本海陆现代机坦师 | `1943.6.1` | `1943.7.1` | 现代线；暂按现代坦歼同步现代线计算 |
| 日本陆巡海陆现代机坦师 | `1943.6.1` | `1943.7.1` | 陆巡 + 现代线；暂按现代坦歼同步现代线计算 |

#### 决议规则

日期规则：

- 每个装备设计判定脚本条件对应一个装备设计。
- 每个装备设计对应一条创建装备设计的决议。
- 创建装备设计的决议中存在保底日期。
- 每个编制决议的最晚日期，应晚于该编制所需全部装备设计的保底日期。
- 在上述最晚装备保底日期基础上，额外加入 1 个月缓冲期。

结构规则：

- 每种编制使用独立决议控制。
- 决议命名根据编制名称创建。
- 决议排序从低级编制到高级编制，可按难度分配顺序排列。
- 决议不隐藏。
- 不额外设置为“仅 AI 可见”，因为 AI 决议组已经负责承载此部分内容。
- 每个编制决议完成后，同时创建模板并发放该编制的起始部队。

特殊项目与科技：

- 机械化与两栖机械化科技不再由 AI 编制决议补发。
- 直升机与陆军工程载具特殊项目在常规编制相关逻辑中处理。
- 直升机与陆军工程载具不放入陆巡线或现代坦克线。
- 特殊项目补发使用 `JAP_ai_complete_regular_template_special_projects`：先检测当前是否尚未完成，未完成时再发放。

#### 已完成准备件

- 已新增各编制复合装备判定 scripted trigger，位置：`common/scripted_triggers/JAP_equipment_design_scripted_triggers.txt`。
- 已新增常规编制特殊项目补发 scripted effect，位置：`common/scripted_effects/JAP_templates_scripted_effects.txt`。
- 已新增现代坦歼判定入口 `JAP_has_cr_modern_tank_destroyer_chassis_design`。
- 已补充现代坦歼装备设计、装备创建脚本效果、旗标登记与动态本地化入口。
- 已在 `common/decisions/JAP_rework_ai_decision.txt` 落地各编制独立 AI 决议。

#### 待办

- 旧批量模板/起始部队决议已手动注释停用，后续确认稳定后可清理旧注释块。
- 两种步兵师与日本试验步坦师未来专门处理。
- 维护装备发放未来采用独立系统，本轮不考虑。
- `common/ai_strategy/` 生产策略未来再调整，本轮不考虑。
