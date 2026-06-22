# 情报机构决议参考

来源：2026-06-19 为 `JAP_intelligence_agency_decisions` 调查整理。
适用范围：未来编写情报机构、特工、反间谍、情报行动相关决议时使用。

## 调查范围

已检查的原版文件：

- `D:\SteamLibrary\steamapps\common\Hearts of Iron IV\common\intelligence_agencies\00_intelligence_agencies.txt`
- `D:\SteamLibrary\steamapps\common\Hearts of Iron IV\common\intelligence_agency_upgrades\_documentation.md`
- `D:\SteamLibrary\steamapps\common\Hearts of Iron IV\common\intelligence_agency_upgrades\intelligence_agency_upgrades.txt`
- `D:\SteamLibrary\steamapps\common\Hearts of Iron IV\common\operations\_documentation.md`
- `D:\SteamLibrary\steamapps\common\Hearts of Iron IV\common\operations\00_operations.txt`
- `D:\SteamLibrary\steamapps\common\Hearts of Iron IV\common\operation_tokens\_documentation.md`
- `D:\SteamLibrary\steamapps\common\Hearts of Iron IV\common\operation_tokens\00_OperationTokens.txt`

已检查的本项目文件：

- `common/national_focus/japan.txt`
- `common/ideas/japan.txt`
- `common/dynamic_modifiers/zzz_japan_rework_dynamic_modifiers.txt`
- `common/ai_strategy/JAP_rework_ai_operations.txt`
- `common/ai_strategy/AI_Strategy_Reference/_documentation.md`
- `common/characters/JAP.txt`
- `Reference/modifier_trans.md`
- `Reference/defines_lua_reference.md`

## 结论速记

- 与情报机构、特工、行动相关的内容应先用 `has_dlc = "La Resistance"` 设门槛。本项目日本国策已有惯例：有 LaR 时走机构/特工奖励；无 LaR 时给独立的 no-LaR idea 兜底。
- 创建机构的稳定写法是先检查 `has_intelligence_agency = no`，再执行 `create_intelligence_agency = yes`。本项目 `JAP_supremacy_of_the_kempeitai`、`JAP_form_cabinet_intelligence_bureau`、`JAP_learn_from_the_nkvd` 都是这个模式。
- 决议组的名称/描述可以用 scripted localization 动态变化，但真正的情报机构窗口名称和徽标由 `common/intelligence_agencies` 控制，不会被决议组本地化自动改名。
- 已检查原版 `common`/`events` 和本项目脚本，未见 `start_operation`、`create_operation`、`run_operation`、`prepare_operation` 这类直接启动情报行动的脚本用例。应把情报行动视为独立 UI/系统；决议可以通过机构创建、idea/dynamic modifier、行动令牌、情报/破译效果或 AI strategy 来辅助，而不是假定普通决议能直接启动行动。
- 直接赠送指定机构升级的原版效果是 `upgrade_intelligence_agency = upgrade_*`。使用前仍建议用 `NOT = { has_done_agency_upgrade = upgrade_* }` 避免重复赠送。
- 原版还有 scripted effect `gain_random_agency_upgrade`：没有机构时先创建机构；已有机构时随机给予一个未完成的机构升级。

## 机构创建与机构名称

原版 `intelligence_agency = { ... }` 条目支持：

- `picture = GFX_intelligence_agency_logo_*`
- `names = { ... }`：可写直接文本或本地化键，会随机选择一个名称。
- `default = { ... }`：创建机构时默认选用哪套名称/徽标。
- `available = { ... }`：控制该徽标/名称组合是否在机构 UI 中可用。

原版日本有两个相关默认项：

- `GFX_intelligence_agency_logo_jap`，名称为 `G-2 Department` / `Section 3`，在 `tag = JAP` 且未完成 `JAP_establish_the_gunbatsu` 时作为默认项；`available = { original_tag = JAP }`。
- `GFX_intelligence_agency_logo_JAP_Kempeitai`，名称为 `Kempeitai`，在 `tag = JAP` 且完成 `JAP_establish_the_gunbatsu` 后作为默认项；可用于 `original_tag = JAP` 且政府为中立或法西斯。

对本 MOD 的含义：

