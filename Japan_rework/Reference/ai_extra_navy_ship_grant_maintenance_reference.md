# AI 额外海军舰船发放维护参考

本文用于维护日本 AI 动态难度额外舰船发放系统。维护时以当前代码为准；原舰船发放规划已归入本文末尾的“开发归档”。

## 总体链路

海军舰船发放独立于陆空额外装备 60 天循环与陆军编制检查 45 天循环，使用专用启动决议和 180 天 mission。

| 阶段 | 入口 | 职责 | 关键条件 |
| --- | --- | --- | --- |
| 首轮启动 | `JAP_ai_navy_ship_grant_loop_start` | 1939.6.1 当天触发首轮轮转，并启动半年度 mission | `visible` 检查 `Rance_is_jap_ai = yes` 与日期；`available` 只检查 `tag = JAP` 与日期 |
| 半年度轮转 | `JAP_ai_navy_ship_grant_cycle_mission` | 每 180 天 timeout 后尝试结算一次，并自我重启 | mission 层只检查 `tag = JAP` |
| 实际发放 | `JAP_ai_navy_ship_grant_cycle` | 判定是否真的发船，并按动态最终倍率循环调用精确难度包 | 满足 `Rance_is_jap_ai`、海军动态补给规则开启、任一 Rance 难度 |

重要维护原则：

- 决议/mission 层只负责启动和轮转；启动决议的 `visible` 使用 `Rance_is_jap_ai = yes`，让通过开局规则启用日本玩家 AI 作弊的玩家也能启动循环。
- 不要把难度、`rance_japan_ai_navy_dynamic_supply` 等发放限制放进决议/mission 层。
- 海军动态补给规则关闭时，不应打断 180 天读条；只应让当次 `JAP_ai_navy_ship_grant_cycle` 不实际发船。
- 不接入陆空额外装备 60 天循环，也不接入陆军编制检查 45 天循环。
- 不在决议、mission 或发放 guard 中加入战争状态保护；战争状态只参与共享动态倍率刷新。
- 当前不设置舰队数量上限，只记录循环次数和包发放次数。

## 文件索引

| 内容 | 文件 |
| --- | --- |
| 决议/mission 接入 | `common/decisions/JAP_rework_equipment_design_decision.txt` |
| 共享动态倍率刷新 | `common/scripted_effects/JAP_ai_general_scripted_effects.txt`、`common/on_actions/JAP_rework_focus_on_actions.txt` |
| Boss 模式与海军动态补给规则 | `common/game_rules/000_Rance_game_rules.txt`、`localisation/simp_chinese/Rance_game_rules_l_simp_chinese.yml` |
| 单舰 helper、批量 helper、包、难度入口 | `common/scripted_effects/JAP_ai_navy_ship_grant_scripted_effects.txt` |
| 舰船设计效果与设计 flag | `common/scripted_effects/JAP_equipment_scripted_effects.txt` |
| 舰船发放用 scripted localisation | `common/scripted_localisation/JAP_ai_navy_ship_grant_scripted_loc.txt` |
| 舰船发放用动态船体/型号本地化 | `localisation/simp_chinese/JAP_ai_navy_ship_grant_l_simp_chinese.yml` |
| 决议名称与说明 | `localisation/simp_chinese/JAP_decisions_l_simp_chinese.yml` |
| 需求来源 | `common/ai_navy/taskforce/JAP_taskforce_templates.txt` |
| 型号池与 AI role 参考 | `common/ai_equipment/JAP_naval.txt` |

## 决议与轮转

`JAP_ai_navy_ship_grant_loop_start`：

- `visible` 保留 `Rance_is_jap_ai = yes` 和 `date > 1939.5.31`，让满足日本 AI 辅助判定的玩家也能看到启动决议。
- `available` 只保留 `tag = JAP` 和 `date > 1939.5.31`。
- `complete_effect` 先调用 `JAP_ai_navy_ship_grant_cycle = yes`，再 `activate_mission = JAP_ai_navy_ship_grant_cycle_mission`。
- `fire_only_once = yes`。

`JAP_ai_navy_ship_grant_cycle_mission`：

- `days_mission_timeout = 180`。
- `available = { hidden_trigger = { always = no } }`，由启动决议或自我重启激活。
- `visible` 只保留 `tag = JAP`。
- `timeout_effect` 调用 `JAP_ai_navy_ship_grant_cycle = yes` 后自我重启。

不要在启动决议 `available` 或半年度 mission 中加入：

- `Rance_is_jap_ai = yes`
- `Rance_nd_is_*`
- `Rance_nd_more_than_*`
- `rance_japan_ai_navy_dynamic_supply`
- `has_war` / `has_offensive_war` / `any_enemy_country`
- `has_navy_size` / `num_ships_with_type@...`

## 发放入口

`JAP_ai_navy_ship_grant_cycle` 是实际发船 guard：

