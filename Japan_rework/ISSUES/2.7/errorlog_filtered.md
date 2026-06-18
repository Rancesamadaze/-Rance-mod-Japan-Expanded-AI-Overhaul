# 2.7 error.log 过滤板

来源：`ISSUES/2.7/errorlog shortcut.txt`
采样范围：20:31:42/no_game_date 到 21:02:07/1940.03.21.02

## 过滤结论

- 原始 log 解析出 1756 条 entry，合并后约 132 类。
- 主要噪音是运行期命令刷屏：`gameidler.cpp` 805 条、`session.cpp` 336 条、`scopedvariable.cpp` 304 条。
- 优先处理对象只保留两类：直接指向当前工作区文件的报错；或虽然没有路径但明显由本 mod 自定义字段触发的报错。

## 优先处理

| 优先级 | 数量 | 报错源 | 过滤后问题 | 初步判断 / 下一步 |
| --- | ---: | --- | --- | --- |
| P0 | 8 | `common/game_rules/000_Rance_game_rules.txt:23/43/63/118/138/158/178/198` | 顶层 `desc = ...` 被解析为 `Unexpected token: desc`。 | 当前原版 `00_game_rules.txt` 注释仍提到顶层 `desc`，但实际示例主要把 `desc` 放在 `option/default` 内；本文件所有报错都集中在规则块顶层 `desc`。需要按当前 1.19 实测语法确认是否移除/迁移规则总描述，并同步 `common/game_rules/Game_Rule_Reference/game_rule_authoring_reference.md`。 |
| P0 | 4 | `common/national_focus/japan.txt:1401/1739/1768/2153` | `relative_focus_id` 指向的国策在文件后面才定义，解析时提示目标不存在。 | 不是 id 真缺失，而是解析顺序问题：`JAP_modern_shogunate` 在 2595，`JAP_strengthen_civilian_government` 在 2450，`JAP_support_the_kodoha_faction` 在 2511。需要调整国策块顺序，或把这些节点的 `relative_position_id` 改到已先解析的锚点。 |
| P1 待检验 | 304 | `scopedvariable.cpp:551` | `num_equipment@...`、`num_equipment_in_armies_k@...`、`num_target_equipment_in_armies_k@...` 等动态变量读数使用的 24 个装备 token 未注册为 synchronized dynamic token。 | 已新增 `common/synchronized_dynamic_tokens/JAP_rework_synchronized_dynamic_tokens.txt`，按本次 error.log 实际报出的 24 个 token 补齐；需用新启动 log 验证该类警告是否归零。 |
| P1 | 3 | `common/scripted_effects/JAP_equipment_scripted_effects.txt:3533/4362` | `菊池级`、`吉野级` 的巡洋舰设计模块冲突：安装重巡洋舰炮组 3 时速射炮类模块不可用。 | 需要检查对应船体模块槽，拆开轻巡/重巡火炮路线或换成兼容模块。`菊池级` 同类报错出现 2 次，`吉野级` 1 次。 |
| P1 | 1 | `common/scripted_effects/JAP_equipment_scripted_effects.txt:2003` | `Ki-51 九九袭` 推重不足：`Thrust is lower than weight`。 | 需要调整飞机模块或引擎，避免创建变体时生成无效/低效配置。 |
| P1 | 11 | `common/scripted_effects/JAP_equipment_scripted_effects.txt` 多处 `create_equipment_variant` | 多个机体/船体在未解锁对应 chassis variant 时被创建，游戏提示先解锁科技以避免 bug。 | 受影响样例包括 `Ki-43 一式战“隼”`、`A6M2 零式舰战 “零战”`、`B6N 一式舰攻 “天山”`、`翔鹤级`、`加贺级`、`云仙级`、`风云级`、`伊13`、`伊404`。需要补齐前置科技/特殊项目解锁顺序。 |
| P1 | 1 | `common/decisions/JAP_war_readiness_construction_decisions.txt:1900` | `build_railway` 报 `province 12014 and 12378 are not neighbours`。 | 需要按省份/州参考核对铁路节点链路，改成相邻省份路径或拆成多段。 |
| P2 | 19 | MIO bonus database | `submarine_carrier_size is not found in ai_bonus_weights database`。 | 本 mod 在 MIO 或舰艇模块里使用了 `submarine_carrier_size`。该 key 可能能作为装备 stat，但不被 MIO AI bonus weight 数据库识别；需要确认是否应避免写入 MIO bonus，或接受其不参与 AI 权重。 |
| P2 | 4 | `common/military_industrial_organization/organizations/JAP_organization.txt:282/288/1829/1835` | `三菱社长` advisor trait 出现 remove 时没有、add 时已经有。 | 这类通常是同一 MIO/顾问 trait 切换链重复触发或缺少 guard。需要给 add/remove 加状态判断，或检查前后 trait 是否应为不同 token。 |
| P2 | 5 | `common/scripted_effects/JAP_equipment_scripted_effects.txt:1563/1602/2870/3195` | `complete_special_project` 对已经完成的项目再次执行。 | 多数情况下是低风险噪音；如果脚本频繁重复运行，可以给完成特殊项目效果加 `NOT = { is_special_project_completed = ... }` 之类的前置。 |
| P2 | 1 | `gameapplication.cpp:866` | `The game has loc key collisions. Check logs/text.log for more details`。 | 当前 error.log 只给总提示，真正重复键要去 `logs/text.log` 查；暂不从这份 error.log 继续展开。 |

