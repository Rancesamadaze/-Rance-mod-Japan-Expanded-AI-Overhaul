# 陆军学说 v1.19 差异与 MOD 处理建议

日期：2026-06-13

范围：
- `common/doctrines/grand_doctrines/land_grand_doctrines.txt`
- `common/doctrines/subdoctrines/land/armor_subdoctrines.txt`
- `common/doctrines/subdoctrines/land/combat_support_subdoctrines.txt`
- `common/doctrines/subdoctrines/land/infantry_subdoctrines.txt`
- `common/doctrines/subdoctrines/land/operations_subdoctrines.txt`

本报告只做分析和处理建议，不直接修改 live 学说文件。

## 总判断

本 MOD 对陆军学说做过广泛重置，尤其是陆军子学说的节点命名、奖励分布和数值曲线已经和原版不同。因此本轮不能用“新版原版覆盖 MOD”的方式处理。

v1.19 的学说改动可以分成三类：

1. 新团级支援系统兼容项：优先处理。当前 MOD 快照几乎没有 `category_regimental_support_battalions`、`category_regimental_support_artillery`、`anti_tank_battery`、`anti_air_battery`、`field_guns`、`fire_support`、`mot_fire_support`、`category_tank_destroyer_regimental_support`、`category_self_propelled_anti_air_regimental_support` 等新 key。若不补，MOD 会让新团级支援单位吃不到许多学说收益。
2. 纯数值平衡项：默认不直接合入。比如 `continuous_offensives` 给装甲额外突破、`quick_decision_offensive_warfare` 增强民兵主动性、`shoot_and_scoot` 削弱自行单位组织和恢复。这些要服从 MOD 已有再平衡。
3. 语义修正和 DLC 可用性项：倾向合入或等价处理。比如部分 `battalion_mult` 新增 `add = yes`，以及印尼相关的 `available` 条件。这些不是单纯平衡，更多是兼容或脚本语义修正。

实际合入时建议先做“结构兼容 pass”，再做“数值平衡 pass”。不要在同一轮里把所有原版数值照搬，否则很容易破坏 MOD 已经建立的学说强度曲线。

## 合入标签

- `合入`：可以按原版意图直接加入，或当前 MOD 没有等价设计。
- `调整合入`：要合入新系统挂钩，但数值或落点要按 MOD 学说重置调整。
- `不合入`：纯原版平衡项，暂不照搬。
- `已满足`：MOD 当前设计已经覆盖或比原版更宽，不需要额外动作。
- `待验证`：仍需要进游戏确认显示、DLC 条件或数值体验；单位分类倒查已完成。

## 跨文件原则

1. 对新团级支援单位，优先保证“有学说收益”，但不保证“完全等于原版收益”。
2. 单位分类倒查已完成，详见 `update_fit/reports/regimental_support_category_trace.md`。
3. 全部团属支援连都吃 `category_army`，因此 MOD 已有 `category_army` 同属性加成时，不再用 `category_regimental_support_battalions` 完整叠同一属性。
4. 普通团属支援、团属火力、团属炮兵、团属反坦克、防空炮组不吃 `category_all_infantry`。步兵学说想让它们受益，必须显式补 `fire_support`、`mot_fire_support`、`category_regimental_support_artillery`、`anti_tank_battery`、`anti_air_battery` 等。
5. 团属坦歼和团属自行防空吃 `category_all_armor`。装甲学说里如果已有 `category_all_armor` 组织、突破、硬攻等同属性加成，就只补 `air_attack`、`ap_attack` 等未覆盖角色属性，避免重复加成。
6. 原版把旧单位收益迁移到新单位时，优先采用“迁移式调整”，不是“保留旧收益再叠新收益”。
7. 对 MOD 已经明显削弱或重排的节点，新增团级支援数值建议先按原版的 50% 到 100% 区间落地，测试后再上调。
8. 新增完整学说 `dispersed_operations` 属于 DLC 新内容，应整体合入，然后再评估数值是否需要跟 MOD 的作战分支一起再平衡。

