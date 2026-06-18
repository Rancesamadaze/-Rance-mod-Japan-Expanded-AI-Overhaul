# HOI4 使用脚本化文本实现动态本地化流程整理

> 说明：本文档由 GPT 生成，后续已按原版 scripted localisation 写法修正关键结论；在没有更权威项目或实测结果推翻前，可作为临时可信参考使用。

## 一、核心思路

HOI4 的动态本地化通常通过 `scripted_localisation` 实现。

核心逻辑是：

> 普通本地化键不直接写死文本，而是调用一个 `defined_text`；游戏根据触发条件选择不同的 `localization_key`，从而显示不同文本。

重要结论：

- 一个 `defined_text` 调用应理解为从多个 `text = { ... }` 候选中选出一个 `localization_key`。
- 多个 `text` 分支同时满足时，不应假定它们会按理想顺序稳定返回，也不会自动拼接成多行文本。
- 原版常见写法是让分支条件互斥，或把无 `trigger` 的分支作为最后 fallback。
- 如果需要同时显示多个独立奖励，优先使用多个本地化调用、多个 `custom_modifier_tooltip`，或显式枚举组合文本。

简单说：

```txt
普通本地化键
    ↓
调用 scripted localisation
    ↓
判断 trigger
    ↓
返回对应 localization_key
    ↓
显示对应文本
```

---

## 二、常用文件结构

一般涉及两个主要位置：

```txt
你的MOD/
├─ common/
│  └─ scripted_localisation/
│     └─ XXX_scripted_localisation.txt
└─ localisation/
   └─ simp_chinese/
      └─ XXX_l_simp_chinese.yml
```

如果动态文本用于 GUI，还可能涉及：

```txt
interface/
└─ XXX.gui
```

---

## 三、scripted localisation 的基本写法

在：

```txt
common/scripted_localisation/RA_scripted_localisation.txt
```

写入：

```txt
defined_text = {
    name = RA_JAP_doctrine_dynamic_desc

    text = {
        trigger = {
            has_completed_focus = JAP_army_modernization
        }
        localization_key = RA_JAP_doctrine_dynamic_desc_modernized
    }

    text = {
        trigger = {
            has_completed_focus = JAP_old_guard_compromise
        }
        localization_key = RA_JAP_doctrine_dynamic_desc_old_guard
    }

    text = {
        localization_key = RA_JAP_doctrine_dynamic_desc_default
    }
}
```

含义如下：

| 字段 | 作用 |
|---|---|
| `defined_text` | 定义一组动态文本 |
| `name` | 动态文本的调用名 |
| `text` | 一个候选文本分支 |
| `trigger` | 该文本分支的触发条件 |
| `localization_key` | 条件成立时实际显示的本地化键 |
| 无 `trigger` 的 `text` | 默认文本，作为 fallback |

---

## 四、在本地化文件中定义实际文本

在：

```txt
localisation/simp_chinese/RA_l_simp_chinese.yml
```

写入：

```yaml
l_simp_chinese:
 RA_JAP_doctrine_dynamic_desc_default:0 "日本陆军仍在旧有经验与现代化需求之间摇摆。"
 RA_JAP_doctrine_dynamic_desc_modernized:0 "日本陆军已经完成现代化改革，新的装甲与机动思想正在成型。"
 RA_JAP_doctrine_dynamic_desc_old_guard:0 "旧派军官集团仍然保有强大影响，改革只能以妥协方式推进。"
```

注意：

```txt
localization_key = RA_JAP_doctrine_dynamic_desc_modernized
```

指向的就是 `.yml` 文件中的：

```yaml
RA_JAP_doctrine_dynamic_desc_modernized:0 "..."
```

---

## 五、让某一个普通键调用动态文本

假设你要让某个国策描述动态变化：

```yaml
l_simp_chinese:
 JAP_army_doctrine_reform_desc:0 "[ROOT.RA_JAP_doctrine_dynamic_desc]"
```

逻辑是：

```txt
JAP_army_doctrine_reform_desc
        ↓
调用 [ROOT.RA_JAP_doctrine_dynamic_desc]
        ↓
进入 common/scripted_localisation 里的 defined_text
        ↓
根据 trigger 选择实际 localization_key
        ↓
显示对应中文文本
```

也就是说：

> 不是让 `JAP_army_doctrine_reform_desc` 自己变来变去，而是让它调用一个动态文本函数。

---

## 六、适用范围限制

