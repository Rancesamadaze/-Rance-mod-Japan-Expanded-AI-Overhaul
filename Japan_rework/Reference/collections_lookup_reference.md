# HOI4 Collections 参照表

> 配套手册：`Reference/collections_usage_reference.md`。
> 原版合订资料：`D:\钢四MOD写作\集合\vanilla_collections_reference.md`。

## Input 输入来源

| 写法 | 输出类型 | 是否依赖调用 scope | 说明 |
|---|---|---|---|
| `game:empty` | 空集合 | 否 | 空集合，通常用于占位或特殊逻辑 |
| `game:all_countries` | country | 否 | 当前存在的国家，包括流亡政府 |
| `game:all_possible_countries` | country | 否 | 所有可能国家，包括当前不存在者 |
| `game:all_states` | state | 否 | 全部现存地区 |
| `game:scope` | 当前 scope 类型 | 是 | 当前调用环境中的对象 |
| `collection:xxx` | 取决于被引用集合 | 取决于被引用集合 | 引用命名 collection |
| `constant:state_groups.xxx` | state | 否 | 引用 `common/script_constants/state_groups.txt` 中的静态地区组 |
| `constant:country_groups.xxx` | country | 否 | 引用 `common/script_constants/country_groups.txt` 中的静态国家组 |

## Operators

| Operator | 输入类型 | 输出类型 | 说明 |
|---|---|---|---|
| `limit = { ... }` | 任意 | 原类型 | 用 trigger 过滤集合；内部当前 scope 是集合元素 |
| `faction_members` | country | country | 当前国家所在阵营的所有成员，包括自己；无阵营时为空 |
| `country_and_all_subjects` | country | country | 当前国家及其所有附属国；无属国时只含自己 |
| `owned_states` | country | state | 当前国家拥有的地区 |
| `controlled_states` | country | state | 当前国家控制的地区 |

## Consumer 消费者

| Consumer | 类型 | 字段 | 集合字段名 | 作用 |
|---|---|---|---|---|
| `collection_size` | trigger | `input` | collection id 或匿名 collection | 比较集合大小 |
| `any_collection_element` | trigger | `collection` | collection id 或匿名 collection | 任意元素满足触发器 |
| `all_collection_elements` | trigger | `collection` | collection id 或匿名 collection | 全部元素满足触发器 |
| `every_collection_element` | effect | `input` | collection id 或匿名 collection | 对每个元素执行效果 |
| `has_resources_in_collection` | trigger | `collection` | country collection | 统计一组国家的资源 |
| `count_in_collection` | trigger | `collection` | country collection | 统计一组国家的单位、库存、人力或建筑 |
| `ratio_progress` | faction goal | `total_amount_collection` / `completed_amount_collection` | collection id 或匿名 collection | 用两个集合数量计算进度 |

## collection_size 参数

```txt
collection_size = {
    input = collection:some_collection
    value > 10
    value < 30
    value = some_variable
}
```

| 参数 | 说明 |
|---|---|
| `input` | 要统计大小的 collection |
| `value > N` | 下限比较；原版文档说明比较是 inclusive |
| `value < N` | 上限比较；原版文档说明比较是 inclusive |
| `value = N` | 等值比较 |
| `value = VAR` | 可用变量比较 |

## any_collection_element / all_collection_elements 参数

```txt
any_collection_element = {
    collection = collection:some_collection
    count = 3
    trigger_here = yes
}
```

| 参数 | 说明 |
|---|---|
| `collection` | 要遍历的 collection |
| `count = N` | 仅 `any_collection_element` 可选；至少 N 个元素满足条件 |
| 其他 trigger | 对每个集合元素执行，当前 scope 是该元素 |

## every_collection_element 参数

```txt
every_collection_element = {
    input = collection:some_collection
    effect_here = yes
}
```

| 参数 | 说明 |
|---|---|
| `input` | 要遍历的 collection |
| 其他 effect | 对每个集合元素执行，当前 scope 是该元素 |

## has_resources_in_collection 参数

```txt
has_resources_in_collection = {
    collection = collection:country_and_all_subjects
    resource = steel
    amount > 199
    extracted = yes
}
```

