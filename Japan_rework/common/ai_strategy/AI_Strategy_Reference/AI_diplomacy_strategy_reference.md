# AI 外交策略参考

> 目的：快速查 `common/ai_strategy/*.txt` 里外交 AI 怎么写，尤其是联盟、友好/敌对、保证独立、军事通行、互不侵犯、志愿军、租借、宣战倾向，以及如何参考羊头 AI 的实战结构。
>
> 核对来源：
>
> - 原版 `common/ai_strategy/_documentation.md`
> - 原版 `JAP.txt`、`USA.txt`、`FRA.txt`、`WTT_china_ai_strategies.txt`
> - 羊头 `common/ai_strategy/AI_alliance_clearance.txt`
> - 羊头 `common/ai_strategy/AI_alliance_avoidance.txt`
> - 羊头 `common/ai_strategy/LSM_opinion_strategy.txt`
> - 羊头 `common/ai_strategy/volunteer_his.txt`
> - 羊头 `common/ai_strategy/volunteer_nonhis.txt`
> - 羊头 `common/ai_strategy/aggressive_wargoal.txt`
> - 羊头 `common/ai_strategy/peace_in_the_world.txt`
> - 羊头 `JAP.txt`、`GER.txt`、`SOV.txt`、`USA.txt`
> - 本项目 `common/ai_strategy/Jap_rework_cm_dip.txt`

## 第一部分：总体写法

### 1. 先确定“谁对谁”

外交策略最容易错的是方向。

普通写法：

```txt
JAP_befriend_SOV = {
	allowed = {
		original_tag = JAP
	}
	enable = {
		has_government = communism
		SOV = { has_government = communism }
		NOT = { has_war_with = SOV }
	}
	abort_when_not_enabled = yes

	ai_strategy = {
		type = befriend
		id = SOV
		value = 300
	}
}
```

含义：

- `allowed` 和 `enable` 默认在当前 AI 国家作用域。
- `id = SOV` 是当前 AI 国家面对的外交目标。
- 上例是“日本 AI 对苏联增加友好倾向”。

建议：

- 单一国家对单一目标：优先用普通写法。
- 双方都需要配合时：写两条策略，一条给 A 对 B，一条给 B 对 A。
- 一组动态国家对固定国家，或者固定国家对一组动态国家：可以考虑 `reversed = yes`，但要先确认方向。

### 2. 策略块骨架

下面模板里的 `TARGET` 是占位符，实际写脚本时要换成真实国家 tag，例如 `SOV`、`PRC`、`GER`。

```txt
my_diplomacy_strategy = {
	allowed = {
		original_tag = JAP
	}

	enable = {
		has_war = no
		TARGET = {
			exists = yes
		}
	}

	abort_when_not_enabled = yes

	ai_strategy = {
		type = alliance
		id = TARGET
		value = 300
	}
}
```

基础规则：

- `allowed`：静态筛选，常放 `tag`、`original_tag`、路线大类、DLC、是否原始国家。
- `enable`：动态启用，常放意识形态、战争状态、焦点、国家 flag、威胁度、世界线。
- `abort_when_not_enabled = yes`：外交策略优先用这个，避免路线变化后旧倾向残留。
- `abort = { ... }`：只在需要更复杂的停止条件时使用。
- `ai_strategy`：可以一块内写多条，例如同时加 `alliance`、`befriend`、`support`、志愿军和租借倾向。

### 3. 羊头的文件分工

羊头不是把所有外交策略都塞进国家文件，而是按用途拆开：

| 文件 | 主要用途 |
| --- | --- |
| `AI_alliance_clearance.txt` | 正向联盟、路线兼容、互相靠拢 |
| `AI_alliance_avoidance.txt` | 阻止不合逻辑联盟、保证、阵营靠拢 |
| `LSM_opinion_strategy.txt` | 为国策或事件临时拉关系、军事通行、互不侵犯 |
| `volunteer_his.txt` / `volunteer_nonhis.txt` | 历史 / 非历史志愿军倾向 |
| `aggressive_wargoal.txt` | 强化宣战、准备战争、认为目标弱 |
| `peace_in_the_world.txt` | 临时压制宣战，避免过早开战 |
| `JAP.txt`、`GER.txt`、`SOV.txt`、`USA.txt` | 国家专用外交与战争节奏补丁 |

