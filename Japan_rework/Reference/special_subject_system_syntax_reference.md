# 特殊属国系统语法参考

记录日期：2026-06-22

本文整理 `PLAN/属国系统构想.md` 后续实现可能用到的 HOI4 语法入口。本文只记录可复用语法、最小模板和风险点，不代表特殊属国系统已经进入玩法脚本。

## 使用边界

- 新版特殊属国系统的主循环是“特殊属国轻量 AI + 月度积分 + 日本装备/设计/编制决议辅助”。
- 不再把“日本长期脚本生成属国师”作为核心方案。
- 直接生成单位、锁训练、强行补装备等语法只作为事件、紧急补给、AI 兜底或调试工具参考。
- 所有实装前都应先用小范围 debug 决议或事件验证，尤其是自定义自治等级、国策树替换、collection 比例和动态修正刷新。

## 自定义自治等级

用途：

- 表达“皇国海军辖地”“皇国合作政府”“皇国总督府”“皇国卫星国”等特殊属国类型。
- 给脚本、AI、国策、决议和本地化提供稳定的属国类型判定点。

推荐写法：

```hoi4
autonomy_state = {
	id = autonomy_jap_special_subject
	default = yes
	is_puppet = yes
	use_overlord_color = no
	min_freedom_level = 0.2
	manpower_influence = 0.9

	rule = {
		desc = "RULE_DESC_IS_A_SUBJECT"
		can_not_declare_war = yes
		can_decline_call_to_war = no
		can_be_spymaster = no
		can_create_collaboration_government = no
	}

	modifier = {
		can_master_build_for_us = 1
		cic_to_overlord_factor = 0.25
		mic_to_overlord_factor = 0.50
		autonomy_gain_global_factor = -1.0
	}

	allowed = {
		OVERLORD = { original_tag = JAP }
	}

	allowed_levels_filter = {
		autonomy_jap_special_subject
	}

	can_take_level = {
		always = no
	}

	can_lose_level = {
		always = no
	}
}
```

风险点：

- `allowed_levels_filter` 可限制同一链条里的可见/可用等级，但自定义单级属国仍需实测 UI 和自治度变化是否会被其他系统推走。
- `can_take_level`、`can_lose_level` 可以锁升级/降级；如果未来要通过事件转换属国类型，不应只依赖自治度自然升降。
- 原版没有发现 `dockyard_to_overlord` 或 `nic_to_overlord_factor` 这类船坞直接上供字段；船坞贡献应按变量/动态修正或积分模拟。
- `use_overlord_color = yes` 会让属国继承宗主国颜色，适合直接辖地，但不适合需要地图区分的多属国体系。

图标配置：

- `autonomy_state` 定义本身不写 `icon =`；原版 `common/autonomous_states/*.txt` 未发现自治等级图标字段。
- 政治界面的自治等级图标在 `interface/countrypoliticsview.gfx` 注册，命名约定是 `GFX_<自治等级 id>_icon`，例如 `GFX_autonomy_wtt_imperial_associate_icon`。
- 本 MOD 自定义等级 `autonomy_jap_rework_imperial_governor_generalship` 对应注册名为 `GFX_autonomy_jap_rework_imperial_governor_generalship_icon`；当前复用原版 `gfx/interface/autonomy/autonomy_imperial_associate.dds`，登记在 `interface/rance_jap_autonomy.gfx`。

原版参考路径：

- `D:\SteamLibrary\steamapps\common\Hearts of Iron IV\common\autonomous_states\supervised_state.txt`
- `D:\SteamLibrary\steamapps\common\Hearts of Iron IV\common\autonomous_states\sea_warlord_subject.txt`
- `D:\SteamLibrary\steamapps\common\Hearts of Iron IV\common\autonomous_states\wtt_imperial_protectorate.txt`
- `Reference/subject_autonomy_reference.md`

## 类型判定与初始化标记

用途：

- 在国策、决议、AI 策略、动态修正和 scripted trigger 中判断某国是否接入特殊属国系统。
- 区分自治等级本身、成立方式、地区身份和初始化进度。

推荐写法：

```hoi4
JAP_rework_is_japanese_special_subject = {
	is_subject_of = JAP
	OR = {
		has_autonomy_state = autonomy_jap_rework_imperial_governor_generalship
		# Future Japan special subject autonomy levels should be added here.
	}
}
```

```hoi4
set_country_flag = JAP_rework_special_subject_initialized
set_country_flag = JAP_rework_special_subject_from_decision_release
```

风险点：

