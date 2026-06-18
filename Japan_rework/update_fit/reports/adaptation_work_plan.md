# v1.19 更新适配工作计划

这份计划用于指导 `update_fit/` 里的版本适配分析。目标不是一次性把所有文件改完，而是把 24 个原版变更文件按类别拆开，逐批判断：哪些新版内容要合入本 mod，哪些可以忽略，哪些需要手工设计。

`update_fit/` 只作为分析工作区。真正的 gameplay 修改应回到 live mod 路径中进行。

## 先读这几个文件

开始适配前，先看这些材料：

- `reports/changed_files.txt`：v1.19 原版更新影响了哪些文件。
- `reports/v1.19_update.diff`：原版从旧版本到 v1.19 的完整差异。
- `reports/changed_files_with_mod_status.tsv`：每个变更文件在 mod 中是否有对应覆盖文件。
- `reports/adaptation_notes.md`：后续记录每个文件的结论和风险。

每个待处理文件都有三份对照：

- `vanilla_pre_v1.19/<路径>`：更新前原版。
- `vanilla_v1.19/<路径>`：v1.19 新原版。
- `mod_current/<路径>`：当前 mod 覆盖文件快照。

## 每个文件的固定处理流程

处理任何文件时都按同一个流程走：

1. 看 `vanilla_pre_v1.19` 和 `vanilla_v1.19`，先确认 P 社在 v1.19 改了什么。
2. 看 `mod_current`，确认本 mod 原来为什么覆盖这个文件。
3. 判断新版原版改动是否会被当前 mod 覆盖掉。
4. 给这个文件打一个结论标签。
5. 如果要修改，回到 live mod 路径编辑，不直接改 `update_fit` 的参考快照。
6. 把结论写回 `reports/adaptation_notes.md`。

结论标签：

- `合入`：新版原版改动需要合入 live mod 文件。
- `忽略`：新版原版改动与本 mod 目标无关，可以不处理。
- `手工合并`：不能直接照搬，需要逐段判断。
- `考虑取消覆盖`：如果原版新版已经满足需求，考虑从 `descriptor.mod` 或覆盖文件中移除此覆盖。
- `待测试`：已经做出编辑，但需要进游戏或日志验证。

## 横向任务：地图引用资料刷新

v1.19 改动已经在日本国策中暴露出新 state id，例如 `JAP_unsinkable_aircraft_carriers` 新增 state `1071`。这说明本项目的地图参考表也需要跟随版本刷新，不能只在 gameplay 文件里补 id。

要做：

- 对照 v1.19 vanilla 地图、州历史、战略区域和本地化，检查项目参考表是否缺新州、新省份归属或战略区域变化。
- 重点更新：
  - `Reference/state_name_reference.md`
  - `Reference/state_province_reference.md`
  - `Reference/strategic_region_reference.md`
- 处理国策、决议、事件、AI strategy 时，凡遇到新增 state id 或 strategic region id，都要记录到 `reports/adaptation_notes.md` 的地图引用资料待办。
- strategic region id 与 state id 不能混用；AI `naval_invasion_support_priority` 等战略区域权重应查 `map/strategicregions` 或 `Reference/strategic_region_reference.md`。

完成标准：

- 新版国策/决议/AI 中引用到的新 state id 能在项目 Reference 表中查到中文名和省份关系。
- 新版战略区域变化能在 `Reference/strategic_region_reference.md` 中查到，且不会误写成 state 表。
- 更新 Reference 前必须按根 `AGENTS.md` 先确认目标文件编码与换行。

完成记录（2026-06-13）：

- 已按 vanilla v1.19 `history/states/`、`map/strategicregions/` 和 `localisation/simp_chinese/` 重建三张 Reference 表。
- `Reference/state_name_reference.md` 与 `Reference/state_province_reference.md` 现覆盖 state `1`-`1081`；`Reference/strategic_region_reference.md` 现覆盖 strategic region `1`-`304`。
- 已在 `reports/adaptation_notes.md` 记录 `STATE_1071`“瓦努阿图”、province `1237, 4247, 12120`，新增 state `1047`-`1081`，已有 state 的名称/省份归属变化，以及新增战略区域 `299`-`304`。

