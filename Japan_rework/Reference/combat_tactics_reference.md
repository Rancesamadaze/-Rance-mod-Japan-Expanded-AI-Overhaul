# 陆战战术参考

来源：原版 `common/combat_tactics.txt`。
用途：学习和编写陆战战术、战术解锁、偏好战术权重，以及日本/Rance 专属强化战术。

## 入口文件

- 原版战术表：`D:\SteamLibrary\steamapps\common\Hearts of Iron IV\common\combat_tactics.txt`
- MOD 战术表：`common/combat_tactics.txt`
- 原版简体中文战术名：`D:\SteamLibrary\steamapps\common\Hearts of Iron IV\localisation\simp_chinese\tactics_l_simp_chinese.yml`
- 原版战术 DDS 图标：`D:\SteamLibrary\steamapps\common\Hearts of Iron IV\gfx\interface\landcombat\tactics`
- 学说里启用战术：`enable_tactic = tactic_id`
- 国策、决议、效果里解锁战术：`unlock_tactic = tactic_id`
- 偏好战术权重修正：`<tactic_id>_preferred_weight_factor = <number>`

战术表是 `common` 根目录下的 `common/combat_tactics.txt`，不是 `common/combat_tactics/` 目录。本 MOD 已克隆原版完整文件，后续可以在这份完整表里替换或追加专属战术。保守做法是维护完整同路径覆盖文件；不要先假设“只写一个只有新增战术的小文件”一定会和原版合并，除非进游戏实测过。

## 基本结构

需要被科技或学说识别的战术，id 必须以 `tactic_` 开头。

```hoi4
tactic_example = {
    only_show_for = JAP

    is_attacker = yes
    trigger = {
        tag = JAP
        is_attacker = yes
        phase = no
    }

    active = no

    base = {
        factor = 4
        modifier = {
            add = 4
            has_trait = panzer_expert
        }
    }

    picture = tactic_example
    countered_by = tactic_elastic_defense

    attacker_movement_speed = 0.15
    attacker = 0.15
    defender = -0.05
}
```

主要字段含义：

- `only_show_for = TAG`：只限制界面显示，不等于真正的适用限制。专属战术仍建议在 `trigger` 里加 `tag = JAP`、路线触发、旗帜或 `OWNER = { ... }`。
- `is_attacker = yes/no`：战术属于进攻方还是防御方。外层和 `trigger` 内部要保持一致。
- `trigger = { ... }`：战术进入随机池的条件。原版战术触发可以混用战斗侧条件和国家侧条件；国家侧常见写法是 `OWNER = { ... }`。
- `active = yes`：默认启用，只要触发满足就能进入随机池。
- `active = no`：默认不启用，需要通过学说、国策、决议或效果启用/解锁。
- `base = { factor = N }`：基础随机权重。里面可以写 `modifier = { add = N ... }` 或 `modifier = { factor = N ... }` 按条件调整权重。
- `picture = X`：战术图标名。优先复用原版图标；新图标可以放在 `gfx/interface/landcombat/tactics`，如果不显示，再参考原版 `SOV_tank_desant_blitz` 在 `interface/landcombat.gfx` 里的 `spriteType` 写法。
- `countered_by = tactic_other`：被哪个对方战术反制。
- 数值修正是小数倍率：`0.15` 表示 +15%，`-0.15` 表示 -15%。

原版常见战术修正：

- `attacker`：进攻方伤害/战斗表现修正。
- `defender`：防御方伤害/战斗表现修正。
- `attacker_movement_speed`：进攻方战斗中移动速度修正。
- `combat_width`：战斗宽度修正。
- `attacker_org_damage_modifier`：进攻方组织度伤害修正。
- `defender_org_damage_modifier`：防御方组织度伤害修正。

## 战斗阶段

原版在 `common/combat_tactics.txt` 顶部定义了几个非标准阶段：

- `close_combat`
- `tactical_withdrawal`
- `seize_bridge`
- `hold_bridge`
- `street_fighting`

在 `trigger` 里，`phase = no` 表示标准阶段；`phase = street_fighting` 表示只有正在巷战阶段时才可选。写在 `trigger` 外面的 `phase = street_fighting` 则会把战斗切换到该阶段。阶段内战术通常还会写 `display_phase = street_fighting`，用于界面显示。

不要轻易新增阶段。普通进攻、防守、专属路线战术通常维持 `phase = no` 就够了。

## 原版例子

`tactic_planned_attack` 对应简体中文“周密计划攻击”。它是进攻方战术，`active = no`，标准阶段，`base.factor = 4`，`picture = tactic_planned_attack`，效果是 `attacker = 0.15`。它由决战计划学说启用。