本项目如果继续扩展日共外交，可以保留现有 `Jap_rework_cm_dip.txt`，但建议把“参考说明”集中在本文件，实际策略按路线或国家分组。

## 第二部分：常用外交 `type`

### 1. `alliance`

作用：增加或降低 AI 与目标结盟、同阵营、接受/发起阵营合作的倾向。

```txt
ai_strategy = {
	type = alliance
	id = SOV
	value = 300
}
```

参数：

| 参数 | 含义 |
| --- | --- |
| `id` | 目标国家 tag |
| `value` | 结盟倾向修正 |

选值：

| 目的 | 羊头常见值 |
| --- | ---: |
| 轻度靠拢 | `200` 到 `300` |
| 明确想拉近 | `500` |
| 强烈结盟 | `2000` 到 `2500` |
| 几乎强推结盟 | `5000` |
| 阻止结盟 | `-200` 到 `-500` |
| 强力禁止结盟 | `-1000` 到 `-5000` |

用法：

- `alliance` 通常只影响当前 AI 对 `id` 的倾向。
- 如果目标也需要接受，最好写目标国的对应策略，或配合 `diplo_action_acceptance`。
- 羊头经常把正向拉盟和负向避盟分开写，方便后续排查。

示例：日共和苏联互相靠拢时，不只写日本对苏联，也写苏联对日本。

```txt
JAP_befriend_SOV = {
	allowed = { original_tag = JAP }
	enable = {
		has_government = communism
		SOV = { has_government = communism }
		NOT = { has_war_with = SOV }
	}
	abort_when_not_enabled = yes

	ai_strategy = {
		type = alliance
		id = SOV
		value = 300
	}
}

SOV_befriend_JAP = {
	allowed = { tag = SOV }
	enable = {
		has_government = communism
		JAP = { has_government = communism }
		NOT = { has_war_with = JAP }
	}
	abort_when_not_enabled = yes

	ai_strategy = {
		type = alliance
		id = JAP
		value = 300
	}
}
```

### 2. `befriend`

作用：让 AI 倾向改善关系、减少敌意、把目标视为友方。

```txt
ai_strategy = {
	type = befriend
	id = SOV
	value = 300
}
```

选值：

| 目的 | 建议值 |
| --- | ---: |
| 轻度友好 | `50` 到 `100` |
| 明确友好 | `200` 到 `500` |
| 为国策/路线强行友好 | `1000` |
| 禁止友好 | `-200` 到 `-500` |
| 强力切断友好 | `-2000` |

用法：

- `befriend` 适合外交氛围，不一定直接触发加入阵营。
- 需要具体外交动作时，用 `diplo_action_desire` 写 `target = improve_relation`、`military_access`、`non_aggression_pact` 等。
- 羊头常用 `befriend + alliance + diplo_action_desire` 组成一套“路线友好包”。

### 3. `support`

作用：让 AI 更愿意支持目标，常和志愿军、租借、保护一起使用。

```txt
ai_strategy = {
	type = support
	id = SOV
	value = 300
}
```

选值：

| 目的 | 建议值 |
| --- | ---: |
| 轻度支持 | `50` 到 `100` |
| 明确支持 | `200` 到 `500` |
| 强力支持 | `1000` |

用法：

- `support` 是泛支持，不等于一定送志愿军或租借。
- 如果要明确送志愿军，配合 `send_volunteers_desire`。
- 如果要明确租借，配合 `send_lend_lease_desire`。

### 4. `protect`

作用：让 AI 倾向保护目标，包括保证独立等行为。负值可以阻止保护/保证。

```txt
ai_strategy = {
	type = protect
	id = AST
	value = 200
}
```

负向示例：

```txt
ai_strategy = {
	type = protect
	id = USA
	value = -2500
}
```

选值：

| 目的 | 建议值 |
| --- | ---: |
| 轻度保护 | `100` |
| 明确保护 | `200` 到 `500` |
| 强力保护 | `1000` 以上 |
| 阻止保证/保护 | `-200` 到 `-500` |
| 强力禁止保证/保护 | `-2500` 到 `-5000` |

用法：

