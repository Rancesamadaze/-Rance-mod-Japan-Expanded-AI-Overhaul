# HOI4 原版属国语法与代码参考

记录日期：2026-06-18

本文总结原版属国、自主等级、放傀儡、和平会议 AI 相关语法，供后续设计日本专属属国系统时查阅。本文只记录原版观察与可借鉴模式，不代表已经在本 MOD 实装。

## 主要入口

原版属国相关内容分散在几类文件中：

- `common/autonomous_states/`
  - 定义属国类型和自治等级，例如 `autonomy_puppet`、`autonomy_integrated_puppet`、`autonomy_wtt_imperial_protectorate`。

- `common/decisions/JAP.txt`
  - 日本原版决议里有大量放出帝国保护国、转移核心州、设置自治等级的样例。

- `common/scripted_effects/JAP_scripted_effects.txt`
  - 日本内战、释放殖民地、重设属国关系等复用效果。

- `events/Japan.txt` 与 `events/SEA_Japan.txt`
  - 事件中直接 `puppet`、`set_autonomy`、转移州和设外观标签的样例。

- `common/peace_conference/ai_peace/JAP.txt`
  - 和平会议 AI 对 `puppet`、`take_states` 等行动的偏好脚本。

- `common/ideas/_economic.txt`
  - 国家精神 `rule = { can_access_market = no }` 的样例，可参考用于禁止进入国际装备市场。

- `localisation/*/autonomy_l_*.yml`、`localisation/*/rules_l_*.yml`
  - 属国类型名、规则说明等本地化。

## `autonomy_state` 文件结构

所有原版自定义属国类型都使用同一顶层：

```hoi4
autonomy_state = {
	id = autonomy_example_subject
	default = yes
	is_puppet = yes
	use_overlord_color = yes
	min_freedom_level = 0.2
	manpower_influence = 0.9

	rule = {
		desc = "RULE_DESC_IS_A_SUBJECT"
		can_not_declare_war = yes
		can_decline_call_to_war = no
	}

	modifier = {
		autonomy_manpower_share = 0.9
		cic_to_overlord_factor = 0.25
		mic_to_overlord_factor = 0.65
	}

	allowed = {
		OVERLORD = { original_tag = JAP }
	}
}
```

每个 `common/autonomous_states/*.txt` 通常只定义一个 `autonomy_state`。文件名不必和 `id` 完全一致，但原版基本保持可读命名。

## 顶层字段

`id`

- 属国类型 key，例如 `autonomy_puppet`、`autonomy_wtt_imperial_protectorate`。
- 后续 `set_autonomy`、本地化和国家名规则都引用这个 key。

`default = yes`

- 在某些系统需要默认等级时使用。
- 原版 `puppet.txt`、`reichsprotectorate.txt`、`wtt_imperial_protectorate.txt`、`sea_warlord_subject.txt` 等都使用过。

`is_puppet = yes/no`

- 标记是否算作傀儡型从属关系。
- `wtt_imperial_subject.txt` 中存在 `is_puppet = no`，说明“从属关系”和“是否 puppet”可以拆开。

`use_overlord_color = yes`

- 让属国使用宗主国颜色。
- 常见于合作政府、监督国、军阀属国、欧盟成员、人民委员部等特殊类型。

`min_freedom_level`

- 自治等级在自由度轴上的位置。
- 数值越高越接近独立或较高自治。原版例子：`integrated_puppet` 为 `0.2`，`puppet` 为 `0.4`，`dominion` 为 `0.8`。

`peace_conference_initial_freedom`

- 和平会议生成时的初始自由度。
- 原版 `supervised_state.txt` 使用 `peace_conference_initial_freedom = 0.001`。

`manpower_influence`

- 自治度变化中人力贡献相关权重。
- 压榨型属国常见较高值，例如 `integrated_puppet`、`collaboration_government` 为 `1.0`。

## `rule` 块

`rule` 块控制国家规则，既能出现在属国类型里，也能出现在国家精神里。

原版属国类型常见字段：

