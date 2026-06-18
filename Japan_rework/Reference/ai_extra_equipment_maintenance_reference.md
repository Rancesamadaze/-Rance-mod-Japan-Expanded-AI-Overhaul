# AI 额外装备发放维护参考

本文用于维护日本 AI 动态难度额外装备发放系统。维护时以当前代码为准；原陆军与空军规划已归入本文末尾的“开发归档”。

## 总体链路

额外装备发放分为开局补给和 60 天陆空独立循环两部分：

| 阶段 | 入口 | 触发条件 | 内容 |
| --- | --- | --- | --- |
| 60 天循环启动前 | `JAP_ai_opening_equipment_resupply` | 满足 `Rance_is_jap_ai`、开局步兵/实验装甲阶段、陆空动态补给规则开启 | 填线步兵包 + 100 轻战 + 50 CAS |
| 60 天陆空循环 | `JAP_ai_extra_equipment_grant_cycle_mission` | 满足 `Rance_is_jap_ai`、陆空动态补给规则开启 | 按动态最终倍率循环结算陆军额外装备 + 空军额外装备 |

陆空动态补给规则：

```txt
has_game_rule = {
    rule = rance_japan_ai_land_air_dynamic_supply
    option = ENABLED
}
```

开局规则关闭后，开局补给和 60 天陆空循环中的额外发放都会停止。旧版运行中 country flag 开关已废弃。

## 文件索引

| 内容 | 主要文件 |
| --- | --- |
| 数量变量初始化 | `history/countries/JAP - Japan.txt` |
| 动态倍率刷新 | `common/scripted_effects/JAP_ai_general_scripted_effects.txt`、`common/on_actions/JAP_rework_focus_on_actions.txt` |
| Boss 模式与陆空动态补给规则 | `common/game_rules/000_Rance_game_rules.txt`、`localisation/simp_chinese/Rance_game_rules_l_simp_chinese.yml` |
| 开局补给决议 | `common/decisions/JAP_rework_ai_decision.txt` |
| 60 天陆空循环接入 | `common/decisions/JAP_rework_equipment_design_decision.txt` |
| 单装备效果、包组、倍率入口 | `common/scripted_effects/JAP_equipment_scripted_effects.txt` |
| 动态型号后缀 | `common/scripted_localisation/JAP_equipment_scripted_loc.txt` |
| 决议名称与说明 | `localisation/simp_chinese/JAP_decisions_l_simp_chinese.yml` |

## 开局补给

`JAP_ai_opening_equipment_resupply` 位于 `common/decisions/JAP_rework_ai_decision.txt`。

当前条件：

- `Rance_is_jap_ai = yes`
- `JAP_ai_template_stage_opening_infantry = yes`
- 或 `JAP_ai_template_stage_experimental_armor = yes`
- 开局规则 `rance_japan_ai_land_air_dynamic_supply = ENABLED`

当前效果：

```txt
JAP_ai_extra_equipment_grant_line_infantry_package = yes
JAP_ai_opening_air_equipment_grant_package = yes
```

开局空军包：

| 效果 | 装备 | 数量变量 | 数量 |
| --- | --- | --- | ---: |
| `JAP_ai_opening_air_equipment_grant_fighter_unit` | 轻型战斗机 | `JAP_ai_opening_air_equipment_fighter_unit_amount` | 100 |
| `JAP_ai_opening_air_equipment_grant_cas_unit` | CAS | `JAP_ai_opening_air_equipment_cas_unit_amount` | 50 |

开局补给不走动态难度倍率。若要调整数量，只改 `history/countries/JAP - Japan.txt` 中的两个 `JAP_ai_opening_air_equipment_*_amount` 变量。

## 60 天陆空循环入口

`JAP_ai_extra_equipment_grant_loop_start` 在军工厂数量大于 100 时启动，立即补给第一轮并激活 `JAP_ai_extra_equipment_grant_cycle_mission`。该 mission 每 60 天在同一个陆空动态补给规则判断内调用陆空额外装备，并自我重启：

```txt
if = {
    limit = {
        tag = JAP
        Rance_is_jap_ai = yes
        has_game_rule = {
            rule = rance_japan_ai_land_air_dynamic_supply
            option = ENABLED
        }
    }
    JAP_ai_extra_equipment_grant_cycle = yes
    JAP_ai_extra_air_equipment_grant_cycle = yes
}
hidden_effect = { activate_mission = JAP_ai_extra_equipment_grant_cycle_mission }
```

`JAP_ai_land_production_template_suppression_cycle_mission` 仍是 45 天编制检查循环，但只维护训练抑制与扩编意愿，不再调用陆空额外装备。

不要把陆军和空军拆成两个额外装备 mission。空军额外装备与空军生产策略互不依赖，只按实际装备 key 发放库存；陆空发放在 60 天循环中绑定结算。

## 动态最终倍率

`JAP_ai_dynamic_grant_refresh_multipliers` 每月在 `on_monthly` 中刷新一次，开局初始化也会刷新一次；旧存档若缺少变量，陆军、空军和海军 wrapper 会在结算前补刷新。

| 变量 | 含义 |
| --- | --- |
| `JAP_ai_dynamic_base_multiplier` | 战况基础倍率：和平 1，战争 2，战争中且日本投降进度大于 5% 为 3 |
| `JAP_ai_boss_bonus_multiplier` | Boss 模式额外加值：规则关闭为 0；规则开启后只按敌方玩家/主要国家 AI 累加 |
| `JAP_ai_dynamic_final_multiplier` | 最终倍率，等于基础倍率 + Boss 额外加值 |

Boss 模式统计规则：

- 敌方主要国家玩家：每个 +2。
- 敌方非主要国家玩家：每个 +1。
- 敌方主要国家 AI：每个 +1。
- 敌方非主要国家 AI：不增加。

陆军和空军 60 天循环入口只读取 `JAP_ai_dynamic_final_multiplier`。Boss 变量本身不直接作为发放次数使用，避免 0 倍率影响海军或陆空结算。

## 应急炮兵类补给决议

`common/decisions/JAP_rework_ai_decision.txt` 中有三条 AI-only 低库存即时补给决议，用于防止师编制因炮兵类装备见底而停摆。

| 决议 | 触发库存 | 调用效果 | 单次发放 |
| --- | --- | --- | ---: |
| `JAP_ai_emergency_artillery_equipment_resupply` | `artillery_equipment < 50` | `JAP_ai_extra_equipment_grant_artillery_equipment_unit` | 400 |
| `JAP_ai_emergency_anti_tank_equipment_resupply` | `anti_tank_equipment < 50` | `JAP_ai_extra_equipment_grant_anti_tank_equipment_unit` | 400 |
| `JAP_ai_emergency_anti_air_equipment_resupply` | `anti_air_equipment < 50` | `JAP_ai_extra_equipment_grant_anti_air_equipment_unit` | 200 |

这些决议不受 `rance_japan_ai_land_air_dynamic_supply` 限制，定位是 AI 保底急救，不属于 60 天动态难度循环。它们复用现有动态型号 grant effect，不要在决议里硬编码 `artillery_equipment_1/2/3`、`anti_tank_equipment_1/2/3` 或 `anti_air_equipment_1/2/3`。

## 装备型号控制

型号会变化的装备使用 `meta_effect` + scripted localisation 拼接实际装备 key：

```txt
meta_effect = {
    text = {
        add_equipment_to_stockpile = {
            type = small_plane_airframe_[JAP_ai_extra_air_equipment_text_small_plane_airframe]
            amount = JAP_ai_extra_air_equipment_fighter_unit_amount
            producer = ROOT
        }
    }
    JAP_ai_extra_air_equipment_text_small_plane_airframe = "[GetJAP_cr_small_plane_airframe]"
}
```

维护规则：

- `GetJAP_cr_*` 只返回装备后缀，例如 `1/2/3/4/5`。
- `type = *_[...]` 拼出最终装备 key，例如 `small_plane_airframe_3`。
- 固定单型号装备直接写具体 key，例如 `support_equipment_1`、`mothership_equipment_0`。
- `amount` 读取国家变量；不要在效果里写死数量。
- `producer = ROOT` 沿用现有额外装备发放写法。

如果新增动态型号装备，需要同时确认：

1. 已有或新增 `GetJAP_cr_*` defined text。
2. 对应装备设计效果会设置 `JAP_has_cr_*` flag，或 defined text 可按科技安全返回。
3. 拼出的装备 key 存在于本 MOD 或原版 `common/script_enums.txt` / `common/units/equipment/`。