- `has_autonomy_state = autonomy_xxx` 应作为优先判定点，country flag 只记录“接入状态”“成立方式”“地区身份”等附加信息。
- 如果自治等级和 flag 同时表达类型，未来转换属国类型时容易两套状态互相打架。
- 开局既存属国、决议释放属国、战争中新占领地区释放属国最好走同一个初始化 scripted effect，只在入口处传不同参数或设置不同 flag。

原版参考路径：

- `D:\SteamLibrary\steamapps\common\Hearts of Iron IV\common\autonomous_states\supervised_state.txt`
- `D:\SteamLibrary\steamapps\common\Hearts of Iron IV\common\collections\collections.txt`
- `Reference/subject_autonomy_reference.md`

## 国策树替换

用途：

- 成立特殊属国后，替换或覆盖原版/专属国策树，避免旧国策继续把国家拉回原版路线。
- 给特殊属国通用建设、特殊地位内容和联合发展提供统一入口。

推荐写法：

```hoi4
if = {
	limit = {
		NOT = { has_focus_tree = jap_special_subject_focus_tree }
	}
	load_focus_tree = {
		tree = jap_special_subject_focus_tree
		keep_completed = no
	}
	mark_focus_tree_layout_dirty = yes
}
```

如果替换时需要保留旧进度或修补起点：

```hoi4
load_focus_tree = {
	tree = jap_special_subject_focus_tree
	keep_completed = yes
}
unlock_national_focus = JAP_special_subject_start
```

风险点：

- `keep_completed = yes/no` 是关键分岔：特殊属国新树通常倾向 `no`，但接管已有国家时要评估是否需要保留已完成旧国策效果。
- 原版替换后常用 `unlock_national_focus` 修补起点；如果新树有多个入口，需要明确解锁哪一个。
- `mark_focus_tree_layout_dirty = yes` 主要用于刷新布局或动态图标，不等于重新计算所有旧国策效果。
- 旧国策给予的国家精神、动态修正、变量和 flag 不会因为换树自动清理，需要另写白名单清理。

原版参考路径：

- `D:\SteamLibrary\steamapps\common\Hearts of Iron IV\common\on_actions\03_wtt_on_actions.txt`
- `D:\SteamLibrary\steamapps\common\Hearts of Iron IV\common\decisions\BEL.txt`
- `D:\SteamLibrary\steamapps\common\Hearts of Iron IV\events\BFTB_Greece.txt`

## 外观标签、颜色和名称

用途：

- 给特殊属国设置地图颜色、UI 颜色和特殊政权名。
- 区分泛用自治等级名称与具体 tag 的特殊外观。

推荐写法：

```hoi4
TAG = {
	drop_cosmetic_tag = yes
	set_cosmetic_tag = TAG_jap_special_subject
}
```

```hoi4
TAG_jap_special_subject = {
	color = rgb { 80 120 150 }
	color_ui = rgb { 90 150 180 }
}
```

名称方案：

- 泛用类型名：使用 `autonomy_jap_special_subject` 的本地化。
- 特定 tag 在某自治等级下的名称：使用 `TAG_autonomy_jap_special_subject`、`TAG_autonomy_jap_special_subject_DEF`、`TAG_autonomy_jap_special_subject_ADJ`。
- 特殊军政府、合并政权、临时政权：优先使用 `set_cosmetic_tag`，再写对应外观标签本地化。

风险点：

- 如果旧 `cosmetic_tag` 还在，直接 `set_cosmetic_tag` 可能继承旧显示语义；转换前优先 `drop_cosmetic_tag = yes`。
- 颜色和名称应单独建表维护，避免决议、事件、国策和本地化各写一份。
- `use_overlord_color = yes` 与外观标签颜色的优先级、实际地图表现需要实测，尤其是同一属国类型下多 tag 并存时。

原版参考路径：

- `D:\SteamLibrary\steamapps\common\Hearts of Iron IV\common\countries\cosmetic.txt`
- `D:\SteamLibrary\steamapps\common\Hearts of Iron IV\common\decisions\JAP.txt`
- `D:\SteamLibrary\steamapps\common\Hearts of Iron IV\events\AAT_Iceland.txt`
- `D:\SteamLibrary\steamapps\common\Hearts of Iron IV\localisation\english\countries_l_english.yml`
- `D:\SteamLibrary\steamapps\common\Hearts of Iron IV\localisation\english\autonomy_l_english.yml`

## 规划疆域与 Collection

用途：

- 判断目标属国规划疆域是否已被日本、属国或盟友控制到足够比例。
- 批量转交规划疆域、筛出不应持有地区、支持 UI 进度。

