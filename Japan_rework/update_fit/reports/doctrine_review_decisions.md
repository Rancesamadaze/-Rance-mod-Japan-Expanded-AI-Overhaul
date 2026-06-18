# 陆军学说逐条审核记录

日期：2026-06-13

用途：记录对话中逐个学说/节点的审核结论。这里先记决策，live 文件后续统一修改。

实施状态：已在 live 学说文件中统一落地本记录内已通过的处理方案。

落地文件：

- `common/doctrines/grand_doctrines/land_grand_doctrines.txt`
- `common/doctrines/grand_doctrines/rance_grand_doctrines.txt`
- `common/doctrines/subdoctrines/land/armor_subdoctrines.txt`
- `common/doctrines/subdoctrines/land/combat_support_subdoctrines.txt`
- `common/doctrines/subdoctrines/land/infantry_subdoctrines.txt`
- `common/doctrines/subdoctrines/land/operations_subdoctrines.txt`

## 审核规则修正

- 总学说不按单个里程碑孤立审核。
- 总学说必须把基础效果和全部里程碑加成合在一起，看整条学说的最终定位和累计强度。
- 子学说仍可按 reward 节点逐条审核，但遇到同一子学说内部迁移效果时，也要按整条子学说关系判断。
- 团属支援连的基础组织补偿优先放在总学说选用即生效的 `# EFFECTS` 区域，不放进里程碑。
- 炮兵/团属炮兵相关火力适配不再默认降档；除非明确会和 MOD 现有宽分类重复叠加，否则优先按原版 v1.19 数值合入。
- 后续逐条汇报时，先列出原版 v1.19 相对旧版的具体变化或更新日志相关条目，再列出 MOD 当前状态和处理建议，便于用户审核决策。
- 从 `grand_assault` 之后，默认采用简略批量汇报：每批列原版变化、处理结论和关键理由；只有迁移/重复叠加/大幅平衡项再展开。

## 总学说修正决策

### `new_mobile_warfare`

处理：`调整合入`

执行位置：总学说选用即生效的 `# EFFECTS`，不放入里程碑。

执行方案：

```txt
category_regimental_support_battalions = {
    max_organisation = 10
}
```

不合入：

```txt
breakthrough = 0.1
```

理由：团属支援连已吃 `category_army`，MOD 机动作战总学说已有全军突破方向；这里改为基础组织补偿，避免把突破叠到团属支援上。组织补偿从 `5` 上调到 `10`，用于抵消团属支援连加入后对师组织度的拉低。

状态：用户已通过，待统一实施。

### `grand_battleplan`

处理：`调整合入`

执行位置：总学说选用即生效的 `# EFFECTS`，不放入里程碑。

执行方案：

```txt
category_regimental_support_battalions = {
    max_organisation = 10
}
```

不合入：

```txt
defense = 0.1
entrenchment = 0.2
```

理由：决战计划总学说已从整体上给足计划、堑壕、协同和增援定位；这里只给团属支援连基础组织补偿，不再额外给防御或堑壕。组织补偿从 `5` 上调到 `10`，用于抵消团属支援连加入后对师组织度的拉低。

状态：用户已通过，待统一实施。

### `superior_firepower`

处理：`调整合入`

执行位置：总学说选用即生效的 `# EFFECTS`，不放入里程碑。

执行方案：

```txt
category_regimental_support_battalions = {
    max_organisation = 5
    supply_consumption = -0.02
}
```

不合入：

```txt
soft_attack = 0.05
hard_attack = 0.05
```

理由：MOD 在其他里程碑已经给过 `category_army` 的软攻，不再额外补团属支援火力；改给与人海突击一致的团属支援补给消耗加成，并额外给 `max_organisation = 5`，补偿团属支援连拉低组织度的问题。

状态：用户已通过，待统一实施。

### `mass_assault`

处理：`调整合入`

执行位置：总学说选用即生效的 `# EFFECTS`，不放入里程碑。

执行方案：

```txt
category_regimental_support_battalions = {
    max_organisation = 5
    supply_consumption = -0.02
}
```

不合入：

```txt
default_morale = 0.1
```

