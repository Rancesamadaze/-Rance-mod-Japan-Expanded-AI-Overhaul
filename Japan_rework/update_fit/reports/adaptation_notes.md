# v1.19 Update Fit Notes

Vanilla base: `c13be7350567d17ffef02f0c4665a7d6ae5ce953`
Vanilla v1.19 update: `83777651df4db97a299bbd21fae772aec846f7cb`

Use this folder as a mod-side adaptation workspace. Keep the vanilla Git repository as the source timeline; use these copied files for side-by-side reading and notes.

## Folders

- `vanilla_pre_v1.19/`: the same paths before the v1.19 update.
- `vanilla_v1.19/`: the same paths after the v1.19 update.
- `mod_current/`: current mod files copied from the live mod workspace when present.
- `reports/`: changed file lists and the raw vanilla update diff.

## Review Checklist

- [x] `common/ai_navy/fleet/JAP_fleet_templates.txt` - mod present; vanilla v1.19 changes reviewed and merged through custom Rance naval invasion support template
- [x] `common/ai_strategy/JAP.txt` - mod present; vanilla v1.19 changes reviewed and selectively merged
- [x] `common/ai_strategy/default.txt` - mod present; vanilla v1.19 changes reviewed and merged
- [x] `common/ai_strategy_plans/JAP_alternate_strategy_plan.txt` - mod present; vanilla v1.19 changes reviewed; no gameplay merge needed
- [x] `common/ai_templates/templates_JAP.txt` - mod present; vanilla v1.19 changes reviewed; deferred to separate template design
- [x] `common/characters/JAP.txt` - mod present; vanilla v1.19 changes reviewed
- [x] `common/combat_tactics.txt` - mod present; vanilla v1.19 changes reviewed
- [x] `common/countries/cosmetic.txt` - mod present; vanilla v1.19 changes reviewed
- [x] `common/decisions/JAP.txt` - mod present; vanilla v1.19 changes reviewed and merged
- [x] `common/decisions/_generic_decisions.txt` - mod present; vanilla v1.19 changes reviewed and merged
- [x] `common/decisions/foreign_influence.txt` - mod present; vanilla v1.19 changes reviewed and merged
- [ ] `common/doctrines/grand_doctrines/land_grand_doctrines.txt` - mod present
- [ ] `common/doctrines/subdoctrines/land/armor_subdoctrines.txt` - mod present
- [ ] `common/doctrines/subdoctrines/land/combat_support_subdoctrines.txt` - mod present
- [ ] `common/doctrines/subdoctrines/land/infantry_subdoctrines.txt` - mod present
- [ ] `common/doctrines/subdoctrines/land/operations_subdoctrines.txt` - mod present
- [x] `common/ideas/_economic.txt` - mod present; vanilla v1.19 changes reviewed
- [x] `common/ideas/_manpower.txt` - mod present; vanilla v1.19 changes reviewed
- [ ] `common/national_focus/japan.txt` - mod present; first compatibility batch merged; special-forces rewards pending
- [x] `common/peace_conference/ai_peace/JAP.txt` - mod present; vanilla v1.19 changes reviewed and merged
- [x] `common/raids/air_raids_custom.txt` - mod present; vanilla v1.19 changes reviewed and merged
- [x] `common/technologies/electronic_mechanical_engineering.txt` - mod present; vanilla v1.19 changes reviewed
- [x] `events/SEA_Japan.txt` - mod present; vanilla v1.19 changes reviewed and merged
- [x] `history/countries/JAP - Japan.txt` - mod present; vanilla v1.19 changes reviewed

## Suggested Decision Tags

- `merge`: bring v1.19 vanilla changes into the mod override.
- `ignore`: vanilla change does not affect our override intent.
- `manual`: needs hand merge or gameplay decision.
- `remove_override`: consider dropping the mod override if vanilla now covers the need.

## 已分析记录

### 学说文件处理前提

用户判断：

- 本 mod 对学说系统进行了广泛重置。
- 特别是陆军学说，本 mod 已经做过大幅度再平衡。

适配含义：

- 学说文件不按“原版直接覆盖”处理。
- 原版新增结构、系统挂钩和兼容性修正可以优先考虑合入。
- 原版纯数值平衡项默认标记为 `手工合并`，需要逐项判断是否符合本 mod 的学说再平衡目标。
- 后续分析陆军学说文件时，应结合 `reports/v1.19_patch_notes_zh_excerpt.md` 中的官方更新日志中文摘录。

### `common/combat_tactics.txt`

组别：底层战斗、学说、科技

原版 v1.19 变动：

- `tactic_sf_barrage`：`active = no` 改为 `active = yes`。
- `tactic_sf_ambush`：`active = no` 改为 `active = yes`。

影响判断：

- 两个战术都属于 `street_fighting` 阶段。
- 原版没有改触发条件、基础权重、图片、counter 关系或战斗修正，只是启用此前定义好但未激活的战术。
- 当前 mod 快照中这两个战术仍是 `active = no`，因此 live mod 若不合入，会覆盖掉 v1.19 的启用修正。

结论：`合入`

状态：已合入 live mod 文件。

已执行操作：

- 已在 live `common/combat_tactics.txt` 中仅把这两个战术的 `active = no` 改为 `active = yes`。
- 不调整数值，避免把一个原版兼容修正扩大成战斗平衡改动。

