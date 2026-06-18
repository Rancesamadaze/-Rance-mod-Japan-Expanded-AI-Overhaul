# AI 空军生产系统维护参考

## 维护定位

- 记录日本 AI 空军产线重置、阈值变量、scripted trigger 和工厂占比策略。
- 陆军产线维护可交叉参考 `Reference/ai_land_production_maintenance_reference.md`。
- 空军额外装备补给可交叉参考 `Reference/ai_extra_equipment_maintenance_reference.md`。

## 空军 unit_ratio 维护规则

- 日本不吃原版/`rookie_basic` 的泛用空军 `unit_ratio`。`common/ai_strategy/default.txt` 克隆自 `rookie_basic`，并在 `bba_air_prod_1`、`build_patrol_bombers`、`default_spyplanes_production`、`minors_dont_spy` 中排除 `original_tag = JAP`。
- 日本空军部署比例集中写在 `common/ai_strategy/JAP_rework_ai_air_production.txt`，常态键为 `JAP_rework_air_unit_ratio_baseline`。
- 当前常态部署比例：`fighter = 500`、`cas = 20`、`strategic_bomber = 5`、`heavy_fighter = 1`、`cv_fighter = 5`、`cv_naval_bomber = 5`。`tactical_bomber` 与 `naval_bomber` 不写正数 `unit_ratio`，生产侧封禁。
- 轻型战斗机作为空军产能主缓冲池：高库存减产只使用 `equipment_production_factor fighter = -40`，不再使用 `build_airplane fighter = -99999` 硬切断生产，避免释放出的空军工厂挤到海巡轰、洲际轰等小众机种。
- 不要给飞机写负数 `unit_ratio`，也不要用库存阈值把正数 `unit_ratio` 关成 `0`；这两种做法都会压低 AI 部署目标，容易导致 AI 不再部署对应飞机。需要减产时使用 `equipment_production_factor`、`equipment_production_min_factories`、`build_airplane` 或 `air_factory_balance`。
- 海军巡逻轰炸机的正数 ratio 使用 `JAP_rework_maritime_patrol_plane_unit_ratio` 单独调试：有 BBA、海军规模有效且已有海军巡逻轰炸机设计时保持 `unit_ratio id = maritime_patrol_plane value = 2`，不按高库存关闭部署比例。

## 开发归档

> 归档时间：2026-05-22。以下内容从 `CHANGELOG` 迁入 `Reference`，用于保留设计背景、调参依据和已完成/待办记录。日常维护时可在本文前部继续补充新的维护索引。
### 来源：`CHANGELOG/ai_production_line/ai_production_air_rework_plan`

### 空军 AI 生产重置计划

#### 当前目标

空军生产 v2 先将旧策略里的飞机数量判断脚本条件化，并将各飞机的临界值变量化。

当前阶段只记录各飞机自己的数量阈值，不在阈值脚本条件中加入飞机间联动。

数量计算口径：

```txt
库存数量 + 已部署飞机数量
```

对应脚本写法：

```txt
set_temp_variable = { air_total = num_equipment@aircraft_archetype }
add_to_temp_variable = { var = air_total value = num_deployed_planes_with_type@aircraft_archetype }
```

低阈值表示：该飞机总量低于此值时，进入增产候选。

高阈值表示：该飞机总量高于此值时，进入减产候选。

阈值变量初始化位置：

```txt
history/countries/JAP - Japan.txt
```

脚本条件位置：

```txt
common/scripted_triggers/JAP_ai_air_production_scripted_triggers.txt
```

#### 当前阈值变量表

| 飞机对象 | 装备/archetype | 低阈值变量 | 低阈值意义 | 当前值 | 高阈值变量 | 高阈值意义 | 当前值 |
| --- | --- | --- | --- | ---: | --- | --- | ---: |
| 轻型战斗机 | `small_plane_airframe` | `Rance_fighter_low_threshold` | 轻型战斗机总量低于该值时进入增产候选 | 5000 | `Rance_fighter_high_threshold` | 轻型战斗机总量高于该值时进入减产候选 | 10000 |
| CAS | `small_plane_cas_airframe` | `Rance_cas_low_threshold` | CAS 总量低于该值时进入增产候选 | 1000 | `Rance_cas_high_threshold` | CAS 总量高于该值时进入减产候选 | 6000 |
| 重型战斗机 | `medium_plane_fighter_airframe` | `Rance_heavy_fighter_low_threshold` | 重型战斗机总量低于该值时进入增产候选 | 500 | `Rance_heavy_fighter_high_threshold` | 重型战斗机总量高于该值时进入减产候选 | 3000 |
| 海军巡逻轰炸机 | `large_plane_maritime_patrol_plane_airframe` | `Rance_maritime_patrol_plane_low_threshold` | 海军巡逻轰炸机总量低于该值时进入增产候选 | 200 | `Rance_maritime_patrol_plane_high_threshold` | 海军巡逻轰炸机总量高于该值时进入减产候选 | 800 |
| 洲际轰炸机 | `strat_bomber_intercontinental_equipment` | `Rance_intercontinental_bomber_low_threshold` | 洲际轰炸机总量低于该值时进入增产候选 | 200 | `Rance_intercontinental_bomber_high_threshold` | 洲际轰炸机总量高于该值时进入减产候选 | 800 |
| 空天母舰 | `mothership_equipment` | `Rance_mothership_low_threshold` | 空天母舰总量低于该值时进入增产候选 | 250 | `Rance_mothership_high_threshold` | 空天母舰总量高于该值时进入减产候选 | 1000 |