- 当前动态决议组名称可以独立显示为 `特高课` / `内务部` / `公安厅`。
- 如果以后希望真正的机构 UI 也按意识形态变化，需要单独添加或覆盖 `common/intelligence_agencies` 条目。不要指望决议组标题能改机构 UI 名称。

## 可用于决议的触发器

下列触发器是后续写决议最可能用到的已核对项。

| 触发器 | 已见用处 | 适用方式 |
| --- | --- | --- |
| `has_dlc = "La Resistance"` | 本项目国策、AI strategy、角色 | 情报机构、特工、行动内容的基础门槛。 |
| `has_intelligence_agency = no/yes` | 本项目国策、情报首脑顾问可用条件 | 创建机构前检查，或要求已有机构。 |
| `has_done_agency_upgrade = upgrade_*` | 原版升级、国策、决议、角色 | 按已完成机构升级解锁决议或提示。 |
| `has_tech = mechanical_computing` | 原版 `operation_capture_cipher` | 密码/破译内容门槛。 |
| `num_of_operatives > N` | 原版窃取科技、破坏行动 | 检查可用特工数量；常见于行动 requirements。 |
| `network_strength = { target = FROM value > N }` | 原版行动 | 要求对目标国家有足够情报网强度。 |
| `network_national_coverage = { target = FROM value > 0 }` | 原版渗透文职部门行动 | 要求对目标有非零情报网覆盖。 |
| `has_operation_token = { tag = FROM token = token_* }` | 原版行动 | 要求之前已对目标取得渗透/联络令牌。 |
| `has_captured_operative = ROOT` | 原版营救特工行动 | 检查目标是否关押 ROOT 的特工。 |
| `num_finished_operations = { operation = operation_* target = TAG value < N }` | 本项目 AI strategy | 限制 AI 对某目标重复执行行动的次数。 |
| `is_preparing_operation = { operation = operation_* target = TAG }` | 本项目 AI strategy | AI 正在准备行动时保持引导。 |
| `is_running_operation = { operation = operation_* target = TAG }` | 本项目 AI strategy | AI 正在执行行动时保持引导。 |

作用域提醒：

- 原版行动文档中，`ROOT` 是行动发起国，`FROM` 是行动目标国。
- 如果行动有 state `selection_target`，`FROM.FROM` 可以是被选中的州。
- 普通决议不自动拥有行动系统的目标作用域。把行动触发器/效果搬进决议前，要重新确认作用域。

## 可用于决议的效果

下列效果可作为未来决议设计的主要候选。

| 效果 | 已见用处 | 适用方式 |
| --- | --- | --- |
| `create_intelligence_agency = yes` | 本项目日本国策 | 缺少机构时创建情报机构。 |
| `create_intelligence_agency = { name = KEY_OR_TEXT icon = GFX_* }` | 原版阿富汗、阿根廷、奥地利等国策 | 创建机构并指定名称/徽标。 |
| `upgrade_intelligence_agency = upgrade_*` | 原版国策、on_action、scripted effect | 直接给予指定机构升级。 |
| `gain_random_agency_upgrade = yes` | 原版 `common/scripted_effects/00_scripted_effects.txt` | 随机给予未完成机构升级；无机构时先创建机构。 |
| `add_ideas = JAP_*_idea_lar` / `swap_ideas = { ... }` | 本项目日本国策 | 给予长期国家奖励。 |
| `JAP_add_or_modify_communist_party_modifier = yes` + `add_to_variable = { ... }` | 本项目共产路线国策 | 给予路线专属动态修正奖励。 |
| `add_operation_token = { tag = FROM token = token_* }` | 原版行动 outcome | 行动完成后授予渗透/联络令牌；搬到非行动效果前要复查作用域。 |
| `add_intel = { target = FROM civilian_intel/army_intel/navy_intel/airforce_intel = N }` | 原版行动 outcome | 直接增加对目标的民政/陆军/海军/空军情报。 |
| `add_decryption = { target = FROM ratio = N }` | 原版 `operation_capture_cipher` | 增加对目标的破译进度。 |
| `free_random_operative = { captured_by = FROM all = yes }` | 原版营救特工行动 | 从目标国家释放一名被捕特工。 |
| `release_captured_generals_from = ROOT` | 原版营救将领行动 | 释放被俘将领。 |

推荐决议模式：

