# AI 战争策略参考（war_strategy：前线控制、登陆与区域守卫）

> 目的：作为 `war_strategy` / 战争策略参考的主入口，快速查 `common/ai_strategy/*.txt` 里前线、登陆、区域守卫、预备队相关策略怎么写，以及如何参考羊头 AI 的实战结构。
>
> 核对来源：
>
> - 原版 `common/ai_strategy/_documentation.md`
> - 原版 `JAP.txt`、`ENG.txt`、`USA.txt`、`CHI.txt`、`GER.txt`
> - 羊头 `common/ai_strategy/UK_home_island.txt`
> - 羊头 `common/ai_strategy/d_day_invasion_plan.txt`
> - 羊头 `common/ai_strategy/home_island_invasion_plan.txt`
> - 羊头 `common/ai_strategy/frontline_consideration.txt`
> - 羊头 `common/ai_areas/` 与 `common/scripted_triggers/AI_scripted_triggers.txt`

## 路线专项参考

本文件是战争 AI 的通用语法与数值口径入口。路线专项旧条目梳理放在独立 reference 中：

- 皇道派军事 AI：`common/ai_strategy/AI_Strategy_Reference/JAP_kodoha_war_strategy_reference.md`
- 皇道派中国战后 AI 区域计划：`common/ai_strategy/AI_Strategy_Reference/JAP_kodoha_post_china_ai_area_plan.md`

处理皇道派 `Jap_rework_kodoha_mil.txt` 时，先用本文确认通用语法，再用皇道派 reference 查当前条目内容、目标州、登陆 flag 链和 `front_control priority` 梯子。
处理皇道派吞并中国后的同盟国/共产国际战争策略时，先用中国战后 AI 区域计划确认 area 拆分，再写 `area_priority`、`put_unit_buffers`、`front_unit_request` 和 `front_control`。

## 第一部分：语法大纲

### 1. 策略块骨架

```txt
my_strategy = {
	allowed = {
		original_tag = JAP
	}

	enable = {
		has_war = yes
	}

	abort_when_not_enabled = yes

	ai_strategy = {
		type = area_priority
		id = asia
		value = 20
	}
}
```

基础规则：

- `allowed`：静态筛选。常放 `tag`、`original_tag`、DLC、路线大类。
- `enable`：动态启用。常放战争、日期、焦点、flag、state 控制、国家状态。
- `abort_when_not_enabled = yes`：`enable` 不成立时自动停用，普通策略优先用它。
- `abort = { ... }`：复杂战役的明确结束条件，例如目标已占领、国家投降、日期过期。
- 一个策略块可以包含多个 `ai_strategy`，通常按“区域偏好 -> 兵力需求 -> 执行控制 -> 预备队”排列。

### 2. 通用目标选择器

许多前线类策略都支持这些目标字段：

```txt
tag = CHI
state = 613
strategic_region = 247
area = asia
country_trigger = { tag = CHI }
state_trigger = { is_on_continent = asia }
```

建议：

- 单一国家前线：用 `tag = TAG`。
- 单一州目标：用 `state = <state id>`。
- 战区目标：用 `area = <ai area key>`。
- 一组国家：用 `country_trigger`。
- 一组州：用 `state_trigger`。
- 新写 `front_control` / `front_unit_request` 时，不优先用 `id = TAG`。部分旧文件或羊头文件里有这种遗留写法，但原版文档推荐的是上面的目标字段。

### 3. `area_priority`

作用：改变 AI 对某个 AI area 的战略兴趣。

```txt
ai_strategy = {
	type = area_priority
	id = asia
	value = 20
}
```

参数：

| 参数 | 含义 |
| --- | --- |
| `id` | `common/ai_areas/*.txt` 里的 area key |
| `value` | 区域优先级修正 |

选值：

| 目的 | 建议值 |
| --- | ---: |
| 轻微关注 | `5` 到 `15` |
| 明显关注 | `20` 到 `30` |
| 战役主方向 | `40` 到 `60` |
| 短期危机或终局单向强拉 | `80` 到 `100`，慎用 |
| 压低无关方向 | `-20` 到 `-100` |

用法：