#### 当前 scripted trigger 表

| 飞机对象 | 低阈值 scripted trigger | 高阈值 scripted trigger |
| --- | --- | --- |
| 轻型战斗机 | `JAP_ai_air_production_fighter_below_low_threshold` | `JAP_ai_air_production_fighter_above_high_threshold` |
| CAS | `JAP_ai_air_production_cas_below_low_threshold` | `JAP_ai_air_production_cas_above_high_threshold` |
| 重型战斗机 | `JAP_ai_air_production_heavy_fighter_below_low_threshold` | `JAP_ai_air_production_heavy_fighter_above_high_threshold` |
| 海军巡逻轰炸机 | `JAP_ai_air_production_maritime_patrol_plane_below_low_threshold` | `JAP_ai_air_production_maritime_patrol_plane_above_high_threshold` |
| 洲际轰炸机 | `JAP_ai_air_production_intercontinental_bomber_below_low_threshold` | `JAP_ai_air_production_intercontinental_bomber_above_high_threshold` |
| 空天母舰 | `JAP_ai_air_production_mothership_below_low_threshold` | `JAP_ai_air_production_mothership_above_high_threshold` |

#### 空军工厂占比修正

默认空军工厂占比策略：

```txt
ai_strategy = {
	type = air_factory_balance
	value = 33
}
```

新增高库存修正策略：

```txt
ai_strategy = {
	type = air_factory_balance
	value = -23
}
```

启用条件：

- 轻型战斗机、CAS、重型战斗机、海军巡逻轰炸机、洲际轰炸机、空天母舰全部高于各自高阈值。

中止条件：

- 任一上述飞机低于自己的低阈值。

目标效果：

- 全机种高库存时，将空军工厂占比从 `33` 修正到 `10`。

#### 旧策略停止阈值迁移表

以下 scripted trigger 用于等价迁移旧策略中的停止条件，当前数值沿用旧策略。

| 飞机对象 | scripted trigger | 条件意义 | 当前值 |
| --- | --- | --- | ---: |
| 轻型战斗机 | `JAP_ai_air_production_fighter_below_reduce_stop_threshold` | 轻型战斗机减产停止阈值 | 7000 |
| CAS | `JAP_ai_air_production_cas_above_increase_stop_threshold` | CAS 增产停止阈值 | 2500 |
| CAS | `JAP_ai_air_production_cas_below_reduce_stop_threshold` | CAS 减产停止阈值 | 4000 |
| 重型战斗机 | `JAP_ai_air_production_heavy_fighter_above_increase_stop_threshold` | 重型战斗机增产停止阈值 | 1500 |
| 重型战斗机 | `JAP_ai_air_production_heavy_fighter_below_reduce_stop_threshold` | 重型战斗机减产停止阈值 | 2000 |
| 海军巡逻轰炸机 | `JAP_ai_air_production_maritime_patrol_plane_above_increase_stop_threshold` | 海军巡逻轰炸机增产停止阈值 | 400 |
| 海军巡逻轰炸机 | `JAP_ai_air_production_maritime_patrol_plane_below_reduce_stop_threshold` | 海军巡逻轰炸机减产停止阈值 | 600 |
| 洲际轰炸机 | `JAP_ai_air_production_intercontinental_bomber_above_increase_stop_threshold` | 洲际轰炸机增产停止阈值 | 400 |
| 洲际轰炸机 | `JAP_ai_air_production_intercontinental_bomber_below_reduce_stop_threshold` | 洲际轰炸机减产停止阈值 | 600 |
| 空天母舰 | `JAP_ai_air_production_mothership_below_reduce_stop_threshold` | 空天母舰减产停止阈值 | 750 |
| 空天母舰 | `JAP_ai_air_production_mothership_above_increase_stop_threshold` | 空天母舰增产停止阈值 | 500 |

#### 待定事项

- 空天母舰由于 `common/units/air.txt` 中与轻型战斗机同为 `type = fighter`，后续仍需要单独处理生产策略。
- 当前已将旧空军生产策略中的飞机数量条件块替换为 scripted trigger 调用。