## 已折叠噪音

| 数量 | 类型 | 处理 |
| ---: | --- | --- |
| 805 | `AI tried to post an invalid command: ...`，其中 `unlock_trait_command` 632、`order_set_invasion_source_command` 136、`merge_navies` 22、`order_assign_command` 15。 | 无脚本源路径，先折叠。若后续查 AI 将领/海军命令异常，可单独按复现时间追踪。 |
| 336 | `Dropped command: ... tick: 65535`。 | 运行期命令丢弃刷屏，无直接文件定位，先折叠。 |
| 304 | `scopedvariable.cpp:551` dynamic token OOS warning。 | 已上移到优先处理并补同步 token 表；保留原始数量，待新 log 验证。 |
| 102 | `interface/armytraittreewindow.gui`、`interface/frontendgamesetupview.gui` 控件缺失。 | 这些文件不在当前 mod 工作区内，先按原版/其他 UI mod 噪音处理；若游戏内对应界面确实坏，再单独追。 |
| 43 | `common/on_actions/14_sea_on_actions.txt`、`common/on_actions/15_mun_on_actions.txt`。 | 文件不在当前 mod 工作区内，先折叠为外部/原版 DLC 噪音。 |
| 42 | `common/characters/FIN.txt:591 has_character_flag Invalid Scope`。 | 芬兰角色文件不在当前 mod 工作区内，先折叠。 |
| 17 | `events/LAR_NewsEvents.txt:251 remove_dynamic_modifier unplanned_offensive`。 | 文件不在当前 mod 工作区内，先折叠。 |
| 10 | `game rules/jp.txt`、`game rules/normal jap.txt`、`game rules/sov.txt` 中 `cjc_*` 规则 id 无效。 | 看起来像本地游戏规则预设/其他 mod 规则残留，不属于当前 mod 源文件。 |
| 5 | `mod/ugc_*.mod` 的 `supported_version` 或 `thumbnail` 报错。 | 创意工坊 descriptor 噪音，不进本 mod 修复队列。 |
| 2 | `gamelobby.cpp` remote file buffer 分配失败。 | 联机/远端文件读取类噪音，非脚本定位入口。 |

## 下一轮建议

1. 用新启动 log 验证 `scopedvariable.cpp:551` 的 24 个 dynamic token warning 是否归零。
2. 再修 `common/game_rules/000_Rance_game_rules.txt` 顶层 `desc` 与 `common/national_focus/japan.txt` 相对定位顺序，这两类都是启动期解析报错。
3. 继续查 `JAP_equipment_scripted_effects.txt` 的无效装备变体；这部分会影响设计生成质量。
4. 最后处理铁路路径、MIO bonus key、顾问 trait 重复切换等低频项。