- 它解决“去哪儿”，不解决“派多少兵”。
- 通常配合 `front_unit_request` 或 `invasion_unit_request`。
- 按菜鸟意大利的经验，常态多线作战不靠高 `area_priority` 抢权重，而是靠本地兵池和小额 request。新写策略先从 `10` 到 `30` 试，多个战区不要同时写到 `50+`。
- 写之前先确认 area key 存在。羊头有自定义 `JAP_home_islands`、`all_mainland_europe` 等，本项目不会自动拥有这些 key。

### 4. `front_unit_request`

作用：增加或减少陆上前线的部队需求。

```txt
ai_strategy = {
	type = front_unit_request
	tag = CHI
	value = 20
}
```

参数：

| 参数 | 含义 |
| --- | --- |
| `tag` / `state` / `area` / `country_trigger` / `state_trigger` | 目标前线 |
| `value` | 对该目标前线的需求修正 |

选值：

| 目的 | 建议值 |
| --- | ---: |
| 轻微加兵 | `3` 到 `10` |
| 局部加兵 | `10` 到 `30` |
| 主要方向 | `30` 到 `50` |
| 短期危机或单一决战 | `50` 到 `80`，慎用 |
| 降低需求 | `-20` 到 `-100` |
| 强烈排除或释放需求 | `-1000` / `-9999`，只适合短期强制窗口 |

示例：

```txt
ai_strategy = {
	type = front_unit_request
	country_trigger = {
		OR = {
			tag = CHI
			tag = PRC
			tag = SHX
			tag = XSM
			tag = YUN
			tag = GXC
		}
	}
	value = 20
}
```

### 5. `invasion_unit_request`

作用：增加或减少登陆方向的部队需求。

```txt
ai_strategy = {
	type = invasion_unit_request
	state = 613 # 上海
	value = 100
}
```

参数：

| 参数 | 含义 |
| --- | --- |
| `tag` / `state` / `strategic_region` / `area` / `country_trigger` / `state_trigger` | 登陆目标 |
| `value` | 登陆方向需求修正 |

选值：

| 目的 | 建议值 |
| --- | ---: |
| 轻微登陆兴趣 | `3` 到 `20` |
| 明确登陆目标 | `40` 到 `120` |
| 强制战役登陆 | `200` 到 `500` |
| 压低登陆 | `-100` 到 `-500` |

注意：

- 它解决“登陆方向要兵”，不保证 AI 一定执行登陆。
- 原版日本上海登陆只给 `state = 613 # 上海` 加 `invasion_unit_request`，说明有时只补需求就够。
- 如果 AI 会造登陆计划但不执行，再考虑加 `front_control` 的 `ordertype = invasion`。

### 6. `front_control`

作用：控制已有前线或登陆 order 是否执行，以及执行风格。

```txt
ai_strategy = {
	type = front_control
	tag = CHI
	ratio = 0.25
	priority = 100
	ordertype = front
	execution_type = balanced
	execute_order = yes
	manual_attack = yes
}
```

参数：

| 参数 | 含义 |
| --- | --- |
| 目标字段 | `tag`、`state`、`area`、`country_trigger`、`state_trigger` 等 |
| `ratio` | 目标覆盖前线比例必须大于该值才适用 |
| `priority` | 多条 `front_control` 冲突时，高值覆盖低值 |
| `ordertype` | `front` 或 `invasion` |
| `execution_type` | `careful`、`balanced`、`rush`、`rush_weak` |
| `execute_order` | `yes` 执行 order，`no` 暂停 order |
| `manual_attack` | 是否允许局部手动攻击，主要对陆上前线有意义 |

`ratio` 解释：

- `ratio = 0`：几乎只要匹配目标就生效，常用于救火或短窗口强制执行。
- `ratio = 0.25`：目标覆盖一部分前线时生效，原版常见。
- `ratio = 0.7`：目标覆盖大段前线时才生效。

选值：

| 参数 | 常用范围 |
| --- | --- |
| `priority` 普通修正 | `50` 到 `200` |
| `priority` 危机救火 | `500` 到 `1000` |
| `priority` 极端强制 | `9999+`，慎用 |

注意：

- `front_control` 不会自动派兵，需要配合 `front_unit_request` 或 `invasion_unit_request`。
- 没有目标限制的 `front_control` 很危险，尤其是 `ordertype = invasion`。
- `execute_order = no` 是强工具，适合登陆节奏窗口或装备崩溃时暂停进攻。