```txt
if = {
    limit = {
        tag = JAP
        Rance_is_jap_ai = yes
        has_game_rule = {
            rule = rance_japan_ai_navy_dynamic_supply
            option = ENABLED
        }
        OR = {
            Rance_nd_is_easy = yes
            Rance_nd_is_normal = yes
            Rance_nd_is_hard = yes
            Rance_nd_is_lunatic = yes
            Rance_nd_is_extra = yes
            Rance_nd_is_phantasm = yes
        }
    }
    JAP_ai_navy_grant_yearly_packages_by_difficulty = yes
}
```

难度使用精确判定，不使用不等判定。`EASY` 现在有轻量发放分支。

`JAP_ai_navy_grant_yearly_packages_by_difficulty` 是动态倍率 wrapper；它按 `JAP_ai_dynamic_final_multiplier` 循环调用单轮效果 `JAP_ai_navy_grant_yearly_packages_by_difficulty_single`。海军不单独读取 Boss 变量，避免 Boss 额外加值为 0 时影响半年度发船兜底。

共享动态倍率由 `JAP_ai_dynamic_grant_refresh_multipliers` 每月刷新一次：

| 变量 | 含义 |
| --- | --- |
| `JAP_ai_dynamic_base_multiplier` | 战况基础倍率：和平 1，战争 2，战争中且日本投降进度大于 5% 为 3 |
| `JAP_ai_boss_bonus_multiplier` | Boss 模式额外加值：规则关闭为 0；规则开启后只按敌方玩家/主要国家 AI 累加 |
| `JAP_ai_dynamic_final_multiplier` | 最终倍率，等于基础倍率 + Boss 额外加值；海军、陆军、空军都只读取该变量 |

## 半年度难度包

各难度分支写完整调用清单，维护时不要改成“低难度 + 高难度追加”的叠加写法。当前周期为 180 天；年化数量约为表内半年度数量的两倍，再乘动态最终倍率。

| 难度 | 180 天调用包 | 半年度舰数 | 年化舰数（倍率 1） |
| --- | --- | ---: | ---: |
| `EASY` | `sub_raiding` x1；`surface_small_fleet` x1 | 20 | 40 |
| `NORMAL` | `sub_raiding` x2；`surface_small_fleet` x2；驱逐屏卫 x1；轻巡屏卫 x1 | 75 | 150 |
| `HARD` | `sub_raiding` x2；`surface_small_fleet` x2；`kido_butai` x1；驱逐屏卫 x1；轻巡屏卫 x1 | 113 | 226 |
| `LUNATIC` | `sub_raiding` x2；`surface_small_fleet` x2；`kido_butai` x1；`mega_kido_butai` x1；驱逐屏卫 x2；轻巡屏卫 x1 | 183 | 366 |
| `EXTRA` | `sub_raiding` x2；`surface_small_fleet` x2；`kido_butai` x1；`mega_kido_butai` x1；驱逐屏卫 x3；轻巡屏卫 x2 | 218 | 436 |
| `PHANTASM` | `sub_raiding` x2；`surface_small_fleet` x2；`kido_butai` x1；`mega_kido_butai` x1；驱逐屏卫 x4；轻巡屏卫 x3 | 253 | 506 |

## 发放包内容

| 包 | 内容 |
| --- | --- |
| `JAP_ai_navy_pkg_kido_butai` | 正规航母 2、标准战列舰 2、超重战列舰 1、重雷装巡洋舰 3、特遣轻巡 10、肉盾轻巡 5、雷击驱逐 15；额外舰载机支援 |
| `JAP_ai_navy_pkg_mega_kido_butai` | 冰航母 1、超重战列舰 5、重雷装巡洋舰 4、特遣轻巡 14、肉盾轻巡 6、雷击驱逐 20；额外空军支援 |
| `JAP_ai_navy_pkg_surface_small_fleet` | 护航航母 1、标准重巡 1、袭击轻巡 2、雷击驱逐 3、护航驱逐 3；额外舰载机支援 |
| `JAP_ai_navy_pkg_sub_raiding` | 常规潜艇 6、潜水空母 4；潜水空母未解锁时不回填常规潜艇 |
| `JAP_ai_navy_pkg_extra_destroyer_screen_batch` | 雷击驱逐 20 |
| `JAP_ai_navy_pkg_extra_light_cruiser_screen_batch` | 特遣轻巡 10、肉盾轻巡 5 |

`Rance_JAP_PatrolDominanceForce` 与 `Rance_JAP_KidoButai` 内容重合，不单独做包。

`Rance_JAP_PatrolReconForce` 只需要 1 艘巡逻轻巡，不做免费舰船包。

`Rance_JAP_ConvoySurfaceRaiding` 与 `Rance_JAP_ConvoyEscort` 合并为 `JAP_ai_navy_pkg_surface_small_fleet`。