推荐写法：

固定规划疆域先放在 `state_groups`：

```hoi4
state_groups = {
	JAP_rework_korea_subject_states = {
		525
		527
		909
	}
}
```

再用命名 collection 过滤控制状态：

```hoi4
JAP_rework_korea_subject_planned_states = {
	input = constant:state_groups.JAP_rework_korea_subject_states
	name = COLLECTION_JAP_REWORK_KOREA_SUBJECT_PLANNED_STATES
}

JAP_rework_korea_subject_controlled_states = {
	input = constant:state_groups.JAP_rework_korea_subject_states
	operators = {
		limit = {
			OR = {
				is_controlled_by_ROOT_or_ally = yes
				controller = { is_subject_of = ROOT }
			}
		}
	}
	name = COLLECTION_JAP_REWORK_KOREA_SUBJECT_CONTROLLED_STATES
}
```

决议可用性用固定半数阈值：

```hoi4
collection_size = {
	input = collection:JAP_rework_korea_subject_controlled_states
	value > 2
}
```

风险点：

- `collection_size` 的比较在原版文档中标注为 inclusive，关键阈值应实测 tooltip 和实际可用性。
- `game:scope` 取决于 collection 的调用环境；日本侧决议、属国侧决议、事件 `FROM` 中的结果可能不同。
- 固定规划疆域优先 `state_groups`/collection；数组更适合运行时临时列表。
- 若要做“控制比例”UI，可参考 `ratio_progress`，但决议可用性首版建议用固定半数阈值，减少不确定性。

原版参考路径：

- `D:\SteamLibrary\steamapps\common\Hearts of Iron IV\common\collections\_documentation.md`
- `D:\SteamLibrary\steamapps\common\Hearts of Iron IV\common\collections\collections.txt`
- `D:\SteamLibrary\steamapps\common\Hearts of Iron IV\common\script_constants\state_groups.txt`
- `D:\SteamLibrary\steamapps\common\Hearts of Iron IV\common\factions\_documentation.md`
- `Reference/collections_usage_reference.md`
- `Reference/collections_lookup_reference.md`

## 变量、积分和动态修正

用途：

- 记录属国每月陆军步兵师积分、陆军装甲师积分、海军积分。
- 记录日本侧模拟船坞贡献、联合发展国策进度、全体属国共享强化。
- 将变量读入动态修正，用于工业、船坞、生产或其他数值表现。

推荐写法：

```hoi4
set_variable = { JAP_rework_subject_infantry_points = 0 }
add_to_variable = { JAP_rework_subject_infantry_points = 5 }
clamp_variable = {
	var = JAP_rework_subject_infantry_points
	min = 0
	max = 999
}
```

跨属国共享进度可使用全局变量，但只在确实需要全体共享时使用：

```hoi4
set_variable = { global.JAP_rework_subject_joint_army_progress = 0 }
add_to_variable = { global.JAP_rework_subject_joint_army_progress = 1 }
```

动态修正模板：

```hoi4
JAP_rework_special_subject_joint_modifier = {
	enable = { always = yes }
	remove_trigger = {
		NOT = { has_country_flag = JAP_rework_special_subject_initialized }
	}

	industrial_capacity_factory = JAP_rework_subject_factory_bonus
	industrial_capacity_dockyard = JAP_rework_subject_dockyard_bonus
}
```

挂载和刷新：

```hoi4
add_dynamic_modifier = {
	modifier = JAP_rework_special_subject_joint_modifier
}
force_update_dynamic_modifier = yes
```

风险点：

- 动态修正会读取变量，但默认不是每行脚本后立刻刷新；原版注释说明可用 `force_update_dynamic_modifier` 强制更新。
- 全局变量适合联合进度，不适合所有属国私有积分；私有积分优先存到属国国家作用域。
- 新成立属国要保证挂上动态修正；已失去特殊属国身份的国家要能触发移除。
- 月度积分结算应可重复执行且幂等，避免 save/load 或重复初始化后翻倍。

原版参考路径：

- `D:\SteamLibrary\steamapps\common\Hearts of Iron IV\common\dynamic_modifiers\0_dynamic_modifiers.txt`
- `Reference/variable_syntax_reference.md`
- `common/dynamic_modifiers/zzz_japan_rework_dynamic_modifiers.txt`

## 装备、编制和单位辅助

用途：

- 日本给特殊属国发放装备包、设计、编制或紧急单位。
- 属国用积分兑换辅助，而不是由日本永久托管全部建军。

推荐写法：

