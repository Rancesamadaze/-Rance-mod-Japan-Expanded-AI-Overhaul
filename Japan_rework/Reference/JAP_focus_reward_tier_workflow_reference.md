# 日本国策奖励分档调整工作流参考

> 适用场景：为日本国策奖励建立“削弱版 / 标准版”两档数值，并通过开局规则“重回巅峰”决定国策完成时采用哪一档奖励。

本文件用于把后续长期调整流程固定下来。具体国策数值可以慢慢改，但每次改动都应先判断奖励属于哪一类，再选择对应写法，避免把同一套分档逻辑散落成难以维护的临时分支。

## 核心设定

- 开局规则名称：`重回巅峰`
- 默认选项：`否`
- 默认效果：日本国策使用调整后的削弱版数值。
- 可选选项：`是`
- 可选效果：日本国策使用削弱前的标准数值。

建议把两档命名固定为：

- `reduced` / `削弱版`：默认档，开局规则选“否”时使用。
- `standard` / `标准版`：旧数值档，开局规则选“是 / 重回巅峰”时使用。

不要把 `standard` 理解为额外加强版。它只是恢复削弱前数值，除非后续某个国策明确另有设计说明。

## 涉及文件

### 游戏规则

- `common/game_rules/000_Rance_game_rules.txt`
- `localisation/simp_chinese/Rance_game_rules_l_simp_chinese.yml`

规则脚本保持 UTF-8 无 BOM，不直接写中文显示文本。行尾编辑既有文件时保留当前格式；新建文件再按目录规则使用 LF。本地化文件保持 UTF-8 with BOM，行尾同样优先保留既有格式。

### 规则检测

如果只在少数国策里使用，可以直接写 `has_game_rule`。如果会在大量国策、idea、事件或决议里复用，优先在以下文件增加 scripted trigger：

- `common/scripted_triggers/JAP_rework_scripted_triggers.txt`

建议的规则 key 与选项 key：

```txt
rance_japan_return_to_peak = {
	name = "RANCE_JAPAN_RETURN_TO_PEAK"
	desc = "RANCE_JAPAN_RETURN_TO_PEAK_DESC"
	group = "RULE_GROUP_RANCE_JAPAN_REWORK"

	default = {
		name = DISABLED
		text = "RULE_OPTION_RANCE_NO"
		desc = "RANCE_JAPAN_RETURN_TO_PEAK_DISABLED_DESC"
		allow_achievements = yes
	}

	option = {
		name = ENABLED
		text = "RULE_OPTION_RANCE_YES"
		desc = "RANCE_JAPAN_RETURN_TO_PEAK_ENABLED_DESC"
		allow_achievements = no
	}
}
```

建议的复用触发器只检测标准版是否开启。国策分支命中该 trigger 时走 `standard`，否则用 `else` 回退到 `reduced`，不要再额外检测削弱版：

```txt
Rance_jap_return_to_peak_standard = {
	custom_trigger_tooltip = {
		tooltip = Rance_jap_return_to_peak_standard.tt
		has_game_rule = {
			rule = rance_japan_return_to_peak
			option = ENABLED
		}
	}
}
```

如果后续担心旧存档、缺省规则或极端加载顺序，也继续只把 `standard` 作为显式分支，其他情况全部落入 `else` 的削弱版。

### 国策奖励

- `common/national_focus/japan.txt`

讨论或记录具体国策时，先用 UTF-8 读取 `Reference/focus_name.md`，并在台账里写出国策中文名，避免只靠内部 key 维护。

### Idea 奖励

优先按现有拆分放置：

- `common/ideas/JAP_hidden_ideas.txt`
- `common/ideas/JAP_rework_ideas.txt`
- `common/ideas/JAP_rework_law_idea.txt`
- `common/ideas/JAP_rework_decision_idea.txt`
- `common/ideas/japan.txt`

脚本 key 必须不同；如果设计上希望玩家看到“同名 idea”，可以让两个 idea 使用相同或等价的本地化显示名、描述和图片，而不是复用同一个内部 key。

### 动态修正奖励

常见位置：

- `common/scripted_effects/JAP_scripted_effects.txt`
- `common/dynamic_modifiers/zzz_japan_rework_dynamic_modifiers.txt`
- `Reference/JAP_add_or_modify_scripted_effect_reference.md`
- `Reference/variable_syntax_reference.md`

给动态修正追加变量奖励时，先调用对应 `JAP_add_or_modify_xxx = yes`，再按规则分支写不同变量数值。

## 奖励分类与写法

### 1. 直接给予效果

适合政治点、稳定度、战争支持度、科研槽、建筑、资源、部队、科技加成等一次性奖励。

推荐写法：

```txt
if = {
	limit = { Rance_jap_return_to_peak_standard = yes }
	add_political_power = 150
}
else = {
	add_political_power = 100
}
```

原则：

- 旧数值放在 `standard` 分支。
- 削弱后数值放在 `else` 分支。
- 如果 tooltip 因 `if / else` 变得难读，再考虑 `custom_effect_tooltip + hidden_effect`。

### 2. 通过 idea 给予

适合国策发放长期国家精神、隐藏 idea、法律型 idea 或决议辅助 idea 的情况。

推荐结构：

```txt
if = {
	limit = { Rance_jap_return_to_peak_standard = yes }
	add_ideas = JAP_example_spirit_standard
}
else = {
	add_ideas = JAP_example_spirit_reduced
}
```

