# Flag Reference

本文档用于归纳未来新增的各类 flag。

## 装备设计创建 flag

来源：`common/scripted_effects/JAP_equipment_scripted_effects.txt`

用途：在 `create_equipment_variant` 创建完装备设计后，同步设置国家 flag，表示该级别装备设计已创建。

命名规则：

```txt
JAP_has_cr_<type>
```

其中 `<type>` 来自同一 scripted effect 内 `create_equipment_variant` 的 `type`。同一 `type` 的多个 scripted effect 必须使用同一个 flag。

标准写法：

```txt
if = {
    limit = {
        JAP = {
            NOT = {
                has_country_flag = JAP_has_cr_<type>
            }
        }
    }
    JAP = {
        set_country_flag = JAP_has_cr_<type>
    }
}
```

### 陆军车辆底盘

| Type | Flag |
| --- | --- |
| `heavy_tank_aa_chassis_1` | `JAP_has_cr_heavy_tank_aa_chassis_1` |
| `heavy_tank_aa_chassis_2` | `JAP_has_cr_heavy_tank_aa_chassis_2` |
| `heavy_tank_aa_chassis_3` | `JAP_has_cr_heavy_tank_aa_chassis_3` |
| `heavy_tank_amphibious_chassis_1` | `JAP_has_cr_heavy_tank_amphibious_chassis_1` |
| `heavy_tank_amphibious_chassis_2` | `JAP_has_cr_heavy_tank_amphibious_chassis_2` |
| `heavy_tank_amphibious_chassis_3` | `JAP_has_cr_heavy_tank_amphibious_chassis_3` |
| `heavy_tank_artillery_chassis_1` | `JAP_has_cr_heavy_tank_artillery_chassis_1` |
| `heavy_tank_artillery_chassis_2` | `JAP_has_cr_heavy_tank_artillery_chassis_2` |
| `heavy_tank_artillery_chassis_3` | `JAP_has_cr_heavy_tank_artillery_chassis_3` |
| `heavy_tank_chassis_1` | `JAP_has_cr_heavy_tank_chassis_1` |
| `heavy_tank_chassis_2` | `JAP_has_cr_heavy_tank_chassis_2` |
| `heavy_tank_chassis_3` | `JAP_has_cr_heavy_tank_chassis_3` |
| `heavy_tank_destroyer_chassis_1` | `JAP_has_cr_heavy_tank_destroyer_chassis_1` |
| `heavy_tank_destroyer_chassis_2` | `JAP_has_cr_heavy_tank_destroyer_chassis_2` |
| `heavy_tank_destroyer_chassis_3` | `JAP_has_cr_heavy_tank_destroyer_chassis_3` |
| `land_cruiser_chassis_1` | `JAP_has_cr_land_cruiser_chassis_1` |
| `medium_tank_aa_chassis_1` | `JAP_has_cr_medium_tank_aa_chassis_1` |
| `medium_tank_aa_chassis_2` | `JAP_has_cr_medium_tank_aa_chassis_2` |
| `medium_tank_aa_chassis_3` | `JAP_has_cr_medium_tank_aa_chassis_3` |
| `medium_tank_amphibious_chassis_1` | `JAP_has_cr_medium_tank_amphibious_chassis_1` |
| `medium_tank_amphibious_chassis_2` | `JAP_has_cr_medium_tank_amphibious_chassis_2` |
| `medium_tank_amphibious_chassis_3` | `JAP_has_cr_medium_tank_amphibious_chassis_3` |
| `medium_tank_artillery_chassis_1` | `JAP_has_cr_medium_tank_artillery_chassis_1` |
| `medium_tank_artillery_chassis_2` | `JAP_has_cr_medium_tank_artillery_chassis_2` |
| `medium_tank_artillery_chassis_3` | `JAP_has_cr_medium_tank_artillery_chassis_3` |
| `medium_tank_chassis_0` | `JAP_has_cr_medium_tank_chassis_0` |
| `medium_tank_chassis_1` | `JAP_has_cr_medium_tank_chassis_1` |
| `medium_tank_chassis_2` | `JAP_has_cr_medium_tank_chassis_2` |
| `medium_tank_chassis_3` | `JAP_has_cr_medium_tank_chassis_3` |
| `medium_tank_destroyer_chassis_1` | `JAP_has_cr_medium_tank_destroyer_chassis_1` |
| `medium_tank_destroyer_chassis_2` | `JAP_has_cr_medium_tank_destroyer_chassis_2` |
| `medium_tank_destroyer_chassis_3` | `JAP_has_cr_medium_tank_destroyer_chassis_3` |
| `medium_tank_flame_chassis_1` | `JAP_has_cr_medium_tank_flame_chassis_1` |
| `medium_tank_flame_chassis_2` | `JAP_has_cr_medium_tank_flame_chassis_2` |
| `modern_tank_aa_chassis_1` | `JAP_has_cr_modern_tank_aa_chassis_1` |
| `modern_tank_artillery_chassis_1` | `JAP_has_cr_modern_tank_artillery_chassis_1` |
| `modern_tank_chassis_1` | `JAP_has_cr_modern_tank_chassis_1` |
| `modern_tank_destroyer_chassis_1` | `JAP_has_cr_modern_tank_destroyer_chassis_1` |

### 航空器机体

