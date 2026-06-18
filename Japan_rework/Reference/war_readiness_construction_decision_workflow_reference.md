# 战备建设局决议工作流参考

> 适用范围：`common/decisions/JAP_war_readiness_construction_decisions.txt`、
> `common/scripted_triggers/JAP_war_readiness_construction_scripted_triggers.txt`、
> `localisation/simp_chinese/JAP_decisions_l_simp_chinese.yml`。

本文件用于整理“军需省——战备建设局”系列决议的写法与约定。写新决议时优先保持逻辑清楚、条件准确、玩家体验可读，不要为了复刻旧格式而牺牲可维护性。

## 写前检查

写或改战备建设局决议前，先确认：

- 决议脚本文件为 UTF-8 无 BOM，保持 LF。
- 简体中文本地化文件为 UTF-8 with BOM，保持 LF。
- 省份和州的归属查 `Reference/state_province_reference.md`。
- 州名查 `Reference/state_name_reference.md`。
- 建筑 key 与建筑写法查 `Reference/building_reference.md`。
- 本地化颜色、换行等格式查 `Reference/localisation_formatting_reference.md`。
- 省份若有胜利点本地化，可查原版或项目本地化；若没有明确城市名，用户-facing 文案优先用州名或方向名，不硬编地名。

## 常见决议类型

### 一次性设施建设

适合单个州、单个港口、机场、补给中心或少量固定奖励。

常见结构：

- `visible`：未完成，且目标方向由己方或盟友控制时显示。
- `available`：真正施工所需的控制条件。
- `cancel_trigger`：读条期间失去施工条件则取消。
- `remove_effect`：再次校验条件后发放建筑并设置完成 flag。
- `ai_will_do = { factor = 100 }`。

### 分段工程

适合一条战线、沿海补给线或多个可独立完成的工程段。

常见结构：

- 决议本体使用 `days_re_enable = 1`。
- 每段有独立完成 flag。
- `available` 只要求“至少一段可施工”。
- `remove_effect` 中每段分别 `if = { limit = { <segment_ready> = yes } ... }`。
- 最后检查全部分段完成后设置总完成 flag。

这种写法用于避免读条完成时只满足部分条件，导致其它工程段被永久跳过。

## 命名约定

战备建设局决议和 flag 默认使用 `JAP_war_readiness_` 前缀。

建议：

- 决议 key 用路线或工程主题命名，例如 `JAP_war_readiness_nanjing_huangshan_supply_network`。
- 总完成 flag 用 `<decision_key>_completed`。
- 分段 flag 用 `<decision_key>_<segment>_completed`，或在 key 较长时保持同一主题前缀。
- 由于战备建设局可由日本及其属国共同使用，工程完成状态应集中存放在 `JAP` 作用域下的 country flag。判定时使用 `JAP = { has_country_flag = ... }`，设立时使用 `JAP = { set_country_flag = ... }`；不要直接在 ROOT 上读写完成 flag，否则日本和多个属国会各自保留一套完成状态，导致同一地图工程可能被重复执行。
- scripted trigger 用 `<decision_or_theme>_<condition>`，例如 `_has_ready_segment`、`_can_connect_...`、`_all_segments_completed`。

不必为了所有决议机械套同一个命名模板；更重要的是读起来能看出工程对象、路线和完成状态。

## 控制条件约定

### 用户说“控制 p...”

一般写为：

```txt
controls_province = <province_id>
```

适合用户明确要求控制具体省份、沿途省份或港口节点。

注意：province 级 `controls_province` 适合判定 ROOT 自己是否控制该省份，但不适合作为盟友、附庸或阵营控制的唯一判断。若设计允许“己方阵营控制即可施工”，按现有战备建设局代码习惯保留 state 级回退。

常见写法一：关键省份自己控制，或该方向州由己方/盟友控制即可显示或视为有支点。

```txt
OR = {
	controls_province = <province_id>
	<state_id> = {
		is_controlled_by_ROOT_or_ally = yes
	}
}
```

常见写法二：精确控制沿线 province，或完整控制相关 state 作为阵营控制回退。

```txt
OR = {
	AND = {
		controls_province = <province_a>
		controls_province = <province_b>
		controls_province = <province_c>
	}
	AND = {
		<state_a> = {
			state_is_fully_controlled_by_ROOT_subject_or_faction_member = yes
		}
		<state_b> = {
			state_is_fully_controlled_by_ROOT_subject_or_faction_member = yes
		}
	}
}
```

这类 OR 回退尤其适合 scripted trigger：玩家自己控制沿线省份时可以精确通过；如果是附庸、盟友或阵营成员完整控制整州，也不会因为 province trigger 判不到盟友控制而卡住工程。