### `common/technologies/electronic_mechanical_engineering.txt`

组别：底层战斗、学说、科技

原版 v1.19 变动：

- 在 `sp_rockets_improved_guidance` 科技中新增：

```txt
rocket_battery = {
	soft_attack = 0.1
}
```

影响判断：

- 这是 1943 年火箭制导相关特殊项目科技的单位加成。
- 原版已有 `rocket_artillery`、`rocket_artillery_brigade`、`mot_rocket_artillery_brigade`、`motorized_rocket_brigade` 的 `soft_attack = 0.1`。
- v1.19 新增的 `rocket_battery` 应该是让新版火箭炮单位同样吃到这项 +10% 软攻加成。
- 当前 mod 快照和 live 文件都没有 `rocket_battery` 这一段，因此如果不合入，mod 会覆盖掉 v1.19 对该单位的科技加成。
- 当前 mod 在该科技的 `ai_will_do` 中额外保留了 `is_rookie_country = yes` 时 `factor = 0` 的项目逻辑；这和本次原版新增单位加成不冲突。

结论：`合入`

状态：已合入 live mod 文件。

已执行操作：

- 已在 live `common/technologies/electronic_mechanical_engineering.txt` 的 `sp_rockets_improved_guidance` 中，紧跟现有 `motorized_rocket_brigade` 加成后加入 `rocket_battery = { soft_attack = 0.1 }`。
- 不改 `ai_will_do`、研究年份、花费、路径或其他火箭科技数值。

### `common/doctrines/*`

组别：底层战斗、学说、科技

原版 v1.19 变动：
- 五个陆军学说文件出现两类主要改动：一类是团级支援系统兼容挂钩，另一类是原版自身的学说平衡调整。
- `operations_subdoctrines.txt` 新增完整 `dispersed_operations` 学说。

影响判断：
- 本 MOD 对陆军学说进行了广泛重置，不能整块照搬 v1.19 原版。
- 当前 MOD 快照几乎没有 v1.19 新增的团级支援单位和分类 key，存在新系统加成被覆盖吞掉的风险。
- 纯数值平衡项应先标记，不应与结构兼容项混在一起直接合入。

结论：`手工合并`

状态：已完成差异分析和处理建议，尚未修改 live 学说文件。

详细报告：
- `update_fit/reports/doctrine_adaptation_analysis.md`
- `update_fit/reports/regimental_support_category_trace.md`

补充验证：
- 已倒查 v1.19 原版团属支援连分类。
- 全部团属支援连都吃 `category_army`。
- 普通团属支援、团属炮兵、团属反坦克、防空炮组不吃 `category_all_infantry`。
- 团属坦歼和团属自行防空吃 `category_all_armor`。
- 当前 MOD 未覆盖 `common/units/fire_support.txt`、`common/units/tank_destroyer_brigade.txt`、`common/units/sp_anti-air_brigade.txt`。

总学说审核更新：
- 团属支援组织补偿统一放在总学说选用即生效的 `# EFFECTS`，不放入里程碑。
- `new_mobile_warfare`、`grand_battleplan`、`rance_furinkazan`：团属支援 `max_organisation = 10`。
- `superior_firepower`、`mass_assault`：团属支援 `max_organisation = 5` 且 `supply_consumption = -0.02`。

### `common/ideas/_economic.txt`

组别：经济与人力法案/精神

原版 v1.19 变动：

- 在 `civilian_economy`、`low_economic_mobilisation`、`partial_economic_mobilisation`、`war_economy`、`tot_economic_mobilisation` 的 `on_add` 中新增暹罗经济法追踪：`SIA_current_economy_law`，并根据升降档调整军方/文官支持度。
- 在 `free_trade`、`export_focus`、`limited_exports`、`closed_economy` 的 `on_add` 中新增暹罗贸易法追踪：`SIA_current_trade_law`，并根据升降档调整军方/文官支持度。
- `autarkic_economy` 的 `visible` 条件扩展到 `Thunder at Our Gates` 下完成 `AST_autarky` 的澳大利亚。

影响判断：

- 当前 live 文件与 `update_fit/mod_current` 快照一致，未包含上述 v1.19 新挂钩；若不合入，mod 覆盖会吞掉暹罗新法案系统和澳大利亚自给经济可见条件。
- 本次原版变动不涉及日本经济法案数值再平衡，也不要求回退本 mod 对消费品、工厂、能源消耗等 modifier 的改动。

结论：`合入`

状态：已合入 live mod 文件。

已执行操作：

- 已在 live `common/ideas/_economic.txt` 中补入暹罗经济法和贸易法 `on_add` 追踪。
- 已将 `autarkic_economy` 的 `visible` 条件改为兼容德国旧逻辑和澳大利亚 `AST_autarky` 新逻辑。
- 保留本 mod 当前经济法案 modifier 数值和 AI 权重，不做额外平衡调整。

待验证：

- 进游戏或日志确认暹罗经济/贸易法切换时 `SIA_current_economy_law`、`SIA_current_trade_law` 与支持度调整正常。
- 确认澳大利亚完成 `AST_autarky` 后可以看到 `autarkic_economy`。

### `common/ideas/_manpower.txt`

组别：经济与人力法案/精神

原版 v1.19 变动：