## 陆军数量变量

陆军数量变量在 `history/countries/JAP - Japan.txt` 的 `1.7 AI 额外装备发放数量` 段。

### 公共和填线装备

| 装备效果 | 数量变量 | 数量 |
| --- | --- | ---: |
| `JAP_ai_extra_equipment_grant_infantry_equipment_3000` | `JAP_ai_extra_equipment_infantry_equipment_3000_amount` | 750 |
| `JAP_ai_extra_equipment_grant_infantry_equipment_12000` | `JAP_ai_extra_equipment_infantry_equipment_12000_amount` | 12000 |
| `JAP_ai_extra_equipment_grant_support_equipment_unit` | `JAP_ai_extra_equipment_support_equipment_unit_amount` | 250 |
| `JAP_ai_extra_equipment_grant_medium_tank_flame_chassis_unit` | `JAP_ai_extra_equipment_medium_tank_flame_chassis_unit_amount` | 15 |
| `JAP_ai_extra_equipment_grant_armored_support_vehicle_unit` | `JAP_ai_extra_equipment_armored_support_vehicle_unit_amount` | 25 |
| `JAP_ai_extra_equipment_grant_helicopter_equipment_unit` | `JAP_ai_extra_equipment_helicopter_equipment_unit_amount` | 40 |
| `JAP_ai_extra_equipment_grant_artillery_equipment_unit` | `JAP_ai_extra_equipment_artillery_equipment_unit_amount` | 400 |
| `JAP_ai_extra_equipment_grant_anti_tank_equipment_unit` | `JAP_ai_extra_equipment_anti_tank_equipment_unit_amount` | 400 |
| `JAP_ai_extra_equipment_grant_anti_air_equipment_unit` | `JAP_ai_extra_equipment_anti_air_equipment_unit_amount` | 200 |

### 60 天循环专用填线装备

这些效果只给 `JAP_ai_extra_equipment_grant_cycle` 的填线倍率入口使用；开局补给和紧急补给仍走上面的原始单装备效果。

| 装备效果 | 数量变量 | 数量 |
| --- | --- | ---: |
| `JAP_ai_extra_equipment_grant_cycle_infantry_equipment_12000` | `JAP_ai_extra_equipment_cycle_infantry_equipment_12000_amount` | 3000 |
| `JAP_ai_extra_equipment_grant_cycle_support_equipment_unit` | `JAP_ai_extra_equipment_cycle_support_equipment_unit_amount` | 65 |
| `JAP_ai_extra_equipment_grant_cycle_artillery_equipment_unit` | `JAP_ai_extra_equipment_cycle_artillery_equipment_unit_amount` | 100 |
| `JAP_ai_extra_equipment_grant_cycle_anti_tank_equipment_unit` | `JAP_ai_extra_equipment_cycle_anti_tank_equipment_unit_amount` | 100 |
| `JAP_ai_extra_equipment_grant_cycle_anti_air_equipment_unit` | `JAP_ai_extra_equipment_cycle_anti_air_equipment_unit_amount` | 50 |

### 主战装备

| 装备效果 | 数量变量 | 数量 |
| --- | --- | ---: |
| `JAP_ai_extra_equipment_grant_mechanized_equipment_unit` | `JAP_ai_extra_equipment_mechanized_equipment_unit_amount` | 275 |
| `JAP_ai_extra_equipment_grant_amphibious_mechanized_equipment_unit` | `JAP_ai_extra_equipment_amphibious_mechanized_equipment_unit_amount` | 350 |
| `JAP_ai_extra_equipment_grant_medium_tank_chassis_unit` | `JAP_ai_extra_equipment_medium_tank_chassis_unit_amount` | 250 |
| `JAP_ai_extra_equipment_grant_medium_tank_amphibious_chassis_unit` | `JAP_ai_extra_equipment_medium_tank_amphibious_chassis_unit_amount` | 250 |
| `JAP_ai_extra_equipment_grant_heavy_tank_chassis_unit` | `JAP_ai_extra_equipment_heavy_tank_chassis_unit_amount` | 250 |
| `JAP_ai_extra_equipment_grant_heavy_tank_amphibious_chassis_unit` | `JAP_ai_extra_equipment_heavy_tank_amphibious_chassis_unit_amount` | 250 |
| `JAP_ai_extra_equipment_grant_modern_tank_chassis_unit` | `JAP_ai_extra_equipment_modern_tank_chassis_unit_amount` | 1100 |
| `JAP_ai_extra_equipment_grant_land_cruiser_chassis_unit` | `JAP_ai_extra_equipment_land_cruiser_chassis_unit_amount` | 3 |
| `JAP_ai_extra_equipment_grant_medium_tank_destroyer_chassis_unit` | `JAP_ai_extra_equipment_medium_tank_destroyer_chassis_unit_amount` | 35 |
| `JAP_ai_extra_equipment_grant_medium_tank_artillery_chassis_unit` | `JAP_ai_extra_equipment_medium_tank_artillery_chassis_unit_amount` | 35 |
| `JAP_ai_extra_equipment_grant_medium_tank_aa_chassis_unit` | `JAP_ai_extra_equipment_medium_tank_aa_chassis_unit_amount` | 35 |
| `JAP_ai_extra_equipment_grant_heavy_tank_destroyer_chassis_unit` | `JAP_ai_extra_equipment_heavy_tank_destroyer_chassis_unit_amount` | 35 |
| `JAP_ai_extra_equipment_grant_heavy_tank_artillery_chassis_unit` | `JAP_ai_extra_equipment_heavy_tank_artillery_chassis_unit_amount` | 35 |
| `JAP_ai_extra_equipment_grant_heavy_tank_aa_chassis_unit` | `JAP_ai_extra_equipment_heavy_tank_aa_chassis_unit_amount` | 35 |
| `JAP_ai_extra_equipment_grant_modern_tank_destroyer_chassis_unit` | `JAP_ai_extra_equipment_modern_tank_destroyer_chassis_unit_amount` | 150 |
| `JAP_ai_extra_equipment_grant_modern_tank_artillery_chassis_unit` | `JAP_ai_extra_equipment_modern_tank_artillery_chassis_unit_amount` | 125 |
| `JAP_ai_extra_equipment_grant_modern_tank_aa_chassis_unit` | `JAP_ai_extra_equipment_modern_tank_aa_chassis_unit_amount` | 125 |

## 陆军包组和启用 flag

陆军额外装备保留编制包组。填线包始终发放；主战包组由持久 flag 启用，flag 一旦设置不需要随模板阶段替换清除。

| 包组效果 | 启用 flag | 内容 |
| --- | --- | --- |
| `JAP_ai_extra_equipment_grant_line_infantry_package` | 无 | 开局/非主循环填线包：步兵装备、支援装备 x2、火炮、反坦、防空 |
| `JAP_ai_extra_equipment_grant_cycle_line_infantry_package` | 无 | 60 天循环专用填线包：削弱后的步兵装备、支援装备 x2、火炮、反坦、防空 |
| `JAP_ai_extra_equipment_grant_infantry_tank_package` | `JAP_ai_extra_equipment_infantry_tank_package_started` | 公共包 + 中坦系列 + 重坦歼/重防空支援兜底 |
| `JAP_ai_extra_equipment_grant_mechanized_tank_package` | `JAP_ai_extra_equipment_mechanized_tank_package_started` | 公共包 + 机械化 + 中坦系列 + 重坦歼/重防空支援 |
| `JAP_ai_extra_equipment_grant_amphibious_medium_package` | `JAP_ai_extra_equipment_amphibious_medium_package_started` | 公共包 + 两栖机械化 + 两栖中坦 + 中坦衍生 + 重坦歼/重防空支援 |
| `JAP_ai_extra_equipment_grant_modern_tank_package` | `JAP_ai_extra_equipment_modern_tank_package_started` | 公共包 + 两栖机械化 + 现代坦克系列 |
| `JAP_ai_extra_equipment_grant_heavy_tank_package` | `JAP_ai_extra_equipment_heavy_tank_package_started` | 公共包 + 机械化 + 重坦系列 |
| `JAP_ai_extra_equipment_grant_heavy_amphibious_package` | `JAP_ai_extra_equipment_heavy_amphibious_package_started` | 公共包 + 两栖机械化 + 重型两栖 + 重坦衍生 |
| `JAP_ai_extra_equipment_grant_land_cruiser_package` | `JAP_ai_extra_equipment_land_cruiser_package_started` | 陆巡底盘 |