## 逐文件建议

### `land_grand_doctrines.txt`

原版 v1.19 只在四个陆军总学说的里程碑中新增 `category_regimental_support_battalions`。当前 MOD 没有这些新 key。

| 原版位置 | v1.19 变化 | MOD 当前风险 | 建议 |
| --- | --- | --- | --- |
| `new_mobile_warfare` | 原版里程碑给团属支援营 `max_organisation = 10`，`breakthrough = 0.1` | MOD 已有全军突破方向，团属支援吃 `category_army` | `调整合入`。不按原版里程碑放置；在总学说基础 `# EFFECTS` 给 `category_regimental_support_battalions = { max_organisation = 10 }`，不补突破。 |
| `superior_firepower` | 原版里程碑给团属支援营 `soft_attack = 0.05`，`hard_attack = 0.05` | 用户判断 MOD 在其他里程碑已经给过 `category_army` 软攻 | `调整合入`。不补原版火力；在总学说基础 `# EFFECTS` 给 `category_regimental_support_battalions = { max_organisation = 5 supply_consumption = -0.02 }`。 |
| `grand_battleplan` | 原版里程碑给团属支援营 `defense = 0.1`，`entrenchment = 0.2` | MOD 整条总学说已经给足计划、堑壕、协同和增援定位 | `调整合入`。不补原版防御/堑壕；在总学说基础 `# EFFECTS` 给 `category_regimental_support_battalions = { max_organisation = 10 }`。 |
| `mass_assault` | 原版里程碑给团属支援营 `supply_consumption = -0.02`，`default_morale = 0.1` | MOD 已有 `category_army` 高恢复率，覆盖团属支援 | `调整合入`。在总学说基础 `# EFFECTS` 给 `category_regimental_support_battalions = { max_organisation = 5 supply_consumption = -0.02 }`；不补恢复率。 |

结论：总学说不再把团属支援补偿塞进里程碑。统一按“选用总学说即生效”的基础效果处理：机动作战 `+10` 组织，决战计划 `+10` 组织，优势火力 `+5` 组织并 `-0.02` 补给消耗，人海突击 `+5` 组织并 `-0.02` 补给消耗。

补充自建特殊学说：

| 学说 | 建议 |
| --- | --- |
| `rance_furinkazan` | 在基础 `# EFFECTS` 加 `category_regimental_support_battalions = { max_organisation = 10 }`，不放入里程碑。 |

### `armor_subdoctrines.txt`

装甲子学说的改动主要是把装甲线的一部分收益挂到新团级自行防空、团级坦歼、反坦克炮组和摩托化火力支援上，同时有少量纯装甲平衡调整。