- 在 `disarmed_nation`、`volunteer_only`、`limited_conscription`、`extensive_conscription`、`service_by_requirement`、`all_adults_serve`、`scraping_the_barrel` 的 `on_add` 中新增暹罗征兵法追踪：`SIA_current_manpower_law`。
- 同一批征兵法新增暹罗 national savings bond 精神刷新和对应 `idea_SIA_nsb_*` 添加逻辑。
- 澳大利亚征兵门槛从旧 `Together for Victory` 国策硬条件扩展为：`Thunder at Our Gates` 下使用 `AST_conscription_level_*` scripted trigger，否则保留旧 `AST_citizen_military_forces` / `AST_fight_work_or_perish` 条件。

影响判断：

- 当前 live 文件与 `update_fit/mod_current` 快照一致，未包含上述 v1.19 新挂钩；若不合入，mod 覆盖会吞掉暹罗征兵法/国债联动和澳大利亚新版征兵门槛。
- 本次原版变动不要求调整本 mod 当前征兵法 modifier 数值。

结论：`合入`

状态：已合入 live mod 文件。

已执行操作：

- 已在 live `common/ideas/_manpower.txt` 中补入暹罗征兵法 `on_add` 追踪和 national savings bond 逻辑。
- 已将澳大利亚 `limited_conscription`、`extensive_conscription`、`service_by_requirement`、`all_adults_serve`、`scraping_the_barrel` 的门槛改为兼容新旧 DLC 逻辑。
- 保留本 mod 当前征兵法 modifier 数值、AI 权重和芬兰 `FIN_militarized_society` `on_add` 逻辑。

待验证：

- 进游戏或日志确认暹罗切换征兵法时 `SIA_current_manpower_law`、national savings bond 精神刷新和支持度调整正常。
- 确认澳大利亚在 `Thunder at Our Gates` 下按 `AST_conscription_level_*` 条件解锁征兵法，非新 DLC 逻辑仍沿用旧国策门槛。

### `common/characters/JAP.txt`

组别：日本内容主干

原版 v1.19 变动：

- 给山川菊荣新增政治顾问身份：`idea_token = JAP_yamakawa_kikue`，顾问 trait 为 `ARG_feminist_revolutionary`。
- 顾问仅限 `original_tag = JAP`，在山川均为当前执政领导人时可用。
- 完成 `JAP_revere_the_emperor_destroy_the_traitors`、`JAP_organize_a_general_election`、`JAP_sea_purge_the_kodoha_faction` 后不可见。

影响判断：

- 本 mod `descriptor.mod` 对 `common/characters/JAP.txt` 使用 `replace_path`，若不合入会吞掉 v1.19 给山川菊荣新增的顾问身份。
- 当前 live 文件已有山川均、山川菊荣角色定义和历史招募项，本次只需要补顾问块，不需要重复招募角色。

结论：`合入`

状态：已合入 live mod 文件。

已执行操作：

- 已在 live `common/characters/JAP.txt` 的山川菊荣角色定义中加入 v1.19 政治顾问块。
- 未新增 `country_leader` 起始角色，保留本 mod 现有后续晋升/国策逻辑。

待验证：

- 进游戏确认山川均执政时山川菊荣顾问显示、任用条件和 trait 图标正常。

### `history/countries/JAP - Japan.txt`

组别：日本内容主干

原版 v1.19 变动：

- 在开局州处理后、开局科技前新增 `store_core_states_on_game_start = yes`。

影响判断：

- 本 mod `descriptor.mod` 对 `history/countries/JAP - Japan.txt` 使用 `replace_path`，若不合入会吞掉 v1.19 的开局核心州缓存设置。
- 本项目只维护 1936 主路径；该 key 是开局状态记录，不涉及 1939 或无 DLC fallback。

结论：`合入`

状态：已合入 live mod 文件。

已执行操作：

- 已在 live `history/countries/JAP - Japan.txt` 中，将 `store_core_states_on_game_start = yes` 放在开局州处理块之后、`Starting Technology` 前。
- 未改动现有角色招募、开局科技或 1936 主路径设置。

待验证：

- 进游戏或日志确认日本开局核心州缓存没有报错。

### `common/countries/cosmetic.txt`

组别：日本内容主干

原版 v1.19 变动：

- `INS_HOL` 改为新版印尼配色。
- 新增 `INS_HOL_FLAG`、`INS_UNION`、`INS_REP_UNION`、`INS_aslia`。
- 新增 `HND_UNIFIED`。
- 新增 `SIA_thailand`、`SIA_great_thai_empire`。

影响判断：

- 本 mod `descriptor.mod` 对 `common/countries/cosmetic.txt` 使用 `replace_path`，若不合入会吞掉这些 v1.19 新增/调整的 cosmetic tag 颜色定义。
- 这些改动不涉及日本路线平衡，也不影响本 mod 现有日本 cosmetic tag 定义。

结论：`合入`

状态：已合入 live mod 文件。

已执行操作：

- 已在 live `common/countries/cosmetic.txt` 中按 v1.19 原版合入上述 color / color_ui 定义。
- 未把 vanilla v1.19 文件尾部的其他旧有 cosmetic tag 整段搬入；仅合入本次 v1.19 diff 明确新增或修改的条目。

补充 diff 复核：

