# templates_JAP equipment requirement reference

统计来源：

- 模板文件：`common/ai_templates/templates_JAP.txt`
- 自定义陆军营：`common/units/JAP_army_units.txt`
- 自定义海军特战队营：`common/units/JAP_special_units.txt`
- 本 mod 覆盖单位：`common/units/artillery.txt`、`common/units/land_cruiser.txt`
- 原版单位参考：`D:\SteamLibrary\steamapps\common\Hearts of Iron IV\common\units`

统计口径：

- 每个模板按 `target_template` 中的 `regiments`、`support` 与 `regimental_support` 直接相乘统计。
- 装备 key 使用单位定义中的 `need = {}` 原始装备/底盘 key。
- 未计入科技、编制上限、装备变体可用性、AI 权重、经验花费或替换逻辑。
- 文件名与模板 key 保持原脚本拼写，例如 `infantry`、`defult`、`crushier`。

## 单营/支援连装备需求

| 营或支援连 key | 装备需求 |
| --- | --- |
| `Rance_JAP_A_infantry` | `infantry_equipment` x150 |
| `Rance_JAP_A_mechanized` | `infantry_equipment` x100, `mechanized_equipment` x40 |
| `Rance_JAP_A_medium_armor` | `medium_tank_chassis` x40 |
| `Rance_JAP_A_heavy_armor` | `heavy_tank_chassis` x40 |
| `Rance_JAP_A_medium_artillery_armor` | `medium_tank_artillery_chassis` x40 |
| `Rance_JAP_A_heavy_artillery_armor` | `heavy_tank_artillery_chassis` x40 |
| `Rance_JAP_A_medium_tankdestroyer` | `medium_tank_destroyer_chassis` x40 |
| `Rance_JAP_A_heavy_tankdestroyer` | `heavy_tank_destroyer_chassis` x40 |
| `Rance_JAP_A_medium_anti_air_armor` | `medium_tank_aa_chassis` x36 |
| `Rance_JAP_A_heavy_anti_air_armor` | `heavy_tank_aa_chassis` x36 |
| `Rance_JAP_A_medium_artillery_armor_support` | `medium_tank_artillery_chassis` x10 |
| `Rance_JAP_A_heavy_artillery_armor_support` | `heavy_tank_artillery_chassis` x10 |
| `Rance_JAP_A_medium_tankdestroyer_support` | `medium_tank_destroyer_chassis` x10 |
| `Rance_JAP_A_heavy_tankdestroyer_support` | `heavy_tank_destroyer_chassis` x10 |
| `Rance_JAP_A_medium_anti_air_armor_support` | `medium_tank_aa_chassis` x9 |
| `Rance_JAP_A_heavy_anti_air_armor_support` | `heavy_tank_aa_chassis` x9 |
| `Rance_JAP_M_infantry` | `infantry_equipment` x150 |
| `Rance_JAP_M_mechanized` | `amphibious_mechanized_equipment` x50, `infantry_equipment` x100 |
| `Rance_JAP_M_medium_armor` | `medium_tank_amphibious_chassis` x40 |
| `Rance_JAP_M_heavy_armor` | `heavy_tank_amphibious_chassis` x40 |
| `Rance_JAP_M_modern_armor` | `modern_tank_chassis` x45 |
| `Rance_JAP_M_medium_artillery_armor` | `medium_tank_artillery_chassis` x45 |
| `Rance_JAP_M_heavy_artillery_armor` | `heavy_tank_artillery_chassis` x45 |
| `Rance_JAP_M_modern_artillery_armor` | `modern_tank_artillery_chassis` x40 |
| `Rance_JAP_M_medium_tankdestroyer` | `medium_tank_destroyer_chassis` x45 |
| `Rance_JAP_M_heavy_tankdestroyer` | `heavy_tank_destroyer_chassis` x45 |
| `Rance_JAP_M_modern_tankdestroyer` | `modern_tank_destroyer_chassis` x45 |
| `Rance_JAP_M_medium_anti_air_armor` | `medium_tank_aa_chassis` x40 |
| `Rance_JAP_M_heavy_anti_air_armor` | `heavy_tank_aa_chassis` x40 |
| `Rance_JAP_M_modern_anti_air_armor` | `modern_tank_aa_chassis` x40 |
| `Rance_JAP_M_modern_artillery_armor_support` | `modern_tank_artillery_chassis` x10 |
| `Rance_JAP_M_modern_tankdestroyer_support` | `modern_tank_destroyer_chassis` x10 |
| `Rance_JAP_M_modern_anti_air_armor_support` | `modern_tank_aa_chassis` x10 |
| `artillery_brigade` | `artillery_equipment` x24 |
| `anti_air_brigade` | `anti_air_equipment` x36 |
| `anti_tank_brigade` | `anti_tank_equipment` x36 |
| `cavalry` | `infantry_equipment` x120 |
| `engineer` | `infantry_equipment` x10, `support_equipment` x30 |
| `artillery` | `artillery_equipment` x12 |
| `field_hospital` | `motorized_equipment` x20, `support_equipment` x30 |
| `recon` | `infantry_equipment` x40, `support_equipment` x10 |
| `logistics_company` | `motorized_equipment` x10, `support_equipment` x20 |
| `signal_company` | `motorized_equipment` x10, `support_equipment` x20 |
| `medium_flame_tank` | `medium_tank_flame_chassis` x15 |
| `helicopter_field_hospital` | `helicopter_equipment` x15, `motorized_equipment` x15, `support_equipment` x30 |
| `helicopter_recon` | `helicopter_equipment` x20, `infantry_equipment` x20, `support_equipment` x10 |
| `helicopter_transport` | `helicopter_equipment` x10, `motorized_equipment` x10, `support_equipment` x20 |
| `armored_engineer` | `armored_support_vehicle` x30, `support_equipment` x15 |
| `helicopter_brigade` | `helicopter_equipment` x15, `support_equipment` x15 |
| `land_cruiser` | `land_cruiser_chassis` x1 |
| `military_police` | `infantry_equipment` x40, `support_equipment` x10 |

