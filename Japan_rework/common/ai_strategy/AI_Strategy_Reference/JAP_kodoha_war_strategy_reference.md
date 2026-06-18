# 皇道派战争策略参考

> 目的：梳理 `common/ai_strategy/Jap_rework_kodoha_mil.txt` 的现有皇道派战争 AI 条目，尤其是旧条目的数值、目标范围、前线控制 `priority` 层级和互相覆盖关系。
>
> 泛用语法先看：`common/ai_strategy/AI_Strategy_Reference/AI_war_strategy_reference.md`。
>
> 本文只记录当前皇道派军事策略。改动 `Jap_rework_kodoha_mil.txt` 的数值、条件、目标州或新增皇道派军事条目后，同步更新本文。

## 读取顺序

1. 先用 `AI_war_strategy_reference.md` 确认 `front_control`、`front_unit_request`、`invasion_unit_request`、`area_priority` 等通用语法。
2. 再用本文确认皇道派旧条目的数值梯度和目标范围。
3. 最后打开 `common/ai_strategy/Jap_rework_kodoha_mil.txt` 写实际策略。

## 本轮未提交变动整编摘要

当前未提交改动围绕皇道派军区前线节奏、例外优先级和装甲/进攻模板分配展开：

- 新增 `JAP_kodoha_dont_defend_all_ally_borders`：使用 `reversed = yes` 动态匹配日本盟友，让皇道派日本不把兵力投入盟友自己的边境。
- 中国战线改为持续强推：`JAP_kodoha_china_war_cyclic_offensive` 与 `JAP_kodoha_china_war_chongqing_cyclic_offensive` 移除 `global.num_days` 取模条件；两个 key 保留 `cyclic` 只是历史命名。对华主动推进只受步枪不足保险 `800/1200` 覆盖。
- 中国战后普通陆上推进改为脉冲：东南亚主推进、南亚主战、东印度大岛、澳新大陆、太平洋常态、北美大陆、北方东线、北方西线侧翼与纵深使用 `global.num_days % 60 < 15`；南亚清理与东印度-澳新清理使用 `< 30`。
- 新增 `JAP_kodoha_post_china_land_front_rest_pulse`：中国战后每 60 天最后 15 天，即 `global.num_days % 60 > 44`，以 `priority = 680`、`careful`、`execute_order = no`、`manual_attack = yes` 压住非中国陆上普通前线；不影响 `front_unit_request`、登陆需求、`area_priority` 或 buffer。
- 调整例外层优先级，确保不被 `680` 休整层压住：东印度-澳新小岛/末端岛登陆后低强度巩固 `620 -> 690`，太平洋中等岛屿登陆后整理 `620 -> 690`，太平洋台湾/菲律宾主节点 `650 -> 700`，朝鲜止血前线 `620 -> 690`。
- 新增两条 `front_armor_score`：完成北进论并对苏作战时对 `SOV` 给 `200`；完成大本营决议“筹备美国本土登陆”并对美作战时对 `USA` 给 `200`。这两条只影响装甲/进攻模板分配，不进入 `front_control priority` 梯子。

## 基础判定

皇道派军事策略的共同前提：

- `allowed` 通常只写 `original_tag = JAP`。
- 路线判定统一写在 `enable`：`Rance_is_jap_kodoha_ai = yes`。
- `Rance_is_jap_kodoha_ai` 位于 `common/scripted_triggers/JAP_rework_scripted_triggers.txt`，当前含义是日本 AI，并且随机路线 flag 为 `JAP_AI_RANDOM_NEUTRALITY` 或游戏规则 `JAP_ai_behavior = NEUTRALITY`。
- 对华目标用原版 `is_literally_china = yes`，覆盖中国系原始 tag，例如 `CHI`、`PRC`、`GXC`、`YUN`、`SHX`、`XSM` 等。
- 州占领检查主要用原版 `state_is_fully_controlled_by_ROOT_or_subject`，含义是 ROOT 或 ROOT 的附庸完全控制该州。
- 皇道派本土危机不使用 `surrender_progress`，因为投降进度会被亚洲扩展核心干扰。
- 皇道派本土识别不使用 `is_core_of = JAP`，因为后期国策可能在日本列岛以外制造日本核心。
- 日本本土统一使用 `JAP_kodoha_is_home_islands_state` 的显式 13 州表：北海道 `536`、北东北 `533`、南东北 `1019`、甲信越 `534`、北陆 `535`、关东 `282`、东海道 `532`、关西 `531`、四国 `530`、山阳 `529`、山阴 `1020`、北九州 `528`、南九州 `1018`。
- 对华军事停止符使用 `JAP_china_war_substantially_ended_flag`。该 flag 由大本营决议“宣告对华战争胜利”设置；设置后，皇道派对华前线、登陆、推进和对华缺装保险策略应停止。

常用皇道派国策节点：

| 国策 key | 中文名 | 目前军事用途 |
| --- | --- | --- |
| `JAP_revere_the_emperor_destroy_the_traitors` | 尊皇讨奸 | 皇道派路线背景节点，当前军事文件只在注释中列出 |
| `JAP_establish_mongol_military_government` | 建立蒙古军政府 | 当前军事文件只在注释中列出 |
| `JAP_reinforce_the_beijing_garrison` | 加强冀东驻军 | 开启华北开局推进 |
| `JAP_nanshin_ron` | 南进论 | 外交 AI 完成后立即对暹罗、英法殖民体系与东南亚相关目标进入 `prepare_for_war` 预判 |
| `JAP_occupy_siam` | 占领暹罗 | 旧东南亚 buffer 前置；当前主战 buffer 不再依赖南进国策 |
| `JAP_strike_the_southern_road` | 打通南方道路 | 旧东南亚 buffer 前置；当前主战 buffer 不再依赖南进国策 |
| `JAP_a_green_persimmon` | 青涩的柿子 | 当前军事文件只在注释中列出 |

## 当前数值骨架

| 用途 | 当前条目 | 数值 |
| --- | --- | --- |
| 亚洲基础兴趣 | `JAP_kodoha_area_priority_base_asia` | `area_priority asia = 20` |
| 基础登陆倾向 | `JAP_kodoha_base_naval_invasion_focus` | `naval_invasion_focus = 25`，`naval_invasion_dominance_weight = 15` |
| 盟友边境隔离 | `JAP_kodoha_dont_defend_all_ally_borders` | `reversed = yes`；对所有交战且未投降的日本盟友提供 `dont_defend_ally_borders id = JAP value = 9999` |
| 东南亚军区集结 | `JAP_kodoha_southeast_asia_theater_buffer` | `put_unit_buffers order_id = 2301`，`ratio = 0.15`，`area = JAP_rework_southeast_asia_theater` |
| 东南亚军区主推进 | `JAP_kodoha_southeast_asia_theater_push` | `area_priority = 30`，`front_unit_request = 30`，`front_control priority = 520`；`%60 < 15` |
| 东南亚登陆链 | 暹罗、马来亚、勃固/仰光 | 各 `invasion_unit_request = 60`；登陆窗口 `naval_invasion_focus = 100`，`naval_invasion_dominance_weight = 40` |
| 南亚军区主战集结 | `JAP_kodoha_south_asia_main_battle_buffer` | `put_unit_buffers order_id = 2401`，`ratio = 0.15`，`area = JAP_rework_south_asia_theater` |
| 南亚军区主战推进 | `JAP_kodoha_south_asia_main_battle_pressure` | `area_priority = 25`，`front_unit_request = 25`，`front_control priority = 500`；`%60 < 15` |
| 南亚军区清理阶段 | `JAP_kodoha_south_asia_cleanup_*` | `ratio = 0.06`，`front_unit_request = 10`，`front_control priority = 360`；推进 `%60 < 30` |
| 南亚登陆链 | 西孟加拉、孟买、锡兰 | 各 `invasion_unit_request = 60`；登陆窗口 `naval_invasion_focus = 100`，`naval_invasion_dominance_weight = 40` |
| 东印度-澳新军区接替集结 | `JAP_kodoha_eia_theater_buffer` | `put_unit_buffers order_id = 2501`，`ratio = 0.15`，`area_priority = 20`，`area = JAP_rework_east_indies_australia_theater` |
| 东印度-澳新主动登陆网络 | 东印度门户、中部枢纽、澳新桥头堡 | 目标 `invasion_unit_request = 25` 到 `45`；登陆窗口 `naval_invasion_focus = 80`，`naval_invasion_dominance_weight = 40` |
| 东印度-澳新登陆后桥头堡 | `JAP_kodoha_eia_landing_followup` | 小岛/末端岛 `front_unit_request = 5`、`priority = 690`；主桥头堡基础 `15`，澳新额外 `+10`，`priority = 700`，30 天窗口 |
| 东印度-澳新常态推进 | `JAP_kodoha_eia_big_island_push` / `JAP_kodoha_eia_australia_nz_push` | 东印度主节点 `front_unit_request = 10`、`priority = 440`；澳新大陆 `front_unit_request = 20`、`priority = 480`；均 `%60 < 15` |
| 东印度-澳新残余清理 | `JAP_kodoha_eia_cleanup_buffer` / `JAP_kodoha_eia_cleanup_pressure` | 清理 buffer `ratio = 0.04`；`front_unit_request = 6`，`front_control priority = 320`；推进 `%60 < 30` |
| 东印度-澳新本地弹性防备池 | `JAP_kodoha_eia_local_guard_*` | 与军区接替/清理集结共用 `order_id = 2501`；主阶段 `ratio = 0.15`，清理阶段 `ratio = 0.04`，`subtract_* = yes` |
| 太平洋军区九州集结 | `JAP_kodoha_pacific_theater_buffer` | `put_unit_buffers order_id = 2600`，`ratio = 0.10`，`area_priority = 20`，`area = JAP_rework_pacific_theater` |
| 太平洋可调用弹性守备池 | `JAP_kodoha_pacific_flexible_guard_*` | 与九州集结共用 `order_id = 2600`，`ratio = 0.10`；复用旧守备 `_needed`，`subtract_* = yes` |
| 太平洋主动登陆链 | 两条岛链逐跳登陆 | 目标 `invasion_unit_request = 30` 到 `50`；登陆窗口 `naval_invasion_focus = 80`，`naval_invasion_dominance_weight = 40` |
| 太平洋中等岛屿登陆后整理 | `JAP_kodoha_pacific_island_landing_followup` | `front_unit_request = 5`，`front_control priority = 690`，30 天窗口 |
| 太平洋台湾/菲律宾登陆后整理 | `JAP_kodoha_pacific_main_node_landing_followup` | `front_unit_request = 10`，`front_control priority = 700`，30 天窗口 |
| 太平洋常态推进 | `JAP_kodoha_pacific_theater_push` | `front_unit_request = 15`，`front_control priority = 420`，低于东印度-澳新澳新推进与东南亚主推进；`%60 < 15` |
| 太平洋不可调用岛链守备 | `JAP_kodoha_pacific_*_chain_guard_*` | 北链 `order_id = 2601`，南链 `order_id = 2602`，`ratio = 0.02` 到 `0.04`，`subtract_* = no` |
| 太平洋完成后夏威夷常驻 | `JAP_kodoha_pacific_hawaii_permanent_guard` | `put_unit_buffers order_id = 2603`，`ratio = 0.03`，只守夏威夷 |
| 北美军区夏威夷集结 | `JAP_kodoha_north_america_hawaii_staging_buffer` | `put_unit_buffers order_id = 2604`，`ratio = 0.25`，`area_priority = 30`，`area = JAP_rework_north_america_theater`；要求已完成“筹备美国本土登陆” |
| 北美对美装甲倾向 | `JAP_kodoha_north_america_usa_armor_score` | 已完成“筹备美国本土登陆”且对美作战时，`front_armor_score id = USA value = 200` |
| 北美西海岸登陆 | 加利福尼亚、俄勒冈 | 加利福尼亚 `invasion_unit_request = 80`，俄勒冈 `60`；登陆窗口 `naval_invasion_focus = 100`，`naval_invasion_dominance_weight = 45` |
| 北美登陆后桥头堡 | `JAP_kodoha_north_america_landing_followup` | `front_unit_request = 35`，`front_control priority = 720`，30 天窗口 |
| 北美西海岸囤兵转移 | `JAP_kodoha_north_america_*_staging_buffer` | 复用 `order_id = 2604`，`ratio = 0.25`，节点优先级为加利福尼亚 > 俄勒冈 > 华盛顿 |
| 北美大陆推进 | `JAP_kodoha_north_america_theater_push` | `area_priority = 35`，`front_unit_request = 45`，`front_control priority = 650`，覆盖整个北美军区；`%60 < 15` |
| 本土常态预备 | `JAP_kodoha_home_islands_base_guard` | `put_unit_buffers order_id = 2800`，`ratio = 0.05`，`area = JAP_rework_home_islands_defense`，`subtract_* = no` |
| 本土预警预备 | `JAP_kodoha_home_islands_warning_guard` | 同 `order_id = 2800`，`ratio = 0.15`，预警时取代常态预备，`area_priority = 60` |
| 本土危机预备 | `JAP_kodoha_home_islands_crisis_guard` | 同 `order_id = 2800`，`ratio = 0.25`，本土 13 州敌控时取代前两层，`area_priority = 120` |
| 本土危机收复 | `JAP_kodoha_home_islands_crisis_front_control` | `front_unit_request = 70`，`front_control priority = 900`，`rush_weak`，只覆盖日本列岛 13 州 |
| 本土危机外线释放 | `JAP_kodoha_home_islands_crisis_release_outer_operations` | 对非本土州 `front_unit_request = -80`、`invasion_unit_request = -120`，并压低 `garrison` |
| 北方朝鲜止血预备 | `JAP_kodoha_northern_korea_delay_buffer` | `put_unit_buffers order_id = 2810`，`ratio = 0.04`，只驻平安-黄海、咸镜，不守北海道 |
| 北方朝鲜止血前线 | `JAP_kodoha_northern_korea_delay_front` | 朝鲜敌控时 `front_unit_request = 12`，`front_control priority = 690`，`balanced` |
| 北方对苏装甲倾向 | `JAP_kodoha_northern_soviet_armor_score` | 完成北进论且对苏作战时，`front_armor_score id = SOV value = 200` |
| 北方东线预备集结 | `JAP_kodoha_northern_east_theater_reserve_buffer` | `put_unit_buffers order_id = 2701`，`ratio = 0.10`，未完成北进论且未对苏开战时启用 |
| 北方东线全量集结 | `JAP_kodoha_northern_east_theater_buffer` | `put_unit_buffers order_id = 2701`，`ratio = 0.25`，`area_priority = 35`，完成北进论或对苏开战后启用 |
| 北方东线主推进 | `JAP_kodoha_northern_east_main_pressure` | `front_unit_request = 45`，`front_control priority = 560`，`balanced`；`%60 < 15` |
| 北方东线大陆登陆 | 符拉迪沃斯托克、哈巴罗夫斯克 | `invasion_unit_request = 45/35`；登陆窗口 `naval_invasion_focus = 60`，`naval_invasion_dominance_weight = 35` |
| 北方东线大陆登陆后桥头堡 | `JAP_kodoha_northern_east_landing_followup` | `front_unit_request = 25`，`front_control priority = 700`，30 天窗口 |
| 北方西线预备集结 | `JAP_kodoha_northern_west_theater_reserve_buffer` | `put_unit_buffers order_id = 2702`，`ratio = 0.05`，未完成北进论且未对苏开战时启用 |
| 北方西线全量集结 | `JAP_kodoha_northern_west_theater_buffer` | `put_unit_buffers order_id = 2702`，`ratio = 0.14`，`area_priority = 15`，完成北进论或对苏开战后启用 |
| 北方西线侧翼推进 | `JAP_kodoha_northern_west_side_pressure` | `front_unit_request = 20`，`front_control priority = 400`，`balanced`；`%60 < 15` |
| 北方西线纵深推进 | `JAP_kodoha_northern_west_deep_pressure` | `front_unit_request = 15`，`front_control priority = 340`，`balanced`；`%60 < 15` |
| 对华战争释放守备兵力 | `JAP_kodoha_china_war_suppress_garrison_when_stable` | `garrison = -9999`，条件是 `JAP_kodoha_home_islands_crisis = no` |
| 对华主前线常态需求 | `JAP_kodoha_china_war_main_front_pressure` | `front_unit_request = 40`，`front_control priority = 150` |
| 沿海登陆需求 | 山东、青岛、上海 | 各 `invasion_unit_request = 60` |
| 广州登陆需求 | 广州 | `invasion_unit_request = 80` |
| 登陆路线制海 | `JAP_kodoha_china_war_coastal_landing_dominance` | `naval_invasion_dominance_weight = 30` |
| 对华战争结束停止符 | 对华前线、登陆、推进、对华缺装保险 | `NOT = { has_country_flag = JAP_china_war_substantially_ended_flag }` |
| 装备补充模式刹车 | `JAP_kodoha_replenishment_mode_pause_fronts` | 暂时用 `##` 注释禁用；旧值为 `front_control priority = 1000`，`execute_order = no` |
| 中国战后陆上休整脉冲 | `JAP_kodoha_post_china_land_front_rest_pulse` | 每 60 天最后 15 天对非中国陆上前线 `priority = 680`，`careful`，`execute_order = no`，`manual_attack = yes` |
| 步枪低库存降速 | `JAP_kodoha_china_war_low_infantry_equipment_careful_fronts` | `< 500` 启用，`> 2000` 解除，`priority = 800` |
| 步枪极端缺口停攻 | `JAP_kodoha_china_war_critical_infantry_equipment_pause_fronts` | `< -5000` 启用，`> 500` 解除，`priority = 1200` |

