# HOI4 Collections 语法与实战手册

> 适用场景：`common/collections`、国策/决议/事件/阵营目标中需要动态筛选国家或地区，并将结果交给触发器、效果或进度系统使用。
> 参照表见 `Reference/collections_lookup_reference.md`。

## 核心理解

Collection 不是静态列表，而是一条动态查询语句。

它的运行模型可以理解为：

```txt
input 起始集合 -> operator 1 -> operator 2 -> limit 过滤 -> 最终集合
```

例如：

```txt
faction_controlled_asian_states = {
    input = game:scope
    operators = {
        faction_members
        controlled_states
        limit = {
            is_on_continent = asia
        }
    }
    name = COLLECTION_FACTION_CONTROLLED_ASIAN_STATES
}
```

这段逻辑不是“写死一组地区”，而是在使用时动态计算：

1. 从当前 scope 开始。
2. 找当前国家所在阵营的成员。
3. 找这些成员控制的地区。
4. 只保留亚洲地区。

所以 collection 的关键不是名字，而是调用环境、输入类型、operator 顺序和最终消费者。

## 基本结构

命名 collection 放在 `common/collections/*.txt`：

```txt
my_collection = {
    input = game:all_states
    operators = {
        limit = {
            is_coastal = yes
        }
    }
    name = COLLECTION_MY_COLLECTION
}
```

字段含义：

| 字段 | 必需 | 作用 |
|---|---|---|
| `input` | 是 | 起始对象集合，例如全世界国家、全世界地区、当前 scope、已有 collection、constant 组 |
| `operators` | 否 | 按顺序转换或过滤集合 |
| `name` | 否 | UI/tooltip 显示名，本地化 key；不影响逻辑 |

只给 `input` 时也合法：

```txt
all_asian_states = {
    input = collection:states_in_asia
}
```

更短的简写在部分 collection 语境中也成立：

```txt
my_collection = game:all_states
```

实际项目中推荐使用完整块，便于补充 `name`、注释和后续过滤。

## 命名集合与匿名集合

命名集合：

```txt
my_named_collection = {
    input = game:all_countries
    operators = {
        limit = {
            has_government = communism
        }
    }
    name = COLLECTION_MY_NAMED_COLLECTION
}
```

引用时使用 `collection:` 前缀：

```txt
collection_size = {
    input = collection:my_named_collection
    value > 3
}
```

匿名集合直接写在消费处：

```txt
collection_size = {
    input = {
        input = game:all_states
        operators = {
            limit = {
                controller = {
                    has_government = communism
                }
            }
        }
        name = COLLECTION_COMMUNIST_CONTROLLED_STATES
    }
    value > 10
}
```

建议：

| 情况 | 推荐 |
|---|---|
| 多处复用、逻辑有名字、需要 tooltip 友好 | 命名 collection |
| 只在一个条件里临时筛选 | 匿名 collection |
| 逻辑较长、涉及多个 operator | 命名 collection |
| 只是简单判断“全世界地区中有几个满足条件” | 匿名 collection 可接受 |

## Input：起始集合

`input` 决定 collection 的起点。

常见输入：

```txt
input = game:all_countries
input = game:all_possible_countries
input = game:all_states
input = game:scope
input = collection:some_existing_collection
input = constant:state_groups.balkans
input = constant:country_groups.islamic_world
```

`game:scope` 最需要小心。它的含义是“当前调用这个 collection 的 scope”，不是固定国家。

例如同一个 collection：

```txt
my_subjects = {
    input = game:scope
    operators = {
        country_and_all_subjects
    }
    name = COLLECTION_MY_SUBJECTS
}
```

如果在日本国策里调用，`game:scope` 通常是日本；如果在一个目标国家决议里从 `FROM` 中调用，结果可能变成目标国及其属国。写 `game:scope` 前先确认调用处的当前 scope。

## Operators：集合流水线

`operators` 按顺序执行。

```txt
operators = {
    faction_members
    controlled_states
    limit = {
        is_on_continent = asia
    }
}
```

这不是三个并列条件，而是三步转换：

| 步骤 | 当前集合 |
|---|---|
| `input = game:scope` | 当前国家 |
| `faction_members` | 当前国家所在阵营成员国 |
| `controlled_states` | 这些成员国控制的地区 |
| `limit` | 其中位于亚洲的地区 |

operator 会改变集合元素类型。国家集合经过 `controlled_states` 或 `owned_states` 后会变成地区集合；后续 `limit` 里就要写地区触发器。

## Limit 里的 Scope

`limit` 内部的当前 scope 是集合中的每一个元素。

国家集合过滤：