| 原版位置 | v1.19 变化 | 建议 |
| --- | --- | --- |
| `armored_spearhead/local_reserves` | 新增 `category_self_propelled_anti_air_regimental_support = { max_organisation = 10 air_attack = 0.05 }` | `调整合入`。团属自行防空吃 `category_all_armor`；若映射节点已有装甲组织加成，只补 `air_attack = 0.05`。若无组织来源，再补 `max_organisation = 5`。 |
| `armored_infantry_support/armored_cohorts` | 新增 `category_tank_destroyer_regimental_support = { max_organisation = 5 ap_attack = 0.1 }` | `调整合入`。团属坦歼吃 `category_all_armor`；若映射节点已有装甲组织加成，只补 `ap_attack = 0.1`。 |
| `mobile_armored_strongpoints` | 新增 `heavy_sp_anti_air_support = { max_organisation = 5 air_attack = 0.1 }` | `合入`。单位定义存在，且 MOD 不覆盖 `sp_anti-air_brigade.txt`；若节点已有装甲组织加成，只补 `air_attack = 0.1`。 |
| `continuous_offensives` | `category_all_armor` 新增 `breakthrough = 0.1` | `不合入`。这是纯装甲突破增强，MOD 已有自己的装甲突破曲线。 |
| `mobile_defense` 的 `armored_engineer` | `battalion_mult` 新增 `add = yes` | `已满足`。MOD 对等工程装甲效果已使用 `add = yes`。后续 live 合入时再复核一次。 |
| `mobile_defense/attached_support` | 新增团级自行防空支援组织和防空 | `调整合入`。优先补 `air_attack = 0.05`；组织只在映射节点没有 `category_all_armor` 组织收益时补 `max_organisation = 5`。 |
| `mobile_defense/combined_anti_armor` | 新增团级坦歼 `max_organisation = 5 hard_attack = 0.05 ap_attack = 0.15` | `调整合入`。优先补 `ap_attack = 0.1-0.15`；`hard_attack` 和组织视映射节点已有 `category_all_armor` / `category_tank_destroyers` 收益决定。 |
| `armored_cavalry/fighting_reconnaissance` | 新增 `anti_tank_battery` 穿甲，新增 `mot_fire_support` 组织、软攻、恢复率 | `合入`。该线本来就是侦察/机动作战，团级机动火力支援应该吃到收益。 |
| `armored_cavalry_no_lar` 对应节点 | 新增反坦克炮组和摩托化火力支援 | `合入`。和 LAR 版本保持等价，但反坦克炮组按原版较低值处理。 |
| `tank_destroyer_force/selfsufficient_battalion` | `armored_signal` 对坦歼的 `ap_attack` 从 `0.2` 降到 `0.1`，新增团级坦歼支援 | `调整合入`。MOD 没有同名节点，不合入原版削弱；团属坦歼已吃 `category_all_armor` 和 `category_tank_destroyers`，优先补 `category_tank_destroyer_regimental_support = { ap_attack = 0.1 }`，硬攻/组织只在缺口明确时补。 |

结论：装甲文件重点不是复制原版节点名，而是给 MOD 的装甲突击、装甲步兵、机动防御、装甲骑兵、坦歼五条功能线补新团级支援挂钩。由于团属坦歼和团属自行防空已吃 `category_all_armor`，装甲线新增项应偏向 `air_attack`、`ap_attack` 等角色属性，组织/突破不作为默认补项。

### `combat_support_subdoctrines.txt`

这是本轮最复杂的文件。原版把炮兵、反坦克、防空、自行支援、工程支援的大量收益分配给新团级支援系统。