维护规则：

- 两档 idea 使用不同内部 key，例如 `_standard` 与 `_reduced`。
- 若玩家界面不应感知为两个不同精神，本地化名称可以写成相同。
- 两档 idea 的 `picture`、`allowed_civil_war`、`removal_cost` 等基础结构保持一致，只有数值差异不同。
- 如果国策是升级或替换已有 idea，先查现有项目写法；可以使用 `swap_ideas` 或显式 `remove_ideas + add_ideas`，但不要让两档 idea 同时残留。

### 3. 通过动态修正变量给予

适合 `JAP_add_or_modify_xxx = yes` 后面跟随 `add_to_variable` 的奖励。

推荐结构：

```txt
custom_effect_tooltip = generic_skip_one_line_tt
JAP_add_or_modify_early_industrialization = yes
if = {
	limit = { Rance_jap_return_to_peak_standard = yes }
	add_to_variable = { JAP_industry_consumer_goods_factor = -0.05 tooltip = consumer_goods_factor_tt }
}
else = {
	add_to_variable = { JAP_industry_consumer_goods_factor = -0.03 tooltip = consumer_goods_factor_tt }
}
```

原则：

- 通常先调用一次 `JAP_add_or_modify_xxx = yes`，再分支变量数值。
- 不要只改 `add_to_variable` 而忘记动态修正本体可能尚未存在。
- 变量 key、tooltip key 和目标动态修正体系要匹配。
- 若两档不仅数值不同，而且目标动态修正体系不同，再把 `JAP_add_or_modify_xxx` 和变量写进同一个分支块内。

### 4. 其他可能情况

#### 国策时间联动

涉及 `reduce_focus_completion_cost` 时，先查：

- `Reference/focus_time_linkage_reference.md`

如果削弱版要减少缩短天数，或标准版保留旧缩短天数，最好补清楚自定义 tooltip，避免游戏原生提示误导玩家。

#### 限时 idea 或限时修正

先判断差异是持续时间、修正数值，还是两者都有变化。

- 只改持续时间：同一个 idea 可配不同 `days`。
- 改修正数值：倾向拆成两档 idea。
- 同时改持续时间和数值：优先拆成两档 idea，减少后续查错成本。

#### 科技 bonus、装备 bonus、MIO 或设计公司 bonus

先判断奖励是否是一次性 token、长期 idea，还是 MIO trait / policy 之类的外部系统效果。能直接分支的直接分支；涉及 MIO、装备模块或 modifier key 时，先查对应 Reference，不临时猜 key。

#### AI 专用奖励

如果某个国策奖励本来只给 AI 或只影响 AI 策略，先确认是否应该受“重回巅峰”影响。默认原则是：玩家可感知的国策数值参与分档；纯粹修正 AI 路线稳定性的后台逻辑不主动纳入，除非它本身就是国策奖励强度的一部分。

## 单个国策调整流程

1. 定位国策 key，并用 `Reference/focus_name.md` 查中文名。
2. 阅读完整 `focus = { ... }`，不要只看选中片段。
3. 把 `completion_reward` 内所有奖励拆成“直接效果 / idea / 动态修正变量 / 其他”。
4. 为每项奖励记录当前数值，把它视为 `standard` 候选值。
5. 写出目标 `reduced` 数值。
6. 选择最小可维护分支写法。
7. 如果涉及本地化、idea 或动态修正定义，同步补齐对应文件。
8. 检查 tooltip 是否会让玩家误解当前规则档位。
9. 在游戏中分别用规则“否”和“是”验证奖励结果。
10. 把完成情况记录回本文件或后续专门台账。

## 台账模板

后续每次动一组国策，可以复制下面表格追加记录。中文名列应来自 `Reference/focus_name.md`。

| 状态 | 国策 key | 中文名 | 奖励类型 | standard 数值 | reduced 数值 | 实现方式 | 涉及文件 | 验证 |
|---|---|---|---|---|---|---|---|---|
| 待处理 |  |  | 直接 / idea / 动态修正 / 其他 |  |  |  |  |  |

状态建议使用：

- `待处理`
- `已分类`
- `已改脚本`
- `已补本地化`
- `已测试`
- `暂缓`

## 验证清单

每完成一批国策，至少检查：

- `common/game_rules/000_Rance_game_rules.txt` 没有 BOM，且没有中文直写。
- `localisation/simp_chinese/Rance_game_rules_l_simp_chinese.yml` 有 BOM，且包含规则、选项、描述本地化。
- `Rance_jap_return_to_peak_standard` 的调用位置只在需要标准版时生效。
- 默认“否”时，只获得削弱版数值。
- 选择“是”时，只获得标准版数值。
- idea 分档不会同时残留两档。
- 动态修正奖励先添加 / 修改动态修正，再写变量。
- 所有新增 tooltip 和本地化不放入 `SEA_focus_l_simp_chinese.yml`，除非有明确理由。
- `logs/error.log` 中没有新增脚本错误、BOM 错误或本地化 key 缺失。

## 一句话总结

先落规则，再封装检测；每个国策先分类奖励类型，再按“直接效果分支、idea 双 key、动态修正变量分支、特殊系统查参考”的顺序处理。默认档永远是削弱版，“重回巅峰”只恢复削弱前标准数值。
