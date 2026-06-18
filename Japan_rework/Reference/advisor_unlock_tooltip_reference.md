# HOI4 顾问解锁 Tooltip 键名参考

> 目的：记录国策、事件等内容在解锁顾问时应使用的标准 tooltip 键名。
>
> 说明：应根据顾问 `slot` 选择对应的 `available_xxx` 或 `remove_xxx` 键，而不是统一套用政治顾问键。

## 解锁类键名

| 顾问类型 / slot | 标准键名 |
| --- | --- |
| `political_advisor` | `available_political_advisor` |
| `army_chief` | `available_chief_of_army` |
| `navy_chief` | `available_chief_of_navy` |
| `air_chief` | `available_chief_of_airforce` |
| `high_command` | `available_military_high_command` |
| `theorist` | `available_theorist` |
| `designer` | `available_designer` |
| `industrial_concern` | `available_industrial_concern` |

## 移除类键名

| 顾问类型 / slot | 标准键名 |
| --- | --- |
| `political_advisor` | `remove_political_advisor` |
| `army_chief` | `remove_chief_of_army` |
| `navy_chief` | `remove_chief_of_navy` |
| `air_chief` | `remove_chief_of_airforce` |
| `high_command` | `remove_military_high_command` |
| `theorist` | `remove_theorist` |

## 用法示例

政治顾问：

```txt
custom_effect_tooltip = available_political_advisor
show_ideas_tooltip = JAP_erin
```

理论家：

```txt
custom_effect_tooltip = available_theorist
show_ideas_tooltip = JAP_reisen
```

总司令：

```txt
custom_effect_tooltip = available_military_high_command
show_ideas_tooltip = JAP_tewi
```

## 项目习惯

- 写国策或事件中的顾问解锁提示时，先看角色定义里的 `slot = ...`
- 再按本表选择对应的 `available_xxx`
- 不要把 `theorist`、`high_command`、`army_chief` 等都误写成 `available_political_advisor`