理由：团属支援连已吃 `category_army`，当前 MOD 人海突击总学说已有 `category_army = { default_morale = 0.3 }` 和 `category_army = { defense = 0.1 }`；补给消耗符合低补给压力定位，并额外给 `max_organisation = 5`，补偿团属支援连拉低组织度的问题。

状态：用户已通过，待统一实施。

### `rance_furinkazan`

处理：`调整合入`

执行位置：自建特殊总学说 `rance_furinkazan` 选用即生效的 `# EFFECTS`，不放入里程碑。

执行方案：

```txt
category_regimental_support_battalions = {
    max_organisation = 10
}
```

理由：风林火山是自建强化总学说，已有步兵/装甲组织加成和全军恢复率；给团属支援连基础组织补偿，保持新团属支援系统与该特殊学说兼容。组织补偿从 `5` 上调到 `10`。

状态：用户已通过，待统一实施。

## 已通过的子学说决策

### `armored_spearhead` / 团属自行防空

处理：`调整合入`

执行方案：

```txt
category_self_propelled_anti_air_regimental_support = {
    air_attack = 0.05
}
```

不合入：

```txt
max_organisation = 10
```

理由：团属自行防空已吃 `category_all_armor`，不额外叠组织；只补防空攻击，接上装甲突击部队的团属防空屏护定位。

状态：用户已通过，待统一实施。

### `armored_infantry_support` / 团属坦歼

处理：`调整合入`

执行方案：

```txt
category_tank_destroyer_regimental_support = {
    ap_attack = 0.1
}
```

不合入：

```txt
max_organisation = 5
```

理由：团属坦歼已吃 `category_all_armor`，不额外叠组织；只补穿甲角色收益，保持装甲步兵支援线的反装甲协同定位。

状态：用户已通过，待统一实施。

### `mobile_defense` / 团属自行防空与团属坦歼

处理：`调整合入`

执行方案：

```txt
category_self_propelled_anti_air_regimental_support = {
    air_attack = 0.05
}

category_tank_destroyer_regimental_support = {
    ap_attack = 0.1
}
```

不合入：

```txt
max_organisation = 10
max_organisation = 5
hard_attack = 0.05
ap_attack = 0.15
```

理由：总学说已统一处理团属支援组织补偿；机动防御子学说只补团属自行防空和团属坦歼的角色属性，避免组织和硬攻重复堆叠。

状态：用户已通过，待统一实施。

### `armored_cavalry` / 团属反坦克与摩托化火力支援

处理：`合入`

执行方案：对齐原版 v1.19，同时处理 `armored_cavalry` 和 `armored_cavalry_no_lar`。

`armored_cavalry/fighting_reconnaissance`：

```txt
anti_tank_battery = {
    ap_attack = 0.10
}

mot_fire_support = {
    max_organisation = 5
    soft_attack = 0.05
    default_morale = 0.1
}
```

`armored_cavalry_no_lar/fighting_reconnaissance`：

```txt
anti_tank_battery = {
    max_organisation = 2
    ap_attack = 0.05
}
```

`armored_cavalry_no_lar/sustained_deployments`：

```txt
mot_fire_support = {
    max_organisation = 5
    soft_attack = 0.05
    default_morale = 0.1
}
```

理由：用户判断 MOD 未明显重做该学说，因此本项直接对齐原版 v1.19。

状态：用户已通过，待统一实施。

### `tank_destroyer_force` / 团属坦歼

处理：`调整合入`

执行方案：

```txt
category_tank_destroyer_regimental_support = {
    ap_attack = 0.1
}
```

不合入：

```txt
max_organisation = 5
hard_attack = 0.1
```

理由：团属坦歼同时属于 `category_tank_destroyers`、`category_all_armor` 和 `category_army`。当前 MOD 的 `tank_destroyer_force` 已通过 `category_tank_destroyers` / `category_all_armor` 覆盖组织、硬攻、恢复率、主动性和补给消耗；缺口主要是穿甲 `ap_attack`。

状态：用户已通过，待统一实施。

### `fire_concentration` / `artillery_groups`

处理：`合入`

执行方案：对齐原版 v1.19。

