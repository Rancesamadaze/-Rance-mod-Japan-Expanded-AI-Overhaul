# HOI4 国策语法 AI 学习手册（精简版）

> 用途：供 AI 学习 Hearts of Iron IV 国策相关**语法结构、字段位置、常见写法与注意事项**。  
> 目标：让 AI 在编写或修改国策时，尽量做到**结构正确、字段位置正确、语义稳定**。  
> 范围：仅整理上传模板中**对写代码有直接帮助**的部分；删除重复、闲聊式解释与不稳定表述。  
> 来源：根据用户提供的国策模板整理。fileciteturn0file0

---

## 1. 总原则

1. AI 生成国策代码时，应优先保证：
   - **块结构正确**
   - **字段放在正确层级**
   - **引用 id 正确**
   - **前置 / 互斥 / 位置关系逻辑一致**

2. 不确定某字段是否支持时，**不要臆造字段名**。

3. 同类结构中常见字段可复用，但要注意：
   - `focus_tree`、`focus`、`shared_focus`、`joint_focus`、`continuous_focus_palette` 不是同一级概念。
   - `focus` 是普通国策条目。
   - `shared_focus` / `joint_focus` 是共享类国策定义。
   - `continuous_focus_palette` 是持续性国策面板，不是普通国策树。

4. 某些动态显示相关内容**不会实时刷新**，往往需要刷新国策树布局。

---

## 2. 国策树基本骨架

文件位置通常为：`common/national_focus/xxx.txt`

```txt
focus_tree = {
    id = MOD_focus_tree

    country = {
        factor = 0
        modifier = {
            add = 10
            tag = GER
        }
    }

    default = no
    continuous_focus_position = { x = 1200 y = 100 }

    focus = {
        id = MOD_example_focus
        x = 0
        y = 0
        cost = 10

        completion_reward = {
        }
    }
}
```

### 关键字段

#### `id`
国策树 id。

#### `country = { ... }`
用于决定哪个国家使用这棵国策树，以及权重修正。

常见写法：

```txt
country = {
    factor = 0
    modifier = {
        add = 10
        tag = GER
    }
}
```

- `factor = 0`：基础权重通常不要乱改。
- `modifier`：通过条件给特定国家增加权重。

#### `default = no`
是否为通用国策树。一般专属树写 `no`。

#### `continuous_focus_position = { x = ... y = ... }`
持续性国策按钮在总界面中的位置。

---

## 2.1 国策树布局大局观

`focus_tree` 应先被理解为整张国策树画布的配置。它决定：

- 哪个国家使用这棵树
- 这棵树是不是通用树
- 打开国策界面时应看向哪里
- 持续性国策按钮和界面附加元素放在哪里
- 第一排根节点如何给整棵树预留横向空间

### 树选择不是节点布局

```txt
country = {
    factor = 0
    modifier = {
        add = 10
        tag = MAN
        has_country_flag = MOD_special_subject
    }
}
```

`country = { ... }` 是树选择权重，不是显示条件。专属树通常用 `factor = 0`，再用 `modifier` 给目标国家加权。

如果同一个国家可能命中多棵树，应让条件互斥，或让目标树权重明显高于其他树。不要只写一个宽泛的 `tag = XXX`，然后再建立另一棵同样命中该 tag 的树。

### 根节点坐标不是默认值

第一枚或第一排根国策通常没有 `relative_position_id`，所以它们的 `x/y` 是整棵树的绝对锚点。这个数值不能随手写 `x = 0 y = 0`。

根节点的横向位置应按整棵树的左侧展开空间来定：

```txt
root_x = 根节点左侧最大展开格数 + 左侧安全边距
root_y = 0
```

如果树会从根节点向左展开 4 格，根节点至少应放到 `x = 4` 或更右。只有树完全不向左展开，或你明确要把根节点贴在最左侧时，`x = 0` 才是合理选择。

原版参考：

- 满洲国树第一枚国策使用 `x = 6 y = 0`，因为后续分支需要左侧空间。
- 日本树第一枚大路线节点使用 `x = 12 y = 0`，因为整棵树横向规模更大。
- 通用树有多个第一排根节点，例如陆军、空军、海军、工业、政治分散在不同 `x` 上，这是典型的“多泳道”布局。

### 先划泳道，再填节点

设计一棵新树时，先决定顶层分支从左到右的顺序，例如：

```txt
政治路线 | 经济建设 | 陆军 | 海军 | 空军 | 外交/属国
```

每个大分支的第一枚国策可以使用绝对坐标。进入分支以后，优先使用：

```txt
x = 1
y = 1
relative_position_id = MOD_branch_root
```

这能保证后续移动整条分支时，只需要调整少数锚点，而不是重写一大片绝对坐标。

### 不同位置字段不要混用

