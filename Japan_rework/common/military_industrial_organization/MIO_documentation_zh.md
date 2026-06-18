# 军事工业组织（MIO）数据库

军事工业组织（MIO）是设计公司的替代系统。它们会提供科研加成，但更重要的是会为装备提供加成，包括装备质量与生产方面的加成。

一个 MIO 由一棵可解锁特质树构成。  
MIO 能匹配哪些装备，由 MIO 本体中的装备列表决定。  
具体的装备属性加成与生产属性加成，则在特质中设置。  
最终加成由两者组合而成——例如：步兵装备的对人员杀伤。

特质也可以为 MIO 本身解锁修正；在这种情况下，装备类型并不重要。

特质树中连线颜色的配置见 `game/common/defines/00_graphics.lua`，例如 `TRAIT_LINE_ASSIGNED_COLOR`。

包含所有可能部分的示例：

```
my_MIO_token = {
    name = loc_key # 可选
    # 如果提供 name，则优先使用 TAG_loc_key；若不存在，则使用 loc_key（TAG 为 MIO 所有者的国家标签）
    # 如果本地化键 TAG_my_MIO_token 存在，则使用该键
    # 否则使用本地化键 my_MIO_token
    # 本地化键可以使用 scripted loc，其作用域会设置为此 MIO

    icon = GFX_key # 可选
    # 如果提供 icon，则使用 GFX_key
    # 如果图形键 GFX_TAG_my_MIO_token 存在，则使用它（TAG 为 MIO 所有者的国家标签）
    # 如果图形键 GFX_my_MIO_token 存在，则使用它
    # 否则使用 GFX_idea_unknown

    background = GFX_key # 可选
    # 详情窗口背景图的图形键
    # 如果不指定，会根据支持的装备类型使用一种标准背景

    allowed = { ... } # 必填
    # 国家作用域
    # allowed 会在游戏开始时对所有国家判定，包括尚不存在的国家
    # 如果触发器返回 true，则会为该国家创建此 MIO 的一个实例

    visible = { ... } # 可选，默认为 always = yes
    # 当前 MIO 作用域；FROM = 国家
    # visible 会在显示 MIO UI 时判定
    # 如果触发器返回 false，则该 MIO 对玩家不可见

    available = { ... } # 可选，默认为 always = yes
    # 当前 MIO 作用域；FROM = 国家
    # available 会在显示 MIO UI 时判定
    # 如果触发器返回 false，则该 MIO 可见，但处于禁用与灰显状态

    # 对 AI 和脚本而言，只有同时 visible 与 available 时，一个 MIO 才被视为启用

    equipment_type = { equipment_type_token1 }
    # 用于让 MIO 与装备改型匹配的装备原型与装备类别
    # 可用值见脚本枚举 script_enum_equipment_bonus_type
    # 这里也可以使用 game/common/equipment_groups 中的装备组

    research_categories = { infantry_weapons }
    # 用于让 MIO 与科技匹配的科研类别
    # 必须与 game/common/technologies 文件中的类别匹配

    on_design_team_assigned_to_tech = { ... }
    on_design_team_assigned_to_variant = { ... }
    on_industrial_manufacturer_assigned = { ... }
    on_tech_research_cancelled = { ... }
    on_tech_research_completed = { ... }
    on_industrial_manufacturer_unassigned = { ... }
    # 可选的 on-action 效果；以当前 MIO 为作用域执行，FROM = 国家

    research_bonus = 0.2 # 可选，默认值为 define DESIGN_TEAM_RESEARCH_BONUS
    task_capacity = 3 # 可选，默认值为 define DEFAULT_INITIAL_TASK_CAPACITY


    ai_will_do = {
        ...
    }
    # 当前 MIO 作用域；FROM = 国家
    # 此组织的 AI 权重修正，可选
    # 相关写法可参考内容中各处 ai_will_do 的示例
    # 该值会作为“乘数”使用，基础权重来自 `ai_bonus_weights`

    # 风味文本会显示在特质树上方。
    # 它们通常用于描述一列特质——界面上只有一行空间！
    # 可以设置多个风味文本；重复 tree_flavor_text 块即可
    # 使用 x 选择文本在水平轴上的位置。
    # x 应为文本中心所在单元格的水平坐标。
    # 如果要让文本对齐到两个单元格之间的位置，可以使用小数。（例如 x = 1.2）
    tree_header_text = {
        text = my_flavor_text_loc_key
        x = 1
    }

    # 除了树上的特质之外，MIO 还可以拥有一个初始特质。
    # 该特质从一开始就已解锁，其加成会直接生效。
    initial_trait = {
        # 初始特质只会使用以下参数，且全部为可选
        # 更多细节见下文“特质参数”。
        name = my_loc_key # 若不填写名称，默认名称会使用 token initial_trait
        limit_to_equipment_type = { ... }
        equipment_bonus = { ... }
        production_bonus = { ... }
        organization_modifier = { ... }
    }

    # 向特质树添加特质
    # 可以通过重复 trait 块添加任意数量的特质
    trait = {
        token = upgrade_1 # 必填
        name = loc_key # 可选
        # 如果提供 name，则优先使用 TAG_loc_key；若不存在，则使用 loc_key（TAG 为 MIO 所有者的国家标签）
        # 如果本地化键 TAG_my_MIO_token_upgrade_1 存在，则使用它
        # 否则使用本地化键 my_MIO_token_upgrade_1

        icon = GFX_key # 可选
        # 如果提供 icon，则使用 GFX_key
        # 如果图形键 GFX_TAG_my_MIO_token_upgrade_1 存在，则使用它（TAG 为 MIO 所有者的国家标签）
        # 如果图形键 GFX_my_MIO_token_upgrade_1 存在，则使用它
        # 否则使用 GFX_idea_unknown

        special_trait_background  = yes # 可选，默认为 no
        # 如果为 yes，特质背景会变成金色，用于标示比较重要或有趣的特质

        # 如果该特质不是树上的第一个特质，则至少需要指定一个父特质
        # 可以使用 parent 或 any_parent
        parent = {
            traits = { parent traits }
            num_parents_needed = X # 需要解锁的父特质数量，默认为 1
        }
        any_parent = { parent traits } # 简写，等同于 parent = { traits = { parent traits } num_parents_needed = 1 }
        all_parents = { parent traits} # 简写，等同于 parent = { traits = { parent traits } num_parents_needed = N }，其中 N 为父特质数量

        # 该特质可以与另一个或多个特质互斥
        # 注意：另一个特质也应当设置 mutually_exclusive 参数
        mutually_exclusive= { upgrade4 }

        visible = { ... } # 可选，默认为 always = yes
        # 当前 MIO 作用域；FROM = 国家
        # visible 会在显示 MIO UI 时判定
        # 如果触发器返回 false，则该特质对玩家不可见

        available = { ... } # 可选，默认为 always = yes
        # 当前 MIO 作用域；FROM = 国家
        # available 会在显示 MIO UI 时判定
        # 如果触发器返回 false，则该特质可见，但处于禁用与灰显状态

        # 对 AI 和脚本而言，只有同时 visible 与 available 时，一个特质才被视为启用

        on_complete = { ... } # 可选
        # 当前 MIO 作用域；FROM = 国家
        # 该特质完成，也就是解锁时，会执行的效果

        limit_to_equipment_type = { ... } # 可选
        # 默认情况下，特质中的加成会应用到 MIO 层级指定的装备类型上
        # 但你可以将它们限制到 MIO 层级装备类型所包含的某些装备类型上
        # 例如：如果 MIO 的装备原型列表为 { light_armor medium_tank }，则可以限制为原型 { light_tank }
        # 例如：如果 MIO 的装备类别为 { armor }，则可以限制为原型 { light_tank medium_tank }
        # 这里也可以使用 game/common/equipment_groups 中的装备组

        # 定义特质解锁后，且该 MIO 被分配给装备改型时提供的加成
        # 可用值见脚本枚举 script_enum_equipment_stat
        equipment_bonus = {
            reliability = 0.2
            soft_attack = 0.1 # 可接受任意数量的属性
        }
        # 定义特质解锁后，且该 MIO 被分配给生产线时提供的加成
        # 可用值见脚本枚举 script_enum_production_stat
        production_bonus = {
            production_cost_factor = -0.1
            production_capacity_factor = 0.1 # 可接受任意数量的属性
        }

        # 定义会应用到该特质所属组织本身的修正。
        # 只应使用适用于 MIO 的修正；完整列表见下方。
        organization_modifier = {
            military_industrial_organization_research_bonus = 0.1
            military_industrial_organization_design_team_assign_cost = -0.33
            military_industrial_organization_design_team_change_cost = -0.5
            military_industrial_organization_industrial_manufacturer_assign_cost = -0.66
            military_industrial_organization_task_capacity = 2
            military_industrial_organization_size_up_requirement = -0.2
            military_industrial_organization_funds_gain = 0.5
        }

        # 定义该特质在特质树网格中的位置，也就是 MIO 详情 UI 中的位置
        # x=0 y=0 表示左上角
        # 注意不要在同一棵树中重复使用同一个位置
        position = { x=1 y=0 }
        # 默认情况下，position 是特质树网格中的绝对坐标。
        # 如果提供 relative_position_id，则 position 会变成相对于输入特质位置的偏移量
        relative_position_id = trait_token

        # 该特质的 AI 权重修正
        # 相关写法可参考内容中各处 ai_will_do 的示例
        # 警告：如果该特质属于中央树，则该特质自己的 ai_will_do 会覆盖中央树的 ai_will_do！
        ai_will_do = {
            ...
        }
    }
}
```

