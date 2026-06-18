# 建筑 Reference

> 来源：原版 `common/buildings/00_buildings.txt`、`common/buildings/01_landmark_buildings.txt`、`localisation/simp_chinese/buildings_l_simp_chinese.yml` 与 `localisation/simp_chinese/constructions_l_simp_chinese.yml` 交叉匹配

## 建筑名称对照

| 键 | 本地化名称 |
| --- | --- |
| air_base | 空军基地 |
| air_facility | 空气动力学与航空电子研究设施 |
| anti_air_building | 防空阵地 |
| arms_factory | 军用工厂 |
| bunker | 陆上要塞 |
| canal_kiel | 基尔运河船闸 |
| canal_panama | 巴拿马运河船闸 |
| coastal_bunker | 海岸要塞 |
| commercial_nuclear_reactor | 民用核反应堆 |
| dam | 大坝 |
| dam_mountain | 大坝 |
| dockyard | 海军船坞 |
| energy_infrastructure | 强化电网 |
| fuel_silo | 储油罐 |
| industrial_complex | 民用工厂 |
| industrial_infrastructure | 大容量电网 |
| infrastructure | 基础设施 |
| land_facility | 地面战设施 |
| landmark_berlin_reichstag | 帝国议会 |
| landmark_berlin_volkshalle | 人民大厅 |
| landmark_big_ben | 大本钟 |
| landmark_colosseum | 罗马竞技场 |
| landmark_cristo_redentor | 里约热内卢基督像 |
| landmark_eiffel_tower | 埃菲尔铁塔 |
| landmark_forbidden_city | 紫禁城 |
| landmark_great_wall_section | 万里长城 |
| landmark_hagia_sophia | 圣索菲亚 |
| landmark_hakko_ichiu | 八纮一宇塔 |
| landmark_hofburg_palace | 霍夫堡宫 |
| landmark_kremlin | 克里姆林宫 |
| landmark_nanjing_presidential_palace | 南京总统府 |
| landmark_nanjing_presidential_palace_gen | 南京总统府 |
| landmark_nanjing_presidential_palace_prc | 南京总统府 |
| landmark_national_diet | 国会议事堂 |
| landmark_sadabad_complex | 萨德阿巴德宫 |
| landmark_statue_of_liberty | 自由女神像 |
| landmark_taj_mahal | 泰姬陵 |
| landmark_tokyo_imperial_palace | 皇居 |
| mega_gun_emplacement | 多级加速大口径火炮 |
| naval_base | 海军基地 |
| naval_facility | 海军工程设施 |
| naval_headquarters | 海军指挥部 |
| naval_supply_hub | 海军补给中心 |
| nuclear_facility | 核研究设施 |
| nuclear_reactor | 核反应堆 |
| nuclear_reactor_heavy_water | 重水核反应堆 |
| radar_station | 雷达站 |
| rail_way | 铁路 |
| rocket_site | 火箭基地 |
| stronghold_network | 要塞群 |
| supply_node | 补给中心 |
| synthetic_refinery | 合成炼油厂 |

## 建筑代码速查

### 在某个州建造建筑

`add_building_construction` 是最常用的建筑 effect。把它放在某个 state scope 里，就会在该州添加对应建筑。

```txt
123 = {
	add_building_construction = {
		type = industrial_complex
		level = 1
		instant_build = yes
	}
}
```

常见参数：

| 参数 | 含义 |
| --- | --- |
| `type` | 建筑键，例如 `industrial_complex`、`arms_factory`、`bunker` |
| `level` | 增加的等级或数量 |
| `instant_build` | `yes` 为立即完成，`no` 或不写则进入建造队列 |
| `province` | 可选；写了以后表示在州内指定省份建造 |

原版常见写法：

```txt
random_owned_controlled_state = {
	limit = {
		free_building_slots = {
			building = arms_factory
			size > 0
			include_locked = yes
		}
	}
	add_extra_state_shared_building_slots = 1
	add_building_construction = {
		type = arms_factory
		level = 1
		instant_build = yes
	}
}
```

这里的思路是：先补 1 个共享建筑位，再在该州直接落 1 级 `arms_factory`。

需要特别注意：

- `industrial_complex`、`arms_factory`、`dockyard` 会占用共享建筑槽
- `energy_infrastructure`、`industrial_infrastructure` 也会占用共享建筑槽
- `air_facility`、`land_facility` 不占用共享建筑槽
- 因此如果奖励脚本直接发放 `energy_infrastructure` 或 `industrial_infrastructure`，通常也应同步补足 `add_extra_state_shared_building_slots`

### 在州内指定省份建造建筑

如果目标建筑是省份级建筑，或者你想把建筑精确落在某个 province 上，可以在同一个 `add_building_construction` 里加 `province = <province id>`。