- `desc = "RULE_DESC_IS_A_SUBJECT"`
  - 规则说明本地化。简体中文原版为“（是附属国）”。

- `can_not_declare_war = yes`
  - 禁止自行宣战。

- `can_decline_call_to_war = yes/no`
  - 是否可以拒绝宗主国召唤参战。
  - `dominion`、`supervised_state` 倾向允许；低级傀儡通常不允许。

- `units_deployed_to_overlord = yes`
  - 部署出的单位归宗主国使用。
  - 常见于更深度控制的属国，如 `integrated_puppet`、`reichskommissariat`、`wtt_imperial_protectorate`、`collaboration_government`。

- `can_be_spymaster = yes/no`
  - 是否能成为间谍主管。

- `contributes_operatives = yes/no`
  - 是否贡献特工。

- `can_create_collaboration_government = no`
  - 禁止再创建合作政府。

国家精神中也能写规则。原版经济法示例：

```hoi4
rule = {
	can_access_market = no
	desc = can_not_access_market_closed_economy
}
```

这说明“禁止国际装备市场”更适合通过属国专属国家精神或类似规则实现，而不是强塞进 `autonomy_state` 的常见主体字段里。

## `modifier` 块

属国类型的 `modifier` 可以直接挂国家修正。原版最常见的是这些：

- `autonomy_manpower_share`
  - 宗主国可使用属国人力比例。

- `can_master_build_for_us`
  - 宗主国可在属国境内建设。

- `extra_trade_to_overlord_factor`
  - 给宗主国额外贸易倾斜。

- `overlord_trade_cost_factor`
  - 宗主国从属国购买资源的贸易成本修正。

- `cic_to_overlord_factor`
  - 民用工厂上供比例。

- `mic_to_overlord_factor`
  - 军用工厂上供比例。

- `license_subject_master_purchase_cost`
  - 宗主国购买属国许可生产的成本修正。原版部分压榨型属国为 `-1`。

- `autonomy_gain_global_factor`
  - 全局自治度增长修正。许多低级属国为负值。

- `autonomy_gain`
  - 固定自治度增长。`supervised_state` 用于走向独立。

- `master_ideology_drift`
  - 向宗主国意识形态漂移。`supervised_state` 有样例。

- `peace_score_ratio_transferred_to_overlord`
  - 和平分数转给宗主国的比例。

- `lend_lease_tension_with_overlord`
  - 与宗主国租借所需紧张度修正。

- `research_sharing_per_country_bonus_factor`
  - 科研共享相关修正。

- `faction_subject_contribution_gain`
  - 阵营从属贡献相关修正。

- `faction_influence_contribution_factor`
  - 阵营影响力贡献修正。

- `conscription_factor`
  - 征兵修正。德国行政区类属国常用负值压低自身征兵。

- `resistance_target`
  - 抵抗目标修正。`reichskommissariat` 有降低抵抗目标的样例。

首轮搜索没有发现属国类型里存在 `dockyard_to_overlord`、`nic_to_overlord_factor` 或同类船坞上供字段。原版船坞通常通过 `industrial_capacity_dockyard` 这类产出修正处理，而不是作为属国上供比例直接存在。

## AI 自治倾向块

`ai_subject_wants_higher`

- 属国 AI 是否倾向提升自治等级。
- 可写 `factor = 1.0`，也可在内部加 `modifier = { ... add = ... }`。

`ai_overlord_wants_lower`

- 宗主国 AI 是否倾向压低自治等级。
- 深度压榨型属国常见 `factor = 0.0`，表示宗主国不推动进一步降低或避免常规逻辑干扰。

`ai_overlord_wants_garrison`

- 宗主国是否倾向驻军。
- 压榨型、专属属国和军阀属国常见 `always = yes`；普通 `puppet`、`dominion` 常见 `always = no`。

这些块影响 AI 对自治升降级和驻军的倾向，不等同于和平会议是否选择放傀儡。

## 可用条件与等级过滤

`allowed`

