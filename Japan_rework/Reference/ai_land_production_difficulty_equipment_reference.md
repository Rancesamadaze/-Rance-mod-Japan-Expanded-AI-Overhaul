# AI 陆军生产难度装备需求参考

统计来源：

- `Reference/route_difficulty_scripted_trigger.md`
- `Reference/template_JAP_equipment_requirements.md`

统计口径：

- 本文只整理“AI 编制分配草案”中按难度出现的装甲/机械化相关编制。
- 基础步兵、镇压等不在难度分配表中的通用模板未纳入本表。
- 装备 key 使用 `template_JAP_equipment_requirements.md` 中的原始装备/底盘 key。
- `motorized_equipment` 虽然出现在模板需求中，但已移出当前陆军 AI 装备调产体系，后续与火车一起单独设计。

## 难度到编制映射

| 难度 | 编制 |
| --- | --- |
| `EASY` | `JAP_infantry_tank`, `JAP_special_infantry_tank` |
| `NORMAL` | `JAP_special_infantry_tank`, `JAP_mechanized_tank`, `JAP_marine_modern_mechanized_tank` |
| `HARD` | `JAP_special_infantry_tank`, `JAP_mechanized_tank`, `JAP_amphibious_mechanized`, `JAP_marine_modern_mechanized_tank` |
| `LUNATIC` | `JAP_special_infantry_tank`, `JAP_mechanized_tank`, `JAP_amphibious_mechanized`, `JAP_marine_modern_mechanized_tank`, `JAP_mechanized_heavy_tank`, `JAP_heavy_amphibious_mechanized` |
| `EXTRA` | `JAP_special_infantry_tank`, `JAP_mechanized_tank`, `JAP_amphibious_mechanized`, `JAP_marine_modern_mechanized_tank`, `JAP_mechanized_heavy_tank`, `JAP_heavy_amphibious_mechanized`, `JAP_land_crushier`, `JAP_land_cruiser_marine_modern_mechanized_tank` |
| `PHANTASM` | 暂时与 `EXTRA` 相同 |

## 各难度装备需求

### EASY

| 装备 key | 来源编制 |
| --- | --- |
| `infantry_equipment` | `JAP_infantry_tank`, `JAP_special_infantry_tank` |
| `medium_tank_chassis` | `JAP_infantry_tank`, `JAP_special_infantry_tank` |
| `medium_tank_destroyer_chassis` | `JAP_infantry_tank`, `JAP_special_infantry_tank` |
| `medium_tank_artillery_chassis` | `JAP_infantry_tank`, `JAP_special_infantry_tank` |
| `medium_tank_aa_chassis` | `JAP_infantry_tank`, `JAP_special_infantry_tank` |
| `heavy_tank_destroyer_chassis` | `JAP_infantry_tank`, `JAP_special_infantry_tank` |
| `heavy_tank_aa_chassis` | `JAP_special_infantry_tank` |
| `medium_tank_flame_chassis` | `JAP_infantry_tank`, `JAP_special_infantry_tank` |
| `armored_support_vehicle` | `JAP_infantry_tank`, `JAP_special_infantry_tank` |
| `helicopter_equipment` | `JAP_infantry_tank`, `JAP_special_infantry_tank` |
| `support_equipment` | `JAP_infantry_tank`, `JAP_special_infantry_tank` |
| `motorized_equipment` | `JAP_infantry_tank`, `JAP_special_infantry_tank` |

### NORMAL