```txt
available = {
	has_dlc = "La Resistance"
}

complete_effect = {
	if = {
		limit = { has_intelligence_agency = no }
		create_intelligence_agency = yes
	}
	if = {
		limit = { NOT = { has_done_agency_upgrade = upgrade_passive_defense } }
		upgrade_intelligence_agency = upgrade_passive_defense
	}
	add_ideas = JAP_some_intelligence_agency_idea
}
```

```txt
complete_effect = {
	JAP_add_or_modify_communist_party_modifier = yes
	add_to_variable = {
		JAP_communist_party_operative_slot = 1
		tooltip = operative_slot_tt
	}
}
```

## 可复用修正

项目和原版已经使用或记录了这些修正。

| 修正 | 含义 / 用途 |
| --- | --- |
| `operative_slot` | 增加可用特工位；本项目 `JAP_tokko_idea_lar`、`JAP_kempeitai_idea_lar`、共产动态修正都在用。 |
| `new_operative_slot_bonus` | 增加特工招募候选；原版 `upgrade_training_centers` 使用。 |
| `intelligence_agency_defense` | 反间谍；日本秘密警察类 idea 已使用。 |
| `enemy_operative_detection_chance_factor` | 提高发现敌方特工几率。 |
| `enemy_operative_capture_chance_factor` | 提高抓捕敌方特工几率。 |
| `enemy_operative_intel_extraction_rate` | 提高从被捕敌方特工处获取情报的效率。 |
| `own_operative_detection_chance` | 影响我方特工被发现风险；原版 `upgrade_suicide_pills` 降低该值。 |
| `operative_death_on_capture_chance` | 我方特工被捕后死亡几率；原版 `upgrade_suicide_pills` 提高该值。 |
| `intel_from_operatives_factor` | 提高来自特工和渗透线人的情报。 |
| `civilian_intel_factor`、`army_intel_factor`、`navy_intel_factor`、`airforce_intel_factor` | 各情报分支的情报加成。 |
| `operation_infiltrate_outcome`、`operation_infiltrate_risk`、`operation_infiltrate_cost` | 影响渗透类行动。 |
| `operation_steal_tech_outcome`、`operation_steal_tech_risk` | 影响窃取科技行动。 |
| `operation_coordinated_strike_outcome` | 影响协同打击行动结果。 |
| `operation_outcome`、`operation_risk`、`operation_cost` | 原版行动通用结果/风险/花费修正。 |
| `target_sabotage_factor`、`target_sabotage_risk`、`target_sabotage_cost` | 影响定点破坏行动。 |
| `boost_resistance_factor` | 影响加强抵抗组织行动。 |
| `agency_upgrade_time` | 情报机构升级时间。 |
| `crypto_department_enabled`、`crypto_strength`、`decryption_power`、`decryption_power_factor` | 密码部门、加密和破译机制。 |
| `intelligence_operation_speed` | 情报行动速度系数。 |

## 本项目已有奖励载体

固定 idea：

- `JAP_tokko_idea_lar`：`operative_slot = 1`，发现/榨取/抓捕敌方特工修正，`intelligence_agency_defense = 0.05`，`drift_defence_factor = 0.15`。
- `JAP_tokko_idea_lar_2`：加强版特高课 idea，`intelligence_agency_defense = 0.1`，另有 `stability_factor = 0.05` 和 `root_out_resistance_effectiveness_factor = 0.1`。
- `JAP_kempeitai_idea_lar`：`operative_slot = 2`，发现/榨取/抓捕敌方特工修正，`intelligence_agency_defense = 0.1`，`resistance_target = -0.1`。

动态修正：

- `JAP_showa_statism_modifier` 暴露 `operative_slot = JAP_showa_statism_operative_slot`。
- `JAP_communist_party_modifier` 和 `JAP_rounouha_modifier` 暴露：
  - `operative_slot = JAP_communist_party_operative_slot`
  - `enemy_operative_detection_chance_factor = JAP_communist_party_enemy_operative_detection_chance_factor`
  - `enemy_operative_intel_extraction_rate = JAP_communist_party_enemy_operative_intel_extraction_rate`
  - `enemy_operative_capture_chance_factor = JAP_communist_party_enemy_operative_capture_chance_factor`

新增决议奖励前，优先复用这些载体。

## 原版机构升级分支

指定升级效果：