### 7. `invade`

作用：提高或压低 AI 对某国发起海上入侵的评分。

```txt
ai_strategy = {
	type = invade
	id = JAP
	value = 300
}
```

参数：

| 参数 | 含义 |
| --- | --- |
| `id` | 目标国家 tag |
| `value` | 登陆目标评分修正 |

选值：

| 目的 | 建议值 |
| --- | ---: |
| 小幅鼓励 | `10` 到 `60` |
| 明确目标 | `100` 到 `300` |
| 强制方向 | `500+` |
| 避免登陆 | 负值 |

搭配：

- `invade` 决定“想不想登陆某国”。
- `invasion_unit_request` 决定“给登陆方向多少兵”。
- `naval_invasion_focus` 决定“整体是否更愿意搞登陆”。
- `front_control` 决定“已有登陆 order 是否执行”。

### 8. `naval_invasion_focus`

作用：提高整体海上入侵倾向。

```txt
ai_strategy = {
	type = naval_invasion_focus
	value = 50
}
```

选值：

| 目的 | 建议值 |
| --- | ---: |
| 轻微提高 | `10` 到 `30` |
| 明确登陆窗口 | `50` 到 `200` |
| 强行登陆阶段 | `400+`，慎用 |

注意：

- 这是全局倾向，不指定目标。
- 长期高值会让 AI 到处规划登陆。
- 更适合放在短期战役窗口。

### 9. `naval_invasion_dominance_weight`

作用：让 AI 海军更重视登陆路线制海。

```txt
ai_strategy = {
	type = naval_invasion_dominance_weight
	value = 30
}
```

适合：

- 上海、马来亚、菲律宾、夏威夷等跨海目标；
- 登陆需求已经明确，但海军不够配合时；
- 与 `invasion_unit_request` 同时使用。

### 10. `put_unit_buffers`

作用：在指定 states 附近保留一批预备队/守备队，这些部队可服务于指定 area 内的 orders。主战军区使用时，`put_unit_buffers` 属于战前/战役准备层，不应默认依赖 `controller = { has_war_with = ROOT }` 这类敌情；敌情更适合放在 `front_unit_request`、`front_control`、`invasion_unit_request` 和 `invade` 上。

```txt
ai_strategy = {
	type = put_unit_buffers
	order_id = 1001
	ratio = 0.15
	states = {
		125 # 东盎格利亚
		126 # 大伦敦区
	}
	area = europe
	subtract_invasions_from_need = yes
	subtract_fronts_from_need = no
}
```

参数：

| 参数 | 含义 |
| --- | --- |
| `ratio` | 按全国陆军规模计算的 buffer 比例 |
| `order_id` | 同 ID 的 buffer 共享需求池 |
| `states` | 预备队部署州 |
| `area` | buffer 服务的 AI area，可写多个 |
| `subtract_invasions_from_need` | 是否让 area 内登陆需求抵消部分 buffer 需求 |
| `subtract_fronts_from_need` | 是否让 area 内前线需求抵消部分 buffer 需求 |

选值：

| 目的 | 建议 `ratio` |
| --- | ---: |
| 常态本土守备 | `0.05` 到 `0.15` |
| 重要 staging 区 | `0.15` 到 `0.30` |
| 危机救火 | `0.30` 到 `0.70` |
| 羊头式极端集中 | `1.0+`，慎用 |

`subtract_*` 经验：

- `yes`：避免同一 area 内 order 和 buffer 重复索兵。
- `no`：buffer 更独立，更容易强行保留预备队。
- 羊头英国本土防御常用 `subtract_fronts_from_need = no`，目的是本土预备队不被已有前线抵消。

#### 菜鸟意大利多线经验：本地兵池 + 小额请求

来源参考：`rookie_ITA/common/ai_strategy/ITA.txt` 的北非和法国西岸支援逻辑。

菜鸟处理多线作战时，不是把每条前线的 `front_unit_request` 都拉高，而是先在关键战区放本地兵池，再用小额 request 激活本地战线。这样北非、巴尔干、法国西岸、本土不会互相抽兵。