```txt
artillery_groups = {
    category_regimental_support_artillery = {
        soft_attack = 0.05
        breakthrough = 0.1
    }
    category_support_artillery = {
        soft_attack = 0.05
        breakthrough = 0.1
    }
    category_line_artillery  = {
        soft_attack = 0.05
        breakthrough = 0.1
    }
}
```

理由：当前 MOD 对该学说没有明显特殊再平衡；原版 v1.19 是完整扩展炮兵群收益到线列炮兵、支援炮兵、团属炮兵。

状态：用户已通过，待统一实施。

### `anti_tank_frontline` / `pakfront` 迁移

处理：`合入`

执行方案：对齐原版 v1.19 的迁移式调整。

```txt
pakfront = {
    anti_tank_brigade = {
        ap_attack = 0.1
    }
    anti_tank_battery = {
        ap_attack = 0.2
        hard_attack = 0.2
    }
}

emplacement_rotation = {
    anti_tank_brigade = {
        defense = 0.2
        max_organisation = 10
    }
}

weakpoint_studies = {
    anti_tank_brigade = {
        ap_attack = 0.1
        hard_attack = 0.1
        soft_attack = 0.2
    }
}
```

理由：当前 MOD 对该学说没有明显特殊再平衡；原版 v1.19 是把旧 `pakfront` 的防御/软攻迁移到后续节点，同时接入团属反坦克炮组，避免 `pakfront` 过肥。

状态：用户已通过，待统一实施。

### `flying_batteries` / `deployment_drills` 与 `ballistics_corrections`

处理：`合入`

执行方案：对齐原版 v1.19。

```txt
deployment_drills = {
    mot_rocket_artillery_brigade = {
        max_organisation = 10
    }
    motorized_rocket_brigade = {
        max_organisation = 10
    }
    mot_artillery_brigade = {
        max_organisation = 10
    }
    mot_fire_support = {
        max_organisation = 10
        soft_attack = 0.1
    }
}
```

同时将：

```txt
ballistics_corrections = {
    armored_signal = {
        battalion_mult = {
            category = category_line_artillery
            initiative = 0.02
            supply_consumption = -0.01
        }
    }
}
```

改为：

```txt
ballistics_corrections = {
    armored_signal = {
        battalion_mult = {
            category = category_line_artillery
            supply_consumption = -0.01
            add = yes
        }
        battalion_mult = {
            category = category_line_artillery
            initiative = 0.02
        }
    }
}
```

理由：当前 MOD 对该学说没有明显特殊再平衡；新增 `mot_fire_support` 是新团属支援适配，`add = yes` 是脚本语义修正。

状态：用户已通过，待统一实施。

### `mobile_recon_and_assault` / 摩托化火力支援

处理：`调整合入`

执行方案：同时处理 `mobile_recon_and_assault` 和 `mobile_recon_and_assault_no_lar`。

在 `motorization_support` 中补：

```txt
mot_fire_support = {
    max_organisation = 10
    soft_attack = 0.1
}
```

不合入：

```txt
category_tank_destroyer_regimental_support = {
    breakthrough = 0.2
}
category_self_propelled_anti_air_regimental_support = {
    breakthrough = 0.2
}
```

理由：`mot_fire_support` 不吃 `category_all_armor`，需要单独补；团属坦歼/团属自行防空已吃 `category_all_armor`，当前 MOD 已在该学说中给装甲突破收益，避免专属突破重复叠加。

状态：用户已通过，待统一实施。

### `self_propelled_support` / 自行支援重分配

处理：`不合入`

不合入原版 v1.19 的 `multirole_support_vehicles` 迁移：

```txt
category_tank_destroyer_regimental_support = {
    max_organisation = 10
    hard_attack = 0.1
    breakthrough = 0.2
}
category_self_propelled_anti_air_regimental_support = {
    max_organisation = 10
    air_attack = 0.1
    breakthrough = 0.2
}
```

不合入原版 v1.19 的 `shoot_and_scoot` 削弱。

理由：当前 MOD 的 `self_propelled_support` 已明显强化并重排自行支援线；团属坦歼和团属自行防空已通过 `category_tank_destroyers` / `category_self_propelled_anti_air` 吃到组织、火力、突破和恢复率。继续添加专属分类会双叠，照搬 `shoot_and_scoot` 削弱则会破坏 MOD 当前定位。