`tactic_unexpected_thrust` 对应简体中文“奇袭”。它是进攻方战术，`active = no`，标准阶段，`base.factor = 4`，`picture = tactic_unexpected_thrust`，效果是 `attacker_movement_speed = 0.15` 和 `attacker = 0.15`。它由机动作战学说启用。

`tactic_ambush` 对应简体中文“伏击”。它是防御方战术，`active = yes`，标准阶段，需要技能优势、技能等级或 `trickster` 特质，`base.factor = 4`，被 `tactic_breakthrough` 反制，效果是 `attacker = -0.25`。

`tactic_blitz` 对应简体中文“闪电战”。它是进攻方战术，`active = no`，需要 `hardness > 0.5`，还需要技能等级、装甲将领特质或技能优势。它被 `tactic_elastic_defense` 反制，给进攻方移动速度和攻击加成；如果国家已经拥有 `tactic_masterful_blitz`，原版 `tactic_blitz` 会被排除。

## 本 MOD：風林火山四战术

`rance_furinkazan` 不再直接解锁原版通用战术，而是通过 4 个里程碑解锁 4 个 `active = no` 的日本专属战术；PHANTASM 难度奖励决议 `JAP_rai_buff_phantasm` 也会一次性 `unlock_tactic` 这四个战术，作为高难 AI 的直接战术补强入口：

- Infantry / Forest：`tactic_rance_steady_as_forest`，中文名“其徐如林”，防御方高优先级迟滞战术。当前基础权重为 100，不设置条件权重变化，不写 `countered_by`，并要求 `frontage_full = no`，只有前线尚未填满时才进入候选。效果是 `combat_width = -0.50`、`attacker = -0.8`、`defender = -0.6`、`attacker_org_damage_modifier = -0.25`、`attacker_movement_speed = -0.5`，表达防守方在战线尚未完全展开时收缩接战面、拖慢攻势并削弱进攻方组织度伤害输出。
- Combat Support / Mountain：`tactic_rance_immovable_as_mountain`，中文名“不動如山”，防御方常态阵地守势战术。当前基础权重为 25，不设置条件权重变化，不写 `countered_by`。效果是 `attacker = -0.2`、`defender = 0.3`、`defender_org_damage_modifier = 0.25`、`attacker_movement_speed = -0.25`，直接削弱进攻方、强化防御方并提高防守方组织度伤害输出。
- Armor / Fire：`tactic_rance_raiding_as_fire`，中文名“侵掠如火”，进攻方投入预备队强攻战术。当前基础权重为 100，不设置条件权重变化，不写 `countered_by`，并仿照“人海冲锋”要求 `frontage_full = yes` 与 `has_reserves = yes`，只有前线已满且有预备队时才进入候选。效果是 `attacker = 0.30`、`defender = -0.15`、`combat_width = 0.5`、`attacker_org_damage_modifier = 0.25`，表达在战线已经拥挤时继续投入后备力量，扩大正面并提高进攻方组织度伤害输出。
- Operations / Wind：`tactic_rance_swift_as_wind`，中文名“其疾如風”，进攻方常态机动战术。当前基础权重为 25，不设置条件权重变化，不写 `countered_by`。效果是 `attacker_movement_speed = 0.5`、`attacker = 0.2`、`defender = -0.25`、`defender_org_damage_modifier = -0.25`，以高推进速度为主要特色，并压低防御方战斗表现和组织度伤害输出。

这些战术均保留 `only_show_for = JAP` 作为显示辅助，实际身份限制写在 `trigger` 的国家 scope 里：`OWNER = { OR = { tag = JAP is_subject_of = JAP } }`。战术 `trigger` 的直接 scope 是战斗员，`is_subject_of` 必须放进 `OWNER` 后才能按国家判断；因此日本本体和日本直属属国都能满足战术触发条件，其他国家不会进入候选；图标先复用原版战术图标，等机制稳定后再考虑自定义 DDS。

当前风、火的设计思路是分层优先级：`其疾如風` 不加额外战场条件，用 25 权重和高移动修正作为風林火山进攻端的常态高优先级选择；`侵掠如火` 反过来加上 `frontage_full = yes` 与 `has_reserves = yes`，让它只在前线已满且仍有预备队可投入时出现，再用 100 权重保证一旦满足条件就强烈压过普通进攻战术。配套地，原版 `tactic_banzai_charge` 与强化版 `tactic_grand_banzai_charge` 的 `trigger` 都在 `OWNER` 内排除 `tactic_rance_swift_as_wind` 与 `tactic_rance_raiding_as_fire`，只要風、火任一战术已解锁，万岁冲锋两个版本都会退出候选；在風、火尚未解锁时，它们仍以 10 基础权重作为日本专属进攻战术存在。