### 南进外交 `prepare_for_war` 预判

由于本 MOD 缩短国策时间，`Jap_rework_kodoha_dip.txt` 中的 `JAP_kodoha_nanshin_*_prepare` 在完成 `JAP_nanshin_ron`（南进论）后立即启用，不再等到 `JAP_strike_the_southern_road`（打通南方道路）或具体战争目标生成。

| 目标 | 数值 | 用途 |
| --- | ---: | --- |
| `SIA` | `200` | 暹罗链条较短，完成南进论后最早预热 |
| `ENG` / `RAJ` / `BRM` / `MAL` | `100` | 英帝国、英属印度、缅甸、马来亚方向 |
| `FRA` / `VIC` | `100` | 法国或维希法国控制印度支那时的预判 |
| `HOL` / `INS` / `POR` | `50` | 东印度、澳门/东帝汶等后续牵连目标的低强度预判 |

这些条目只写固定 tag，不使用 `reversed = yes`。启用条件统一要求目标存在、未投降、未与日本交战、未与日本同阵营、不是日本附庸。`USA` 与 `PHI` 不加入南进论即时正向备战；太平洋延迟期间仍由 `JAP_kodoha_suppress_usa_aggression_before_pacific_wargoals_release` 和 `JAP_kodoha_suppress_phi_aggression_before_pacific_wargoals_release` 维持 `prepare_for_war = -800`。

### 太平洋战争目标 30 日准备期

大本营决议“批准太平洋作战”现在是 `days_remove = 30` 的计时决议。选用时只设置 `JAP_kodoha_pacific_wargoals_preparation_started_flag`，不会立刻发放菲律宾或美国战争目标；到期后才清除 `JAP_kodoha_delayed_pacific_wargoals_flag` 与准备期 flag，并设置 `JAP_kodoha_pacific_wargoals_released_flag`。

准备期 flag 生效后，美菲压制策略停止，`JAP_kodoha_prepare_usa_during_pacific_wargoal_preparation` 与 `JAP_kodoha_prepare_phi_during_pacific_wargoal_preparation` 分别提供 `prepare_for_war = 200`。准备期也会放开独立突袭机制 `JAP_pearl_harbor_strike`（`common/raids/air_raids_custom.txt`）的皇道派专属 `available` / `launchable` 限制；旧 `operations` 中的 `JAP_tora_tora_tora` 不作为这轮准备期解锁目标。真正的 `declare_war` 推进仍等待 30 天后战争目标放行，再交给现有战后推进块处理。

当前皇道派战争策略已有九组主要 `put_unit_buffers`。主战 buffer 是战前准备层：东南亚、南亚、太平洋在中国战事基本结束后即可按支点与关键目标未完成提前集结；东印度-澳新仍作为战时接替军区，保留东南亚核心走廊完成且 EIA 有战时目标后再集结；北美在四个亚洲主战区基本完成、对美战争仍在、已完成大本营决议“筹备美国本土登陆”且夏威夷完全控制后启用；北方东线/西线分预备态与北进全量态；本土防卫用 `order_id = 2800` 分常态、预警、危机三层；朝鲜止血用独立 `order_id = 2810`。新增本地兵池时要同步记录 `order_id`、`ratio`、`states`、`area` 和 `subtract_*` 参数。同一 `order_id` 的 `put_unit_buffers` 共享需求池，最坏预算按该 ID 的最高 ratio 计算，而不是把同 ID 条目相加。东印度-澳新本地守备与马来亚/新加坡接替池共用独立 `order_id = 2501`，与东南亚 `order_id = 2301` 拆开；太平洋可调用弹性守备与九州主池共用 `order_id = 2600`，北美夏威夷与西海岸转移囤兵共用 `order_id = 2604` 且互斥启用；本土常态/预警/危机三层共用 `order_id = 2800`；太平洋和北美可调用守备/集结使用 `subtract_invasions_from_need = yes`、`subtract_fronts_from_need = yes`，允许对应军区内登陆和前线调用这些兵；本土防卫与太平洋旧岛链守备使用独立不可调用口径，`subtract_* = no`。

补装备模式口径：`JAP_ai_land_production_replenishment_mode` 不作为普通军区策略的关闭条件。驻防/集结 buffer、`front_unit_request`、登陆需求和登陆窗口继续启用；原本由 `JAP_kodoha_replenishment_mode_pause_fronts` 通过 `front_control priority = 1000` 停止陆上执行进攻，但该策略当前实测效果不理想，已暂时用 `##` 注释禁用，日后另行重做。

战前准备态主战兵池预算按 `order_id` 分组取最高值；东南亚 `2301` 与东印度-澳新 `2501` 已拆分，二者分别计入预算。不计清理阶段、完成后常驻守备和太平洋岛链独立守备：

| order_id | 军区 | ratio |
| --- | --- | --- |
| `2301` | 东南亚，与东印度-澳新互斥 | `0.15` |
| `2501` | 东印度-澳新主阶段，与东南亚互斥 | `0.15` |
| `2401` | 南亚主战 | `0.15` |
| `2600` | 太平洋 | `0.10` |
| `2701` | 北方东线预备 | `0.10` |
| `2702` | 北方西线预备 | `0.05` |
| `2800` | 本土常态预备 | `0.05` |
| 合计 | 东南亚/EIA 二者择一 | `0.60` |

北进论完成或对苏开战后的全量主战预算：

| order_id | 军区 | ratio |
| --- | --- | --- |
| `2301` | 东南亚，与东印度-澳新互斥 | `0.15` |
| `2501` | 东印度-澳新主阶段，与东南亚互斥 | `0.15` |
| `2401` | 南亚主战 | `0.15` |
| `2600` | 太平洋 | `0.10` |
| `2701` | 北方东线全量 | `0.25` |
| `2702` | 北方西线全量 | `0.14` |
| `2800` | 本土常态预备 | `0.05` |
| 合计 | 东南亚/EIA 二者择一 | `0.84` |

北美本土登陆属于更晚阶段，不计入上述亚洲/北方主战预算；满足四个亚洲主战区基本完成、对美战争仍在、已完成大本营决议“筹备美国本土登陆”且夏威夷完全控制后，启用 `order_id = 2604`、`ratio = 0.25`。该 `order_id` 同时服务夏威夷集结和西海岸转移囤兵，两者互斥，不叠加。

本土预警和危机仍使用同一个 `order_id = 2800`，只按最高启用层取值：常态 `0.05`，预警 `0.15`，危机 `0.25`，不会互相叠加。朝鲜止血 `order_id = 2810` 仅在满洲关键州预警、朝鲜仍可拖延且本土未危机时增加 `0.04`；因此北进全量加本土预警与朝鲜止血约为 `0.98`，本土危机则约为 `1.04`，并由外线释放策略压低非本土前线与登陆需求。

## 前线控制优先级梯子

高优先级会覆盖低优先级。新增 `front_control` 前先找合适层级，避免无意覆盖旧逻辑。

| `priority` | 条目 | 执行方式 | 目标/含义 |
| ---: | --- | --- | --- |
| `1200` | `JAP_kodoha_china_war_critical_infantry_equipment_pause_fronts` | `careful`，`execute_order = no`，`manual_attack = no` | 对华战争步枪 `< -5000` 时暂停主动推进 |
| `1000` | `JAP_kodoha_replenishment_mode_pause_fronts` | 暂时用 `##` 注释禁用；旧值为 `careful`，`execute_order = no`，`manual_attack = no` | 旧口径：生产进入补装备模式后全战争前线停攻 |
| `900` | `JAP_kodoha_home_islands_crisis_front_control` | `rush_weak`，`execute_order = yes` | 日本列岛 13 州出现敌控时优先收复本土，高于普通推进和登陆后窗口，低于极端缺装停攻 |
| `800` | `JAP_kodoha_china_war_low_infantry_equipment_careful_fronts` | `careful` | 对华战争步枪 `< 500` 时降速，但不显式停攻 |
| `750` | `JAP_kodoha_china_war_chongqing_cyclic_offensive` | `rush_weak`，`execute_order = yes` | 武汉后四川/重庆方向持续冲击，`cyclic` 为历史命名 |
| `720` | `JAP_kodoha_north_america_landing_followup` | `rush_weak`，`execute_order = yes` | 北美西海岸登陆后 30 天桥头堡，略高于其他大陆登陆后窗口 |
| `700` | `JAP_kodoha_eia_landing_followup` | `rush_weak`，`execute_order = yes` | 东印度-澳新登陆后 30 天窗口内推进登陆州与邻近州 |
| `700` | `JAP_kodoha_south_asia_landing_followup` | `rush_weak`，`execute_order = yes` | 南亚登陆后 30 天窗口内推进登陆州与邻近州 |
| `700` | `JAP_kodoha_southeast_asia_landing_followup` | `rush_weak`，`execute_order = yes` | 东南亚登陆后 30 天窗口内推进登陆州与邻近州 |
| `700` | `JAP_kodoha_china_war_coastal_landing_followup` | `rush_weak`，`execute_order = yes` | 登陆后 30 天窗口内推进登陆州与邻近州 |
| `700` | `JAP_kodoha_northern_east_landing_followup` | `rush_weak`，`execute_order = yes` | 北方东线符拉迪沃斯托克/哈巴罗夫斯克大陆登陆后 30 天桥头堡 |
| `700` | `JAP_kodoha_china_war_chongqing_final_push` | `rush_weak`，`execute_order = yes` | 重庆终局推进 |
| `700` | `JAP_kodoha_pacific_main_node_landing_followup` | `rush_weak`，`execute_order = yes` | 太平洋台湾与菲律宾主节点登陆后小额推进 |
| `690` | `JAP_kodoha_eia_landing_followup` | `balanced`，`execute_order = yes` | 东印度-澳新小岛/末端岛登陆后低强度巩固 |
| `690` | `JAP_kodoha_pacific_island_landing_followup` | `rush_weak`，`execute_order = yes` | 太平洋中等岛屿登陆后小额整理 |
| `690` | `JAP_kodoha_northern_korea_delay_front` | `balanced`，`execute_order = yes` | 满洲关键州失守后在平安-黄海/咸镜方向短期止血，不守北海道 |
| `680` | `JAP_kodoha_post_china_land_front_rest_pulse` | `careful`，`execute_order = no`，`manual_attack = yes` | 中国战后每 60 天最后 15 天压住非中国普通陆上前线 |
| `650` | `JAP_kodoha_china_war_cyclic_offensive` | `rush_weak`，`execute_order = yes` | 对华全局持续总攻，`cyclic` 为历史命名 |
| `650` | `JAP_kodoha_china_war_shanghai_bridgehead_push` | `rush_weak`，`execute_order = yes` | 上海登陆场扩张 |
| `650` | `JAP_kodoha_north_america_theater_push` | `balanced`，`execute_order = yes` | 西海岸支点存在后的北美大陆主推进 |
| `600` | `JAP_kodoha_china_war_guangzhou_bridgehead_push` | `rush_weak`，`execute_order = yes` | 广州登陆场扩张 |
| `600` | `JAP_kodoha_china_war_hubei_to_wuhan_push` | `rush_weak`，`execute_order = yes` | 湖北到武汉 |
| `560` | `JAP_kodoha_northern_east_main_pressure` | `balanced`，`execute_order = yes` | 中国战后北方东线对苏远东主轴推进，高于东南亚主推进 |
| `550` | `JAP_kodoha_china_war_wuhan_to_sichuan_push` | `rush_weak`，`execute_order = yes` | 武汉到四川 |
| `520` | `JAP_kodoha_southeast_asia_theater_push` | `rush_weak`，`execute_order = yes` | 中国战后东南亚军区主推进 |
| `500` | `JAP_kodoha_south_asia_main_battle_pressure` | `balanced`，`execute_order = yes` | 南亚主目标仍有敌情时的主战推进 |
| `500` | `JAP_kodoha_china_war_anhui_to_hubei_push` | `rush_weak`，`execute_order = yes` | 安徽到湖北 |
| `480` | `JAP_kodoha_eia_australia_nz_push` | `balanced`，`execute_order = yes` | 东印度-澳新军区已有澳新桥头堡后的澳大利亚/新西兰大陆推进 |
| `450` | `JAP_kodoha_china_war_nanjing_to_anhui_push` | `rush_weak`，`execute_order = yes` | 南京到安徽 |
| `440` | `JAP_kodoha_eia_big_island_push` | `balanced`，`execute_order = yes` | 东印度大岛常态推进，低于东南亚主推进 |
| `420` | `JAP_kodoha_pacific_theater_push` | `balanced`，`execute_order = yes` | 太平洋军区常态推进，低于东印度-澳新澳新推进与东南亚主推进 |
| `400` | `JAP_kodoha_northern_west_side_pressure` | `balanced`，`execute_order = yes` | 中国战后北方西线外蒙古、乌梁海、新疆和青海侧翼稳推 |
| `380` | `JAP_kodoha_china_war_wuhan_to_changde_flank` | `balanced`，`execute_order = yes` | 武汉后常德侧翼 |
| `360` | `JAP_kodoha_south_asia_cleanup_pressure` | `balanced`，`execute_order = yes` | 南亚主目标已清后低强度清理缅甸重合区或小飞地 |
| `340` | `JAP_kodoha_northern_west_deep_pressure` | `balanced`，`execute_order = yes` | 北方西线西伯利亚纵深到乌拉尔边界低强度推进 |
| `320` | `JAP_kodoha_eia_cleanup_pressure` | `balanced`，`execute_order = yes` | 东印度-澳新主节点已清后的残余清理 |
| `300` | `JAP_kodoha_china_war_north_china_opening_push` | `rush_weak`，`execute_order = yes` | 加强冀东驻军后的华北开局 |
| `300` | `JAP_kodoha_china_war_jiangxi_flank_push` | `balanced`，`execute_order = yes` | 南京后江西侧翼 |
| `150` | `JAP_kodoha_china_war_main_front_pressure` | `balanced`，未显式写 `execute_order` | 对华主前线常态推进 |

