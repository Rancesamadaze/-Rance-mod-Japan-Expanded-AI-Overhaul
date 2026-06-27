# AI陆空额外补给刷师规划（归档）

状态：已归档。装备包主循环、刷师效果与三份正式版 overlay 已按本文口径实装；等待游戏内与 `error.log` 验证。

归档说明：本文保留为设计推导和落地记录。后续维护以 `Reference/ai_extra_equipment_maintenance_reference.md` 为主；正式版 overlay 同步记录见 `release_maintenance/ai_extra_equipment_units_overlay_2026-06-24.md`。

日期：2026-06-24

## 背景

当前 AI 陆空额外补给系统已经拆成独立 60 天循环：

- 入口决议：`common/decisions/JAP_rework_equipment_design_decision.txt`
- 陆军装备循环效果：`common/scripted_effects/JAP_equipment_scripted_effects.txt` 的 `JAP_ai_extra_equipment_grant_cycle`
- 模板与既有刷师样例：`common/scripted_effects/JAP_templates_scripted_effects.txt`

原系统主要发维护装备，能帮助 AI 训练和补缺，但不能立刻转化成前线部队。高难 MOD 中，AI 需要更直接的即战力，尤其是日本本土遭受入侵时，单纯发库存不适合作为防御机制复用。

## 设计原则

- 刷师必须接入 `JAP_ai_extra_equipment_grant_cycle` 的 `while_loop_effect` 内，吃 `JAP_ai_dynamic_final_multiplier`。
- 保持装备包和刷师同步随战争、投降进度、Boss 模式倍率增长。
- 尽量减少脚本数量，允许为了减少脚本数量妥协部分经验档位。
- 步兵师不太重要，所有难度共用一个低经验步兵脚本即可，定为0.3经验。
- 主力装甲师使用难度独立脚本控制经验，`PHANTASM` 装甲经验定为 `1.00`。
- 主力装甲师不做低难到高难的累加池；每个难度只刷本难度专属组合。
- 陆巡装甲师和现代装甲师作为“若模板可用”的附加槽，不纳入基础主力装甲数量递进。
- 首版允许比现行系统更强，但避免“满装备师 + 旧双倍库存包”叠加过强。

## 每 Tick 刷师规划

本文的 tick 指 `JAP_ai_dynamic_final_multiplier` 的单次 while 循环。实际每 60 天刷师量为本表乘以当时动态最终倍率。

| 难度 | 步兵师 | 基础主力装甲师 | 基础主力装甲数量 | 装甲经验 |
| --- | ---: | --- | ---: | ---: |
| `EASY` | `日本步兵师` x2 | 无 | 0 | - |
| `NORMAL` | `日本步兵师` x2 | `日本特种步坦师` x1 + `日本机坦师` x1 | 2 | 0.40 |
| `HARD` | `日本步兵师` x2 | `日本特种步坦师` x1 + `日本两栖机坦师` x2 | 3 | 0.55 |
| `LUNATIC` | `日本步兵师` x2 | `日本特种步坦师` x1 + `日本两栖重机坦师` x3 | 4 | 0.70 |
| `EXTRA` | `日本步兵师` x2 | `日本特种步坦师` x1 + `日本两栖重机坦师` x4 | 5 | 0.85 |
| `PHANTASM` | `日本步兵师` x2 | `日本特种步坦师` x1 + `日本两栖重机坦师` x5 | 6 | 1.00 |

步兵脚本统一使用 `start_experience_factor = 0.30`，包括 `PHANTASM`。高难真正的经验递进只体现在本难度装甲脚本中。

## 陆巡与现代附加槽

除 `EASY` 外，各难度装甲脚本可在末尾追加两个模板存在判定：

| 附加槽 | 条件 | 每 tick 数量 | 经验 |
| --- | --- | ---: | ---: |
| 陆巡装甲师 | `has_template = "日本陆巡两栖重机坦师"` | x2 | 使用当前难度装甲经验 |
| 现代装甲师 | `has_template = "日本海陆现代机坦师"` | x2 | 使用当前难度装甲经验 |