- `update_fit/vanilla_pre_v1.19/common/countries/cosmetic.txt` 到 live 文件的目标 v1.19 改动已经全部出现。
- live 文件相对 `update_fit/vanilla_v1.19/common/countries/cosmetic.txt` 曾有 14 个 vanilla tag 缺失；这些 tag 在 `vanilla_pre_v1.19` 中已存在、且在 `mod_current` 中也已缺失。用户确认这是历史遗漏，已一并补回：`CHI_great_ma`、`CHI_great_yuan`、`CHI_panthay_empire`、`CZE_CEF`、`CZE_CEF_puppet`、`CZE_fascist_color`、`CZE_first_monarchy_color`、`CZE_great_moravia`、`CZE_puppet`、`CZE_SLO_bohemia_expansion`、`CZE_union_expanded`、`CZE_union_expanded_puppet`、`neo_mesopotamia`、`SPR_habsburg`。
- live 文件额外保留本 mod 自定义 `JAP_PRC_union`，不属于异常。

`rookie_basic` 兼容补充：

- `rookie_basic/common/countries/cosmetic.txt` 也覆盖同一路径；若本 mod 后加载，会吞掉其 HA MOD 土耳其/奥斯曼相关 cosmetic tag。
- 已按 `rookie_basic` 的配色补入：`TUR_sultanate`、`TUR_Ottoman_empire`、`TUR_turkey_state`、`TUR_greater_turkey_state`、`TUR_turkey_union`、`TUR_turkey_revolution_republic`、`TUR_turkey_soviet_republic`、`TUR_turkey_people_republic`、`CRI_ottoman_puppet`。
- 复核同名土耳其/库尔德/突厥斯坦相关 vanilla tag：`TUR_GREATER_TURKEY_*`、`TUR_PROVISIONARY_*`、`TUR_AUS_danubian_state`、`KUR_FRA`、`IRQ_kurdistan_tag`、`greater_kurdistan`、`turkestan_united` 当前配色已与 `rookie_basic` 一致，未额外改动。

待验证：

- 进游戏确认相关印尼、洪都拉斯、暹罗以及土耳其/奥斯曼 cosmetic tag 颜色显示正常。

### `common/national_focus/japan.txt`

组别：日本内容主干

本轮初步分析范围：

- 对照 `update_fit/vanilla_pre_v1.19/common/national_focus/japan.txt` 与 `update_fit/vanilla_v1.19/common/national_focus/japan.txt`。
- 对照 live `common/national_focus/japan.txt` 中对应国策块。
- 已按 `Reference/focus_name.md` 查中文名；下列中文名用于维护台账。

原版 v1.19 变动摘要：

- `JAP_hasten_the_integration_of_taiwan`（加速整合台湾）：新增台湾不再由日本拥有/控制时的 `bypass`。
- `JAP_unsinkable_aircraft_carriers`（不沉的航空母舰）：新版把 state `1071` 加入可用性、机场、海岸堡垒和雷达建设范围。
- `JAP_sea_exploit_southern_resource_area`（开发南方资源区）：完成奖励新增 `INS_cancel_hol_ally_strategy_entirely_effect = yes`。
- `JAP_occupy_indochina`（占领印度支那）：新增 AI hidden gate，避免 AI 在暹罗控制相关印度支那州时绕过 `JAP_sea_pressure_siam` / `JAP_occupy_siam` 处理。
- `JAP_sea_pressure_siam`（施压暹罗）：在 `Thunder at Our Gates` 下限制为非 AI 可用，并要求暹罗 `has_rule = can_join_factions`。
- `JAP_occupy_siam`（占领暹罗）：如已有互不侵犯条约则先取消；历史 AI 直接 `declare_war_on`，否则仍创建吞并战争目标。
- `JAP_strike_the_southern_road`（打通南方道路）：完成奖励新增 `INS_cancel_hol_ally_strategy_entirely_effect = yes`。
- `JAP_kikues_new_model`（菊荣的新模式）与 `JAP_women_in_industry`（工业中的女性）：可用条件从“山川菊荣是执政领导人”扩展为“拥有山川菊荣顾问或山川菊荣执政”。
- `JAP_sea_mountaineers`（组建山地兵团）、`JAP_jungle_adaptation`（丛林适应训练）、`JAP_prepare_the_southern_front`（备战南方战线）：特种部队学说奖励从具体子分类折扣调整为 `special_forces_doctrine` 折扣，并追加对应 `add_mastery_bonus`。
- `JAP_form_the_kido_butai`（成立机动部队）：完成奖励新增 `JAP_form_the_kido_butai_tt` 提示。

影响判断：

- live 文件此前未包含上述 v1.19 新增 key；本 mod 覆盖会吞掉这些修正。
- 南进、暹罗、印尼策略取消、台湾 bypass、山川菊荣顾问兼容、机动部队 tooltip 都属于结构/提示兼容，倾向先小批量合入。
- 三个特种部队国策涉及本 mod 已重做的日本奖励分档和特种兵数值，应单独按 `Reference/JAP_focus_reward_tier_workflow_reference.md` 手工处理，不与首批兼容修正混在一起。
- state `1071` 已按 v1.19 地图资料确认：`STATE_1071` 为“瓦努阿图”，province 为 `1237, 4247, 12120`；后续合入国策时可直接查 `Reference/state_name_reference.md` 和 `Reference/state_province_reference.md`。
- v1.19 地图资料已刷新到 `Reference/state_name_reference.md`、`Reference/state_province_reference.md` 和 `Reference/strategic_region_reference.md`；state id 与 strategic region id 分开处理，不能互相代用。

结论：`手工合并`

