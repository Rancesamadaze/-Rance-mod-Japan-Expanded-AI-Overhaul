# HOI4 决议图标参考

> 适用场景：为决议组（category）和决议（decision / mission / targeted decision）选择较合适的图标代码  
> 用途定位：这是“常见对应关系参考表”，不是硬性语法规定  
> 使用建议：如果拿不准，先查原版同类型内容，再决定是否复用 vanilla 图标或本模组自定义图标

## 基本区分

在 HOI4 决议系统里，常见会接触到三类视觉字段：

- 决议组图标：`icon = GFX_decision_category_xxx`
- 单个决议图标：`icon = some_icon_key`
- 决议组配图：`picture = GFX_decision_cat_picture_xxx`

不要混用这三类概念。

尤其注意：

- `GFX_decision_category_...` 通常用于决议组
- 单个决议里常见的是 `generic_naval`、`generic_military`、`generic_factory`、`jap_conquer_china` 这类 key
- 有些单个决议也会使用 `GFX_decision_...` 风格 key，但要先确认该 key 确实存在

## 选择原则

选图标时，优先按下面顺序判断：

1. 原版是否已经有同主题、同功能、同国家风格的现成图标
2. 本模组是否已经给同一条内容线注册过专用图标
3. 如果没有专用图标，再退回到泛用 `generic_*` 图标

优先保证“主题接近”，其次再追求“看起来华丽”。

## 决议组图标常见对应

| 常见类型 | 常用图标代码 | 说明 |
| --- | --- | --- |
| 泛用决议组 | `GFX_decision_category_generic` | 默认保底选项，适合没有明确主题的分类 |
| 边境冲突 / 边境战争 | `GFX_decision_category_border_conflicts` / `GFX_decision_category_border_war` | 适合边境摩擦、边境战机制 |
| 宣传 / 舆论 | `GFX_decision_category_generic_propaganda` | 适合宣传、动员、意识形态鼓动 |
| 经济 / 资源开发 | `GFX_decision_category_generic_economy` / `GFX_decision_category_generic_industry` | 前者偏经济政策，后者偏工业建设 |
| 政治操作 | `GFX_decision_category_generic_political_actions` | 泛政治决议组可优先考虑 |
| 独立 / 民族国家形成 | `GFX_decision_category_generic_independence` / `GFX_decision_category_generic_formable_nations` | 前者偏独立，后者偏组建国家 |
| 军事行动 | `GFX_decision_category_military_operation` | 适合军事行动、作战策划、战区任务 |
| 山地 / 防线建设 | `GFX_decision_category_generic_mountain_fortification` | 适合防线建设、山地据点类 |
| 日本对华行动 | `GFX_decision_category_jap_intervene_in_china` | 适合日本对华战略线 |
| 日本南进 / 太平洋 | `GFX_decision_category_jap_southern_expansion` / `GFX_decision_category_jap_pacific_guardian` | 适合扩张、海军战略、太平洋方向 |
| 本模组神道决议组 | `GFX_decision_category_JAP_state_shintoism` | 适合与国家神道直接相关的分类 |

## 单个决议图标常见对应

| 常见类型 | 常用图标代码 | 说明 |
| --- | --- | --- |
| 泛用保底 | `GFX_decision_generic_decision` | 最稳的兜底图标，但辨识度一般 |
| 陆军 / 军事整备 | `generic_military` / `GFX_decision_generic_military` | 适合陆军、军备、军事改革 |
| 海军 / 舰队 / 海上行动 | `generic_naval` / `GFX_decision_generic_naval` | 适合海军路线、舰队建设 |
| 空泛政治 / 政治动作 | `generic_political_address` / `GFX_decision_generic_political_discourse` | 前者更常见于政治发言、派系政治 |
| 工业 / 工厂 / 财阀 | `generic_factory` / `GFX_decision_generic_factory` | 适合工业扩建、财阀、生产能力 |
| 工业综合 / 建设 | `generic_industry` / `GFX_decision_generic_industry` / `generic_construction` | 建设偏 `construction`，产业线偏 `industry` |
| 科研 | `generic_research` | 适合科研、技术试验、研究扶持 |
| 内战准备 / 点火 | `generic_prepare_civil_war` / `GFX_decision_generic_prepare_civil_war` / `generic_ignite_civil_war` | 用于内战前置与爆发决议 |
| 国族主义 / 宣传 | `GFX_decision_generic_nationalism` / `GFX_decision_generic_propaganda` | 适合民族主义、鼓动与宣传 |
| 边境战 / 渗透 | `border_war` / `GFX_decision_border_war` / `GFX_decision_infiltrate_state` | 适合边境行动、渗透、特种任务 |
| 特殊项目 | `GFX_decision_generic_special_project` | 适合特殊项目、特殊技术工程 |
| 日本对华战争推进 | `jap_conquer_china` / `GFX_decision_jap_conquer_china` | 原版日本相关对华决议常见用法 |
| 日本派系互动 | `GFX_decision_JAP_army_faction` / `GFX_decision_JAP_naval_faction` / `GFX_decision_JAP_zaibatsu_faction` / `GFX_decision_JAP_civic_faction` | 适合日本内部势力、派系、财阀、文官互动 |

## 决议组配图常见说明

如果一个决议组需要更明显的头图展示，可以考虑 `picture = GFX_decision_cat_picture_xxx`。

但要注意：

- `picture` 是装饰性配图，不等于左侧小图标
- 很多决议组并不必须写 `picture`
- 如果没有明确的原版或模组资源，不要为了“看起来完整”而硬加一个不存在的 `picture`

## 日本内容的实用建议

为日本相关内容选图标时，可先按主题分流：

- 陆军派 / 军部斗争：`generic_military`、`GFX_decision_JAP_army_faction`
- 海军派 / 南进 / 太平洋：`generic_naval`、`GFX_decision_JAP_naval_faction`
- 财阀 / 工业资本：`generic_factory`、`generic_industry`、`GFX_decision_JAP_zaibatsu_faction`
- 政府 / 文官 / 政争：`generic_political_address`、`GFX_decision_JAP_civic_faction`
- 对华战争：`jap_conquer_china`
- 国家神道 / 神权政治：`GFX_decision_category_JAP_state_shintoism`

如果一个日本决议没有直接对应的专用图标，通常优先选择“主题最接近的 generic 图标”，而不是硬套另一个日本专用图标。

## 使用时的核对清单

写入图标代码前，建议确认：

1. 这是决议组图标、单个决议图标，还是 `picture`
2. 该 key 是否真的存在于原版或本模组注册中
3. 该图标是否和内容主题一致
4. 是否已经有同一内容线正在使用的既定图标
5. 是否只是“能显示”，但语义其实不合适

## 当前项目中的常见现象

根据当前模组 `common/decisions/` 的实际使用情况：

- `GFX_decision_generic_decision` 是最常见的保底图标
- `generic_naval`、`generic_military`、`generic_factory`、`generic_political_address` 这些 generic key 很常用
- `GFX_decision_category_JAP_state_shintoism` 已用于本模组的神道相关决议组

因此，建立新决议时可以遵循这个经验：

- 没有明确主题时，先用保底图标
- 已经形成主题线时，优先统一同一条线的图标风格
- 新造专用图标 key 前，先确认是否真的需要新增资源注册