另一个示例：通过复用已有 MIO 来构建一个新 MIO。

```
my_quick_unoriginal_MIO = {
    include = my_MIO_token
    # 默认情况下，my_MIO_token 的所有部分都会被复用。
    # 但你可以覆盖其中任意部分
    allowed = { ... }
    icon = another_GFX_key
    research_bonus = 0.3

    # 如果想把某个参数覆盖为默认值或空值，将参数名写入 delete_included_values
    # 除特质相关参数外，所有参数都可以这样处理（见下文）
    delete_included_values = { name on_design_team_assigned_to_variant initial_trait ... }

    # 对于初始特质
    # 使用通常的特质 API；只填写你想覆盖的部分，其余部分会保留原值
    initial_trait = {
        icon = another_trait_GFX_key
    }

    # 对于复制到当前 MIO 中的普通特质，也是同理。
    # 使用以下特定参数来修改它们。
    add_trait = { ... } # 向被包含的特质树添加一个特质；使用通常的特质 API
    remove_trait = { trait_token }
    override_trait = {
        token = trait_token # 必须匹配被包含 MIO 中的某个特质
        # 使用通常的特质 API；只填写你想覆盖的部分，其余部分会保留原值
        equipment_bonus = { ... }
        is_available = { ... }
        # 如果想把某个参数覆盖为默认值或空值，将参数名写入 delete_included_values
        # 所有参数都可以这样处理
        delete_included_values = { equipment_bonus relative_position_id ...  }
    }
    # 警告！如果被 include 的 MIO 与当前 MIO 位于两个不同文件中，则需要“保存”两个文件，热重载结果才会生效。
}
```