```txt
815 = {
	add_building_construction = {
		type = bunker
		province = 9246
		level = 2
		instant_build = yes
	}
}
```

原版也大量使用这种写法来给边境省份修筑要塞：

```txt
814 = {
	add_building_construction = { type = bunker province = 6281 level = 1 instant_build = yes }
}
815 = {
	add_building_construction = { type = bunker province = 9246 level = 2 instant_build = yes }
	add_building_construction = { type = bunker province = 11226 level = 2 instant_build = yes }
}
```

### 一次指定多个省份

如果要对州内多个省份统一设置建筑等级，`set_building_level` 往往比连续写多条 `add_building_construction` 更方便。

```txt
613 = {
	set_building_level = {
		type = bunker
		province = {
			id = 11913
			id = 10076
			id = 7014
		}
		level = 2
		instant_build = yes
	}
}
```

这类写法适合“把若干指定省份直接设为固定等级”的场景。

### `add_building_construction` 与 `set_building_level` 的区别

| effect | 更适合的用途 |
| --- | --- |
| `add_building_construction` | 给某州或某省份新增建筑等级；最像“奖励建造一个建筑” |
| `set_building_level` | 把目标建筑直接设为某个等级；适合补齐防线、统一校正建筑等级 |

可以把它们简单理解为：

- `add_building_construction` 更偏“增加”
- `set_building_level` 更偏“覆盖到指定等级”

### 建筑位相关

对于 `industrial_complex`、`arms_factory` 这类共享建筑位建筑，如果州里没有空位，常常要先补建筑位，再落建筑：

```txt
123 = {
	add_extra_state_shared_building_slots = 1
	add_building_construction = {
		type = industrial_complex
		level = 1
		instant_build = yes
	}
}
```

实际写脚本时可以先用 `free_building_slots` 之类的 trigger 检查是否有空位，再决定是否补槽。

### 使用建议

- 州级建筑直接在 `state scope` 里写 `add_building_construction`
- 省份级建筑或要塞线定点施工时，加 `province = <province id>`
- 想把多个点位统一拉到固定等级时，优先考虑 `set_building_level`
- 涉及工厂类建筑时，记得同时考虑共享建筑位是否足够

### 铁路的特殊写法
铁路通常不使用 `add_building_construction`，而是使用专门的 `build_railway`。

参考写法：
```txt
build_railway = {
	level = 5
	build_only_on_allied = yes
	fallback = yes
	start_province = 5010
	target_province = 12812
}
```

常见参数：
| 参数 | 含义 |
| --- | --- |
| `level` | 目标铁路等级；本项目通常默认写 `5` |
| `build_only_on_allied` | 只在己方或同盟控制省份上建造；本项目通常默认写 `yes` |
| `fallback` | 当理想路径不可用时允许回退寻找可行路线；本项目通常默认写 `yes` |
| `start_province` | 铁路起点省份 |
| `target_province` | 铁路终点省份 |

项目内默认习惯：

- `level = 5`
- `build_only_on_allied = yes`
- `fallback = yes`

适用场景：

- 连接两个关键地区或枢纽省份
- 国策、决议、事件中直接铺设一整段铁路
- 需要沿路径自动修到目标，而不是只在单个州里加建筑等级

使用建议：

- 优先确认起点和终点 `province id`
- 默认按“只在己方 / 同盟省份施工”来写，避免路线穿过不受控地区
- 除非你明确希望铁路因路径失败而不建成，否则 `fallback` 建议保持 `yes`
### 提升州地区类别
如果需要提高某个州的地区类别，可以使用 `set_state_category`。

原版有一个很适合参考的阶梯式写法：

```txt
ETH_upgrade_state_category = {
	IF = {
		limit = { has_state_category = wasteland }
		set_state_category = pastoral
	}
	ELSE_IF = {
		limit = { has_state_category = pastoral }
		set_state_category = rural
	}
	ELSE_IF = {
		limit = { has_state_category = rural }
		set_state_category = town
	}
	ELSE_IF = {
		limit = { has_state_category = town }
		set_state_category = large_town
	}
	ELSE_IF = {
		limit = { has_state_category = large_town }
		set_state_category = city
	}
	ELSE_IF = {
		limit = { has_state_category = city }
		set_state_category = large_city
	}
}
```

常见州类别升级顺序：

- `wasteland`
- `pastoral`
- `rural`
- `town`
- `large_town`
- `city`
- `large_city`

使用建议：

- 如果设计的是“地区开发计划”，可以把它封装成一个 `scripted_effect`，后续由国策、决议或事件反复调用
- 这种写法适合“每次提升一级”，比直接写死最终类别更稳妥
- 它常用于和建筑位、工业承载、地区开发阶段挂钩，但要注意它调整的是 `state category`，不是直接给建筑槽
- 如果你的设计同时要求增加共享建筑位，仍然需要另外写 `add_extra_state_shared_building_slots`