这些 flag 在 `common/decisions/JAP_rework_equipment_design_decision.txt` 的对应 AI 编制创建决议中设置。

陆军单装备效果内部还会检查对应 `JAP_has_cr_*` 设计 flag；缺少该装备设计时，只跳过该单项发放，不阻断同一包组内的其他装备。

## 陆军难度倍率

`JAP_ai_extra_equipment_grant_cycle_by_difficulty` 是单轮难度包，使用精确难度触发器，不使用 `Rance_nd_more_than_*` 比较型触发器。外层 `JAP_ai_extra_equipment_grant_cycle` 按 `JAP_ai_dynamic_final_multiplier` 循环调用该单轮包。

| 难度 | 主力包组调用倍率 | 填线步兵包调用倍率 |
| --- | ---: | ---: |
| `EASY` | 1 | 1 |
| `NORMAL` | 2 | 2 |
| `HARD` | 2 | 2 |
| `LUNATIC` | 1 | 3 |
| `EXTRA` | 2 | 3 |
| `PHANTASM` | 2 | 3 |

说明：

- 主力包组调用倍率作用于已启用的主战编制包组。
- 填线倍率作用于 `JAP_ai_extra_equipment_grant_cycle_line_infantry_package`。
- 高难度会启用更多装备族，因此“装备族数量增加”本身也是动态难度的一部分。
- 动态最终倍率在上述单轮难度包外层生效；开局补给和应急炮兵类补给不受该倍率影响。

## 空军数量变量

空军数量变量在 `history/countries/JAP - Japan.txt` 分为通用原始包和 60 天主循环专用包。60 天循环通过 `JAP_ai_extra_air_equipment_grant_cycle_total_package` 使用削弱后的 cycle 变量；不要直接下调通用原始变量，否则会影响未来或其他入口复用 `JAP_ai_extra_air_equipment_grant_total_package` 的场景。

### 通用原始空军包

| 装备效果 | 装备 key | 数量变量 | 通用数量 |
| --- | --- | --- | ---: |
| `JAP_ai_extra_air_equipment_grant_fighter_unit` | `small_plane_airframe` | `JAP_ai_extra_air_equipment_fighter_unit_amount` | 500 |
| `JAP_ai_extra_air_equipment_grant_cas_unit` | `small_plane_cas_airframe` | `JAP_ai_extra_air_equipment_cas_unit_amount` | 200 |
| `JAP_ai_extra_air_equipment_grant_heavy_fighter_unit` | `medium_plane_fighter_airframe` | `JAP_ai_extra_air_equipment_heavy_fighter_unit_amount` | 100 |
| `JAP_ai_extra_air_equipment_grant_cv_fighter_unit` | `cv_small_plane_airframe` | `JAP_ai_extra_air_equipment_cv_fighter_unit_amount` | 100 |
| `JAP_ai_extra_air_equipment_grant_cv_naval_bomber_unit` | `cv_small_plane_naval_bomber_airframe` | `JAP_ai_extra_air_equipment_cv_naval_bomber_unit_amount` | 100 |
| `JAP_ai_extra_air_equipment_grant_maritime_patrol_plane_unit` | `large_plane_maritime_patrol_plane_airframe` | `JAP_ai_extra_air_equipment_maritime_patrol_plane_unit_amount` | 50 |
| `JAP_ai_extra_air_equipment_grant_intercontinental_bomber_unit` | `strat_bomber_intercontinental_equipment_1` | `JAP_ai_extra_air_equipment_intercontinental_bomber_unit_amount` | 50 |
| `JAP_ai_extra_air_equipment_grant_mothership_unit` | `mothership_equipment_0` | `JAP_ai_extra_air_equipment_mothership_unit_amount` | 50 |

### 60 天主循环专用空军包

这些效果只给 `JAP_ai_extra_air_equipment_grant_cycle` 的难度倍率入口使用。轻战和 CAS 约为通用原始包的四分之一；其他空军装备按该口径再翻倍，50 件级别的后期特殊装备取 30，保持整齐且略偏宽松。

| 装备效果 | 装备 key | 数量变量 | 1 倍率数量 | 年化约 |
| --- | --- | --- | ---: | ---: |
| `JAP_ai_extra_air_equipment_grant_cycle_fighter_unit` | `small_plane_airframe` | `JAP_ai_extra_air_equipment_cycle_fighter_unit_amount` | 125 | 750 |
| `JAP_ai_extra_air_equipment_grant_cycle_cas_unit` | `small_plane_cas_airframe` | `JAP_ai_extra_air_equipment_cycle_cas_unit_amount` | 50 | 300 |
| `JAP_ai_extra_air_equipment_grant_cycle_heavy_fighter_unit` | `medium_plane_fighter_airframe` | `JAP_ai_extra_air_equipment_cycle_heavy_fighter_unit_amount` | 50 | 300 |
| `JAP_ai_extra_air_equipment_grant_cycle_cv_fighter_unit` | `cv_small_plane_airframe` | `JAP_ai_extra_air_equipment_cycle_cv_fighter_unit_amount` | 50 | 300 |
| `JAP_ai_extra_air_equipment_grant_cycle_cv_naval_bomber_unit` | `cv_small_plane_naval_bomber_airframe` | `JAP_ai_extra_air_equipment_cycle_cv_naval_bomber_unit_amount` | 50 | 300 |
| `JAP_ai_extra_air_equipment_grant_cycle_maritime_patrol_plane_unit` | `large_plane_maritime_patrol_plane_airframe` | `JAP_ai_extra_air_equipment_cycle_maritime_patrol_plane_unit_amount` | 30 | 180 |
| `JAP_ai_extra_air_equipment_grant_cycle_intercontinental_bomber_unit` | `strat_bomber_intercontinental_equipment_1` | `JAP_ai_extra_air_equipment_cycle_intercontinental_bomber_unit_amount` | 30 | 180 |
| `JAP_ai_extra_air_equipment_grant_cycle_mothership_unit` | `mothership_equipment_0` | `JAP_ai_extra_air_equipment_cycle_mothership_unit_amount` | 30 | 180 |

新档由历史文件初始化这些 cycle 变量；旧存档如果缺少变量，`JAP_ai_extra_air_equipment_grant_cycle` 会先调用 `JAP_ai_extra_air_equipment_ensure_cycle_amounts` 补齐默认值。

空军不按中间分类包组拆分。`JAP_ai_extra_air_equipment_grant_total_package` 保留通用原始数量；`JAP_ai_extra_air_equipment_grant_cycle_total_package` 是 60 天主循环的小包，带相同的后期装备设计 flag 门槛。

后期空军装备门槛：

- 海军巡逻轰炸机：已有 `JAP_has_cr_large_plane_maritime_patrol_plane_airframe_2/3/4` 任一 flag。
- 洲际轰炸机：已有 `JAP_has_cr_strat_bomber_intercontinental_equipment_1`。
- 空天母舰：已有 `JAP_has_cr_mothership_equipment_0`。

## 空军难度倍率

空军所有难度调用同一个 60 天主循环小包，仅用调用次数调整总量。通用原始包不参与 `JAP_ai_extra_air_equipment_grant_cycle`。

| 难度 | 60 天循环小包调用倍率 |
| --- | ---: |
| `EASY` | 1 |
| `NORMAL` | 1 |
| `HARD` | 2 |
| `LUNATIC` | 2 |
| `EXTRA` | 3 |
| `PHANTASM` | 3 |

空军额外发放不关心 `common/units/air.txt` 中的 sub-unit `type` 是否重叠，只关心 `add_equipment_to_stockpile` 的实际装备 key。

## 调整流程

### 调整数量

1. 若调整 60 天主循环，只改 `history/countries/JAP - Japan.txt` 中对应 `JAP_ai_extra_air_equipment_cycle_*_amount` 或陆军 `*_cycle_*_amount` 变量。
2. 若调整开局补给、应急补给、或未来非主循环复用包，才改对应通用 `*_amount` 变量。
3. 确认该变量仍被 `common/scripted_effects/JAP_equipment_scripted_effects.txt` 引用。
4. 更新本文表格。

### 新增陆军装备

1. 在历史文件新增数量变量。
2. 在 `JAP_equipment_scripted_effects.txt` 新增单装备效果。
3. 若装备型号会变化，补或复用 `GetJAP_cr_*` 动态后缀。
4. 把单装备效果接入合适的陆军包组。
5. 若需要新包组，新增持久 flag，并在对应 AI 编制创建决议中设置。
6. 更新本文的数量表和包组表。

