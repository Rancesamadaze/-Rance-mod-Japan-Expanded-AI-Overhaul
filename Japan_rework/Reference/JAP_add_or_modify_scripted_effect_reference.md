# JAP add_or_modify 脚本效果使用说明

> 适用场景：在国策、决议、事件或 idea 中，为日本项目的动态修正追加变量奖励时，使用 `JAP_add_or_modify_xxx = yes` 这一组脚本效果。

## 定义位置

- 脚本效果定义：`common/scripted_effects/JAP_scripted_effects.txt`
- 动态修正定义：`common/dynamic_modifiers/zzz_japan_rework_dynamic_modifiers.txt`
- 常见使用位置：`common/national_focus/japan.txt`、`common/decisions/JAP.txt`

## 基本写法

在给某个动态修正添加变量奖励前，先调用对应的 `JAP_add_or_modify_xxx = yes`。

推荐格式：

```txt
custom_effect_tooltip = generic_skip_one_line_tt
JAP_add_or_modify_early_industrialization = yes
add_to_variable = { JAP_industry_consumer_goods_factor = -0.1 tooltip = consumer_goods_factor_tt }
add_to_variable = { JAP_industry_production_factory_max_efficiency_factor = 0.05 tooltip = production_factory_max_efficiency_factor_tt }
```

效果：

- 如果国家还没有对应动态修正，脚本效果会添加动态修正，并显示“添加”提示。
- 如果国家已经有对应动态修正，脚本效果会显示“修改”提示。
- 后续 `add_to_variable` 会把具体数值写入该动态修正引用的变量。

## 什么时候必须调用

新增或修改以下变量奖励时，应先调用对应脚本效果：

- 动态修正可能尚未存在。
- 玩家需要在国策/决议提示中看到“添加/修改某动态修正”的提示。
- 后续紧跟 `add_to_variable`，且变量名属于某个项目动态修正体系。

如果只是检查变量、清理变量，或处理一次性的非动态修正效果，不需要调用。

## 推荐提示顺序

常见国策奖励中使用：

```txt
custom_effect_tooltip = generic_skip_one_line_tt
JAP_add_or_modify_xxx = yes
add_to_variable = { ... tooltip = ... }
```

如果前面已经有一组无关奖励，例如资源、建筑、科技或单位奖励，建议在动态修正奖励前加：

```txt
custom_effect_tooltip = generic_skip_one_line_tt
```

这样 UI 提示会更清晰。

## 可用脚本效果对照

| 脚本效果 | 管理的默认动态修正 | 备注 |
|---|---|---|
| `JAP_add_or_modify_showa_statism` | `JAP_showa_statism_modifier` | 昭和国家主义相关奖励 |
| `JAP_add_or_modify_state_shintoism` | `JAP_state_shinotism_dm` | 国家神道相关奖励，注意项目内 key 拼作 `shinotism` |
| `JAP_add_or_modify_early_industrialization` | `JAP_early_industrialization_efforts_dm` / `JAP_the_economic_mirale_dm` | 工业化奖励；若经济奇迹已存在，会显示修改经济奇迹 |
| `JAP_add_or_modify_imperial_army` | `JAP_imperial_army_dm` / `JAP_national_army_dm` | 陆军奖励；若已转为国民军动态修正，会修改国民军 |
| `JAP_add_or_modify_imperial_navy` | `JAP_imperial_navy_dm` / `JAP_japanese_navy_dm` | 海军奖励；若已转为日本海军动态修正，会修改日本海军 |
| `JAP_add_or_modify_army_and_naval_air_services` | `JAP_army_and_naval_air_services_dm` / `JAP_japanese_airforce_dm` | 陆海军航空队/空军奖励 |
| `JAP_add_or_modify_east_asia_co_prosperity_sphere` | `JAP_east_asia_co_prosperity_sphere_dm` | 原版共荣圈 DM；`东亚新秩序` 先给予空壳，后续大东亚共荣圈/属国上供只维护变量 |
| `JAP_add_or_modify_imperial_way` | `JAP_the_imperial_way_dm` | 皇道派相关奖励 |
| `JAP_add_or_modify_advanced_weapon_projects` | `JAP_advanced_weapon_projects_dm` | 先进武器项目相关奖励 |
| `JAP_add_or_modify_civilian_cabinet` | `JAP_civilian_cabinet_modifier` | 文官内阁相关奖励 |
| `JAP_add_or_modify_communist_party_modifier` | `JAP_communist_party_modifier` | 日共路线相关奖励 |
| `JAP_add_or_modify_rounouha_modifier` | `JAP_rounouha_modifier` | 劳农派相关奖励 |