```txt
if = {
	limit = {
		has_dlc = "La Resistance"
	}
	if = {
		limit = { has_intelligence_agency = no }
		create_intelligence_agency = yes
	}
	if = {
		limit = { NOT = { has_done_agency_upgrade = upgrade_training_centers } }
		upgrade_intelligence_agency = upgrade_training_centers
	}
}
```

原版 `ICE_infiltrating_the_british_isles` 使用了这个模式，先建机构，再给 `upgrade_diplo_training` 和 `upgrade_training_centers`。

指定机构名称/徽标时，可用块式创建：

```txt
create_intelligence_agency = {
	name = "Evidenzbureau"
	icon = GFX_intelligence_agency_logo_AUS_evidenzbureau_democratic
}
```

随机升级效果：

```txt
gain_random_agency_upgrade = yes
```

原版 `gain_random_agency_upgrade` 内部会用 `random_list` 排除已完成升级；密码部门后续升级还会检查 `upgrade_form_department` 等前置。

本项目当前没有自定义 `common/intelligence_agency_upgrades`，因此可直接用于 `upgrade_intelligence_agency = ...` 的机构升级 key 来自原版 21 个条目：

| 分支 | key | 原版中文名 | 前置 / 可用条件 | 主要效果 |
| --- | --- | --- | --- | --- |
| `branch_intelligence` 情报 | `upgrade_economy_civilian` | 经济/民政 | 无 | `civilian_intel_factor = 0.25`。 |
| `branch_intelligence` 情报 | `upgrade_army_department` | 陆军部 | 无 | `army_intel_factor = 0.25`。 |
| `branch_intelligence` 情报 | `upgrade_naval_department` | 海军部 | 无 | `navy_intel_factor = 0.25`。 |
| `branch_intelligence` 情报 | `upgrade_airforce_department` | 空军部 | 无 | `airforce_intel_factor = 0.25`。 |
| `branch_defense` 防御 | `upgrade_passive_defense` | 被动防御 | 无；4 个 `level` | `intelligence_agency_defense = 1.5 / 1.25 / 1 / 1`。 |
| `branch_defense` 防御 | `upgrade_anti_partisan` | 反抵抗运动 | 无；2 个 `level` | 每级 `root_out_resistance_effectiveness_factor = 0.25`。 |
| `branch_operation` 行动 | `upgrade_blueprint_stealing` | 盗取蓝图 | 无 | `operation_steal_tech_outcome = 0.25`。 |
| `branch_operation` 行动 | `upgrade_portable_radios` | 便携式无线通信设备 | `has_tech = radio` | `operation_coordinated_strike_outcome = 1`。 |
| `branch_operation` 行动 | `upgrade_invisible_ink` | 隐形墨水 | 无 | `intel_from_operatives_factor = 0.2`，`operation_steal_tech_risk = -0.25`。 |
| `branch_operation` 行动 | `upgrade_plastic_explosives` | 塑胶炸药 | 无 | `target_sabotage_factor = 0.25`，`boost_resistance_factor = 0.25`。 |
| `branch_operation` 行动 | `upgrade_suicide_pills` | 自杀药物 | 无 | `operative_death_on_capture_chance = 0.1`，`own_operative_detection_chance = -0.05`。 |
| `branch_operative` 特工训练 | `upgrade_training_centers` | 本地化训练中心 | 无 | `enemy_operative_recruitment_chance = 0.25`，`occupied_operative_recruitment_chance = 0.25`，`new_operative_slot_bonus = 1`；完成后解锁 `lar_local_recruitment` 决议分类提示。 |
| `branch_operative` 特工训练 | `upgrade_commando_training` | 特种作战训练 | 无 | `commando_trait_chance_factor = 1`。 |
| `branch_operative` 特工训练 | `upgrade_interrogation_techniques` | 审讯技术 | 无 | `enemy_operative_capture_chance_factor = 1`，`enemy_operative_intel_extraction_rate = 0.25`。 |
| `branch_operative` 特工训练 | `upgrade_diplo_training` | 外交训练 | 无 | `control_trade_mission_factor = 0.25`，`diplomatic_pressure_mission_factor = 0.25`。 |
| `branch_operative` 特工训练 | `upgrade_psycho_warfare` | 心理战 | 无 | `propaganda_mission_factor = 0.25`，`boost_ideology_mission_factor = 0.25`。 |
| `branch_crypto` 密码部门 | `upgrade_form_department` | 成立部门 | 无 | `crypto_department_enabled = 1`，`crypto_strength = 1`，`decryption_power = 25`。 |
| `branch_crypto` 密码部门 | `upgrade_decryption_boost` | 无线电侦听组 | `has_done_agency_upgrade = upgrade_form_department`；2 个 `level` | `decryption_power = 25 / 10`。 |
| `branch_crypto` 密码部门 | `upgrade_decryption_boost_2` | 机械辅助解密技术 | `has_done_agency_upgrade = upgrade_decryption_boost`，`has_tech = mechanical_computing`；3 个 `level` | `decryption_power = 25 / 15 / 10`。 |
| `branch_crypto` 密码部门 | `upgrade_crypto_strength` | 政府密码学院 | `has_done_agency_upgrade = upgrade_form_department`；2 个 `level` | 每级 `crypto_strength = 1`。 |
| `branch_crypto` 密码部门 | `upgrade_crypto_strength_2` | 机器辅助加密技术 | `has_done_agency_upgrade = upgrade_crypto_strength`，`has_tech = mechanical_computing`；3 个 `level` | 每级 `crypto_strength = 2`。 |