## 普通机动部队舰载机附加

`JAP_ai_navy_pkg_kido_butai` 调用 `JAP_ai_navy_grant_kido_butai_carrier_air_support`，额外给：

- 舰载战斗机 200：`JAP_ai_extra_air_equipment_grant_cv_fighter_unit` x2。
- 舰载海军轰炸机 200：`JAP_ai_extra_air_equipment_grant_cv_naval_bomber_unit` x2。

该 helper 调用空军最小装备效果前保留设计存在性 guard：

- 舰载战斗机：`JAP_has_cr_cv_small_plane_airframe_1/2/3/4` 任一存在。
- 舰载海军轰炸机：`JAP_has_cr_cv_small_plane_naval_bomber_airframe_1/2/3/4` 任一存在。

## 护航航母舰载机附加

`JAP_ai_navy_pkg_surface_small_fleet` 调用 `JAP_ai_navy_grant_surface_small_fleet_carrier_air_support`，按每包 1 艘护航航母额外给：

- 舰载战斗机 100。
- 舰载海军轰炸机 100。

该 helper 调用空军最小装备效果前保留 guard：

- 护航航母设计：`JAP_has_cr_ship_design_cv_ryujo/zuiho/ryuho` 任一存在。
- 舰载战斗机：`JAP_has_cr_cv_small_plane_airframe_1/2/3/4` 任一存在。
- 舰载海军轰炸机：`JAP_has_cr_cv_small_plane_naval_bomber_airframe_1/2/3/4` 任一存在。

## Mega 空军附加

`JAP_ai_navy_pkg_mega_kido_butai` 调用 `JAP_ai_navy_grant_mega_kido_butai_air_support`，额外给：

- 海军巡逻轰炸机约 100：`JAP_ai_extra_air_equipment_grant_maritime_patrol_plane_unit` x2。
- 空天母舰约 100：`JAP_ai_extra_air_equipment_grant_mothership_unit` x2。

空军最小装备效果本身没有设计存在性 guard，因此海军 mega 包内必须保留 guard：

- 海军巡逻轰炸机：`JAP_has_cr_large_plane_maritime_patrol_plane_airframe_2/3/4` 任一存在。
- 空天母舰：`JAP_has_cr_mothership_equipment_0` 存在。

## 单舰创建链

单舰 helper 使用：

```txt
meta_effect = {
    text = {
        create_ship = {
            type = ship_hull_*_[JAP_ai_navy_text_*_hull]
            equipment_variant = "[JAP_ai_navy_text_*_variant]"
            creator = ROOT
        }
    }
    JAP_ai_navy_text_*_hull = "[GetJAP_ai_navy_*_hull]"
    JAP_ai_navy_text_*_variant = "[GetJAP_ai_navy_*_variant]"
}
```

维护规则：

- 单舰 helper 必须先检查对应 `JAP_has_cr_ship_design_*` flag。
- `create_ship` 不支持 `amount`，批量必须用 `while_loop_effect` 多次调用单舰 helper。
- 新舰种要同步四处：设计效果设置 flag、单舰 helper guard、scripted localisation 选船体/型号、中文本地化 key。
- 普通轻巡使用 `ship_hull_cruiser_[suffix]`，驱逐使用 `ship_hull_light_[suffix]`。
- 自定义舰体通常使用 `ship_hull_[suffix]`，例如 `mega_carrier`、`escort_carrier`、`torpedo_cruiser`、`carrier_submarine`。

## 抽样链路检查

当前抽样静态检查通过以下型号链路：

| 型号 | flag | helper | 拼出舰体 key |
| --- | --- | --- | --- |
| 白龙级正规航母 | `JAP_has_cr_ship_design_cv_hakuryu` | `JAP_ai_navy_create_one_formal_carrier` | `ship_hull_carrier_modern` |
| 雪凤级冰航母 | `JAP_has_cr_ship_design_cv_yukihou` | `JAP_ai_navy_create_one_mega_carrier` | `ship_hull_mega_carrier` |
| 瑞凤级护航航母 | `JAP_has_cr_ship_design_cv_zuiho` | `JAP_ai_navy_create_one_escort_carrier` | `ship_hull_escort_carrier` |
| 大井级重雷巡 | `JAP_has_cr_ship_design_clt_ooi` | `JAP_ai_navy_create_one_torpedo_cruiser` | `ship_hull_torpedo_cruiser` |
| 能代级特遣轻巡 | `JAP_has_cr_ship_design_cl_noshiro` | `JAP_ai_navy_create_one_task_light_cruiser` | `ship_hull_cruiser_4` |
| 汐风级雷击驱逐 | `JAP_has_cr_ship_design_dd_shiokaze` | `JAP_ai_navy_create_one_strike_destroyer` | `ship_hull_light_4` |
| 伊404潜水空母 | `JAP_has_cr_ship_design_ss_i404` | `JAP_ai_navy_create_one_carrier_submarine` | `ship_hull_carrier_submarine` |