经验规则：

- `150` 是常态中国前线，不要用低于它的值指望覆盖主前线。
- `300` 到 `650` 是普通推进层；中国战后普通推进需要配合 `global.num_days % 60 < 15` 或 `< 30`。
- `680` 是中国战后通用休整层，只覆盖非中国陆上前线，不能压住登陆、小岛、朝鲜止血、本土危机和缺装保险。
- `690` 是小岛/末端岛登陆巩固和朝鲜止血层，高于休整层，低于主桥头堡。
- `700` 到 `750` 是登陆后短窗口、主桥头堡或对华终局层。
- 对华战争推进不参与普通休整；除 `800/1200` 步枪保险外持续强推。
- `900` 只给本土危机收复层，表示日本列岛已经出现敌控州，普通进攻不要使用。
- `800+` 是刹车/降速层，应该高于所有普通进攻。
- `1000+` 当前只给“停攻”类强覆盖，新增进攻条目不要轻易进入这个区间。

## 当前条目总览

除基础亚洲倾向、基础登陆倾向和全战争补装备停攻外，下表所有对华军事条目都应以 `NOT = { has_country_flag = JAP_china_war_substantially_ended_flag }` 作为额外启用条件。两个对华缺装保险条目还需要把该 flag 放入显式 `abort` 的 `OR` 中，用于终止已激活策略。