| 参数 | 说明 |
|---|---|
| `collection` | country collection |
| `resource` | 资源 key，例如 `steel`、`aluminium`、`oil`、`tungsten`、`chromium`、`rubber`、`coal` |
| `amount > N` / `<` / `=` | 资源数量比较 |
| `extracted = yes/no` | 是否检查开采量而不是国家余额 |
| `buildings = yes/no` | 是否只检查本地建筑提供的资源；与 `extracted` 互斥 |

## count_in_collection 参数

```txt
count_in_collection = {
    collection = collection:country_and_all_subjects
    stockpile = infantry_equipment
    size > 100000
}
```

| 参数 | 说明 |
|---|---|
| `collection` | country collection |
| `unit = armor` | 统计含指定装备类型的单位 |
| `unit_category = { marine category_fighter }` | 统计指定单位或类别 |
| `buildings = { industrial_complex }` | 统计建筑 |
| `manpower = yes` | 统计已部署人力 |
| `stockpile = infantry_equipment` | 统计指定装备库存 |
| `equipment_ratio = 0.9` | 统计陆军单位时要求装备比例 |
| `size > N` / `<` / `=` | 统计结果比较 |

## ratio_progress 参数

```txt
ratio_progress = {
    total_amount_collection = collection:states_in_asia
    completed_amount_collection = collection:faction_states_in_asia
    range = {
        min = 0.1
        max = 0.8
    }
}
```

| 参数 | 说明 |
|---|---|
| `total_amount_collection` | 分母集合 |
| `completed_amount_collection` | 分子集合 |
| `total_amount` | 固定分母，与 `total_amount_collection` 互斥 |
| `completed_amount` | 固定分子，与 `completed_amount_collection` 互斥 |
| `range = { min = ... max = ... }` | 将比例映射到进度范围 |
| `scale = { modifier = value }` | 按进度缩放 modifier |
| `progress_sections` | 按进度区间启用 modifier/rule |

## 原版可复用 Collections 总表

输出类型：

| 类型 | 含义 |
|---|---|
| `country` | 国家集合 |
| `state` | 地区集合 |
| `scope` | 依赖调用处 scope，通常不建议作为最终类型理解 |