首版不默认刷 `日本陆巡海陆现代机坦师`。该模板同时吃陆巡和现代定位，强度更高，后续若要给 `PHANTASM` 单独追加，再作为独立增强项处理。

## 脚本数量规划

已新增 7 个效果：

| 效果名 | 内容 |
| --- | --- |
| `JAP_ai_extra_units_spawn_infantry_common` | 统一刷 `日本步兵师`，经验 `0.30` |
| `JAP_ai_extra_units_spawn_armor_normal` | `NORMAL` 装甲包，经验 `0.40` |
| `JAP_ai_extra_units_spawn_armor_hard` | `HARD` 装甲包，经验 `0.55` |
| `JAP_ai_extra_units_spawn_armor_lunatic` | `LUNATIC` 装甲包，经验 `0.70` |
| `JAP_ai_extra_units_spawn_armor_extra` | `EXTRA` 装甲包，经验 `0.85` |
| `JAP_ai_extra_units_spawn_armor_phantasm` | `PHANTASM` 装甲包，经验 `1.00` |
| `JAP_ai_extra_units_grant_cycle_by_difficulty` | 难度调度入口 |

刷师效果已放在 `common/scripted_effects/JAP_templates_scripted_effects.txt`，靠近既有 `JAP_start_*` 系列。难度调度入口从装备循环中调用。

## create_unit 写法

沿用项目现有 `capital_scope` 写法，新增效果内部使用模板存在判定，避免模板尚未创建时刷师失败。实装时沿用项目既有 `start_equipment_factor = 1.0` 写法，不额外加入未验证的 `start_manpower_factor`。

示例骨架：

```txt
if = {
    limit = { has_template = "日本步兵师" }
    capital_scope = {
        create_unit = {
            division = "division_template = \"日本步兵师\" start_experience_factor = 0.30 start_equipment_factor = 1.0"
            owner = prev
            count = 1
        }
    }
}
```

常规首都刷师不默认加入 `allow_spawning_on_enemy_provs = yes`。该参数只留给登陆突袭、敌占省刷兵或未来本土防御专用效果。

## 接入点

在 `JAP_ai_extra_equipment_grant_cycle` 的 `while_loop_effect` 内，装备发放后追加刷师：

```txt
while_loop_effect = {
    limit = {
        check_variable = { JAP_ai_dynamic_grant_loop < JAP.JAP_ai_dynamic_final_multiplier }
    }
    JAP_ai_extra_equipment_grant_cycle_by_difficulty = yes
    JAP_ai_extra_units_grant_cycle_by_difficulty = yes
    add_to_temp_variable = { JAP_ai_dynamic_grant_loop = 1 }
}
```

这样刷师吃和平、战争、日本投降进度和 Boss 模式共同决定的动态最终倍率。

## 装备包修正

加入满装备刷师后，装备包定位从“帮助 AI 造师”改为“1:1 维护本 tick 免费部队，并额外补少量损耗”。旧 `all_main_packages + main/line multiplier` 结构按“已启用装备族”发包，不按“本 tick 实际刷出的师”发包；在免费刷师接入后容易变成满装备师和旧库存包叠加。

新方案把 60 天陆军主循环改成“刷什么师，就给对应维护包”：

| 包 | 对应口径 | 调度 |
| --- | --- | --- |
| 步兵刷师维护包 | `日本步兵师` x2 | 全难度每 tick 调 1 次 |
| 特种步坦维护包 | `日本特种步坦师` x1 | `NORMAL+` 每 tick 调 1 次 |
| 机坦维护包 | `日本机坦师` x1 | `NORMAL` 每 tick 调 1 次 |
| 两栖机坦维护包 | `日本两栖机坦师` x1 | `HARD` 每 tick 调 2 次 |
| 重两栖维护包 | `日本两栖重机坦师` x1 | `LUNATIC / EXTRA / PHANTASM` 每 tick 调 `3 / 4 / 5` 次 |
| 陆巡附加包 | `日本陆巡两栖重机坦师` x1 完整包 | `NORMAL+` 若模板可用，每 tick 调 2 次 |
| 现代附加包 | `日本海陆现代机坦师` x1 完整包 | `NORMAL+` 若模板可用，每 tick 调 2 次 |