多级升级提示：

- 原版定义用多个 `level = { ... }` 表示同一升级有多级效果。
- 决议直接赠送多级升级时，推荐按原版国策写法先检查 `NOT = { has_done_agency_upgrade = upgrade_* }`，再执行 `upgrade_intelligence_agency = upgrade_*`。
- 如果需要精确控制“给第几级”或“是否填满全部级数”，先在游戏内实测 `upgrade_intelligence_agency` 对多级升级的推进行为，再写成项目规则。

| 分支 | 主要效果 |
| --- | --- |
| `branch_intelligence` | `civilian_intel_factor`、`army_intel_factor`、`navy_intel_factor`、`airforce_intel_factor`。 |
| `branch_defense` | `intelligence_agency_defense`、`root_out_resistance_effectiveness_factor`。 |
| `branch_operation` | `operation_steal_tech_outcome`、`operation_coordinated_strike_outcome`、`intel_from_operatives_factor`、`operation_steal_tech_risk`、`target_sabotage_factor`、`boost_resistance_factor`、`operative_death_on_capture_chance`、`own_operative_detection_chance`。 |
| `branch_operative` | `enemy_operative_recruitment_chance`、`occupied_operative_recruitment_chance`、`new_operative_slot_bonus`、特战/审讯/外交/宣传任务相关修正。 |
| `branch_crypto` | `crypto_department_enabled`、`crypto_strength`、`decryption_power`；后续升级用 `has_done_agency_upgrade` 做前置。 |

升级定义可写 `visible`、`available`、`modifiers_during_progress`，也可在每级里写 `modifier` / `complete_effect`。如果决议要直接给升级，使用 `upgrade_intelligence_agency = upgrade_*`；如果只是想给路线专属长期能力，仍可选择 idea 或动态修正。

## 原版行动族

| 行动 | 天数 / 情报网 / 特工 | 关键条件或奖励 |
| --- | --- | --- |
| `operation_rescue_operative` | 35 / 30 / 1 | 需要目标关押特工；释放特工。 |
| `operation_rescue_general` | 35 / 30 / 1 | 释放被俘将领。 |
| `operation_infiltrate_civilian` | 90 / 35 / 2 | 授予 `token_civilian`；可能增加 `civilian_intel`。 |
| `operation_capture_cipher` | 75 / 40 / 2 | 需要 `mechanical_computing`；增加破译进度和可能的情报。 |
| `operation_infiltrate_armed_forces_army` | 75 / 50 / 2 | 授予 `token_army`；可能增加 `army_intel`。 |
| `operation_infiltrate_armed_forces_navy` | 75 / 50 / 2 | 授予 `token_navy`；可能增加 `navy_intel`。 |
| `operation_infiltrate_armed_forces_airforce` | 75 / 50 / 2 | 授予 `token_airforce`；可能增加 `airforce_intel`。 |
| `operation_coup_government` | 180 / 70 / 2 | 州目标政变行动；使用 `operation_coup_cost`。 |
| `operation_make_resistance_contacts` | 60 / 40 / 2 | 授予 `token_resistance_contacts`。 |
| `operation_boost_resistance` | 50 / 35 / 2 | 需要 `token_resistance_contacts`；使用 `boost_resistance_factor`。 |
| `operation_collaboration_government` | 90 / 50 / 2 | 本项目日本 AI 已明确用于对中国行动。 |
| `operation_coordinated_strike` | 3 / 70 / 2 | 战略区域目标；`will_lead_to_war_with = yes`。 |
| `operation_steal_tech_civilian` | 120 / 35 / 3 | 需要 `token_civilian`；使用窃取科技修正。 |
| `operation_steal_tech_army/navy/airforce` | 120 / 50 / 3 | 需要对应军种 token；使用窃取科技修正。 |
| `operation_targeted_sabotage_industry/infrastructure/resources` | 90 / 35 / 3 | 需要 `token_resistance_contacts`；使用破坏类修正。 |