`[GetXxx]` / `[ROOT.Xxx]` 这类动态调用不是所有本地化键都会解析。它适合国策名/描述、事件文本、决议文本、自定义提示、GUI 文本等会执行动态本地化解析的入口。

不要默认把它用于所有静态数据名称。已确认需要避免的例子：

```yaml
Rance_JAP_A_infantry: "[GetRanceJAPArmyNamePrefix]步兵"
```

`common/units` 里的 `sub_units` 兵种/营名称本地化会把上述内容当普通字符串显示，实际界面会出现 `[GetRanceJAPArmyNamePrefix]步兵`，不会调用 `defined_text`。

如果必须让这类名称随条件变化，不能只改同一个本地化 key；应考虑拆成不同的单位 key / 装备 key / GUI 展示文本，或用脚本在支持动态解析的提示文本里另行说明。

---

## 七、Scope 写法说明

常见调用形式：

```yaml
某键:0 "[ROOT.RA_JAP_doctrine_dynamic_desc]"
```

也可以写成：

```yaml
某键:0 "[JAP.RA_JAP_doctrine_dynamic_desc]"
```

常见 scope 含义：

| 写法 | 用途 |
|---|---|
| `[ROOT.xxx]` | 以当前作用域为判断对象 |
| `[JAP.xxx]` | 固定以日本为判断对象 |
| `[FROM.xxx]` | 事件或效果链中以前一个来源对象为判断对象 |

一般建议：

- 国策描述、决议描述中，优先尝试 `[ROOT.xxx]`
- 如果文本一定只服务于日本，可以尝试 `[JAP.xxx]`
- 事件中如果涉及其他国家，需要根据事件 scope 判断使用 `ROOT`、`FROM` 或其他 scope

---

## 八、完整例子：国策描述动态变化

### 1. 国策文件

```txt
focus = {
    id = JAP_army_doctrine_reform
    icon = GFX_goal_generic_army_doctrines
    x = 10
    y = 3
    cost = 10

    completion_reward = {
        army_experience = 25
    }
}
```

国策本体不需要特殊写法。

---

### 2. 本地化文件

```yaml
l_simp_chinese:
 JAP_army_doctrine_reform:0 "陆军学说改革"
 JAP_army_doctrine_reform_desc:0 "[ROOT.RA_JAP_army_doctrine_reform_desc]"
 
 RA_JAP_army_doctrine_reform_desc_default:0 "陆军内部仍在争论未来战争的方向。"
 RA_JAP_army_doctrine_reform_desc_armor:0 "装甲部队的改革成果已经改变了陆军对突破作战的理解。"
 RA_JAP_army_doctrine_reform_desc_infantry:0 "步兵中心主义仍然主导陆军改革，火力、组织与持久战被放在首位。"
```

---

### 3. scripted localisation 文件

```txt
defined_text = {
    name = RA_JAP_army_doctrine_reform_desc

    text = {
        trigger = {
            has_completed_focus = JAP_armor_modernization
        }
        localization_key = RA_JAP_army_doctrine_reform_desc_armor
    }

    text = {
        trigger = {
            has_completed_focus = JAP_infantry_reform
        }
        localization_key = RA_JAP_army_doctrine_reform_desc_infantry
    }

    text = {
        localization_key = RA_JAP_army_doctrine_reform_desc_default
    }
}
```

这样，玩家看到的同一个国策描述：

```yaml
JAP_army_doctrine_reform_desc
```

会根据日本是否完成某些国策而变化。

---

## 九、分支互斥比顺序更重要

`text = { ... }` 是候选文本分支，不是追加文本行。一个 `defined_text` 通常只应返回一个 `localization_key`。

原版脚本本地化的可靠模式是：

```txt
最特殊且互斥的条件
↓
较一般且互斥的条件
↓
无 trigger 的默认文本
```

例如：

```txt
defined_text = {
    name = RA_JAP_status_text

    text = {
        trigger = {
            has_completed_focus = JAP_total_army_reform
            has_war = yes
        }
        localization_key = RA_JAP_status_total_reform_at_war
    }

    text = {
        trigger = {
            has_completed_focus = JAP_total_army_reform
            NOT = { has_war = yes }
        }
        localization_key = RA_JAP_status_total_reform
    }

    text = {
        localization_key = RA_JAP_status_default
    }
}
```