注：使用 include 时没有加载顺序限制。被 include 的 MIO 只需要存在于 organizations 目录中的某处即可。



## 装备属性

```
########  #######  ##     ## #### ########  ##     ## ######## ##    ## ########     ######  ########    ###    ########  ######  
##       ##     ## ##     ##  ##  ##     ## ###   ### ##       ###   ##    ##       ##    ##    ##      ## ##      ##    ##    ## 
##       ##     ## ##     ##  ##  ##     ## #### #### ##       ####  ##    ##       ##          ##     ##   ##     ##    ##       
######   ##     ## ##     ##  ##  ########  ## ### ## ######   ## ## ##    ##        ######     ##    ##     ##    ##     ######  
##       ##  ## ## ##     ##  ##  ##        ##     ## ##       ##  ####    ##             ##    ##    #########    ##          ## 
##       ##    ##  ##     ##  ##  ##        ##     ## ##       ##   ###    ##       ##    ##    ##    ##     ##    ##    ##    ## 
########  ##### ##  #######  #### ##        ##     ## ######## ##    ##    ##        ######     ##    ##     ##    ##     ######  
```


### 坦克

```
###  ##  #  # # #  ## 
 #  #  # ## # # # #   
 #  #### # ## ##   #  
 #  #  # #  # # #   # 
 #  #  # #  # # # ##  
```