数值参照：菜鸟意大利的局部作战常见 `front_unit_request = 10`、`20`、`30`，英国登陆巩固用到 `50`，只有埃塞俄比亚强制窗口、美国登陆这类单线硬推才出现 `200+` 或更极端值。它也没有用高 `area_priority` 替代本地兵池；移植到本项目时，`area_priority` 应只做方向辅助，不能当作主要调兵阀门。

核心拆法：

1. `put_unit_buffers`：先让兵待在目标战区附近；用路线、支点、关键目标未完成等战略条件启停。
2. `front_unit_request`：战时敌情出现后，只给小额增量。
3. `front_control`：战时控制这条战线是暂停、均衡推进，还是 rush。
4. 放弃战区时，同时把 buffer 清零，并给负数 `front_unit_request`。

经验修正：如果 `theater_clear` 被定义为“无交战敌情”，不要直接拿它阻止和平期主战 buffer；和平时当然没有敌情，但仍可能需要提前集结。主战 buffer 应使用“关键目标已由 ROOT/盟友控制”一类完成 trigger；清理 buffer、岛链守备和登陆后巩固仍可继续使用敌情或局部 needed trigger。

北非摘录，保留重点结构：

```txt
ai_strategy = {
	type = put_unit_buffers
	states = {
		448
		661
		451
		663
	}
	ratio = 0.15
	subtract_invasions_from_need = no
	subtract_fronts_from_need = yes
}

ai_strategy = {
	type = front_unit_request
	state_trigger = {
		is_in_array = { global.rookie_array_ITA_north_africa = THIS.id }
	}
	value = 20
}
```

这里的重点是 `ratio = 0.15` 加 `value = 20`：北非先有一批本地兵，前线再只补一个小需求。`subtract_fronts_from_need = yes` 让同一战区内已经上前线的兵抵扣 buffer 需求，避免“前线要兵 + buffer 再要兵”的双重吸兵。

菜鸟原码的北非 buffer 没有显式写 `area`，主要靠 buffer 州和 `global.rookie_array_ITA_north_africa` 限定范围。移植到本项目时，建议写得更明确：buffer 的 `area`、`front_unit_request` 的目标范围、`front_control` 的目标范围尽量指向同一个 AI area 或同一组州。这样 `subtract_fronts_from_need = yes` 才能稳定服务“本地兵池”，避免 request 从别的战场抽兵。

北非等待海军优势时，菜鸟用 `front_control` 暂停进攻：

```txt
ai_strategy = {
	type = front_control
	state_trigger = {
		is_in_array = { global.rookie_array_ITA_north_africa = THIS.id }
	}
	ordertype = front
	execution_type = balanced
	manual_attack = no
	execute_order = no
	ratio = 0
}
```

条件成熟后再切到进攻：

```txt
ai_strategy = {
	type = front_control
	state_trigger = {
		is_in_array = { global.rookie_array_ITA_north_africa = THIS.id }
	}
	ordertype = front
	execution_type = balanced
	manual_attack = yes
	execute_order = yes
	ratio = 0.25
}
```

如果海军崩溃、投降进度升高，或北非不值得守，菜鸟会释放需求：

```txt
ai_strategy = {
	type = put_unit_buffers
	ratio = 0
	subtract_invasions_from_need = no
	subtract_fronts_from_need = yes
}

ai_strategy = {
	type = front_unit_request
	state_trigger = {
		is_in_array = { global.rookie_array_ITA_north_africa = THIS.id }
	}
	value = -50
}
```

可迁移到日本的原则：

- 中国、缅甸、南方资源区、太平洋岛链、本土应拆成不同本地兵池。
- 有连续陆上前线的战区，优先用 `subtract_fronts_from_need = yes`，避免重复索兵。
- 只有明确需要后方独立预备队时，才考虑 `subtract_fronts_from_need = no`。
- 多线局部调兵的 `front_unit_request` 可以很小，常见从 `3` 到 `20` 起步；`30` 已经能表达明显局部倾向，`50+` 应留给真正主战场、危机或单一决战窗口，`100+` 不作为常态模板。
- `front_control` 不负责调兵，只负责当前 order 的执行方式；调兵靠 buffer、request 和 area/target 对齐。
- 停用或放弃战区时，要同时清空 buffer 和压低 request，避免旧需求继续吸兵。

### 11. `garrison`

