# 模板刷兵脚本效果同步记录（2026-06-23）

## 修改范围

- `common/scripted_effects/JAP_templates_scripted_effects.txt`

## 本次新增

- 新增属国旧军清理模板创建效果：
  - `JAP_create_subject_old_army_cleanup_template`：创建锁定、废弃、仅含 `Rance_JAP_A_infantry` 的 `属国旧军清理编制`，供 MAN/小属国旧军清理流程把旧部队临时转入后删除。
- 新增基础步兵刷兵效果：
  - `JAP_start_basic_infantry`：在首都创建 10 个 `日本基础步兵师`。
  - `JAP_start_infantry`：在首都创建 10 个 `日本步兵师`。
- 新增装甲系列 5 师版本：
  - `JAP_start_infantry_tanks_5`
  - `JAP_start_experimental_infantry_tanks_5`
  - `JAP_start_special_infantry_tanks_5`
  - `JAP_start_mechanized_tanks_5`
  - `JAP_start_heavy_mechanized_tanks_5`
  - `JAP_start_amphibious_mechanized_tanks_5`
  - `JAP_start_heavy_amphibious_mechanized_tanks_5`
  - `JAP_start_land_crushier_5`
  - `JAP_start_marine_modern_mechanized_tanks_5`
  - `JAP_start_land_cruiser_marine_modern_mechanized_tanks_5`

## 同步提醒

- `JAP_templates_scripted_effects.txt` 是正式版的 `name_overlay` 文件，不要把中文版直接覆盖到英文版或日文版。
- 同步到英文版、日文版时，应在各自 overlay 文件中添加同名脚本效果，并把 `name = "..."`、`division_template = "..."` 内的硬编码模板名替换为该语言版本已经使用的对应模板名。
- `JAP_create_subject_old_army_cleanup_template` 不是日本 AI 的旧填线清理效果；不要把它和 `JAP_ai_cleanup_irregular_divisions_effect` 合并。日本继续删除落后的 `日本基础步兵师`，MAN/小属国旧军清理使用专用的 `属国旧军清理编制`。
- 5 师版本沿用原 10 师版本的经验与装备比例；两个陆巡相关效果继续使用 `start_experience_factor = 0.5`，其余为 `0.3`。
- `JAP_start_experimental_infantry_tanks` 原本就是 5 师；本次仍添加 `_5` 版本，方便调用方按统一命名检索整组 5 师效果。

## 正式版同步状态

2026-06-23 已同步到：

- `rance_jap_chinese/common/scripted_effects/JAP_templates_scripted_effects.txt`
- `rance_jap_english/common/scripted_effects/JAP_templates_scripted_effects.txt`
- `rance_jap_japenese/common/scripted_effects/JAP_templates_scripted_effects.txt`

正式版保留各自 overlay 名称：

- 中文清理模板：`属国旧军清理编制`
- 英文清理模板：`Subject Old Army Cleanup Template`
- 日文清理模板：`従属国旧軍整理用編制`

中文正式版的 `JAP_templates_scripted_effects.txt` 不保留独立脚本差异，直接以测试版 `Japan_rework` 同名文件为准。此前中文正式版后半段 `producer = ROOT`、直接 `has_tech = ...` 等差异属于遗漏记载项，已一并按测试版同步为 `producer = JAP` 与测试版科技判定写法。

同步后已检查：

- 新增 effect ID 在测试版与三份正式版均存在。
- 三份正式版目标文件保持 UTF-8 无 BOM、LF。
- `git diff --check` 通过。