| Collection ID | 输出类型 | Input | Operators | 中文显示名 | 原版位置 |
|---|---|---|---|---|---|
| `world_at_peace_countries` | country | `game:all_countries` | `limit` | 处于和平状态的国家 | collections.txt:11 |
| `democratic_faction_members` | country | `game:scope` | `faction_members -> limit` | 民主阵营成员 | collections.txt:21 |
| `uncapitulated_democratic_faction_members` | country | `game:scope` | `faction_members -> limit` | 尚未投降的民主阵营成员 | collections.txt:32 |
| `world_democratic_countries` | country | `game:all_countries` | `limit` | 民主国家 | collections.txt:44 |
| `world_uncapitulated_democratic_countries_and_dominions` | country | `game:all_countries` | `limit` | 独立且未停止抵抗的民主主义国家或自治领 | collections.txt:55 |
| `world_uncapitulated_democratic_countries` | country | `collection:world_democratic_countries` | `limit` | 未停止抵抗的民主主义国家 | collections.txt:70 |
| `world_non_communist_countries` | country | `game:all_countries` | `limit` | 非共产主义国家 | collections.txt:80 |
| `world_non_communist_states` | state | `game:all_states` | `limit` | 非共产主义国家控制的地区 | collections.txt:90 |
| `world_communist_countries` | country | `game:all_countries` | `limit` | 所有共产主义国家 | collections.txt:100 |
| `europe_non_aligned_countries` | country | `game:all_countries` | `limit` | 欧洲不结盟国家 | collections.txt:110 |
| `countries_china` | country | `game:all_countries` | `limit` | 中国势力 | collections.txt:122 |
| `countries_asia` | country | `game:all_countries` | `limit` | 首都位于亚洲的国家 | collections.txt:135 |
| `communist_countries_asia` | country | `game:all_countries` | `limit` | 首都位于亚洲的共产主义国家 | collections.txt:146 |
| `non_communist_or_capitulated_countries_asia` | country | `game:all_countries` | `limit` | 首都位于亚洲的非共产主义国家 | collections.txt:157 |
| `faction_owned_core_states` | state | `game:scope` | `faction_members -> owned_states -> limit` | 阵营核心地区总数 | collections.txt:185 |
| `world_non_fascist_controlled_states` | state | `game:all_states` | `limit` | 无 `name`，主要作中间集合 | collections.txt:197 |
| `faction_controlled_non_core_states` | state | `game:scope` | `faction_members -> controlled_states -> limit` | 阵营占领的外国地区 | collections.txt:206 |
| `country_and_all_subjects_controlled_non_core_states` | state | `game:scope` | `country_and_all_subjects -> controlled_states -> limit` | 国家及附属国控制的非核心地区 | collections.txt:219 |
| `POL_between_the_seas_states` | state | `game:all_states` | `limit` | 指定战略区内的海间联邦地区 | collections.txt:232 |
| `faction_controlled_between_the_seas_states` | state | `collection:POL_between_the_seas_states` | `limit` | 我方控制的海间联邦地区 | collections.txt:250 |
| `china_potential_core_states` | state | `game:all_states` | `limit` | 无 `name`，中国潜在核心地区 | collections.txt:261 |
| `china_potential_core_mainland_states` | state | `collection:china_potential_core_states` | `limit` | 无 `name`，中国大陆潜在核心地区 | collections.txt:273 |
| `china_core_states_controlled_by_faction_leader_ideology` | state | `game:scope` | `faction_members -> controlled_states -> limit` | 由我们阵营领导者意识形态控制的中国核心地区 | collections.txt:283 |
| `states_in_africa` | state | `game:all_states` | `limit` | 所有非洲地区 | collections.txt:303 |
| `faction_states_in_africa` | state | `game:scope` | `faction_members -> controlled_states -> limit` | 我们控制的非洲地区 | collections.txt:313 |
| `states_in_americas` | state | `game:all_states` | `limit` | 所有北美洲与南美洲地区 | collections.txt:325 |
| `faction_states_in_americas` | state | `game:scope` | `faction_members -> controlled_states -> limit` | 我们控制的北美洲与南美洲地区 | collections.txt:338 |
| `states_in_the_baltics` | state | `game:all_states` | `limit` | 所有波罗的地区 | collections.txt:353 |
| `faction_states_in_the_baltics` | state | `game:scope` | `faction_members -> controlled_states -> limit` | 我们控制的波罗的海地区 | collections.txt:369 |
| `states_in_the_nordics` | state | `game:all_states` | `limit` | 所有北欧地区 | collections.txt:387 |
| `faction_states_in_the_nordics` | state | `game:scope` | `faction_members -> controlled_states -> limit` | 我们控制的北欧地区 | collections.txt:410 |
| `states_in_europe` | state | `game:all_states` | `limit` | 所有欧洲地区 | collections.txt:435 |
| `faction_states_in_europe` | state | `game:scope` | `faction_members -> controlled_states -> limit` | 我们控制的欧洲地区 | collections.txt:445 |
| `states_in_asia` | state | `game:all_states` | `limit` | 亚洲所有地区 | collections.txt:457 |
| `faction_states_in_asia` | state | `game:scope` | `faction_members -> controlled_states -> limit` | 我们控制的亚洲地区 | collections.txt:467 |
| `states_in_middle_east` | state | `game:all_states` | `limit` | 所有中东地区 | collections.txt:479 |
| `faction_states_in_middle_east` | state | `game:scope` | `faction_members -> controlled_states -> limit` | 我们控制的中东地区 | collections.txt:489 |
| `states_in_oceania` | state | `game:all_states` | `limit` | 大洋洲所有地区 | collections.txt:501 |
| `states_in_asia_and_oceania` | state | `game:all_states` | `limit` | 亚洲及大洋洲所有地区 | collections.txt:511 |
| `faction_states_on_my_continent` | state | `game:all_states` | `limit` | 阵营控制的 `[ROOT.GetCountryContinent]` 地区 | collections.txt:523 |
| `states_on_my_continent` | state | `game:all_states` | `limit` | `[ROOT.GetCountryContinent]` 的地区 | collections.txt:533 |
| `non_fascist_controlled_states_on_my_continent` | state | `collection:states_on_my_continent` | `limit` | 非法西斯国家控制的同大陆地区 | collections.txt:542 |
| `non_communist_controlled_states_on_my_continent` | state | `collection:states_on_my_continent` | `limit` | 非共产主义国家控制的同大陆地区 | collections.txt:551 |
| `non_democratic_controlled_states_on_my_continent` | state | `collection:states_on_my_continent` | `limit` | 非民主国家控制的同大陆地区 | collections.txt:560 |
| `states_controlled_by_faction_member_and_core_holder` | state | `game:scope` | `faction_members -> controlled_states -> limit` | 由阵营成员与核心持有者控制的地区 | collections.txt:570 |
| `the_northern_mandate_states` | state | `game:all_states` | `limit` | 北方委任相关地区；原版复用亚洲及大洋洲显示名 | collections.txt:582 |
| `the_southern_mandate_states` | state | `game:all_states` | `limit` | 南方委任相关地区；原版复用亚洲及大洋洲显示名 | collections.txt:592 |
| `the_greater_game_states` | state | `game:all_states` | `limit` | 大博弈相关地区；原版复用亚洲及大洋洲显示名 | collections.txt:602 |
| `communist_controlled_states_my_continent` | state | `game:all_states` | `limit` | 同一大洲由共产主义国家控制的地区 | collections.txt:613 |
| `countries_my_continent` | country | `game:all_countries` | `limit` | 同一大洲的所有国家 | collections.txt:626 |
| `communist_or_capitulated_countries_my_continent` | country | `game:all_countries` | `limit` | 同一大洲的共产主义或已投降国家 | collections.txt:636 |
| `fascist_controlled_states_my_continent` | state | `game:all_states` | `limit` | 同一大洲由法西斯主义国家控制的地区 | collections.txt:651 |
| `anti_communist_controlled_states_my_continent` | state | `game:all_states` | `limit` | 同一大洲由法西斯主义或民主主义国家控制的地区 | collections.txt:665 |
| `anti_fascist_controlled_states_my_continent` | state | `game:all_states` | `limit` | 同一大洲由共产主义或民主主义国家控制的地区 | collections.txt:681 |
| `controllable_balkan_states` | state | `constant:state_groups.balkans` | none | 巴尔干地区 | collections.txt:702 |
| `faction_controlled_balkan_states` | state | `constant:state_groups.balkans` | `limit` | 阵营控制的巴尔干地区 | collections.txt:707 |
| `controllable_central_powers_border_states` | state | `constant:state_groups.central_powers_border_states` | none | 1936 年中欧同盟边境地区 | collections.txt:718 |
| `central_powers_controlled_central_powers_border_states` | state | `constant:state_groups.central_powers_border_states` | `limit` | 目前由德、奥、匈、保控制的中欧边境地区 | collections.txt:722 |
| `african_states` | state | `game:all_states` | `limit` | 无 `name`，非洲地区中间集合 | collections.txt:743 |
| `non_colonial_power_controlled_african_states` | state | `collection:african_states` | `limit` | 非殖民统治的非洲地区 | collections.txt:752 |
| `potential_habsburg_countries_total` | country | `game:all_countries` | `limit` | 无 `name`，潜在哈布斯堡国家 | collections.txt:780 |
| `habsburg_countries_in_our_faction` | country | `collection:potential_habsburg_countries_total` | `limit` | 无 `name`，我方阵营内哈布斯堡国家 | collections.txt:830 |
| `all_islamic_countries` | country | `constant:country_groups.islamic_world` | none | 伊斯兰国家 | collections.txt:883 |
| `islamic_faction_members` | country | `constant:country_groups.islamic_world` | `limit` | 我们阵营中的伊斯兰国家 | collections.txt:888 |
| `controllable_mare_nostrum_states` | state | `constant:state_groups.mare_nostrum_states` | none | 地中海地区 | collections.txt:904 |
| `faction_controlled_mare_nostrum_states` | state | `constant:state_groups.mare_nostrum_states` | `limit` | 阵营控制的地中海地区 | collections.txt:909 |
| `controllable_pax_romana_states` | state | `constant:state_groups.pax_romana_states` | none | 罗马帝国疆域地区 | collections.txt:919 |
| `faction_controlled_pax_romana_states` | state | `constant:state_groups.pax_romana_states` | `limit` | 阵营控制的罗马帝国疆域地区 | collections.txt:924 |
| `comintern_controllable_border_states` | state | `constant:state_groups.comintern_starting_border` | none | 共产国际开局边境地区 | collections.txt:936 |
| `comintern_controlled_border_states` | state | `collection:comintern_controllable_border_states` | `limit` | 开局时由我们控制的边境地区 | collections.txt:942 |
| `neighboring_states_to_leader` | state | `game:all_states` | `limit` | 阵营领导者接壤的地区 | collections.txt:952 |
| `puppet_controlled_border_states` | state | `collection:neighboring_states_to_leader` | `limit` | 阵营领导者的附属国控制的地区 | collections.txt:964 |
| `country_and_all_subjects` | country | `game:scope` | `country_and_all_subjects` | 当前国家及其全部属国 | generic_collections.txt:1 |