| 条目 | 启用窗口 | payload 和数值 | 目标/备注 |
| --- | --- | --- | --- |
| `JAP_kodoha_area_priority_base_asia` | 皇道派 AI | `area_priority asia = 20` | 基础亚洲重心 |
| `JAP_kodoha_base_naval_invasion_focus` | 皇道派 AI 且有战争 | `naval_invasion_focus = 25`；`naval_invasion_dominance_weight = 15` | 全局登陆倾向，不绑定目标 |
| `JAP_kodoha_dont_defend_all_ally_borders` | 皇道派 AI，日本与目标盟友均处于战争且未投降 | `reversed = yes`；`dont_defend_ally_borders id = JAP value = 9999` | 动态匹配所有日本盟友，让日本不协防盟友自己的边境 |
| `JAP_kodoha_southeast_asia_theater_buffer` | 中国战事基本结束，南方出发口可用，核心走廊未全控 | `put_unit_buffers order_id = 2301`，`ratio = 0.15`，`states = 325/599/594/592/593/591`，`area = JAP_rework_southeast_asia_theater`，`subtract_* = yes` | 战前准备层；云南、广西、南宁、广州、广东、海南屯兵，服务东南亚军区 |
| `JAP_kodoha_southeast_asia_theater_push` | 中国战事基本结束，东南亚有敌方目标，南方大陆出发口未全丢，核心走廊未全控，`global.num_days % 60 < 15` | `area_priority = 30`；`front_unit_request = 30`；`front_control ratio = 0`，`priority = 520`，`rush_weak` | 东南亚军区第一版一条主推进；强推窗口为每 60 天前 15 天 |
| `JAP_kodoha_southeast_asia_siam_landing_invade_target_owner` | 中国战事基本结束，海南可用，暹罗控制者与日本交战，海军比例 `< 1.5` | `reversed = yes`；`invade id = JAP value = 100` | 对动态目标州控制者提高登陆倾向 |
| `JAP_kodoha_southeast_asia_malaya_landing_invade_target_owner` | 中国战事基本结束，海南可用，马来亚控制者与日本交战，海军比例 `< 1.5` | `reversed = yes`；`invade id = JAP value = 100` | 对动态目标州控制者提高登陆倾向 |
| `JAP_kodoha_southeast_asia_pegu_landing_invade_target_owner` | 中国战事基本结束，马来亚可用，勃固控制者与日本交战，海军比例 `< 1.5` | `reversed = yes`；`invade id = JAP value = 100` | 马来亚控制后再考虑勃固/仰光方向 |
| `JAP_kodoha_southeast_asia_siam_landing_request` | 海南可用，暹罗敌控，海军比例 `< 1.5` | `invasion_unit_request state = 289 value = 60` | 暹罗登陆需求 |
| `JAP_kodoha_southeast_asia_malaya_landing_request` | 海南可用，马来亚敌控，海军比例 `< 1.5` | `invasion_unit_request state = 336 value = 60` | 马来亚登陆需求 |
| `JAP_kodoha_southeast_asia_pegu_landing_request` | 马来亚可用，勃固敌控，海军比例 `< 1.5` | `invasion_unit_request state = 995 value = 60` | 勃固/仰光登陆需求 |
| `JAP_kodoha_southeast_asia_landing_window` | 任一东南亚登陆目标可用，海军比例 `< 1.5` | `naval_invasion_focus = 100`；`naval_invasion_dominance_weight = 40` | 参考菜鸟意大利，不加海军规模 fallback |
| `JAP_kodoha_southeast_asia_landing_followup` | `JAP_kodoha_southeast_asia_landing_boost` 设立未满 30 天 | `front_unit_request = 30`；`front_control ratio = 0`，`priority = 700`，`rush_weak` | 目标是东南亚登陆 state flag 州和邻州 |
| `JAP_kodoha_south_asia_main_battle_buffer` | 中国战事基本结束，喜马拉雅边境或勃固可用，印度次大陆战略骨架未全控 | `put_unit_buffers order_id = 2401`，`ratio = 0.15`，`states = 322/757/758/995`，`area = JAP_rework_south_asia_theater`，`subtract_* = yes` | 战前准备层；边境/出发口屯兵，战略骨架完成后释放 |
| `JAP_kodoha_south_asia_main_battle_pressure` | 南亚主目标仍有敌情，南亚通道未全丢，军区未完成，`global.num_days % 60 < 15` | `area_priority = 25`；`front_unit_request = 25`；`front_control ratio = 0`，`priority = 500`，`balanced` | 印度、巴基斯坦、孟加拉、喜马拉雅、锡兰方向主战推进；强推窗口为每 60 天前 15 天 |
| `JAP_kodoha_south_asia_cleanup_buffer` | 南亚主敌情已清，但缅甸重合区或法属印度/果阿仍有敌情 | `put_unit_buffers order_id = 2401`，`ratio = 0.06`，`states = 431/435/438/429/427/423` | 转入印度内部低强度兵池，不提前释放军区 |
| `JAP_kodoha_south_asia_cleanup_pressure` | 南亚主敌情已清，但缅甸重合区或法属印度/果阿仍有敌情，`global.num_days % 60 < 30` | `front_unit_request = 10`；`front_control ratio = 0`，`priority = 360`，`balanced` | 低于东南亚主推进 `520`；清理强推窗口为每 60 天前 30 天 |
| 南亚三条反转 `invade` | 勃固可用，目标控制者与日本交战，海军比例 `< 1.5` | `reversed = yes`；`invade id = JAP value = 100` | 目标控制者分别是西孟加拉、孟买、锡兰 |
| 南亚三条登陆需求 | 勃固可用，西孟加拉/孟买/锡兰敌控，海军比例 `< 1.5` | 各 `invasion_unit_request value = 60` | 不主动登陆法属印度、果阿 |
| `JAP_kodoha_south_asia_landing_window` | 任一南亚登陆目标可用，海军比例 `< 1.5` | `naval_invasion_focus = 100`；`naval_invasion_dominance_weight = 40` | 共享登陆窗口 |
| `JAP_kodoha_south_asia_landing_followup` | `JAP_kodoha_south_asia_landing_boost` 设立未满 30 天 | `front_unit_request = 30`；`front_control ratio = 0`，`priority = 700`，`rush_weak` | 目标是南亚登陆 state flag 州和邻州 |
| `JAP_kodoha_eia_theater_buffer` | 东南亚核心走廊已完成，马来亚/新加坡接替点可用，东印度-澳新存在战时目标，且未进入清理阶段 | `put_unit_buffers order_id = 2501`，`ratio = 0.15`，`states = 336/1021`，`area_priority = 20`，`area = JAP_rework_east_indies_australia_theater`，`subtract_* = yes` | 战时接替层，不做和平提前集结 |
| `JAP_kodoha_eia_cleanup_buffer` | 东印度大岛和澳新主节点已清，只剩残余敌情，马来亚/新加坡接替点可用 | `put_unit_buffers order_id = 2501`，`ratio = 0.04`，`states = 336/1021`，`area = JAP_rework_east_indies_australia_theater`，`subtract_* = yes` | 清理阶段低强度兵池，避免主阶段持续吸兵 |
| 东印度-澳新十七条反转 `invade` | 对应枢纽网络门槛可用，目标控制者与日本交战，海军比例 `< 1.5` | `reversed = yes`；`invade id = JAP value = 100` | 目标按东印度门户、中部枢纽、澳新桥头堡、塔斯马尼亚和新西兰分阶段开放 |
| 东印度-澳新十七条登陆需求 | 对应枢纽网络门槛可用，目标州敌控，海军比例 `< 1.5` | 苏门答腊/爪哇/沙捞越/加里曼丹/北领地/西澳大利亚/北昆士兰/新南威尔士 `45`；摩鹿加/苏拉威西/西巴布亚/巴布亚/北岛 `35`；小巽他/东帝汶/塔斯马尼亚/南岛 `25` | 同一阶段只开放有合理地理支点的目标，避免全军区目标同时吸兵 |
| `JAP_kodoha_eia_landing_window` | 任一东印度-澳新枢纽网络登陆目标可用，海军比例 `< 1.5` | `naval_invasion_focus = 80`；`naval_invasion_dominance_weight = 40` | 低于东南亚/南亚 `100` 的登陆意愿，减少多目标过度吸兵 |
| `JAP_kodoha_eia_landing_followup` | `JAP_kodoha_eia_landing_boost` 设立未满 30 天 | 小岛/末端岛 `front_unit_request = 5`，`priority = 690`；主桥头堡基础 `15`，澳新额外 `+10`；主桥头堡 `priority = 700`，`rush_weak` | 所有主动登陆目标都打 state flag；小巽他、东帝汶、摩鹿加、塔斯马尼亚、南岛只低强度巩固 |
| `JAP_kodoha_eia_big_island_push` | 东印度主节点已打开，东印度主节点仍有敌情，`global.num_days % 60 < 15` | `front_unit_request = 10`；`front_control priority = 440`，`balanced` | 苏门答腊、爪哇、沙捞越、加里曼丹、摩鹿加、苏拉威西、西巴布亚、巴布亚及邻近州；强推窗口为每 60 天前 15 天 |
| `JAP_kodoha_eia_australia_nz_push` | 北领地/西澳大利亚/北昆士兰/新南威尔士任一桥头堡可用，澳新仍有敌情，`global.num_days % 60 < 15` | `front_unit_request = 20`；`front_control priority = 480`，`balanced` | 澳大利亚和新西兰大陆推进，低于东南亚主推进 `520`；强推窗口为每 60 天前 15 天 |
| `JAP_kodoha_eia_cleanup_pressure` | 东印度大岛和澳新主节点已清，只剩残余敌情，`global.num_days % 60 < 30` | `front_unit_request = 6`；`front_control priority = 320`，`balanced` | 小岛、内陆或零散敌控州低强度清理；清理强推窗口为每 60 天前 30 天 |
| 东印度-澳新本地弹性防备池 | 主阶段：军区可运作、未清空、未进入残余清理，且方向上仍有敌控节点；清理阶段：进入残余清理；两阶段都要求本节点由 ROOT/盟友控制 | `put_unit_buffers order_id = 2501`；主阶段 `ratio = 0.15`，清理阶段 `ratio = 0.04`；`subtract_* = yes` | 节点按西侧、东侧、澳新方向分组；只守已控节点，不再按两条长岛链逐跳锁兵 |
| `JAP_kodoha_pacific_theater_buffer` | 中国战事基本结束，九州集结点可用，日本列岛 13 州安全，重要目标未全控 | `put_unit_buffers order_id = 2600`，`ratio = 0.10`，`states = 528/1018`，`area_priority = 20`，`area = JAP_rework_pacific_theater`，`subtract_* = yes` | 北九州、南九州屯兵，服务菲律宾、中太平洋和夏威夷方向 |
| 太平洋可调用弹性守备池 | 复用对应旧岛链守备 `_needed`，节点已控且太平洋军区仍可运作/未清空 | `put_unit_buffers order_id = 2600`，`ratio = 0.10`，覆盖 14 个主动/守备节点，`area = JAP_rework_pacific_theater`，`subtract_* = yes` | 与九州集结共享需求池，不额外叠加预算；让多余兵力可在链上节点防守、前线和登陆需求之间流动 |
| 太平洋十四条反转 `invade` | 上一跳由 ROOT/盟友控制，目标控制者与日本交战，海军比例 `< 1.5`，日本列岛 13 州安全，重要目标未全控；夏威夷额外要求中途岛稳定且内环/菲律宾主节点无敌情 | `reversed = yes`；`invade id = JAP value = 100` | 北链与南链逐跳目标；威克岛可由关岛或马绍尔群岛方向打开 |
| 太平洋十四条登陆需求 | 对应逐跳 landing trigger 可用，目标州敌控，海军比例 `< 1.5`，日本列岛 13 州安全，重要目标未全控 | 硫磺岛/塞班岛/关岛/冲绳/台湾/马尼拉/吕宋 `50`；威克岛/中途岛/北棉兰老/达沃/加罗林群岛/马绍尔群岛 `40`；夏威夷 `30` | 每条链只抬当前可用下一跳，不提前请求后续节点 |
| `JAP_kodoha_pacific_landing_window` | 任一太平洋逐跳登陆目标可用，海军比例 `< 1.5`，日本列岛 13 州安全，重要目标未全控 | `naval_invasion_focus = 80`；`naval_invasion_dominance_weight = 40` | 与东印度-澳新同级，低于东南亚/南亚登陆窗口 |
| `JAP_kodoha_pacific_hawaii_landing_support_priority` | 夏威夷逐跳登陆目标可用，海军比例 `< 1.5`，日本列岛 13 州安全，重要目标未全控 | 北天皇海山链 `96`、西北太平洋 `177`、太平洋海脊 `172` 的 `naval_invasion_support_priority = 150`；北太平洋 `114`、夏威夷海脊 `105` 为 `200` | 只抬远洋/夏威夷航线，不给每个小岛单独写 |
| `JAP_kodoha_pacific_island_landing_followup` | `JAP_kodoha_pacific_landing_boost` 设立未满 30 天，日本列岛 13 州安全，重要目标未全控 | `front_unit_request = 5`；`front_control ratio = 0`，`priority = 690`，`rush_weak` | 只覆盖冲绳、塞班岛、关岛、加罗林群岛、夏威夷及邻州 |
| `JAP_kodoha_pacific_main_node_landing_followup` | `JAP_kodoha_pacific_landing_boost` 设立未满 30 天，日本列岛 13 州安全，重要目标未全控 | `front_unit_request = 10`；`front_control ratio = 0`，`priority = 700`，`rush_weak` | 只覆盖台湾、马尼拉、吕宋、北棉兰老、达沃及邻州 |
| `JAP_kodoha_pacific_theater_push` | 太平洋军区仍有敌情，任一军区支点可用，日本列岛 13 州安全，重要目标未全控，`global.num_days % 60 < 15` | `front_unit_request = 15`；`front_control priority = 420`，`balanced` | 菲律宾、日方岛链、中太平洋和夏威夷常态推进；强推窗口为每 60 天前 15 天 |
| 太平洋不可调用岛链守备 | 控制当前节点且下两跳尚未稳定；威克岛、中途岛、夏威夷等关键汇合/终点节点守到完成/撤出 | 北链 `put_unit_buffers order_id = 2601`；南链 `order_id = 2602`；普通小岛 `0.02`，台湾/冲绳/菲律宾主节点 `0.03`，夏威夷 `0.04`；`subtract_* = no` | 控制下下跳后释放上一跳；北链与南链分开 `order_id`，作为不可被前线/登陆抵扣的底线守备 |
| `JAP_kodoha_pacific_hawaii_permanent_guard` | 太平洋重要目标全控，夏威夷由 ROOT/盟友控制，日本列岛 13 州安全 | `put_unit_buffers order_id = 2603`，`ratio = 0.03`，`states = 629`，`area = JAP_rework_pacific_theater`，`subtract_* = no` | 完成后只在夏威夷保留常驻守备；本土 13 州失控即停用 |
| `JAP_kodoha_north_america_hawaii_staging_buffer` | 四个亚洲主战区基本完成、对美战争仍在、已完成“筹备美国本土登陆”、夏威夷完全控制，且未控制西海岸节点 | `put_unit_buffers order_id = 2604`，`ratio = 0.25`，`states = 629`，`area = JAP_rework_north_america_theater`，`area_priority = 30`，`subtract_* = yes` | 夏威夷集结，服务整个北美军区 |
| `JAP_kodoha_north_america_usa_armor_score` | 已完成“筹备美国本土登陆”、美国存在且未投降、仍与美国交战 | `front_armor_score id = USA value = 200` | 决议确认北美作战后，把装甲/进攻模板推向美国前线；不影响 `front_control` 节奏 |
| 北美西海岸登陆链 | 夏威夷阶段可用，西海岸节点尚未控制，目标州控制者与日本交战，海军比例 `< 1.5` | 加利福尼亚 `378` 登陆请求 `80`；俄勒冈 `385` 登陆请求 `60`；共享 `naval_invasion_focus = 100`，`naval_invasion_dominance_weight = 45` | 只主动抬两个西海岸主登陆点；华盛顿作为后续囤兵/推进节点 |
| `JAP_kodoha_north_america_landing_followup` | 北美登陆 boost 未满 30 天，北美作战支点可用，战区未清空 | `front_unit_request = 35`；`front_control priority = 720`，`rush_weak` | 覆盖登陆州及邻州，用于扶住西海岸桥头堡 |
| `JAP_kodoha_north_america_*_staging_buffer` | 已控制西海岸节点，北美仍有敌情 | 复用 `put_unit_buffers order_id = 2604`，`ratio = 0.25`，`area = JAP_rework_north_america_theater`，`subtract_* = yes` | 同一时间只启用一个节点：加利福尼亚优先，其次俄勒冈，再次华盛顿 |
| `JAP_kodoha_north_america_theater_push` | 已控制西海岸节点，北美洲仍有交战敌控州，`global.num_days % 60 < 15` | `area_priority = 35`；`front_unit_request = 45`；`front_control priority = 650`，`balanced` | 覆盖整个北美军区；强推窗口为每 60 天前 15 天 |
| `JAP_kodoha_home_islands_base_guard` | 皇道派 AI 有战争，未进入本土预警/危机 | `put_unit_buffers order_id = 2800`，`ratio = 0.05`，`states = 282/532/531/528/1018/536`，`area = JAP_rework_home_islands_defense`，`subtract_* = no` | 常态本土预备，只服务战略区域 `154` 日本列岛 |
| `JAP_kodoha_home_islands_warning_guard` | 太平洋内环、满洲关键州或中国华东沿海预警，且本土未危机 | `put_unit_buffers order_id = 2800`，`ratio = 0.15`，同一组屯兵州，`area_priority = 60` | 预警层取代常态层，不和常态 `0.05` 相加 |
| `JAP_kodoha_home_islands_crisis_guard` | 日本列岛 13 州任一敌控 | `put_unit_buffers order_id = 2800`，`ratio = 0.25`，同一组屯兵州，`area_priority = 120` | 本土危机层取代前两层 |
| `JAP_kodoha_home_islands_crisis_front_control` | 日本列岛 13 州任一敌控 | `front_unit_request = 70`；`front_control priority = 900`，`rush_weak` | 只对 `JAP_kodoha_is_home_islands_state = yes` 的州收复本土 |
| `JAP_kodoha_home_islands_crisis_release_outer_operations` | 日本列岛 13 州任一敌控 | 非本土州 `front_unit_request = -80`、`invasion_unit_request = -120`，`garrison = -9999` | 外线降需求，不使用 `NOT = { is_core_of = JAP }` |
| `JAP_kodoha_northern_korea_delay_buffer` | 满洲关键州敌控，朝鲜仍可拖延，且本土未危机 | `put_unit_buffers order_id = 2810`，`ratio = 0.04`，`states = 527/1028`，`area = JAP_rework_korea_theater` | 北方止血只守平安-黄海与咸镜，不守北海道 |
| `JAP_kodoha_northern_korea_delay_front` | 朝鲜平安-黄海或咸镜敌控，且本土未危机 | `front_unit_request = 12`；`front_control priority = 690`，`balanced` | 给朝鲜方向短期拖延层，高于通用休整层、低于主桥头堡 |
| `JAP_kodoha_northern_soviet_armor_score` | 完成北进论，苏联存在且未投降，仍与苏联交战 | `front_armor_score id = SOV value = 200` | 把装甲/进攻模板推向苏联前线；不影响 `front_control` 节奏 |
| `JAP_kodoha_northern_east_main_pressure` | 中国战事基本结束，东线支点可用，东线有敌情，东线未完成，本土未危机，`global.num_days % 60 < 15` | `front_unit_request = 45`；`front_control priority = 560`，`balanced` | 只覆盖远东主轴；强推窗口为每 60 天前 15 天 |
| `JAP_kodoha_northern_west_side_pressure` | 中国战事基本结束，西线支点可用，侧翼敌情存在，西线未完成，本土未危机，`global.num_days % 60 < 15` | `front_unit_request = 20`；`front_control priority = 400`，`balanced` | 外蒙古、乌梁海、新疆和青海侧翼；强推窗口为每 60 天前 15 天 |
| `JAP_kodoha_northern_west_deep_pressure` | 中国战事基本结束，西线支点可用，纵深推进条件成熟，西线未完成，本土未危机，`global.num_days % 60 < 15` | `front_unit_request = 15`；`front_control priority = 340`，`balanced` | 北方东线远东主轴完成，或西线已有西伯利亚桥头堡后才启用；强推窗口为每 60 天前 15 天 |
| `JAP_kodoha_china_war_suppress_garrison_when_stable` | 对华战争，`JAP_kodoha_home_islands_crisis = no` | `garrison = -9999` | 本土 13 州未危机时释放守备兵力 |
| `JAP_kodoha_china_war_main_front_pressure` | 对华战争 | `front_unit_request = 40`；`front_control ratio = 0.25`，`priority = 150`，`execution_type = balanced`，`manual_attack = yes` | 中国系敌国前线；未显式写 `execute_order` |
| `JAP_kodoha_china_war_cyclic_offensive` | 对华战争 | `front_control ratio = 0.25`，`priority = 650`，`execution_type = rush_weak`，`execute_order = yes`，`manual_attack = yes` | 全局对华持续总攻；`cyclic` 为历史命名 |
| `JAP_kodoha_china_war_north_china_opening_push` | 加强冀东驻军后，北平/山东/河北/济南/青岛未全控 | `front_unit_request = 30`；`front_control ratio = 0`，`priority = 300`，`rush_weak` | 华北开局推进 |
| `JAP_kodoha_china_war_shandong_landing_request` | 对华战争，山东未全控 | `invasion_unit_request state = 597 value = 60` | 山东登陆 |
| `JAP_kodoha_china_war_qingdao_landing_request` | 对华战争，青岛未全控 | `invasion_unit_request state = 743 value = 60` | 青岛登陆 |
| `JAP_kodoha_china_war_shanghai_landing_request` | 对华战争，上海未全控 | `invasion_unit_request state = 613 value = 60` | 上海登陆 |
| `JAP_kodoha_china_war_guangzhou_landing_request` | 山东或上海已全控，广州未全控 | `invasion_unit_request state = 592 value = 80` | 广州登陆 |
| `JAP_kodoha_china_war_coastal_landing_dominance` | 山东/青岛/上海/广州任一未全控 | `naval_invasion_dominance_weight = 30` | 对华沿海登陆制海 |
| `JAP_kodoha_china_war_coastal_landing_followup` | `JAP_kodoha_china_landing_boost` 设立未满 30 天 | `front_unit_request = 30`；`front_control ratio = 0`，`priority = 700`，`rush_weak` | 目标是 `JAP_kodoha_china_landing_priority` 州和邻州 |
| `JAP_kodoha_china_war_guangzhou_bridgehead_push` | 广州已全控，广东/南宁/广西任一未全控 | `front_unit_request = 25`；`front_control ratio = 0`，`priority = 600`，`rush_weak` | 华南登陆场扩张 |
| `JAP_kodoha_china_war_shanghai_bridgehead_push` | 上海已全控，苏州/南京/江苏/浙江任一未全控 | `front_unit_request = 30`；`front_control ratio = 0`，`priority = 650`，`rush_weak` | 华东登陆场扩张 |
| `JAP_kodoha_china_war_nanjing_to_anhui_push` | 南京已全控，安徽未全控 | `front_unit_request = 20`；`front_control ratio = 0`，`priority = 450`，`rush_weak` | 长江线第一段 |
| `JAP_kodoha_china_war_anhui_to_hubei_push` | 南京、安徽已全控，湖北未全控 | `front_unit_request = 25`；`front_control ratio = 0`，`priority = 500`，`rush_weak` | 长江线第二段 |
| `JAP_kodoha_china_war_hubei_to_wuhan_push` | 南京、湖北已全控，武汉未全控 | `front_unit_request = 35`；`front_control ratio = 0`，`priority = 600`，`rush_weak` | 武汉攻势 |
| `JAP_kodoha_china_war_wuhan_to_sichuan_push` | 武汉已全控，四川未全控 | `front_unit_request = 30`；`front_control ratio = 0`，`priority = 550`，`rush_weak` | 重庆东侧门户 |
| `JAP_kodoha_china_war_wuhan_to_changde_flank` | 武汉已全控，常德未全控 | `front_unit_request = 15`；`front_control ratio = 0`，`priority = 380`，`balanced` | 重庆攻势南侧侧翼 |
| `JAP_kodoha_china_war_chongqing_final_push` | 武汉已全控，四川或常德已全控，重庆未全控 | `front_unit_request = 40`；`front_control ratio = 0`，`priority = 700`，`rush_weak` | 重庆终局 |
| `JAP_kodoha_china_war_chongqing_cyclic_offensive` | 武汉已全控，重庆未全控 | `front_control ratio = 0`，`priority = 750`，`rush_weak` | 四川/重庆方向终局持续冲击，无额外 request；`cyclic` 为历史命名 |
| `JAP_kodoha_china_war_jiangxi_flank_push` | 南京已全控，江西未全控 | `front_unit_request = 15`；`front_control ratio = 0`，`priority = 300`，`balanced` | 武汉方向南侧保障 |
| `JAP_kodoha_replenishment_mode_pause_fronts` | 暂时用 `##` 注释禁用；旧条件为有战争，军工 `> 100`，有 `JAP_ai_land_production_replenishment_mode` | 旧值为 `front_control ratio = 0`，`priority = 1000`，`careful`，`execute_order = no`，`manual_attack = no` | 所有与 ROOT 交战的国家 |
| `JAP_kodoha_post_china_land_front_rest_pulse` | 中国战事基本结束、有战争，且 `global.num_days % 60 > 44` | 非中国交战国陆上前线 `front_control ratio = 0`，`priority = 680`，`careful`，`execute_order = no`，`manual_attack = yes` | 每 60 天最后 15 天压住普通非中国陆上前线，不影响 request、登陆和 buffer |
| `JAP_kodoha_china_war_low_infantry_equipment_careful_fronts` | 对华战争，步枪 `< 500`；步枪 `> 2000` 后解除 | `front_control ratio = 0`，`priority = 800`，`careful` | 只降速，不显式停攻 |
| `JAP_kodoha_china_war_critical_infantry_equipment_pause_fronts` | 对华战争，步枪 `< -5000`；步枪 `> 500` 后解除 | `front_control ratio = 0`，`priority = 1200`，`careful`，`execute_order = no`，`manual_attack = no` | 极端缺装时暂停对华主动推进 |

北方东线当前主体策略总览：`JAP_kodoha_northern_east_theater_reserve_buffer` 在中国战事基本结束、东线支点可用、远东主轴未完成、日本列岛 13 州安全、未完成北进论且未对苏开战时启用，`order_id = 2701`、`ratio = 0.10`；`JAP_kodoha_northern_east_theater_buffer` 在完成北进论 `JAP_hokushin_ron` 或与苏联开战后切到 `ratio = 0.25`、`area_priority = 35`。屯兵州均为北海道 `536`、热河 `610`、辽宁 `716`、吉林 `328`、黑龙江 `714`、平安-黄海 `527`、咸镜 `1028`。北海道在东线 area 内，作为屯兵和远东大陆登陆支点；东线 area 也补入东萨哈/西萨哈以覆盖雅库茨克作战半径；`JAP_kodoha_northern_east_access_lost` 只看热河、辽宁、吉林、黑龙江、平安-黄海、咸镜这些前进支点，不由北海道或萨哈单独维持。`JAP_kodoha_northern_east_main_pressure` 仍只在对苏敌情存在时启用，使用 `front_unit_request = 45`、`front_control priority = 560`、`balanced`。完成北进论且与苏联交战时，`JAP_kodoha_northern_soviet_armor_score` 对 `SOV` 给 `front_armor_score = 200`，把装甲/进攻模板推向苏联前线。大陆登陆只覆盖符拉迪沃斯托克 `408` 和哈巴罗夫斯克 `409`，分别给 `invasion_unit_request = 45/35`，共享 `naval_invasion_focus = 60`、`naval_invasion_dominance_weight = 35`；登陆后 30 天由 `JAP_kodoha_northern_east_landing_followup` 给 `front_unit_request = 25`、`priority = 700`，不新增守岛 buffer。