发送日本库存：

```hoi4
send_equipment = {
	target = TAG
	equipment = infantry_equipment
	amount = 2000
	old_prioritised = yes
}
```

直接给库存并指定生产者：

```hoi4
TAG = {
	add_equipment_to_stockpile = {
		type = infantry_equipment_0
		amount = 500
		producer = JAP
	}
}
```

创建或授予编制：

```hoi4
TAG = {
	division_template = {
		name = "JAP Special Subject Infantry"
		division_names_group = JAP_INF_01
		regiments = {
			infantry = { x = 0 y = 0 }
			infantry = { x = 1 y = 0 }
			infantry = { x = 2 y = 0 }
		}
	}
}
```

单位生成只作为事件或兜底：

```hoi4
capital_scope = {
	create_unit = {
		division = "division_template = \"JAP Special Subject Infantry\" start_experience_factor = 0.3 start_equipment_factor = 0.5"
		owner = TAG
		count = 1
	}
}
```

限制指定模板数量：

```hoi4
set_division_template_cap = {
	division_template = "JAP Special Subject Infantry"
	division_cap = 6
}
```

风险点：

- `send_equipment` 消耗发送方库存，适合表现“日本援助”；直接 `add_equipment_to_stockpile` 更像脚本生成，需谨慎用于平衡。
- `producer = JAP` 能标记库存装备生产者，但不等于属国已经学会或会生产同款设计。
- `create_unit` 容易绕过训练、AI 和装备经济，不应成为新版属国系统主循环。
- `country_lock_all_division_template` 能锁训练，但新版方案不再以“全面禁止自训”为核心。

原版参考路径：

- `D:\SteamLibrary\steamapps\common\Hearts of Iron IV\common\national_focus\japan.txt`
- `D:\SteamLibrary\steamapps\common\Hearts of Iron IV\common\decisions\JAP.txt`
- `D:\SteamLibrary\steamapps\common\Hearts of Iron IV\events\SEA_Japan.txt`

## 装备设计与 AI 设计

用途：

- 让日本提供或影响高质量装备设计。
- 让特殊属国 AI 生产符合日本体系的飞机、舰船、坦克或其他装备。

推荐写法：

```hoi4
create_equipment_variant = {
	name = "JAP Subject Tank"
	type = light_tank_chassis_2
	parent_version = 0
	design_team = mio:JAP_mitsubishi_heavy_industries_organization
	modules = {
		main_armament_slot = tank_small_cannon
		turret_type_slot = tank_light_one_man_tank_turret
		suspension_type_slot = tank_christie_suspension
		armor_type_slot = tank_welded_armor
		engine_type_slot = tank_gasoline_engine
	}
	upgrades = {
		tank_nsb_engine_upgrade = 3
		tank_nsb_armor_upgrade = 2
	}
}
```

AI 装备设计应优先走 `common/ai_equipment/`：

```hoi4
JAP_rework_subject_tank_designs = {
	category = armor
	available_for = {
		MAN
	}
	roles = {
		armor
	}
	priority = {
		factor = 10
	}
}
```

风险点：

- `create_equipment_variant` 创建的是当前作用域国家的设计；“复制日本设计给属国”是否能直接表达，需要单独实测。
- `design_team = mio:xxx` 依赖目标国家能否使用对应 MIO 或设计团队；跨国使用尤其要谨慎。
- `common/ai_equipment` 负责 AI 设计方向，不能替代库存援助和模板解锁。
- 如果属国没有相关科技或模块，AI 设计可能被 `enable`、模块可用性或科技门槛卡住。

原版参考路径：

- `D:\SteamLibrary\steamapps\common\Hearts of Iron IV\common\national_focus\japan.txt`
- `D:\SteamLibrary\steamapps\common\Hearts of Iron IV\common\ai_equipment\_documentation.md`
- `D:\SteamLibrary\steamapps\common\Hearts of Iron IV\common\ai_equipment\JAP_tank.txt`
- `D:\SteamLibrary\steamapps\common\Hearts of Iron IV\common\ai_equipment\JAP_naval.txt`

## 轻量属国 AI

用途：

- 控制特殊属国基础生产、模板角色、装备比例和市场行为。
- 用高权重本系统 AI 稀释原版专属 AI 中会干扰属国体系的部分。

推荐入口：

