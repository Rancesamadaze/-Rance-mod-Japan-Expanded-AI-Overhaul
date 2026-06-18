# AI 建筑策略参考

> 来源：`common/ai_strategy/_documentation.md` 中与建筑建造最相关的条目整理  
> 用途：快速查阅 AI 如何被引导去建造特定建筑、补足建筑数量、以及调整工厂建设倾向

## 直接控制建造的核心条目

### `build_building`

作用：

- 直接让 AI 倾向去建造某种建筑
- 可选指定目标位置

最小写法：

```txt
ai_strategy = {
	type = build_building
	id = industrial_complex
	value = 200
}
```

常见参数：

- `type = build_building`
- `id = <building key>`
- `target = <location id>`：可选
- `value = <weight>`

要点：

- `id` 是建筑类型，例如 `industrial_complex`、`arms_factory`、`dockyard`、`infrastructure`、`coastal_bunker`
- `target` 对州级建筑按 `state id` 解释，对省份级建筑按 `province id` 解释
- 如果指定位置无法建造该建筑，这条策略会被忽略
- 如果不写 `target`，AI 会在可建造的位置里随机选择
- 如果该建筑支持转换，且没有指定 `target`，AI 可能优先走“转换”而不是新建
- 如果该建筑已经在目标位置施工中，这条策略会被忽略
- `value` 本质上是权重，AI 会把所有可用的 `build_building` 方案拿来做加权选择

示例：

```txt
ai_strategy = {
	type = build_building
	id = coastal_bunker
	target = 139
	value = 200
}
```

适合场景：

- 指定州优先补基建
- 指定沿海点修海岸要塞
- 指定关键州补民工、军工、船坞

### `building_target`

作用：

- 让 AI 以“达到某种建筑的目标数量”为优先目标

最小写法：

```txt
ai_strategy = {
	type = building_target
	id = industrial_complex
	value = 85
}
```

要点：

- `id` 仍然是建筑类型
- `value` 在这里不是普通权重，而是“希望至少拥有的建筑数量”
- 常用于告诉 AI：“在达到这个数量之前，继续优先补这种建筑”

适合场景：

- 民工总量不足时先补民工
- 日本前期先把船坞或军工补到某个阈值
- 某路线要求 AI 先把基建或机场堆到一定规模

## 间接影响建筑倾向的相关条目

下面这些条目虽然不直接写“建某个州的某个建筑”，但会影响 AI 的整体建设偏好。

### `added_military_to_civilian_factory_ratio`

作用：

- 调整 AI 对“军工 / 民工比例”的额外倾向

常见理解：

- 适合在某条路线下让 AI 更偏向军工化，或更偏向先补民工

### `dockyard_to_military_factory_ratio`

作用：

- 调整 AI 对“船坞 / 军工比例”的倾向

适合场景：

- 日本海军路线更偏船坞
- 陆军路线降低船坞优先级，转去补军工

### `air_factory_balance`

作用：

- 调整 AI 对空军相关工厂投入的平衡倾向

说明：

- 这条更偏生产分配逻辑，不是直接下建筑指令
- 但当 AI 整体航空投入倾向上升时，往往会连带影响其相关工业发展取向

### `factory_build_score_factor`

作用：

- 调整 AI 对工厂建设评分的偏好

说明：

- 这类条目更像是“修正 AI 对某类工厂建设的打分”
- 不像 `build_building` 那样明确指定“去建这个”
- 更适合做路线级、阶段级的全局偏好微调

## 建筑 key 使用提醒

在 AI 建筑策略里，`id` 需要写建筑 key，而不是本地化名称。

常见可用键例如：

- `industrial_complex`
- `arms_factory`
- `dockyard`
- `infrastructure`
- `air_base`
- `naval_base`
- `bunker`
- `coastal_bunker`
- `anti_air_building`
- `radar_station`
- `synthetic_refinery`
- `fuel_silo`
- `rocket_site`
- `nuclear_reactor`

建筑键的中文对照可继续参考：

- [building_reference.md](C:/Users/Administrator/Documents/Paradox%20Interactive/Hearts%20of%20Iron%20IV/mod/Japan_rework/Reference/building_reference.md)(不同计算机上地址不同，以实际地址为准)

## 实战建议

如果你想让 AI “真的去某地修某建筑”，优先考虑：

1. `build_building`
2. 必要时配合 `target`
3. 再用 `building_target` 控制阶段性总量目标

如果你想让 AI “整体上更偏向某类工厂结构”，优先考虑：

1. `building_target`
2. `added_military_to_civilian_factory_ratio`
3. `dockyard_to_military_factory_ratio`
4. `factory_build_score_factor`

## 最小模板

### 指定地点修建筑

