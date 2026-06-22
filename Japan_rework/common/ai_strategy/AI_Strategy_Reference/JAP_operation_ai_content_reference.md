# 日本 Operation AI 内容参考

资料范围：

- 当前 MOD：`common/ai_strategy/default.txt`、`common/ai_strategy/JAP_rework_ai_operations.txt`
- 原版：`D:\SteamLibrary\steamapps\common\Hearts of Iron IV\common\ai_strategy\operatives_default.txt`、`generic_operation_strats.txt`、`GER_operation_strats.txt`
- Sheep's Mod：`common/ai_strategy/default.txt`、`common/ai_strategy/AI_spying_on_you.txt`
- Rookie Mod：`rookie_basic/common/ai_strategy/default.txt`、`rookie_basic/common/ai_strategy/generic_operation_strats.txt`、`rookie_basic/common/ai_strategy/operatives_default.txt`、`rookie_GER/common/ai_strategy/GER_operation_strats.txt`

这份文档只解释情报机构和特工 AI 的“内容旋钮”：预算、分支倾向、任务、行动、装备优先级等。通用的 `allowed` / `enable` / `abort` 块结构不在这里重复讲。

## 核心内容旋钮

### 情报机构预算

```txt
ai_strategy = {
	type = intelligence_agency_usable_factories
	value = 10
}
```

含义：提高 AI 愿意投入到情报机构创建和升级上的民工厂力度。不需要写 `id`。

观察到的取值：

- 本 MOD 覆盖文件、Rookie/Sheep 的通用 `default.txt` 里，普通预算常见是 `5`。
- Rookie 德国专属预算使用常驻 `15`。
- Sheep 日本把预算挂到具体对华窗口：速推中国时 `15`，对华协作政府推进时 `20`。
- Sheep 德国对苏协作政府推进时有极端的 `100`，属于强行推动后期战略目标的写法。

设计启发：预算可以是长期常驻，也可以绑定到具体行动窗口。常驻预算可靠，但可能提前浪费工业；行动窗口预算更干净，但 `enable` 条件必须写得稳。

### 情报机构升级工厂门槛修正

```txt
ai_strategy = {
	type = agency_ai_base_num_factories_factor
	value = -50
}

ai_strategy = {
	type = agency_ai_per_upgrade_factories_factor
	value = -25
}
```

含义：降低 AI 继续升级情报机构时面对的工厂门槛压力。Sheep 和 Rookie 都把它用于 `is_spymaster = yes`，注释里把数值解释为对 define 门槛的百分比降低。

设计启发：这不是直接的行动优先级，而是“已经承担阵营情报职责后，更愿意持续升级机构”的旋钮。

### 情报机构分支倾向

```txt
ai_strategy = {
	type = intelligence_agency_branch_desire_factor
	id = branch_defense
	value = 200
}
```

含义：调整 AI 对某个情报机构升级分支的偏好。项目参考说明里把它描述为对 AI 权重的 factor 修正。

已见到的分支 ID：

- `branch_intelligence`
- `branch_defense`
- `branch_operation`
- `branch_operative`
- `branch_crypto`

参考 MOD 里的分支风格：

- Rookie 通用：全面、激进。
  - `branch_intelligence = 1000`
  - `branch_defense = 1000`
  - `branch_operation = 500`
  - `branch_operative = 100`
  - `branch_crypto = 2000`
- Sheep 通用：窄而保守。
  - `branch_intelligence = 200`
  - `branch_defense = 200`
- Rookie 德国：`GER_operation_strats.txt` 里没有德国专属分支倾向，只写预算和具体行动。
- Sheep 日本：`AI_spying_on_you.txt` 里没有日本专属分支倾向，主要靠具体对华行动推动行为。

设计启发：是否给日本写专属分支块，是一个设计选择，不是 Sheep/Rookie 明确要求的结构。如果它和已有通用分支块同时生效，要按“叠加或抵消的策略压力”理解。

### 特工任务

```txt
ai_strategy = {
	type = operative_mission
	mission = build_intel_network
	value = 800
	mission_target = GER
	state = 1
	priority = 100
}
```

含义：给某个特工任务加权，例如建情报网、反间谍、静默网络等。原版 `operatives_default.txt` 注释说明：特工任务必须先通过 strategy 启用，然后才会评估潜在目标；strategy 的 `value` 会加入目标评分。

原版 `operatives_default.txt` 里常见任务：

- `build_intel_network`
- `counter_intelligence`
- `quiet_network`
- `root_out_resistance`
- `control_trade`

原版注释中也保留了这些例子：

- `boost_ideology`
- `propaganda`
- `diplomatic_pressure`

常用字段：