- 羊头用 `protect` 给美国对澳大利亚、英属印度等目标提供保护倾向。
- 也用负值防止某些国家乱保证或过早保护。
- 如果要指定“保证独立”这个外交动作，配合 `diplo_action_desire` 的 `target = guarantee`。

### 5. `diplo_action_desire`

作用：控制 AI 对某个具体外交动作的发起倾向。

```txt
ai_strategy = {
	type = diplo_action_desire
	id = SOV
	target = non_aggression_pact
	value = 2500
}
```

常见 `target`：

| `target` | 作用 |
| --- | --- |
| `improve_relation` | 改善关系 |
| `military_access` | 请求军事通行 |
| `non_aggression_pact` | 互不侵犯条约 |
| `guarantee` | 保证独立 |
| `declare_war` | 宣战外交动作倾向 |

选值：

| 目的 | 羊头常见值 |
| --- | ---: |
| 轻度关系动作 | `15` 到 `50` |
| 明确改善关系 | `50` 到 `100` |
| 明确请求军事通行 | `1000` |
| 明确互不侵犯 | `2500` |
| 强推动作 | `9999` |
| 阻止动作 | `-500` 到 `-5000` |
| 强力锁死宣战 | `-9999` 到 `-99999` |

用法：

- 新写具体外交动作时，建议总是写 `target = ...`。
- 当前项目里有不带 `target` 的 `diplo_action_acceptance`，这类更像宽泛兼容写法；新代码最好写具体目标，方便维护。
- 羊头在 `GER_SOV_avoid_war_GER` / `GER_SOV_avoid_war_SOV` 里同时写军事通行、互不侵犯、保证，形成完整的避战合作包。

### 6. `diplo_action_acceptance`

作用：控制 AI 接受某个具体外交动作的倾向。

```txt
ai_strategy = {
	type = diplo_action_acceptance
	id = GER
	target = military_access
	value = 1000
}
```

用法：

- `desire` 是“我想发起”，`acceptance` 是“我愿意接受”。
- 双方互动时，经常需要一边 `desire`、另一边 `acceptance`，或者双方都写。
- 对军事通行、互不侵犯这种双边动作，羊头常写：

```txt
ai_strategy = {
	type = diplo_action_acceptance
	id = SOV
	target = military_access
	value = 1000
}
ai_strategy = {
	type = diplo_action_desire
	id = SOV
	target = military_access
	value = 1000
}
ai_strategy = {
	type = diplo_action_desire
	id = SOV
	target = non_aggression_pact
	value = 2500
}
```

### 7. `send_volunteers_desire`

作用：控制 AI 向目标送志愿军的倾向。

```txt
ai_strategy = {
	type = send_volunteers_desire
	id = PRC
	value = 300
}
```

选值：

| 目的 | 建议值 |
| --- | ---: |
| 轻度愿意 | `50` 到 `100` |
| 明确愿意 | `300` 到 `500` |
| 强力送志愿军 | `1000` 到 `5000` |
| 不要送 | `-500` |
| 强力禁止送 | `-3333` 到 `-5000` |

用法：

- 这只是倾向，不绕过法律、外交距离、战争状态、阵营限制等机制。
- 羊头把历史与非历史志愿军拆成两个文件，方便不同世界线单独调值。
- 如果只是想“别帮某国”，直接对该目标给负值，通常比写复杂宣战逻辑更稳。

### 8. `send_lend_lease_desire`

作用：控制 AI 向目标发送租借的倾向。

```txt
ai_strategy = {
	type = send_lend_lease_desire
	id = SOV
	value = 300
}
```

选值：

| 目的 | 建议值 |
| --- | ---: |
| 轻度愿意 | `50` 到 `100` |
| 明确租借 | `300` 到 `500` |
| 强力租借 | `1000` 以上 |
| 阻止租借 | 负值 |

用法：

- 适合“友好但不一定同阵营”的支援关系。
- 和 `support`、`befriend`、`alliance` 可以组合。
- 注意 AI 仍需要有可租借装备和合适外交条件。

### 9. `antagonize`

作用：增加或降低 AI 对目标的敌意。

```txt
ai_strategy = {
	type = antagonize
	id = CHI
	value = 300
}
```

选值：