- 决定此属国类型在什么情况下可用。
- 可检查 DLC、宗主国、属国本身、政体、原始 tag、国策、是否军阀等。
- 在 `allowed` 内常用 `OVERLORD = { ... }` 指向宗主国，`ROOT` 指向该属国类型被评估的国家。

常见模式：

```hoi4
allowed = {
	has_dlc = "Waking the Tiger"
	OR = {
		OVERLORD = { original_tag = JAP }
		OVERLORD = { original_tag = MAN }
	}
}
```

`can_take_level`

- 能否升到这个自治等级。
- 原版常用于特殊国家的国策门槛，例如英联邦自治提升、刚果特殊路线、满洲国服从路线。

`can_lose_level`

- 能否从这个自治等级降下去。
- 可用来锁住特殊等级，或要求某些国策后才允许变化。

`allowed_levels_filter`

- 限制可见或可用等级集合。
- `supervised_state` 和 `personal_union` 有样例。

`use_for_peace_conference_weight`

- 让和平会议选择某个自治等级时增加权重。
- `puppet` 和 `supervised_state` 有样例。

## 创建或改变属国关系

`puppet = TAG`

- 在当前 ROOT 作用域下把目标 tag 变为 ROOT 的傀儡。
- 原版 `events/Japan.txt` 里有简单样例：日本事件接受暹罗后执行 `puppet = SIA`。

`puppet = { target = FROM end_wars = yes/no }`

- 块式写法可以指定目标和是否结束战争。
- 原版 `common/decisions/JAP.txt` 中有 `target = FROM`、`end_wars = yes/no` 样例。

作用域写法：

```hoi4
MAN = {
	puppet = MEN
}
```

表示 `MAN` 作为宗主国，把 `MEN` 设为属国。

`set_autonomy`

用于给目标设置指定自治等级。原版出现两种键名：

```hoi4
set_autonomy = {
	target = BRM
	autonomous_state = autonomy_wtt_imperial_protectorate
	end_wars = no
	end_civil_wars = no
}
```

```hoi4
set_autonomy = { target = KOR autonomy_state = autonomy_free }
```

观察：

- `autonomous_state` 和 `autonomy_state` 在原版都出现过。
- 多行放出帝国保护国时常用 `autonomous_state`。
- 释放为独立时常用 `autonomy_state = autonomy_free`。
- `autonomy_free` 未在 `common/autonomous_states` 中定义，疑似引擎内置自由等级。

`release = TAG`

- 释放国家。
- 原版日本脚本常见流程是：先确认控制核心州，再 `release = KOR`，再 `set_autonomy = { target = KOR autonomy_state = autonomy_free }`。

`transfer_state_to = TAG`

- 转移州所有权。
- 原版建立缅甸、印度、菲律宾等日系属国时，常先把核心州转交给目标国家，再设自治等级。

`set_state_controller_to = TAG`

- 转移州控制权。
- 常和 `transfer_state_to` 配合，用于确保新属国实际控制该州。

`white_peace = TAG`

- 建国后清理战争关系。
- 原版事件会让日本、阵营国家、属国与新目标白和，避免刚放出来的国家继续被旧战争拖住。

`set_cosmetic_tag` / `drop_cosmetic_tag`

- 设定或移除外观国家标签。
- 原版日本属国事件大量使用，例如缅甸国、自由印度、菲律宾第二共和国、柬埔寨王国等。

## 常用属国触发条件

`is_subject = yes/no`

- 判断当前国家是否为附属国。

`is_subject_of = TAG/ROOT/FROM`

- 判断当前国家是否为某国属国。

`has_subject = TAG`

- 判断当前国家是否拥有指定属国。

`has_autonomy_state = autonomy_xxx`

- 判断当前国家是否处于某个自治等级。

`has_rule = can_puppet`

- 原版 `puppet` 的和平会议权重里出现，用来判断潜在宗主国是否有傀儡权限。

`OVERLORD = { ... }`

- 在 `autonomy_state` 的 `allowed` 等块里指向宗主国。

`ROOT`、`FROM`、`PREV`

