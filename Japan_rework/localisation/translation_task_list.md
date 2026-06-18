# 本地化模块与翻译维护清单

本清单记录 `localisation/` 下当前维护结构。执行英日翻译、补键或同步时，同时遵守根目录 `AGENTS.md` 和本目录 `AGENTS.md`。

## 通用完成标准

- 三语文件使用同一项目模块名：`l_simp_chinese:`、`l_english:`、`l_japanese:`。
- `.yml` 文件使用 UTF-8 with BOM 和 LF；每个文件只保留一个根键。
- 同一模块的中英日 key 集合应一致，除非本清单明确说明该文件只在某一语言中存在。
- 不再维护完整原版同名本地化克隆。若只需要少量原版 key 的 MOD 差异，放入项目自有 `JAP_rework_*` 文件。
- 不要向 `SEA_focus_l_simp_chinese.yml` 追加内容；该原版克隆已删除。
- 游戏术语、角色名、文化词、俳句、成语和历史名词翻译前必须查证；难以等效表达时可以保留日文原文或中文。

## 当前模块

- [x] `JAP_rework_focus_l_*`：国策需求、国策时长、国策奖励卡等高频 focus tooltip 与奖励文本。由旧 `JAP_focus_need_l_*`、`JAP_focus_time_l_*`、`JAP_tech_card_l_*` 合并。
- [x] `JAP_rework_events_l_*`：Rance、辉夜、皇道派事件，以及 `SEA_Japan.txt` 中的日本外交政策事件兜底选项。由旧事件碎片合并。
- [x] `JAP_rework_politics_l_*`：角色名/传记、法案、民族精神与政治类显示文本。由旧 `JAP_character_l_*`、`JAP_law_l_*`、`JAP_idea_l_*` 合并。
- [x] `JAP_rework_military_l_*`：大亚洲战争动态修正、通用修正显示、自定义特殊单位显示。由旧 `JAP_greater_asian_war_l_*`、`JAP_Modifiers_l_*`、`JAP_special_units_l_*` 合并。
- [x] `JAP_rework_communism_l_*`：日共/中共合流、毛泽东、太平洋苏维埃、反封建统一战线、南亚/西亚解放等共产主义路线文本。由旧 `JAP_PRC_unification_l_*` 整理改名。
- [x] `JAP_rework_doctrines_l_*`：Rance/Japan 专属大学说、特殊部队学说，以及从旧 `doctrines_l_*` 克隆迁出的 30 个新增学说 key 和 6 个改写 key。旧原版同名 `doctrines_l_*` 三语克隆已删除，descriptor 中的本地化 `replace_path` 已移除。
- [x] `JAP_rework_debug_l_simp_chinese.yml`：测试版中文调试决议与事件文本。由旧 `JAP_rework_debug_extra_l_simp_chinese.yml` 合并；旧空占位 `JAP_debug_l_simp_chinese.yml` 已删除。

## 保留独立模块

- [x] `JAP_decisions_l_*`：大型决议与效果说明模块，当前三语 key 集合一致。中文源已压平为单一根键。
- [x] `JAP_mio_l_*`：军工组织、特质和节点文本，保持独立以便与 MIO 脚本同步。
- [x] `JAP_ministry_of_commerce_and_industry_l_*`：商工省系统文本，保持独立以便系统级维护。
- [x] `Rance_game_rules_l_*`：游戏规则 UI 文本，保持独立。
- [x] `JAP_stats_l_japanese.yml`：日文独有的一行数值格式覆盖，用于修正 `STAT_COMMON_MAX_ORG_MOD_VALUE` 显示。

## 受保护文件

- [x] `JAP_ai_navy_ship_grant_l_*`：海军 meta effect 效果文本。普通整理或翻译批次不要改写、重命名、合并或制作占位；只有用户明确开启该系统专项维护时再处理。

## 已删除的原版克隆

- [x] `SEA_focus_l_simp_chinese.yml`：复核后没有 MOD 独有 key，也没有与当前原版不同的值，且比当前原版少 `JAP_end_the_interservice_rivalry_tt`；已删除。
- [x] `doctrines_l_simp_chinese.yml`、`doctrines_l_english.yml`、`doctrines_l_japanese.yml`：差异已迁入 `JAP_rework_doctrines_l_*`，不再通过本地化 `replace_path` 覆盖原版同名文件。

## 校验清单

- [ ] 对三语模块运行 key 集合对比：中文源 key、英文 key、日文 key。
- [ ] 检查 `$...$`、`[?var]`、`§...§!`、`\n`、`£icon`、动态本地化和内嵌脚本语法未被破坏。
- [ ] 对同一角色、国策、理念、决议、事件标题做跨模块译名一致性检查。
- [ ] 每批完成后运行限定范围的 `git diff --check` 或等效空白检查。