检查项包括：

- 设计效果设置对应 `JAP_has_cr_ship_design_*` flag。
- 单舰 helper 用同一 flag 做 guard。
- 单舰 helper 调用对应 `GetJAP_ai_navy_*_hull` 与 `GetJAP_ai_navy_*_variant`。
- scripted localisation 用同一 flag 选择船体后缀和型号本地化 key。
- 本地化文件存在对应船体后缀和型号 key。
- 拼出的舰体 key 在本 MOD 或原版装备定义中存在。

## 变量

当前只用于观察和调参，不作为数量上限：

| 变量 | 用途 |
| --- | --- |
| `JAP_ai_dynamic_base_multiplier` | 战况基础倍率 |
| `JAP_ai_boss_bonus_multiplier` | Boss 模式额外加值 |
| `JAP_ai_dynamic_final_multiplier` | 半年度发船 wrapper 实际读取的最终循环次数 |
| `JAP_ai_navy_free_ship_cycle_count` | 半年度发船循环结算次数 |
| `JAP_ai_navy_granted_kido_butai_packages` | 机动部队包发放次数 |
| `JAP_ai_navy_granted_mega_kido_butai_packages` | 巨型机动部队包发放次数 |
| `JAP_ai_navy_granted_surface_small_fleet_packages` | 水面小舰队包发放次数 |
| `JAP_ai_navy_granted_destroyer_screen_batches` | 额外驱逐屏卫包发放次数 |
| `JAP_ai_navy_granted_light_cruiser_screen_batches` | 额外轻巡屏卫包发放次数 |
| `JAP_ai_navy_granted_sub_raiding_packages` | 潜艇破交包发放次数 |

## 验证清单

维护后建议至少检查：

```powershell
rg -n "JAP_ai_navy_ship_grant_loop_start|JAP_ai_navy_ship_grant_cycle_mission" common/decisions localisation/simp_chinese
rg -n "Rance_nd_more_than|has_navy_size|num_ships_with_type" common/decisions/JAP_rework_equipment_design_decision.txt common/scripted_effects/JAP_ai_navy_ship_grant_scripted_effects.txt
rg -n "amount\\s*=" common/scripted_effects/JAP_ai_navy_ship_grant_scripted_effects.txt
```

还要检查：

- `common/decisions/JAP_rework_equipment_design_decision.txt` 与 `common/scripted_effects/JAP_ai_navy_ship_grant_scripted_effects.txt` 括号平衡。
- 新增 scripted localisation 函数都有本地化 key。
- 新增本地化文件为 UTF-8 with BOM；脚本与参考文件为 UTF-8 without BOM。
- 新的动态舰体 key 能在本 MOD 或原版 `common/units/equipment/` 找到。
## 开发归档

> 归档时间：2026-05-22。以下内容从 `CHANGELOG` 迁入 `Reference`，用于保留设计背景、调参依据和已完成/待办记录。日常维护优先参考本文前面的维护索引。
### 来源：`CHANGELOG/ai_extra_navy_ship_grant_plan.md`

注意：以下为 2026-05-22 年度旧方案归档，数字和周期不代表当前半年度实现；维护当前实现以前文为准。

### 日本 AI 动态免费舰船系统计划

> 维护源已整理至 `Reference/ai_extra_navy_ship_grant_maintenance_reference.md`。本文保留为海军额外舰船发放的规划归档；后续调参、增删舰种和排查引用时优先更新 Reference 文档。

#### 当前结论

