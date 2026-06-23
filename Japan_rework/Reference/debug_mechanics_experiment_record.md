# Debug 机制实验记录

> 日期：2026-06-22  
> 来源：`common/decisions/JAP_rework_debug_decisions.txt` 中的临时 debug 决议。本文只记录已经观察到的实验结果，不等同于正式机制设计。

## 放置理由

本文件放在 `Reference/`，用于保存一次性机制实验结论。这里的内容主要服务于后续脚本判断、debug 决议维护和机制取舍，不直接进入正式玩法设计。

## 1. 军工数量变量

测试对象：

- `num_of_military_factories`
- 满洲国军工上供类修正
- 决议标题中的动态变量显示

观察结果：

- 决议标题中读取的军工数量会反映当前实际可用的军工数量。
- 满洲国向宗主上供军工后，日本与满洲国读取到的军工数量变化符合预期。

结论：

- `num_of_military_factories` 可以按“当前实际可用军工数”理解。
- 这个读取结果符合“上供、控制、可用性等机制会影响当前可用军工”的实验预期。

后续用法：

- 如果脚本需要判断国家当前能实际使用多少军工，可以优先考虑这类数量读取。
- 如果要判断历史建造总量、地图上原始军工、被上供前的工厂数量，则不能直接用这个值代替。

## 2. 师统计与指挥权接管

测试对象：

- `every_country_division`
- `division_has_majority_template = infantry`
- `has_army_size = { size > 100 type = infantry }`
- 满洲国刷出并统计“日本步兵师”的 debug 决议

观察结果：

- 当前能稳定测试到的师级分类粒度主要是“师的主要构成”，例如是否以 `infantry` 为主要模板类型。
- 没有在本次实验中找到可以直接按现役师的具体编制名称精确统计数量的可靠原生读取项。
- 宗主接管指挥权后，相关部队在所有权统计上归宗主；此时在满洲国作用域下统计不到这些师。

结论：

- 通过 `division_has_majority_template = infantry` 或 `has_army_size = { type = infantry }` 只能解决粗粒度的兵种/主构成统计，不能替代“按具体编制名统计”。
- 如果实验目的要求“满洲国拥有多少个名为日本步兵师的现役师”，在宗主接管指挥权后，这条统计路径达不到原本目的。

后续用法：

- 若只需要判断某国是否拥有足够多的步兵主构成师，可以继续使用 `has_army_size`。
- 若需要跟踪某个 debug 刷兵按钮刷出了多少师，更可靠的方式是刷兵时维护一个国家变量作为累计记录。
- 若需要判断指挥权被接管后的部队，应重新考虑统计作用域，必要时从宗主作用域或事件记录变量入手。

## 3. `create_ship` 的 `creator` 与目标归属

测试对象：

- 在 `MAN` 作用域下执行 `create_ship`
- `creator = JAP`
- `equipment_variant = "长门级"`

观察结果：

- 可以通过设置 `creator = JAP` 让船使用日本已有的舰船设计。
- 船可以直接刷到当前执行 `create_ship` 的目标国家手里，同时使用日本设计。

结论：

- `creator` 可用于指定舰船设计来源。
- 船的实际归属仍可由执行 `create_ship` 的作用域控制；本次实验中，在满洲国作用域创建并指定 `creator = JAP` 可以得到“满洲国获得日本设计舰船”的效果。

后续用法：

- 给傀儡、盟友或测试国家发放指定日本设计舰船时，可以考虑使用“目标国家作用域 + `creator = JAP` + 指定 `equipment_variant`”的模式。
- 设计名必须与当前 MOD/开局中实际存在的设计名一致，例如本 MOD 中使用的是 `长门级`，不是原版英文或原版日文设计名。

## 4. `global.` 全局变量前缀

测试对象：

- `set_variable = { global.JAP_debug_global_variable_test = 0 }`
- `add_to_variable = { global.JAP_debug_global_variable_test = 10 }`
- 决议标题动态显示 `[?global.JAP_debug_global_variable_test|0]`

观察结果：

- 初始化决议可以把 `global.JAP_debug_global_variable_test` 设置为 `0`。
- 加值决议每点击一次可以让该变量增加 `10`。
- 切换国家后，决议标题读取到的是同一个变量值。

结论：

- `global.` 前缀可用于自定义全局变量。
- `global.JAP_debug_global_variable_test` 这类写法不是普通变量名，而是明确写入全局作用域。

后续用法：

- 需要跨国家共享的测试计数、世界级状态或全局进度，可以使用 `global.` 变量。
- 国家专属状态不应为了省作用域而写成全局变量，否则容易污染所有国家共享状态。

## 5. 负数工厂捐赠修正

测试对象：

- `industrial_factory_donations = -5`
- `dockyard_donations = -5`
- `num_of_civilian_factories`
- `num_of_civilian_factories_available_for_projects`
- `num_of_naval_factories`
- debug 决议 `JAP_debug_toggle_negative_factory_donations_idea`

观察结果：

- 在当前国家添加包含负数捐赠修正的 debug 民族精神后，民用工厂和海军船坞相关读数会下降。
- `num_of_civilian_factories_available_for_projects` 也会随负数民用工厂捐赠变化，说明该修正会影响“当时可用民工”的读取口径。
- 移除该 debug 民族精神后，相关读数可以恢复，用于反复对照。

结论：

- `industrial_factory_donations` 可以用负值扣减当前国家可用民用工厂口径。
- `dockyard_donations` 可以用负值扣减当前国家海军船坞口径。
- 这两个 modifier 不只是正向“捐赠”展示字段；负值在普通 debug 民族精神中也能产生可观察的工厂/船坞扣减效果。

后续用法：

- 若特殊属国系统需要模拟“民工被上供/抽调”或“船坞被宗主等效占用”，可以考虑用负数 `industrial_factory_donations`、`dockyard_donations` 在属国侧扣减可用工厂与船坞。
- 由于原版文档将这两个 modifier 标在 `government_in_exile` 分类下，正式玩法使用前仍应在目标属国场景中复测一次，包括普通属国、特殊自治等级、战争中与和平中、以及玩家/AI 控制差异。
- 如果用于长期机制，建议保留一个可逆 debug 决议，用来观察扣减前后的 `num_of_civilian_factories_available_for_projects` 与 `num_of_naval_factories`。