- 普通 `focus` 的 `x/y`：国策节点网格坐标。
- `relative_position_id`：让当前节点相对某个国策定位。
- `continuous_focus_position`：持续性国策按钮位置，不是节点位置。
- `initial_show_position`：打开界面时先看哪枚国策。
- `shortcut` / `inlay_window` / `override_position`：界面辅助元素位置，不应用来推导节点坐标。

### 推荐布局流程

1. 先判断是替换旧树、扩展旧树，还是并存新树。
2. 确认 `country` 条件不会让同一国家同时命中多棵树。
3. 画出顶层泳道和每条路线向左/向右的最大展开宽度。
4. 用左侧最大展开宽度确定第一排根节点的绝对 `x/y`。
5. 根节点以下优先使用 `relative_position_id`。
6. 如果使用隐藏分支、动态偏移、动态图标，检查是否需要 `mark_focus_tree_layout_dirty = yes`。
7. 最后检查 `initial_show_position` 和 `continuous_focus_position` 是否仍然合理。

---

## 3. 普通国策 `focus = { ... }` 骨架

```txt
focus = {
    id = MOD_example_focus
    icon = GFX_goal_generic_construct_civilian

    x = 0
    y = 0
    cost = 10

    prerequisite = { focus = MOD_prev_focus }

    available = {
    }

    bypass = {
    }

    ai_will_do = {
        base = 1
    }

    completion_reward = {
    }
}
```

---

## 4. 普通国策常用字段

## 4.1 图标

### 普通图标

```txt
icon = GFX_xxx
```

### 动态图标

```txt
dynamic = yes
icon = {
    trigger = {
        has_war = yes
    }
    value = GFX_focus_icon_war
}
icon = {
    trigger = {
        always = yes
    }
    value = GFX_focus_icon_peace
}
```

注意：
- `dynamic = yes` 表示允许动态 icon。
- 动态 icon **通常不会实时刷新**，往往需要手动刷新国策树。

---

## 4.2 标题栏样式

```txt
text_icon = custom_focus_header
```

对应样式定义示意：

```txt
style = {
    name = custom_focus_header
    unavailable = GFX_focus_unavailable
    completed = GFX_focus_completed
    available = GFX_focus_available
    current = GFX_focus_current
}
```

说明：
- `text_icon` 只是在国策上调用某个标题栏样式名。
- 样式本体通常在别处定义。

---

## 4.3 位置

### 绝对位置

```txt
x = 5
y = 0
```

含义：相对整棵国策树左上角原点定位。

### 相对位置

```txt
x = 1
y = 0
relative_position_id = MOD_base_focus
```

含义：以 `MOD_base_focus` 为参考点偏移。

这是非常重要的写法。AI 在补写或扩展分支时，应优先使用这种方式来保持布局稳定。

### 动态偏移

```txt
x = 5
y = 0
offset = {
    x = -2
    trigger = {
        has_government = democratic
    }
}
```

注意：
- `offset` 是在原始坐标上再做偏移。
- **通常只在开局或刷新时检测，不会实时刷新。**

---

## 4.4 前置国策 `prerequisite`

### “满足其一即可”

```txt
prerequisite = {
    focus = MOD_focus_a
    focus = MOD_focus_b
}
```

同一个 `prerequisite` 块内多个 `focus =`，通常表示**任选其一**。

### “必须同时满足”

```txt
prerequisite = {
    focus = MOD_focus_a
}
prerequisite = {
    focus = MOD_focus_b
}
```

多个 `prerequisite` 块并列，通常表示**都要完成**。

这是 AI 最容易写错的地方之一，必须严格区分。

---

## 4.5 互斥 `mutually_exclusive`

```txt
mutually_exclusive = {
    focus = MOD_other_focus
}
```

注意：
- 互斥通常应**双向书写**。
- 如果 A 与 B 互斥，最好 A 写指向 B，B 也写指向 A。

---

## 4.6 时间成本 `cost`

```txt
cost = 10
```

模板说明中给出的含义：
- `cost = 1` 约等于一周
- `cost = 10` 约等于 70 天
- 可以使用小数

因此 AI 写国策时，要把 `cost` 理解为**国策耗时参数**，不是政治点成本。

---

## 4.7 AI 倾向 `ai_will_do`

```txt
ai_will_do = {
    base = 1
    modifier = {
        add = 2
        has_war = yes
    }
}
```

说明：
- `base` 是基础倾向。
- `modifier` 用条件修正倾向。
- 模板中提示常见写法为 `add` / `factor`。

---

## 4.8 可点条件 / 可见条件 / 分支显示

### `available`

```txt
available = {
    has_political_power > 50
}
```

表示：国策**能否点击**。

### `allow_branch`

```txt
allow_branch = {
    original_tag = JAP
}
```