- `mission_target = TAG`：国家目标。
- `state = ID`：如果任务可指定州，则偏好这个州。
- `num_operatives = N`：要求多个特工投入同一任务。
- `priority = N`：让该州/目标偏好和其他 strategy 偏好竞争。

设计启发：`operative_mission` 适合做准备和被动压力。它不会自己启动“协作政府”这种特别行动。

### 特别行动

```txt
ai_strategy = {
	type = operative_operation
	operation = operation_collaboration_government
	value = 900
	operation_target = GER
}
```

含义：给一个特别行动加权。

参考中出现过的常见行动 ID：

- `operation_collaboration_government`
- `operation_rescue_operative`
- `operation_infiltrate_armed_forces_army`

常用字段：

- `operation_target = TAG`：国家目标。
- `state = ID`：如果行动可指定州，则偏好这个州。
- `region = ID`：如果行动可指定战略区，则偏好这个战略区。
- `priority = N`：目标偏好的优先级。

设计启发：`operative_operation` 通常要搭配同目标的 `operative_mission = build_intel_network`。否则 AI 可能“想做行动”，但缺乏足够情报网去执行。

### 行动装备优先级

```txt
ai_strategy = {
	type = operation_equipment_priority
	value = 100
}
```

含义：提高行动所需装备的优先级。原版 generic operation 和 Rookie 德国都会把它和具体行动搭配。

设计启发：它适合写在行动窗口里，不适合无脑常驻。除非你明确希望 AI 长期为特工行动保留装备优先级。

### 阵营情报角色

```txt
ai_strategy = {
	type = become_spymaster
	value = 30
}
```

相关类型：

- `become_spymaster`
- `become_head_of_crypto`
- `become_head_of_operations`
- `become_head_of_counter_intel`

观察到的常见取值：

- 大国成为 spymaster：`30`
- 小国成为 spymaster：`2`
- `head_of_crypto` / `head_of_operations` / `head_of_counter_intel`：`2`

设计启发：这些是阵营层面的情报职务优先级，不是普通情报机构升级优先级。它们主要和 No Compromise, No Surrender 的阵营情报功能有关。

## 常见条件模式

### 行动完成次数门槛

```txt
num_finished_operations = {
	operation = operation_collaboration_government
	target = CHI
	value < 3
}
```

用途：达到目标次数后停止重复做协作政府。

Sheep 日本对中国使用过 `< 3` 和 `< 4`。Rookie 德国则用目标队列，例如“波兰协作完成到一定程度后，再推进法国”。

### 已经准备/执行中的行动继续保留

```txt
OR = {
	date < 1941.7.7
	is_preparing_operation = {
		operation = operation_collaboration_government
		target = NOR
	}
	is_running_operation = {
		operation = operation_collaboration_government
		target = NOR
	}
}
```

原版德国对挪威使用这种写法。它允许设置截止日期，同时避免把已经在准备或执行中的行动中途取消。

### 目标有效性门槛

```txt
CHI = {
	exists = yes
	has_capitulated = no
	NOT = { is_ally_with = JAP }
	NOT = { is_subject_of = JAP }
}
```

用途：给目标国家分配任务或行动前，先确认它仍然是有效目标。联盟、附庸、投降等检查要根据具体战役调整。

### 战争或阶段门槛

常见例子：

- `date > 1938.1.1`
- `has_war_with = CHI`
- `FRA = { has_capitulated = yes }`
- `SOV = { surrender_progress > 0.4 }`
- 用州控制者判断是否已经拥有登陆或大陆通道

设计启发：operation AI 最好和战争阶段绑定。德国参考文件很适合学习“阶段目标队列”。

## 参考案例

### 原版：启用基础特工任务

原版 `operatives_default.txt` 在国家拥有任意特工后，启用低权重特工任务：

```txt
enable = {
	any_operative_leader = { always = yes }
}
ai_strategy = {
	type = operative_mission
	mission = build_intel_network
	value = 100
}
```

学习点：这是基础任务解锁，不是某个国家的专属计划。

### 原版：通用行动执行器

原版 `generic_operation_strats.txt` 使用变量：

```txt
operation = var:generic_operation_type_to_run
operation_target = var:generic_operation_target
mission_target = var:generic_operation_target
```

学习点：这是一个灵活的执行器模式。它依赖别处设置变量；如果不知道变量来源，不要直接照搬。

### Rookie 通用：全面建设情报机构

Rookie 通用 `default.txt`：

```txt
build_intelligence_agency_as_major -> value = 5
build_intelligence_agency -> value = 5
upgrade_intelligence_agency -> value = 5
upgrade_intelligence_agency_as_spy_master -> value = 10
```