北方西线当前主体策略总览：`JAP_kodoha_northern_west_theater_reserve_buffer` 在中国战事基本结束、西线支点可用、西线未完成、日本列岛 13 州安全、未完成北进论且未对苏开战时启用，`order_id = 2702`、`ratio = 0.05`；`JAP_kodoha_northern_west_theater_buffer` 在完成北进论 `JAP_hokushin_ron` 或与苏联开战后切到 `ratio = 0.14`、`area_priority = 15`。屯兵州均为乌鲁木齐 `617`、准噶尔 `618`、青海 `604`、绥远 `621`、察哈尔 `611`、乌兰巴托 `330`。西线 area 覆盖华西、山西、阿尔泰，以及外里海、费尔干纳、撒马尔罕、锡尔河内的苏联中亚州，但本版不把这些州加入侧翼敌情、推进 state_trigger 或完成条件。`JAP_kodoha_northern_west_side_pressure` 仍只在侧翼敌情存在时启用，`front_unit_request = 20`、`front_control priority = 400`、`balanced`。`JAP_kodoha_northern_west_deep_pressure` 只在北方东线远东主轴完成，或西线已控制克拉斯诺亚尔斯克 `568`、新西伯利亚 `570`、鄂木斯克 `571` 任一桥头堡后启用，`front_unit_request = 15`、`front_control priority = 340`、`balanced`。西线不写登陆、不写 `on_action`、不新增守岛 buffer。

## 对华推进阶段

当前顺序大致是：

1. 基础层：亚洲 `area_priority = 20`，有战争时小幅提高登陆倾向。
2. 对华开战：`garrison = -9999` 释放兵力，主前线 `front_unit_request = 40`，常态 `priority = 150`。
3. 开局突破：加强冀东驻军后推北平、山东、河北、济南、青岛，`priority = 300`。
4. 沿海登陆：山东、青岛、上海各 `60`，广州 `80`，制海权重 `30`。
5. 登陆场巩固：登陆 flag 窗口内 `front_unit_request = 30`，`priority = 700`。
6. 华东/华南扩张：上海方向 `priority = 650`，广州方向 `priority = 600`。
7. 长江推进：安徽 `450`，湖北 `500`，武汉 `600`。
8. 终局重庆：四川 `550`，常德侧翼 `380`，重庆 `700`，终局持续冲击 `750`。
9. 对华推进不参与中国战后普通休整层；除步枪低库存 `800` 和步枪极端缺口 `1200` 外持续强推。
10. 大本营宣告对华战争胜利后，`JAP_china_war_substantially_ended_flag` 停止皇道派对华前线、登陆、推进与对华缺装保险策略。

## 东南亚军区第一版

实际 area key：`JAP_rework_southeast_asia_theater`，位于 `common/ai_areas/JAP_rework_areas.txt`。

战略区域：`165` 华南、`248` 广西、`249` 云南、`142` 北印度支那、`228` 南印度支那、`229` 暹罗、`188` 马来亚、`292` 掸族诸邦、`293` 丹那沙林、`294` 仰光、`295` 曼德勒、`72` 马六甲海峡、`73` 暹罗湾、`75` 南中国海。不包含 `189` 和 `101`。

辅助 trigger 位于 `common/scripted_triggers/JAP_kodoha_ai_area_scripted_triggers.txt`：

- `JAP_kodoha_southeast_asia_staging_available`：南方屯兵点任一仍由 ROOT 或盟友控制。
- `JAP_kodoha_southeast_asia_staging_lost`：云南、广西、南宁、广州、广东五个大陆出发口全部丢失。
- `JAP_kodoha_southeast_asia_core_corridor_secured`：景栋和永贵到新加坡的核心走廊均由 ROOT 或盟友控制。
- `JAP_kodoha_southeast_asia_enemy_presence`：核心走廊任一州由与 ROOT 交战的国家控制。
- `JAP_kodoha_southeast_asia_hainan_departure_available`：海南由 ROOT 或盟友控制，作为暹罗/马来亚登陆门槛。
- `JAP_kodoha_southeast_asia_malaya_departure_available`：马来亚由 ROOT 或盟友控制，作为勃固/仰光登陆门槛。
- `JAP_kodoha_southeast_asia_siam_landing_available`：海南可用，暹罗由与 ROOT 交战国家控制。
- `JAP_kodoha_southeast_asia_malaya_landing_available`：海南可用，马来亚由与 ROOT 交战国家控制。
- `JAP_kodoha_southeast_asia_pegu_landing_available`：马来亚可用，勃固由与 ROOT 交战国家控制。
- `JAP_kodoha_southeast_asia_landing_target_available`：上述三条登陆窗口任一成立。

主动登陆目标为暹罗 `289`、马来亚 `336`、勃固/仰光 `995`。登陆链按“海南到暹罗/马来亚，马来亚到勃固/仰光”处理；出发州只作为启停判断，不指定真实出发港。新加坡 `1021` 只保留为核心走廊完成条件，不作为主动登陆目标。

东南亚登陆参数在菜鸟意大利口径基础上按皇道派多登陆点并发削弱：目标州 `invasion_unit_request = 60`，登陆窗口 `naval_invasion_focus = 100`，`naval_invasion_dominance_weight = 40`，海军门槛 `enemies_naval_strength_ratio < 1.5`。本轮不加入非目标登陆点负向抑制。

## 南亚军区第一版

实际 area key：`JAP_rework_south_asia_theater`，位于 `common/ai_areas/JAP_rework_areas.txt`。

战略区域：`146` 喜马拉雅、`141` 东印度、`153` 北印度、`290` 孟加拉、`31` 德干高原、`231` 东高止、`253` 温迪亚恰尔、`254` 塔尔沙漠、`296` 古吉拉特、`190` 巴基斯坦、`291` 俾路支、`145` 塔克拉玛干、`251` 阿里、`162` 北阿富汗、`289` 南阿富汗、`101` 孟加拉湾、`104` 阿拉伯海、`230` 科摩林角、`292` 掸族诸邦、`293` 丹那沙林、`294` 仰光、`295` 曼德勒。不包含 `189`，因为该战略区域当前有效 province 数为 `0`。塔克拉玛干允许与北方西线重合，阿富汗只扩大南亚作战半径，不新增南亚 clear 条件。

辅助 trigger 位于 `common/scripted_triggers/JAP_kodoha_ai_area_scripted_triggers.txt`：

- `JAP_kodoha_south_asia_land_staging_available`：那曲、日喀则、阿里任一仍由 ROOT 或盟友控制。
- `JAP_kodoha_south_asia_pegu_departure_available`：勃固由 ROOT 或盟友控制，作为南亚登陆出发门槛。
- `JAP_kodoha_south_asia_access_lost`：喜马拉雅边境屯兵点全部不可用，且勃固也不可用。
- `JAP_kodoha_south_asia_main_enemy_presence`：南亚主目标任一州由与 ROOT 交战的国家控制，包含印度、巴基斯坦、孟加拉、喜马拉雅与锡兰相关州。
- `JAP_kodoha_south_asia_main_objectives_secured`：印度次大陆战略骨架州均由 ROOT 或盟友控制；用于停止主战准备 buffer。锡兰 `422` 不参与该完成条件，避免海岛登陆目标长期锁住 `order_id = 2401` 主战屯兵。
- 当前战略骨架州为 `423 424 425 426 427 428 429 430 431 432 433 435 436 437 438 439 440 443 983 986`。
- `JAP_kodoha_south_asia_burma_overlap_enemy_presence`：景栋和永贵、掸族诸邦、曼德勒、勃固、丹那沙林任一州由与 ROOT 交战的国家控制。
- `JAP_kodoha_south_asia_enclave_enemy_presence`：法属印度或果阿由与 ROOT 交战的国家控制。
- `JAP_kodoha_south_asia_theater_clear`：南亚主目标、缅甸重合区和两个小飞地都没有交战控制者；这是战时执行层清理口径，不再作为主战 buffer 的和平期停止口径。

南亚释放规则：

- 主战 buffer 要求 `JAP_kodoha_south_asia_access_lost = no`；只要喜马拉雅边境或勃固任一路径可用，南亚主战集结即可启用。
- 只要 `JAP_kodoha_south_asia_access_lost = yes`，南亚推进、登陆需求和登陆窗口都应停止。
- 主战 buffer 在 `JAP_kodoha_south_asia_main_objectives_secured = yes` 后释放；该 trigger 只看印度战略骨架，战时推进、锡兰登陆需求和清理仍按 `JAP_kodoha_south_asia_theater_clear`/敌情口径启停。
- 缅甸重合区与法属印度/果阿会阻塞南亚完成，但进入清理阶段后只保留低强度需求。

南亚数值分层：

- 主战阶段：`put_unit_buffers ratio = 0.15`，`area_priority = 25`，`front_unit_request = 25`，`front_control priority = 500`。
- 清理阶段：`put_unit_buffers ratio = 0.06`，`front_unit_request = 10`，`front_control priority = 360`。
- 登陆后巩固：`front_unit_request = 30`，`front_control priority = 700`。

南亚登陆目标：

- 勃固 `995` 可用后，尝试登陆西孟加拉 `431`、孟买 `429`、锡兰 `422`。
- 不主动登陆法属印度 `320` 与果阿 `321`；如果它们敌控，会通过清理阶段阻塞释放并提供低强度需求。
- 南亚登陆参数沿用东南亚口径：目标州 `invasion_unit_request = 60`，共享 `naval_invasion_focus = 100` 和 `naval_invasion_dominance_weight = 40`，海军门槛 `enemies_naval_strength_ratio < 1.5`。

## 东印度-澳新军区当前口径

实际 area key：`JAP_rework_east_indies_australia_theater`，位于 `common/ai_areas/JAP_rework_areas.txt`。

战略区域：`188` 马来亚、`72` 马六甲海峡、`187` 苏门答腊、`159` 婆罗洲、`158` 巽他群岛、`93` 爪哇海、`167` 新几内亚、`91` 阿拉弗拉海、`99` 极东印度洋、`193` 北澳大利亚、`156` 南澳大利亚、`194` 东澳大利亚、`195` 中澳大利亚、`98` 大澳大利亚湾、`157` 新西兰、`86` 塔斯曼海、`81` 珊瑚海。故意不包含菲律宾和中太平洋方向。

## 太平洋军区区域第一版

实际 area key：`JAP_rework_pacific_theater`，位于 `common/ai_areas/JAP_rework_areas.txt`。主体策略已经落地，包含九州集结、可调用弹性守备、两条逐跳登陆链、共享登陆窗口、分级登陆后推进、常态推进、两条不可调用岛链守备和完成后夏威夷常驻守备。

战略区域：`154` 日本列岛、`90` 日本海岸、`76` 东中国海、`75` 南中国海、`78` 菲律宾海、`160` 菲律宾、`94` 马里亚纳海沟、`84` 俾斯麦海、`97` 东密克罗尼西亚、`95` 西天皇海山链、`96` 北天皇海山链、`180` 密克罗尼西亚裂谷、`177` 西北太平洋、`114` 北太平洋、`172` 太平洋海脊、`105` 夏威夷海脊。明确不纳入 `77` 黄海，避免牵扯朝鲜、华北和黄海侧翼方向。

用途：统一覆盖台湾 `524`、冲绳 `526`、北九州 `528`、南九州 `1018`，菲律宾群岛，硫磺岛 `645`、塞班岛 `646`、加罗林群岛 `684`、马绍尔群岛 `633`、关岛 `638`、威克岛 `632`、中途岛 `631`、夏威夷 `629`。北九州和南九州作为当前太平洋策略的囤兵处与本土相关目标。

岛链规划：

- 北/中太平洋主链：北九州 `528` / 南九州 `1018` -> 硫磺岛 `645` -> 塞班岛 `646` -> 关岛 `638` -> 威克岛 `632` -> 中途岛 `631` -> 夏威夷 `629`。
- 南/菲律宾支链：北九州 `528` / 南九州 `1018` -> 冲绳 `526` -> 台湾 `524` -> 马尼拉 `327` / 吕宋 `623` -> 北棉兰老 `1026` / 达沃 `627` -> 加罗林群岛 `684` -> 马绍尔群岛 `633` -> 威克岛 `632` -> 中途岛 `631` -> 夏威夷 `629`。
- 北/中太平洋主链继承旧讲座派“塞班 -> 关岛 -> 威克 -> 中途 -> 夏威夷”的方向，并向内补上九州、硫磺岛和塞班岛防守纵深。
- 南/菲律宾支链负责菲律宾和南侧太平洋侧翼；菲律宾失守时回守台湾/冲绳，加罗林群岛失守时回守菲律宾或塞班方向。
- 两链共用 `JAP_rework_pacific_theater`；可调用弹性守备与九州集结共用 `order_id = 2600`，旧北链守备使用 `order_id = 2601`，旧南链守备使用 `order_id = 2602`。
- 夏威夷方向晚启用：必须中途岛 `631` 由 ROOT 或盟友控制，且日本内环与菲律宾主节点没有敌情。
- 日本列岛 13 州任一州失控时立即放弃太平洋主体策略；冲绳、台湾、南萨哈林、千岛群岛不计入这个撤出口径。
- 十四个主动登陆链目标全部由 ROOT 或盟友控制后视为军区完成，不再追逐萨马、巴拉望、西米沙鄢等残余目标。

太平洋数值分层：

- 九州集结：`put_unit_buffers order_id = 2600`，`ratio = 0.10`，`area_priority = 20`，屯兵北九州 `528` 与南九州 `1018`。
- 可调用弹性守备：14 个主动/守备节点各一条 `put_unit_buffers order_id = 2600`、`ratio = 0.10`，复用对应旧守备 `_needed`，并用 `subtract_invasions_from_need = yes`、`subtract_fronts_from_need = yes`。
- 主动登陆请求：硫磺岛、塞班岛、关岛、冲绳、台湾、马尼拉、吕宋为 `50`；威克岛、中途岛、北棉兰老、达沃、加罗林群岛、马绍尔群岛为 `40`；夏威夷为 `30`。
- 登陆窗口：`naval_invasion_focus = 80`，`naval_invasion_dominance_weight = 40`，并与逐跳 `invade` 和 `invasion_unit_request` 一样要求 `enemies_naval_strength_ratio < 1.5`。
- 夏威夷登陆支援：`JAP_kodoha_pacific_hawaii_landing_support_priority` 只在 `JAP_kodoha_pacific_hawaii_landing_available = yes` 时启用；北天皇海山链 `96`、西北太平洋 `177`、太平洋海脊 `172` 为 `150`，北太平洋 `114`、夏威夷海脊 `105` 为 `200`。
- 登陆后推进分层：硫磺岛、威克岛、中途岛、马绍尔群岛不打 followup flag；冲绳、塞班岛、关岛、加罗林群岛、夏威夷使用 `front_unit_request = 5`、`priority = 690`；台湾、马尼拉、吕宋、北棉兰老、达沃使用 `front_unit_request = 10`、`priority = 700`。
- 常态推进：`front_unit_request = 15`，`front_control priority = 420`，低于东印度-澳新澳新推进 `480` 和东南亚主推进 `520`。
- 不可调用岛链守备：普通小岛 `ratio = 0.02`，台湾/冲绳/菲律宾主节点 `0.03`，夏威夷 `0.04`；旧守备使用 `subtract_invasions_from_need = no` 与 `subtract_fronts_from_need = no`。
- 完成后常驻：重要目标全控后关闭主体军区，只保留夏威夷 `order_id = 2603`、`ratio = 0.03` 常驻守备；本土 13 州失控时该常驻守备也停用。

