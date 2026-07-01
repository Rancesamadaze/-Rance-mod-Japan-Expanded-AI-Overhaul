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

具体装备设计同步使用第二层 flag，命名为：

```txt
JAP_has_cr_design_<effect_id_without_JAP_cr_prefix>
```

例如 `JAP_cr_basic_medium_tank_jap_97` 创建成功后设置
`JAP_has_cr_design_basic_medium_tank_jap_97`。这一层 flag 表示某个具体装备型号已经被创建，用于区分同一 `type` 下的多个历史型号；原有 `JAP_has_cr_<type>` 仍保留为底盘、舰体或机体级别的粗粒度记录。

覆盖范围是 MOD 自己通过 `JAP_cr_*` scripted effect 创建的特殊设计，包括开局历史内直接授予的基础/历史特殊设计和军需省后续解锁设计；不追踪原版默认设计。

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

## 联合大本营属国军区集结 flag

来源：`common/scripted_effects/JAP_subject_theater_assembly_scripted_effects.txt`

用途：日本侧决议记录当前指定特殊属国集结的军区。旗帜只设置在 `JAP` 作用域；特殊属国 AI 策略通过 `JAP = { has_country_flag = ... }` 读取当前命令，避免新成立属国错过即时发放的属国自身 flag。

同一时间只应保留一个 `JAP_rework_subject_assembly_*_theater_active` flag。切换军区时先调用 `JAP_rework_clear_subject_theater_assembly_flags` 清理旧命令，再设置新命令。

| Theater | Flag |
| --- | --- |
| Southeast Asia | `JAP_rework_subject_assembly_southeast_asia_theater_active` |
| South Asia | `JAP_rework_subject_assembly_south_asia_theater_active` |
| East Indies-Australia | `JAP_rework_subject_assembly_east_indies_australia_theater_active` |
| Pacific | `JAP_rework_subject_assembly_pacific_theater_active` |
| Northern East | `JAP_rework_subject_assembly_northern_east_theater_active` |
| Northern West | `JAP_rework_subject_assembly_northern_west_theater_active` |