状态：第一批兼容修正已合入 live 国策文件；特种部队 doctrine 奖励仍暂缓。

已首批合入 live `common/national_focus/japan.txt`：

- 加速整合台湾 bypass。
- 不沉的航空母舰 state `1071` 范围补充。
- 开发南方资源区、打通南方道路的 `INS_cancel_hol_ally_strategy_entirely_effect = yes`。
- 占领印度支那 AI hidden gate。
- 施压暹罗 / 占领暹罗 v1.19 可用性与 AI 宣战逻辑修正。
- 菊荣的新模式 / 工业中的女性的山川菊荣顾问兼容条件。
- 成立机动部队 tooltip。
- 合入时保留本 mod 现有 cost、Rance / Kodoha 条件、动态修正奖励和日本路线自定义数值。

暂缓：

- 组建山地兵团、丛林适应训练、备战南方战线的特种部队 doctrine 折扣与 mastery bonus，另开小块手工合并。

地图引用资料完成记录：

- 已用 vanilla v1.19 `history/states/`、`map/strategicregions/` 和 `localisation/simp_chinese/` 重建三张地图 Reference 表。
- 对照结果：新增 state `1047`-`1081`；已有 state 中 14 个中文名变化、24 个 province 归属变化已随全量重建同步。
- `Reference/state_name_reference.md` 与 `Reference/state_province_reference.md` 现覆盖 state `1`-`1081`，包含 `STATE_1071`“瓦努阿图”和 province `1237, 4247, 12120`。
- `Reference/strategic_region_reference.md` 现覆盖 strategic region `1`-`304`，新增 `299`-`304`；`154` 改为“日本中部”，`157` 改为“北岛”，`215-Namibia.txt` 按脚本 key `STRATEGICREGION_NAMIBIA` 记录为“纳米比亚”。
- 后续处理决议、事件、AI strategy 时若继续遇到新增 state / strategic region id，仍在本节追加记录。

### ????????????

??????? / ???? / ?? / AI

?? v1.19 ???
- ??????????? `common/doctrines` ?????????
- ? `special_forces_mountaineers`?`special_forces_marines`?`special_forces_paratroopers`?`special_forces_rangers` ?????????? `has_doctrine`?`special_forces_doctrine`?`add_mastery_bonus`?

? MOD ?????
- ?????????????`jap_rance_air_sea_joint_assault`????????? `jap_rance_mountain_ranger_assault`?????????
- ?????????????????????????????????????
- `Rance_JAP_*_M_infantry` ????????????????????????????????

???`??`

?????? live mod ????????????

??????
- `common/national_focus/japan.txt`?`JAP_sea_mountaineers`?`JAP_jungle_adaptation`?`JAP_prepare_the_southern_front` ??? `special_forces_*` ??????? `special_forces_doctrine`????? `jap_rance_mountain_ranger_assault` / `jap_rance_air_sea_joint_assault` mastery bonus?
- `common/decisions/JAP_rework_equipment_design_decision.txt`??? `JAP_unlock_Rance_JAP_*_M_infantry` ???? `has_doctrine`??????????????????? fallback?
- `common/decisions/JAP_rework_ai_decision.txt`?AI ????????? keystone ??????????????????? `Rance_JAP_*_M_infantry` ???
- `common/decisions/_generic_decisions.txt`?????????? AI ????? v1.19 ?? `has_doctrine`?????????????
- `common/ai_strategy/default.txt`?????? / ??? role ratio ?????? `has_tech` ?? `has_doctrine`???? `jap_rance_air_sea_joint_assault`?
- `common/ai_strategy/Jap_rework_ai_research.txt`?????? keystone ???????
- `history/countries/JAP - Japan.txt`???????? `special_forces_marines` ?????
- `localisation/simp_chinese/JAP_rework_doctrines_l_simp_chinese.yml`?`localisation/simp_chinese/JAP_special_units_l_simp_chinese.yml`???????? mastery bonus tooltip???????????

????
- ????????? tooltip?`add_mastery_bonus` ? `special_forces_doctrine` ???????
- ??????????????????????????? / ???AI ????????
- ?? `error.log`???? `special_forces_*` ?? keystone ?????????

### 特种学说校正记录（2026-06-14）

- 四个旧海军特战队训练科技 `Rance_JAP_mountaineers_M_infantry` / `Rance_JAP_rangers_M_infantry` / `Rance_JAP_marines_M_infantry` / `Rance_JAP_parapoopers_M_infantry` 已取消，不再通过玩家或 AI 决议授予；其效果由两个日本专属特种学说直接承接。
- `jap_rance_air_sea_joint_assault` 的玩家解锁条件绑定 `JAP_prepare_the_southern_front`；`jap_rance_mountain_ranger_assault` 的玩家解锁条件绑定 `JAP_sea_mountaineers` 与 `JAP_jungle_adaptation`；`Rance_is_jap_ai = yes` 可绕过国策门槛。

### `common/decisions/JAP.txt` + `events/SEA_Japan.txt`

组别：日本内容主干

本轮分析范围：