## 高价值复用清单

| 目标 | 优先考虑 |
|---|---|
| 当前国家及属国资源/库存/人力统计 | `collection:country_and_all_subjects` |
| 亚洲国家 | `collection:countries_asia` |
| 亚洲地区 | `collection:states_in_asia` |
| 同大陆地区 | `collection:states_on_my_continent` |
| 阵营控制的同大陆地区 | `collection:faction_states_on_my_continent` |
| 阵营控制的亚洲地区 | `collection:faction_states_in_asia` |
| 阵营控制的非核心地区 | `collection:faction_controlled_non_core_states` |
| 国家及属国控制的非核心地区 | `collection:country_and_all_subjects_controlled_non_core_states` |
| 非共产主义国家 | `collection:world_non_communist_countries` |
| 非共产主义国家控制地区 | `collection:world_non_communist_states` |
| 共产主义国家 | `collection:world_communist_countries` |
| 巴尔干、地中海、罗马疆域等固定地区 | `constant:state_groups.xxx` 或对应原版 collection |

## 常用 Static Constants

| Constant | 类型 | 原版用途 |
|---|---|---|
| `constant:state_groups.balkans` | state | 巴尔干地区 |
| `constant:state_groups.central_powers_border_states` | state | 中欧同盟开局边境地区 |
| `constant:state_groups.mare_nostrum_states` | state | 地中海地区 |
| `constant:state_groups.pax_romana_states` | state | 罗马疆域地区 |
| `constant:state_groups.comintern_starting_border` | state | 共产国际开局边境地区 |
| `constant:country_groups.islamic_world` | country | 伊斯兰世界国家 |
| `constant:country_groups.continental_europe_1936` | country | 1936 欧洲大陆国家 |
| `constant:country_groups.nordics` | country | 北欧国家 |
| `constant:country_groups.literally_china` | country | 中国相关国家组 |