状态：用户已通过，待统一实施。

### `siege_artillery` / `urban_strongpoint_sieges`

处理：`合入`

执行方案：

```txt
fire_support = {
    soft_attack = 0.1
}

category_regimental_support_artillery = {
    soft_attack = 0.1
}
```

理由：当前 MOD 没明显重做该节点；攻城炮兵给普通团属火力支援与团属炮兵软攻符合定位，且 `fire_support` 不吃 `category_regimental_support_artillery`，需要单独补。

状态：用户已通过，待统一实施。

### `field_engineering` / 野战工程

处理：`调整合入`

不照搬 `rapid_fire_lane_clearance` 的工程堑壕大幅增强：

```txt
engineer = {
    battalion_mult = {
        category = category_all_infantry
        entrenchment = 0.1
        add = yes
    }
}
```

执行方案：将当前 MOD `engineerdug_gun_emplacements` 中四类工程支援对步兵的堑壕从 `0.02` 提升到 `0.05`：

```txt
engineer / assault_engineer / pioneer_support / armored_engineer = {
    battalion_mult = {
        category = category_all_infantry
        entrenchment = 0.05
        add = yes
    }
}
```

执行方案：在 `engineerdug_gun_emplacements` 中合入：

```txt
field_guns = {
    soft_attack = 0.1
    defense = 0.1
}
```

执行方案：在 `charge_and_flame` 中调整合入：

```txt
fire_support = {
    breakthrough = 0.1
}
```

不合入：

```txt
max_organisation = 5
```

理由：原版把工程营对步兵堑壕提高到 `0.1`，但当前 MOD 工程线已经改成四类工程支援共享的协同设计，并且还有挖壕速度、步兵防御、装甲突破和火焰坦克地形收益；因此不照搬满额 `0.1`，改为把现有 `0.02` 提到 `0.05`。`field_guns` 是新团属野战炮收益，应补齐。`fire_support` 的突破符合工程突击定位，但团属支援组织度已由总学说统一处理，不在该节点重复加 `max_organisation`。

状态：用户已通过，待统一实施。

### `mobile_infantry` / 机动步兵

处理：`调整合入`

不合入原版基础效果：

```txt
category_all_infantry = {
    breakthrough = 0.1
}
```

执行方案：在 `decisive_operations` 中按原版补入：

```txt
category_regimental_support_artillery = {
    soft_attack = 0.15
}
```

执行方案：在 `maneuver_warfare` 中合入：

```txt
mot_fire_support = {
    max_organisation = 5
    soft_attack = 0.1
}
```

理由：原版基础突破是纯步兵突破增强，且团属支援单位不吃 `category_all_infantry`；当前 MOD 机动步兵线已经明显降档重平衡，不直接加回全步兵突破。`category_regimental_support_artillery` 和 `mot_fire_support` 是当前 MOD 缺口，应补新团属支援挂钩；炮兵相关加成不再默认降档，团属炮兵软攻按原版 `0.15` 合入。

状态：用户已通过，待统一实施。

### `defensive_postures` / 防御姿态

处理：`合入`

执行方案：按原版 v1.19 数值合入。

```txt
improvised_fighting_position = {
    fire_support = {
        supply_consumption = -0.01
        soft_attack = 0.2
    }
}

field_emplacements = {
    category_regimental_support_artillery = {
        soft_attack = 0.2
    }
}
```

理由：`fire_support` 和 `category_regimental_support_artillery` 都是当前 MOD 防御姿态漏掉的新团属火力收益；炮兵/团属炮兵相关火力适配不再默认降档，且普通团属火力支援在这里承担防御阵地直射/火力支援角色，因此按原版 v1.19 数值合入。

状态：用户已通过，待统一实施。

### `large_unit_tactics` / 大兵团战术

处理：`合入`

原版 v1.19 相对旧版变化：只在 `large_front_offensive` 新增团属火力收益。

执行方案：

```txt
large_front_offensive = {
    fire_support = {
        breakthrough = 0.1
    }

    category_regimental_support_artillery = {
        soft_attack = 0.1
    }
}
```

