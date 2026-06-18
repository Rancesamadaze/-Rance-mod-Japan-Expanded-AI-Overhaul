# HOI4 Idea 语法速查（供 AI 学习）

> 用途：帮助 AI 正确编写或修改 `common/ideas/*.txt` 中的 idea 定义。  
> 范围：民族精神、隐藏 idea、制造商 / 工业顾问类 idea。  
> 说明：具体语法骨架主要依据用户提供模板整理，ideas 系统定位参考官方 wiki。

---

## 1. ideas 是什么

`ideas` 是 HOI4 中用于定义长期国家修正的一套系统，常见包括：

- national spirits（民族精神）
- hidden ideas
- laws
- designers / concerns（设计公司、制造商、工业顾问）

通常放在：

```txt
common/ideas/*.txt
```

顶层结构常见为：

```txt
ideas = {
    hidden_ideas = { ... }
    country = { ... }

    naval_manufacturer = { ... }
    materiel_manufacturer = { ... }
    tank_manufacturer = { ... }
    aircraft_manufacturer = { ... }
    industrial_concern = { ... }
}
```

---

## 2. 顶层分类

### 2.1 `hidden_ideas`

定义隐藏 idea。

```txt
ideas = {
    hidden_ideas = {
        my_hidden_idea = {
            ...
        }
    }
}
```

常用于：

- 后台机制状态
- 隐藏修正
- 配合事件 / 国策 / 决议进行控制

---

### 2.2 `country`

定义普通国家民族精神。

```txt
ideas = {
    country = {
        my_country_idea = {
            ...
        }
    }
}
```

常用于：

- 开局民族精神
- 国策给予的民族精神
- 事件 / 决议给予的国家长期修正

---

### 2.3 制造商 / 工业顾问类

常见分类：

```txt
naval_manufacturer
materiel_manufacturer
tank_manufacturer
aircraft_manufacturer
industrial_concern
```

示例：

```txt
ideas = {
    tank_manufacturer = {
        my_tank_designer = {
            ...
        }
    }
}
```

---

## 3. 常用字段

### 3.1 `picture`

指定图标。

```txt
picture = some_picture_name
```

---

### 3.2 `allowed_civil_war`

控制内战时 idea 是否保留 / 继承。

```txt
allowed_civil_war = {
    has_government = democratic
}
```

在本项目中，除非明确需要在内战时丢失，否则默认应补：

```txt
allowed_civil_war = {
    always = yes
}
```

---

### 3.3 `on_add`

获得 idea 时立刻执行一次效果。

```txt
on_add = {
    add_stability = 0.2
}
```

---

### 3.4 `on_remove`

移除 idea 时立刻执行一次效果。

```txt
on_remove = {
    add_stability = -0.2
}
```

---

### 3.5 `do_effect`

控制在何种条件下该 idea 生效。

```txt
do_effect = {
    has_war = no
}
```

---

### 3.6 `cancel`

满足条件时移除该 idea。

```txt
cancel = {
    has_war_with = FRA
}
```

---

### 3.7 `modifier`

国家级持续修正。

```txt
modifier = {
    consumer_goods_factor = 0.1
    army_infantry_attack_factor = 0.1
    army_infantry_defence_factor = 0.1
}
```

---

### 3.8 `equipment_bonus`

给装备或装备分类附加修正。

```txt
equipment_bonus = {
    armor = {
        build_cost_ic = -0.5
        instant = yes
    }
}
```

---

### 3.9 `research_bonus`

给某科研分类提供加成。

```txt
research_bonus = {
    construction_tech = 0.1
}
```

---

### 3.10 `rule`

设置国家规则。

```txt
rule = {
    can_create_factions = yes
}
```

---

### 3.11 `allowed / visible / available`

主要用于制造商、顾问、公司等可选 idea。

```txt
allowed = { ... }
visible = { ... }
available = { ... }
```

区别：

- `allowed`：初始准入条件
- `visible`：是否显示
- `available`：是否可选

---

### 3.12 `traits`

用于某些顾问 / 制造商定义。

```txt
traits = {
    some_country_leader_trait
}
```

---

### 3.13 `ai_will_do`

AI 选择倾向。

```txt
ai_will_do = {
    factor = 1
}
```

---

## 4. 标准骨架

### 4.1 国家民族精神

```txt
ideas = {
    country = {
        IDEA_ID = {
            picture = IDEA_PICTURE

            allowed_civil_war = { ... }

            on_add = { ... }
            on_remove = { ... }

            do_effect = { ... }
            cancel = { ... }

            modifier = { ... }

            equipment_bonus = { ... }
            research_bonus = { ... }
            rule = { ... }
        }
    }
}
```

---

### 4.2 隐藏 idea

```txt
ideas = {
    hidden_ideas = {
        IDEA_ID = {
            on_add = { ... }
            on_remove = { ... }

            do_effect = { ... }
            cancel = { ... }

            modifier = { ... }
            equipment_bonus = { ... }
            research_bonus = { ... }
            rule = { ... }
        }
    }
}
```

---

### 4.3 制造商 / 顾问

```txt
ideas = {
    tank_manufacturer = {
        IDEA_ID = {
            picture = IDEA_PICTURE

            allowed = { ... }
            visible = { ... }
            available = { ... }

            modifier = { ... }

            equipment_bonus = { ... }
            research_bonus = { ... }

            traits = { ... }

            ai_will_do = {
                factor = 1
            }
        }
    }
}
```

---

## 5. 完整示例

```txt
ideas = {
    country = {
        shili_idea = {
            picture = generic_coastal_defense_ships2

            allowed_civil_war = {
                has_government = democratic
            }

            on_add = {
                add_stability = 0.2
            }
            on_remove = {
                add_stability = -0.2
            }

            do_effect = {
                has_war = no
            }
            cancel = {
                has_war_with = FRA
            }

            modifier = {
                consumer_goods_factor = 0.1
                army_infantry_attack_factor = 0.1
                army_infantry_defence_factor = 0.1
            }

            equipment_bonus = {
                armor = {
                    build_cost_ic = -0.5
                    instant = yes
                }
            }

            research_bonus = {
                construction_tech = 0.1
            }

            rule = {
                can_create_factions = yes
            }
        }
    }
}
```

---

## 6. 易错点

- 不要把即时效果写进 `modifier`
- 不要把条件写进 `on_add / on_remove`
- 不要混淆 `visible` 和 `available`
- 不要混淆 `country`、`hidden_ideas` 和 manufacturer 分类
- 不要随意编造 picture、trait、rule、modifier、research category、equipment category 名称

---

## 7. 一句话总结

`ideas` 用于定义国家长期修正；写作时先确定顶层分类，再区分条件、即时效果和持续修正三个层面。