| 目的 | 建议值 |
| --- | ---: |
| 轻度敌对 | `100` 到 `300` |
| 明确敌对 | `500` 到 `1000` |
| 战争目标配套敌意 | `2500` |
| 强力敌意 | `6666` 到 `9999` |
| 压制敌意 | `-200` 到 `-500` |
| 强力压制敌意 | `-2000` |

用法：

- `antagonize` 不等于宣战。
- 推战争时通常配合 `conquer`、`declare_war`、`prepare_for_war`。
- 避战时可以给负值，并同时压 `declare_war`。

### 10. `conquer`

作用：让 AI 把目标视为征服对象。

```txt
ai_strategy = {
	type = conquer
	id = SOV
	value = 2500
}
```

用法：

- `conquer` 是战争方向，不一定立即宣战。
- 原版文档说明 `avoid_starting_wars` 会和 `conquer` 加性叠加。
- 推强制战争时，羊头常把 `conquer`、`antagonize`、`declare_war`、`prepare_for_war`、`consider_weak` 放在一组。

### 11. `declare_war`

作用：直接影响 AI 对目标宣战的权重。

```txt
ai_strategy = {
	type = declare_war
	id = SOV
	value = -9999
}
```

选值：

| 目的 | 建议值 |
| --- | ---: |
| 压制宣战 | `-500` 到 `-2000` |
| 强力禁止宣战 | `-5000` 到 `-99999` |
| 明确宣战 | `500` |
| 强力宣战 | `9999` |

用法：

- 羊头 `aggressive_wargoal.txt` 的注释使用 `value = 500` 作为“强制宣战”的阈值参考。
- 如果是“绝对别打”，羊头常同时写：

```txt
ai_strategy = {
	type = diplo_action_desire
	id = SOV
	target = declare_war
	value = -9999
}
ai_strategy = {
	type = declare_war
	id = SOV
	value = -9999
}
ai_strategy = {
	type = conquer
	id = SOV
	value = -200
}
```

### 12. `prepare_for_war`

作用：让 AI 为对目标作战做准备。

```txt
ai_strategy = {
	type = prepare_for_war
	id = POL
	value = 200
}
```

用法：

- 适合和 `antagonize`、`conquer`、`declare_war` 组合。
- 它更像战争前置心理准备，不单独负责宣战。

### 13. `consider_weak`

作用：让 AI 认为目标较弱，更敢打。

```txt
ai_strategy = {
	type = consider_weak
	id = POL
	value = 500
}
```

用法：

- 羊头在强制战争包里常用它帮助 AI 下决心。
- 不建议和平外交里滥用，否则可能导致 AI 不必要地冒进。

### 14. `contain`

作用：让 AI 遏制目标，常配合保护目标国、支援目标国。

```txt
ai_strategy = {
	type = contain
	id = JAP
	value = 200
}
```

用法：

- 羊头美国在日本威胁澳大利亚、英属印度时使用 `contain = JAP`，同时 `protect = AST/RAJ`。
- 适合“不是现在打你，但我要围堵你”的路线。

### 15. `avoid_starting_wars`

作用：降低 AI 主动开战倾向。

```txt
ai_strategy = {
	type = avoid_starting_wars
	value = -200
}
```

注意：

- 原版文档写法是无 `id`，并说明它会和 `conquer` 加性叠加。
- 羊头和本项目里能看到带 `id` 的写法，但新写时不要依赖它一定是目标定向策略，除非已经通过实测确认。
- 如果要阻止对某一国宣战，优先写 `declare_war = -9999`，必要时再加 `diplo_action_desire target = declare_war`。

### 16. `dont_join_wars_with`

作用：阻止或降低 AI 跟随某国加入战争。

```txt
ai_strategy = {
	type = dont_join_wars_with
	id = SOV
	value = 500
}
```

用法：

- 适合“先不要被盟友拖进战争”的路线。
- 本项目 `Jap_rework_cm_dip.txt` 里已有相关草稿注释，后续可以参考这个方向完善。
- 建议明确时间窗和结束条件，例如日期、焦点完成、目标已经参战。

### 17. `ignore` 与 `ignore_claim`

作用：降低 AI 对目标或目标宣称的关注。

```txt
ai_strategy = {
	type = ignore_claim
	id = LIT
	value = 500
}
```

用法：

- `ignore` 更泛，`ignore_claim` 更偏宣称争端。
- 羊头用它们处理波罗的、维希、和平期中立等不该被 AI 过度关注的对象。