原版州类别列表：

| key | 原版本地化 |
| --- | --- |
| `tiny_island` | 极小岛屿 |
| `small_island` | 小岛 |
| `large_island` | 大型岛屿 |
| `city` | 城市 |
| `large_city` | 大型城市 |
| `town` | 城镇 |
| `large_town` | 大型城镇 |
| `enclave` | 飞地 |
| `metropolis` | 都市 |
| `pastoral` | 牧区 |
| `rural` | 乡村 |
| `megalopolis` | 特大都市 |
| `wasteland` | 荒地 |

和 `ETH_upgrade_state_category` 的对比：

- 这个脚本效果实际覆盖的链条只有：
  `wasteland -> pastoral -> rural -> town -> large_town -> city -> large_city`
- 也就是说，它适合“常规内陆地区逐级开发”
- 它没有处理这些类别：
  `tiny_island`、`small_island`、`large_island`、`enclave`、`metropolis`、`megalopolis`
- 因此如果目标州当前属于这些未覆盖类别，直接调用这个脚本效果不会生效

使用提醒：

- 对日本本土多数普通州，这条链通常够用
- 如果后面要处理岛屿州、飞地、或已经高于 `large_city` 的特殊都会州，最好单独补一套更完整的项目内 `scripted_effect`

项目内现成可复用写法：

```txt
JAP_upgrade_state_category_non_island = {
	IF = {
		limit = {
			OR = {
				has_state_category = wasteland
				has_state_category = enclave
			}
		}
		set_state_category = pastoral
	}
	ELSE_IF = {
		limit = { has_state_category = pastoral }
		set_state_category = rural
	}
	ELSE_IF = {
		limit = { has_state_category = rural }
		set_state_category = town
	}
	ELSE_IF = {
		limit = { has_state_category = town }
		set_state_category = large_town
	}
	ELSE_IF = {
		limit = { has_state_category = large_town }
		set_state_category = city
	}
	ELSE_IF = {
		limit = { has_state_category = city }
		set_state_category = large_city
	}
	ELSE_IF = {
		limit = { has_state_category = large_city }
		set_state_category = metropolis
	}
	ELSE_IF = {
		limit = { has_state_category = metropolis }
		set_state_category = megalopolis
	}
}
```

文件位置：

- [JAP_state_category_scripted_effects.txt](C:/Users/Administrator/Documents/Paradox%20Interactive/Hearts%20of%20Iron%20IV/mod/Japan_rework/common/scripted_effects/JAP_state_category_scripted_effects.txt)

这条 effect 的特点：

- 覆盖全部非岛屿类别
- 额外把 `enclave` 也并入最低级开发起点
- 开发链终点是 `megalopolis`
- 不处理任何 `island` 类别，所以不会误改岛屿州的特殊海空基地上限逻辑

原版州类别数值信息：

| key | 中文名 | `local_building_slots` | 特殊上限 | 备注 |
| --- | --- | --- | --- | --- |
| `wasteland` | 荒地 | 0 | 无 | 在 `ETH_upgrade_state_category` 升级链中 |
| `pastoral` | 牧区 | 1 | 无 | 在升级链中 |
| `rural` | 乡村 | 2 | 无 | 在升级链中 |
| `town` | 城镇 | 4 | 无 | 在升级链中 |
| `large_town` | 大型城镇 | 5 | 无 | 在升级链中 |
| `city` | 城市 | 6 | 无 | 在升级链中 |
| `large_city` | 大型城市 | 8 | 无 | 升级链终点 |
| `metropolis` | 都市 | 10 | 无 | 不在 `ETH_upgrade_state_category` 链中 |
| `megalopolis` | 特大都市 | 12 | 无 | 不在升级链中 |
| `enclave` | 飞地 | 0 | 无 | 不在升级链中 |
| `tiny_island` | 极小岛屿 | 0 | `naval_base = 3` `air_base = 2` | 不在升级链中 |
| `small_island` | 小岛 | 1 | `naval_base = 6` `air_base = 4` | 不在升级链中 |
| `large_island` | 大型岛屿 | 3 | `naval_base = 8` `air_base = 6` | 不在升级链中 |

补充观察：

- 常规陆地开发链的建筑槽增长是：
  `0 -> 1 -> 2 -> 4 -> 5 -> 6 -> 8`
- `metropolis` 和 `megalopolis` 继续把本地建筑槽提高到 `10` 与 `12`
- 岛屿类别除了建筑槽外，还单独定义了 `naval_base` 与 `air_base` 的等级上限
- `enclave`、`wasteland`、`tiny_island` 都是 `0` 本地建筑槽，但语义完全不同，设计时不要混用