辅助 trigger 位于 `common/scripted_triggers/JAP_kodoha_ai_area_scripted_triggers.txt`：

- `JAP_kodoha_pacific_staging_available`：北九州或南九州由 ROOT 或盟友控制。
- `JAP_kodoha_pacific_operational_access_available`：九州集结点可用，或任一太平洋链上支点仍由 ROOT 或盟友控制。
- `JAP_kodoha_pacific_access_lost`：九州集结点和链上支点全失。
- `JAP_kodoha_pacific_inner_ring_enemy_presence`：北九州、南九州、冲绳、台湾、硫磺岛、塞班岛、关岛任一州由与 ROOT 交战的国家控制。
- `JAP_kodoha_pacific_philippines_main_enemy_presence`：马尼拉、吕宋、北棉兰老、达沃任一州敌控；`JAP_kodoha_pacific_philippines_enemy_presence` 额外覆盖萨马、巴拉望、西米沙鄢。
- `JAP_kodoha_pacific_outer_island_enemy_presence`：加罗林群岛、马绍尔群岛、威克岛、中途岛任一州敌控。
- `JAP_kodoha_pacific_hawaii_enemy_presence`：夏威夷敌控。
- `JAP_kodoha_home_islands_compromised`：日本列岛 13 州任一州非 ROOT 或附庸完全控制；不含冲绳、台湾、南萨哈林、千岛群岛，也不使用 `is_core_of = JAP`。
- `JAP_kodoha_home_islands_warning`：太平洋内环敌情、满洲关键州敌控或中国战后华东沿海敌控任一成立。
- `JAP_kodoha_home_islands_crisis`：只由日本列岛 13 州任一州敌控触发，不读取投降进度。
- `JAP_kodoha_pacific_key_objectives_secured`：十四个主动登陆链目标均由 ROOT 或盟友控制。
- `JAP_kodoha_pacific_theater_clear`：作为停止符使用；敌情全清、重要目标全控或本土 13 州失控任一成立即为 yes。
- `JAP_kodoha_pacific_hawaii_landing_gate_available`：中途岛 `631` 稳定，且日本内环与菲律宾主节点无敌情。
- 太平洋逐跳 landing trigger 覆盖北链硫磺岛、塞班岛、关岛、威克岛、中途岛、夏威夷，以及南链冲绳、台湾、马尼拉、吕宋、北棉兰老、达沃、加罗林群岛、马绍尔群岛。
- 太平洋守备 trigger 按“当前节点已控，下一跳未控，或下一跳已控但下下跳未控”释放窗口；威克岛、中途岛、夏威夷等关键汇合/终点节点守到 `JAP_kodoha_pacific_theater_clear = yes`。
- `JAP_kodoha_northern_manchuria_warning`：热河 `610`、辽宁 `716`、大连 `745`、吉林 `328`、黑龙江 `714` 任一由交战敌国控制。
- `JAP_kodoha_northern_korea_delay_needed`：满洲关键州预警，且平安-黄海 `527` 或咸镜 `1028` 仍由 ROOT/盟友控制，本土危机时停用。
- `JAP_kodoha_china_coast_home_warning`：中国战事基本结束后，上海 `613`、浙江 `596`、江苏 `598`、苏州 `1034`、南京 `1035`、福建 `595` 任一敌控；只触发本土预警，不创建华东防守军区。
- `JAP_kodoha_eia_handoff_ready`：东南亚核心走廊已完成，且马来亚或新加坡由 ROOT 或盟友控制。
- `JAP_kodoha_eia_critical_hold_available`：马来亚、新加坡、东印度大岛、新几内亚、澳洲主桥头堡、北岛任一关键支点由 ROOT 或盟友控制；小巽他、东帝汶、摩鹿加、内婆罗洲、塔斯马尼亚、南岛不算关键支点。
- `JAP_kodoha_eia_operational_access_available`：接替点可用，或军区关键支点仍可用；推进和守备层使用此口径。
- `JAP_kodoha_eia_access_lost`：军区关键支点全失。
- `JAP_kodoha_eia_big_island_enemy_presence`：苏门答腊、爪哇、沙捞越、加里曼丹、摩鹿加、苏拉威西、西巴布亚、巴布亚任一州由与 ROOT 交战的国家控制。
- `JAP_kodoha_eia_australia_nz_bridgehead_available`：北领地、西澳大利亚、北昆士兰、新南威尔士任一州由 ROOT 或盟友控制。
- `JAP_kodoha_eia_cleanup_enemy_presence`：东印度主节点与澳新主节点已清，但小岛、内陆或零散目标仍有交战控制者。
- `JAP_kodoha_eia_theater_clear`：东印度、澳新与残余目标都没有交战控制者。

主动登陆网络：

- 第一波东印度门户：马来亚/新加坡可用后，同时开放苏门答腊 `672`、爪哇 `335`、沙捞越 `333`、加里曼丹 `334`。
- 第二波中部枢纽：由已控东印度门户或相邻枢纽开放小巽他 `667`、东帝汶 `721`、摩鹿加 `668`、苏拉威西 `673`、西巴布亚 `669`、巴布亚 `523`。
- 第三波澳新桥头堡：由东印度西/东侧支点开放北领地 `520`、西澳大利亚 `522`、北昆士兰 `872`、新南威尔士 `285`；维多利亚、南澳、昆士兰和内陆交给陆推/清理。
- 塔斯马尼亚末端岛：新南威尔士 `285` 或维多利亚 `517` 控制后，开放塔斯马尼亚 `518` 的低强度末端主动登陆。
- 新西兰：新南威尔士 `285` 控制后开放北岛 `284`，北岛控制后开放南岛 `723`。
- 登陆请求值：主门户与澳洲桥头堡 `45`；摩鹿加/苏拉威西/西巴布亚/巴布亚/北岛 `35`；小巽他/东帝汶/塔斯马尼亚/南岛 `25`。
- 共享登陆窗口：`naval_invasion_focus = 80`，`naval_invasion_dominance_weight = 40`，并与 `invade`、`invasion_unit_request` 一样要求 `enemies_naval_strength_ratio < 1.5`。

东印度-澳新数值分层：

- 接替集结：`put_unit_buffers order_id = 2501`，`ratio = 0.15`，`area_priority = 20`，屯兵马来亚 `336` 与新加坡 `1021`；进入清理阶段后主 buffer 关闭。
- 清理集结：`put_unit_buffers order_id = 2501`，`ratio = 0.04`，只在 `JAP_kodoha_eia_cleanup_enemy_presence = yes` 时启用。
- 登陆后桥头堡：小巽他、东帝汶、摩鹿加、塔斯马尼亚、南岛低强度 `front_unit_request = 5`、`front_control priority = 690`；其他主动登陆目标基础 `15`，澳新桥头堡额外 `+10`，主桥头堡 `priority = 700`。
- 东印度主节点推进：`front_unit_request = 10`，`front_control priority = 440`，低于东南亚主推进 `520`。
- 澳新大陆推进：`front_unit_request = 20`，`front_control priority = 480`，只在澳新桥头堡存在后启用。
- 残余清理：`front_unit_request = 6`，`front_control priority = 320`。

本地弹性防备池规则：

- 本地守备只写 `put_unit_buffers`，不写进攻性 `front_control`；每个节点都要求该州由 ROOT 或盟友控制，敌控州不会成为 buffer 目标。
- 所有节点共用 `order_id = 2501`，并和马来亚/新加坡接替集结、清理集结处在同一个需求池；主阶段 `ratio = 0.15`，清理阶段 `ratio = 0.04`。
- 守备 buffer 写 `subtract_invasions_from_need = yes`、`subtract_fronts_from_need = yes`，允许军区内登陆需求和前线需求抵扣这些本地守备。
- 主阶段按方向口径启用：西侧节点看苏门答腊/爪哇/小巽他/东帝汶/西澳方向敌情；东侧节点看沙捞越/加里曼丹/摩鹿加/苏拉威西/新几内亚/澳洲东岸敌情；澳新节点复用澳新敌情口径。
- 节点列表：西侧为苏门答腊 `672`、爪哇 `335`、小巽他 `667`、东帝汶 `721`；东侧为沙捞越 `333`、加里曼丹 `334`、摩鹿加 `668`、苏拉威西 `673`、西巴布亚 `669`、巴布亚 `523`；澳新为北领地 `520`、西澳大利亚 `522`、北昆士兰 `872`、新南威尔士 `285`、维多利亚 `517`、北岛 `284`、南岛 `723`、塔斯马尼亚 `518`。

## 北美军区当前口径

实际 area key：`JAP_rework_north_america_theater`，位于 `common/ai_areas/JAP_rework_areas.txt`。战略区域覆盖夏威夷海脊、北太平洋、美国东西海岸、加拿大、墨西哥、中美洲、加勒比、阿拉斯加和格陵兰相关区域；不纳入南美洲。

启动门槛：皇道派日本 AI 已满足 `JAP_kodoha_major_asian_theaters_basic_missions_completed = yes`，仍与美国交战，已完成大本营决议“筹备美国本土登陆”并获得 `JAP_us_mainland_invasion_preparation_completed_flag`，夏威夷 `629` 由 ROOT 或附庸完全控制，且日本本土未失守。北美敌情用 `any_state = { is_on_continent = north_america controller = { has_war_with = ROOT } }` 检测。

作战流程：夏威夷阶段使用 `order_id = 2604`、`ratio = 0.25` 在夏威夷集结；完成“筹备美国本土登陆”且仍与美国交战时，`JAP_kodoha_north_america_usa_armor_score` 对 `USA` 给 `front_armor_score = 200`，把装甲/进攻模板推向美国前线；主动登陆加利福尼亚 `378` 与俄勒冈 `385`，请求值为 `80/60`，共享 `naval_invasion_focus = 100` 与 `naval_invasion_dominance_weight = 45`。登陆加利福尼亚、俄勒冈或华盛顿 `386` 后，`on_naval_invasion` 打北美 landing flag，30 天内以 `front_unit_request = 35`、`priority = 720` 扶住桥头堡。

西海岸节点控制后，夏威夷集结关闭，同一 `order_id = 2604` 转移到西海岸，节点优先级为加利福尼亚 > 俄勒冈 > 华盛顿；同一时间只启用一个 `ratio = 0.25` 的囤兵点。北美常态推进用 `area = JAP_rework_north_america_theater`、`front_unit_request = 45`、`front_control priority = 650`、`balanced`，让西海岸囤兵点服务整个北美前线。

## 本土防卫与朝鲜止血当前口径

实际 area key：`JAP_rework_home_islands_defense` 和 `JAP_rework_korea_theater`，位于 `common/ai_areas/JAP_rework_areas.txt`。`JAP_rework_home_islands_defense` 只含战略区域 `154` 日本列岛；`JAP_rework_korea_theater` 只含战略区域 `186` 朝鲜。

本土州表固定为日本列岛 13 州：北海道 `536`、北东北 `533`、南东北 `1019`、甲信越 `534`、北陆 `535`、关东 `282`、东海道 `532`、关西 `531`、四国 `530`、山阳 `529`、山阴 `1020`、北九州 `528`、南九州 `1018`。后续所有“本土”启停、危机和外线释放逻辑都调用 `JAP_kodoha_is_home_islands_state` 或对应统一本土 trigger；禁止用投降进度或 `is_core_of = JAP` 识别本土。

本土预备队使用同一个 `order_id = 2800`：常态 `JAP_kodoha_home_islands_base_guard` 为 `ratio = 0.05`，预警 `JAP_kodoha_home_islands_warning_guard` 为 `ratio = 0.15`，危机 `JAP_kodoha_home_islands_crisis_guard` 为 `ratio = 0.25`。三层不会叠加，只取当前启用层的最高值；屯兵关东 `282`、东海道 `532`、关西 `531`、北九州 `528`、南九州 `1018`、北海道 `536`，`area = JAP_rework_home_islands_defense`，`subtract_invasions_from_need = no`、`subtract_fronts_from_need = no`。

预警来源有三类：太平洋内环敌情；满洲关键州热河 `610`、辽宁 `716`、大连 `745`、吉林 `328`、黑龙江 `714` 任一敌控；中国战事基本结束后华东沿海上海 `613`、浙江 `596`、江苏 `598`、苏州 `1034`、南京 `1035`、福建 `595` 任一敌控。华东沿海只拉本土预警，不额外创建华东防守军区。

本土危机只等于日本列岛 13 州任一州由交战敌国控制。危机时 `JAP_kodoha_home_islands_crisis_front_control` 对 `JAP_rework_home_islands_defense` 给 `front_unit_request = 70` 和 `front_control priority = 900`、`rush_weak`；`JAP_kodoha_home_islands_crisis_release_outer_operations` 对 `JAP_kodoha_is_home_islands_state = no` 的州降低外线 `front_unit_request = -80` 与 `invasion_unit_request = -120`。

北方止血不守北海道。`JAP_kodoha_northern_korea_delay_buffer` 在满洲关键州预警且朝鲜仍可拖延时启用，使用 `order_id = 2810`、`ratio = 0.04`，只驻平安-黄海 `527` 与咸镜 `1028`，`area = JAP_rework_korea_theater`。朝鲜实际敌控时 `JAP_kodoha_northern_korea_delay_front` 给 `front_unit_request = 12`、`front_control priority = 690`、`balanced`；本土危机时朝鲜止血停止，让兵力回到本土收复。

## 北方军区拆分第一版

实际 area key：`JAP_rework_northern_east_theater` 和 `JAP_rework_northern_west_theater`，位于 `common/ai_areas/JAP_rework_areas.txt`。单体 `JAP_kodoha_northern_theater` 已废弃，不再作为有效 area key。北方东线与北方西线主体策略均已落地；西线不写登陆、`on_action` 或守岛 buffer。

东线战略区域：`154` 日本列岛、`143` 华北、`155` 西满洲、`242` 北满洲、`243` 东满洲、`186` 朝鲜、`148` 俄属远东、`149` 东西伯利亚、`255` 阿穆尔、`256` 外贝加尔、`257` 北远东、`258` 鄂霍茨克、`259` 东萨哈、`260` 西萨哈、`79` 日本海、`87` 鄂霍茨克海、`88` 白令海。

西线战略区域：`145` 塔克拉玛干、`144` 华西、`267` 外里海、`268` 费尔干纳、`269` 撒马尔罕、`270` 锡尔河、`200` 青海、`244` 察哈尔、`245` 山西、`252` 天山、`152` 外蒙古、`266` 乌梁海、`147` 北西伯利亚、`151` 西西伯利亚、`261` 阿尔泰、`262` 中西伯利亚、`14` 外乌拉尔、`138` 乌拉尔山区、`263` 外乌拉尔-涅涅茨、`264` 科米-涅涅茨。

