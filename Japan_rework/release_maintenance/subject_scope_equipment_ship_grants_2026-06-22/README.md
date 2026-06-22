# 日本属国装备/舰船奖励脚本维护记录

创建日期：2026-06-22

本维护包记录一次面向日本特殊属国系统的奖励脚本预备改造。目标是让奖励效果可以由日本属国在 ROOT 作用域调用，同时仍以日本 `JAP` 作为装备生产者、舰船设计者、科技判断和设计旗标判断的来源。

## 覆盖范围

本次处理以下文件中的奖励发放逻辑：

- `common/scripted_effects/JAP_equipment_scripted_effects.txt`
- `common/scripted_effects/JAP_ai_navy_ship_grant_scripted_effects.txt`
- `common/scripted_effects/JAP_templates_scripted_effects.txt`

本维护包不处理以下内容：

- `common/scripted_effects/JAP_named_focus_scripted_effects.txt`
- `create_equipment_variant` 本体及其设计参数
- 新增属国专用脚本效果入口

## 同步规则

- `add_equipment_to_stockpile` 的接收者仍是当前 ROOT，但所有纳入范围的装备发放都显式使用 `producer = JAP`。
- 变量数量从日本读取，例如 `amount = JAP.JAP_ai_extra_...`，避免属国没有对应变量时读到空值。
- 日本科技、装备设计旗标、舰船设计旗标等条件判断放入 `JAP = { ... }` 作用域。
- `create_ship` 仍在 ROOT 下执行，让调用者拿到船；其中 `creator` 使用 `JAP`。
- 舰船年度包/循环倍率读取日本的 `JAP_ai_dynamic_final_multiplier`。
- 设计创建效果内的 `JAP_has_cr_*` 设旗块增加 `tag = JAP` 门槛：日本本体调用时照常设旗，日本属国调用时只创建设计，不写日本旗标。

## 备份

`backups/common/scripted_effects/` 保存了本次改动前的三个目标文件原文，用于未来维护英文版、日文版 overlay 文件时对照。

英文版和日文版同步时，请同步这里记录的脚本逻辑变化，但保留各目标语言文件中已有的硬编码显示名称、模板名称和本地化语义。