### 新增空军装备

1. 在历史文件新增数量变量。
2. 在 `JAP_equipment_scripted_effects.txt` 新增单装备效果。
3. 若需要动态型号，复用或新增 `GetJAP_cr_*`。
4. 若装备属于 60 天主循环，新增对应 `JAP_ai_extra_air_equipment_grant_cycle_*` 小效果和 cycle 数量变量，并接入 `JAP_ai_extra_air_equipment_grant_cycle_total_package`。
5. 若装备也需要被非主循环入口复用，再接入 `JAP_ai_extra_air_equipment_grant_total_package`。
6. 如果是后期特殊装备，在对应总包内加设计 flag 门槛。
7. 更新本文的空军数量表和门槛说明。

### 改难度倍率

陆军改：

- `JAP_ai_extra_equipment_grant_cycle`
- `JAP_ai_extra_equipment_grant_main_multiplier_*`
- `JAP_ai_extra_equipment_grant_line_infantry_multiplier_*`

空军改：

- `JAP_ai_extra_air_equipment_grant_cycle`
- `JAP_ai_extra_air_equipment_grant_multiplier_*`

改完同步更新本文的陆军/空军倍率表。

## 快速检查命令

```powershell
rg -n "JAP_ai_opening_equipment_resupply|JAP_ai_opening_air_equipment" common history localisation Reference
rg -n "rance_japan_ai_land_air_dynamic_supply|JAP_ai_extra_equipment_grant_loop_start|JAP_ai_extra_equipment_grant_cycle_mission|JAP_ai_extra_equipment_grant_cycle|JAP_ai_extra_air_equipment_grant_cycle" common/decisions common/scripted_effects common/game_rules
rg -n "JAP_ai_extra_equipment_.*_amount|JAP_ai_extra_air_equipment_.*_amount|JAP_ai_opening_air_equipment_.*_amount" history common/scripted_effects
rg -n "GetJAP_cr_.*plane|JAP_has_cr_.*plane|JAP_has_cr_mothership|JAP_has_cr_strat_bomber" common/scripted_localisation common/scripted_effects common/decisions history
```

重点看：

- 数量变量是否全部初始化并被效果引用。
- `meta_effect` 拼接出来的装备 key 是否存在。
- 开局补给是否仍只在陆空动态补给规则开启、且处于开局步兵/实验装甲阶段时生效。
- 45 天编制检查 mission 是否不再调用陆空发放。
- 60 天陆空循环 mission 是否仍只在陆空动态补给规则开启时调用陆空发放。
- 空军后期特殊装备是否有设计 flag 后才发放。

## 调参观察点

- AI 是否仍然会正常生产装备，而不是完全依赖赠送。
- 填线步兵装备是否足够支撑长战线。
- 中坦、两栖中坦、现代坦克、重坦之间是否出现严重库存偏科。
- `LUNATIC` 及以上是否因为重装包过强导致中坦体系过早失去意义。
- `EXTRA` / `PHANTASM` 的陆巡底盘是否过快堆高。
- 轻型战斗机库存是否过早超过 `Rance_fighter_high_threshold`。
- CAS 是否能支撑大陆战场消耗，同时不挤占轻战数量。
- 舰载机是否明显过剩，尤其是日本航母数量不足时。
- 海巡、洲际轰炸机、空天母舰是否因小批量赠送仍然堆得过快。
- 和平期是否囤货过多；如明显过量，优先考虑在对应循环入口加 `has_war = yes`。
## 开发归档

> 归档时间：2026-05-22。以下内容从 `CHANGELOG` 迁入 `Reference`，用于保留设计背景、调参依据和已完成/待办记录。日常维护优先参考本文前面的维护索引。
### 来源：`CHANGELOG/ai_extra_equipment_plan.md`

### AI 额外装备发放规划

> 维护源已整理至 `Reference/ai_extra_equipment_maintenance_reference.md`。本文保留为陆军额外装备发放的规划归档；后续调参、增删装备和排查引用时优先更新 Reference 文档。

#### 目标

为日本 AI 建立一套随 MOD 难度变化的额外陆军装备发放系统。

第一版目标：

- 主体效果集成进现有 45 天编制检测循环。
- 不按实时装备缺口计算。
- 不读取 `role_ratio` 做复杂加权。
- 保留编制包组作为条件入口，实际发放由单装备效果执行。

当前结构是三层：

1. `JAP_ai_extra_equipment_grant_cycle`：45 天循环总入口。
2. 编制包组效果：按持久 flag 判断是否启用，再调用单装备效果。
3. 单装备效果：实际执行 `add_equipment_to_stockpile`。

#### 当前已落地

已完成：

- 数量变量：`history/countries/JAP - Japan.txt`
- 装备型号脚本本地化：`common/scripted_localisation/JAP_equipment_scripted_loc.txt`
- 单装备发放效果：`common/scripted_effects/JAP_equipment_scripted_effects.txt`
- 编制包组发放效果：`common/scripted_effects/JAP_equipment_scripted_effects.txt`
- 机械倍率与总入口效果：`common/scripted_effects/JAP_equipment_scripted_effects.txt`
- 45 天 mission 接入：`common/decisions/JAP_rework_equipment_design_decision.txt`
- 编制包组持久 flag 设置：`common/decisions/JAP_rework_ai_decision.txt`
- 45 天循环启动前的开局陆空阶段补给：`common/decisions/JAP_rework_ai_decision.txt`

尚未完成：

- 第一版主体外的独立额外发放决议

#### 集成位置

主体效果集成进：

- `common/decisions/JAP_rework_equipment_design_decision.txt`
- `JAP_ai_land_production_template_suppression_cycle_mission`

该 45 天 mission 当前调用：

```txt
JAP_ai_template_update_training_suppression_flags = yes
JAP_ai_extra_equipment_grant_cycle = yes
```

不新增第三个循环 mission。

#### 45 天循环启动前的陆空阶段补给

45 天循环由 `JAP_ai_land_production_loop_start` 在军工厂数量大于 100 时启动。循环启动前，`JAP_ai_opening_equipment_resupply` 在开局步兵阶段每 30 天给日本 AI 发放 1 个填线步兵包、100 架轻型战斗机、50 架 CAS，各难度相同。

该补给复用 `JAP_ai_extra_equipment_grant_line_infantry_package`，即约 5 个 `JAP_infantry` 师的填线装备包；空军侧调用 `JAP_ai_opening_air_equipment_grant_package`，只发轻型战斗机与 CAS。不走难度倍率。若玩家关闭 AI 动态难度额外装备，或 AI 离开 `JAP_ai_template_stage_opening_infantry`，则该决议不可见并取消读条。

#### 范围边界

主体效果覆盖：

- 填线步兵装备。
- 主战编制包组装备。
- 普通火炮、反坦炮、防空炮随填线步兵包发放。

主体效果暂不覆盖：

- `motorized_equipment`
- `train_equipment`

这些后续与火车、补给、铁路、后勤逻辑单独设计。

#### 1 倍率口径

45 天发放一次，一年约 8 次。

1 倍率代表：

- 填线步兵：每次约 5 个师装备，一年约 40 个师。
- 每个主战编制包组：每次约 3 个该族主战师装备，一年约 24 个该族主战师。

本 MOD 日本产能高于原版，因此该基准高于原版 AI 直觉。

#### 单装备效果

最小单位按单装备 key 写。除 `infantry_equipment` 特例外，一个装备只保留一个基础发放效果。

##### 公共装备

| 单装备效果 | 装备 key | 数量变量 | 数量 |
| --- | --- | --- | ---: |
| `JAP_ai_extra_equipment_grant_infantry_equipment_3000` | `infantry_equipment` | `JAP_ai_extra_equipment_infantry_equipment_3000_amount` | 3000 |
| `JAP_ai_extra_equipment_grant_infantry_equipment_12000` | `infantry_equipment` | `JAP_ai_extra_equipment_infantry_equipment_12000_amount` | 12000 |
| `JAP_ai_extra_equipment_grant_support_equipment_unit` | `support_equipment_1` | `JAP_ai_extra_equipment_support_equipment_unit_amount` | 250 |
| `JAP_ai_extra_equipment_grant_medium_tank_flame_chassis_unit` | `medium_tank_flame_chassis` | `JAP_ai_extra_equipment_medium_tank_flame_chassis_unit_amount` | 50 |
| `JAP_ai_extra_equipment_grant_armored_support_vehicle_unit` | `armored_support_vehicle_1` | `JAP_ai_extra_equipment_armored_support_vehicle_unit_amount` | 100 |
| `JAP_ai_extra_equipment_grant_helicopter_equipment_unit` | `helicopter_equipment_1` | `JAP_ai_extra_equipment_helicopter_equipment_unit_amount` | 150 |