```txt
input = game:all_countries
operators = {
    limit = {
        has_government = democratic
        has_capitulated = no
    }
}
```

这里 `limit` 的当前元素是国家，所以可以直接写 `has_government`。

地区集合过滤：

```txt
input = game:all_states
operators = {
    limit = {
        controller = {
            has_government = communism
        }
    }
}
```

这里当前元素是地区，所以要通过 `controller = { ... }` 检查控制国。

阵营成员控制地区过滤：

```txt
input = game:scope
operators = {
    faction_members
    controlled_states
    limit = {
        NOT = { is_core_of = PREV }
    }
}
```

这类写法常见于原版。根据 collection 文档，`limit` 的：

| Scope | 含义 |
|---|---|
| `THIS` / 当前 scope | collection 当前元素 |
| `PREV` | collection 被使用时的上一层 scope |
| `ROOT` | 调用环境中的 ROOT |
| `FROM` | 调用环境中的 FROM |

实际写作时，不要只看 collection 本身，还要看它在哪里被消费。

## Consumers：谁能使用 Collection

Collection 本身只负责得到一组对象；它必须交给消费者才会产生效果。

常见消费者：

```txt
collection_size = { ... }
any_collection_element = { ... }
all_collection_elements = { ... }
every_collection_element = { ... }
has_resources_in_collection = { ... }
count_in_collection = { ... }
ratio_progress = {
    total_amount_collection = ...
    completed_amount_collection = ...
}
```

### collection_size

比较集合大小。

```txt
collection_size = {
    input = collection:states_in_asia
    value > 20
}
```

注意：原版文档说明比较是 inclusive。`value > 20` 的行为接近“至少 20”，不是严格大于 20。重要阈值建议先在游戏里验证 tooltip。

### any_collection_element

集合中任意元素满足条件。

```txt
any_collection_element = {
    collection = {
        input = game:scope
        operators = {
            faction_members
            controlled_states
        }
        name = COLLECTION_FACTION_CONTROLLED_STATES
    }
    distance_to = {
        target = 479
        value < 2000
    }
}
```

这里 `distance_to` 的当前 scope 是每一个阵营控制地区。

### all_collection_elements

集合中所有元素都满足条件。

```txt
all_collection_elements = {
    collection = {
        input = game:scope
        operators = {
            controlled_states
        }
    }
    is_core_of = PREV
}
```

适合检查“全部控制地区都是核心”“全部目标国家都满足某条件”。

### every_collection_element

对集合中的每个元素执行效果。

```txt
every_collection_element = {
    input = {
        input = game:scope
        operators = {
            faction_members
            limit = {
                has_capitulated = no
            }
        }
        name = COLLECTION_UNCAPITULATED_FACTION_MEMBERS
    }
    add_political_power = 50
}
```

效果里的当前 scope 是当前元素。上例当前元素是国家，所以能直接 `add_political_power`。

### has_resources_in_collection

统计一组国家的资源。原版日本国策中使用 `collection:country_and_all_subjects` 检查本国及属国资源。

```txt
has_resources_in_collection = {
    collection = collection:country_and_all_subjects
    resource = steel
    amount > 199
    extracted = yes
}
```

### count_in_collection

统计集合内国家的库存、单位、人力或建筑。

```txt
count_in_collection = {
    collection = {
        input = game:scope
        operators = {
            faction_members
        }
        name = COLLECTION_FACTION_MEMBERS
    }
    stockpile = infantry_equipment
    size > 100000
}
```

### ratio_progress

阵营目标/manifest 中常用。

```txt
ratio_progress = {
    total_amount_collection = collection:states_in_asia
    completed_amount_collection = collection:faction_states_in_asia
}
```

这表示“阵营控制的亚洲地区 / 亚洲所有地区”。

## 阵营以外的应用

Collection 不限于阵营系统。只要某个触发器或效果支持 collection，就可以在国策、决议、事件、AI 权重里使用。

### 国策可用条件

```txt
available = {
    collection_size = {
        input = {
            input = game:all_states
            operators = {
                limit = {
                    controller = {
                        has_government = communism
                    }
                }
            }
            name = COLLECTION_COMMUNIST_CONTROLLED_STATES
        }
        value > 30
    }
}
```

### AI 权重

```txt
ai_will_do = {
    base = 1
    modifier = {
        add = 2
        has_resources_in_collection = {
            collection = collection:country_and_all_subjects
            resource = oil
            amount < 20
            extracted = no
        }
    }
}
```

### 决议显示条件

```txt
visible = {
    any_collection_element = {
        collection = collection:states_in_asia
        controller = {
            tag = ROOT
        }
    }
}
```