作用：调整总体守备倾向。

```txt
ai_strategy = {
	type = garrison
	value = 50
}
```

选值：

| 目的 | 建议值 |
| --- | ---: |
| 轻微加强守备 | `25` 到 `50` |
| 明显加强守备 | `100` 到 `300` |
| 压低守备释放部队 | `-50` 到 `-500` |
| 羊头式释放全部兵力 | `-9999`，只适合短期强制窗口 |

注意：

- 它不是占领区镇压模板。
- 它不能指定守某个 state。
- 具体州守备用 `put_unit_buffers`。

### 12. `theatre_distribution_demand_increase`

作用：提高包含指定 state 的 theatre 对部队的需求。

```txt
ai_strategy = {
	type = theatre_distribution_demand_increase
	id = 126 # 大伦敦区
	value = 4
}
```

适合：

- 已有 theatre 分配逻辑，但想把部队再往某个核心 theatre 拉一点；
- 本土救火；
- 登陆场巩固。

### 13. 盟友边境：`force_defend_ally_borders` / `dont_defend_ally_borders`

作用：控制 AI 是否协防盟友边境。

```txt
ai_strategy = {
	type = force_defend_ally_borders
	id = "ENG"
	value = 9999
}

ai_strategy = {
	type = dont_defend_ally_borders
	target = asia
	value = 500
}
```

用法：

- `force_defend_ally_borders`：把盟友拉去守某国或某区域。
- `dont_defend_ally_borders`：压低不重要区域的盟友协防。
- 羊头常用它们把英美盟友从亚洲、非洲、美洲等次要方向拉回英国本土或欧洲。

### 14. 集中突破与装甲分配

相关类型：

- `force_concentration_factor`
- `force_concentration_front_factor`
- `force_concentration_target_weight`
- `front_armor_score`

用途：

- `front_control` 解决“打不打、怎么打”。
- `force_concentration_*` 解决“集中力量打哪里”。
- `front_armor_score` 提高装甲或进攻模板去某方向的倾向。

示意：

```txt
ai_strategy = {
	type = force_concentration_target_weight
	state = 15 # 诺曼底
	value = 80
}

ai_strategy = {
	type = front_armor_score
	id = "ROM"
	value = 50
}
```

## 第二部分：羊头实战用例与仿照指南

### 1. 英国本土防御：分层守备，而不是一个常驻值

来源：羊头 `UK_home_island.txt`

代表思路：

- 英国还没被打穿：用 `put_unit_buffers` 在英格兰南部和内陆保留兵力。
- 英国出现投降进度：盟友也启用本土救火策略。
- 危机时叠加 `force_defend_ally_borders`、`area_priority`、`front_unit_request`、`front_control`、`theatre_distribution_demand_increase`。
- 用 `garrison = -9999` 释放 AI 的普通守备倾向，让部队集中到英国本土战场。

简化结构：

```txt
ENG_home_guard_is_cool_others_minor = {
	enable = {
		NOT = { tag = ENG }
		is_in_faction_with = ENG
		ENG = { surrender_progress > 0 }
		is_major = no
	}

	abort_when_not_enabled = yes

	ai_strategy = {
		type = put_unit_buffers
		states = {
			125 # 东盎格利亚
			126 # 大伦敦区
			127 # 萨塞克斯
			130
			123
		}
		ratio = 0.2
		area = europe
		subtract_invasions_from_need = yes
		subtract_fronts_from_need = no
	}

	ai_strategy = {
		type = force_defend_ally_borders
		value = 9999
		id = "ENG"
	}

	ai_strategy = {
		type = area_priority
		id = UK
		value = 30
	}

	ai_strategy = {
		type = front_unit_request
		state_trigger = { is_core_of = ENG }
		value = 20
	}

	ai_strategy = {
		type = front_control
		state_trigger = { is_core_of = ENG }
		area = UK_excluding_ni
		priority = 99999
		ratio = 0
		ordertype = front
		execution_type = rush
		execute_order = yes
		manual_attack = yes
	}
}
```

编程思想：

- 本土防御分“平时、危险、被登陆、盟友救火”多个层级。
- 每层只解决一个清晰状态，不要一个策略块包打天下。
- 危机层可以用高 `priority`，常态层不要用。
- `put_unit_buffers` 负责“先把兵留在附近”，`front_control` 负责“真打进来时立刻反推”。