## 多状态动态修正

部分脚本效果会根据已有动态修正选择不同提示，而不一定添加默认版本：

```txt
JAP_add_or_modify_early_industrialization = yes
```

逻辑：

- 没有 `JAP_early_industrialization_efforts_dm` 且没有 `JAP_the_economic_mirale_dm`：添加 `JAP_early_industrialization_efforts_dm`
- 已有 `JAP_early_industrialization_efforts_dm`：显示修改早期工业化提示
- 已有 `JAP_the_economic_mirale_dm`：显示修改经济奇迹提示

类似结构也用于陆军、海军和空军体系。写奖励时不要手动判断这些分支，优先调用封装好的脚本效果。

## 变量命名规则

变量通常以动态修正体系为前缀：

- 早期工业化：`JAP_industry_...`
- 皇道派：`JAP_the_imperial_way_...`
- 昭和国家主义：`JAP_showa_statism_...`
- 国家神道：`JAP_state_shinotism_...`
- 陆军：`JAP_army_...`
- 海军：`JAP_navy_...` 或部分海军全局变量
- 空军：`JAP_airforce_...`
- 先进武器：`JAP_advanced_weapons_...`

若变量名或 modifier 不确定，先查：

- `common/dynamic_modifiers/zzz_japan_rework_dynamic_modifiers.txt`
- `Reference/modifier_trans.md`
- `Reference/variable_syntax_reference.md`

## 新增动态变量注册规范

新增某个动态修正变量时，不要只在国策、决议或事件里写 `add_to_variable`。需要同时完成以下检查：

1. 在 `common/dynamic_modifiers/zzz_japan_rework_dynamic_modifiers.txt` 中，把实际 modifier key 映射到新变量。
2. 如果同一体系有多状态动态修正，必须在所有等价动态修正里同步注册。例如陆军体系要同时检查 `JAP_imperial_army_dm` 和 `JAP_national_army_dm`。
3. 在对应国家历史文件里初始化变量为 `0`，日本本体通常放在 `history/countries/JAP - Japan.txt` 的同体系 `set_variable` 区。
4. 确认 tooltip key 可用。若 vanilla 已有同名 `*_tt` 可以直接复用；否则放到合适的本地化文件中，不要随手塞进无关本地化文件。
5. 如果 modifier key 不确定，先查 `Reference/modifier_trans.md`，必要时再核对 vanilla 动态修正或 idea 示例。

最常见的遗漏是只完成第 1 步和国策奖励，忘记第 3 步的历史初始化。这样新变量虽然会在后续 `add_to_variable` 时出现，但动态修正初始状态和提示更容易变得不稳定。

## 常见错误

- 只写 `add_to_variable`，但忘记先调用 `JAP_add_or_modify_xxx = yes`：动态修正不存在时，玩家不会获得可见修正。
- 多组不同动态修正奖励连续写在一起，没有 `generic_skip_one_line_tt`：提示会挤在一起。
- 给 A 体系变量调用 B 体系脚本效果：例如给 `JAP_industry_...` 变量前调用了 `JAP_add_or_modify_imperial_army`。
- 手动 `add_dynamic_modifier`：除非在做特殊转换，否则优先使用封装脚本效果，避免缺少本地化提示或多状态兼容。