完整列表见原版：

```txt
D:\SteamLibrary\steamapps\common\Hearts of Iron IV\common\script_constants\state_groups.txt
D:\SteamLibrary\steamapps\common\Hearts of Iron IV\common\script_constants\country_groups.txt
```

## Scope 快查

| 使用位置 | 常见当前 scope | 备注 |
|---|---|---|
| 国家国策 `available` / `completion_reward` | 当前国家 | `game:scope` 多数时候是执行国策国家 |
| 决议 category / decision | 当前国家，目标决议可能有 `FROM` | target decision 里一定确认 `FROM` |
| 国家事件 | 事件接收国 | 事件发送方常在 `FROM` |
| 阵营目标 `visible` / `available` / `completed` | 多数为阵营领袖 | 原版 faction 文档说明 `ROOT` 常为 faction leader |
| `every_collection_element` 效果内部 | 集合当前元素 | 元素是国家就写国家效果，元素是地区就写地区效果 |
| `any_collection_element` / `all_collection_elements` trigger 内部 | 集合当前元素 | 触发器必须匹配元素类型 |

## 写作检查表

写 collection 前先问：

1. 我最终要的是国家集合还是地区集合？
2. 起始 `input` 能不能稳定得到我想要的范围？
3. 每个 operator 的输入类型是否正确？
4. `limit` 内的当前 scope 是什么？
5. 这个 collection 是否依赖 `game:scope`、`ROOT`、`FROM`？
6. 需要不需要 `name` 来改善 tooltip？
7. 会不会重复计数？
8. 这个逻辑是否已有原版 collection 可复用？