| 装备 key | 来源编制 |
| --- | --- |
| `infantry_equipment` | `JAP_special_infantry_tank`, `JAP_mechanized_tank`, `JAP_marine_modern_mechanized_tank` |
| `mechanized_equipment` | `JAP_mechanized_tank` |
| `amphibious_mechanized_equipment` | `JAP_marine_modern_mechanized_tank` |
| `medium_tank_chassis` | `JAP_special_infantry_tank`, `JAP_mechanized_tank` |
| `modern_tank_chassis` | `JAP_marine_modern_mechanized_tank` |
| `medium_tank_destroyer_chassis` | `JAP_special_infantry_tank`, `JAP_mechanized_tank` |
| `heavy_tank_destroyer_chassis` | `JAP_special_infantry_tank`, `JAP_mechanized_tank` |
| `modern_tank_destroyer_chassis` | `JAP_marine_modern_mechanized_tank` |
| `medium_tank_artillery_chassis` | `JAP_special_infantry_tank`, `JAP_mechanized_tank` |
| `modern_tank_artillery_chassis` | `JAP_marine_modern_mechanized_tank` |
| `medium_tank_aa_chassis` | `JAP_special_infantry_tank`, `JAP_mechanized_tank` |
| `heavy_tank_aa_chassis` | `JAP_special_infantry_tank`, `JAP_mechanized_tank` |
| `modern_tank_aa_chassis` | `JAP_marine_modern_mechanized_tank` |
| `medium_tank_flame_chassis` | `JAP_special_infantry_tank`, `JAP_mechanized_tank`, `JAP_marine_modern_mechanized_tank` |
| `armored_support_vehicle` | `JAP_special_infantry_tank`, `JAP_mechanized_tank`, `JAP_marine_modern_mechanized_tank` |
| `helicopter_equipment` | `JAP_special_infantry_tank`, `JAP_mechanized_tank`, `JAP_marine_modern_mechanized_tank` |
| `support_equipment` | `JAP_special_infantry_tank`, `JAP_mechanized_tank`, `JAP_marine_modern_mechanized_tank` |
| `motorized_equipment` | `JAP_special_infantry_tank`, `JAP_mechanized_tank`, `JAP_marine_modern_mechanized_tank` |

### HARD

| 装备 key | 来源编制 |
| --- | --- |
| `infantry_equipment` | `JAP_special_infantry_tank`, `JAP_mechanized_tank`, `JAP_amphibious_mechanized`, `JAP_marine_modern_mechanized_tank` |
| `mechanized_equipment` | `JAP_mechanized_tank` |
| `amphibious_mechanized_equipment` | `JAP_amphibious_mechanized`, `JAP_marine_modern_mechanized_tank` |
| `medium_tank_chassis` | `JAP_special_infantry_tank`, `JAP_mechanized_tank` |
| `medium_tank_amphibious_chassis` | `JAP_amphibious_mechanized` |
| `modern_tank_chassis` | `JAP_marine_modern_mechanized_tank` |
| `medium_tank_destroyer_chassis` | `JAP_special_infantry_tank`, `JAP_mechanized_tank`, `JAP_amphibious_mechanized` |
| `heavy_tank_destroyer_chassis` | `JAP_special_infantry_tank`, `JAP_mechanized_tank`, `JAP_amphibious_mechanized` |
| `modern_tank_destroyer_chassis` | `JAP_marine_modern_mechanized_tank` |
| `medium_tank_artillery_chassis` | `JAP_special_infantry_tank`, `JAP_mechanized_tank`, `JAP_amphibious_mechanized` |
| `modern_tank_artillery_chassis` | `JAP_marine_modern_mechanized_tank` |
| `medium_tank_aa_chassis` | `JAP_special_infantry_tank`, `JAP_mechanized_tank`, `JAP_amphibious_mechanized` |
| `heavy_tank_aa_chassis` | `JAP_special_infantry_tank`, `JAP_mechanized_tank`, `JAP_amphibious_mechanized` |
| `modern_tank_aa_chassis` | `JAP_marine_modern_mechanized_tank` |
| `medium_tank_flame_chassis` | `JAP_special_infantry_tank`, `JAP_mechanized_tank`, `JAP_amphibious_mechanized`, `JAP_marine_modern_mechanized_tank` |
| `armored_support_vehicle` | `JAP_special_infantry_tank`, `JAP_mechanized_tank`, `JAP_amphibious_mechanized`, `JAP_marine_modern_mechanized_tank` |
| `helicopter_equipment` | `JAP_special_infantry_tank`, `JAP_mechanized_tank`, `JAP_amphibious_mechanized`, `JAP_marine_modern_mechanized_tank` |
| `support_equipment` | `JAP_special_infantry_tank`, `JAP_mechanized_tank`, `JAP_amphibious_mechanized`, `JAP_marine_modern_mechanized_tank` |
| `motorized_equipment` | `JAP_special_infantry_tank`, `JAP_mechanized_tank`, `JAP_amphibious_mechanized`, `JAP_marine_modern_mechanized_tank` |

### LUNATIC

