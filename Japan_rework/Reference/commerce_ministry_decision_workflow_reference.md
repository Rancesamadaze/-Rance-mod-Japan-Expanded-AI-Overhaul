# 商工省决议编写流程参考
> 用途：整理当前“商工省”决议的完整编写流程，作为后续同类“国策解锁 -> 条件门槛 -> 启动决议 -> mission 验收 -> AI 配套 -> 阶段完成判定”内容的参考模板。  
> 当前样例：`发展首都圈`

## 适用场景

适合以下类型的内容：

- 一个国策先解锁某个决议组
- 决议组还要受额外政局条件限制
- 点击启动决议后，先发放一部分前置奖励
- 然后进入一个需要玩家或 AI 在期限内完成建设目标的 `mission`
- `mission` 根据是否达标发放不同奖励
- 无论成功或超时，都会设置项目完成 flag
- 多个项目再进一步汇总成“阶段完成”脚本条件

## 总体流程

当前“商工省”决议的推荐流程可以拆成 8 步：

1. 定义商工省决议组
2. 定义决议组显示所需的通用脚本条件
3. 给国策补解锁提示
4. 编写启动决议
5. 编写对应的 `mission`
6. 定义“阶段完成”脚本条件
7. 补齐商工省专用本地化
8. 为 AI 编写任务配套建造策略

---

## 1. 定义决议组

对应文件：
- `common/decisions/categories/JAP_ministry_of_commerce_and_industry_categories.txt`

当前样例作用：
- 定义决议组 `JAP_ministry_of_commerce_and_industry_decisions`
- 设置 `icon`、`priority`、`allowed`、`visible`、`available`、`visible_when_empty`

当前商工省使用的关键显示条件：
- 完成国策 `JAP_ministry_of_commerce_and_industry`
- 满足脚本条件 `JAP_dust_has_settled = yes`

这一部分决定的是：

- 决议组何时出现
- 玩家何时能看到整个分类

---

## 2. 定义通用脚本条件

对应文件：
- `common/scripted_triggers/JAP_rework_scripted_triggers.txt`

当前样例：
- `JAP_dust_has_settled`

对应本地化文件：
- `localisation/simp_chinese/JAP_ministry_of_commerce_and_industry_l_simp_chinese.yml`
- key：`JAP_dust_has_settled.tt`

这里的用途是：

- 把“政局趋于稳定”这类会被多个系统复用的条件抽出来
- 让决议组、国策、事件都能直接调用
- tooltip 直接写在 scripted trigger 里，便于统一维护

---

## 3. 给国策补解锁提示

对应文件：
- `common/national_focus/japan.txt`

当前商工省样例：

- 在国策 `JAP_ministry_of_commerce_and_industry` 的 `completion_reward` 中加入  
  `custom_effect_tooltip = JAP_unlock_ministry_of_commerce_and_industry_decisions_tt`

对应本地化文件：
- `localisation/simp_chinese/JAP_ministry_of_commerce_and_industry_l_simp_chinese.yml`

提示文本当前写法：
- `§Y政局趋于稳定§!后，解锁决议组：§Y商工省§!`

这一部分决定的是：

- 玩家完成国策时，是否能准确知道后续解锁逻辑

---

## 4. 编写启动决议

对应文件：
- `common/decisions/JAP_ministry_of_commerce_and_industry_decisions.txt`

当前样例：
- `JAP_shoko_develop_kanto`

启动决议通常负责：

- 校验最基础的点击条件
- 立即发放前置奖励
- 记录 `mission` 验收要用到的变量
- 显式启动 `mission`

当前“发展首都圈”启动决议做了这些事：

- 要求完全控制 `282`（关东）
- 立即给关东 `+2` 建筑位
- 立即给关东添加地区动态修正 `JAP_shoko_special_charter`
- 记录启动时的基建等级：`JAP_shoko_kanto_infra_pre`
- 记录后续民工目标：`JAP_shoko_kanto_civ_target`
- 使用 `activate_mission = JAP_shoko_develop_kanto_mission` 启动任务

这里特别要注意：

- 当前项目的 mission 通过 `activate_mission` 触发
- 不再依赖“flag + activation 条件自发出现”的旧写法
- 如果启动决议会让州进入新的工厂或其他共享建筑建造队列，通常也要同步补足对应的 `add_extra_state_shared_building_slots`

---

## 5. 编写 mission 决议

对应文件：
- `common/decisions/JAP_ministry_of_commerce_and_industry_decisions.txt`

当前样例：
- `JAP_shoko_develop_kanto_mission`

mission 决议通常负责：

- 定义期限
- 定义验收条件
- 定义成功奖励
- 定义超时奖励
- 设置项目完成 flag

当前样例使用的关键结构：

- `allowed = { always = no }`
- `activation = { always = no }`
- `days_mission_timeout = 180`
- `available = { ... }`
- `complete_effect = { ... }`
- `timeout_effect = { ... }`

当前 mission 的验收逻辑是：

1. 完全控制关东
2. 关东基建满足以下任一：
   - `infrastructure > 4`，即满基建
   - `building_level@infrastructure > JAP_shoko_kanto_infra_pre`