仿照日本：

- 常态：东京、硫磺岛、塞班岛、冲绳等做低比例 buffer。
- 危险：敌方控制日本本土附近岛链或本土有投降进度时，提高本土 area priority。
- 被登陆：对 `is_core_of = JAP` 的 state 使用高优先级 `front_control`，并提高 theatre demand。

### 2. D-Day 登陆场救火：短窗口强推，而不是永久 rush

来源：羊头 `d_day_invasion_plan.txt`

代表思路：

- `on_naval_invasion` 给刚登陆的州打 `landing_priority` state flag。
- AI strategy 检查 `landing_priority_boost` country flag 和 `landing_priority` state flag。
- 只在短时间窗口内提高登陆点和邻近州的 `front_control` 与 `front_unit_request`。

简化结构：

```txt
allies_tryhard_landing_in_italy = {
	enable = {
		OR = {
			is_in_faction_with = ENG
			is_in_faction_with = USA
		}
		has_country_flag = {
			flag = landing_priority_boost
			days < 60
		}
		set_temp_variable = { aggro_days_small = global.num_days }
		modulo_temp_variable = { aggro_days_small = 15 }
		check_variable = { aggro_days_small < 10 }
	}

	abort_when_not_enabled = yes

	ai_strategy = {
		type = front_control
		country_trigger = {
			has_war_with = FROM
			capital_scope = { is_on_continent = europe }
		}
		state_trigger = {
			OR = {
				has_state_flag = landing_priority
				any_neighbor_state = { has_state_flag = landing_priority }
			}
		}
		ratio = 0
		priority = 700
		ordertype = front
		execution_type = rush
		execute_order = yes
	}

	ai_strategy = {
		type = front_unit_request
		state_trigger = {
			OR = {
				has_state_flag = landing_priority
				any_neighbor_state = { has_state_flag = landing_priority }
			}
		}
		value = 3
	}
}
```

编程思想：

- 登陆场最危险的是刚上岸的几十天，所以用 flag + days 限制。
- `front_control` 只对登陆州和邻近州生效，避免全欧洲乱 rush。
- `global.num_days` 取模制造“进攻脉冲”，避免 AI 永久高强度进攻。
- `value = 3` 看起来小，但这里是补强登陆点，不是替代整场战争的主需求。
- 登陆后推进要按目标体量分级：小岛可以不打 `landing_priority`、不推邻州；较大岛屿只给小额短窗口；大陆、多州岛或关键陆战区才使用高额 request 和 `priority = 700`。

仿照日本：

- 日本登陆上海、马来亚、菲律宾后，可以给目标州或邻近州打短期 `landing_priority` flag。
- flag 存续期内对该州加 `front_unit_request` 和 `rush`。
- 站稳后切到普通陆上前线策略，停止重复登陆。
- 日本太平洋小岛登陆不应照搬大陆桥头堡模板；硫磺岛、威克岛、中途岛一类小岛只靠岛链守备，台湾/菲律宾主节点才给小额 followup。

### 3. 登陆日本本土：先关节奏，再开终局目标

来源：羊头 `home_island_invasion_plan.txt`

代表思路：

- 英美对日终局不是一直无脑登陆。
- 先用周期窗口控制 `front_control`，让登陆 order 不在所有时间都执行。
- 进入日本终局后，再提高日本本土登陆需求、亚洲和日本本土 area priority、对日 `invade`。
- 另有建设策略，在浙江、上海、京畿等前进基地修海军基地，为登陆服务。

节奏控制：

```txt
ENG_USA_sync_wave_on_japan = {
	enable = {
		is_historical_focus_on = yes
		is_in_faction_with = ENG
		has_war_with = JAP
		set_temp_variable = { days = global.num_days }
		modulo_temp_variable = { days = 180 }
		check_variable = { days < 60 }
	}

	abort_when_not_enabled = yes

	ai_strategy = {
		type = front_control
		area = JAP_home_islands
		ordertype = invasion
		execute_order = no
	}
}
```

终局目标：