表示：该国策 / 分支**能否显示**。

注意：
- 模板强调它常常**只在开局检测一次**。
- 后续变化可能需要刷新国策树才反映。

---

## 4.9 选中时效果 / 完成时效果

### `select_effect`

```txt
select_effect = {
    add_political_power = -25
}
```

表示：点击开始国策时立即触发的效果。

### `completion_reward`

```txt
completion_reward = {
    add_stability = 0.05
}
```

表示：国策完成时给予的效果。

### 刷新布局

```txt
completion_reward = {
    mark_focus_tree_layout_dirty = yes
}
```

用于刷新国策树布局，常见于：
- 动态 icon
- 动态位置
- 分支显示变化

---

## 4.10 跳过 / 取消相关

### `bypass`

```txt
bypass = {
    has_completed_focus = MOD_other_focus
}
```

满足条件时跳过该国策，**不会获得正常完成效果**。

### `cancel`

```txt
cancel = {
    has_war = no
}
```

满足条件时取消国策。

### 三个常见布尔项

```txt
bypass_if_unavailable = yes
cancel_if_invalid = yes
continue_if_invalid = no
```

可理解为：
- 不可用时是否跳过
- 条件失效时是否取消
- 条件失效时是否继续执行

AI 在修改时不要混淆这三者。

---

## 4.11 其他常用布尔项

```txt
available_if_capitulated = yes
cancelable = no
```

- `available_if_capitulated`：投降后是否还能点。
- `cancelable`：国策能否手动取消。

注意：原始模板里该字段大小写写法不完全统一；AI 编写时应尽量保持统一、规范。

---

## 4.12 战争提示

```txt
will_lead_to_war_with = CHI
```

表示该国策会导向与对应国家的战争提示。

---

## 4.13 国策标签 `search_filters`

示例：

```txt
search_filters = { FOCUS_FILTER_POLITICAL }
search_filters = { FOCUS_FILTER_RESEARCH }
search_filters = { FOCUS_FILTER_INDUSTRY }
search_filters = { FOCUS_FILTER_STABILITY }
search_filters = { FOCUS_FILTER_WAR_SUPPORT }
search_filters = { FOCUS_FILTER_MANPOWER }
search_filters = { FOCUS_FILTER_ANNEXATION }
```

这是国策界面中的筛选标签。

---

## 5. `shared_focus` 共享国策

`shared_focus` 的定义结构和普通 `focus` 大体相似，但用于被多个国策树引用。

### 基本骨架

```txt
shared_focus = {
    id = SHARED_example_focus
    icon = GFX_goal_generic_construct_civilian

    x = 0
    y = 0
    relative_position_id = SHARED_root_focus

    cost = 10

    completion_reward = {
    }
}
```

### 关键理解

1. `shared_focus` 不是 `focus_tree`。
2. 它更像一个**可被引用的共享国策定义**。
3. 模板建议共享国策优先使用：

```txt
relative_position_id = 某国策id
```

来做位置定位，方便整体引用。

### 在国策树中引用

```txt
shared_focus = SHARED_example_focus
```

模板说明：引用一个共享国策时，会把其下辖导向内容一并引入；此时更适合使用相对定位。

---

## 6. `joint_focus` 联合国策

`joint_focus` 是共享国策的一种特殊形式，结构与普通国策类似，但多了联合逻辑字段。

### 基本骨架

```txt
joint_focus = {
    id = JOINT_example_focus
    icon = GFX_goal_generic_alliance

    x = 0
    y = 0
    relative_position_id = JOINT_root_focus

    cost = 10

    joint_trigger = {
    }

    completion_reward = {
    }

    completion_reward_joint_originator = {
    }

    completion_reward_joint_member = {
    }
}
```

### 关键字段

#### `joint_trigger`
用于确定联合国策的发起方 / 重点国家。

#### `completion_reward`
发起者和其他成员共同享有的效果。

#### `completion_reward_joint_originator`
只有发起者获得的效果。

#### `completion_reward_joint_member`
其他成员（接收方）获得的效果。

AI 在写联合国策时，必须区分这三类奖励作用对象。

---

## 7. 持续性国策 `continuous_focus_palette`

文件位置通常为：`common/continuous_focus/*.txt`

它不是普通国策树里的 `focus = {}` 列表，而是单独的持续性国策面板。

### 基本骨架

```txt
continuous_focus_palette = {
    id = MOD_focus_palette

    country = {
        factor = 0
        modifier = {
            tag = BHR
            add = 10
        }
    }

    position = { x = 50 y = 1000 }

    focus = {
        id = MOD_continuous_focus
        icon = GFX_goal_generic_production
        daily_cost = 0.1

        available = {
        }

        enable = {
        }

        select_effect = {
        }

        cancel_effect = {
        }

        modifier = {
        }
    }
}
```

