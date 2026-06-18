# HOI4 MIO Tree Header Text Reference

目的：整理原版 `00_generic_organization.txt` 中已经出现过的 `tree_header_text.text = mio_header_...` 键，并补充本项目对自定义 header 的使用规则。

## 使用原则

- `tree_header_text.text` 是某一整片 trait 分区的标题键，不是单个 trait 的名称。
- 优先根据整棵树的分区主题来选键，而不是只看某个节点给了什么数值。
- 如果原版已有语义接近的键，优先复用原版键。
- 如果原版没有现成且合适的键，可以手动编写新的 header key，并补对应本地化。
- 只有在原版现成键会明显误导分区语义时，才建议自定义 header key。

## 原版出现过的 text 键总表

| text 键 | 典型含义 |
| --- | --- |
| `mio_header_tank_construction` | 坦克构造 / 车体制造 |
| `mio_header_equipment_and_specialization` | 装备与专精 |
| `mio_header_engine_and_suspension` | 发动机与悬挂 |
| `mio_header_armament` | 武装 |
| `mio_header_production` | 生产 |
| `mio_header_armor` | 装甲 |
| `mio_header_light_assault_gun_department` | 轻型突击炮部门 |
| `mio_header_medium_assault_gun_department` | 中型突击炮部门 |
| `mio_header_heavy_assault_gun_department` | 重型突击炮部门 |
| `mio_header_armor_and_armaments` | 装甲与武装 |
| `mio_header_design` | 设计 |
| `mio_header_engines` | 发动机 |
| `mio_header_engine_and_drive_system` | 发动机与传动系统 |
| `mio_header_chassis` | 底盘 |
| `mio_header_guns_and_turret` | 火炮与炮塔 |
| `mio_header_weapons` | 武器 |
| `mio_header_trains` | 列车 |
| `mio_header_systems` | 系统 |
| `mio_header_long_range_focus` | 远程取向 |
| `mio_header_high_speed_focus` | 高速取向 |
| `mio_header_stealth_focus` | 隐蔽取向 |
| `mio_header_supremacy_focus` | 优势取向 |
| `mio_header_protection` | 防护 |
| `mio_header_fighter_aircraft` | 战斗机 |
| `mio_header_bomber_aircraft` | 轰炸机 |
| `mio_header_naval_aircraft` | 海军航空机 |
| `mio_header_wings` | 机翼 |
| `mio_header_design_department` | 设计部门 |
| `mio_header_operational_department` | 运用 / 作战部门 |
| `mio_header_engines_department` | 发动机部门 |
| `mio_header_light_aircraft` | 轻型飞机 |
| `mio_header_medium_aircraft` | 中型飞机 |
| `mio_header_mechanical_design` | 机械设计 |
| `mio_header_armament_and_ammunition` | 武器与弹药 |
| `mio_header_design_and_production` | 设计与生产 |
| `mio_header_anti_tank` | 反坦克 |
| `mio_header_support` | 支援 |
| `mio_header_motorized` | 摩托化 |
| `mio_header_mechanized` | 机械化 |
| `mio_header_tandem_rotor` | 串列双旋翼 |
| `mio_header_single_rotor` | 单旋翼 |

## 按类型选择

### 坦克 / 装甲类

常用：

- `mio_header_tank_construction`
- `mio_header_equipment_and_specialization`
- `mio_header_engine_and_suspension`
- `mio_header_armament`
- `mio_header_production`
- `mio_header_armor`
- `mio_header_engine_and_drive_system`
- `mio_header_chassis`
- `mio_header_guns_and_turret`

### 舰船类

常用：

- `mio_header_systems`
- `mio_header_weapons`
- `mio_header_protection`
- `mio_header_long_range_focus`
- `mio_header_high_speed_focus`
- `mio_header_stealth_focus`
- `mio_header_supremacy_focus`

### 飞机类

常用：

- `mio_header_fighter_aircraft`
- `mio_header_bomber_aircraft`
- `mio_header_naval_aircraft`
- `mio_header_production`
- `mio_header_engines`
- `mio_header_wings`
- `mio_header_weapons`

### 步兵 / 支援 / 火炮类

常用：

- `mio_header_mechanical_design`
- `mio_header_armament_and_ammunition`
- `mio_header_design_and_production`
- `mio_header_anti_tank`
- `mio_header_support`
- `mio_header_weapons`
- `mio_header_motorized`
- `mio_header_mechanized`
- `mio_header_trains`

## 通用高复用键

| text 键 | 适用场景 |
| --- | --- |
| `mio_header_weapons` | 泛火力、武器、主攻方向 |
| `mio_header_production` | 生产、扩产、产线优化 |
| `mio_header_systems` | 系统、综合模块、复杂平台 |
| `mio_header_engines` | 动力、机动、引擎分区 |
| `mio_header_armor` | 装甲、防护、生存性 |
| `mio_header_support` | 支援器材、辅助分区 |

## 自定义 Header 规则

如果原版没有合适的 `tree_header_text.text`，允许手动编写新的 key。

建议：

- 命名保持可追踪，例如：
  - `TAG_mio_header_xxx`
  - `project_mio_header_xxx`
- 不要使用过于模糊的名字，例如：
  - `mio_header_new`
  - `custom_header_1`
- 新 key 需要补本地化，否则界面会直接显示键名。

适合自定义的典型场景：

- 两棵树或多棵树的分区主题并不等于原版任何一组 header
- 某条路线有明显项目特色，复用原版键会误导玩家理解
- 模板树是为了后续批量复用，需要更中性的项目内标题

## 对本项目的落地规则

- 先查原版键，再决定是否自定义。
- 日系变体若明显沿用原版 archetype，优先沿用原版 header。
- 模板组织如果分区主题明显不同于原版，可直接采用项目自定义 header key。