## 第三部分：组合模板

### 1. 友好合作包

适合：同意识形态、同路线、短期合作但不一定马上同阵营。

```txt
JAP_cm_friend_target = {
	allowed = {
		original_tag = JAP
	}
	enable = {
		has_government = communism
		TARGET = {
			has_government = communism
			NOT = { has_war_with = JAP }
		}
	}
	abort_when_not_enabled = yes

	ai_strategy = {
		type = support
		id = TARGET
		value = 300
	}
	ai_strategy = {
		type = befriend
		id = TARGET
		value = 300
	}
	ai_strategy = {
		type = send_volunteers_desire
		id = TARGET
		value = 300
	}
	ai_strategy = {
		type = send_lend_lease_desire
		id = TARGET
		value = 300
	}
}
```

可选：

- 如果要入阵营，加 `alliance`。
- 如果要军事通行，加 `diplo_action_desire target = military_access`。
- 如果要互不侵犯，加 `diplo_action_desire target = non_aggression_pact`。

### 2. 双边军事通行 / 互不侵犯包

适合：暂时合作、避免误战、打通战区路线。

```txt
JAP_cm_access_with_target = {
	allowed = {
		original_tag = JAP
	}
	enable = {
		has_war = yes
		TARGET = {
			exists = yes
			NOT = { has_war_with = JAP }
		}
	}
	abort_when_not_enabled = yes

	ai_strategy = {
		type = diplo_action_acceptance
		id = TARGET
		target = military_access
		value = 1000
	}
	ai_strategy = {
		type = diplo_action_desire
		id = TARGET
		target = military_access
		value = 1000
	}
	ai_strategy = {
		type = diplo_action_desire
		id = TARGET
		target = non_aggression_pact
		value = 2500
	}
}
```

建议：

- 军事通行常用 `1000`。
- 互不侵犯常用 `2500`。
- 需要目标接受时，给目标也写一条镜像策略。

### 3. 联盟规避包

适合：阻止不合理阵营、阻止目标国乱保证、阻止跨路线乱抱团。

```txt
JAP_cm_avoid_bad_alliance = {
	allowed = {
		original_tag = JAP
	}
	enable = {
		has_government = communism
		TARGET = {
			has_government = fascism
		}
	}
	abort_when_not_enabled = yes

	ai_strategy = {
		type = alliance
		id = TARGET
		value = -1000
	}
	ai_strategy = {
		type = befriend
		id = TARGET
		value = -500
	}
	ai_strategy = {
		type = protect
		id = TARGET
		value = -500
	}
}
```

羊头经验：

- 小阻力用 `-200` 到 `-500`。
- 明确禁止用 `-1000`。
- 非常不该发生的阵营关系用 `-2000` 到 `-5000`。

### 4. 志愿军支援包

适合：不入阵营但帮忙打仗。

```txt
JAP_cm_send_volunteers_to_target = {
	allowed = {
		original_tag = JAP
	}
	enable = {
		has_government = communism
		TARGET = {
			has_war = yes
			NOT = { has_war_with = JAP }
		}
	}
	abort_when_not_enabled = yes

	ai_strategy = {
		type = support
		id = TARGET
		value = 300
	}
	ai_strategy = {
		type = send_volunteers_desire
		id = TARGET
		value = 300
	}
}
```

反向阻止：

```txt
ai_strategy = {
	type = send_volunteers_desire
	id = CHI
	value = -3333
}
```

建议：

- 只想表达“别帮某国”，用负值比复杂排除条件更直观。
- 但仍要在 `enable` 里限定路线和时间窗，避免永久副作用。

### 5. 宣战推进包

适合：确保 AI 在条件成熟后愿意打某个目标。

```txt
JAP_cm_attack_target = {
	allowed = {
		original_tag = JAP
	}
	enable = {
		has_government = communism
		TARGET = {
			exists = yes
			NOT = { has_war_with = JAP }
		}
	}
	abort_when_not_enabled = yes

	ai_strategy = {
		type = antagonize
		id = TARGET
		value = 2500
	}
	ai_strategy = {
		type = conquer
		id = TARGET
		value = 2500
	}
	ai_strategy = {
		type = prepare_for_war
		id = TARGET
		value = 200
	}
	ai_strategy = {
		type = declare_war
		id = TARGET
		value = 500
	}
}
```