- 属国脚本里作用域经常很深，尤其是和平会议和事件链。
- 原版和平会议 AI 中，`ROOT` 是谈判者；`FROM`、`FROM.FROM`、`FROM.FROM.FROM` 分别指向和平行动相关对象和州级上下文。写新逻辑前必须先用相邻原版样例确认作用域。

## 和平会议 AI

原版日本有：

```text
common/peace_conference/ai_peace/JAP.txt
```

顶层结构：

```hoi4
peace_ai_desires = {
	JAP_create_chinese_puppet = {
		peace_action_type = puppet
		enable = {
			ROOT = { original_tag = JAP }
		}
		ai_desire = 150
	}
}
```

常见字段：

- `peace_action_type`
  - 可为单个类型，如 `puppet`、`take_states`。
  - 也可为集合，如 `{ puppet force_government }` 或 `{ puppet liberate force_government }`。

- `enable`
  - 决定该偏好何时启用。
  - 可检查谈判者、目标国家、目标州、是否为核心、是否为已有属国等。

- `ai_desire`
  - 正数提高欲望，负数降低欲望。
  - 日本原版用 `150` 鼓励创建中国傀儡，用 `-100` 降低吞掉非重点中国州的欲望。

日本原版思路：

- 对不想吞并的中国内陆州，降低 `take_states` 欲望。
- 对剩余中国地区，提高 `puppet` 欲望。
- 若重组国民政府存在，则提高把相关州给该属国的 `take_states` 欲望。
- 对军阀和中共降低 `puppet` 或 `force_government` 欲望，避免生成不想要的傀儡。

这套很适合作为未来“史实路线/劳农派路线不吞并、转向放属国”的 AI 入口。

注意：原版 `JAP.txt` 注释提到 `documentation.info`，但当前安装中未找到该文件。本文只按实际存在的脚本归纳。

## 代表性原版属国类型

`autonomy_puppet`

- 普通傀儡。
- 可宣战受限、不能拒绝召唤、宗主贸易成本低。
- 没有 `cic_to_overlord_factor` 与 `mic_to_overlord_factor`，工业上供不如深度属国。

`autonomy_integrated_puppet`

- 深度整合傀儡。
- `units_deployed_to_overlord = yes`。
- `cic_to_overlord_factor = 0.25`，`mic_to_overlord_factor = 0.75`。

`autonomy_wtt_imperial_protectorate`

- 日本/满洲相关帝国保护国。
- 通过 `allowed` 限定 `OVERLORD` 原始 tag 为日本或满洲，且政体为法西斯或中立。
- `cic_to_overlord_factor = 0.25`，`mic_to_overlord_factor = 0.65`。

`autonomy_reichskommissariat`

- 德系行政区。
- 生产和征兵方面有压制，`conscription_factor = -0.5`。
- 有 `license_subject_master_purchase_cost = -1`、`resistance_target = -0.1`。

`autonomy_collaboration_government`

- 合作政府。
- `use_overlord_color = yes`。
- `cic_to_overlord_factor = 0.75`，`mic_to_overlord_factor = 0.75`，是原版工厂上供很高的样例。
- `allowed` 要求 `has_variable = collaboration_formed_by`。

`autonomy_supervised_state`

- 监督国。
- `can_decline_call_to_war = yes`，并有 `autonomy_gain = 2` 与 `master_ideology_drift = 0.3`。
- 更像战后托管，不像永久压榨型属国。

`autonomy_sea_warlord_subject`

- 中国军阀属国。
- 用 `is_chinese_warlord = yes` 和 `OVERLORD = { is_literally_china = yes }` 限定。
- 是“某一类国家专属属国等级”的好参考。

## 市场、租借与装备外流

市场：

- 已确认国家规则 `can_access_market = no` 存在。
- 原版经济法在国家精神 `rule` 中使用，而非在 `autonomy_state` 常见字段中使用。
- 若要禁止特殊属国进国际装备市场，建议挂属国专属国家精神或其他稳定载体。

租借：