| 原版位置 | v1.19 变化 | 建议 |
| --- | --- | --- |
| `fire_concentration/artillery_groups` | 从单纯线列炮兵突破，扩展为线列炮兵、支援炮兵、团级支援炮兵的软攻和突破 | `调整合入`。必须补 `category_regimental_support_artillery`，因为 `field_guns`/`rocket_battery` 不吃 `category_line_artillery` 或 `category_all_infantry`。`category_support_artillery` 可一并补；线列炮兵新增 `soft_attack = 0.05` 属于平衡增强，先不直接合入。 |
| `anti_tank_frontline/pakfront` | 旧反坦克旅防御和软攻从 `pakfront` 迁到后续节点；新增 `anti_tank_battery` 硬攻和穿甲 | `调整合入`。`anti_tank_battery` 已吃 `category_anti_tank` 和 `category_mobile_anti_tank`，先确认 MOD 现有反坦宽分类收益；仍建议采用迁移式处理，不在旧 `pakfront` 全套上再叠新炮组。 |
| `flying_batteries/deployment_drills` | 新增 `mot_fire_support = { max_organisation = 10 soft_attack = 0.1 }` | `调整合入`。MOD 同节点存在，建议先补 `max_organisation = 5-10`、`soft_attack = 0.05-0.1`。 |
| `flying_batteries/ballistics_corrections` | 把 `supply_consumption = -0.01` 放入带 `add = yes` 的独立 `battalion_mult`，`initiative = 0.02` 保持单独乘区 | `合入`。这是脚本语义修正，建议按原版拆开，避免补给消耗被错误解释。 |
| `mobile_recon_and_assault/motorization_support` | 原版改用 `category_mobile_and_mobile_combat_sup`，并新增 `mot_fire_support` | `调整合入`。不建议替换 MOD 的宽分类设计；只补 `mot_fire_support`。 |
| `mobile_recon_and_assault/deep_reconnaissance_focus` | 新增团级坦歼和团级自行防空突破 | `调整合入`。团属坦歼/自行防空已吃 `category_all_armor`，若 MOD 该节点已有装甲突破收益，则不再完整叠加；只在缺口明确时补 `breakthrough = 0.1-0.2`。 |
| `self_propelled_support/multirole_support_vehicles` | 原版删除旧自行炮/自行防空/坦歼的部分收益，改给团级坦歼和团级自行防空支援 | `调整合入`。不要直接删除 MOD 现有自行支援收益；团属坦歼/自行防空已吃 `category_all_armor`，优先补专属 `air_attack`、`ap_attack`/`hard_attack`，组织和突破只补半档或不补。 |
| `self_propelled_support/shoot_and_scoot` | 原版削弱自行单位组织和恢复率，并新增少量火力 | `不合入`。这是纯平衡重调，和 MOD 自行支援路线强度直接冲突。 |
| `siege_artillery/urban_strongpoint_sieges` | 新增 `fire_support` 和 `category_regimental_support_artillery` 软攻 | `合入`。围城炮兵线应覆盖团级火力支援。 |
| `field_engineering/rapid_fire_lane_clearance` | 工程营堑壕加成从 `0.02` 提到 `0.1` 并加 `add = yes` | `不合入` 或 `手工平衡`。这是大幅强化，不属于新系统必要挂钩。MOD 当前工程线已更细分。 |
| `field_engineering/engineerdug_gun_emplacements` | 新增 `field_guns = { soft_attack = 0.1 defense = 0.1 }` | `合入`。这是新团级野战炮收益。 |
| `field_engineering/charge_and_flame` | 新增 `fire_support = { max_organisation = 5 breakthrough = 0.1 }` | `合入`。工程突击和团级火力支援有明确功能关系。 |

结论：战斗支援文件应优先做迁移式合入，尤其是 `pakfront` 和 `multirole_support_vehicles`，否则容易出现旧单位收益保留、新单位收益叠加，导致反坦克和自行支援路线过强。

### `infantry_subdoctrines.txt`

步兵子学说同时包含团级支援火力补挂、步兵突破增强、民兵增强、印尼 DLC 可用性修正。