陆巡附加包和现代附加包是完整模板维护包，不是只补陆巡或现代坦克底盘。首版不默认发 `日本陆巡海陆现代机坦师` 的混合模板包。

## 每 Tick 维护包数值

数量按模板满装需求向上取整，优先保持整齐和可读。当前实现使用固定数值写在 cycle 包里，不新增一批历史变量，避免旧存档缺变量导致发放为 0。

常规装备：

| 包 | 步兵装备 | 支援 | 火炮 | 反坦 | 防空 | 摩托 | 机械化 | 两栖机械化 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 步兵 x2 | 5000 | 250 | 200 | 125 | 100 | 100 | 0 | 0 |
| 特种步坦 | 1600 | 80 | 0 | 0 | 0 | 25 | 0 | 0 |
| 机坦 | 850 | 80 | 0 | 0 | 0 | 25 | 350 | 0 |
| 两栖机坦 | 850 | 80 | 0 | 0 | 0 | 25 | 0 | 400 |
| 重两栖 | 1000 | 80 | 0 | 0 | 0 | 25 | 0 | 450 |
| 陆巡附加 | 1000 | 50 | 0 | 0 | 0 | 0 | 0 | 450 |
| 现代附加 | 1000 | 80 | 0 | 0 | 0 | 25 | 0 | 450 |

装甲与特殊装备：

| 包 | 主要补给 |
| --- | --- |
| 特种步坦 | 中坦 300、中坦歼 150、中自火 10、中防空 10、重坦歼 10、重防空 10、中喷火 15、装甲支援车 30、直升机 50 |
| 机坦 | 中坦 300、中坦歼 150、中自火 10、中防空 10、重坦歼 10、重防空 10、中喷火 15、装甲支援车 30、直升机 50 |
| 两栖机坦 | 两栖中坦 300、中坦歼 150、中自火 10、中防空 10、重坦歼 10、重防空 10、中喷火 15、装甲支援车 30、直升机 50 |
| 重两栖 | 两栖重坦 400、重坦歼 20、重自火 10、重防空 20、中喷火 15、装甲支援车 30、直升机 50 |
| 陆巡附加 | 两栖重坦 400、重坦歼 20、重自火 10、重防空 20、中喷火 15、装甲支援车 30、直升机 40、陆巡 1 |
| 现代附加 | 现代坦克 450、现代坦歼 20、现代自火 10、现代防空 20、中喷火 15、装甲支援车 30、直升机 50 |

新包直接覆盖旧主循环实用入口：

- 保留 `JAP_ai_extra_equipment_grant_cycle` 外层入口和动态倍率 while 循环。
- 保留开局、应急、非主循环使用的旧通用单装备效果和旧通用包。
- 重写 `JAP_ai_extra_equipment_grant_cycle_by_difficulty`，不再调用旧 `all_main_packages`、`main_multiplier_*`、`line_infantry_multiplier_*`。
- 新增 `motorized_equipment` 发放，因为免费模板实际需要摩托化装备，而旧 AI 额外装备包没有 60 天 cycle 卡车 grant。

## HARD 和平样本

假设：

- 当前难度为 `HARD`
- 日本处于和平
- Boss 模式无额外倍率
- `JAP_ai_dynamic_final_multiplier = 1`

则每 60 天执行 1 个 tick。

改后固定步兵刷师维护包为 x1：