## 模板总装备需求

### `JAP_basic_infantry`

基础步兵师。变体：`JAP_basic_infantry_default`

| 装备 key | 数量 |
| --- | ---: |
| `infantry_equipment` | 1510 |
| `artillery_equipment` | 12 |
| `support_equipment` | 30 |

### `JAP_infantry`

步兵。变体：`JAP_infantry_defult`

| 装备 key | 数量 |
| --- | ---: |
| `infantry_equipment` | 2300 |
| `artillery_equipment` | 72 |
| `anti_tank_equipment` | 72 |
| `anti_air_equipment` | 36 |
| `motorized_equipment` | 40 |
| `support_equipment` | 110 |

### `JAP_experimental_infantry_tank`

试验步坦师。变体：`JAP_experimental_infantry_tank_default`

| 装备 key | 数量 |
| --- | ---: |
| `infantry_equipment` | 2000 |
| `medium_tank_chassis` | 120 |
| `artillery_equipment` | 48 |
| `anti_tank_equipment` | 36 |
| `anti_air_equipment` | 36 |
| `motorized_equipment` | 40 |
| `support_equipment` | 110 |

### `JAP_infantry_tank`

步坦。变体：`JAP_infantry_tank_defult`

| 装备 key | 数量 |
| --- | ---: |
| `infantry_equipment` | 1220 |
| `medium_tank_chassis` | 280 |
| `medium_tank_destroyer_chassis` | 130 |
| `medium_tank_artillery_chassis` | 10 |
| `medium_tank_aa_chassis` | 18 |
| `heavy_tank_destroyer_chassis` | 10 |
| `medium_tank_flame_chassis` | 15 |
| `armored_support_vehicle` | 30 |
| `helicopter_equipment` | 45 |
| `motorized_equipment` | 25 |
| `support_equipment` | 75 |

### `JAP_special_infantry_tank`

特种步坦师。变体：`JAP_special_infantry_tank_default`

| 装备 key | 数量 |
| --- | ---: |
| `infantry_equipment` | 1520 |
| `medium_tank_chassis` | 280 |
| `medium_tank_destroyer_chassis` | 130 |
| `medium_tank_artillery_chassis` | 10 |
| `medium_tank_aa_chassis` | 9 |
| `heavy_tank_destroyer_chassis` | 10 |
| `heavy_tank_aa_chassis` | 9 |
| `medium_tank_flame_chassis` | 15 |
| `armored_support_vehicle` | 30 |
| `helicopter_equipment` | 45 |
| `motorized_equipment` | 25 |
| `support_equipment` | 75 |

### `JAP_mechanized_tank`

机坦。变体：`JAP_mechanized_tank_defult`

| 装备 key | 数量 |
| --- | ---: |
| `infantry_equipment` | 820 |
| `mechanized_equipment` | 320 |
| `medium_tank_chassis` | 280 |
| `medium_tank_destroyer_chassis` | 130 |
| `medium_tank_artillery_chassis` | 10 |
| `medium_tank_aa_chassis` | 9 |
| `heavy_tank_destroyer_chassis` | 10 |
| `heavy_tank_aa_chassis` | 9 |
| `medium_tank_flame_chassis` | 15 |
| `armored_support_vehicle` | 30 |
| `helicopter_equipment` | 45 |
| `motorized_equipment` | 25 |
| `support_equipment` | 75 |