## 文件分组总览

| 组别 | 文件数量 | 适配优先级 | 为什么先后这样排 |
| --- | ---: | --- | --- |
| 1. 底层战斗、学说、科技 | 7 | 最高 | 会影响国策奖励、AI 编制、战斗平衡，是其他内容的基础。 |
| 2. 经济与人力法案/精神 | 2 | 最高 | 改动量大，容易影响日本路线、动员、工厂和人力平衡。 |
| 3. 日本内容主干 | 6 | 高 | 包括角色、历史、国策、决议、事件，是本 mod 的核心体验。 |
| 4. 通用决议系统 | 2 | 中 | 影响全局行为，需确认没有被覆盖掉新版通用机制。 |
| 5. AI 行为与模板 | 6 | 高但靠后 | AI 应建立在已经确定的国策、学说、经济和编制逻辑上。 |
| 6. 空袭与特殊行动 | 1 | 中 | 范围较小，适合在主要系统稳定后处理。 |

## 第 0 步：锁定清单

目标：确认本轮适配对象就是这 24 个文件，不在分析途中随意扩张范围。

要做：

- 对照 `reports/changed_files.txt`，确认文件清单没有遗漏。
- 在 `reports/adaptation_notes.md` 中为每个文件建立一行记录。
- 每行至少包含：文件路径、组别、原版改动摘要、mod 冲突点、结论标签、状态。

产出：

- 一份可持续更新的适配记录表。

完成标准：

- 24 个文件全部有记录项。
- 每个文件都归入下面六个组别之一。

## 第 1 步：底层战斗、学说、科技

优先处理这些文件：

- `common/combat_tactics.txt`
- `common/doctrines/grand_doctrines/land_grand_doctrines.txt`
- `common/doctrines/subdoctrines/land/armor_subdoctrines.txt`
- `common/doctrines/subdoctrines/land/combat_support_subdoctrines.txt`
- `common/doctrines/subdoctrines/land/infantry_subdoctrines.txt`
- `common/doctrines/subdoctrines/land/operations_subdoctrines.txt`
- `common/technologies/electronic_mechanical_engineering.txt`

重点问题：

- v1.19 是否新增了学说节点、子学说效果、战术触发条件或科技解锁？
- 当前 mod 覆盖文件是否会让这些新增内容失效？
- 新增 modifier 是否会影响日本路线、AI 编制或陆军强度？

建议做法：

- 先看原版 diff，只摘出新增 key、删除 key、数值变化和触发条件变化。
- 不急着平衡数值，先保证新版结构不被 mod 覆盖掉。
- 对每个学说文件记录“新增内容是否必须合入”。

完成标准：

- 所有新增学说、战术、科技结构都明确为 `合入`、`忽略` 或 `手工合并`。
- 如果合入 live 文件，必须保留本 mod 原有设计意图。

## 第 2 步：经济与人力法案/精神

处理文件：

- `common/ideas/_economic.txt`
- `common/ideas/_manpower.txt`

重点问题：

- v1.19 是否改了经济法案、人力法案、动员、工厂、征兵或训练相关 modifier？
- 本 mod 是否覆盖了同名 idea，导致新版原版效果被吞掉？
- 日本国策、决议或事件是否引用这些 idea 或依赖其中 modifier？

建议做法：

- 逐个 idea 对比 modifier，而不是只看文件整体 diff。
- 先合入结构性变化，再决定是否保留 mod 的平衡数值。
- 对大幅改动的 idea 标记 `待测试`，后续进游戏观察工厂、人力和动员曲线。

完成标准：

- `_economic.txt` 和 `_manpower.txt` 不会无意覆盖掉 v1.19 新机制。
- 所有保留的 mod 数值都有理由。

## 第 3 步：日本内容主干

处理文件：

- `common/characters/JAP.txt`
- `history/countries/JAP - Japan.txt`
- `common/countries/cosmetic.txt`
- `common/national_focus/japan.txt`
- `common/decisions/JAP.txt`
- `events/SEA_Japan.txt`

推荐顺序：