不处理：不恢复 MOD 已经调低的 `category_all_infantry = { soft_attack = 0.05 }`。

理由：`fire_support` 和 `category_regimental_support_artillery` 是新团属支援系统补挂，不会重复吃 `category_all_infantry`；炮兵/团属炮兵火力不再默认降档，因此按原版 `0.1` 合入。MOD 当前大兵团步兵基础火力已经有意降档，仍保留。

状态：用户已通过，待统一实施。

### `assault_infantry` / 突击步兵

处理：`合入`

执行方案：完全对齐原版 v1.19。

原版 v1.19 相对旧版变化：

```txt
low_echelon_fire_support = {
    field_guns = {
        soft_attack = 0.2
    }
}

organic_battalion_fire_support = {
    category_regimental_support_artillery = {
        soft_attack = 0.1
    }
    anti_tank_battery = {
        ap_attack = 0.1
        hard_attack = 0.1
    }
    anti_air_battery = {
        air_attack = 0.1
    }
}

integrated_support_batteries = {
    category_support_artillery = {
        max_organisation = 20
        soft_attack = 0.05
    }

    anti_tank = {
        max_organisation = 20
        ap_attack = 0.05
        hard_attack = 0.05
    }

    anti_air = {
        max_organisation = 20
        air_attack = 0.05
    }
}

assault_detachments = {
    category_regimental_support_artillery = {
        supply_consumption = -0.01
    }
}
```

同步迁移：`organic_battalion_fire_support` 不再保留旧版的 `category_support_artillery`、`anti_tank`、`anti_air`，这些旧支援连收益按原版 v1.19 迁移到新团属炮兵/反坦炮组/防空炮组，以及后续 `integrated_support_batteries` 的旧支援连半档收益。

理由：用户判断 MOD 对该学说没有明显特殊再平衡，因此本项完全按原版 v1.19 合入；包括新团属单位挂钩、旧支援连收益迁移，以及 `category_support_artillery` 软攻从 `0.1` 调整为 `0.05`。

状态：用户已通过，待统一实施。

### `mounted_infantry` / 骑乘步兵

处理：`合入格式修正`

原版 v1.19 相对旧版变化：没有数值变化，只修正 `anti_mechanized_cavalry_groups` 与 `beasts_of_war` 挤在同一行的格式。

执行方案：将旧格式：

```txt
}        beasts_of_war = {
```

整理为正常分行结构：

```txt
}

beasts_of_war = {
```

理由：该项不是平衡项，也不是团属支援新挂钩；只修正结构可读性，避免后续维护时误读节点边界。

状态：用户已通过，待统一实施。

### `commandos` / 突击队

处理：`调整合入`

原版 v1.19 相对旧版变化：

```txt
isolated_combat_elements = {
    category_regimental_support_artillery = {
        supply_consumption = -0.01
        soft_attack = 0.05
    }
}

rigorous_training_regimen = {
    anti_tank_battery = {
        battalion_mult = {
            category = category_light_infantry
            hard_attack = 0.1
        }
    }
}

integrated_assaults = {
    category_regimental_support_artillery = {
        breakthrough = 0.15
    }
    fire_support = {
        breakthrough = 0.15
    }
    mot_fire_support = {
        breakthrough = 0.15
    }
}
```

执行方案：按原版 v1.19 数值合入以上新团属单位挂钩。

不处理：不恢复原版 `category_all_infantry` 更高软攻/突破和其他突击队重平衡内容，保留 MOD 当前突击队的 `category_all_infantry` 降档与重排。

理由：这些都是当前 MOD 缺失的新团属支援收益，不会被现有 `category_all_infantry` 覆盖；数值按原版给满。MOD 当前突击队已经明显改过自身强度曲线，因此只补新系统挂钩。

状态：用户已通过，待统一实施。

### `peoples_war` / 人民战争

处理：`合入`

执行方案：完全对齐原版 v1.19 更改。

原版 v1.19 相对旧版变化：