- 系统独立于陆空军 45 天循环，使用海军专用 mission、变量和发放包。
- 需求来源只看 `common/ai_navy/taskforce/JAP_taskforce_templates.txt`；不把海军 goal 和 fleet template 层纳入发放包设计。
- 采用单包简化路线：核心特遣舰队需求对应固定包，难度只影响是否调用、调用节奏或调用次数。
- `EASY` 难度不发放免费舰船。
- 海军发船决议 `JAP_ai_navy_ship_grant_loop_start` 在 1939.6.1 当天触发首轮轮转，随后由 `JAP_ai_navy_ship_grant_cycle_mission` 每 365 天循环。
- 决议/mission 层只负责启动和轮转；启动决议 `visible` 使用 `Rance_is_jap_ai = yes`，但不把难度、海军动态补给规则等发放限制放进决议条件。实际发放限制统一放在 `JAP_ai_navy_ship_grant_cycle` 内，避免规则关闭时打断读条。
- `Rance_JAP_PatrolDominanceForce` 和 `Rance_JAP_KidoButai` 发放内容完全重合，只保留 `JAP_ai_navy_pkg_kido_butai`，不单独做巡逻制海包。
- `Rance_JAP_PatrolReconForce` 只需要 1 艘巡逻轻巡，不做免费舰船发放包。
- `Rance_JAP_ConvoySurfaceRaiding` 和 `Rance_JAP_ConvoyEscort` 绑定成一个“水面小舰队”包发放。
- 潜艇破交包规模扩大一倍。
- `JAP_ai_navy_pkg_kido_butai` 调用时额外发放 400 架舰载战斗机和 400 架舰载海军轰炸机；调用空军最小效果前必须在海军包内补 guard。
- `JAP_ai_navy_pkg_surface_small_fleet` 调用时额外发放 100 架舰载战斗机和 100 架舰载海军轰炸机，即平均每艘护航航母 50 + 50；调用空军最小效果前必须在海军包内补 guard。
- `JAP_ai_navy_pkg_mega_kido_butai` 调用时额外发放约 200 架海军巡逻轰炸机和 200 架空天母舰；调用空军最小效果前必须在海军包内补 guard。
- role 没锁或 role 含义过宽的位置已经敲定固定比例，后续实现不再拆多难度版本。
- 可以额外准备驱逐舰、轻巡屏卫批量包，用于补齐主力舰队屏卫。
- 当前实现改为海军动态补给开局规则 `rance_japan_ai_navy_dynamic_supply`；不加入战争状态保护。
- 数量上限暂不设定；当前只记录年度循环和各包发放次数。
- `num_ships_with_type@...` 和 `has_navy_size` 追踪舰种/舰体分类，不追踪 `JAP_naval.txt` 里的自定义 AI role。
- 赤城级 debug 测试确认 `meta_effect + scripted localisation + create_ship` 可用。
- `create_ship amount = 5` 实测非法；批量造船必须用 `while_loop_effect` 多次调用单舰 helper。

#### 输入文件

| 文件 | 用途 |
| --- | --- |
| `common/ai_navy/taskforce/JAP_taskforce_templates.txt` | 唯一舰队需求来源。 |
| `common/ai_equipment/JAP_naval.txt` | 设计型号池与 AI role 参考。 |
| `common/scripted_effects/JAP_equipment_scripted_effects.txt` | 舰船变体名、舰体类型、`role_icon_index` 来源。 |
| `common/scripted_localisation/JAP_equipment_scripted_loc.txt` | 最高代舰体动态选择参考。 |
| `common/scripted_effects/JAP_debug_scripted_effects.txt` | 已验证的赤城级 `meta_effect` 测试样板。 |
| `Reference/route_difficulty_scripted_trigger.md` | 难度触发参考。 |
| `Reference/variable_syntax_reference.md` | 变量、临时变量、循环写法参考。 |

#### 固定发放包

所有主包按 taskforce 模板最大/optimal 编制确定。包内容固定，不再拆 `normal`、`hard`、`phantasm` 等多难度版本。

| 发放包 | 模板 / mission | 固定组成 |
| --- | --- | --- |
| `JAP_ai_navy_pkg_kido_butai` | `Rance_JAP_KidoButai` / `naval_strike` | 正规航母 4、标准战列舰 4、超重战列舰 2、重雷装巡洋舰 5、特遣轻巡 20、肉盾轻巡 10、雷击驱逐 30；额外舰载机支援：舰载战斗机 400、舰载海军轰炸机 400 |
| `JAP_ai_navy_pkg_mega_kido_butai` | `Rance_JAP_mega_KidoButai` / `naval_strike` | 冰航母 2、超重战列舰 10、重雷装巡洋舰 8、特遣轻巡 28、肉盾轻巡 12、雷击驱逐 40；额外空军支援：海军巡逻轰炸机约 200、空天母舰约 200 |
| `JAP_ai_navy_pkg_surface_small_fleet` | `Rance_JAP_ConvoySurfaceRaiding` / `convoy_raiding` + `Rance_JAP_ConvoyEscort` / `convoy_escort` | 护航航母 2、标准重巡 2、袭击轻巡 4、雷击驱逐 6、护航驱逐 6；额外舰载机支援：舰载战斗机 100、舰载海军轰炸机 100 |
| `JAP_ai_navy_pkg_sub_raiding` | `Rance_JAP_Sub_Raiding_Force` / `convoy_raiding` | 常规潜艇 12、潜水空母 8；潜水空母未解锁时只创建常规潜艇部分 |

说明：`Rance_JAP_PatrolDominanceForce` 的需求与 `Rance_JAP_KidoButai` 完全重合，正式发船时由 `JAP_ai_navy_pkg_kido_butai` 覆盖，不设置独立包、不设置独立计数变量。
`Rance_JAP_PatrolReconForce` 只需 1 艘巡逻轻巡，正式发船不为它设置独立包，交给正常造舰体系补齐。
`Rance_JAP_ConvoySurfaceRaiding` 和 `Rance_JAP_ConvoyEscort` 不再拆成两个独立小包，正式发船时统一由 `JAP_ai_navy_pkg_surface_small_fleet` 覆盖。