### 与普通国策的关键区别

#### `daily_cost`

```txt
daily_cost = 0.1
```

表示每日花费政治点。

#### `available`
表示持续性国策**可见条件**。

#### `enable`
表示持续性国策**可点条件**。

#### `modifier`
表示持续性国策持续生效的修正效果。

#### `cancel_effect`
表示取消持续性国策时触发的效果。

---

## 8. AI 最容易写错的点

### 8.1 把不同结构混在一起

不要把：
- `focus_tree`
- `focus`
- `shared_focus`
- `joint_focus`
- `continuous_focus_palette`

混成一个层级。

---

### 8.2 把 `prerequisite` 的“或”与“且”写反

必须记住：

```txt
prerequisite = {
    focus = A
    focus = B
}
```

通常是**二选一 / 满足其一**。

而：

```txt
prerequisite = { focus = A }
prerequisite = { focus = B }
```

通常是**两者都要**。

---

### 8.3 忘记互斥双向写

若两个国策互斥，建议两边都写 `mutually_exclusive`。

---

### 8.4 动态显示误当成实时刷新

下列内容经常不是实时更新：
- 动态 icon
- `offset`
- `allow_branch`

必要时要配合：

```txt
mark_focus_tree_layout_dirty = yes
```

---

### 8.5 把 `available`、`allow_branch`、`enable` 混淆

- 普通国策里：
  - `available` = 能否点击
  - `allow_branch` = 能否显示分支

- 持续性国策里：
  - `available` = 能否看见
  - `enable` = 能否点击

---

### 8.6 把 `cost` 和 `daily_cost` 混淆

- 普通国策：`cost`
- 持续性国策：`daily_cost`

两者不是一回事。

---

## 9. 推荐给 AI 的输出规范

AI 在帮用户编写国策时，建议遵守以下输出规范：

1. **优先给完整块结构**，不要只给零散字段。
2. 若是补丁式修改，明确指出：
   - 新增了哪些字段
   - 改了哪些前置 / 互斥 / 坐标
3. 所有新国策都应至少检查：
   - `id`
   - `icon`
   - `x/y` 或 `relative_position_id`
   - `cost`
   - `prerequisite`
   - `completion_reward`
4. 若使用动态位置、动态图标、动态显示，最好提醒是否需要刷新布局。
5. 不确定引擎是否支持某写法时，不要擅自发明“看起来像 P 社语法”的字段。

---

## 10. 最小可用模板

### 10.1 普通国策最小模板

```txt
focus = {
    id = MOD_example_focus
    icon = GFX_goal_generic_political_reform
    x = 0
    y = 0
    cost = 10

    available = {
    }

    completion_reward = {
    }
}
```

### 10.2 带前置与互斥的普通国策模板

```txt
focus = {
    id = MOD_example_branch_focus
    icon = GFX_goal_generic_major_war
    x = 1
    y = 1
    relative_position_id = MOD_root_focus
    cost = 10

    prerequisite = {
        focus = MOD_root_focus
    }

    mutually_exclusive = {
        focus = MOD_other_branch_focus
    }

    available = {
    }

    ai_will_do = {
        base = 1
    }

    completion_reward = {
    }
}
```

### 10.3 共享国策最小模板

```txt
shared_focus = {
    id = SHARED_example_focus
    icon = GFX_goal_generic_construct_mil_factory
    x = 0
    y = 0
    relative_position_id = SHARED_root_focus
    cost = 10

    completion_reward = {
    }
}
```

### 10.4 联合国策最小模板

```txt
joint_focus = {
    id = JOINT_example_focus
    icon = GFX_goal_generic_alliance
    x = 0
    y = 0
    relative_position_id = JOINT_root_focus
    cost = 10

    joint_trigger = {
    }

    completion_reward = {
    }

    completion_reward_joint_originator = {
    }

    completion_reward_joint_member = {
    }
}
```

### 10.5 持续性国策最小模板

```txt
continuous_focus_palette = {
    id = MOD_focus_palette
    country = {
        factor = 0
        modifier = {
            add = 10
            tag = JAP
        }
    }
    position = { x = 50 y = 1000 }

    focus = {
        id = MOD_continuous_focus
        icon = GFX_goal_generic_improve_relations
        daily_cost = 0.1

        available = {
        }

        enable = {
        }

        modifier = {
        }
    }
}
```

---

## 11. 一句话总结

给 AI 学习国策语法时，最重要的不是记住所有说明文字，而是牢牢记住：

- **块结构是什么**
- **字段该写在哪一层**
- **前置、互斥、位置关系怎么写**
- **普通国策、共享国策、联合国策、持续性国策之间的区别**
- **哪些动态效果不会实时刷新**