### 用户说“控制 p... 所在 state”

先查 `Reference/state_province_reference.md`，再用对应 state scope：

```txt
<state_id> = {
	state_is_fully_controlled_by_ROOT_subject_or_faction_member = yes
}
```

如果只是显示决议，`visible` 可以用较宽松的：

```txt
<state_id> = {
	is_controlled_by_ROOT_or_ally = yes
}
```

但 `available`、`cancel_trigger`、`remove_effect` 应围绕实际施工条件写清楚。

### 中间节点

不要默认推断中间省份或中间州控制条件。

- 用户给出中间 province 时，按用户给出的中间 province 检查。
- 用户只给起点和终点时，默认让 `build_railway` 自行寻路并回退。
- 如果铁路必须经过某些特定节点，用户会给出节点，或需要先从地图/原版 railways 明确确认。

## 铁路写法

战备建设局铁路默认使用：

```txt
build_railway = {
	level = 5
	build_only_on_allied = yes
	fallback = yes
	start_province = <start>
	target_province = <target>
}
```

默认不要写显式 `path = { ... }`。

原因：

- `build_railway` 自带寻路能力。
- `fallback = yes` 会让游戏在理想路径不可用时寻找合适路线。
- 大多数情况下，显式 path 会增加维护负担，也容易在地图或控制条件变化时变得过于脆。

显式 `path = { ... }` 的使用规则：

- 只有用户主动明确要求写显式 `path`，或明确要求“走这条线”“必须经过这些 province”时，才写显式 `path = { ... }`。
- 用户只说 `RAIL <a> to <b>`、`RAS <a> to <b>`、控制沿线 province、控制某些 state，或只给出截图/参考路线时，仍默认使用 `start_province` / `target_province` / `fallback = yes`。
- 即使原版 `map/railways.txt` 已确认存在一条固定路径，只要用户没有主动要求复刻或锁定这条路径，也不要写显式 `path`。

使用显式 path 时，控制条件应同步反映关键节点，避免建造穿过完全不受控地区。

## RAIL 与 RAS

`RAIL <a> to <b>`：

- 建 5 级铁路。
- 默认使用 `start_province` / `target_province` / `fallback = yes`。
- 只有用户主动明确要求显式路径或指定必须经过的中间节点时，才使用显式 `path`。

`RAS <a> to <b>`：

- 建 5 级铁路。
- 在 `<b>` 所在 state 的 `<b>` province 添加 `supply_node`。

默认效果：

```txt
build_railway = {
	level = 5
	build_only_on_allied = yes
	fallback = yes
	start_province = <a>
	target_province = <b>
}
<destination_state_id> = {
	add_building_construction = {
		type = supply_node
		level = 1
		province = <b>
		instant_build = yes
	}
}
```

`build_railway` 不需要 `instant_build = yes`。

## 建筑写法

港口、机场、补给中心通常使用 `add_building_construction`：

```txt
<state_id> = {
	add_building_construction = {
		type = naval_base
		province = <province_id>
		level = <level>
		instant_build = yes
	}
}
```

```txt
<state_id> = {
	add_building_construction = {
		type = air_base
		level = <level>
		instant_build = yes
	}
}
```

如果用户说“新增 N 级”，用 `add_building_construction` 很自然。

如果用户明确说“设为 N 级”或“修到 N 级”，可考虑 `set_building_level`，但要先确认该建筑类型和省份/州级写法适用，并避免覆盖玩家已有更高等级建筑。

## 本地化习惯

新决议本地化放在 `localisation/simp_chinese/JAP_decisions_l_simp_chinese.yml` 的战备建设局段落，不放到 `SEA_focus_l_simp_chinese.yml`。

每个普通决议至少补：

- `<decision_key>`：决议名。
- `<decision_key>_desc`：说明战备建设局在做什么。
- `<decision_key>_completed`：完成 flag 文本，通常为 `已完成决议：§Y$<decision_key>$§!`。

文案习惯：

- 用本地化州名、城市名或方向名，不只写 province/state ID。
- 工程描述说明“为什么要修”，例如补给、港口、航空保障、战线推进。
- 普通强调使用 `§Y...§!`。

## 何时拆 scripted trigger

简单一次性工程可以直接写在决议里。

以下情况建议拆到 `common/scripted_triggers/JAP_war_readiness_construction_scripted_triggers.txt`：

- 分段工程有多个 ready/all-completed 条件。
- 条件需要复用。
- 条件很长，直接放进决议会降低可读性。
- 需要给复杂条件配自定义 tooltip。

拆 trigger 时保持 country scope，不要把 ROOT/FROM 关系写模糊。