行动令牌注意事项：

- 原版每个 token 只提供一种情报来源。
- `token_airforce`、`token_army`、`token_civilian`、`token_navy` 分别给对应来源 10 点情报。
- `token_resistance_contacts` 给 5 点陆军情报。
- token 不可叠加；不要设计成重复决议能无限堆叠同类 token。

## AI Strategy 写法

本项目 `common/ai_strategy/JAP_rework_ai_operations.txt` 已经给出推荐风格：

- `allowed` 用 `original_tag = JAP` 和 `has_dlc = "La Resistance"`。
- `enable` 组合路线/政府、目标存在、战争/投降/附庸检查，以及行动次数检查。
- 推动行动的策略使用 `abort_when_not_enabled = yes`。
- `intelligence_agency_usable_factories` 控制 AI 愿意投入机构建设的工厂数。
- `intelligence_agency_branch_desire_factor` 推动 AI 选择 `branch_operation` 和 `branch_operative`。
- `operative_mission` 配合 `mission = build_intel_network` 与 `mission_target = TAG` 推动建立情报网。
- `operative_operation` 配合 `operation = operation_collaboration_government` 与 `operation_target = CHI` 推动具体行动。
- `operation_equipment_priority` 提高情报行动装备优先级。

玩家决议不要轻易塞入 AI strategy，除非该决议本身就是在解锁或改变 AI 行为。AI 专用支持应另写 `common/ai_strategy/` 条目，并保持清晰的 `allowed`、`enable`、`abort_when_not_enabled`。

## 角色 / 顾问挂钩

`common/characters/JAP.txt` 中已有 `head_of_intelligence` 顾问：`available` 要求 `has_intelligence_agency = yes`，`allowed` 要求 `original_tag = JAP` 和 `has_dlc = "La Resistance"`。

如果未来情报决议要解锁或提示顾问，复用这个模式，并参考：

- `common/characters/AGENTS.md`
- `common/characters/Character_Reference/character_authoring_reference.md`
- `Reference/advisor_unlock_tooltip_reference.md`

## Defines 只作背景

`Reference/defines_lua_reference.md` 记录了机构创建天数/工厂数、升级天数、间谍大师/反间谍、情报网行为、宣传任务阈值等 LaR 相关 defines。

这些可作为机制背景。若后续任务要改 defines，应改 `common/defines/Rance_defines.lua`，不要改原版文件，并按 defines 参考复核。

## 编写决议前清单

向 `JAP_intelligence_agency_decisions` 添加决议前：

1. 判断是否 LaR 专属。若是，使用 `has_dlc = "La Resistance"`；若无 LaR 也要显示，另写兜底效果。
2. 判断该决议的目标：创建机构、增强长期能力、辅助行动、还是引导 AI。
3. 创建机构时使用 `has_intelligence_agency = no` 和 `create_intelligence_agency = yes`。
4. 赠送指定机构升级时使用 `upgrade_intelligence_agency = upgrade_*`，并用 `NOT = { has_done_agency_upgrade = upgrade_* }` 保护重复执行。
5. 长期奖励优先复用现有日本 idea 或动态修正。
6. 与行动相关时，优先使用行动定义、行动令牌、情报/破译效果或 AI strategy。不要在未验证有效效果前发明直接启动行动的写法。
7. AI 行为参考 `JAP_rework_ai_operations.txt`，不要把 AI 引导逻辑混进普通玩家决议效果。
8. 如果真实机构 UI 名称也要按意识形态变化，单独处理 `common/intelligence_agencies`，不要依赖决议组本地化。