用途：北方东线负责北海道、华北、满洲、朝鲜、远东、阿穆尔、外贝加尔、东西伯利亚、萨哈和远东北方海域，是主对苏陆战方向；北海道纳入 area 以服务 `2701` 屯兵和大陆登陆，但不参与 access lost。北方西线负责新疆、华西、苏联中亚、青海、山西/察哈尔、外蒙古、乌梁海侧翼、阿尔泰和西伯利亚纵深到乌拉尔边界；华西、山西、苏联中亚和阿尔泰本版只补 area，不扩大主动推进 state_trigger。`255` 阿穆尔用于覆盖阿穆尔州；`259` 东萨哈、`260` 西萨哈用于覆盖雅库茨克作战半径；`261` 阿尔泰用于覆盖哈卡斯和卫拉特地区作战半径；`266` 乌梁海用于覆盖唐努图瓦；`264` 科米-涅涅茨用于覆盖北乌拉尔州，仍不代表向欧洲俄国核心扩展。

明确排除：不纳入中国全域，排除华东、华中、华南、广西、云南等南方纵深；不纳入印度、巴基斯坦；不纳入 `150` 阿尔汉格尔斯克/北极俄国或欧洲俄国核心；不纳入 `77` 黄海和 `114` 北太平洋。阿富汗由南亚军区覆盖，塔克拉玛干允许与南亚军区重合。

关键州覆盖核对：东线覆盖北海道 `536`、吉林 `328`、黑龙江 `714`、符拉迪沃斯托克 `408`、哈巴罗夫斯克 `409`、阿穆尔 `561`、赤塔 `563`、布里亚特 `564`、伊尔库茨克 `566`、雅库茨克 `574`、堪察加 `637`、北萨哈林 `655`、南萨哈林 `537`；西线覆盖乌鲁木齐 `617`、准噶尔 `618`、青海 `604`、绥远 `621`、察哈尔 `611`、乌兰巴托 `330`、唐努图瓦 `329`、哈卡斯 `569`、卫拉特地区 `654`、新西伯利亚 `570`、北乌拉尔 `581`，并覆盖华西、山西、外里海、费尔干纳、撒马尔罕、锡尔河战略区域内的苏联中亚州。

北方东线主体策略已落地：预备态 `order_id = 2701`、`ratio = 0.10`，完成北进论或对苏开战后切到 `ratio = 0.25`，屯兵北海道 `536`、热河 `610`、辽宁 `716`、吉林 `328`、黑龙江 `714`、平安-黄海 `527`、咸镜 `1028`；主推进使用 `front_unit_request = 45`、`front_control priority = 560`、`balanced`。完成北进论且对苏作战时，另有 `JAP_kodoha_northern_soviet_armor_score` 给 `SOV` `front_armor_score = 200`。北海道作为远东大陆登陆支点，主动登陆符拉迪沃斯托克 `408` 与哈巴罗夫斯克 `409`，不登陆萨哈林或堪察加，也不新增岛链守备；东线放弃只看满洲/朝鲜前进支点，东萨哈/西萨哈只补足自然推进半径。北方西线主体策略已落地：预备态 `order_id = 2702`、`ratio = 0.05`，完成北进论或对苏开战后切到 `ratio = 0.14`，屯兵乌鲁木齐 `617`、准噶尔 `618`、青海 `604`、绥远 `621`、察哈尔 `611`、乌兰巴托 `330`；侧翼推进使用 `front_unit_request = 20`、`priority = 400`，纵深推进使用 `front_unit_request = 15`、`priority = 340`；华西、山西、苏联中亚和阿尔泰只补入西线 area。

北方东线完成/撤出逻辑：远东主轴符拉迪沃斯托克 `408`、哈巴罗夫斯克 `409`、阿穆尔 `561`、赤塔 `563`、布里亚特 `564`、伊尔库茨克 `566` 均由 ROOT/盟友控制后，`JAP_kodoha_northern_east_theater_clear = yes`，关闭 buffer、主推进、登陆和登陆后桥头堡；热河 `610`、辽宁 `716`、吉林 `328`、黑龙江 `714`、平安-黄海 `527`、咸镜 `1028` 全失时，`JAP_kodoha_northern_east_access_lost = yes`，北海道 `536` 不参与该放弃判定；日本列岛 13 州任一州失控时，统一由 `JAP_kodoha_home_islands_compromised = yes` 立即停用北方东线主体。

北方西线完成/撤出逻辑：乌兰巴托 `330`、唐努图瓦 `329`、克拉斯诺亚尔斯克 `568`、新西伯利亚 `570`、鄂木斯克 `571`、北乌拉尔 `581`、斯维尔德洛夫斯克 `653`、车里雅宾斯克 `572`、马格尼托哥尔斯克 `582` 均由 ROOT/盟友控制后，`JAP_kodoha_northern_west_theater_clear = yes`，关闭西线 buffer、侧翼推进和纵深推进；日本列岛 13 州任一州失控时，统一由 `JAP_kodoha_home_islands_compromised = yes` 立即停用北方西线主体。

## 登陆后 flag 链

`common/on_actions/JAP_rework_ai_landing_on_actions.txt` 负责给皇道派登陆后短期推进提供 flag：

- 对华触发：皇道派日本 AI 对华战争中，海军入侵山东、青岛、上海或广州。
- 对华国家 flag：`JAP_kodoha_china_landing_boost`，策略中要求 `days < 30`。
- 对华州 flag：`JAP_kodoha_china_landing_priority`，设置 `days = 30`。
- 东南亚触发：中国战事基本结束后，皇道派日本 AI 海军入侵暹罗、马来亚或勃固。
- 东南亚国家 flag：`JAP_kodoha_southeast_asia_landing_boost`，策略中要求 `days < 30`。
- 东南亚州 flag：`JAP_kodoha_southeast_asia_landing_priority`，设置 `days = 30`。
- 南亚触发：中国战事基本结束后，皇道派日本 AI 海军入侵西孟加拉、孟买或锡兰。
- 南亚国家 flag：`JAP_kodoha_south_asia_landing_boost`，策略中要求 `days < 30`。
- 南亚州 flag：`JAP_kodoha_south_asia_landing_priority`，设置 `days = 30`。
- 东印度-澳新触发：中国战事基本结束且东南亚核心走廊完成后，皇道派日本 AI 海军入侵苏门答腊、爪哇、小巽他、东帝汶、沙捞越、加里曼丹、摩鹿加、苏拉威西、西巴布亚、巴布亚、北领地、西澳大利亚、北昆士兰、新南威尔士、塔斯马尼亚、北岛或南岛。
- 东印度-澳新国家 flag：`JAP_kodoha_eia_landing_boost`，策略中要求 `days < 30`。
- 东印度-澳新州 flag：`JAP_kodoha_eia_landing_priority`，设置 `days = 30`；所有主动登陆目标都会打 flag，其中小巽他、东帝汶、摩鹿加、塔斯马尼亚、南岛只走低强度 followup。
- 太平洋触发：中国战事基本结束、太平洋军区未完成/未撤出且仍有可用支点后，皇道派日本 AI 海军入侵塞班岛、关岛、夏威夷、冲绳、台湾、马尼拉、吕宋、北棉兰老、达沃或加罗林群岛。
- 太平洋国家 flag：`JAP_kodoha_pacific_landing_boost`，策略中要求 `days < 30`。
- 太平洋州 flag：`JAP_kodoha_pacific_landing_priority`，设置 `days = 30`；硫磺岛、威克岛、中途岛、马绍尔群岛不打 followup flag。
- 北美触发：北美作战支点可用且战区未清空时，皇道派日本 AI 海军入侵加利福尼亚、俄勒冈或华盛顿。
- 北美国家 flag：`JAP_kodoha_north_america_landing_boost`，策略中要求 `days < 30`。
- 北美州 flag：`JAP_kodoha_north_america_landing_priority`，设置 `days = 30`；覆盖加利福尼亚、俄勒冈和华盛顿。
- 北方东线州 flag：`JAP_kodoha_northern_east_landing_priority`，设置 `days = 30`；只覆盖符拉迪沃斯托克 `408` 与哈巴罗夫斯克 `409`。
- 军事策略会对有州 flag 的州及邻州加短期需求；东南亚、南亚、对华登陆沿用 `front_unit_request = 30`、`priority = 700`，东印度-澳新小岛 followup 为 `front_unit_request = 5`、`priority = 690`，主桥头堡基础 `15`，澳新桥头堡额外 `+10`，太平洋中等岛屿为 `front_unit_request = 5`、`priority = 690`，太平洋台湾/菲律宾主节点为 `front_unit_request = 10`、`priority = 700`，北方东线大陆登陆桥头堡为 `front_unit_request = 25`、`priority = 700`，北美西海岸桥头堡为 `front_unit_request = 35`、`priority = 720`。

如果新增登陆目标，要同时检查：

1. `on_naval_invasion` 是否给新目标州打 flag。
2. 登陆需求条目是否加了 `invasion_unit_request`。
3. 登陆后巩固条目的 `state_trigger` 是否能覆盖新登陆场。
4. 是否需要额外 `naval_invasion_dominance_weight` 或目标州建设逻辑。

## 东南亚登陆经验记录

本轮东南亚登陆链给后续登陆策略留下几个经验：

- 动态目标州控制者用 `reversed = yes` 处理；如果不同目标有不同出发州门槛，优先拆成多条反转 `invade`，避免一个目标可用时误给另一个控制者登陆倾向。
- `invasion_unit_request` 适合按目标州拆开写；`naval_invasion_focus` 和 `naval_invasion_dominance_weight` 适合做一条共享窗口，避免三个目标同时可用时重复堆全局登陆倾向。
- `enemies_naval_strength_ratio < 1.5` 要放进反转 `invade`、目标 request 和共享登陆窗口，确保海军比例不合格时同时停掉倾向、需求和制海加权。
- 出发州门槛只控制“该不该尝试登陆”，不控制真实出发港。海南门槛用于暹罗/马来亚，马来亚门槛用于勃固/仰光。
- 登陆后推进使用独立国家 flag 加短期 state flag：国家 flag 与 state flag 统一为 30 天窗口；`front_unit_request` 和 `front_control` 对登陆州及邻州生效。
- 登陆后推进要按目标体量分级：小岛可不打 state flag、不推邻州；较大岛屿只给小额短窗口；大陆、多州岛或关键陆战区才使用较高 `front_unit_request` 和 `priority = 700`。
- 登陆后 `front_control priority = 700` 高于东南亚主推进 `520`，但低于补装备停攻旧层 `1000`，只适合需要临时扶住的大陆级桥头堡；太平洋中等岛屿和东印度-澳新小岛/末端岛用 `690`，台湾/菲律宾主节点用 `700`。
- 非目标登陆点负向抑制不是默认项；只有实测 AI 乱飞时再考虑 `invasion_unit_request value = -200` 一类过滤层，并同步记录其覆盖范围。

## 目标州速查

北方东线新增目标州：北海道 `536` 是北方东线 buffer 屯兵点、日本列岛 13 州本土口径和远东大陆登陆支点；符拉迪沃斯托克 `408`、哈巴罗夫斯克 `409` 是北海道大陆登陆目标、登陆后 flag 目标和远东主轴完成目标；阿穆尔 `561`、赤塔 `563`、布里亚特 `564`、伊尔库茨克 `566` 是远东主轴完成目标，其中阿穆尔也是哈巴罗夫斯克登陆开启条件之一；雅库茨克 `574` 通过东萨哈/西萨哈纳入东线作战半径，用于覆盖 `要求苏维埃联盟投降`，但不参与远东主轴完成条件。

北方西线新增目标州：乌鲁木齐 `617`、准噶尔 `618`、青海 `604`、绥远 `621`、察哈尔 `611`、乌兰巴托 `330` 是 buffer/staging 支点；绥远和察哈尔所在的 `244` 察哈尔战略区域纳入西线 area，避免这两个西线前进点悬在服务口径外。华西 `144` 和山西 `245` 战略区域补入西线 area，用于覆盖中国西北/华北与外蒙古、苏联方向之间的过渡地带，但不新增 active push 目标。唐努图瓦 `329` 通过 `266` 乌梁海纳入西线；外里海、费尔干纳、撒马尔罕、锡尔河战略区域补入西线 area，用于覆盖新疆外侧苏联中亚，但不新增 active push 目标。哈卡斯 `569` 与卫拉特地区 `654` 通过 `261` 阿尔泰纳入西线作战半径，用于覆盖 `要求苏维埃联盟投降`，但不参与西线完成条件。克拉斯诺亚尔斯克 `568`、新西伯利亚 `570`、鄂木斯克 `571` 是纵深推进提前开启桥头堡，也是完成目标；北乌拉尔 `581`、斯维尔德洛夫斯克 `653`、车里雅宾斯克 `572`、马格尼托哥尔斯克 `582` 是乌拉尔边界完成目标。

