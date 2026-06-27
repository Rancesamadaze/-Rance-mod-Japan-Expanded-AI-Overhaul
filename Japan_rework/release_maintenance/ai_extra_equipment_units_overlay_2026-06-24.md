# AI 陆空额外补给刷师 overlay 同步记录（2026-06-24）

## 修改范围

- `common/scripted_effects/JAP_equipment_scripted_effects.txt`
- `common/scripted_effects/JAP_templates_scripted_effects.txt`

这两个文件都是正式版 `name_overlay`。同步时不能把中文版整文件直接覆盖到英文版或日文版；只能同步本次逻辑块，并替换 `has_template = "..."` 与 `division_template = "..."` 里的硬编码模板名。

## 本次同步内容

- `JAP_equipment_scripted_effects.txt`
  - 将 60 天陆军主循环改为按免费刷师模板调度 1:1 维护包。
  - 同步 `JAP_ai_extra_equipment_grant_cycle_*_package` 系列新维护包。
  - 在 `JAP_ai_extra_equipment_grant_cycle` 的 while 循环中加入 `JAP_ai_extra_units_grant_cycle_by_difficulty = yes`。
- `JAP_templates_scripted_effects.txt`
  - 新增 `JAP_ai_extra_units_spawn_infantry_common`。
  - 新增 `JAP_ai_extra_units_spawn_armor_normal` 到 `JAP_ai_extra_units_spawn_armor_phantasm`。
  - 新增 `JAP_ai_extra_units_grant_cycle_by_difficulty`。

## 正式版目标

已同步到：

- `rance_jap_chinese/common/scripted_effects/JAP_equipment_scripted_effects.txt`
- `rance_jap_chinese/common/scripted_effects/JAP_templates_scripted_effects.txt`
- `rance_jap_english/common/scripted_effects/JAP_equipment_scripted_effects.txt`
- `rance_jap_english/common/scripted_effects/JAP_templates_scripted_effects.txt`
- `rance_jap_japenese/common/scripted_effects/JAP_equipment_scripted_effects.txt`
- `rance_jap_japenese/common/scripted_effects/JAP_templates_scripted_effects.txt`

中文正式版使用 `Japan_rework` 同名块作为源。英文、日文正式版保留各自 overlay 文件前部已有装备变体 `name = "..."`，只替换本次陆军 60 天维护包块与刷师块。

## 模板名替换表

| 中文 / 测试版 | 英文正式版 | 日文正式版 |
| --- | --- | --- |
| `日本步兵师` | `Japanese Infantry Division` | `日本歩兵師団` |
| `日本特种步坦师` | `Japanese Special Infantry-Tank Division` | `日本特殊歩戦師団` |
| `日本机坦师` | `Japanese Mechanized Tank Division` | `日本機械化戦車師団` |
| `日本两栖机坦师` | `Japanese Amphibious Mechanized Tank Division` | `日本水陸両用機械化戦車師団` |
| `日本两栖重机坦师` | `Japanese Heavy Amphibious Mechanized Tank Division` | `日本水陸両用重機械化戦車師団` |
| `日本陆巡两栖重机坦师` | `Japanese Land Cruiser Heavy Amphibious Mechanized Division` | `日本陸上巡洋艦水陸両用重機械化戦車師団` |
| `日本海陆现代机坦师` | `Japanese Marine Modern Mechanized Tank Division` | `日本海軍現代機械化戦車師団` |

## 检查结果

- 三份正式版均存在 `JAP_ai_extra_units_grant_cycle_by_difficulty` 与 6 个 `JAP_ai_extra_units_spawn_*` 效果。
- 三份正式版装备循环均已在 `JAP_ai_extra_equipment_grant_cycle` 中调用 `JAP_ai_extra_units_grant_cycle_by_difficulty`。
- 英文、日文正式版目标块未残留中文模板名。
- 目标文件保持 UTF-8 无 BOM、LF。

## 后续验证

- 仍需进游戏或读取 `error.log` 验证 `create_unit`、`has_template`、`meta_effect` 动态装备 key 是否无报错。
- 原始设计计划已归档到 `Reference/ai_extra_equipment_units_plan_archive.md`；后续维护以 `Reference/ai_extra_equipment_maintenance_reference.md` 为准。
- 若后续改动每 tick 刷师表，必须同时改 `JAP_equipment_scripted_effects.txt` 的 1:1 维护包调度，并按本表重新同步三份正式版 overlay。