1. 先看 `common/characters/JAP.txt` 和 `history/countries/JAP - Japan.txt`。
2. 再看 `common/countries/cosmetic.txt`。
3. 然后看 `common/national_focus/japan.txt`。
4. 最后把 `common/decisions/JAP.txt` 和 `events/SEA_Japan.txt` 放在一起看。

重点问题：

- v1.19 是否新增或修改日本角色、顾问、领导人、起始历史？
- 新版日本国策是否改变了原版路线结构、奖励、触发条件或可用条件？
- 本 mod 的日本路线是否需要吸收这些新版节点或效果？
- 决议和事件是否存在互相调用，不能只改其中一个文件？

注意：

- 涉及角色内容时，live 编辑前要遵守 `common/characters/AGENTS.md`。
- 涉及国策内容时，live 编辑前要遵守 `common/national_focus/AGENTS.md`。
- 涉及事件内容时，live 编辑前要遵守 `events/AGENTS.md`。
- `events/SEA_Japan.txt` 有特殊编码和换行要求，live 编辑时必须保留。

完成标准：

- 日本角色、历史、国策、决议、事件之间的依赖关系没有断。
- 每个原版更新 hunk 都有明确处理结论。

## 第 4 步：通用决议系统

处理文件：

- `common/decisions/_generic_decisions.txt`
- `common/decisions/foreign_influence.txt`

重点问题：

- v1.19 是否改了全局通用决议、外交影响、通用触发或可见条件？
- 当前 mod 覆盖是否会影响非日本国家或全局玩法？
- 日本内容是否依赖这些通用决议逻辑？

建议做法：

- 优先做兼容性合并，不在这里顺手做平衡重构。
- 如果新版改动是全局机制修复，倾向 `合入`。
- 如果和日本玩法没有关系但覆盖会吞掉新版机制，也要记录风险。

完成标准：

- 通用决议文件不会隐藏重要的 v1.19 全局行为。

## 第 5 步：AI 行为与模板

处理文件：

- `common/ai_strategy/default.txt`
- `common/ai_strategy/JAP.txt`
- `common/ai_strategy_plans/JAP_alternate_strategy_plan.txt`
- `common/ai_templates/templates_JAP.txt`
- `common/ai_navy/fleet/JAP_fleet_templates.txt`
- `common/peace_conference/ai_peace/JAP.txt`

推荐顺序：

1. `common/ai_strategy/default.txt`
2. `common/ai_strategy/JAP.txt`
3. `common/ai_strategy_plans/JAP_alternate_strategy_plan.txt`
4. `common/ai_templates/templates_JAP.txt`
5. `common/ai_navy/fleet/JAP_fleet_templates.txt`
6. `common/peace_conference/ai_peace/JAP.txt`

重点问题：

- v1.19 是否新增了 AI 战略权重、生产偏好、前线判断、外交或和平会议逻辑？
- 日本 AI 是否需要根据新版国策、经济、人力、学说变化调整？
- 模板变化是否与新版学说或装备逻辑有关？

注意：

- live 编辑 AI 策略前，先查项目 AI 参考：
  - `common/ai_strategy/AI_Strategy_Reference/AI_war_strategy_reference.md`
  - `common/ai_strategy/AI_Strategy_Reference/JAP_kodoha_war_strategy_reference.md`
  - `common/ai_strategy/AI_Strategy_Reference/JAP_kodoha_post_china_ai_area_plan.md`

完成标准：

- 日本 AI 仍符合本 mod 的路线设计。
- 有价值的 v1.19 AI 改进没有被旧覆盖文件吞掉。
- AI 模板与前面确定的学说、科技、经济、人力假设一致。

## 第 6 步：空袭与特殊行动

处理文件：

- `common/raids/air_raids_custom.txt`

重点问题：

- v1.19 是否改了空袭触发、花费、AI 使用条件或解锁条件？
- 这些变化是否影响日本路线强度或 AI 行为？

建议做法：

- 如果只是原版兼容修正，倾向 `合入`。
- 如果影响日本路线平衡，标记 `手工合并`。

完成标准：

- 空袭覆盖文件兼容 v1.19。

## 第 7 步：最终检查