### `JAP_mechanized_heavy_tank`

重机坦。变体：`JAP_mechanized_heavy_armor_defult`

| 装备 key | 数量 |
| --- | ---: |
| `infantry_equipment` | 920 |
| `mechanized_equipment` | 360 |
| `heavy_tank_chassis` | 360 |
| `heavy_tank_destroyer_chassis` | 20 |
| `heavy_tank_artillery_chassis` | 10 |
| `heavy_tank_aa_chassis` | 18 |
| `medium_tank_flame_chassis` | 15 |
| `armored_support_vehicle` | 30 |
| `helicopter_equipment` | 45 |
| `motorized_equipment` | 25 |
| `support_equipment` | 75 |

### `JAP_amphibious_mechanized`

两栖机坦。变体：`JAP_amphibious_mechanized_defult`

| 装备 key | 数量 |
| --- | ---: |
| `infantry_equipment` | 820 |
| `amphibious_mechanized_equipment` | 400 |
| `medium_tank_amphibious_chassis` | 280 |
| `medium_tank_destroyer_chassis` | 145 |
| `medium_tank_artillery_chassis` | 10 |
| `medium_tank_aa_chassis` | 9 |
| `heavy_tank_destroyer_chassis` | 10 |
| `heavy_tank_aa_chassis` | 9 |
| `medium_tank_flame_chassis` | 15 |
| `armored_support_vehicle` | 30 |
| `helicopter_equipment` | 45 |
| `motorized_equipment` | 25 |
| `support_equipment` | 75 |

### `JAP_heavy_amphibious_mechanized`

两栖重机坦。变体：`JAP_heavy_amphibious_mechanized_defult`

| 装备 key | 数量 |
| --- | ---: |
| `infantry_equipment` | 920 |
| `amphibious_mechanized_equipment` | 450 |
| `heavy_tank_amphibious_chassis` | 360 |
| `heavy_tank_destroyer_chassis` | 20 |
| `heavy_tank_artillery_chassis` | 10 |
| `heavy_tank_aa_chassis` | 18 |
| `medium_tank_flame_chassis` | 15 |
| `armored_support_vehicle` | 30 |
| `helicopter_equipment` | 45 |
| `motorized_equipment` | 25 |
| `support_equipment` | 75 |

### `JAP_land_crushier`

陆巡两栖重机坦。变体：`JAP_land_crushier_defult`

| 装备 key | 数量 |
| --- | ---: |
| `infantry_equipment` | 920 |
| `amphibious_mechanized_equipment` | 450 |
| `heavy_tank_amphibious_chassis` | 360 |
| `heavy_tank_destroyer_chassis` | 20 |
| `heavy_tank_artillery_chassis` | 10 |
| `heavy_tank_aa_chassis` | 18 |
| `medium_tank_flame_chassis` | 15 |
| `armored_support_vehicle` | 30 |
| `helicopter_equipment` | 35 |
| `land_cruiser_chassis` | 1 |
| `support_equipment` | 40 |

### `JAP_marine_modern_mechanized_tank`

海陆现代机坦师。变体：`JAP_marine_modern_mechanized_tank_default`

| 装备 key | 数量 |
| --- | ---: |
| `infantry_equipment` | 920 |
| `amphibious_mechanized_equipment` | 450 |
| `modern_tank_chassis` | 405 |
| `modern_tank_destroyer_chassis` | 20 |
| `modern_tank_artillery_chassis` | 10 |
| `modern_tank_aa_chassis` | 20 |
| `medium_tank_flame_chassis` | 15 |
| `armored_support_vehicle` | 30 |
| `helicopter_equipment` | 45 |
| `motorized_equipment` | 25 |
| `support_equipment` | 75 |

### `JAP_land_cruiser_marine_modern_mechanized_tank`

陆巡海陆现代机坦师。变体：`JAP_land_cruiser_marine_modern_mechanized_tank_default`

| 装备 key | 数量 |
| --- | ---: |
| `infantry_equipment` | 920 |
| `amphibious_mechanized_equipment` | 450 |
| `modern_tank_chassis` | 405 |
| `modern_tank_destroyer_chassis` | 20 |
| `modern_tank_artillery_chassis` | 10 |
| `modern_tank_aa_chassis` | 20 |
| `medium_tank_flame_chassis` | 15 |
| `armored_support_vehicle` | 30 |
| `helicopter_equipment` | 35 |
| `land_cruiser_chassis` | 1 |
| `support_equipment` | 40 |

### `JAP_suppression`

镇压。变体：`JAP_suppression`

| 装备 key | 数量 |
| --- | ---: |
| `infantry_equipment` | 3040 |
| `support_equipment` | 10 |