这里第二个分支显式写了 `NOT = { has_war = yes }`，保证它不会和第一个分支同时成立。不要只依赖“更特殊条件放在前面”来处理重叠。

错误示范：

```txt
defined_text = {
    name = RA_JAP_status_text

    text = {
        trigger = {
            has_completed_focus = JAP_total_army_reform
        }
        localization_key = RA_JAP_status_total_reform
    }

    text = {
        trigger = {
            has_completed_focus = JAP_total_army_reform
            has_war = yes
        }
        localization_key = RA_JAP_status_total_reform_at_war
    }
}
```

在这个错误示范中，两个分支可能同时满足。即使某些场景看起来像是按顺序选中了其中一个，也不应把这种重叠作为可靠逻辑。原版更常见的安全写法是使用 `NOT = { ... }` 拆出互斥条件，或把所有组合状态明确枚举出来。

如果目标是同时显示多段独立奖励，例如“奖励 A 已触发”和“奖励 B 已触发”都要显示，单个 `defined_text` 不是合适的追加容器。可选方案：

- 保留多个独立的本地化调用或 `custom_modifier_tooltip`。
- 写出 `A+B`、`A`、`B`、默认状态等组合分支，并确保这些组合互斥。
- 改用其他能自然承载多段 tooltip 的结构。

---

## 十、GUI 场景中的调用方式

如果动态文本用于 `.gui` 文件，可以让 GUI 文本框指向一个普通本地化键。

例如：

```txt
instantTextboxType = {
    name = "ra_status_text"
    position = { x = 20 y = 40 }
    font = "hoi_18mbs"
    text = "RA_JAP_STATUS_TEXT"
    maxWidth = 400
    maxHeight = 200
}
```

然后在本地化文件中写：

```yaml
l_simp_chinese:
 RA_JAP_STATUS_TEXT:0 "[ROOT.RA_JAP_status_text]"
```

再在 scripted localisation 中写：

```txt
defined_text = {
    name = RA_JAP_status_text

    text = {
        trigger = {
            has_war = yes
        }
        localization_key = RA_JAP_status_text_at_war
    }

    text = {
        localization_key = RA_JAP_status_text_peace
    }
}
```

对应本地化：

```yaml
l_simp_chinese:
 RA_JAP_status_text_at_war:0 "帝国已经进入战争状态，陆军必须立即完成动员。"
 RA_JAP_status_text_peace:0 "帝国暂处和平时期，陆军改革可以稳步推进。"
```

---

## 十一、bound localization 补充

较新版本的 HOI4 还加入了 `bound localization`。

它的用途是：

> 从脚本中向本地化文本传入变量。

传统 `defined_text` 更适合根据条件切换整段文本，而 `bound localization` 更适合把某个变量塞进文本模板。

大致示意：

```txt
bound_tooltip = {
    localization_key = SCIENTIST_ROSTER_SORT_BUTTON_TOOLTIP
    REASON = SCIENTIST_ROSTER_SORT_BY_NAME_REASON
}
```

对应本地化：

```yaml
SCIENTIST_ROSTER_SORT_BUTTON_TOOLTIP: "§Y点击§!以按照$REASON|Y$排序"
```

可以粗略区分为：

| 类型 | 适合用途 |
|---|---|
| `defined_text` / scripted localisation | 根据条件切换整段文本 |
| `bound localization` | 给一个文本模板注入变量 |
| 普通 localization formatter | 从已有对象、变量或 token 中取格式化文本 |

对于一般 MOD 文本动态变化，优先掌握 `defined_text` 即可。

---

## 十二、实用检查清单

制作动态本地化时，可以按这个顺序检查：

```txt
1. 普通 loc 键是否存在？
   例如：
   JAP_xxx_desc:0 "[ROOT.RA_dynamic_text]"

2. scripted_localisation 里的 name 是否完全一致？
   例如：
   name = RA_dynamic_text

3. 每个 localization_key 是否都在 yml 里定义？

4. yml 文件是否有正确语言头？
   例如：
   l_simp_chinese:

5. 文件路径是否正确？
   common/scripted_localisation/
   localisation/simp_chinese/

6. 条件触发是否真的成立？

7. 是否有 fallback？
   最后最好保留一个无 trigger 的 text 分支。

8. 是否存在重叠 trigger？
   不要只靠分支顺序处理重叠；特殊条件、一般条件和 fallback 应尽量互斥。

9. 是否需要刷新界面？
   有些文本不是即时刷新，可能需要切换界面、过一天，或重新加载存档。

10. scope 是否正确？
   ROOT、FROM、JAP 等 scope 错误会导致条件判断对象不对。
```