当前林、山的设计思路也是分层优先级：`其徐如林` 与火相对，使用 `frontage_full = no` 和 100 权重，表示防御方在战线尚未填满时优先采取收缩、迟滞和压制进攻组织度的手段；`不動如山` 则不加额外战场条件，用 25 权重作为風林火山防御端的常态守势，在没有触发林的局面中提供稳定阵地防御和反组织度伤害。

## 专属强化版模板

如果要做某个国家、路线或国策的强化版战术，优先采用原版“旧战术让位，新战术解锁”的结构：

```hoi4
tactic_old = {
    trigger = {
        is_attacker = yes
        phase = no
        OWNER = { NOT = { has_tactic = tactic_new } }
    }
    active = yes
}

tactic_new = {
    only_show_for = JAP
    is_attacker = yes
    trigger = {
        tag = JAP
        is_attacker = yes
        phase = no
    }
    active = no
}
```

然后在国策、决议或脚本效果里解锁：

```hoi4
hidden_effect = {
    unlock_tactic = tactic_new
}
custom_effect_tooltip = some_tactic_unlock_tt
```

原版可参考：

- `tactic_banzai_charge` 在日本解锁 `tactic_grand_banzai_charge` 后让位。
- `tactic_blitz` 在国家拥有 `tactic_masterful_blitz` 后让位。

对本 MOD 来说，`only_show_for` 只能当显示辅助，不能当真正锁。专属战术要加真实条件，比如 `tag = JAP`、路线触发、国策旗帜、国家精神，或 `OWNER = { ... }`。

## 解锁与权重

学说节点可以启用 `active = no` 的战术：

```hoi4
enable_tactic = tactic_unexpected_thrust
```

国策、决议、事件、脚本效果可以解锁战术：

```hoi4
unlock_tactic = tactic_grand_banzai_charge
```

偏好战术权重使用按战术 id 生成的修正：

```hoi4
tactic_planned_attack_preferred_weight_factor = 1
tactic_grand_banzai_charge_preferred_weight_factor = 2
choose_preferred_tactics_cost = -15
```

相关原版 defines：

- `RECON_SKILL_IMPACT = 5`：侦察优势在战术选择中折算为多少技能点。
- `TACTIC_SWAP_FREQUENCEY = 12`：多少小时更换一次战术。
- `PREFERRED_TACTIC_CHARACTER_SKILL_LEVEL_REQUIRED = 5`：将领/元帅可选择偏好战术所需等级。
- `COUNTRY_PREFERRED_TACTIC_WEIGHT_FACTOR = 0.25`：国家偏好战术额外权重。
- `ARMY_GENERAL_PREFERRED_TACTIC_WEIGHT_FACTOR = 0.5`：陆军将领偏好战术额外权重。
- `FIELD_MARSHAL_PREFERRED_TACTIC_WEIGHT_FACTOR = 0.25`：元帅偏好战术额外权重。
- `PREFERRED_TACTIC_COMMAND_POWER_COST = 20`：更改偏好战术的指挥点花费。
- `AI_PREFERRED_TACTIC_WEEKLY_CHANGE_CHANCE = 0.05`：AI 每周自动选择新偏好战术的概率。

本 MOD 的 `common/ideas/JAP_rework_academy_spirit.txt` 里已有一条被注释的例子：`tactic_grand_banzai_charge_preferred_weight_factor = 2`。后续如果要让军校精神偏向某个专属战术，可以沿这个模式做。

## 本地化

新增战术名应放在合适的 `localisation/simp_chinese/` 文件中，并使用 UTF-8 with BOM。不要把无关战术文本塞进 `localisation/simp_chinese/SEA_focus_l_simp_chinese.yml`。

```yaml
l_simp_chinese:
 tactic_example: "示例战术"
 some_tactic_unlock_tt: "\n启用战术：§Y$tactic_example$§!"
```

## 编写检查表

1. 判断战术是默认可用的 `active = yes`，还是需要解锁的 `active = no`。
2. 先定进攻方/防御方，并让外层和 `trigger` 内的 `is_attacker` 一致。
3. 普通战术保留 `phase = no`；只有想做多阶段战斗流时才切阶段。
4. 给战术写窄触发：阵营侧、阶段、国家、路线、旗帜、地形、单位类型、硬度、技能或特质。
5. 设置 `base.factor` 和条件权重 `modifier`。
6. 只有真的需要被某战术反制时才写 `countered_by`。
7. 先复用原版 `picture`；等机制稳定后再加自定义 DDS/interface。
8. 添加中文本地化和解锁提示。
9. 用学说 `enable_tactic`，或国策/决议/效果 `unlock_tactic` 接入。
10. 如果是替换旧战术，在旧战术 `trigger` 里加 `OWNER = { NOT = { has_tactic = new_tactic } }`。
11. 如果要照顾 AI，优先用偏好权重或 AI 专属条件；不要直接把全局 `base.factor` 拉得过高。
