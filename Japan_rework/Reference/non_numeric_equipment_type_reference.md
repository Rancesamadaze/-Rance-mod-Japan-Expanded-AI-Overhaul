# Non-Numeric Equipment Type Reference

本文档用于归纳装备 `type` 中没有数字后缀的型号。

这些型号不能按 `_0`、`_1`、`_2`、`_3` 这类尾部数字自动推导代际值。日后编写 scripted localisation、scripted trigger、动态 tooltip 或其他按型号等级分支的逻辑时，需要单独处理。

来源：`Reference/flag_reference.md`

## 海军舰体

| Type | Flag |
| --- | --- |
| `ship_hull_carrier_modern` | `JAP_has_cr_ship_hull_carrier_modern` |
| `ship_hull_carrier_submarine` | `JAP_has_cr_ship_hull_carrier_submarine` |
| `ship_hull_cruiser_submarine` | `JAP_has_cr_ship_hull_cruiser_submarine` |
| `ship_hull_escort_carrier` | `JAP_has_cr_ship_hull_escort_carrier` |
| `ship_hull_fleet_submarine` | `JAP_has_cr_ship_hull_fleet_submarine` |
| `ship_hull_heavy_modern` | `JAP_has_cr_ship_hull_heavy_modern` |
| `ship_hull_mega_carrier` | `JAP_has_cr_ship_hull_mega_carrier` |
| `ship_hull_torpedo_cruiser` | `JAP_has_cr_ship_hull_torpedo_cruiser` |