#### 固定比例说明

以下比例已经敲定，正式 helper 按这些数量拆批量调用。

| 模板位置 | 固定处理 |
| --- | --- |
| 普通主力/巡逻制海战列舰 | 4 艘标准战列舰 + 2 艘超重战列舰。 |
| 巨型机动部队战列舰 | 10 艘全部使用超重战列舰。 |
| role 1 轻巡 | 输出优先：普通主力包 20 特遣轻巡 + 10 肉盾轻巡；巨型包 28 特遣轻巡 + 12 肉盾轻巡。 |
| 通用驱逐 | 全部使用雷击驱逐。 |
| 水面小舰队包 | 护航航母、标准重巡、袭击轻巡合并发放；驱逐部分保留 6 艘雷击驱逐 + 6 艘护航驱逐。 |
| 潜艇包 | 12 艘常规潜艇 + 8 艘潜水空母；潜水空母未解锁时不回填常规潜艇。 |

#### 普通机动部队舰载机附加发放

`JAP_ai_navy_pkg_kido_butai` 除舰船外额外调用现有空军最小装备效果，作为正规航母舰载机补贴。

目标数量：

| 装备 | 数量 | 调用方式 |
| --- | ---: | --- |
| 舰载战斗机 | 400 | `JAP_ai_extra_air_equipment_grant_cv_fighter_unit` 调用 4 次，每次 100。 |
| 舰载海军轰炸机 | 400 | `JAP_ai_extra_air_equipment_grant_cv_naval_bomber_unit` 调用 4 次，每次 100。 |

注意：空军最小装备效果本身不负责设计存在性 guard。海军普通机动部队包不能裸调最小效果，必须复刻或封装对应舰载机设计 flag 条件。

#### 护航航母舰载机附加发放

`JAP_ai_navy_pkg_surface_small_fleet` 除舰船外额外调用现有空军最小装备效果，作为护航航母舰载机补贴。

目标数量：

| 装备 | 数量 | 调用方式 |
| --- | ---: | --- |
| 舰载战斗机 | 100 | `JAP_ai_extra_air_equipment_grant_cv_fighter_unit` 调用 1 次，每次 100；平均每艘护航航母 50。 |
| 舰载海军轰炸机 | 100 | `JAP_ai_extra_air_equipment_grant_cv_naval_bomber_unit` 调用 1 次，每次 100；平均每艘护航航母 50。 |

注意：空军最小装备效果本身不负责设计存在性 guard。海军水面小舰队包不能裸调最小效果，必须复刻或封装对应护航航母设计 flag 与舰载机设计 flag 条件。

#### 巨型机动部队空军附加发放

`JAP_ai_navy_pkg_mega_kido_butai` 除舰船外额外调用现有空军最小装备效果，作为巨型机动部队的远洋侦察与特殊航空支援。

目标数量：

| 装备 | 数量 | 调用方式 |
| --- | ---: | --- |
| 海军巡逻轰炸机 | 约 200 | `JAP_ai_extra_air_equipment_grant_maritime_patrol_plane_unit` 调用 4 次，每次 50。 |
| 空天母舰 | 约 200 | `JAP_ai_extra_air_equipment_grant_mothership_unit` 调用 4 次，每次 50。 |

注意：空军最小装备效果本身不负责设计存在性 guard。当前 guard 写在 `JAP_ai_extra_air_equipment_grant_total_package` 内部。海军 mega 包不能裸调最小效果，必须复刻或封装以下条件：

```txt
if = {
    limit = {
        OR = {
            has_country_flag = JAP_has_cr_large_plane_maritime_patrol_plane_airframe_2
            has_country_flag = JAP_has_cr_large_plane_maritime_patrol_plane_airframe_3
            has_country_flag = JAP_has_cr_large_plane_maritime_patrol_plane_airframe_4
        }
    }
    JAP_ai_extra_air_equipment_grant_maritime_patrol_plane_unit = yes
    JAP_ai_extra_air_equipment_grant_maritime_patrol_plane_unit = yes
    JAP_ai_extra_air_equipment_grant_maritime_patrol_plane_unit = yes
    JAP_ai_extra_air_equipment_grant_maritime_patrol_plane_unit = yes
}

if = {
    limit = { has_country_flag = JAP_has_cr_mothership_equipment_0 }
    JAP_ai_extra_air_equipment_grant_mothership_unit = yes
    JAP_ai_extra_air_equipment_grant_mothership_unit = yes
    JAP_ai_extra_air_equipment_grant_mothership_unit = yes
    JAP_ai_extra_air_equipment_grant_mothership_unit = yes
}
```

#### 难度策略

本系统采用单包简化路线。难度不改变包内型号比例，只改变是否调用和调用次数。

