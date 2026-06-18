# 团属支援连分类倒查

日期：2026-06-13

目的：确认 v1.19 新团级支援单位是否吃 `category_army`、`category_all_infantry`、`category_all_armor` 等宽分类，并据此修正陆军学说适配计划。

原版来源：
- `D:\SteamLibrary\steamapps\common\Hearts of Iron IV\common\units\fire_support.txt`
- `D:\SteamLibrary\steamapps\common\Hearts of Iron IV\common\units\tank_destroyer_brigade.txt`
- `D:\SteamLibrary\steamapps\common\Hearts of Iron IV\common\units\sp_anti-air_brigade.txt`

MOD 覆盖检查：
- 当前 MOD 没有 `common/units/fire_support.txt`。
- 当前 MOD 没有 `common/units/tank_destroyer_brigade.txt`。
- 当前 MOD 没有 `common/units/sp_anti-air_brigade.txt`。
- `descriptor.mod` 里只替换了 `common/units/artillery_brigade.txt`，没有替换上述三个文件。

因此，以下分类判断以 v1.19 原版单位定义为准。

## 结论速览

| 单位/分类 | 吃 `category_army` | 吃 `category_all_infantry` | 吃 `category_all_armor` | 关键专属分类 |
| --- | --- | --- | --- | --- |
| `fire_support` | 是 | 否 | 否 | `category_regimental_support_battalions` |
| `mot_fire_support` | 是 | 否 | 否 | `category_regimental_support_battalions` |
| `field_guns` | 是 | 否 | 否 | `category_regimental_support_battalions`、`category_regimental_support_artillery` |
| `rocket_battery` | 是 | 否 | 否 | `category_regimental_support_battalions`、`category_regimental_support_artillery` |
| `anti_air_battery` | 是 | 否 | 否 | `category_regimental_support_battalions`、`category_anti_air` |
| `anti_tank_battery` | 是 | 否 | 否 | `category_regimental_support_battalions`、`category_anti_tank`、`category_mobile_anti_tank`、`category_front_line` |
| `*_tank_destroyer_support` | 是 | 否 | 是 | `category_tank_destroyers`、`category_tank_destroyer_regimental_support` |
| `*_sp_anti_air_support` | 是 | 否 | 是 | `category_self_propelled_anti_air`、`category_self_propelled_anti_air_regimental_support` |

## 对学说合入的实际含义

1. `category_army` 会覆盖全部团属支援连。
   如果 MOD 某个节点已经给 `category_army` 同一属性，就不应再用 `category_regimental_support_battalions` 给同一属性完整叠加，除非明确想让团属支援额外吃一层。

2. `category_all_infantry` 不覆盖团属支援连。
   即便 `fire_support`、`mot_fire_support`、`field_guns`、`anti_tank_battery` 等 `type` 中有 `infantry`，它们也没有 `category_all_infantry`。所以步兵学说中只给 `category_all_infantry` 的奖励，不会自动补到团属支援连。

3. `category_all_armor` 会覆盖团属坦歼和团属自行防空。
   装甲学说中已有的 `category_all_armor` 组织、突破、硬攻等加成，会自动影响 `category_tank_destroyer_regimental_support` 和 `category_self_propelled_anti_air_regimental_support` 对应单位。因此这些单位新增专属分类时，重点应放在 `air_attack`、`ap_attack` 等专属角色属性，组织和突破要谨慎避免重复。

4. `category_regimental_support_artillery` 只覆盖 `field_guns` 和 `rocket_battery`。
   它不覆盖 `fire_support` 或 `mot_fire_support`。如果节点想强化普通火力支援班，必须直接写 `fire_support` / `mot_fire_support`，或使用更宽的 `category_regimental_support_battalions`。

5. `anti_air_battery` 与 `anti_tank_battery` 会吃兵种专属宽分类。
   `anti_air_battery` 吃 `category_anti_air`；`anti_tank_battery` 吃 `category_anti_tank` 和 `category_mobile_anti_tank`。因此原版某些旧 `category_anti_air` 或 `category_anti_tank` 奖励可能已经会影响团属 AA/AT，不必全部再用单位 key 复制。

## 调整后的规划原则

- 总学说里已有 `category_army` 同属性时，只补缺失属性。例如 `new_mobile_warfare` 的 `category_army breakthrough` 已覆盖团属支援，后续只补 `max_organisation`。
- 步兵学说里不能假设 `category_all_infantry` 覆盖团属支援。需要按原版给 `fire_support`、`mot_fire_support`、`field_guns`、`category_regimental_support_artillery` 等补对应收益。
- 装甲学说里必须先看 MOD 当前节点是否已有 `category_all_armor` 同属性。若已有，同属性团属坦歼/团属自行防空不再完整叠加，只补 `air_attack`、`ap_attack` 或其他未覆盖属性。
- 战斗支援学说中，`pakfront`、`organic_battalion_fire_support`、`integrated_support_batteries` 仍采用迁移式调整；但要额外注意 `anti_air_battery` 和 `anti_tank_battery` 已经会吃 `category_anti_air` / `category_anti_tank`。