| 原版位置 | v1.19 变化 | 建议 |
| --- | --- | --- |
| `mobile_infantry` 基础效果 | 新增 `category_all_infantry = { breakthrough = 0.1 }` | `不合入`。这是纯步兵突破增强，且不会覆盖团属支援连；MOD 已把机动步兵线大幅重排。 |
| `mobile_infantry/decisive_operations` | 新增团级支援炮兵 `soft_attack = 0.15` | `调整合入`。MOD 当前该节点削弱了车辆步兵组织并加入防御/突破/补给，建议团级支援炮兵先用 `soft_attack = 0.05-0.1`。 |
| `mobile_infantry/maneuver_warfare` | 新增 `mot_fire_support` 组织和软攻 | `调整合入`。建议补 `max_organisation = 5`，`soft_attack = 0.05-0.1`，不改变 MOD 的步兵速度曲线。 |
| `defensive_postures/improvised_fighting_position` | 新增 `fire_support` 补给消耗和软攻 | `调整合入`。建议补 `supply_consumption = -0.01`，软攻先用 `0.1`，不直接给满 `0.2`。 |
| `defensive_postures/field_emplacements` | 新增团级支援炮兵软攻 `0.2` | `调整合入`。建议先用 `0.1`，防止防御线早期火力过高。 |
| `large_unit_tactics/large_front_offensive` | 新增 `fire_support` 突破和团级支援炮兵软攻 | `调整合入`。MOD 当前全步兵软攻只有 `0.05`，建议新团级项也先按 `0.05` 到 `0.1`。 |
| `assault_infantry/low_echelon_fire_support` | 新增 `field_guns` 软攻 `0.2` | `调整合入`。建议先用 `0.1`，因为 MOD 已有 `artillery` 对轻步兵的高额乘区。 |
| `assault_infantry/organic_battalion_fire_support` | 从旧支援炮兵/反坦/防空，迁移到团级支援炮兵、反坦克炮组、防空炮组 | `调整合入`。建议按原版迁移结构处理：该节点主打团级支援单位；旧支援连收益移到 `integrated_support_batteries`。 |
| `assault_infantry/integrated_support_batteries` | 支援炮兵软攻从 `0.1` 降到 `0.05`，并给支援反坦/防空组织和火力 | `调整合入`。建议采用原版迁移逻辑，避免旧支援连和新团级炮组在同一早期节点同时吃满。 |
| `assault_infantry/assault_detachments` | 新增团级支援炮兵补给消耗 `-0.01` | `合入`。 |
| `mounted_infantry` | 主要是格式修正 | `不处理`。 |
| `commandos/isolated_combat_elements` | 新增团级支援炮兵补给和软攻 | `调整合入`。建议补给按原版，软攻先用 `0.05`。 |
| `commandos/combined_operations` | 新增反坦克炮组对轻步兵硬攻乘区 | `合入`。突击队线覆盖轻步兵反装甲能力合理。 |
| `commandos/integrated_assaults` | 新增团级支援炮兵、`fire_support`、`mot_fire_support` 突破 | `调整合入`。建议先用 `breakthrough = 0.1`，不要直接给所有团级火力 `0.15`。 |
| `peoples_war/available` | 印尼 `INS_underground_revolution` 可解锁人民战争 | `合入`。这是 DLC 兼容，不是平衡项。 |
| `peoples_war/destruction_over_land_gains` | 新增 `field_guns` 软攻 `0.15` | `调整合入`。人民战争线可以给野战炮火力，但建议先用 `0.1`。 |
| `peoples_war/quick_decision_offensive_warfare` | 民兵 `initiative` 从 `0.01` 到 `0.015` | `不合入`。纯数值增强，且 MOD 当前保留旧值。 |
| `great_war_infantry/traverse_digging` | 新增 `fire_support`，工程营 `battalion_mult` 加 `add = yes` | `合入`。`add = yes` 是语义修正；`fire_support` 是新系统兼容。 |
| `great_war_infantry/centralized_artillery_control` | 新增团级支援炮兵软攻 `0.2` | `调整合入`。建议先用 `0.1`，因为一战步兵线本身偏防御和堑壕，不宜过度火力化。 |

结论：步兵文件最需要“迁移式合入”的是 `assault_infantry`。其他节点可以先补团级支援单位，但数值建议降档。

### `operations_subdoctrines.txt`

作战子学说有两个重点：一是大量团级支援补挂，二是新增完整 `dispersed_operations` 学说。