- `EASY`：不调用任何免费舰船发放包。
- `NORMAL` 及以上：按下表的精确难度清单调用海军发船包。
- 发船入口使用独立海军决议/mission，不接入陆空军 45 天循环。
- 决议冷却 365 天。
- 首次可用日期为 1939.6.1 当天。
- 365 天 mission 只负责轮转；`Rance_is_jap_ai`、非 `EASY` 精确难度和海军动态补给规则只在 `JAP_ai_navy_ship_grant_cycle` 内判定。例外：当前实现允许满足 `Rance_is_jap_ai` 的玩家从启动决议进入海军动态补给循环。
- 后续落地为了维护清晰，不写成“低难度包 + 高难度追加包”的叠加调用；每个精确难度分支都直接写完整包清单。

| 难度 | 年度调用包清单 |
| --- | --- |
| `EASY` | 不发船 |
| `NORMAL` | `JAP_ai_navy_pkg_sub_raiding` x4；`JAP_ai_navy_pkg_surface_small_fleet` x4；`JAP_ai_navy_pkg_extra_destroyer_screen_batch` x1；`JAP_ai_navy_pkg_extra_light_cruiser_screen_batch` x1 |
| `HARD` | `JAP_ai_navy_pkg_sub_raiding` x4；`JAP_ai_navy_pkg_surface_small_fleet` x4；`JAP_ai_navy_pkg_kido_butai` x1；`JAP_ai_navy_pkg_extra_destroyer_screen_batch` x1；`JAP_ai_navy_pkg_extra_light_cruiser_screen_batch` x1 |
| `LUNATIC` | `JAP_ai_navy_pkg_sub_raiding` x4；`JAP_ai_navy_pkg_surface_small_fleet` x4；`JAP_ai_navy_pkg_kido_butai` x1；`JAP_ai_navy_pkg_mega_kido_butai` x1；`JAP_ai_navy_pkg_extra_destroyer_screen_batch` x2；`JAP_ai_navy_pkg_extra_light_cruiser_screen_batch` x1 |
| `EXTRA` | `JAP_ai_navy_pkg_sub_raiding` x4；`JAP_ai_navy_pkg_surface_small_fleet` x4；`JAP_ai_navy_pkg_kido_butai` x1；`JAP_ai_navy_pkg_mega_kido_butai` x1；`JAP_ai_navy_pkg_extra_destroyer_screen_batch` x3；`JAP_ai_navy_pkg_extra_light_cruiser_screen_batch` x2 |
| `PHANTASM` | `JAP_ai_navy_pkg_sub_raiding` x4；`JAP_ai_navy_pkg_surface_small_fleet` x4；`JAP_ai_navy_pkg_kido_butai` x1；`JAP_ai_navy_pkg_mega_kido_butai` x1；`JAP_ai_navy_pkg_extra_destroyer_screen_batch` x4；`JAP_ai_navy_pkg_extra_light_cruiser_screen_batch` x3 |

#### 备用屏卫批量包

备用包不对应独立 taskforce 模板，只用于补齐主力舰队屏卫缺口。

| 备用包 | 内容 | 用途 |
| --- | --- | --- |
| `JAP_ai_navy_pkg_extra_destroyer_screen_batch` | 雷击驱逐 40 | 补主力舰队驱逐屏卫数量。 |
| `JAP_ai_navy_pkg_extra_light_cruiser_screen_batch` | 特遣轻巡 20 + 肉盾轻巡 10 | 按输出优先比例补主力舰队 role 1 轻巡。 |

#### 发放保护

总开关：

```txt
has_game_rule = {
    rule = rance_japan_ai_navy_dynamic_supply
    option = ENABLED
}
```

可选海军专用开关：

```txt
NOT = { has_country_flag = JAP_ai_extra_navy_ship_grant_disabled }
```

不加入战争状态保护。不要用 `has_war`、`has_offensive_war`、`any_enemy_country` 等战争判断开关发放。

过量保护暂不落地：

- 本阶段不使用 `has_navy_size` 或 `num_ships_with_type@...` 设置舰队数量上限。
- 当前只自建变量记录已经发过哪些包，便于之后观察和调参。

查证结论：

- `num_ships_with_type@carrier` 统计国家控制舰船的 sub-unit definition 或 broad category，例如 `carrier`、`capital`、`screen`、`submarine`。
- `has_navy_size` 可按 `type`、`archetype`、`unit` 或总数检查，例如 `unit = heavy_cruiser`、`archetype = ship_hull_light`。
- 这些类型都不是 `JAP_naval.txt` 的具名 AI role，也不是舰船变体的 `role_icon_index`。

建议变量：