```txt
ENG_USA_sync_wave_on_japan_endsieg = {
	enable = {
		is_in_faction_with = ENG
		has_war_with = JAP
		is_japanese_endsieg = yes
	}

	abort_when_not_enabled = yes

	ai_strategy = {
		type = invasion_unit_request
		area = home_islands
		value = 100
	}

	ai_strategy = {
		type = area_priority
		id = home_islands
		value = 40
	}

	ai_strategy = {
		type = invade
		id = JAP
		value = 300
	}
}
```

编程思想：

- 大型登陆要区分“准备、执行、暂停、终局”。
- `execute_order = no` 不只是禁止，也可以用来制造节奏。
- `invasion_unit_request + area_priority + invade` 是登陆终局的三件套。
- 如果登陆距离远，先准备港口、机场、补给点，比只加登陆权重更稳定。

仿照日本：

- 对太平洋岛链可以按阶段写：越南 -> 马来亚 -> 爪哇 -> 菲律宾 -> 关岛 -> 夏威夷。
- 每阶段用目标 state 控制 `enable` / `abort`。
- 不要所有目标同时加 `invasion_unit_request = 500`，否则 AI 会分裂登陆计划。

### 4. 装备不足降速：让 AI 知道什么时候别送

来源：羊头 `frontline_consideration.txt`

代表思路：

- 根据步兵装备库存分三档。
- 装备少：全线 `careful`。
- 装备极少：`execute_order = no`，暂时停止推进。
- 装备恢复后自动 abort。

简化结构：

```txt
going_slow = {
	enable = {
		has_global_flag = is_active
		has_equipment = { infantry_equipment < 500 }
	}
	abort = {
		has_equipment = { infantry_equipment > 2000 }
	}

	ai_strategy = {
		type = front_control
		country_trigger = {
			has_war_with = FROM
		}
		ratio = 0
		priority = 500
		ordertype = front
		execution_type = careful
	}
}

going_rslow = {
	enable = {
		has_global_flag = is_active
		has_equipment = { infantry_equipment < -8000 }
	}
	abort = {
		has_equipment = { infantry_equipment > 500 }
	}

	ai_strategy = {
		type = front_control
		country_trigger = {
			has_war_with = FROM
		}
		ratio = 0
		priority = 1299
		ordertype = front
		execution_type = careful
		execute_order = no
	}
}
```

编程思想：

- AI strategy 不只用来增强 AI，也可以用来踩刹车。
- 条件应有滞后区间：启用 `< 500`，恢复 `> 2000`，避免反复抖动。
- 高优先级暂停策略要比普通进攻策略优先级更高。
- 对日本尤其适合用在多线战争、补给崩坏、步枪缺口扩大时。

仿照日本：

- 对中国战场：装备正常时 `balanced`，装备低时 `careful`。
- 对苏联边境：装备低时直接 `execute_order = no`，保留防线。
- 对登陆战役：装备低时暂停新登陆，不要把海军陆战队消耗在失败登陆里。

### 5. 羊头的通用编程思想

#### 先造 area，再写策略

羊头自定义了很多更细的 AI area，例如：

- `all_mainland_europe`
- `mainland_europe_excluding_italy`
- `very_bad_area_to_naval_invade`
- `western_front`
- `JAP_home_islands`
- `northern_china_landing_zone`

仿照指南：

1. 先把战区切细。
2. 每个 AI strategy 尽量指向 area，而不是到处散写 state。
3. 只有登陆点、防守点、建设点才直接写 state。

#### 复杂条件放 scripted triggers

羊头把大条件写成：

- `is_prepping_d_day`
- `d_day_secured`
- `home_island_britain_defense_condition`
- `home_island_others_defense_condition`
- `is_japanese_endsieg`

仿照指南：

```txt
JAP_ai_should_defend_home_islands = {
	# 本土危险、敌方接近、投降进度、战争状态等集中放这里
}

JAP_ai_should_stage_pacific_invasion = {
	# 太平洋登陆准备条件集中放这里
}
```

这样 AI strategy 文件只负责写策略效果，条件维护放 scripted triggers。

#### 用阶段，而不是一个永久策略

一个登陆或前线战役可以拆成：

1. 准备：建设港口、机场，放 buffer。
2. 集结：`put_unit_buffers`、`invasion_unit_request`。
3. 发起：`invade`、`naval_invasion_focus`、`front_control ordertype = invasion`。
4. 巩固：登陆州 `front_unit_request`、短期 `rush`。
5. 转常规前线：`area_priority`、普通 `front_unit_request`。
6. 收尾停用：目标州已控制、敌国投降、日期过期。