取整依据：

- 主战包步兵装备多数约 2760，统一为 3000。
- 填线步兵装备约 11500，统一为 12000。
- `support_equipment` 主战约 225、填线约 550，统一单位取 250；填线包调用 2 次。
- 喷火坦克、装甲支援车辆、直升机分别由 45、90、135 取整到 50、100、150。

##### 填线专属装备

| 单装备效果 | 装备 key | 数量变量 | 数量 |
| --- | --- | --- | ---: |
| `JAP_ai_extra_equipment_grant_artillery_equipment_unit` | `artillery_equipment` | `JAP_ai_extra_equipment_artillery_equipment_unit_amount` | 400 |
| `JAP_ai_extra_equipment_grant_anti_tank_equipment_unit` | `anti_tank_equipment` | `JAP_ai_extra_equipment_anti_tank_equipment_unit_amount` | 400 |
| `JAP_ai_extra_equipment_grant_anti_air_equipment_unit` | `anti_air_equipment` | `JAP_ai_extra_equipment_anti_air_equipment_unit_amount` | 200 |

##### 主战专属装备

| 单装备效果 | 装备 key | 数量变量 | 数量 |
| --- | --- | --- | ---: |
| `JAP_ai_extra_equipment_grant_mechanized_equipment_unit` | `mechanized_equipment` | `JAP_ai_extra_equipment_mechanized_equipment_unit_amount` | 1100 |
| `JAP_ai_extra_equipment_grant_amphibious_mechanized_equipment_unit` | `amphibious_mechanized_equipment` | `JAP_ai_extra_equipment_amphibious_mechanized_equipment_unit_amount` | 1350 |
| `JAP_ai_extra_equipment_grant_medium_tank_chassis_unit` | `medium_tank_chassis` | `JAP_ai_extra_equipment_medium_tank_chassis_unit_amount` | 1000 |
| `JAP_ai_extra_equipment_grant_medium_tank_amphibious_chassis_unit` | `medium_tank_amphibious_chassis` | `JAP_ai_extra_equipment_medium_tank_amphibious_chassis_unit_amount` | 1000 |
| `JAP_ai_extra_equipment_grant_heavy_tank_chassis_unit` | `heavy_tank_chassis` | `JAP_ai_extra_equipment_heavy_tank_chassis_unit_amount` | 1000 |
| `JAP_ai_extra_equipment_grant_heavy_tank_amphibious_chassis_unit` | `heavy_tank_amphibious_chassis` | `JAP_ai_extra_equipment_heavy_tank_amphibious_chassis_unit_amount` | 1000 |
| `JAP_ai_extra_equipment_grant_modern_tank_chassis_unit` | `modern_tank_chassis_1` | `JAP_ai_extra_equipment_modern_tank_chassis_unit_amount` | 1100 |
| `JAP_ai_extra_equipment_grant_land_cruiser_chassis_unit` | `land_cruiser_chassis_1` | `JAP_ai_extra_equipment_land_cruiser_chassis_unit_amount` | 3 |

| 单装备效果 | 装备 key | 数量变量 | 数量 |
| --- | --- | --- | ---: |
| `JAP_ai_extra_equipment_grant_medium_tank_destroyer_chassis_unit` | `medium_tank_destroyer_chassis` | `JAP_ai_extra_equipment_medium_tank_destroyer_chassis_unit_amount` | 125 |
| `JAP_ai_extra_equipment_grant_medium_tank_artillery_chassis_unit` | `medium_tank_artillery_chassis` | `JAP_ai_extra_equipment_medium_tank_artillery_chassis_unit_amount` | 125 |
| `JAP_ai_extra_equipment_grant_medium_tank_aa_chassis_unit` | `medium_tank_aa_chassis` | `JAP_ai_extra_equipment_medium_tank_aa_chassis_unit_amount` | 125 |
| `JAP_ai_extra_equipment_grant_heavy_tank_destroyer_chassis_unit` | `heavy_tank_destroyer_chassis` | `JAP_ai_extra_equipment_heavy_tank_destroyer_chassis_unit_amount` | 125 |
| `JAP_ai_extra_equipment_grant_heavy_tank_artillery_chassis_unit` | `heavy_tank_artillery_chassis` | `JAP_ai_extra_equipment_heavy_tank_artillery_chassis_unit_amount` | 125 |
| `JAP_ai_extra_equipment_grant_heavy_tank_aa_chassis_unit` | `heavy_tank_aa_chassis` | `JAP_ai_extra_equipment_heavy_tank_aa_chassis_unit_amount` | 125 |
| `JAP_ai_extra_equipment_grant_modern_tank_destroyer_chassis_unit` | `modern_tank_destroyer_chassis_1` | `JAP_ai_extra_equipment_modern_tank_destroyer_chassis_unit_amount` | 150 |
| `JAP_ai_extra_equipment_grant_modern_tank_artillery_chassis_unit` | `modern_tank_artillery_chassis_1` | `JAP_ai_extra_equipment_modern_tank_artillery_chassis_unit_amount` | 125 |
| `JAP_ai_extra_equipment_grant_modern_tank_aa_chassis_unit` | `modern_tank_aa_chassis_1` | `JAP_ai_extra_equipment_modern_tank_aa_chassis_unit_amount` | 125 |

#### 装备型号控制

型号会变化的最小装备效果采用 `meta_effect` + 脚本本地化拼接装备型号：

```txt
meta_effect = {
	text = {
		add_equipment_to_stockpile = {
			type = medium_tank_chassis_[JAP_ai_extra_equipment_text_medium_tank_chassis]
			amount = JAP_ai_extra_equipment_medium_tank_chassis_unit_amount
			producer = ROOT
		}
	}
	JAP_ai_extra_equipment_text_medium_tank_chassis = "[GetJAP_cr_medium_tank_chassis]"
}
```

规则：

- `GetJAP_cr_*` 只负责返回装备后缀，例如 `1/2/3`。
- `type = *_[...]` 拼出最终装备 key，例如 `medium_tank_chassis_2`。
- 固定为 1 型的装备直接写具体装备 key，不走 `meta_effect`。
- 只借鉴 `rookie_ITA` 的 `meta_effect` 拼接写法，不借鉴其数量变量计算方式。
- `amount` 读取预先初始化的国家变量。

步兵装备和三种普通火炮没有装备设计创建 flag，按原版科技选择型号：

| 控制器 | 原版科技换代点 | 返回装备 |
| --- | --- | --- |
| `GetJAP_cr_infantry_equipment` | `infantry_weapons` / `infantry_weapons1` / `improved_infantry_weapons` / `advanced_infantry_weapons` | `infantry_equipment_0/1/2/3` |
| `GetJAP_cr_artillery_equipment` | `gw_artillery` / `artillery1` / `artillery4` | `artillery_equipment_1/2/3` |
| `GetJAP_cr_anti_tank_equipment` | `interwar_antitank` / `antitank2` / `antitank5` | `anti_tank_equipment_1/2/3` |
| `GetJAP_cr_anti_air_equipment` | `interwar_antiair` / `antiair2` / `antiair5` | `anti_air_equipment_1/2/3` |

注意：`artillery2/3`、`antitank3/4`、`antiair3/4` 是属性改良或中间科技，不是新装备型号换代点。

#### 编制包组

上层包组仍按旧编制包组组织，方便条件编写。包组内部只组合调用单装备效果。