| 装备 key | 来源编制 |
| --- | --- |
| `infantry_equipment` | `JAP_special_infantry_tank`, `JAP_mechanized_tank`, `JAP_amphibious_mechanized`, `JAP_marine_modern_mechanized_tank`, `JAP_mechanized_heavy_tank`, `JAP_heavy_amphibious_mechanized` |
| `mechanized_equipment` | `JAP_mechanized_tank`, `JAP_mechanized_heavy_tank` |
| `amphibious_mechanized_equipment` | `JAP_amphibious_mechanized`, `JAP_marine_modern_mechanized_tank`, `JAP_heavy_amphibious_mechanized` |
| `medium_tank_chassis` | `JAP_special_infantry_tank`, `JAP_mechanized_tank` |
| `heavy_tank_chassis` | `JAP_mechanized_heavy_tank` |
| `medium_tank_amphibious_chassis` | `JAP_amphibious_mechanized` |
| `heavy_tank_amphibious_chassis` | `JAP_heavy_amphibious_mechanized` |
| `modern_tank_chassis` | `JAP_marine_modern_mechanized_tank` |
| `medium_tank_destroyer_chassis` | `JAP_special_infantry_tank`, `JAP_mechanized_tank`, `JAP_amphibious_mechanized` |
| `heavy_tank_destroyer_chassis` | `JAP_special_infantry_tank`, `JAP_mechanized_tank`, `JAP_amphibious_mechanized`, `JAP_mechanized_heavy_tank`, `JAP_heavy_amphibious_mechanized` |
| `modern_tank_destroyer_chassis` | `JAP_marine_modern_mechanized_tank` |
| `medium_tank_artillery_chassis` | `JAP_special_infantry_tank`, `JAP_mechanized_tank`, `JAP_amphibious_mechanized` |
| `heavy_tank_artillery_chassis` | `JAP_mechanized_heavy_tank`, `JAP_heavy_amphibious_mechanized` |
| `modern_tank_artillery_chassis` | `JAP_marine_modern_mechanized_tank` |
| `medium_tank_aa_chassis` | `JAP_special_infantry_tank`, `JAP_mechanized_tank`, `JAP_amphibious_mechanized` |
| `heavy_tank_aa_chassis` | `JAP_special_infantry_tank`, `JAP_mechanized_tank`, `JAP_amphibious_mechanized`, `JAP_mechanized_heavy_tank`, `JAP_heavy_amphibious_mechanized` |
| `modern_tank_aa_chassis` | `JAP_marine_modern_mechanized_tank` |
| `medium_tank_flame_chassis` | all listed templates |
| `armored_support_vehicle` | all listed templates |
| `helicopter_equipment` | all listed templates |
| `support_equipment` | all listed templates |
| `motorized_equipment` | all listed templates |

### EXTRA / PHANTASM

`PHANTASM` 当前暂时使用与 `EXTRA` 相同的编制集合和装备需求。