- 对照 `update_fit/vanilla_pre_v1.19/common/decisions/JAP.txt` 与 `update_fit/vanilla_v1.19/common/decisions/JAP.txt`。
- 对照 `update_fit/vanilla_pre_v1.19/events/SEA_Japan.txt` 与 `update_fit/vanilla_v1.19/events/SEA_Japan.txt`。
- 对照 live `common/decisions/JAP.txt` 与 live `events/SEA_Japan.txt` 中对应决议、事件块。
- 已查 `Reference/state_name_reference.md` 与 `Reference/state_province_reference.md`：`1066` 为交趾支那，`1067` 为马德望，`1068` 为巴塞，`1069` 为澜沧。

原版 v1.19 变动摘要：

- `JAP_guardian_of_indochina`（印度支那守护者）：法国控制状态检查新增 `1066`、`1067`、`1068`、`1069`。
- `JAP_establish_kingdoms_of_annam_and_cambodia_decision`（建立安南与柬埔寨王国）：高亮、可用性和转交/加核心范围新增印度支那拆分州；其中 `1069` 归越南，`1066`、`1067`、`1068` 归柬埔寨。
- `JAP_establish_empire_of_vietnam_decision`（建立越南帝国）：高亮、可用性和转交/加核心范围新增 `1066`。
- `JAP_establish_kingdom_of_kampuchea_decision`（建立柬埔寨王国）：高亮和转交/加核心范围新增 `1067`；原版没有同步把 `1067` 加入可用性要求。
- `JAP_establish_kingdom_of_luang_prabang_decision`（建立琅勃拉邦王国）：高亮、可用性和转交/加核心范围新增 `1068`、`1069`。
- `SEA_japan_foreign_policy.4`（日本要求暹罗加入阵营）：在 `Thunder at Our Gates` 下，若暹罗有 `SIA_limited_war_indochina` 任务，则隐藏接受/拒绝选项，改用新选项延迟 181 天再次触发；接受选项还会补完 `SIA_reluctant_submission`。
- `SEA_japan_foreign_policy.7`（日本准备入侵暹罗）：历史 AI + `Thunder at Our Gates` 下不再选择立即屈服。

影响判断：

- live 决议文件目前缺少 `1066`-`1069` 的印度支那地图拆分适配；本 mod 覆盖会吞掉 v1.19 的傀儡王国建国范围修正。
- live 事件文件目前缺少 `SIA_limited_war_indochina` 期间的延迟逻辑；这与此前已合入的 `JAP_sea_pressure_siam` / `JAP_occupy_siam` 国策兼容修正属于同一条暹罗链。
- `SEA_japan_foreign_policy.4.c` 与 `SEA_japan_foreign_policy.4.c_tt` 是新增本地化 key；当前 mod 没有覆盖 `SEA_japan_foreign_policy.*` 事件本地化，合入事件脚本时需要确认原版语言包是否提供，或在本 mod 另加本地化兜底。
- `events/SEA_Japan.txt` 是 UTF-8 with BOM + CRLF 的特殊文件；live 编辑时必须保留。
- `common/decisions/JAP.txt` 是 UTF-8 without BOM + CRLF 的特殊文件；live 编辑时必须保留。

结论：`手工合并`

状态：已合入 live gameplay 文件。

已执行操作：

- 已合入 `common/decisions/JAP.txt` 的 `1066`-`1069` 印度支那拆分州范围修正。
- 已合入 `events/SEA_Japan.txt` 的暹罗有限战争延迟逻辑和历史 AI 权重修正。
- 已新增 `localisation/simp_chinese/SEA_japan_foreign_policy_l_simp_chinese.yml`，为 `SEA_japan_foreign_policy.4.c` / `.4.c_tt` 提供中文本地化兜底，未改动 `SEA_focus_l_simp_chinese.yml`。

待验证：

- 进游戏或查日志确认 `SIA_limited_war_indochina` 存在时事件选项显示正常，181 天延迟不会产生裸 key 或错误 scope。

### `common/decisions/_generic_decisions.txt`

组别：通用决议系统

原版 v1.19 变动摘要：

- `war_propaganda_radio_industry`：巴西 `BRA_radio_nacional` 分支之后，阿富汗 `AFG_establish_radio_networks` 分支从独立 `IF` 改为 `ELSE_IF`，避免阿富汗被默认 `has_tech = radio` 条件误卡。
- `diversify_special_forces`：菲律宾和印尼的特种部队国策随新 DLC 独立处理；旧 `PHI_SEA = no` 排除改为 `No Compromise, No Surrender` 下排除 `PHI`、`Thunder at Our Gates` 下排除 `INS`。
- `diversify_special_forces` AI 条件从旧 `has_tech = special_forces_*` 改为 `has_doctrine = mountaineers/marines/paratroopers/rangers_1/2`。

live 对照结论：

- live 文件已经完成 `has_doctrine` 适配，并额外包含 `jap_rance_air_sea_joint_assault` 与 `jap_rance_mountain_ranger_assault`，这是本 mod 新特种学说适配，应保留。
- live 文件此前仍缺 `war_propaganda_radio_industry` 的 `ELSE_IF` 修正，以及 `diversify_special_forces` 的 PHI/INS 新 DLC 精确排除。
- `blow_suez_canal` 的 AI 倾向被注释为本 mod 设计选择，避免 AI 主动炸毁苏伊士影响后续苏伊士/地中海规划；不按原版恢复。

结论：`手工合并`

状态：已合入 live `common/decisions/_generic_decisions.txt`。

已执行操作：