#### 数值先保守，再加码

羊头常见极端值：

- `garrison = -9999`
- `priority = 99999`
- `force_defend_ally_borders = 9999`
- `ratio = 1.0+`

学习结构，不要直接学习数值。按菜鸟意大利的低值口径，普通日本 AI 建议从这些值起步：

- `area_priority`：`10` 到 `30`；`50+` 只给单一主方向或短期危机
- `front_unit_request`：`10` 到 `30`；`50` 已经是主要方向，`80+` 只给短期强制窗口
- `invasion_unit_request`：`40` 到 `120`
- `front_control priority`：`100` 到 `300`
- 危机救火 `priority`：`500` 到 `1000`
- `put_unit_buffers ratio`：`0.08` 到 `0.25`

### 6. 日本 AI 可直接仿照的模板

#### 本土常态防御

```txt
JAP_home_defense_base = {
	allowed = { original_tag = JAP }
	enable = { has_war = yes }
	abort_when_not_enabled = yes

	ai_strategy = {
		type = put_unit_buffers
		order_id = 1001
		ratio = 0.12
		states = {
			671 # 东京
			645 # 硫磺岛
			646 # 塞班岛
		}
		area = japan
		subtract_invasions_from_need = yes
		subtract_fronts_from_need = no
	}

	ai_strategy = {
		type = garrison
		value = 25
	}
}
```

#### 中国主战场

```txt
JAP_china_front_main = {
	allowed = { original_tag = JAP }
	enable = {
		OR = {
			has_war_with = CHI
			has_war_with = PRC
			has_war_with = SHX
			has_war_with = XSM
			has_war_with = YUN
			has_war_with = GXC
		}
	}
	abort_when_not_enabled = yes

	ai_strategy = {
		type = front_unit_request
		country_trigger = {
			OR = {
				tag = CHI
				tag = PRC
				tag = SHX
				tag = XSM
				tag = YUN
				tag = GXC
			}
		}
		value = 40
	}

	ai_strategy = {
		type = front_control
		country_trigger = {
			OR = {
				tag = CHI
				tag = PRC
				tag = SHX
				tag = XSM
				tag = YUN
				tag = GXC
			}
		}
		ratio = 0.25
		priority = 150
		ordertype = front
		execution_type = balanced
		execute_order = yes
		manual_attack = yes
	}
}
```

#### 上海登陆

```txt
JAP_shanghai_landing_request = {
	allowed = { original_tag = JAP }
	enable = {
		has_war_with = CHI
		613 = { # 上海
			state_is_fully_controlled_by_ROOT_or_subject = no
		}
	}
	abort_when_not_enabled = yes

	ai_strategy = {
		type = invasion_unit_request
		state = 613 # 上海
		value = 100
	}

	ai_strategy = {
		type = naval_invasion_dominance_weight
		value = 30
	}
}
```

#### 装备不足时降速

```txt
JAP_low_equipment_slow_fronts = {
	allowed = { original_tag = JAP }
	enable = {
		has_war = yes
		has_equipment = { infantry_equipment < 500 }
	}
	abort = {
		has_equipment = { infantry_equipment > 2000 }
	}

	ai_strategy = {
		type = front_control
		country_trigger = {
			has_war_with = FROM
		}
		ratio = 0
		priority = 500
		ordertype = front
		execution_type = careful
	}
}
```

## 最小检查清单

写完一条前线/登陆/守备 AI strategy 后，按这个顺序检查：

1. `allowed` 是否只放静态范围？
2. `enable` 是否包含足够明确的动态条件？
3. 是否有 `abort_when_not_enabled` 或 `abort`？
4. 目标字段是否过宽？
5. 是否先写了需求，再写执行控制？
6. `front_control` 有没有目标限制？
7. `execute_order = no` 是否只在短窗口或危机条件下启用？
8. `put_unit_buffers` 的 state 是否在预期情况下由自己或盟友控制？
9. area key 是否存在于当前项目或原版 `common/ai_areas/`？
10. 数值是否从中等值开始，而不是直接抄羊头极端值？