| 包组效果 | 来源参照 | 调用内容 |
| --- | --- | --- |
| `JAP_ai_extra_equipment_grant_line_infantry_package` | `JAP_infantry` x5 | `infantry_equipment_12000`、`support_equipment_unit` x2、火炮、反坦、防空 |
| `JAP_ai_extra_equipment_grant_combat_common_package` | 多数主战包公共需求 | `infantry_equipment_3000`、支援、喷火坦克、装甲支援车、直升机 |
| `JAP_ai_extra_equipment_grant_infantry_tank_package` | `JAP_infantry_tank` x3 | 主战公共包 + 中坦底盘/坦歼/自火/防空 + 重坦歼/重防空支援兜底 |
| `JAP_ai_extra_equipment_grant_mechanized_tank_package` | `JAP_mechanized_tank` x3 | 主战公共包 + 机械化 + 中坦底盘/坦歼/自火/防空 + 重坦歼/重防空支援 |
| `JAP_ai_extra_equipment_grant_amphibious_medium_package` | `JAP_amphibious_mechanized` x3 | 主战公共包 + 两栖机械化 + 两栖中坦底盘 + 中坦坦歼/自火/防空 + 重坦歼/重防空支援 |
| `JAP_ai_extra_equipment_grant_modern_tank_package` | `JAP_marine_modern_mechanized_tank` x3 | 主战公共包 + 两栖机械化 + 现代坦克底盘/坦歼/自火/防空 |
| `JAP_ai_extra_equipment_grant_heavy_tank_package` | `JAP_mechanized_heavy_tank` x3 | 主战公共包 + 机械化 + 重坦底盘/坦歼/自火/防空 |
| `JAP_ai_extra_equipment_grant_heavy_amphibious_package` | `JAP_heavy_amphibious_mechanized` x3 | 主战公共包 + 两栖机械化 + 重型两栖底盘 + 重坦坦歼/自火/防空 |
| `JAP_ai_extra_equipment_grant_land_cruiser_package` | 陆巡模板额外需求 | 陆巡底盘 |

说明：

- `JAP_ai_extra_equipment_grant_line_infantry_package` 不检查编制 flag，45 天循环启动后持续发放。
- `JAP_ai_extra_equipment_grant_combat_common_package` 是主战包内部子包，不单独作为难度入口调用。
- 其他主战包内部用 `if limit` 检查对应持久 flag，未启用时不会实际发放。
- 陆巡两栖重机坦 ≈ 重型两栖包 + 陆巡包。
- 陆巡海陆现代机坦 ≈ 现代坦克包 + 陆巡包。
- 日本特种步坦师没有独立额外装备包，EASY 的步坦包同时承担特种步坦下放重坦歼/重防空支援后的兜底。
- `JAP_ai_extra_equipment_grant_infantry_tank_package` 原始步兵装备约 4110，当前主战公共包只给 3000；这是已知精度妥协。

#### 包组启用条件

装备包不按当前装备库存、装备设计创建状态、或当前 AI 模板阶段触发。

触发原则：

- 每个编制装备包在相关编制开始训练后启用。
- 启用后保持发放，即使该编制后来因为陆巡师、现代坦克师或其他阶段替换而被抑制。
- 不直接使用 `JAP_ai_template_stage_regular_armor_hard` 这类当前阶段 trigger，因为阶段替换后旧阶段 trigger 会失效。

在对应 AI 创建编制决议的 `complete_effect` 中设置：

| 编制创建决议 | 持久 flag | 启用包组 |
| --- | --- | --- |
| `JAP_rai_create_infantry_tank_template` | `JAP_ai_extra_equipment_infantry_tank_package_started` | 中坦步坦包 |
| `JAP_rai_create_mechanized_tank_template` | `JAP_ai_extra_equipment_mechanized_tank_package_started` | 中坦机坦包 |
| `JAP_rai_create_amphibious_mechanized_template` | `JAP_ai_extra_equipment_amphibious_medium_package_started` | 两栖中坦包 |
| `JAP_rai_create_marine_modern_mechanized_tank_template` | `JAP_ai_extra_equipment_modern_tank_package_started` | 现代坦克包 |
| `JAP_rai_create_mechanized_heavy_tank_template` | `JAP_ai_extra_equipment_heavy_tank_package_started` | 重坦包 |
| `JAP_rai_create_heavy_amphibious_mechanized_template` | `JAP_ai_extra_equipment_heavy_amphibious_package_started` | 重型两栖包 |
| `JAP_rai_create_land_crushier_template` | `JAP_ai_extra_equipment_land_cruiser_package_started` | 陆巡包 |
| `JAP_rai_create_land_cruiser_marine_modern_mechanized_tank_template` | `JAP_ai_extra_equipment_modern_tank_package_started` 和 `JAP_ai_extra_equipment_land_cruiser_package_started` | 现代坦克包 + 陆巡包 |

这些 flag 不需要在阶段替换或训练抑制时清除。

#### 难度预期

`JAP_ai_extra_equipment_grant_cycle` 先按难度倍率发填线步兵包，再按难度倍率调用各编制包组。包组内部自行检查持久 flag。

难度倍率选择使用精确难度触发器，不使用 `Rance_nd_more_than_*` 比较型触发器。

倍率效果已拆成可复用的命名效果：

```txt
JAP_ai_extra_equipment_grant_cycle = {
	if = {
		limit = { Rance_nd_is_easy = yes }
		JAP_ai_extra_equipment_grant_main_multiplier_1 = yes
		JAP_ai_extra_equipment_grant_line_infantry_multiplier_1 = yes
	}
	else_if = {
		limit = { Rance_nd_is_normal = yes }
		JAP_ai_extra_equipment_grant_main_multiplier_2 = yes
		JAP_ai_extra_equipment_grant_line_infantry_multiplier_2 = yes
	}
	else_if = {
		limit = { Rance_nd_is_hard = yes }
		JAP_ai_extra_equipment_grant_main_multiplier_2 = yes
		JAP_ai_extra_equipment_grant_line_infantry_multiplier_2 = yes
	}
	else_if = {
		limit = { Rance_nd_is_lunatic = yes }
		JAP_ai_extra_equipment_grant_main_multiplier_1 = yes
		JAP_ai_extra_equipment_grant_line_infantry_multiplier_3 = yes
	}
	else_if = {
		limit = { Rance_nd_is_extra = yes }
		JAP_ai_extra_equipment_grant_main_multiplier_2 = yes
		JAP_ai_extra_equipment_grant_line_infantry_multiplier_3 = yes
	}
	else_if = {
		limit = { Rance_nd_is_phantasm = yes }
		JAP_ai_extra_equipment_grant_main_multiplier_2 = yes
		JAP_ai_extra_equipment_grant_line_infantry_multiplier_3 = yes
	}
}
```

难度不是互斥替换旧包组，而是在保留较低难度主战包组的基础上累积启用更多包组。

| 难度 | 非现坦/陆巡阶段主战包 | 约等效主战师/次 | 约等效主战师/年 | 后续新增 |
| --- | --- | ---: | ---: | --- |
| `EASY` | 中坦步坦包 | 3 | 24 | 无 |
| `NORMAL` | 中坦机坦包 | 3 | 24 | 现代坦克包 |
| `HARD` | 中坦机坦包 + 两栖中坦包 | 6 | 48 | 现代坦克包 |
| `LUNATIC` | 中坦机坦包 + 两栖中坦包 + 重坦包 + 重型两栖包 | 12 | 96 | 现代坦克包 |
| `EXTRA` / `PHANTASM` | 中坦机坦包 + 两栖中坦包 + 重坦包 + 重型两栖包 | 12 | 96 | 现代坦克包 + 陆巡包 |

上表为 1 倍率下的基础包组等效量，未计入下方调用倍率。填线步兵包在 1 倍率下每次约 5 个师装备，一年约 40 个师装备，不计入上表主战师等效数。

##### 调用倍率规划

倍率按难度从低到高排列：`EASY` / `NORMAL` / `HARD` / `LUNATIC` / `EXTRA` / `PHANTASM`。

| 类型 | `EASY` | `NORMAL` | `HARD` | `LUNATIC` | `EXTRA` | `PHANTASM` |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| 主力包组调用倍率 | 1 | 2 | 2 | 1 | 2 | 2 |
| 填线步兵包调用倍率 | 1 | 2 | 2 | 3 | 3 | 3 |

说明：这是归档阶段的旧规划；当前版本中，填线倍率已改为作用于 `JAP_ai_extra_equipment_grant_cycle_line_infantry_package`，避免影响开局/非主循环填线包。

高难度会启用更多装备族，因此“装备族数量增加”本身就是动态难度补给的一部分。

#### 调参观察点

测试时重点看：

- AI 是否仍然会生产这些装备，而不是完全依赖赠送。
- 填线步兵装备是否足够支撑长战线。
- 中坦、两栖中坦、现代坦克、重坦之间是否出现严重库存偏科。
- `LUNATIC` 及以上是否因为重装包过强导致中坦体系过早失去意义。
- `EXTRA` / `PHANTASM` 的陆巡包调用次数是否过高，尤其是 `land_cruiser_chassis` 是否需要通过半量包或小包控制。
- 和平期是否囤货过多；如果囤货明显，优先改成战时发放。