- 已把阿富汗宣传决议分支改为 `ELSE_IF`。
- 已把 `diversify_special_forces` 的旧 `PHI_SEA = no` 替换为 `PHI` / `INS` 的 DLC 精确排除。
- 保留苏伊士运河爆破 AI 禁用设计，保留本 mod 两个日本特种学说 `has_doctrine` 兼容。

### `common/decisions/foreign_influence.txt`

组别：通用决议系统

原版 v1.19 变动摘要：

- 在民主宗主推动非民主傀儡民主化的通用影响决议 `visible` 中新增 `NOT = { has_dlc = "Thunder at Our Gates" }`。

live 对照结论：

- live 文件此前缺少该 v1.19 可见性门槛。
- live 文件额外包含日本 lecture / 皇道 AI 不使用通用协作政府决议的例外，这是本 mod 自定义 AI 设计，应保留。

结论：`合入`

状态：已合入 live `common/decisions/foreign_influence.txt`。

已执行操作：

- 已补入 `Thunder at Our Gates` DLC 可见性门槛。
- 保留本 mod 日本 AI 例外。

### `common/ai_strategy/default.txt`

组别：通用 AI 策略

原版 v1.19 变动摘要：

- `default_major_SF_para`：启用条件从旧 `has_tech = special_forces_paratroopers` 改为 `has_doctrine = paratroopers_1/2`。
- `default_major_SF_marines`：启用条件从旧 `has_tech = special_forces_marines` 改为 `has_doctrine = marines_1/2`。

live 对照结论：

- live 文件已经完成 `has_doctrine` 适配，并额外包含 `jap_rance_air_sea_joint_assault`。
- 日本陆军模板训练由 `JAP_rework_ai_template_v2.txt` 的自定义 role 与阶段/装备短缺抑制闭环控制；泛用 `paratroopers` / `marines` role 倾向会落在该闭环外。

结论：`手工合并`

状态：已合入 live `common/ai_strategy/default.txt`。

已执行操作：

- 在 `default_major_SF_para` 与 `default_major_SF_marines` 的 `allowed` 排除列表中加入 `original_tag = JAP`，避免日本 AI 触发泛用特种兵 role ratio。
- 保留 `jap_rance_air_sea_joint_assault` 兼容项，供非日本或未来复用该学说的对象继续承接该默认逻辑。

### `common/ai_strategy/JAP.txt`

组别：日本 AI 策略

原版 v1.19 变动摘要：

- 新增历史线菲律宾与关岛登陆/优先级策略。
- 新增 `JAP_prepare_for_naval_invasion_capability`，提高 `mtg_landing_craft` 研究权重。
- `JAP_leave_raj_a_bit` 对英属印度的 `invade` 抑制从 `-200` 加强到 `-250`。
- 中国势力圈相关策略把 `is_puppet_of = JAP/SOU` 改为 `is_subject_of = JAP/SOU`。
- `JAP_invade_burma` 使用 `is_ally_with` 替代 `is_in_faction_with`，并新增若开、勃固登陆请求。
- 新增香港、澳门未开战时的登陆规避策略。

live 对照结论：

- live 文件 active 中国势力圈策略仍使用旧 `is_puppet_of`，会漏判非 puppet 等级的附庸，应按原版合入 `is_subject_of`。
- `mtg_landing_craft` 已由本 mod `Jap_rework_ai_research.txt` 与 AI 免费科技决议承接，不需要在 `JAP.txt` 重复增加研究权重。
- 菲律宾、关岛、缅甸、香港、澳门相关原版块在 live 中主要处于注释或缺失状态；本 mod 已有讲座派/皇道派路线专用太平洋、东南亚与东印度登陆体系，不原样打开原版高权重登陆块。

结论：`选择性合入`

状态：已合入 live `common/ai_strategy/JAP.txt`。

已执行操作：

- 已将 active 中国势力圈策略中的 `is_puppet_of = JAP/SOU` 统一改为 `is_subject_of = JAP/SOU`。
- 未原样启用原版新增菲律宾、关岛、缅甸、香港、澳门策略；保留给路线专用 AI 系统承接。

### `common/ai_strategy_plans/JAP_alternate_strategy_plan.txt`

组别：日本 AI 国策计划

原版 v1.19 变动摘要：

- 在 `JAP_manchukuo_player_historical_plan` 的 1941 年南进段，向 `JAP_sea_pressure_siam` 与 `JAP_strike_the_southern_road` 之间新增 `JAP_occupy_siam`，用于暹罗因加入阵营导致施压暹罗路线被阻塞时转入侵暹罗。

live 对照结论：

- live 文件中 `JAP_manchukuo_player_historical_plan` 整体为注释块，不产生实际 gameplay 效果。
- active 的皇道派计划已经在南进段包含 `JAP_occupy_siam`，且位于 `JAP_strike_the_southern_road` 前。

结论：`无需 gameplay 合入`

状态：已审阅 live `common/ai_strategy_plans/JAP_alternate_strategy_plan.txt`。

已执行操作：

- 未改动 live gameplay 文件；仅记录该 v1.19 变动已由 active 皇道派计划覆盖，原版注释参考块不强制同步。

### `common/ai_templates/templates_JAP.txt`

组别：日本 AI 编制模板

原版 v1.19 变动摘要：

- 原版日本装甲、步兵、山地、海军陆战队、伞兵和守备 AI 模板开始接入 `regimental_support`。
- 原版同时调整部分线列营数量，例如减少部分装甲/炮兵线列营，改用 `anti_air_battery`、`anti_tank_battery`、`field_guns`、`fire_support`、`mot_fire_support` 等团属支援。