```txt
my_ai_strategy = {
	allowed = {
		tag = JAP
	}
	enable = {
		always = yes
	}
	abort_when_not_enabled = yes

	ai_strategy = {
		type = build_building
		id = infrastructure
		target = 282
		value = 200
	}
}
```

### 优先把某类建筑堆到目标数量

```txt
my_ai_strategy = {
	allowed = {
		tag = JAP
	}
	enable = {
		always = yes
	}
	abort_when_not_enabled = yes

	ai_strategy = {
		type = building_target
		id = industrial_complex
		value = 90
	}
}
```

## 任务驱动 AI 建造模板

当某个决议、任务、mission、计划或国家 flag 只在一段时间内要求 AI 去完成特定州的建设目标时，建议使用“任务驱动 AI 建造”写法。

核心思路：

1. 由决议或任务在启动时记录建筑旧值或目标变量
2. 用国家 flag 或任务状态控制 AI 策略启停
3. 用多个小型 `build_building` 策略块分阶段控制 AI
4. 不依赖整体工厂倾向调控时，只用定点 `build_building`

适合场景：

- 限时开发某个州
- 先补基建，再补民工
- 某任务要求在指定州完成建筑升级
- 某路线要求 AI 在阶段内优先建设一个固定地区

### 设计原则

- 优先用 `has_country_flag`、任务 flag、mission 激活状态控制 AI 策略启停
- 优先用决议启动时记录的变量决定当前阶段是否达标
- 如果任务有先后顺序，拆成多个 AI 策略块，而不是把所有建筑一起高权重硬塞给 AI
- 如果目标是精确定点施工，优先只用 `build_building`
- 如果不需要全局工厂倾向变化，就不要混用 `added_military_to_civilian_factory_ratio`

### 分阶段示例

以下模式适合“先修基建，后补民工”的任务：

```txt
my_mission_ai_infrastructure = {
	allowed = {
		original_tag = JAP
	}
	enable = {
		has_country_flag = my_mission_active
		282 = {
			NOT = {
				OR = {
					infrastructure > 4
					check_variable = { building_level@infrastructure > my_infra_pre }
				}
			}
		}
	}
	abort_when_not_enabled = yes

	ai_strategy = {
		type = build_building
		id = infrastructure
		target = 282
		value = 900
	}
}

my_mission_ai_civs = {
	allowed = {
		original_tag = JAP
	}
	enable = {
		has_country_flag = my_mission_active
		282 = {
			OR = {
				infrastructure > 4
				check_variable = { building_level@infrastructure > my_infra_pre }
			}
			NOT = {
				check_variable = { building_level@industrial_complex > my_civ_target }
			}
		}
	}
	abort_when_not_enabled = yes

	ai_strategy = {
		type = build_building
		id = industrial_complex
		target = 282
		value = 500
	}
}
```

### 这类模板的优势

- 逻辑清晰，能直接对应任务验收条件
- AI 行为更可控，不容易跑偏到其他州
- 后续扩展方便，例如：
  - 先机场后雷达
  - 先船坞后海军基地
  - 先基建后军工
  - 先建筑 A 达标再切到建筑 B

### 编写建议

- 若任务验收条件本身依赖变量，就让 AI 启用条件也依赖同一批变量
- 若任务只要求一个州，优先用固定 `target = <state id>`
- 若任务要求多个州，建议拆成多个策略块，分别控制
- 若采用硬性启用条件，重点应是“该策略对应的建筑目标尚未达标”
- 是否启用某条策略，优先检查它自己负责的建筑，而不是额外附加过多无关前置

## 当前项目修正规则

对于“商工省”这类任务型建造策略，当前项目对“硬性启用条件”的理解是：

- 只有该策略所负责的对应建筑尚未达标时，这条策略才启用
- 一旦该策略负责的建筑已经达标，这条策略就应停用

也就是说，硬性启用的重点是“按对应建筑是否达标来开关策略”，而不必默认把它写成严格的串行前置链。

当前更贴近项目实现的表述应是：

- `infrastructure` 策略只在基建尚未达标时启用
- `industrial_complex` 策略只在民工尚未达标时启用
- 如有需要，再用权重控制大致先后顺序
- 对不希望 AI 在目标州插入的建筑，可以继续补一条定点负权重 `build_building`

这样做的优点是：

- AI 行为和 mission 验收条件一致，便于调试
- 不容易出现 AI 在任务关键州插入无关建筑
- 各策略的启停边界清晰，后续扩写同类地区开发也更容易复用

如果只是做宽松引导，也可以只靠权重控制先后顺序；
但当任务目标比较明确时，仍然建议先把“对应建筑未达标才启用”这层硬条件写清楚，再决定是否额外叠加顺序型前置。
