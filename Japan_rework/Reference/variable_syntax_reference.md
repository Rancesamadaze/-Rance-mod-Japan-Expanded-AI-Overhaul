# HOI4 变量语法参考

> 适用场景：HOI4 脚本中的变量创建、运算、判断与清理  
> 当前项目可重点参考 `variable_rance_nandu` 这类国家变量写法

## 基本规则

- 变量用于存储数字。
- 变量名尽量只使用英文字母和下划线。
- 建议先创建，再运算。
- 不再需要的变量应及时清理。

## 创建变量

简写：

```txt
set_variable = { my_var = 10 }
```

完整写法：

```txt
set_variable = {
    var = my_var
    value = 10
}
```

## 常用运算

```txt
add_to_variable = { my_var = 5 }
subtract_from_variable = { my_var = 3 }
multiply_variable = { my_var = 2 }
divide_variable = { my_var = 2 }
modulo_variable = { my_var = 3 }
```

## 限制与取整

```txt
clamp_variable = {
    var = my_var
    min = 0
    max = 100
}

round_variable = my_var
```

常见用途：

- 用 `clamp_variable` 限制变量上下界，避免数值溢出。
- 用 `round_variable` 处理需要整数判定或显示的变量。

## 删除变量

```txt
clear_variable = my_var
```

## 判断变量

标准写法：

```txt
check_variable = {
    var = my_var
    value = 50
    compare = less_than
}
```

常用比较符：

- `less_than`
- `less_than_or_equals`
- `greater_than`
- `greater_than_or_equals`
- `equals`
- `not_equals`

简写：

```txt
check_variable = { my_var = 10 }
check_variable = { my_var < 10 }
check_variable = { my_var > 10 }
```

检查变量是否存在：

```txt
has_variable = my_var
```

## 动态变量：读取州内建筑等级

可以使用 `building_level@building_id` 把州内某种建筑的当前等级当作变量读取。

关键点：

- 这类写法必须放在 `state scope` 中使用。
- `building_id` 需要替换成具体建筑键，例如 `infrastructure`、`industrial_complex`、`arms_factory`。
- 这类动态变量通常和 `check_variable`、`set_variable`、tooltip 条件一起使用。

最常见的用途是：

- 记录某州当前建筑等级
- 后续再次读取并与旧值比较
- 判断玩家是否在该州新建了至少一级建筑

示例：

```txt
1027 = {
	set_variable = { PHI_infrastructure_pre_investment = building_level@infrastructure }
}
```

上面这段表示：在 `1027` 州作用域中，把该州当前的 `infrastructure` 等级读出来，并存入变量。

配合 `check_variable` 的典型比较写法：

```txt
1027 = {
	custom_trigger_tooltip = {
		tooltip = PHI_has_built_at_least_one_infrastructure
		check_variable = { building_level@infrastructure > PHI_infrastructure_pre_investment }
	}
}
```

这类写法表示：只有当 `1027` 州当前基础设施等级高于先前记录值时，条件才成立。

## 动态变量同步 token

`num_equipment@equipment_token`、`num_equipment_in_armies_k@equipment_token`、`num_target_equipment_in_armies_k@equipment_token`、`num_deployed_planes_with_type@equipment_token` 这类写法会把 `@` 后面的装备键当作动态 token 读取。

如果 error.log 出现：

```txt
Token xxx is a dynamic token, this can cause OOS depending on how it's used, please add it as a synchronized dynamic token to prevent OOS
```

说明该 `xxx` 没有登记进同步动态 token 列表。把项目实际使用的 token 写入 `common/synchronized_dynamic_tokens/*.txt`，每行一个 token。

本项目当前文件：

```txt
common/synchronized_dynamic_tokens/JAP_rework_synchronized_dynamic_tokens.txt
```

维护建议：

- 只登记脚本实际用到的 `@token`，避免无谓扩张。
- 新增 AI 库存、部队装备、目标装备或部署飞机读数时，同步检查是否需要补 token。
- 补完后用新启动 log 验证 `scopedvariable.cpp:551` 警告是否消失。

## 临时变量

```txt
set_temp_variable = { temp_x = 10 }
add_to_temp_variable = { temp_x = 5 }
```

特点：

- 只在当前脚本执行期间存在。
- 当前脚本结束后自动删除。
- 适合中间计算，不适合长期存档状态。

## 作用域

### 当前作用域变量

直接写时，变量会落在当前作用域：

```txt
set_variable = { global_x = 10 }
```

注意：这里的 `global_x` 只是普通变量名，不代表全局作用域。它会存到当前脚本所在的国家、州、角色或其他当前作用域上。

### 全局变量

真正的全局变量使用 `global.` 前缀：

```txt
set_variable = { global.my_var = 0 }
add_to_variable = { global.my_var = 10 }
check_variable = { global.my_var > 0 }
```

本项目已通过 debug 决议实测 `global.JAP_debug_global_variable_test` 可用：

```txt
set_variable = { global.JAP_debug_global_variable_test = 0 }
add_to_variable = { global.JAP_debug_global_variable_test = 10 }
```

对应本地化动态显示：

```txt
[?global.JAP_debug_global_variable_test|0]
```

实验结果：不同国家打开同一 debug 决议时读取到同一个值，说明 `global.` 前缀确实写入全局变量作用域。原版也有同类写法，例如 `global.atomic_research_race`。

建议：

- 只在确实需要跨国家共享的计数、全局实验状态、世界级进度记录中使用 `global.`。
- 国家路线、难度、阶段、AI 状态等归属明确的长期状态，仍优先使用国家变量。
- 全局变量命名要带项目或功能前缀，避免和原版或其他 MOD 的全局变量冲突。

### 国家变量

放在国家作用域中：

```txt
JAP = {
    set_variable = { jap_x = 10 }
}
```

当前项目中的典型例子：

```txt
JAP = {
    set_variable = {
        variable_rance_nandu = 3
    }
}
```

这类写法表示将难度变量存到日本国家作用域上，后续可在 scripted trigger、decision、event 中继续读取。

## 常见搭配

```txt
if = {
    limit = {
        check_variable = { my_var > 10 }
    }
    add_stability = 0.1
}
else = {
    add_stability = 0.05
}
```

## 推荐工作流

```txt
set_variable
-> add/subtract/multiply/divide
-> clamp_variable
-> round_variable
-> check_variable
```

## 最小示例

```txt
set_variable = { my_var = 0 }
add_to_variable = { my_var = 5 }

check_variable = {
    var = my_var
    value = 10
    compare = greater_than
}
```

## 项目内建议

- 难度、路线、阶段计数这类长期状态，优先使用国家变量。
- 中间运算优先考虑临时变量，避免污染长期状态。
- 对需要长期维护的变量，命名尽量统一，例如：`variable_xxx`。
- 在写 scripted trigger 时，通常通过 `check_variable` 读取变量，再包装成可复用条件。

## 一句话总结

**先创建，后运算；注意作用域；判断用 `check_variable`；中间计算可用临时变量。**