| 装备 key | 来源编制 |
| --- | --- |
| `infantry_equipment` | all listed templates |
| `mechanized_equipment` | `JAP_mechanized_tank`, `JAP_mechanized_heavy_tank` |
| `amphibious_mechanized_equipment` | `JAP_amphibious_mechanized`, `JAP_marine_modern_mechanized_tank`, `JAP_heavy_amphibious_mechanized`, `JAP_land_crushier`, `JAP_land_cruiser_marine_modern_mechanized_tank` |
| `medium_tank_chassis` | `JAP_special_infantry_tank`, `JAP_mechanized_tank` |
| `heavy_tank_chassis` | `JAP_mechanized_heavy_tank` |
| `medium_tank_amphibious_chassis` | `JAP_amphibious_mechanized` |
| `heavy_tank_amphibious_chassis` | `JAP_heavy_amphibious_mechanized`, `JAP_land_crushier` |
| `modern_tank_chassis` | `JAP_marine_modern_mechanized_tank`, `JAP_land_cruiser_marine_modern_mechanized_tank` |
| `land_cruiser_chassis` | `JAP_land_crushier`, `JAP_land_cruiser_marine_modern_mechanized_tank` |
| `medium_tank_destroyer_chassis` | `JAP_special_infantry_tank`, `JAP_mechanized_tank`, `JAP_amphibious_mechanized` |
| `heavy_tank_destroyer_chassis` | `JAP_special_infantry_tank`, `JAP_mechanized_tank`, `JAP_amphibious_mechanized`, `JAP_mechanized_heavy_tank`, `JAP_heavy_amphibious_mechanized`, `JAP_land_crushier` |
| `modern_tank_destroyer_chassis` | `JAP_marine_modern_mechanized_tank`, `JAP_land_cruiser_marine_modern_mechanized_tank` |
| `medium_tank_artillery_chassis` | `JAP_special_infantry_tank`, `JAP_mechanized_tank`, `JAP_amphibious_mechanized` |
| `heavy_tank_artillery_chassis` | `JAP_mechanized_heavy_tank`, `JAP_heavy_amphibious_mechanized`, `JAP_land_crushier` |
| `modern_tank_artillery_chassis` | `JAP_marine_modern_mechanized_tank`, `JAP_land_cruiser_marine_modern_mechanized_tank` |
| `medium_tank_aa_chassis` | `JAP_special_infantry_tank`, `JAP_mechanized_tank`, `JAP_amphibious_mechanized` |
| `heavy_tank_aa_chassis` | `JAP_special_infantry_tank`, `JAP_mechanized_tank`, `JAP_amphibious_mechanized`, `JAP_mechanized_heavy_tank`, `JAP_heavy_amphibious_mechanized`, `JAP_land_crushier` |
| `modern_tank_aa_chassis` | `JAP_marine_modern_mechanized_tank`, `JAP_land_cruiser_marine_modern_mechanized_tank` |
| `medium_tank_flame_chassis` | all listed templates |
| `armored_support_vehicle` | all listed templates |
| `helicopter_equipment` | all listed templates |
| `support_equipment` | all listed templates |
| `motorized_equipment` | all listed templates except `JAP_land_crushier` and `JAP_land_cruiser_marine_modern_mechanized_tank` |

## 装备出现难度速查

用于编写非通用装备的 `should_start_increase` 难度门槛。

| 装备 key | 最低出现难度 | 建议 start 判定附加条件 |
| --- | --- | --- |
| `infantry_equipment` | `EASY` | 无额外难度条件 |
| `medium_tank_chassis` | `EASY` | 无额外难度条件 |
| `medium_tank_destroyer_chassis` | `EASY` | 无额外难度条件 |
| `heavy_tank_destroyer_chassis` | `EASY` | 无额外难度条件 |
| `medium_tank_artillery_chassis` | `EASY` | 无额外难度条件 |
| `medium_tank_aa_chassis` | `EASY` | 无额外难度条件 |
| `heavy_tank_aa_chassis` | `EASY` | 无额外难度条件 |
| `medium_tank_flame_chassis` | `EASY` | 无额外难度条件 |
| `armored_support_vehicle` | `EASY` | 无额外难度条件 |
| `helicopter_equipment` | `EASY` | 无额外难度条件 |
| `support_equipment` | `EASY` | 无额外难度条件 |
| `mechanized_equipment` | `NORMAL` | `Rance_nd_more_than_easy = yes` |
| `amphibious_mechanized_equipment` | `NORMAL` | `Rance_nd_more_than_easy = yes` |
| `modern_tank_chassis` | `NORMAL` | `Rance_nd_more_than_easy = yes` |
| `modern_tank_destroyer_chassis` | `NORMAL` | `Rance_nd_more_than_easy = yes` |
| `modern_tank_artillery_chassis` | `NORMAL` | `Rance_nd_more_than_easy = yes` |
| `modern_tank_aa_chassis` | `NORMAL` | `Rance_nd_more_than_easy = yes` |
| `medium_tank_amphibious_chassis` | `HARD` | `Rance_nd_more_than_normal = yes` |
| `heavy_tank_chassis` | `LUNATIC` | `Rance_nd_more_than_hard = yes` |
| `heavy_tank_amphibious_chassis` | `LUNATIC` | `Rance_nd_more_than_hard = yes` |
| `heavy_tank_artillery_chassis` | `LUNATIC` | `Rance_nd_more_than_hard = yes` |
| `land_cruiser_chassis` | `EXTRA` | `Rance_nd_more_than_lunatic = yes` |

## 调产体系备注

- `motorized_equipment` 不在当前陆军装备调产体系中，不应按本表生成 start 判定。
- 非自行火炮、反坦、防空炮不在本难度编制草案中出现，但在基础步兵模板中存在；当前计划为只减产不增产。
- `PHANTASM` 目前暂时等同 `EXTRA`；如果后续新增专属编制，需要单独更新本表。
