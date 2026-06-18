# JAP_ai_production_examples.md

## 文件用途
本文件只保留必要示例。  
Codex 修改时应优先模仿这些模式，而不是自行发明新结构。

## 示例 1：`normal` 难度是陆军标准参考层
```txt
JAP_template_normal = {
	allowed = {
		tag = JAP
	}
	enable = {
		date >1938.6.1
		Rance_nd_more_than_easy = yes
        Rance_nd_more_than_normal = no
	}
	abort_when_not_enabled = yes
	ai_strategy = {
        type = role_ratio
        id = infantry
        value = 30
    }
	ai_strategy = {
		type = role_ratio
		id = medium_armor
		value = 100
	}
	ai_strategy = {
		type = role_ratio
		id = marine_armor
		value = 75
	}
}
```
用途：定义 `normal` 难度下的陆军结构目标。

## 示例 2：陆军装备盈余率模板
```txt
AND = {
    set_temp_variable = { r_mtd_ratio = num_equipment@medium_tank_destroyer_chassis }
    divide_temp_variable = { r_mtd_ratio = 1000 }
    add_to_temp_variable = { r_mtd_ratio = num_equipment_in_armies_k@medium_tank_destroyer_chassis }

    set_temp_variable = { r_mtd_denom = num_target_equipment_in_armies_k@medium_tank_destroyer_chassis }
    add_to_temp_variable = { r_mtd_denom = 0.01 }

    divide_temp_variable = { r_mtd_ratio = r_mtd_denom }
    check_variable = { r_mtd_ratio > Rance_critical_start_decline }
}
```
用途：陆军关键装备是否进入减产的标准判断模板。

## 示例 3：关键装备不足时压制训练
```txt
ai_strategy = {
    type = role_ratio
    id = heavy_armor
    value = -50
}
```
配合重装关键装备不足的 `enable` 条件使用。  
用途：装备链不足时，不只调整生产，还直接压低对应兵种训练倾向。

## 示例 4：空军按总量判断
```txt
set_temp_variable = {
    num_mothership = num_equipment@mothership_equipment
    num_mothership_d = num_deployed_planes_with_type@mothership_equipment
}
add_to_temp_variable = {
    var = num_mothership
    value = num_mothership_d
}
```
用途：空军按“库存 + 已部署”计算总量，不要改写成陆军式盈余率模型。

## 示例 5：空军强制撤产
```txt
ai_strategy = {
    type = equipment_production_factor
    id = tactical_bomber
    value = -9999
}
```

```txt
ai_strategy = { 
    type = air_factory_balance 
    value = 33
}
```
用途：前者用于单机种强制撤产/禁产，后者用于空军总体工厂配比。二者不能混用。

## 示例 6：海军角色配比
```txt
ai_strategy = {
    type = role_ratio
    id = rance_carrier
    value = 100
}
ai_strategy = {
    type = role_ratio
    id = rance_bb
    value = 150
}
ai_strategy = {
    type = role_ratio
    id = rance_task_cl
    value = 300
}
ai_strategy = {
    type = role_ratio
    id = rance_strike_dd
    value = 200
}
ai_strategy = {
    type = role_ratio
    id = rance_ss
    value = 100
}
```
用途：海军主要按舰种职责配比控制，不套陆军或空军模型。