#### 参考文件

- `Reference/template_JAP_equipment_requirements.md`
- `Reference/ai_land_production_difficulty_equipment_reference.md`
- `Reference/route_difficulty_scripted_trigger.md`
- `common/decisions/JAP_rework_equipment_design_decision.txt`
- `common/decisions/JAP_rework_ai_decision.txt`
- `common/scripted_effects/JAP_equipment_scripted_effects.txt`
- `common/scripted_localisation/JAP_equipment_scripted_loc.txt`
### 来源：`CHANGELOG/ai_extra_air_equipment_plan.md`

### AI 额外空军装备发放规划

> 维护源已整理至 `Reference/ai_extra_equipment_maintenance_reference.md`。本文保留为空军额外装备发放的规划归档；后续调参、增删装备和排查引用时优先更新 Reference 文档。
> 注意：下方归档保留早期 45 天循环和通用总包规划口径。当前 60 天主循环已改用 `JAP_ai_extra_air_equipment_grant_cycle_total_package` 与 `JAP_ai_extra_air_equipment_cycle_*_amount` 小包变量。

#### 目标

为日本 AI 建立一套随 MOD 难度变化的额外空军装备发放系统。

当前落地目标：

- 主体效果集成进现有 45 天编制检测循环。
- 不新增独立空军发放 mission。
- 不读取实时飞机缺口。
- 不和空军生产策略、`build_airplane`、`equipment_production_factor` 联动。
- 只按实际装备型号 key 发放库存。

当前规划结构压缩为三层，但中间只保留一个总包：

1. `JAP_ai_extra_air_equipment_grant_cycle`：45 天循环中的空军发放入口。
2. `JAP_ai_extra_air_equipment_grant_total_package`：组合调用各单装备效果。
3. 单装备效果：实际执行 `add_equipment_to_stockpile`。

#### 当前已落地

已新增或修改：

- 数量变量：`history/countries/JAP - Japan.txt`
- 单装备发放效果：`common/scripted_effects/JAP_equipment_scripted_effects.txt`
- 总包发放效果：`common/scripted_effects/JAP_equipment_scripted_effects.txt`
- 空军倍率与总入口效果：`common/scripted_effects/JAP_equipment_scripted_effects.txt`
- 45 天 mission 接入：`common/decisions/JAP_rework_equipment_design_decision.txt`
- 45 天循环启动前的开局空军补给：`common/decisions/JAP_rework_ai_decision.txt`

通常不需要新增：

- 新的 scripted localisation 文件。现有 `common/scripted_localisation/JAP_equipment_scripted_loc.txt` 已有飞机型号后缀动态文本。
- 新的 AI strategy。额外装备发放与空军生产策略互不依赖。
- 新的编制包启用 flag。空军不按陆军编制阶段启停。
- 新的中间分类包组。空军装备种类少，直接由总包调用单装备效果即可。

#### 45 天循环启动前的空军补给

45 天循环启动前，`JAP_ai_opening_equipment_resupply` 和开局填线步兵补给接在一起，每 30 天统一发放：

| 装备类型 | 数量 |
| --- | ---: |
| 轻型战斗机 | 100 |
| CAS | 50 |

该补给调用 `JAP_ai_opening_air_equipment_grant_package`，只复用当前设计动态文本，不走动态难度倍率，也不读取空军生产策略。

#### 集成位置

主体效果已接入：

- `common/decisions/JAP_rework_equipment_design_decision.txt`
- `JAP_ai_land_production_template_suppression_cycle_mission`

该 45 天 mission 现在调用：

```txt
JAP_ai_template_update_training_suppression_flags = yes
JAP_ai_extra_equipment_grant_cycle = yes
JAP_ai_extra_air_equipment_grant_cycle = yes
```

并继续共用现有陆空动态补给规则：

```txt
has_game_rule = {
    rule = rance_japan_ai_land_air_dynamic_supply
    option = ENABLED
}
```

即玩家在开局规则中关闭陆空动态补给时，陆军和空军额外发放一起停止。

#### 范围边界

主体效果覆盖：

- 轻型战斗机。
- CAS。
- 重型战斗机。
- 舰载战斗机。
- 舰载鱼雷机。
- 海军巡逻轰炸机。
- 洲际轰炸机。
- 空天母舰。

主体效果暂不覆盖：

- `transport_plane_equipment_1`
- `medium_plane_airframe`
- `large_plane_airframe`
- `small_plane_naval_bomber_airframe`
- `cv_small_plane_cas_airframe`
- `cv_small_plane_suicide_airframe`

说明：

- 运输机、战术轰炸机、普通战略轰炸机、陆基小型海军轰炸机、舰载 CAS、神风机等暂不纳入本方案。
- 当前日本 AI 空军主体系以轻战、CAS、重战、舰载机、海巡、特殊飞机为核心。
- 空军额外发放不关心 `common/units/air.txt` 中的 sub-unit `type` 是否重叠，只关心 `add_equipment_to_stockpile` 的实际装备 key。

#### 1 倍率口径

45 天发放一次，一年约 8 次。

1 倍率代表每次发放：

| 装备类型 | 数量 | 年化约 |
| --- | ---: | ---: |
| 轻型战斗机 | 500 | 4000 |
| CAS | 200 | 1600 |
| 重型战斗机 | 100 | 800 |
| 舰载战斗机 | 100 | 800 |
| 舰载鱼雷机 | 100 | 800 |
| 海军巡逻轰炸机 | 50 | 400 |
| 洲际轰炸机 | 50 | 400 |
| 空天母舰 | 50 | 400 |

取整依据：

- 常规陆基飞机以 100 架空军联队为口径，轻战 5 个联队、CAS 2 个联队、重战 1 个联队。
- 舰载飞机以 10 架舰载联队为口径，每次给 10 个舰载联队。
- 海军巡逻轰炸机的空军联队规模为 10 架，每次给 5 个联队。
- 洲际轰炸机和空天母舰虽然联队规模为 100 架，但属于高成本后期装备，当前按半个联队的小批量补给。

#### 单装备效果

| 单装备效果 | 装备 key | 数量变量 | 数量 | 型号控制 |
| --- | --- | --- | ---: | --- |
| `JAP_ai_extra_air_equipment_grant_fighter_unit` | `small_plane_airframe` | `JAP_ai_extra_air_equipment_fighter_unit_amount` | 500 | `GetJAP_cr_small_plane_airframe` |
| `JAP_ai_extra_air_equipment_grant_cas_unit` | `small_plane_cas_airframe` | `JAP_ai_extra_air_equipment_cas_unit_amount` | 200 | `GetJAP_cr_small_plane_cas_airframe` |
| `JAP_ai_extra_air_equipment_grant_heavy_fighter_unit` | `medium_plane_fighter_airframe` | `JAP_ai_extra_air_equipment_heavy_fighter_unit_amount` | 100 | `GetJAP_cr_medium_plane_fighter_airframe` |
| `JAP_ai_extra_air_equipment_grant_cv_fighter_unit` | `cv_small_plane_airframe` | `JAP_ai_extra_air_equipment_cv_fighter_unit_amount` | 100 | `GetJAP_cr_cv_small_plane_airframe` |
| `JAP_ai_extra_air_equipment_grant_cv_naval_bomber_unit` | `cv_small_plane_naval_bomber_airframe` | `JAP_ai_extra_air_equipment_cv_naval_bomber_unit_amount` | 100 | `GetJAP_cr_cv_small_plane_naval_bomber_airframe` |
| `JAP_ai_extra_air_equipment_grant_maritime_patrol_plane_unit` | `large_plane_maritime_patrol_plane_airframe` | `JAP_ai_extra_air_equipment_maritime_patrol_plane_unit_amount` | 50 | `GetJAP_cr_large_plane_maritime_patrol_plane_airframe` |
| `JAP_ai_extra_air_equipment_grant_intercontinental_bomber_unit` | `strat_bomber_intercontinental_equipment_1` | `JAP_ai_extra_air_equipment_intercontinental_bomber_unit_amount` | 50 | 固定型号 |
| `JAP_ai_extra_air_equipment_grant_mothership_unit` | `mothership_equipment_0` | `JAP_ai_extra_air_equipment_mothership_unit_amount` | 50 | 固定型号 |

#### 装备型号控制

型号会变化的飞机采用 `meta_effect` + 脚本本地化拼接装备型号：