```txt
available = {
    if = {
        limit = {
            NOT = {
                original_tag = INS
            }
        }
        has_government = communism
    }
    else = {
        OR = {
            has_government = communism
            AND = {
                original_tag = INS
                has_completed_focus = INS_underground_revolution
            }
        }
    }
}

destruction_over_land_gains = {
    field_guns = {
        soft_attack = 0.15
    }
}

quick_decision_offensive_warfare = {
    militia = {
        initiative = 0.015
    }
}
```

同步调整：`quick_decision_offensive_warfare` 中民兵其他既有项 `max_organisation = 10`、`breakthrough = 0.2` 保持不变。

理由：用户要求本项完全按照原版更改；印尼解锁条件属于 DLC/国策兼容，`field_guns` 是新团属野战炮收益，民兵主动性增强也按原版 v1.19 合入。

状态：用户已通过，待统一实施。

### `great_war_infantry` / 一战步兵

处理：`合入`

原版 v1.19 相对旧版变化：

```txt
traverse_digging = {
    fire_support = {
        soft_attack = 0.1
        defense = 0.1
    }

    engineer = {
        battalion_mult = {
            category = category_light_infantry
            entrenchment = 0.05
            add = yes
        }
    }
}

centralized_artillery_control = {
    category_regimental_support_artillery = {
        soft_attack = 0.2
    }
}
```

执行方案：合入以上玩法/脚本语义变化。

不处理：不改 MOD 当前 `ai_will_do = { base = 1 }`。

理由：这是新团属支援挂钩和 `add = yes` 语义修正；炮兵火力按原版给满。MOD 当前仅调整了 AI 权重，没有明显重做该学说玩法数值。

状态：用户已通过，待统一实施。

### `mission_type_tactics` / 任务式战术

处理：`调整合入`

原版 v1.19 相对旧版变化：只在 `low_level_delegation` 新增团属炮兵收益。

```txt
category_regimental_support_artillery = {
    max_organisation = 5
    soft_attack = 0.05
}
```

执行方案：只补软攻，不重复补组织。

```txt
low_level_delegation = {
    category_regimental_support_artillery = {
        soft_attack = 0.05
    }
}
```

不合入：

```txt
max_organisation = 5
```

理由：MOD 当前 `low_level_delegation` 已通过 `category_army = { max_organisation = 5 }` 覆盖全部团属支援单位组织；团属炮兵软攻是缺口，按原版 `0.05` 合入。

状态：用户已通过，待统一实施。

### `last_stand` / 最后抵抗

处理：`已满足 / 不处理`

原版 v1.19 相对旧版变化：

```txt
available = {
    if = {
        limit = {
            NOT = {
                original_tag = INS
            }
        }
        has_defensive_war = yes
    }
    else = {
        OR = {
            has_defensive_war = yes
            has_country_flag = INS_revolution_has_started
        }
    }
}

breaking_out = {
    category_army = {
        soft_attack = 0.15
    }
    category_regimental_support_artillery = {
        max_organisation = 5
        soft_attack = 0.1
    }
}
```

不处理：不合入原版可用条件，不合入 `category_army soft_attack 0.2 -> 0.15`，也不新增 `category_regimental_support_artillery`。

理由：MOD 当前 `available = { always = yes }` 已比原版和新版印尼条件更宽；`breaking_out` 当前 `category_army = { soft_attack = 0.1 }` 已覆盖全部团属支援单位，包括团属炮兵。若再加 `category_regimental_support_artillery soft_attack = 0.1` 会让团属炮兵双吃软攻；`max_organisation = 5` 也由总学说统一处理。

状态：用户已通过，待统一实施。

### `infiltration_tactics` / 渗透战术

处理：`合入`

原版 v1.19 相对旧版变化：只在 `infiltration_assault` 新增普通团属火力支援软攻。

```txt
fire_support = {
    soft_attack = 0.1
}
```

执行方案：

```txt
infiltration_assault = {
    fire_support = {
        soft_attack = 0.1
    }
}
```

理由：MOD 当前 `infiltration_assault` 已有 `category_army = { breakthrough = 0.1 max_organisation = 5 }`，覆盖普通团属火力支援的突破和组织，但没有覆盖软攻；该新增项不与现有 MOD 加成重复。

状态：用户已通过，待统一实施。

### `grand_assault` / 大规模突击

处理：`调整合入`