| 变量 | 用途 |
| --- | --- |
| `JAP_ai_navy_free_ship_cycle_count` | 独立海军发船循环计数。 |
| `JAP_ai_navy_granted_kido_butai_packages` | 机动部队包发放次数。 |
| `JAP_ai_navy_granted_mega_kido_butai_packages` | 巨型机动部队包发放次数。 |
| `JAP_ai_navy_granted_surface_small_fleet_packages` | 水面小舰队包发放次数。 |
| `JAP_ai_navy_granted_destroyer_screen_batches` | 额外驱逐屏卫包发放次数。 |
| `JAP_ai_navy_granted_light_cruiser_screen_batches` | 额外轻巡屏卫包发放次数。 |
| `JAP_ai_navy_granted_sub_raiding_packages` | 潜艇破交包发放次数。 |

#### 脚本实现规格

##### 单舰 helper

正式实现优先使用已验证的 `meta_effect + scripted localisation + create_ship`。单舰 helper 不使用 `amount`。

```txt
JAP_ai_navy_create_one_formal_carrier = {
    meta_effect = {
        text = {
            create_ship = {
                type = ship_hull_carrier_[JAP_ai_navy_text_carrier_hull]
                equipment_variant = "[JAP_ai_navy_text_carrier_variant]"
                creator = ROOT
            }
        }
        JAP_ai_navy_text_carrier_hull = "[GetJAP_cr_ship_hull_carrier]"
        JAP_ai_navy_text_carrier_variant = "[GetJAP_ai_navy_carrier_variant]"
    }
}
```

如果某个自定义舰体无法用 meta 可靠创建，再对该舰体退回显式 `if/else_if` 分支。

##### 批量 helper

批量创建必须用 `while_loop_effect` 多次调用单舰 helper。

```txt
JAP_ai_navy_create_destroyer_batch_30 = {
    set_temp_variable = { JAP_temp_ship_loop = 0 }
    while_loop_effect = {
        limit = {
            check_variable = { JAP_temp_ship_loop < 30 }
        }
        JAP_ai_navy_create_one_screen_destroyer = yes
        add_to_temp_variable = { JAP_temp_ship_loop = 1 }
    }
}
```

##### 完整包 helper

完整包只负责组合单舰/批量 helper，并在末尾记录发放次数。

```txt
JAP_ai_navy_pkg_kido_butai = {
    JAP_ai_navy_create_formal_carrier_batch_4 = yes
    JAP_ai_navy_create_standard_battleship_batch_4 = yes
    JAP_ai_navy_create_super_heavy_battleship_batch_2 = yes
    JAP_ai_navy_create_torpedo_cruiser_batch_5 = yes
    JAP_ai_navy_create_task_light_cruiser_batch_20 = yes
    JAP_ai_navy_create_shield_light_cruiser_batch_10 = yes
    JAP_ai_navy_create_strike_destroyer_batch_30 = yes
    add_to_variable = { JAP_ai_navy_granted_kido_butai_packages = 1 }
}
```

#### 实施顺序

当前落地进度：第 1-5 步已完成，且已补完脚本本地化、船体/型号动态选择、单舰 helper、批量 helper、完整包 helper、精确难度年度入口、AI 决议/mission 接入及其本地化。

1. 已完成：新建海军专用 scripted effects 文件。
2. 已完成：写单舰 helper，先覆盖赤城级已验证的正规航母链，再扩展其他舰种。
3. 已完成：写批量 helper，统一使用 `while_loop_effect`。
4. 已完成：写完整特遣舰队包；已敲定的固定比例直接拆成批量 helper。
5. 已完成：新建独立海军发船 decision/mission，365 天冷却，1939.6.1 当天首次可用，周期不接入陆空军 45 天循环。
6. 已完成：加入总开关和包计数变量，不加入战争状态保护；数量上限暂不设定。
7. 游戏内测试自定义舰体兼容性，重点是冰航母、护航航母、重雷巡、潜水空母。
8. 根据测试结果调整 mission 调用节奏；若之后观察到明显过量，再另行讨论数量上限。

#### 查证记录

- 本地随游戏附带文档：`documentation/effects_documentation.md` 记录 `create_ship`、`meta_effect`、`while_loop_effect`。
- 本地随游戏附带文档：`documentation/dynamic_variables_documentation.md` 记录 `num_ships_with_type` 统计舰船 sub-unit definition 或 broad category。
- 本地随游戏附带文档：`documentation/triggers_documentation.md` 记录 `has_navy_size` 可按 `type`、`archetype`、`unit` 或总数检查。
- 原版脚本：多个国家 scripted effects 使用 `create_ship`；原版 `common/ai_strategy/USA.txt` 使用 `num_ships_with_type@carrier`。
- 本 MOD 赤城级 debug 测试：`meta_effect + scripted localisation + create_ship` 可用；`create_ship amount = 5` 非法。
- 官方 Paradox wiki 的 `Commands` / `Variables` 页面在当前网页工具中被 JS challenge 拦截；搜索索引可见 `create_ship` 词条，但精确正文仍建议之后人工打开页面复核。