| state | 中文名 | 当前用途 |
| ---: | --- | --- |
| `282` | 关东 | 日本列岛 13 州本土口径；本土防卫 `order_id = 2800` 屯兵州 |
| `284` | 北岛 | 东印度-澳新新西兰主动登陆目标、登陆后 flag 目标、澳新大陆推进范围、南岛守备前置 |
| `285` | 新南威尔士 | 东印度-澳新澳洲东侧桥头堡、登陆后 flag 目标、澳新大陆推进范围、塔斯马尼亚与新西兰登陆前置 |
| `378` | 加利福尼亚 | 北美西海岸主登陆目标、登陆后 flag 目标、北美西海岸优先囤兵节点 |
| `385` | 俄勒冈 | 北美西海岸次级登陆目标、登陆后 flag 目标、加利福尼亚未控时的西海岸囤兵节点 |
| `386` | 华盛顿 | 北美登陆后 flag 目标、加利福尼亚和俄勒冈未控时的西海岸囤兵节点 |
| `591` | 海南 | 东南亚登陆链出发州门槛，控制后才尝试暹罗和马来亚登陆 |
| `592` | 广州 | 广州登陆、华南登陆场起点 |
| `593` | 广东 | 广州登陆场扩张 |
| `594` | 南宁 | 广州登陆场扩张 |
| `595` | 福建 | 中国战后华东沿海本土预警州 |
| `286` | 占婆 | 东南亚核心走廊完成条件 |
| `289` | 暹罗 | 东南亚核心走廊完成条件、海南出发的主动登陆目标 |
| `320` | 法属印度 | 南亚清理阶段小飞地敌情，阻塞南亚完成 |
| `321` | 果阿 | 南亚清理阶段小飞地敌情，阻塞南亚完成 |
| `322` | 那曲 | 南亚主战边境 buffer 屯兵点 |
| `325` | 云南 | 东南亚军区 buffer 屯兵点、南方出发口；不再作为南亚 `2401` 屯兵点 |
| `327` | 马尼拉 | 太平洋南/菲律宾支链主动登陆目标、菲律宾主节点、主节点 followup flag 目标、南链守备节点 |
| `328` | 吉林 | 北方东线 buffer 屯兵点；满洲关键州本土预警 |
| `333` | 沙捞越 | 东印度-澳新第一波门户、登陆后 flag 目标、岛链守备节点 |
| `334` | 加里曼丹 | 东印度-澳新第一波门户、登陆后 flag 目标、东印度主节点推进范围 |
| `335` | 爪哇 | 东印度-澳新第一波门户、登陆后 flag 目标、东印度主节点推进范围 |
| `336` | 马来亚 | 东南亚核心走廊完成条件、海南出发的主动登陆目标、勃固/仰光登陆前置出发州 |
| `408` | 符拉迪沃斯托克 | 北方东线远东主轴完成目标、北海道大陆登陆目标、登陆后 flag 目标 |
| `409` | 哈巴罗夫斯克 | 北方东线远东主轴完成目标、北海道大陆登陆目标、登陆后 flag 目标 |
| `422` | 锡兰 | 南亚主敌情、独立主动登陆目标、南亚登陆后 flag 目标；不参与主战 buffer 完成条件 |
| `423` | 南马德拉斯 | 南亚战略骨架目标、清理阶段印度内部 buffer 屯兵点 |
| `427` | 海德拉巴 | 南亚战略骨架目标、清理阶段印度内部 buffer 屯兵点 |
| `429` | 孟买 | 南亚主目标敌情、主动登陆目标、南亚登陆后 flag 目标、清理阶段印度内部 buffer 屯兵点 |
| `431` | 西孟加拉 | 南亚主目标敌情、主动登陆目标、南亚登陆后 flag 目标、清理阶段印度内部 buffer 屯兵点 |
| `435` | 比哈尔 | 南亚战略骨架目标、清理阶段印度内部 buffer 屯兵点 |
| `438` | 联合省 | 南亚战略骨架目标、清理阶段印度内部 buffer 屯兵点 |
| `517` | 维多利亚 | 东印度-澳新澳新主节点敌情、澳新大陆推进范围、塔斯马尼亚登陆前置 |
| `518` | 塔斯马尼亚 | 东印度-澳新末端主动登陆目标、低强度 followup、残余敌情、澳新大陆推进与清理范围 |
| `519` | 南澳大利亚 | 东印度-澳新残余敌情、澳新大陆推进与清理范围 |
| `520` | 北领地 | 东印度-澳新澳洲北侧桥头堡、登陆后 flag 目标、澳新桥头堡 |
| `521` | 昆士兰 | 东印度-澳新残余敌情、澳新大陆推进与清理范围 |
| `522` | 西澳大利亚 | 东印度-澳新澳洲西侧桥头堡、登陆后 flag 目标、澳新桥头堡、岛链终点守备 |
| `523` | 巴布亚 | 东印度-澳新中部枢纽主动登陆目标、登陆后 flag 目标、东印度主节点推进范围 |
| `524` | 台湾 | 太平洋南/菲律宾支链内环节点、主动登陆目标、主节点 followup flag 目标、南链守备节点 |
| `526` | 冲绳 | 太平洋南/菲律宾支链内环节点、主动登陆目标、中等岛屿 followup flag 目标、南链守备节点 |
| `527` | 平安-黄海 | 北方朝鲜止血 `order_id = 2810` 屯兵州；朝鲜止血前线范围 |
| `528` | 北九州 | 太平洋军区九州集结点、`order_id = 2600` 屯兵州；日本列岛 13 州本土口径；本土防卫 `order_id = 2800` 屯兵州 |
| `529` | 山阳 | 日本列岛 13 州本土口径 |
| `530` | 四国 | 日本列岛 13 州本土口径 |
| `531` | 关西 | 日本列岛 13 州本土口径；本土防卫 `order_id = 2800` 屯兵州 |
| `532` | 东海道 | 日本列岛 13 州本土口径；本土防卫 `order_id = 2800` 屯兵州 |
| `533` | 北东北 | 日本列岛 13 州本土口径 |
| `534` | 甲信越 | 日本列岛 13 州本土口径 |
| `535` | 北陆 | 日本列岛 13 州本土口径 |
| `536` | 北海道 | 日本列岛 13 州本土口径；本土防卫 `order_id = 2800` 屯兵州；北方东线 buffer 屯兵点和远东大陆登陆支点 |
| `561` | 阿穆尔 | 北方东线远东主轴完成目标；哈巴罗夫斯克登陆开启条件之一 |
| `563` | 赤塔 | 北方东线远东主轴完成目标 |
| `564` | 布里亚特 | 北方东线远东主轴完成目标 |
| `566` | 伊尔库茨克 | 北方东线远东主轴完成目标 |
| `596` | 浙江 | 上海登陆场扩张 |
| `597` | 山东 | 华北开局、山东登陆、广州登陆前置 |
| `598` | 江苏 | 上海登陆场扩张 |
| `599` | 广西 | 广州登陆场扩张 |
| `600` | 江西 | 南京后南侧侧翼 |
| `601` | 昌都 | 不再作为南亚 `2401` 屯兵点 |
| `605` | 四川 | 武汉后西进、重庆终局持续冲击；不再作为南亚 `2401` 屯兵点 |
| `606` | 安徽 | 南京后推进 |
| `608` | 北平 | 华北开局 |
| `610` | 热河 | 北方东线 buffer 屯兵点；满洲关键州本土预警 |
| `613` | 上海 | 上海登陆、广州登陆前置、华东登陆场起点 |
| `614` | 河北 | 华北开局 |
| `620` | 湖北 | 安徽后推进、武汉前置 |
| `623` | 吕宋 | 太平洋南/菲律宾支链主动登陆目标、菲律宾主节点、主节点 followup flag 目标、南链守备节点 |
| `625` | 萨马 | 太平洋菲律宾残余敌情与常态推进范围 |
| `626` | 巴拉望 | 太平洋菲律宾残余敌情与常态推进范围 |
| `627` | 达沃 | 太平洋南/菲律宾支链主动登陆目标、菲律宾主节点、主节点 followup flag 目标、南链守备节点 |
| `628` | 西米沙鄢 | 太平洋菲律宾残余敌情与常态推进范围 |
| `629` | 夏威夷 | 太平洋共同终点、晚启用主动登陆目标、中等岛屿 followup flag 目标、北链终点守备、完成后常驻守备；北美军区初始集结点和启动门槛 |
| `631` | 中途岛 | 太平洋北链主动登陆目标、小岛无 followup flag、夏威夷登陆门槛、北链关键守备节点 |
| `632` | 威克岛 | 太平洋两链汇合节点、主动登陆目标、小岛无 followup flag、北链关键守备节点 |
| `633` | 马绍尔群岛 | 太平洋南/菲律宾支链外岛节点、主动登陆目标、小岛无 followup flag、南链守备节点 |
| `638` | 关岛 | 太平洋北链主动登陆目标、中等岛屿 followup flag 目标、北链守备节点 |
| `743` | 青岛 | 华北开局、青岛登陆 |
| `745` | 大连 | 满洲关键州本土预警 |
| `750` | 常德 | 武汉后南侧侧翼、重庆终局前置 |
| `757` | 日喀则 | 南亚主战边境 buffer 屯兵点 |
| `758` | 阿里 | 南亚主战边境 buffer 屯兵点 |
| `640` | 曼德勒 | 东南亚核心走廊完成条件、南亚缅甸重合区敌情 |
| `645` | 硫磺岛 | 太平洋北链内环节点、主动登陆目标、小岛无 followup flag、北链守备节点 |
| `646` | 塞班岛 | 太平洋北链内环节点、主动登陆目标、中等岛屿 followup flag 目标、北链守备节点 |
| `667` | 小巽他群岛 | 东印度-澳新中部枢纽主动登陆目标、小岛低强度 followup、守备节点、残余清理范围 |
| `668` | 摩鹿加群岛 | 东印度-澳新中部枢纽主动登陆目标、小岛低强度 followup、东印度主节点推进范围 |
| `669` | 西巴布亚 | 东印度-澳新中部枢纽主动登陆目标、登陆后 flag 目标、东印度主节点推进范围 |
| `670` | 老挝 | 东南亚核心走廊完成条件 |
| `671` | 东京 | 东南亚核心走廊完成条件 |
| `672` | 苏门答腊 | 东印度-澳新第一波门户、登陆后 flag 目标、东印度主节点推进范围 |
| `673` | 苏拉威西 | 东印度-澳新中部枢纽主动登陆目标、登陆后 flag 目标、东印度主节点推进范围 |
| `674` | 澳大利亚中部 | 东印度-澳新残余敌情、澳新大陆推进与清理范围 |
| `684` | 加罗林群岛 | 太平洋南/菲律宾支链外岛节点、主动登陆目标、中等岛屿 followup flag 目标、南链守备节点 |
| `714` | 黑龙江 | 北方东线 buffer 屯兵点；满洲关键州本土预警 |
| `716` | 辽宁 | 北方东线 buffer 屯兵点；满洲关键州本土预警 |
| `721` | 东帝汶 | 东印度-澳新中部枢纽主动登陆目标、小岛低强度 followup、守备节点、残余清理范围 |
| `723` | 南岛 | 东印度-澳新新西兰末端主动登陆目标、小岛低强度 followup、澳新推进与残余清理范围，终点守备到军区释放 |
| `741` | 柬埔寨 | 东南亚核心走廊完成条件 |
| `870` | 西北澳大利亚 | 东印度-澳新残余敌情、澳新大陆推进与清理范围 |
| `871` | 西南澳大利亚 | 东印度-澳新残余敌情、澳新大陆推进与清理范围 |
| `872` | 北昆士兰 | 东印度-澳新澳洲东侧桥头堡、登陆后 flag 目标、澳新桥头堡 |
| `873` | 西南昆士兰 | 东印度-澳新残余敌情、澳新大陆推进与清理范围 |
| `993` | 景栋和永贵 | 东南亚核心走廊完成条件、南亚缅甸重合区敌情 |
| `994` | 丹那沙林 | 东南亚核心走廊完成条件、南亚缅甸重合区敌情 |
| `995` | 勃固 | 东南亚核心走廊完成条件、马来亚出发的主动登陆目标、南亚主战边境/登陆出发 buffer 屯兵点、南亚登陆出发门槛、南亚缅甸重合区敌情 |
| `999` | 掸族诸邦 | 东南亚核心走廊完成条件、南亚缅甸重合区敌情 |
| `1017` | 越南中部 | 东南亚核心走廊完成条件 |
| `1018` | 南九州 | 太平洋军区九州集结点、`order_id = 2600` 屯兵州；日本列岛 13 州本土口径；本土防卫 `order_id = 2800` 屯兵州 |
| `1019` | 南东北 | 日本列岛 13 州本土口径 |
| `1020` | 山阴 | 日本列岛 13 州本土口径 |
| `1021` | 新加坡 | 东南亚核心走廊完成条件，不作为当前主动登陆目标 |
| `1026` | 北棉兰老 | 太平洋南/菲律宾支链主动登陆目标、菲律宾主节点、主节点 followup flag 目标、南链守备节点 |
| `1028` | 咸镜 | 北方朝鲜止血 `order_id = 2810` 屯兵州；朝鲜止血前线范围 |
| `1022` | 内婆罗洲 | 东印度-澳新残余敌情、清理范围 |
| `1034` | 苏州 | 上海登陆场扩张 |
| `1035` | 南京 | 上海登陆场扩张、长江线前置 |
| `1036` | 武汉 | 武汉攻势、重庆终局前置 |
| `1037` | 重庆 | 最终推进目标 |
| `1038` | 济南 | 华北开局 |

## 新增条目时的数值位置

新增皇道派前线条目时，先按意图放进现有梯子：

- 普通局部方向：`front_unit_request = 10` 到 `25`，`front_control priority = 250` 到 `400`。
- 新主推进段：`front_unit_request = 25` 到 `40`，`priority = 450` 到 `650`；中国战后普通大范围推进默认配合 `global.num_days % 60 < 15`。
- 小范围清理或微操推进可用 `global.num_days % 60 < 30`，但仍应低于主战区推进层；当前清理推进示例是南亚 `360`、东印度-澳新 `320`。
- 通用休整层固定为 `680`，只覆盖中国战后非中国陆上普通前线；新增普通推进不要放到 `680` 以上，除非明确属于例外窗口。
- 小岛/末端岛登陆后巩固、朝鲜止血等“不能被休整压住但也不是主桥头堡”的例外窗口使用 `690`。
- 登陆后短期巩固或决战窗口：`front_unit_request = 30` 到 `40`，`priority = 700` 到 `750`；北美西海岸桥头堡可用 `720`。
- 降速/停攻：必须高于正在覆盖的进攻层；当前低库存是 `800`，补装备模式旧层级为 `1000` 但暂时注释禁用，极端缺装是 `1200`。
- 不要让普通进攻新条目超过 `800`，否则会压过缺装保险。
- `front_armor_score` 不进入 `front_control priority` 梯子。当前强引导档为 `200`：北进论后对 `SOV`，美国本土登陆准备后对 `USA`；它只调整装甲/进攻模板去向，不替代 `front_unit_request` 或 `front_control`。

新增登陆目标时：

- 皇道派普通明确登陆点先从 `invasion_unit_request = 50` 到 `80` 起步；只有单一关键瓶颈或实测登陆不足时再考虑 `100+`。
- 不要同时给太多目标 `100+`，否则登陆计划容易被拆散并过量吸走兵力。
- 东南亚登陆链当前使用 `invasion_unit_request = 60`、`naval_invasion_focus = 100`、`naval_invasion_dominance_weight = 40`，并要求 `enemies_naval_strength_ratio < 1.5`。
- 东印度-澳新主动登陆按枢纽网络打开：主门户/澳洲桥头堡 `45`，中部枢纽与北岛 `35`，小岛/末端 `25`，共享登陆窗口为 `naval_invasion_focus = 80`。
- 太平洋主动登陆按两条岛链逐跳打开，每个目标都有上一跳门槛；内环和菲律宾主节点使用 `50`，外岛使用 `40`，夏威夷使用 `30`，共享登陆窗口为 `naval_invasion_focus = 80`。
- 新增链式登陆时，要先明确“出发州门槛”；这个门槛只用于启停判断，不代表能指定真实出发港。
- 全局 `naval_invasion_focus` 已有 `25`，对华沿海制海已有 `30`，新目标优先补目标 request、链式门槛和登陆后 flag，不要无节制堆全局倾向。

## 维护检查清单

修改皇道派军事策略后检查：

1. `Rance_is_jap_kodoha_ai = yes` 是否仍在 `enable`，而不是只放在 `allowed`。
2. 对华目标是否仍使用 `is_literally_china = yes`，避免漏掉军阀或特殊中国 tag。
3. 新增或改动对华军事条目时，是否加入 `NOT = { has_country_flag = JAP_china_war_substantially_ended_flag }`；如果条目使用显式 `abort`，是否也把该 flag 放进停止条件。
4. 中国战后普通 `front_control` 是否需要加入 `%60 < 15` 或 `%60 < 30` 脉冲；是否会被 `680` 休整层覆盖。
5. 新 `front_control priority` 是否位于预期梯子，是否会覆盖缺装/补装备刹车，或被 `680` 休整层误压。
6. 新增登陆州是否同步更新登陆需求、链式出发州门槛、登陆后 flag 链和本文目标州表。
7. 如果新增 `put_unit_buffers`，是否记录 `states` 屯兵点，并让 `area` 与对应 `front_unit_request` / `front_control` 的服务范围对齐。
8. 如果新增 `front_armor_score`，是否确认目标 tag 粒度不会误吸装甲到同一国家的次要战线，并在本文注明启用条件、目标 tag 与 value。
9. 如果改了数值，本文的“当前数值骨架”“前线控制优先级梯子”和“当前条目总览”是否同步更新。