3. 关东民工满足：
   - `building_level@industrial_complex > JAP_shoko_kanto_civ_target`

关于“新增基建”验收条件的默认规范：

- 若任务要求“基础设施提升 1 级”之类的新增基建条件，默认应写成：
  - “新增条件”
  - 与
  - “已经满基建”
  两者取 `OR`
- 当前项目里通常写成：
  - `infrastructure > 4`
  - `OR`
  - `building_level@infrastructure > <记录的旧值变量>`
- 这样可以避免州在任务启动时就已经满基建，导致后续永远无法满足“新增 1 级基建”的问题
- 后续若有其他建筑也存在“已满级则无法继续增加”的情况，也应套用同样思路

当前奖励逻辑是：

- 成功：
  - 移除关东的 `JAP_shoko_special_charter`
  - 关东 `+2` 建筑位
  - 关东 `+2` 民工
- 超时：
  - 若 `Rance_is_jap_ai = yes`
    - 按成功奖励结算
    - 也就是给 `+2` 建筑位和 `+2` 民工
  - 否则
    - 移除关东的 `JAP_shoko_special_charter`
    - 关东 `+1` 建筑位
    - 关东 `+1` 民工
- 两边都会：
  - 清理临时变量
  - 设置项目完成 flag `JAP_shoko_kanto_construction_completed`

关于建筑槽的补充规范：

- 若奖励中包含 `industrial_complex`、`arms_factory`、`dockyard`、`energy_infrastructure`、`industrial_infrastructure` 等会占用共享建筑槽的建筑，奖励脚本应同步补足 `add_extra_state_shared_building_slots`
- 当前商工省第一阶段的统一模板是：
  - 启动决议：`+2` 建筑槽
  - 成功完成：`+2` 建筑槽
  - 普通超时：`+1` 建筑槽
  - AI 超时按完成奖励结算时：也拿 `+2` 建筑槽
- 像 `air_facility`、`land_facility` 这类不依赖共享建筑槽的奖励，不需要为它们额外补建筑槽
- 若一个奖励块同时发放多种会占共享槽的建筑，补槽数量要按该奖励块内实际新增的共享建筑总数来写，不能只按其中的民工、军工或船坞数量补
- 编写一串同模板地区开发决议时，务必检查后续新项目是否把这套建筑槽逻辑一并复制过去，避免只补建筑不补槽位

当前还补了取消逻辑：

- `cancel_trigger = { NOT = { has_full_control_of_state = 282 } }`
- `cancel_effect` 中移除 `JAP_shoko_special_charter`
- `cancel_effect` 中清理本项目临时变量

如果后续商工省其他地区开发项目也要在工程期间给予州级施工加成，推荐沿用这一模式：

- 启动决议时 `add_dynamic_modifier`
- mission 成功 / 超时 / 取消时 `remove_dynamic_modifier`

这里要用到的语法参考：

- 变量语法：`Reference/variable_syntax_reference.md`
- 建筑 effect：`Reference/building_reference.md`

---

## 5.1 商工省专用地区修正

对应文件：
- `common/dynamic_modifiers/zzz_japan_rework_dynamic_modifiers.txt`

当前样例：
- `JAP_shoko_special_charter`

当前定义作用：

- 使用与 `JAP_regional_development` 相同的图标
- 提供相同的州建设速度加成：
  - `state_production_speed_buildings_factor = 0.1`

设计目的：

- 不直接复用 `JAP_regional_development`
- 为商工省决议单独保留一套专用地区修正 key
- 避免后续与其他日本内容或原版联动发生语义冲突

对应本地化文件：
- `localisation/simp_chinese/JAP_ministry_of_commerce_and_industry_l_simp_chinese.yml`

当前 key：
- `JAP_shoko_special_charter`
- `JAP_shoko_special_charter_desc`

---

## 6. 定义阶段完成脚本条件

对应文件：
- `common/scripted_triggers/JAP_ministry_of_commerce_and_industry_scripted_triggers.txt`

当前样例：
- `JAP_shoko_phase_1_completed`

对应本地化文件：
- `localisation/simp_chinese/JAP_ministry_of_commerce_and_industry_l_simp_chinese.yml`
- key：`JAP_shoko_phase_1_completed.tt`

当前写法是：

```txt
JAP_shoko_phase_1_completed = {
	custom_trigger_tooltip = {
		tooltip = JAP_shoko_phase_1_completed.tt
		AND = {
			has_country_flag = JAP_shoko_kanto_construction_completed
			# Add more phase 1 project completion flags here.
		}
	}
}
```

这一层只负责：

- 定义“某一阶段是否全部完成”
- 通过项目完成 flag 汇总判定

这一层不负责：

- 定义阶段内项目怎么显示
- 定义阶段并行上限
- 定义项目本体奖励

特别说明：

- 即使当前第一阶段只有“关东开发”一个项目，也推荐写成 `AND = { ... }` 结构
- 这样后面第一阶段继续增加更多项目时，只需要往里面追加更多 `has_country_flag = JAP_shoko_xxx_completed`
- 不需要改 trigger 名称，也不需要改调用位置