原版 v1.19 相对旧版变化：

- `multiple_attack_directions` 新增 `fire_support = { soft_attack = 0.1 }`。
- `combined_arms_integration` 将旧版坦克组织/支援防空收益迁移到 `category_tank_destroyer_regimental_support`、`anti_air_battery`、`mot_fire_support`。
- `forward_command_posts` 的后勤连补给乘区新增 `add = yes`。

执行方案：

```txt
multiple_attack_directions = {
    fire_support = {
        soft_attack = 0.1
    }
}

combined_arms_integration = {
    anti_air_battery = {
        air_attack = 0.1
    }
}
```

不合入：`category_tank_destroyer_regimental_support` / `anti_air_battery` / `mot_fire_support` 的 `max_organisation = 5`，以及 `mot_fire_support = { soft_attack = 0.1 }`。

理由：MOD 当前 `c3i_theory` 已用 `category_army = { max_organisation = 5 soft_attack = 0.1 }` 覆盖全部团属支援单位，避免重复组织/软攻；`anti_air_battery air_attack = 0.1` 是角色属性缺口。`forward_command_posts add = yes` 因 MOD 没有对应后勤连补给乘区，不处理。

状态：用户已通过，待统一实施。

### `deep_battle` / 深层战斗

处理：`合入`

原版 v1.19 相对旧版变化：

```txt
breakthrough_priority = {
    mot_fire_support = {
        max_organisation = 5
        soft_attack = 0.1
    }
}

operational_depth_control = {
    category_regimental_support_artillery = {
        max_organisation = 5
        soft_attack = 0.1
    }
}
```

执行方案：按原版 v1.19 数值合入以上两处。

理由：MOD 当前 `deep_battle` 没有等价 `category_army` 宽分类覆盖这些组织/软攻缺口，`mot_fire_support` 与团属炮兵应接入深层突破和纵深控制收益。

状态：用户已通过，待统一实施。

### `deep_battle_no_lar`

处理：`不处理`

原版 v1.19 相对旧版变化：没有给 no-LAR 版本新增 `mot_fire_support` 或 `category_regimental_support_artillery`。

理由：保持与原版 v1.19 分支一致，不自行给 no-LAR 版本额外补同类项。

状态：用户已通过，待统一实施。

### `rapid_domination` / 快速支配

处理：`合入`

原版 v1.19 相对旧版变化：

```txt
forward_observers = {
    category_regimental_support_artillery = {
        breakthrough = 0.1
    }
}

advanced_firebases = {
    category_regimental_support_artillery = {
        soft_attack = 0.1
    }
}
```

执行方案：按原版 v1.19 数值合入以上两处。

理由：这是团属炮兵在快速支配线的侦察校射与前进火力基地收益；炮兵/团属炮兵火力适配不默认降档。虽然 MOD 当前已有部分 `category_army` 火力，但团属炮兵作为炮兵角色可吃专属收益。

状态：用户已通过，待统一实施。

### `expeditionary_warfare` / 远征战

处理：`不处理`

原版 v1.19 相对旧版变化：仅插入空 `ai_will_do = { }`，没有实质玩法数值变化。

理由：不需要为了空 AI 块改动 MOD 当前文件。

状态：用户已通过，待统一实施。

### `dispersed_operations` / 分散作战

处理：`合入`

原版 v1.19 相对旧版变化：新增完整作战子学说。

执行方案：整条按原版 v1.19 加入，包括基础效果和全部奖励节点：

- 基础：`enemy_army_bonus_air_superiority_factor = -0.10`、`land_reinforce_rate = 0.05`
- `camouflage_discipline`：敌空优影响降低、后勤连给步兵堑壕 `0.1 add = yes`
- `hardened_logistics`：后勤连组织、无补给宽限
- `local_air_defense`：防空炮组、支援防空、团属自行防空防空攻击
- `scattered_formations`：CAS 伤害减免
- `independent_operations`：步兵/装甲主动性、突破、组织和缺补给惩罚减免

理由：这是 v1.19 新增整条 DLC 作战子学说，不是局部数值补丁；当前 MOD 没有对应内容，应先完整合入，后续再实测平衡。

状态：用户已通过，待统一实施。