```txt
JAP_ai_extra_air_equipment_grant_fighter_unit = {
	meta_effect = {
		text = {
			add_equipment_to_stockpile = {
				type = small_plane_airframe_[JAP_ai_extra_air_equipment_text_small_plane_airframe]
				amount = JAP_ai_extra_air_equipment_fighter_unit_amount
				producer = ROOT
			}
		}
		JAP_ai_extra_air_equipment_text_small_plane_airframe = "[GetJAP_cr_small_plane_airframe]"
	}
}
```

规则：

- `GetJAP_cr_*` 只负责返回装备后缀，例如 `1/2/3/4/5`。
- `type = *_[...]` 拼出最终装备 key，例如 `small_plane_airframe_3`。
- 固定只有一个型号的特殊装备直接写具体装备 key。
- `amount` 读取预先初始化的国家变量。
- `producer = ROOT` 沿用陆军额外装备发放写法。

已存在并可复用的动态文本：

| 动态文本 | 对应装备 |
| --- | --- |
| `GetJAP_cr_small_plane_airframe` | 轻型战斗机 |
| `GetJAP_cr_small_plane_cas_airframe` | CAS |
| `GetJAP_cr_medium_plane_fighter_airframe` | 重型战斗机 |
| `GetJAP_cr_cv_small_plane_airframe` | 舰载战斗机 |
| `GetJAP_cr_cv_small_plane_naval_bomber_airframe` | 舰载鱼雷机 |
| `GetJAP_cr_large_plane_maritime_patrol_plane_airframe` | 海军巡逻轰炸机 |
| `GetJAP_cr_strat_bomber_intercontinental_equipment` | 洲际轰炸机 |
| `GetJAP_cr_mothership_equipment` | 空天母舰 |

`GetJAP_cr_mothership_equipment` 已存在；当前仍直接写固定 key，因为空天母舰当前只有 `mothership_equipment_0` 一个发放型号。

#### 总包

空军不需要中间分类包组。总包直接调用单装备效果，并在总包内部处理少数后期设计 flag。

| 总包效果 | 调用内容 |
| --- | --- |
| `JAP_ai_extra_air_equipment_grant_total_package` | 轻型战斗机、CAS、重型战斗机、舰载战斗机、舰载鱼雷机、海军巡逻轰炸机、洲际轰炸机、空天母舰 |

总包启用原则：

- 轻型战斗机、CAS、重型战斗机、舰载战斗机、舰载鱼雷机在 45 天循环启动后持续发放。
- 海军巡逻轰炸机只在已存在对应设计 flag 后发放。
- 洲际轰炸机只在 `JAP_has_cr_strat_bomber_intercontinental_equipment_1` 后发放。
- 空天母舰只在 `JAP_has_cr_mothership_equipment_0` 后发放。

当前落地写法：

```txt
JAP_ai_extra_air_equipment_grant_total_package = {
	JAP_ai_extra_air_equipment_grant_fighter_unit = yes
	JAP_ai_extra_air_equipment_grant_cas_unit = yes
	JAP_ai_extra_air_equipment_grant_heavy_fighter_unit = yes
	JAP_ai_extra_air_equipment_grant_cv_fighter_unit = yes
	JAP_ai_extra_air_equipment_grant_cv_naval_bomber_unit = yes

	if = {
		limit = {
			OR = {
				has_country_flag = JAP_has_cr_large_plane_maritime_patrol_plane_airframe_2
				has_country_flag = JAP_has_cr_large_plane_maritime_patrol_plane_airframe_3
				has_country_flag = JAP_has_cr_large_plane_maritime_patrol_plane_airframe_4
			}
		}
		JAP_ai_extra_air_equipment_grant_maritime_patrol_plane_unit = yes
	}
	if = {
		limit = { has_country_flag = JAP_has_cr_strat_bomber_intercontinental_equipment_1 }
		JAP_ai_extra_air_equipment_grant_intercontinental_bomber_unit = yes
	}
	if = {
		limit = { has_country_flag = JAP_has_cr_mothership_equipment_0 }
		JAP_ai_extra_air_equipment_grant_mothership_unit = yes
	}
}
```

#### 难度预期

空军装备种类不按难度分层。所有难度调用同一个总包，仅用调用倍率调节总量。

当前倍率规划：

| 难度 | 总包调用倍率 |
| --- | ---: |
| `EASY` | 1 |
| `NORMAL` | 1 |
| `HARD` | 2 |
| `LUNATIC` | 2 |
| `EXTRA` | 3 |
| `PHANTASM` | 3 |

对应总入口：

```txt
JAP_ai_extra_air_equipment_grant_cycle = {
	if = {
		limit = { Rance_nd_is_easy = yes }
		JAP_ai_extra_air_equipment_grant_multiplier_1 = yes
	}
	else_if = {
		limit = { Rance_nd_is_normal = yes }
		JAP_ai_extra_air_equipment_grant_multiplier_1 = yes
	}
	else_if = {
		limit = { Rance_nd_is_hard = yes }
		JAP_ai_extra_air_equipment_grant_multiplier_2 = yes
	}
	else_if = {
		limit = { Rance_nd_is_lunatic = yes }
		JAP_ai_extra_air_equipment_grant_multiplier_2 = yes
	}
	else_if = {
		limit = { Rance_nd_is_extra = yes }
		JAP_ai_extra_air_equipment_grant_multiplier_3 = yes
	}
	else_if = {
		limit = { Rance_nd_is_phantasm = yes }
		JAP_ai_extra_air_equipment_grant_multiplier_3 = yes
	}
}
```

后续若认为空军不需要按动态难度拉开总量，可把所有难度统一改成 `JAP_ai_extra_air_equipment_grant_multiplier_1 = yes`，不影响装备种类和型号逻辑。

#### 调参观察点

测试时重点看：

- AI 是否仍然会生产飞机，而不是完全依赖赠送。
- 轻型战斗机库存是否过早超过 `Rance_fighter_high_threshold`。
- CAS 是否能支撑大陆战场消耗，同时不挤占轻战数量。
- 舰载机是否明显过剩，尤其是日本航母数量不足时。
- 海军巡逻轰炸机是否在获得设计后库存过快堆高。
- 洲际轰炸机、空天母舰是否因小批量赠送仍然产生过高战略压力。
- 和平期是否囤货过多；如果囤货明显，优先在 `JAP_ai_extra_air_equipment_grant_cycle` 入口加 `has_war = yes`。

#### 落地顺序

已按以下顺序实现：

1. 在 `history/countries/JAP - Japan.txt` 初始化 8 个空军额外装备数量变量。
2. 在 `common/scripted_effects/JAP_equipment_scripted_effects.txt` 新增 8 个单装备效果。
3. 在同文件新增 `JAP_ai_extra_air_equipment_grant_total_package`。
4. 在同文件新增 `JAP_ai_extra_air_equipment_grant_multiplier_1/2/3` 和 `JAP_ai_extra_air_equipment_grant_cycle`。
5. 在陆空动态补给规则判断内追加 `JAP_ai_extra_air_equipment_grant_cycle = yes`。
6. 用 `rg` 检查变量名、效果名、flag 名是否一致。

#### 快速检查命令

```powershell
rg -n "JAP_ai_extra_air_equipment" history common
rg -n "GetJAP_cr_.*plane|JAP_has_cr_.*plane|JAP_has_cr_mothership|JAP_has_cr_strat_bomber" common/scripted_localisation common/scripted_effects common/decisions history
rg -n "rance_japan_ai_land_air_dynamic_supply|JAP_ai_extra_air_equipment_grant_cycle" common/decisions common/scripted_effects common/game_rules
```

重点看：

- 数量变量是否全部初始化。
- `meta_effect` 拼接出来的装备 key 是否能在原版 `common/script_enums.txt`、`common/units/equipment/` 或本 MOD 装备定义中找到。
- 海巡、洲际轰炸机、空天母舰是否有对应设计 flag 后才发放。
- 45 天 mission 是否仍只在陆空动态补给规则开启时调用发放。

#### 参考文件

- `CHANGELOG/ai_extra_equipment_plan.md`
- `Reference/ai_land_production_maintenance_reference.md`
- `common/decisions/JAP_rework_equipment_design_decision.txt`
- `common/scripted_effects/JAP_equipment_scripted_effects.txt`
- `common/scripted_localisation/JAP_equipment_scripted_loc.txt`
- `common/units/equipment/intercontinental_bomber.txt`