目标：确认适配不是“看起来改完了”，而是真的没有漏掉覆盖风险。

要做：

- 按组别查看 mod 仓库 diff，不要只看一个巨大 diff。
- 检查所有 live 编辑过的文件是否遵守对应目录的 `AGENTS.md`。
- 对脚本文件做括号、key、触发器、效果块的基础检查。
- 更新 `reports/adaptation_notes.md`，记录每个文件最终结论。
- 如有必要，再同步一次原版 Git 的 replace_path 追踪清单。

完成标准：

- 24 个文件都有最终标签。
- 所有 live 修改都有明确理由。
- 未解决风险集中列在 `reports/adaptation_notes.md`，不散落在聊天记录里。

## 当前推荐推进顺序

如果现在就开始实际适配，建议按这个顺序：

1. 第 0 步：建立 24 文件决策表。
2. 第 1 步：战斗、陆军学说、科技。
3. 第 2 步：经济与人力。
4. 第 3 步：日本角色、历史、国策、决议、事件。
5. 第 4 步：通用决议。
6. 第 5 步：AI。
7. 第 6 步：空袭。
8. 第 7 步：最终检查。

## ?????????????????

???v1.19 ???????????? `common/doctrines` ?????????? MOD ??????? `jap_rance_air_sea_joint_assault`????????? `jap_rance_mountain_ranger_assault`???????????? `special_forces_*` ?? keystone ?????????

?????

- ??????? `special_forces_mountaineers`?`special_forces_marines`?`special_forces_paratroopers`?`special_forces_rangers` ??????????????
- ???????? `special_forces_doctrine` ??? `add_mastery_bonus`??? v1.19 ???????
- ?????????? MOD ??????????????? `mountaineers_1/2`?`marines_1/2`?`paratroopers_1/2`?`rangers_1/2` ????? fallback?
- MOD ??? `Rance_JAP_*_M_infantry` ????????????????????????????

???

- [x] ???`JAP_sea_mountaineers`??????????? `special_forces_mountaineers`??? `special_forces_doctrine` ????? `jap_rance_mountain_ranger_assault` mastery bonus?
- [x] ???`JAP_jungle_adaptation`??????????? `special_forces_rangers`??? `special_forces_doctrine` ????? `jap_rance_mountain_ranger_assault` mastery bonus?
- [x] ???`JAP_prepare_the_southern_front`??????????? `special_forces_marines` / `special_forces_paratroopers`??? `special_forces_doctrine` ????? `jap_rance_air_sea_joint_assault` mastery bonus?
- [x] ???`JAP_unlock_Rance_JAP_*_M_infantry` ?? `has_doctrine` ??????????????????? fallback?
- [x] AI ???`JAP_rai_complete_*_doctrine` ?????????? AI ?????????????? `Rance_JAP_*_M_infantry` ???
- [x] ?????`add_potential_special_forces_tree` ? AI ????? v1.19 ?? `has_doctrine`?????????????
- [x] AI strategy?????? / ??? role ratio ???? `has_tech` ?? `has_doctrine`???? `jap_rance_air_sea_joint_assault`?
- [x] AI research?????? keystone ??? `research_weight_factor` ????
- [x] ?????????? `special_forces_marines` ?????????????????????
- [x] ??????????? mastery bonus tooltip???????????
- [ ] ????????????? `has_doctrine`?`add_mastery_bonus`???????? AI ??????

## 2026-06-14 特种学说校正

- [x] 取消四个旧海军特战队训练科技 `Rance_JAP_mountaineers_M_infantry` / `Rance_JAP_rangers_M_infantry` / `Rance_JAP_marines_M_infantry` / `Rance_JAP_parapoopers_M_infantry` 及对应玩家、AI 授予决议；效果并入 `jap_rance_air_sea_joint_assault` 与 `jap_rance_mountain_ranger_assault`。
- [x] `jap_rance_air_sea_joint_assault` 需要完成 `JAP_prepare_the_southern_front`；`jap_rance_mountain_ranger_assault` 需要同时完成 `JAP_sea_mountaineers` 与 `JAP_jungle_adaptation`；`Rance_is_jap_ai = yes` 豁免国策门槛。