### 事件批量效果

```txt
immediate = {
    every_collection_element = {
        input = {
            input = game:all_countries
            operators = {
                limit = {
                    has_government = communism
                    has_capitulated = no
                }
            }
            name = COLLECTION_WORLD_COMMUNIST_COUNTRIES
        }
        add_stability = 0.05
    }
}
```

## Cookbook

### 统计共产主义国家控制的地区

```txt
communist_controlled_states = {
    input = game:all_states
    operators = {
        limit = {
            controller = {
                has_government = communism
            }
        }
    }
    name = COLLECTION_COMMUNIST_CONTROLLED_STATES
}
```

适合国策条件、阵营进度、事件判断。

### 当前国家及属国资源检查

优先复用原版：

```txt
collection:country_and_all_subjects
```

示例：

```txt
has_resources_in_collection = {
    collection = collection:country_and_all_subjects
    resource = chromium
    amount > 50
    extracted = yes
}
```

### 当前阵营控制的非核心地区

可复用原版：

```txt
collection:faction_controlled_non_core_states
```

如果要改成国家及属国，而不是全阵营：

```txt
collection:country_and_all_subjects_controlled_non_core_states
```

### 当前国家所在大陆的地区

可复用原版：

```txt
collection:states_on_my_continent
```

注意这个 collection 依赖 `ROOT`，在事件/决议中使用时要确认 `ROOT` 是预期国家。

### 亚洲国家/亚洲地区

可复用原版：

```txt
collection:countries_asia
collection:states_in_asia
```

日本路线、泛亚路线、东亚战争目标通常优先考虑这两个。

## 常见陷阱

| 症状 | 常见原因 | 修法 |
|---|---|---|
| 条件永远不成立 | `limit` 里把国家触发器写在地区 scope 下，或反过来 | 先确认集合当前元素类型 |
| collection 在不同地方结果不同 | 使用了 `game:scope`、`ROOT`、`FROM` | 检查调用环境 |
| tooltip 名字难看或缺失 | 匿名 collection 没写 `name`，或 `COLLECTION_` 未本地化 | 添加 `name` 和本地化 |
| 统计数量偏大 | 集合元素不保证唯一，某些 operator 链可能重复产生同一对象 | 尽量用不会重复的输入，或先用更明确的 `limit` |
| `collection_size` 阈值差一 | 比较符是 inclusive | 避免边界写法，或进游戏验证 |
| 引用失败 | 忘记 `collection:` 前缀 | 命名集合引用必须写 `collection:xxx` |
| `owned_states` / `controlled_states` 报错或无效 | 前一步不是国家集合 | 确认 operator 输入类型 |
| 资源统计不符合预期 | `extracted` / `buildings` 含义混淆 | 查 `has_resources_in_collection` 参照表 |

## 项目写作建议

命名规则：

| 对象 | 建议 |
|---|---|
| collection ID | 使用英文小写或项目统一前缀，例如 `rance_communist_controlled_states` |
| 本地化 key | 使用 `COLLECTION_` 前缀，例如 `COLLECTION_RANCE_COMMUNIST_CONTROLLED_STATES` |
| 文件位置 | `common/collections/` 下按主题分文件 |
| 注释 | 说明输出类型、依赖 scope、用途 |

示例：

```txt
# Output: state
# Scope dependency: none
# Use: communist-route progress and conditions
rance_communist_controlled_states = {
    input = game:all_states
    operators = {
        limit = {
            controller = {
                has_government = communism
            }
        }
    }
    name = COLLECTION_RANCE_COMMUNIST_CONTROLLED_STATES
}
```

编码规则按项目约定：

| 文件类型 | 编码 |
|---|---|
| `common/collections/*.txt` | UTF-8 无 BOM，LF |
| `localisation/simp_chinese/*.yml` | UTF-8 with BOM，LF |
| `Reference/*.md` | UTF-8，无 BOM，LF |

## 调试方法

1. 先把复杂 collection 拆成命名集合。
2. 给 collection 写 `name` 和本地化，让 tooltip 显示得出来。
3. 用 `collection_size` 单独测试数量。
4. 如果有 scope 依赖，分别在国策、决议、事件中确认 `ROOT` / `FROM`。
5. 优先对照原版 `common/collections/collections.txt` 和 `common/factions/goals` 中的使用方式。

调试模板：

```txt
custom_trigger_tooltip = {
    tooltip = MY_COLLECTION_DEBUG_TT
    collection_size = {
        input = collection:my_collection
        value > 1
    }
}
```

如果 tooltip 里 collection 名称、本地化和数量都合理，说明基础查询大概率成立。