- 原版有 `lend_lease_tension` 与 `lend_lease_tension_with_overlord` 修正。
- 外交租借是否启用还受 `common/game_rules/00_game_rules.txt` 中 `allow_lend_lease` 影响。
- `common/scripted_triggers/diplomacy_scripted_triggers.txt` 中 `DIPLOMACY_LEND_LEASE_ENABLE_TRIGGER` 和 `DIPLOMACY_INCOMING_LEND_LEASE_ENABLE_TRIGGER` 检查游戏规则。
- 首轮未确认存在类似 `can_send_lend_lease = no` 的国家规则。若要硬禁属国向外租借，后续需要继续查证，或使用库存控制、生产压制、市场禁入、AI 策略和脚本补给绕开漏洞。

装备市场 AI：

- `common/ai_strategy/default.txt` 中有 `equipment_market_for_sale_threshold`、`equipment_market_min_for_sale`、`equipment_market_for_sale_factor`、`equipment_market_buying_threshold`。
- 这些是 AI 行为倾向，不等同于玩家硬规则。

## 本地化配套

属国等级名：

- 原版放在 `localisation/*/autonomy_l_*.yml`。
- key 直接对应 `autonomy_state` 的 `id`。

规则说明：

- `RULE_DESC_IS_A_SUBJECT` 在 `localisation/*/rules_l_*.yml`。
- `can_access_market = no` 搭配的市场说明如 `can_not_access_market_closed_economy` 在 `aat_ideas_l_*.yml`。

国家名：

- 很多国家有 `TAG_autonomy_xxx`、`TAG_autonomy_xxx_DEF`、`TAG_autonomy_xxx_ADJ`。
- 这些通常在 `countries_l_*.yml` 或 `countries_cosmetic_l_*.yml`。
- 若只定义属国等级名，不定义国家名，国家仍可显示普通国家名；若需要“某某保护国/军政辖区”这类外观，需要补国家名或使用 `set_cosmetic_tag`。

## 对日本专属属国系统的启发

1. 新属国类型可以直接仿照 `autonomy_wtt_imperial_protectorate`。
   - 用 `allowed` 限定日本路线、政体或国旗。
   - 用 `rule` 固定战争、间谍、合作政府等权限。
   - 用 `modifier` 设定工厂上供和自治压制。

2. “不吞并、放属国”应同时走两条线。
   - 和平会议 AI：提高 `puppet`，降低 `take_states`。
   - 决议/事件/脚本效果：对征服后已经控制的地区，用 `transfer_state_to`、`set_state_controller_to`、`set_autonomy` 创建指定属国。

3. 船坞上供不要强行找原版不存在的字段。
   - 目前可确认的是 `cic_to_overlord_factor`、`mic_to_overlord_factor`。
   - 船坞可以后续用日本侧变量 + 动态修正模拟，或用路线奖励等效表达。

4. 禁市场更像国家精神规则。
   - 用属国类型负责“谁是谁的属国”。
   - 用国家精神负责 `can_access_market = no`、生产重罚、训练锁说明等行为限制。

5. 属国军队控制有两种原版灵感。
   - `units_deployed_to_overlord = yes` 可让部署单位归宗主国。
   - `country_lock_all_division_template` 和 `set_division_template_cap` 是另一个方向，适合脚本化发师和禁止自训。

6. 外观和身份可以分离。
   - `set_autonomy` 只管从属等级。
   - `set_cosmetic_tag` 管国家显示身份。
   - 这适合给同一 tag 在不同路线下使用不同称号。

## 后续查证清单

- `set_autonomy` 中 `autonomy_state` 与 `autonomous_state` 的兼容性边界。原版两者都出现，但本 MOD 后续应统一采用一种局部风格。
- 是否存在可硬禁租借的国家规则；当前只确认游戏规则和紧张度修正。
- `units_deployed_to_overlord = yes` 对脚本生成部队、玩家属国、AI 属国训练部队的具体行为差异。
- `use_for_peace_conference_weight` 和 `peace_ai_desires` 对同一和平行动同时存在时的叠加关系。
- 自定义属国类型若无 `allowed_levels_filter`，是否会与普通自治等级链发生不想要的升降级交互。

