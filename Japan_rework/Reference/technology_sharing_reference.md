# 科研共享组织参考

本文记录 `technology_sharing_group` 的基础语法和本项目实践。新增或修改科研共享组织前，优先核对原版 `common/technology_sharing/` 示例与目标科技文件中的 `categories` key。

## 组织定义

科研共享组织定义在 `common/technology_sharing/*.txt`，基础结构如下：

```hoi4
technology_sharing_group = {
	id = JAP_axis_military_tech_sharing_group
	name = JAP_axis_military_tech_sharing_group
	desc = JAP_axis_military_tech_sharing_group_desc
	picture = GFX_technology_sharing_default

	research_sharing_per_country_bonus = 0.05

	categories = { armor air_equipment naval_equipment }

	available = {
		# 成员国自身需要满足的可用条件
	}
}
```

- `id` 是脚本效果使用的组织 key。
- `name` 和 `desc` 指向本地化 key。
- `research_sharing_per_country_bonus` 是每个已掌握相关科技的成员国提供的科研共享加成。
- `categories` 限定共享组影响的科技分类；省略时按原版机制视为不限分类。
- `available` 是成员国视角的可用条件，不负责自动邀请成员。

## 加入与检测效果

常用效果和触发如下：

```hoi4
add_to_tech_sharing_group = JAP_axis_military_tech_sharing_group
remove_from_tech_sharing_group = JAP_axis_military_tech_sharing_group
is_in_tech_sharing_group = JAP_axis_military_tech_sharing_group
num_tech_sharing_groups < 1
```

- `add_to_tech_sharing_group` 和 `remove_from_tech_sharing_group` 写在国家 scope 下。
- 多国加入时，使用 `every_country`、`every_country_with_original_tag` 或 `ROOT = { ... }` 切换 scope。
- `is_in_tech_sharing_group` 可用于避免重复加入或作为持续效果触发条件。
- `num_tech_sharing_groups` 常用于限制一个国家同时参加的科研共享组织数量。

## 科技分类 key

`categories` 应使用科技文件内已有的分类 key，而不是装备 key 或本地化 key。当前常见军用分类包括：

```hoi4
infantry_weapons
artillery
armor
cat_mechanized_equipment
support_tech
air_equipment
naval_equipment
electronics
radar_tech
rocketry
```

这些 key 分布在原版 `common/technologies/infantry.txt`、`artillery.txt`、`armor.txt`、`air_techs.txt`、`bba_air_techs.txt`、`naval.txt`、`MTG_naval.txt`、`MTG_naval_Support.txt`、`support.txt`、`electronic_mechanical_engineering.txt` 等文件中。新增分类前先用 `rg` 在科技文件内确认。

## 项目实践

- 新增自定义科研共享组织时，优先创建项目自己的 additive 文件，例如 `common/technology_sharing/JAP_rework_technology_sharing.txt`。
- 不需要覆盖原版同路径文件时，不要新增 `replace_path`。
- 国策奖励若要一次性加入多国，推荐把可见说明写成 `custom_effect_tooltip`，实际加入效果放进 `hidden_effect`，避免 tooltip 被大量成员国刷屏。
- 对历史上不在同一阵营但需要共享科技的国家，直接用脚本加入同一个科研共享组织即可；科研共享组织不要求成员必须同阵营。