分支倾向：

```txt
branch_intelligence = 1000
branch_defense = 1000
branch_operation = 500
branch_operative = 100
branch_crypto = 2000
```

学习点：Rookie 通用倾向强烈鼓励全面升级情报机构，尤其偏向 `branch_crypto`。这是“基础设施型”写法，不是某一场战役的行动计划。

### Rookie 德国：常驻预算加目标队列

Rookie 德国：

```txt
intelligence_GER_upgrade = {
	enable = { always = yes }
	ai_strategy = {
		type = intelligence_agency_usable_factories
		value = 15
	}
}
```

随后它按波兰、法国、苏联、英国、美国等目标推进协作政府。

学习点：德国把“基础预算”和“目标行动”拆开写。它没有写德国专属分支倾向。

### Sheep 通用：保守建设情报机构

Sheep 通用：

```txt
branch_intelligence = 200
branch_defense = 200
```

学习点：Sheep 不在通用 AI 里强推 `branch_operation`、`branch_operative`、`branch_crypto`。具体国家的行动行为放到专门行动块里。

### Sheep 日本：具体对华推进

Sheep 日本：

```txt
JAP_spy_on_CHI:
	build_intel_network = 9999
	operation_collaboration_government = 9999

JAP_collaboration_on_CHI:
	operation_collaboration_government = 9999
	build_intel_network = 1000
	intelligence_agency_usable_factories = 20

JAP_speedrun_CHI:
	intelligence_agency_usable_factories = 15
	build_intel_network = 1000
```

学习点：Sheep 日本把预算和任务压力直接挂在中国计划里。它旧代码里的 `has_government = fascism` 不适合本 MOD 日本，因为本 MOD 日本开局可能是 `neutrality`。

### Sheep：负权重抑制目标

Sheep 用负的任务权重防止浪费：

```txt
ai_strategy = {
	type = operative_mission
	mission = build_intel_network
	value = -3000
	mission_target = SOV
}
```

学习点：负权重适合表达“现在还不关心这个目标”。例如日本在北进路线无关时，不应把特工浪费到苏联建网上。

## Japan Rework 的设计选项

### 预算风格

方案 A：日本常驻预算。

- 接近 Rookie 德国。
- 简单、可靠、容易理解。
- 适合“日本必须稳定建设和升级情报机构”的设计。
- 风险：在具体行动计划还没启动前就消耗工业。

方案 B：战役绑定预算。

- 接近 Sheep 日本。
- 预算只在中国、南进、北进、对大国战争等窗口出现。
- 适合“日本的情报机构服务具体军事目标”的设计。
- 风险：门槛写弱了会导致情报机构启动过晚。

方案 C：混合预算。

- 小额常驻预算，加上战役窗口里的较大预算。
- 对多路线脚本大国通常比较稳。

### 分支风格

方案 A：不写日本专属分支块。

- 让 `default.txt` 负责情报机构分支。
- 日本文件只通过目标行动塑造实际行为。

方案 B：保守日本分支块。

- 推 `branch_intelligence` 和 `branch_defense`。
- 在战役需求出现前，不强推 `branch_operation`、`branch_operative`、`branch_crypto`。

方案 C：战役型分支块。

- 中国或后续路线窗口里，临时推 `branch_operation` 和 `branch_operative`。
- 避免永久强推行动/特工分支。

方案 D：抵消已有通用分支。

- 用负值抵消不想要的通用倾向。
- 可以用，但不如“把日本排除出通用块”或“重写通用块”透明。

### 任务和行动风格

方案 A：一次只集中一个目标。

- 适合先处理中国。
- 更容易避免特工分散。

方案 B：阶段目标队列。

- 适合德国式多战线计划。
- 日本候选顺序可以是：中国 -> 苏联 / 东南亚 -> 英国 / 美国。

方案 C：路线互斥压力。

- 通过负权重压制暂时无关的目标。
- 例如：北进前压制对苏建网；南进前压制对英美和东南亚目标。

## 编写日本块前的检查表

- 日本是否已经从 `default.txt` 获得通用预算或分支压力？
- 要把日本排除出通用分支块，还是让日本文件叠加在它上面？
- 当前块是情报机构基础设施、特工任务，还是具体特别行动？
- 目标是否有效：存在、未投降、不是盟友、不是附庸？
- 协作政府行动是否有 `num_finished_operations` 上限？
- 如果行动已经在准备或执行中，是否应允许继续？
- 是否需要 `operation_equipment_priority`？
- 路线未相关前，是否需要用负权重压制某些目标？
- 条件是否符合本 MOD 日本实际情况，尤其是 `neutrality` 开局和自定义国策路线门槛？