- `maximum_speed`
- `reliability`
- `defense`
- `breakthrough`
- `armor_value`
- `soft_attack`
- `hard_attack`
- `ap_attack`
- `air_attack`
- `build_cost_ic`
- `fuel_consumption`
- `hardness`
- `armor_value`
- `build_cost_ic`
- `entrenchment`：仅当拥有 NSB DLC 且装备模块为 `dozer_blade` 时可用
- `fuel_capacity`：仅当拥有 NSB DLC 且装备模块为 `expanded_fuel_tank` 时可用



### 舰船

```
 ## #  # ### ###   ## 
#   #  #  #  #  # #   
 #  ####  #  ###   #  
  # #  #  #  #      # 
##  #  # ### #    ##  
```

- `lg_armor_piercing`（需要模块）
- `lg_attack`（需要模块）
- `hg_armor_piercing`（需要模块）
- `hg_attack`（需要模块）
- `torpedo_attack`（需要模块）
- `sub_attack`（需要模块）
- `anti_air_attack`（需要模块）
- `armor_value`（需要模块）
- `surface_detection`
- `sub_detection`（需要模块）
- `sub_visibility`（仅潜艇）
- `surface_visibility`（仅水面舰艇）
- `naval_speed`
- `reliability`
- `naval_range`
- `max_strength`
- `fuel_consumption`
- `build_cost_ic`
- `manpower`
- `naval_dominance_factor`
- `naval_torpedo_enemy_critical_chance_factor`（如果你有添加该属性的模块）
- `naval_torpedo_damage_reduction_factor`（如果你有添加该属性的模块）
- `carrier_size`（相信我，这会让事情变得非常糟；装备修正是个错误）
- `mines_sweeping`（仅 MTG，且需要模块）
- `mines_planting`（仅 MTG，且需要模块）
- `naval_torpedo_hit_chance_factor`（需要模块）
- `naval_light_gun_hit_chance_factor`（需要模块）
- `naval_heavy_gun_hit_chance_factor`（需要模块）



### 飞机

```
###  #    ##  #  # ###  ## 
#  # #   #  # ## # #   #   
###  #   #### # ## ##   #  
#    #   #  # #  # #     # 
#    ### #  # #  # ### ##  
```

- `air_superiority`
- `reliability`
- `naval_strike_attack`
- `naval_strike_targetting`
- `manpower`
- `fuel_consumption`
- `build_cost_ic`
- `resources`
- `thrust`：仅当拥有 BBA DLC 时可用
- `weight`：仅当拥有 BBA DLC 时可用
- `maximum_speed`
- `air_range`
- `air_agility`
- `air_attack`
- `air_defence`
- `surface_detection`
- `sub_detection`
- `air_ground_attack`
- `air_bombing`
- `mines_planting`：如果拥有 MtG 与 BBA
- `mines_sweeping`：如果拥有 MtG 与 BBA
- `night_penalty`：仅当拥有 BBA DLC 时可用（你需要有对应模块，因为基础值为 0——原文此处疑似截断：radio navigatio）



### 军需器材

```
#   #  ##  ### ### ###  ### ### #   
## ## #  #  #  #   #  #  #  #   #   
# # # ####  #  ##  ###   #  ##  #   
#   # #  #  #  #   #  #  #  #   #   
#   # #  #  #  ### #  # ### ### ### 
```