---

## 十三、推荐命名规范

对于 RA-mod / 日本拓展这类项目，建议采用相对统一的命名风格。

### 1. 动态文本函数名

```txt
RA_JAP_xxx_dynamic_desc
RA_JAP_xxx_dynamic_name
RA_JAP_xxx_dynamic_tooltip
RA_JAP_xxx_status_text
```

### 2. 普通展示本地化键

```txt
RA_JAP_XXX_STATUS_TEXT
RA_JAP_XXX_DYNAMIC_TOOLTIP
```

### 3. 实际文本分支键

```txt
RA_JAP_xxx_desc_default
RA_JAP_xxx_desc_armor
RA_JAP_xxx_desc_infantry
RA_JAP_xxx_desc_war
RA_JAP_xxx_desc_peace
```

推荐区分：

| 类型 | 命名风格 |
|---|---|
| `defined_text` 的 `name` | 语义清晰，可用小写混合 |
| 普通展示键 | 可用全大写 |
| 实际文本分支键 | 与动态文本名保持同前缀 |

---

## 十四、适合 RA-mod 的示例写法

### 1. scripted localisation

```txt
defined_text = {
    name = RA_JAP_armor_doctrine_status

    text = {
        trigger = {
            has_completed_focus = JAP_armor_vanguard_doctrine
        }
        localization_key = RA_JAP_armor_doctrine_status_vanguard
    }

    text = {
        trigger = {
            has_completed_focus = JAP_mobile_defense_doctrine
        }
        localization_key = RA_JAP_armor_doctrine_status_mobile_defense
    }

    text = {
        localization_key = RA_JAP_armor_doctrine_status_default
    }
}
```

---

### 2. 本地化文件

```yaml
l_simp_chinese:
 RA_JAP_ARMOR_DOCTRINE_STATUS_TEXT:0 "[ROOT.RA_JAP_armor_doctrine_status]"

 RA_JAP_armor_doctrine_status_default:0 "装甲部队仍处于学说试验的早期阶段。"
 RA_JAP_armor_doctrine_status_vanguard:0 "装甲先锋学说已经确立，陆军将突破与机动视为未来战争的核心。"
 RA_JAP_armor_doctrine_status_mobile_defense:0 "机动防御思想已经成为装甲部队改革的主轴。"
```

---

## 十五、最小模板

如果只是想快速套用，可以使用这个最小模板。

### 1. 本地化键调用动态文本

```yaml
l_simp_chinese:
 JAP_some_focus_desc:0 "[ROOT.RA_JAP_some_dynamic_desc]"

 RA_JAP_some_dynamic_desc_default:0 "默认文本。"
 RA_JAP_some_dynamic_desc_condition_a:0 "条件 A 成立时显示的文本。"
 RA_JAP_some_dynamic_desc_condition_b:0 "条件 B 成立时显示的文本。"
```

### 2. scripted localisation

```txt
defined_text = {
    name = RA_JAP_some_dynamic_desc

    text = {
        trigger = {
            has_completed_focus = JAP_condition_a_focus
        }
        localization_key = RA_JAP_some_dynamic_desc_condition_a
    }

    text = {
        trigger = {
            has_completed_focus = JAP_condition_b_focus
        }
        localization_key = RA_JAP_some_dynamic_desc_condition_b
    }

    text = {
        localization_key = RA_JAP_some_dynamic_desc_default
    }
}
```

---

## 十六、总结

使用脚本化文本对某一个键实行动态本地化的流程可以概括为：

```txt
1. 在普通 yml 中保留原本要显示的键。
2. 让这个键的文本内容调用一个 scripted localisation。
3. 在 common/scripted_localisation 中定义 defined_text。
4. 在 defined_text 中写多个互斥的候选 text 分支。
5. 每个分支用 trigger 判断条件，或把最后一个无 trigger 分支作为 fallback。
6. 每个分支返回一个 localization_key。
7. 在 yml 中写好这些 localization_key 对应的实际文本。
8. 如果多个状态可能同时成立，改成互斥 trigger、组合分支，或多个独立本地化调用。
```

一句话总结：

> `本地化键` 负责被游戏调用，`defined_text` 负责从候选分支中选择一个 `localization_key`，`localization_key` 负责返回实际显示文本。
