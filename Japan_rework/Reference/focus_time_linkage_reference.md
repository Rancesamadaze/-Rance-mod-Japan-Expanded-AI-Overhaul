# 国策时间联动参考

> 适用场景：处理 HOI4 国策时间被其他国策缩短或增加的情况，包括脚本效果、图标提示与本地化提示。

## 目标国策图标标记

当一个国策会被其他国策改变完成时间时，目标国策应添加：

```txt
overlay = GFX_focus_fast_overlay_generic_clock
```

位置规范：

- 写在 `icon = ...` 后面
- 只加在“被改时间的对象国策”上，不加在施加效果的来源国策上

示例：

```txt
focus = {
    id = MOD_target_focus
    icon = GFX_goal_generic_construct_civilian
    overlay = GFX_focus_fast_overlay_generic_clock
}
```

## 时间改变效果写法

国策时间联动效果通常使用：

```txt
reduce_focus_completion_cost = {
    focus = { MOD_target_focus }
    cost = 35
}
```

当前项目中的实际语义：

- `cost = 正数`：缩短目标国策时间
- `cost = 负数`：增加目标国策时间

注意和普通国策定义里的 `cost` 区分：

- 正常 `focus = { cost = x }` 的实际持续时间是 `x * 7` 天
- `reduce_focus_completion_cost = { cost = x }` 这里的 `x` 直接就是天数，不再乘以 7

## 增加时间的显示处理

当 `cost` 为负数时，界面提示可能仍按“减少”显示，容易误导。

因此对“增加国策时间”的效果，推荐使用：

```txt
if = {
    limit = { is_ai = no }
    custom_effect_tooltip = MOD_focus_time_penalty_tt
    custom_effect_tooltip = generic_skip_one_line_tt
    hidden_effect = {
        reduce_focus_completion_cost = {
            focus = { MOD_target_focus }
            cost = -14
        }
    }
}
```

要点：

- 正面显示用 `custom_effect_tooltip`
- 实际效果放进 `hidden_effect`
- 推荐继续保留 `generic_skip_one_line_tt` 作为分隔

## 本地化存放位置

国策时间联动相关 tooltip，优先集中存放在：

`localisation/simp_chinese/JAP_focus_time_l_simp_chinese.yml`

不建议继续分散堆积到大型国策本地化文件中，除非该 tooltip 明显属于原有条目整体说明的一部分。

## 本地化句式建议

### 增加时间

```yml
MOD_focus_time_penalty_tt: "§R增加§!§Y$MOD_target_focus$§!国策所需的时间§R14§!天。"
```

### 多目标增加时间

```yml
MOD_focus_time_penalty_tt: "§R增加§!§Y$MOD_target_a$§!与§Y$MOD_target_b$§!国策所需的时间各§R7§!天。"
```

### 缩短到最终耗时

当 tooltip 需要表达最终耗时，而不是变化量时，优先写成：

```yml
MOD_focus_time_bonus_tt: "采取§Y$MOD_source_a$§!或§Y$MOD_source_b$§!可将研究时间缩短至 §G21§!天。"
```

### 缩短来源总表

当某个目标国策会被多个来源国策共同缩短时，可在目标国策 tooltip 中集中列出：

```yml
MOD_target_focus_tt: "原有效果说明。\n\n以下国策可缩短§Y$MOD_target_focus$§!所需时间：\n§Y$MOD_source_a$§!：§G35§!天\n§Y$MOD_source_b$§!：§G70§!天"
```

## 国策名引用规范

在时间联动 tooltip 中，优先使用：

```yml
$MOD_focus_key$
```

而不是手写中文名。

这样可以：

- 自动跟随本地化名称变化
- 避免手写不一致
- 便于统一检索与批量维护

## 维护检查清单

当新增或修改一组国策时间联动时，至少检查以下四项：

- 目标国策是否已加 `overlay = GFX_focus_fast_overlay_generic_clock`
- 脚本中的 `reduce_focus_completion_cost` 目标与数值是否正确
- 如果是负数，是否已改为 `custom_effect_tooltip + hidden_effect`
- 对应 tooltip 是否已写入 `JAP_focus_time_l_simp_chinese.yml`

## 当前项目经验

- `reduce_focus_completion_cost` 的 `cost` 在当前项目测试中不应默认改为变量引用，至少在本项目现阶段不可靠
- 对“减少多少天”和“最终变成多少天”这两类 tooltip，要先区分清楚再写
- 发现 `Reference/focus_name.md` 缺少相关国策时，应顺手补全，便于后续统一使用中文名