| 原版位置 | v1.19 变化 | 建议 |
| --- | --- | --- |
| `mission_type_tactics/low_level_delegation` | 新增团级支援炮兵组织和软攻 | `调整合入`。MOD 当前给 `category_army` 组织，已覆盖全部团属支援组织；只补 `category_regimental_support_artillery = { soft_attack = 0.05 }`。 |
| `last_stand/available` | 印尼革命旗帜可满足防御战条件 | `已满足`。MOD 当前 `last_stand` 是 `always = yes`，比原版更宽。若未来收紧可用性，再按原版 INS 条件合入。 |
| `last_stand/breaking_out` | 原版全军软攻从 `0.2` 降到 `0.15`，新增团级支援炮兵 | `不合入` 团级支援软攻。MOD 当前 `category_army = { soft_attack = 0.1 }` 已覆盖全部团属支援；不需要再叠 `category_regimental_support_artillery`，除非设计上要让团属炮兵额外更强。 |
| `infiltration_tactics/infiltration_assault` | 新增 `fire_support` 软攻 | `合入`。渗透突击线补轻型火力支援合理。 |
| `grand_assault/multiple_attack_directions` | 新增 `fire_support` 软攻 | `调整合入`。建议补，但数值先不超过 `0.1`。 |
| `grand_assault/combined_arms_integration` | 移除原版坦克组织加成，改给团级坦歼、防空炮组、摩托化火力支援 | `调整合入`。团属坦歼吃 `category_all_armor`，不补坦克组织；补 `anti_air_battery` 和 `mot_fire_support` 的角色收益，团属坦歼只在无同类装甲收益时补。 |
| `grand_assault/forward_command_posts` | 后勤连补给乘区新增 `add = yes` | `不处理`。MOD 当前该节点没有对应后勤连补给效果。 |
| `deep_battle/breakthrough_priority` | 新增 `mot_fire_support` 组织和软攻 | `合入`。深层突破线补机动火力支援合理。 |
| `deep_battle/operational_depth_control` | 新增团级支援炮兵组织和软攻 | `合入`。作战纵深控制本身是大兵团协同，团级炮兵收益合理。 |
| `rapid_domination/forward_observers` | 新增团级支援炮兵突破 | `调整合入`。MOD 当前该节点偏侦察/增援率，建议补突破 `0.05-0.1`。 |
| `rapid_domination/advanced_firebases` | 新增团级支援炮兵软攻 | `调整合入`。建议补软攻 `0.05-0.1`，不替换 MOD 当前全军软攻设计。 |
| 新增 `dispersed_operations` | 新增完整作战子学说，DLC `Thunder at Our Gates` 可见；提供削弱敌空优影响、补给、局部防空、CAS 伤害减免、独立作战等 | `合入`。这是新 DLC 内容，不应被 MOD 覆盖掉。建议先整体合入原版结构，再在测试后决定是否下调 `enemy_army_bonus_air_superiority_factor`、`cas_damage_reduction`、`out_of_supply_factor`。 |

结论：`operations_subdoctrines.txt` 中 `dispersed_operations` 优先级最高。它不是几个数值，而是一整条新学说，当前 MOD 会完全吞掉。

## 建议的实际合入顺序

1. 先处理总学说基础效果：`new_mobile_warfare`、`grand_battleplan`、`superior_firepower`、`mass_assault`，以及自建 `rance_furinkazan`。
2. 再合入 `operations_subdoctrines.txt` 的 `dispersed_operations` 整块。
3. 再处理所有新团级支援单位挂钩，优先 `assault_infantry`、`combat_support` 三处。
4. 单独处理 `pakfront`、`organic_battalion_fire_support`、`integrated_support_batteries`、`multirole_support_vehicles` 这四个“原版迁移效果”节点，避免双重收益。
5. 单独处理 `add = yes` 语义修正：`ballistics_corrections`、`great_war_infantry/traverse_digging`，以及后续 live 文件里仍存在的同类 `battalion_mult`。
6. 暂缓纯数值平衡项：`continuous_offensives`、`shoot_and_scoot`、`quick_decision_offensive_warfare`、`mobile_infantry` 基础突破、工程堑壕大幅增强。

## 已验证清单

- 已确认 v1.19 新团级支援单位的宽分类归属，详见 `update_fit/reports/regimental_support_category_trace.md`。
- 已确认当前 MOD 没有覆盖 `common/units/fire_support.txt`、`common/units/tank_destroyer_brigade.txt`、`common/units/sp_anti-air_brigade.txt`；`descriptor.mod` 仅替换 `common/units/artillery_brigade.txt`。

## 待验证清单

- 进游戏看学说界面是否显示 `dispersed_operations`，并确认其 DLC 可见条件正常。
- 用一个日本 AI/玩家模板检查团级支援行是否能从学说得到预期火力、组织、防空、补给收益。

## 当前不建议立刻做的事

- 不建议整文件照搬 v1.19 原版学说。
- 不建议先做原版纯数值平衡项，再补新系统兼容。
- 不建议在旧支援连和新团级支援单位上同时保留原版迁移前、迁移后的全部收益。
- 不建议把 `dispersed_operations` 拆成零散数值补丁。它是一个完整新学说，应先以完整结构进入 MOD，再平衡。