live 对照结论：

- live 文件已经是本 mod 自定义日本 AI 模板体系，使用 `JAP_*` 自定义 role 与 `Rance_JAP_A_*` / `Rance_JAP_M_*` 自定义营，不是原版 `armor`、`marines`、`paratrooper` 等模板体系。
- 日本 AI 模板与 `common/scripted_effects/JAP_templates_scripted_effects.txt`、装备需求参考、AI 生产与短缺抑制口径强绑定，不能只把原版 `regimental_support` diff 套进 `templates_JAP.txt`。

结论：`已完成，待测试`

状态：live `common/ai_templates/templates_JAP.txt` 与相关创建效果已完成团属支援化适配；仍需进游戏或日志验证 AI 模板生成、编制合法性、装备需求与图标显示。

已执行操作：

- 已将日本 AI 目标模板同步到团属支援口径，并保持与 `common/scripted_effects/JAP_templates_scripted_effects.txt` 的创建模板一致。
- 已为 MOD 特殊装甲团属支援补齐单位、科技启用、本地化与 interface 图标注册；现代系列按海军特战队现代两栖兵种衍生。
- 保留装备生产/短缺抑制口径后续复核项；本条当前标记为待测试，不代表已经通过实机验证。

### `common/ai_navy/fleet/JAP_fleet_templates.txt` + `common/ai_navy/taskforce/JAP_taskforce_templates.txt`

组别：日本海军 AI 舰队模板

原版 v1.19 变动摘要：

- `JAP_dominance_fleet_1` 的必需巡逻分舰队从 `JAP_PatrolDominanceForce_1 = 2` 调整为 `1`，侦察巡逻从 `JAP_PatrolReconForce_1 = 3` 调整为 `6`。
- `JAP_NavalInvasionSupport_1 = 1` 仍为必需分舰队，原版继续保留登陆支援任务接入优势舰队。

live 对照结论：

- live 已用 `Rance_JAP_DominanceFleet`、`Rance_JAP_KidoButai` 等自定义舰队体系替代原版 `JAP_*` 模板。
- live 已有 `Rance_JAP_PatrolReconForce = 10` 的可选侦察巡逻配置，原版加强侦察巡逻的方向已由自定义数量覆盖。
- live 的 `goals_JAP.txt` 已提高 `JAP_naval_invasion_support` 权重，但任务分舰队侧此前没有自定义 `naval_invasion_support` 模板。

结论：`调整合入`

状态：已合入 live。

已执行操作：

- 新增 `Rance_JAP_NavalInvasionSupport` 分舰队，任务为 `naval_invasion_support`，舰种配置与 `Rance_JAP_KidoButai` 一致。
- 在 `Rance_JAP_DominanceFleet.optional_taskforces` 加入 `Rance_JAP_NavalInvasionSupport = 1`，使优势舰队具备专门登陆支援分舰队，同时不提高前期最低成军门槛。
- 未启用原版 `JAP_*` 舰队模板，继续保留自定义 Rance 海军 AI 模板体系。

### `common/peace_conference/ai_peace/JAP.txt`

组别：日本和谈 AI

原版 v1.19 变动摘要：

- 新增 `JAP_wants_all_of_japan`：日本在内战中击败日本时，对日本核心州执行 `take_states` 的欲望提高 `200`。
- 新增 `JAP_wants_all_of_japan_2`：同场景下，对日本核心州执行 `puppet`、`liberate`、`force_government` 的欲望降低 `200`。

live 对照结论：

- live 文件有讲座派日本吞并亚洲、皇道派日本吞并亚洲/中东/澳洲的自定义和谈偏好。
- 原版新增的日本内战核心州规则与上述路线偏好不冲突；由于 descriptor 对该文件使用 `replace_path`，需要手工补入。

结论：`合入`

状态：已合入 live `common/peace_conference/ai_peace/JAP.txt`。

已执行操作：

- 保留本 mod 现有 Rance / 皇道派和谈偏好。
- 在文件末尾补入 `JAP_wants_all_of_japan` 与 `JAP_wants_all_of_japan_2`。

### `common/raids/air_raids_custom.txt`

组别：日本珍珠港空袭 raid

原版 v1.19 变动摘要：

- `JAP_pearl_harbor_strike` 的基础成功率从 `0.85` 调整为 `0.75`。
- 若已完成 `JAP_form_the_kido_butai`，`success` 额外获得 `weight = 0.1`。
- 若已完成 `JAP_form_the_kido_butai`，`critical` 额外获得 `weight = 0.05`。

live 对照结论：

- live 文件仅额外限制皇道派 AI：未进入太平洋战争目标准备/释放阶段前，不允许准备或发动珍珠港空袭。
- 原版 v1.19 的机动部队成功率加成与皇道派限制不冲突；同时 live 已有 `JAP_form_the_kido_butai_tt` 提示，需要让 tooltip 和实际 raid 机制一致。

结论：`合入`

状态：已合入 live `common/raids/air_raids_custom.txt`。

已执行操作：

- 保留 `available` / `launchable` 中的皇道派限制。
- 将 `JAP_pearl_harbor_strike.success.base` 调整为 `0.75`。
- 补入 `completed_kido_butai_focus` 对 `success` 与 `critical` 的加成。