| Type | Flag |
| --- | --- |
| `cv_small_plane_airframe_1` | `JAP_has_cr_cv_small_plane_airframe_1` |
| `cv_small_plane_airframe_2` | `JAP_has_cr_cv_small_plane_airframe_2` |
| `cv_small_plane_airframe_3` | `JAP_has_cr_cv_small_plane_airframe_3` |
| `cv_small_plane_airframe_4` | `JAP_has_cr_cv_small_plane_airframe_4` |
| `cv_small_plane_naval_bomber_airframe_1` | `JAP_has_cr_cv_small_plane_naval_bomber_airframe_1` |
| `cv_small_plane_naval_bomber_airframe_2` | `JAP_has_cr_cv_small_plane_naval_bomber_airframe_2` |
| `cv_small_plane_naval_bomber_airframe_3` | `JAP_has_cr_cv_small_plane_naval_bomber_airframe_3` |
| `cv_small_plane_naval_bomber_airframe_4` | `JAP_has_cr_cv_small_plane_naval_bomber_airframe_4` |
| `large_plane_maritime_patrol_plane_airframe_2` | `JAP_has_cr_large_plane_maritime_patrol_plane_airframe_2` |
| `large_plane_maritime_patrol_plane_airframe_3` | `JAP_has_cr_large_plane_maritime_patrol_plane_airframe_3` |
| `large_plane_maritime_patrol_plane_airframe_4` | `JAP_has_cr_large_plane_maritime_patrol_plane_airframe_4` |
| `medium_plane_fighter_airframe_1` | `JAP_has_cr_medium_plane_fighter_airframe_1` |
| `medium_plane_fighter_airframe_2` | `JAP_has_cr_medium_plane_fighter_airframe_2` |
| `medium_plane_fighter_airframe_3` | `JAP_has_cr_medium_plane_fighter_airframe_3` |
| `medium_plane_fighter_airframe_4` | `JAP_has_cr_medium_plane_fighter_airframe_4` |
| `small_plane_airframe_1` | `JAP_has_cr_small_plane_airframe_1` |
| `small_plane_airframe_2` | `JAP_has_cr_small_plane_airframe_2` |
| `small_plane_airframe_3` | `JAP_has_cr_small_plane_airframe_3` |
| `small_plane_airframe_4` | `JAP_has_cr_small_plane_airframe_4` |
| `small_plane_airframe_5` | `JAP_has_cr_small_plane_airframe_5` |
| `small_plane_cas_airframe_1` | `JAP_has_cr_small_plane_cas_airframe_1` |
| `small_plane_cas_airframe_2` | `JAP_has_cr_small_plane_cas_airframe_2` |
| `small_plane_cas_airframe_3` | `JAP_has_cr_small_plane_cas_airframe_3` |
| `small_plane_cas_airframe_4` | `JAP_has_cr_small_plane_cas_airframe_4` |
| `small_plane_cas_airframe_5` | `JAP_has_cr_small_plane_cas_airframe_5` |
| `strat_bomber_intercontinental_equipment_1` | `JAP_has_cr_strat_bomber_intercontinental_equipment_1` |

### 机动与特殊装备

| Type | Flag |
| --- | --- |
| `amphibious_mechanized_equipment_1` | `JAP_has_cr_amphibious_mechanized_equipment_1` |
| `amphibious_mechanized_equipment_2` | `JAP_has_cr_amphibious_mechanized_equipment_2` |
| `mechanized_equipment_1` | `JAP_has_cr_mechanized_equipment_1` |
| `mechanized_equipment_2` | `JAP_has_cr_mechanized_equipment_2` |
| `mechanized_equipment_3` | `JAP_has_cr_mechanized_equipment_3` |
| `mothership_equipment_0` | `JAP_has_cr_mothership_equipment_0` |

### 海军舰体

| Type | Flag |
| --- | --- |
| `ship_hull_carrier_1` | `JAP_has_cr_ship_hull_carrier_1` |
| `ship_hull_carrier_2` | `JAP_has_cr_ship_hull_carrier_2` |
| `ship_hull_carrier_3` | `JAP_has_cr_ship_hull_carrier_3` |
| `ship_hull_carrier_modern` | `JAP_has_cr_ship_hull_carrier_modern` |
| `ship_hull_carrier_submarine` | `JAP_has_cr_ship_hull_carrier_submarine` |
| `ship_hull_cruiser_2` | `JAP_has_cr_ship_hull_cruiser_2` |
| `ship_hull_cruiser_3` | `JAP_has_cr_ship_hull_cruiser_3` |
| `ship_hull_cruiser_4` | `JAP_has_cr_ship_hull_cruiser_4` |
| `ship_hull_cruiser_submarine` | `JAP_has_cr_ship_hull_cruiser_submarine` |
| `ship_hull_escort_carrier` | `JAP_has_cr_ship_hull_escort_carrier` |
| `ship_hull_fleet_submarine` | `JAP_has_cr_ship_hull_fleet_submarine` |
| `ship_hull_heavy_2` | `JAP_has_cr_ship_hull_heavy_2` |
| `ship_hull_heavy_3` | `JAP_has_cr_ship_hull_heavy_3` |
| `ship_hull_heavy_4` | `JAP_has_cr_ship_hull_heavy_4` |
| `ship_hull_heavy_modern` | `JAP_has_cr_ship_hull_heavy_modern` |
| `ship_hull_light_2` | `JAP_has_cr_ship_hull_light_2` |
| `ship_hull_light_3` | `JAP_has_cr_ship_hull_light_3` |
| `ship_hull_light_4` | `JAP_has_cr_ship_hull_light_4` |
| `ship_hull_mega_carrier` | `JAP_has_cr_ship_hull_mega_carrier` |
| `ship_hull_super_heavy_1` | `JAP_has_cr_ship_hull_super_heavy_1` |
| `ship_hull_torpedo_cruiser` | `JAP_has_cr_ship_hull_torpedo_cruiser` |