| 装备 | 每 tick 发放 |
| --- | ---: |
| 当前动态步兵装备 | 5000 |
| 支援装备 | 250 |
| 当前动态火炮 | 200 |
| 当前动态反坦 | 125 |
| 当前动态防空 | 100 |
| 摩托化装备 | 100 |

基础装甲维护包为 `日本特种步坦师` x1 + `日本两栖机坦师` x2：

| 装备 | 每 tick 发放 |
| --- | ---: |
| 当前动态步兵装备 | 3300 |
| 支援装备 | 240 |
| 摩托化装备 | 75 |
| 两栖机械化装备 | 800 |
| 当前动态中坦 | 300 |
| 当前动态两栖中坦 | 600 |
| 当前动态中坦歼 | 450 |
| 当前动态中自火 | 30 |
| 当前动态中防空 | 30 |
| 当前动态重坦歼 | 30 |
| 当前动态重防空 | 30 |
| 当前动态中喷火坦 | 45 |
| 装甲支援车 | 90 |
| 直升机 | 150 |

刷师为：

| 师种 | 每 tick 数量 |
| --- | ---: |
| `日本步兵师` | 2 |
| `日本特种步坦师` | 1 |
| `日本两栖机坦师` | 2 |
| `日本陆巡两栖重机坦师` | 若模板可用则 +2 |
| `日本海陆现代机坦师` | 若模板可用则 +2 |

若陆巡模板可用，每 tick 额外给完整陆巡维护包 x2：两栖机械化 900、步兵装备 2000、两栖重坦 800、重坦歼 40、重自火 20、重防空 40、中喷火 30、装甲支援车 60、直升机 80、支援 100、陆巡 2。

若现代模板可用，每 tick 额外给完整现代维护包 x2：两栖机械化 900、步兵装备 2000、现代坦克 900、现代坦歼 40、现代自火 20、现代防空 40、中喷火 30、装甲支援车 60、直升机 100、支援 160、摩托 50。

这比现行 HARD 和平的“填线 x2 + 主战 x2 + 不刷师”强很多，但库存维护包已从旧倍率库存逻辑改成刷师同步逻辑，避免满装备师和旧双倍库存包同时堆叠。

## 落地状态

1. 已在 `common/scripted_effects/JAP_templates_scripted_effects.txt` 新增 6 个刷师效果和 1 个难度调度效果。
2. 已在 `common/scripted_effects/JAP_equipment_scripted_effects.txt` 的 `JAP_ai_extra_equipment_grant_cycle` while 循环内调用 `JAP_ai_extra_units_grant_cycle_by_difficulty`。
3. 已将 `JAP_ai_extra_equipment_grant_cycle_by_difficulty` 改为按免费模板调度 1:1 维护包；后续若改刷师表，必须同步改装备包调度。
4. 已同步更新 `Reference/ai_extra_equipment_maintenance_reference.md` 的 60 天循环说明、旧倍率说明和 HARD 样本。
5. 已按 `release_maintenance/ai_extra_equipment_units_overlay_2026-06-24.md` 同步三份正式版 overlay：中文正式版对齐 `Japan_rework`，英文/日文正式版保留各自模板硬编码名。
6. 待测试 `HARD` 和平单轮、`HARD` 战争单轮、`PHANTASM` 战争单轮，确认装备包和刷师数量都等于基础规划乘动态最终倍率。
7. 待检查 `error.log` 是否存在模板名、`create_unit`、`meta_effect` 或装备 key 报错。

## 待验证点

- 高难后期现代/陆巡附加槽是否过强；若过强，优先把附加槽限制到 `EXTRA` 和 `PHANTASM`。
- 新 cycle 装备包当前使用固定数值而不是历史变量，旧存档不会缺变量；若后续需要热调数值，再拆成 `JAP_ai_extra_equipment_cycle_*_amount` 变量。
- `meta_effect` 单包内多装备动态后缀需要通过 `error.log` 确认；若引擎不接受多后缀同包，退回为多个小 grant effect。