建议：

- `declare_war = 500` 是羊头强推战争包中的常用参考值。
- 如果 AI 已有战争目标但不动，检查是否还缺 `antagonize`、`conquer`、`consider_weak`。
- 如果战争必须排队，先写宣战压制包，等前一个目标解决后再撤销。

### 6. 宣战压制包

适合：避免珍珠港太早、避免打完暹罗前乱开新战、避免大国过早互咬。

```txt
JAP_cm_do_not_attack_target_yet = {
	allowed = {
		original_tag = JAP
	}
	enable = {
		date < 1941.12.7
		TARGET = {
			exists = yes
		}
	}
	abort_when_not_enabled = yes

	ai_strategy = {
		type = declare_war
		id = TARGET
		value = -9999
	}
	ai_strategy = {
		type = diplo_action_desire
		id = TARGET
		target = declare_war
		value = -9999
	}
	ai_strategy = {
		type = antagonize
		id = TARGET
		value = -500
	}
	ai_strategy = {
		type = conquer
		id = TARGET
		value = -200
	}
}
```

羊头经验：

- `peace_in_the_world.txt` 会用很大的负值压宣战。
- 日本文件中也能看到先压美国、菲律宾、英属马来亚等目标，等日期或 flag 到了再放开。
- 压宣战时建议同时压 `declare_war` 和 `diplo_action_desire target = declare_war`，更不容易漏。

## 第四部分：`reversed = yes`

### 1. 它解决什么问题

`reversed = yes` 常用于“动态目标很多，但固定国家只有一个”的策略。

原版和羊头常见场景：

- 固定大国对一批国家提供支持。
- 固定国家不要给某批国家送志愿军。
- 一批国家根据自身条件，与固定国家形成关系。
- 目标筛选写在 `enable`，固定国家条件写在 `enable_reverse`。

典型结构：

```txt
USA_support_targets = {
	reversed = yes

	enable_reverse = {
		USA = {
			has_government = democratic
		}
	}

	enable = {
		NOT = { tag = USA }
		has_war = yes
		any_enemy_country = {
			has_government = fascism
		}
	}

	abort_when_not_enabled = yes

	ai_strategy = {
		type = support
		id = USA
		value = 100
	}
}
```

解释：

- `enable` 描述一批动态国家。
- `id = USA` 指向固定国家。
- `reversed = yes` 会让策略方向变成反向关系。
- 由于不同 `type` 的语义有方向差异，新写复杂外交时最好先仿照原版或羊头已有例子。

### 2. 本项目建议

优先级：

1. 单一国家对单一国家：普通写法。
2. 双方都要配合：写两条普通镜像策略。
3. 一组国家和固定国家互动：再考虑 `reversed = yes`。

写 `reversed = yes` 前先问：

- `enable` 是在谁身上判断？
- `id` 指向的是固定国家还是目标国家？
- 这条策略最终希望谁对谁产生倾向？
- 是否需要 `enable_reverse` 限定固定国家的状态？
- 是否已有原版或羊头同类型例子可抄结构？

## 第五部分：日共外交的实用建议

### 1. 友好不是一条策略能解决

如果目标是“日共和苏联/中共/德国/意大利暂时合作”，一般需要组合：

- `support`：泛支持。
- `befriend`：改善外交氛围。
- `alliance`：进入同阵营或拉盟倾向。
- `diplo_action_desire`：具体动作，例如军事通行、互不侵犯。
- `diplo_action_acceptance`：对方愿意接受。
- `send_volunteers_desire`：战争中送志愿军。
- `send_lend_lease_desire`：装备支援。

当前 `Jap_rework_cm_dip.txt` 已经在用这些方向，后续可以把缺少 `target` 的外交接受项补成更明确的动作。

### 2. 阻止错误目标也要成组写

如果目标是“德国/意大利别帮校长”或“日共处理暹罗前别打英法葡”，建议组合：

- 对错误目标 `send_volunteers_desire = -3333`。
- 对错误敌人 `declare_war = -9999`。
- 对错误敌人 `diplo_action_desire target = declare_war value = -9999`。
- 需要时压 `antagonize` 和 `conquer`。
- 用 `abort_when_not_enabled = yes` 或明确 `abort` 让压制在条件变化后消失。