#### 步兵装备

```
##############################
##### INFANTRY EQUIPMENT #####
##############################
```

- `reliability`
- `maximum_speed`
- `defense`
- `breakthrough`
- `hardness`：脚本中存在该属性，但数值设为 0（游戏 UI 中不会显示该值）
- `armor_value`：脚本中存在该属性，但数值设为 0（游戏 UI 中不会显示该值）
- `soft_attack`
- `hard_attack`
- `ap_attack`
- `air_attack`：脚本中存在该属性，但数值设为 0（游戏 UI 中不会显示该值）
- `build_cost_ic`

#### 支援装备

```
##############################
##### SUPPORT EQUIPMENT ######
##############################
```

- `reliability`
- `build_cost_ic`


#### 火炮装备

```
#############################
#### ARTILLERY EQUIPMENT ####
#############################
```

- `reliability`
- `defense`
- `breakthrough`
- `hardness`
- `armor_value`
- `soft_attack`
- `hard_attack`
- `ap_attack`
- `air_attack`
- `build_cost_ic`

#### 防空炮装备

```
############################
#### ANTI-AIR EQUIPMENT ####
############################
```

- `reliability`
- `defense`
- `breakthrough`
- `hardness`
- `armor_value`
- `soft_attack`
- `hard_attack`
- `ap_attack`
- `air_attack`
- `build_cost_ic`

#### 反坦克炮装备

```
#############################
#### ANTI-TANK EQUIPMENT ####
#############################
```

- `reliability`
- `defense`
- `breakthrough`
- `hardness`
- `armor_value`
- `soft_attack`
- `hard_attack`
- `ap_attack`
- `air_attack`
- `build_cost_ic`


#### 火箭炮装备

```
####################################
#### ROCKET ARTILLERY EQUIPMENT ####
####################################
```

- `reliability`
- `defense`
- `breakthrough`
- `hardness`
- `armor_value`
- `soft_attack`
- `hard_attack`
- `ap_attack`
- `air_attack`
- `build_cost_ic`



#### 摩托化装备

```
##############################
#### MOTORIZED EQUIPMENT #####
##############################
```

- `maximum_speed`
- `reliability`
- `hardness`
- `breakthrough`
- `build_cost_ic`
- `fuel_consumption`


#### 摩托化火箭炮装备

```
####################################
#### MOTORIZED ROCKET EQUIPMENT ####
####################################
```

- `reliability`
- `defense`
- `breakthrough`
- `hardness`
- `armor_value`
- `soft_attack`
- `hard_attack`
- `ap_attack`
- `air_attack`
- `build_cost_ic (edited)`



#### 机械化装备

```
###############################
#### MECHANIZED EQUIPMENT #####
###############################
```

- `maximum_speed`
- `reliability`
- `defense`
- `breakthrough`
- `hardness`
- `armor_value`
- `ap_attack`
- `air_attack`
- `build_cost_ic`
- `fuel_consumption`


#### 两栖机械化装备

```
#########################################
#### AMPHIBIOUS MECHANIZED EQUIPMENT ####
#########################################
```

- `maximum_speed`
- `reliability`
- `defense`
- `breakthrough`
- `hardness`
- `armor_value`
- `ap_attack`
- `air_attack`
- `build_cost_ic`
- `fuel_consumption`



#### 装甲车装备

```
################################
#### ARMORED CAR EQUIPMENT #####
################################
```

- `maximum_speed`
- `reliability`
- `defense`
- `breakthrough`
- `hardness`
- `armor_value`
- `soft_attack`
- `hard_attack`
- `ap_attack`
- `air_attack`
- `build_cost_ic`
- `fuel_consumption`


#### 火车装备

```
##########################
#### TRAIN EQUIPMENT #####
##########################
```

- `armor_value`
- `build_cost_ic`
- `air_attack`


#### 列车炮装备

```
################################
#### RAILWAY GUN EQUIPMENT #####
################################
```

- `reliability`
- `maximum_speed`
- `railway_gun_attack`
- `build_cost_ic`