```hoi4
JAP_rework_special_subject_basic_production = {
	allowed = {
		JAP_rework_is_special_subject = yes
	}
	enable = {
		always = yes
	}

	ai_strategy = {
		type = equipment_production_factor
		id = infantry
		value = 80
	}

	ai_strategy = {
		type = equipment_production_min_factories
		id = infantry
		value = 2
	}

	ai_strategy = {
		type = role_ratio
		id = infantry
		value = 80
	}

	ai_strategy = {
		type = template_prio
		id = infantry
		value = 100
	}
}
```

AI 模板入口：

```hoi4
JAP_rework_subject_infantry_templates = {
	available_for = {
		MAN
	}

	role = infantry

	upgrade_prio = {
		factor = 1
	}

	JAP_rework_subject_infantry_1 = {
		upgrade_prio = { factor = 1 }
		target_template = {
			support = {
				engineer = 1
				anti_air = 1
			}
			regiments = {
				infantry = 6
			}
		}
	}
}
```

风险点：

- `role_ratio` 决定 AI 想要多少某角色师，AI 模板决定这些师长什么样；两者需要成套维护。
- `equipment_production_min_factories` 会强制最低工厂，原版文档提醒它不考虑国家实际可用工厂，属国小国要特别保守。
- `template_prio` 和 AI 模板优先级不应只堆高数值，还要检查目标 tag 是否仍被原版/专属 AI 文件覆盖。
- `blocked_for` 与 `available_for` 不应同时乱用；AI 模板文档提示同一 role 最好每个国家只落到一套 role-level 模板。
- 高权重稀释原版 AI 是设计方向，不是已验证的完全屏蔽方案。

原版参考路径：

- `D:\SteamLibrary\steamapps\common\Hearts of Iron IV\common\ai_strategy\_documentation.md`
- `D:\SteamLibrary\steamapps\common\Hearts of Iron IV\common\ai_strategy\USA.txt`
- `D:\SteamLibrary\steamapps\common\Hearts of Iron IV\common\ai_templates\_documentation.md`
- `D:\SteamLibrary\steamapps\common\Hearts of Iron IV\common\ai_templates\generic.txt`
- `D:\SteamLibrary\steamapps\common\Hearts of Iron IV\common\ai_templates\templates_JAP.txt`

## 数组

用途：

- 临时记录运行时目标国家、目标州、战争中已处理对象。
- 支持复杂地盘整理或多步事件链。

推荐写法：

```hoi4
clear_array = ROOT.JAP_rework_subject_transfer_states

every_collection_element = {
	input = collection:JAP_rework_korea_subject_controlled_states
	ROOT = {
		add_to_array = {
			array = JAP_rework_subject_transfer_states
			value = PREV
		}
	}
}

for_each_scope_loop = {
	array = ROOT.JAP_rework_subject_transfer_states
	transfer_state_to = TAG
}

clear_array = ROOT.JAP_rework_subject_transfer_states
```

如果只是检查数组成员，可参考：

```hoi4
every_state = {
	limit = {
		is_in_array = {
			array = ROOT.JAP_rework_subject_transfer_states
			value = THIS
		}
	}
	add_claim_by = ROOT
}
```

风险点：

- 固定规划疆域不应优先用数组维护；`state_groups`/collection 更适合长期静态疆域。
- 数组适合运行时临时列表，使用后应 `clear_array`，避免存档残留。
- `THIS`、`PREV`、`ROOT` 在数组循环中很容易错位，必须从相邻原版样例确认作用域。
- 如果只需要“控制了几个规划州”，优先用 `collection_size`，不要为了计数而手写数组。

原版参考路径：

- `D:\SteamLibrary\steamapps\common\Hearts of Iron IV\events\AAT_Finland.txt`
- `D:\SteamLibrary\steamapps\common\Hearts of Iron IV\common\decisions\JAP.txt`
- `D:\SteamLibrary\steamapps\common\Hearts of Iron IV\events\TAOG_Siam.txt`

## 首版实现建议

1. 先实现一个特殊自治等级和一个 scripted trigger，验证 `has_autonomy_state`、显示名和升降级锁定。
2. 再实现一个测试属国的初始化 scripted effect：设自治等级、外观标签、清理旧状态、挂动态修正、设初始化 flag。
3. 规划疆域先选一个小目标，用 `state_groups` + collection + 固定半数阈值写决议可用条件。
4. 积分先只做国家变量，等月度结算和 UI 稳定后再扩展全局联合变量。
5. 轻量 AI 首版只处理步兵生产和 infantry role ratio，确认不会被原版专属 AI 明显覆盖后再加入装甲、海军和市场控制。
6. 装备援助首版只做 `send_equipment` 或少量 `add_equipment_to_stockpile`，不要同时引入设计复制、舰船授予和自动模板升级。