### 3. 战争推进要和战争排队分开

羊头的思路通常是：

- 要打的目标：`antagonize + conquer + prepare_for_war + declare_war`。
- 暂时不要打的目标：`declare_war` 负值，必要时 `diplo_action_desire target = declare_war` 负值。
- 前一个目标结束后，压制策略自动失效，推进策略再生效。

这比让一个大策略同时处理所有战争节奏更好维护。

### 4. 注意 PP 浪费

改善关系、保证独立等外交动作会消耗政治点数。

当前项目已有：

```txt
ai_strategy = {
	type = pp_spend_priority
	id = relation
	value = -9999
}

ai_strategy = {
	type = pp_spend_priority
	id = guarantee
	value = -9999
}
```

如果新策略希望 AI 主动改善关系或保证独立，要确认这类 PP 限制是否会抵消你的外交策略。

## 第六部分：常见问题

### 1. 只写 `alliance` 但对方不进阵营

原因：

- 只推动了本国对目标的倾向。
- 对方没有接受倾向。
- 目标政府、路线、战争状态、阵营规则仍不允许。

处理：

- 给对方写镜像 `alliance`。
- 加 `diplo_action_acceptance`。
- 检查 `is_in_faction`、`is_faction_leader`、战争、意识形态、国策效果。

### 2. AI 仍然宣战

原因：

- 只压了 `antagonize`，但 `declare_war` 或 `conquer` 仍然很高。
- 其他文件里有更强的宣战推进。
- 事件、国策、决议直接给战争目标，不完全受 AI strategy 控制。

处理：

- 同时压 `declare_war`、`diplo_action_desire target = declare_war`、`conquer`。
- 用 `rg` 搜目标 tag 的 `declare_war`、`conquer`、`antagonize`。
- 检查国策和事件是否直接开战。

### 3. 志愿军不送

原因：

- `send_volunteers_desire` 只是倾向。
- 法律、世界紧张度、目标战争状态、距离、阵营、运输等条件不满足。
- 目标已经不需要或不能接收志愿军。

处理：

- 先确认目标正在战争中。
- 提高 `support` 和 `send_volunteers_desire`。
- 检查是否有其他文件给同目标负值。

### 4. `reversed = yes` 方向看不懂

处理：

- 优先不用 `reversed = yes`，写两条普通策略。
- 如果必须用，找原版或羊头同类型例子复制骨架。
- 在注释里写清楚“最终希望谁对谁产生倾向”。

### 5. `avoid_starting_wars` 要不要写 `id`

建议：

- 原版文档说它不需要 `id`，更像全局开战刹车。
- 如果是对单一目标刹车，优先用 `declare_war` 负值。
- 已有带 `id` 的旧写法不要急着删，但新写法不要把它当成主要目标定向工具。

## 第七部分：速查表

| 目标 | 推荐组合 |
| --- | --- |
| 让 A 友好 B | `befriend + support` |
| 让 A 想和 B 结盟 | `alliance`，必要时双方镜像 |
| 让 A 接受 B 的军事通行 | `diplo_action_acceptance target = military_access` |
| 让 A 主动要军事通行 | `diplo_action_desire target = military_access` |
| 让 A 和 B 互不侵犯 | `diplo_action_desire target = non_aggression_pact`，必要时双方写 |
| 让 A 保证 B | `protect` 或 `diplo_action_desire target = guarantee` |
| 阻止 A 保证 B | `protect` 负值，必要时 `target = guarantee` 负值 |
| 让 A 送志愿军给 B | `support + send_volunteers_desire` |
| 阻止 A 送志愿军给 B | `send_volunteers_desire` 负值 |
| 让 A 租借给 B | `support + send_lend_lease_desire` |
| 让 A 敌视 B | `antagonize` |
| 让 A 准备打 B | `antagonize + conquer + prepare_for_war` |
| 让 A 立即更想宣 B | `declare_war` 正值，强推可参考 `500+` |
| 阻止 A 宣 B | `declare_war` 负值 + `diplo_action_desire target = declare_war` 负值 |
| 阻止 A 被盟友拖进战争 | `dont_join_wars_with` |
| 避免 AI 全局乱开战 | `avoid_starting_wars` |