---

## 7. 补齐商工省专用本地化

对应文件：
- `localisation/simp_chinese/JAP_ministry_of_commerce_and_industry_l_simp_chinese.yml`

不要放到：
- `localisation/simp_chinese/SEA_focus_l_simp_chinese.yml`

当前商工省样例需要补的本地化包括：

- 决议组名称和描述
- 国策解锁 tooltip
- 启动决议名称和描述
- mission 名称和描述
- mission 条件 tooltip
- scripted trigger 的 `.tt`
- 阶段完成 trigger 的 `.tt`

当前已用到的 key 示例：

- `JAP_ministry_of_commerce_and_industry_decisions`
- `JAP_unlock_ministry_of_commerce_and_industry_decisions_tt`
- `JAP_shoko_develop_kanto`
- `JAP_shoko_develop_kanto_mission`
- `JAP_shoko_develop_kanto_infra_requirement_tt`
- `JAP_shoko_develop_kanto_civ_requirement_tt`
- `JAP_dust_has_settled.tt`
- `JAP_shoko_phase_1_completed.tt`

格式参考：
- `Reference/localisation_formatting_reference.md`

---

## 8. 编写 AI 配套建造策略

对应文件：
- `common/ai_strategy/JAP_rework_ai_mission_constructions.txt`

相关参考：
- `common/ai_strategy/AI_Strategy_Reference/AI_building_strategy_reference.md`

当前样例的 AI 策略思路是：

- 只使用 `build_building`
- 允许少量混用总体工厂倾向调控，作为民工补建的辅助
  - 这里默认只指 `added_military_to_civilian_factory_ratio` 这类军工 / 民工比例调整
  - 不默认包括船坞相关比例调控，通常不要在商工省地区开发任务里混用 `dockyard_to_military_factory_ratio`
- 使用 `mission` 状态 + 决议记录变量控制“对应建筑未达标才启用”
- 是否强制要求“基建先完成，工厂策略才启用”，由具体地区项目设计决定

当前分成两段：

1. `JAP_shoko_develop_kanto_ai_infrastructure`
   - 任务激活中
   - 基建尚未达标
   - 高权重定点在关东修基建

2. `JAP_shoko_develop_kanto_ai_civs`
   - 任务激活中
   - 民工尚未达标
   - 定点在关东修民工
   - 并小幅提高全局民工倾向

这里特别说明：

- “只有基建完成后，民工策略才启用”不是商工省 AI 配套的统一强制规则
- 某些地区适合写成严格前置
- 某些地区则更适合只检查“民工目标未达标”本身
- 是否把基建完成作为工厂前提，由具体项目设计者决定

这套方式的优点是：

- AI 行为更精准
- 不容易跑到别州乱修
- 可以直接复用到后续其他“按建筑目标是否达标来启停”的任务型建设项目

---

## 当前样例涉及到的文件总表

### 决议组
- `common/decisions/categories/JAP_ministry_of_commerce_and_industry_categories.txt`

### 决议与 mission 本体
- `common/decisions/JAP_ministry_of_commerce_and_industry_decisions.txt`

### 国策联动
- `common/national_focus/japan.txt`

### 通用脚本条件
- `common/scripted_triggers/JAP_rework_scripted_triggers.txt`

### 商工省阶段脚本条件
- `common/scripted_triggers/JAP_ministry_of_commerce_and_industry_scripted_triggers.txt`

### 商工省专用动态修正
- `common/dynamic_modifiers/zzz_japan_rework_dynamic_modifiers.txt`

### 商工省本地化
- `localisation/simp_chinese/JAP_ministry_of_commerce_and_industry_l_simp_chinese.yml`

### AI 配套
- `common/ai_strategy/JAP_rework_ai_mission_constructions.txt`

### 参考资料
- `Reference/variable_syntax_reference.md`
- `Reference/building_reference.md`
- `Reference/localisation_formatting_reference.md`
- `common/ai_strategy/AI_Strategy_Reference/AI_building_strategy_reference.md`

---

## 一句话总结

商工省决议的标准写法是：

**国策解锁决议组 -> 通用 scripted trigger 控制政局门槛 -> 启动决议记录变量、添加商工省专用地区修正并 `activate_mission` -> mission 验收建设成果 -> 成功 / 超时 / 取消时移除地区修正并结算 -> 设置项目完成 flag -> 阶段完成 scripted trigger 汇总项目完成情况 -> 同步补齐 AI 建造策略和商工省专用本地化。**
## 第三阶段及以后地区条件

- 本条仅适用于 `商工省第三阶段` 及其后续阶段。
- 从第三阶段开始，地区开发项目默认额外增加一条州级条件：

```txt
OR = {
	is_core_of = JAP
	compliance > 50
}
```

- 这条条件通常应写在目标州的 `state scope` 内，不应直接写在国家层。
- 含义是：
  - 目标地区是日本核心州
  - 或该地区顺从度大于 50
- 如果某个第三阶段以后的项目有特殊设计，可以在具体项目中覆盖这条默认规则，但默认应先按这条执行。
