# 英文/日文本地化任务列表

本清单用于把 `localisation/simp_chinese/` 中的中文源文件拆成可执行的英文、日文翻译批次。执行时同时遵守根目录 `AGENTS.md` 和本目录 `AGENTS.md`。

## 通用完成标准

- 英文输出到 `localisation/english/`，根键使用 `l_english:`；日文输出到 `localisation/japanese/`，根键使用 `l_japanese:`。
- 输出 `.yml` 文件使用 UTF-8 with BOM 和 LF；不要制造重复根键。
- 每个外语文件的本地化键集合应与对应中文源文件一致，除非任务说明明确允许继承原版外语键。
- 同名原版文件先克隆原版英文/日文文件，再比较原版简中与 MOD 简中的差异，只移植 MOD 新增或改写内容。
- 游戏术语、角色名、文化词、俳句、成语和历史名词翻译前必须查证；难以等效表达时可以保留日文原文或中文。
- 旧进度中标注为“已有初稿”的外语文本大多未按上述策略制作，不能直接视为可继承成果；继续翻译时应按源文件和原版外语基线重新核对。

## 第 0 批：准备与术语表

- [x] 建立 `localisation/english/` 与 `localisation/japanese/` 目录。
- [ ] 建立或更新翻译术语表，至少覆盖角色名、路线名、势力名、MIO 名称、法案、装备、学说、修正、决议 UI 常用词。（已新建 `localisation/translation_terminology.md`，目前收录 `JAP_law` 批次固定译法，仍待扩展到全项目。）
- [ ] 从原版英文/日文本地化与 HOI4 wiki 核对核心术语。
- [ ] 从项目引用表核对中文解释用名称：`Reference/focus_name.md`、`Reference/character_name.md`、`Reference/event_title_reference.md`、`Reference/state_name_reference.md`、`Reference/strategic_region_reference.md`。
- [ ] 确认自动检查脚本或手工检查流程：BOM、根键、重复键、缺失键、格式变量、颜色码、动态本地化语法。

## 第 1 批：原版同名大文件

这些文件有原版同名外语文件，优先走克隆继承路线。

- [x] `doctrines_l_simp_chinese.yml`，约 875 键：克隆原版 `doctrines_l_english.yml` / `doctrines_l_japanese.yml`，再移植 MOD 简中相对原版简中的差异。
- [x] `SEA_focus_l_simp_chinese.yml`，约 3541 键：经复核不再维护整份英文/日文克隆；小型 MOD tooltip 差异已迁移到 `JAP_focus_need_l_*` 的项目专属 key。

完成记录：第 1 批已从 `D:\SteamLibrary\steamapps\common\Hearts of Iron IV\localisation\english\` 与 `...\japanese\` 克隆同名原版文件完成 `doctrines`，移植 30 个 MOD 新增键与 6 个 MOD 改写键。`SEA_focus` 经复核后不再维护整份英文/日文克隆；`JAP_reduce_zaibatsu_focus_cost_tt`、`JAP_ship_management_committee_tt`、`JAP_naval_armaments_program_tt` 的 MOD 文本迁移到 `JAP_rework_*` 项目专属 key，并放入 `JAP_focus_need_l_*`。原版同名 `SEA_focus` key 已按原版三语还原。

## 第 2 批：核心玩法与高频 UI

这些文件玩家最常见，优先级高，且需要大量原版术语对照。

- [x] `JAP_decisions_l_simp_chinese.yml`，约 665 键：决议、提示、条件和效果说明；已有外语稿不计为完成，大部分内容需要按原版基线、变量、颜色码和动态本地化二次核对。
- [x] `JAP_mio_l_simp_chinese.yml`，419 键：军工组织、特质和节点；已按简中源重做英日翻译，修正日本专属初始特质、RA 模板组织名、舰船/飞机/装甲节点和日文混排问题。
- [x] `JAP_focus_need_l_simp_chinese.yml`，126 键：国策需求提示；已完成二次核对，英日文件键集合、格式变量、颜色码和动态本地化 token 与简中源一致。
- [x] `JAP_focus_time_l_simp_chinese.yml`，20 键：国策时长提示；已完成启用文本二次核对，英日海军互斥加时与辉夜五道难题提示已按脚本效果修正；注释未启用的永远线奖励提示暂不处理。
- [x] `JAP_rework_doctrines_l_simp_chinese.yml`，筛选后 26 键：MOD 学说扩展；已清理不用 key，并按当前脚本使用范围重写英日文本，保留未来恢复的“舰队决战”预留项。
- [x] `JAP_ministry_of_commerce_and_industry_l_simp_chinese.yml`，96 键：商工省系统；已按简中源重做英日翻译，修正旧稿区域套模板、任务名缺空格、日文简中混排和格式提示问题。

阶段记录：2026-06-16 复核后，旧记录中“初稿”与 `JAP_decisions_l_*` 完成标记均撤回；`JAP_mio_l_*`、`JAP_focus_need_l_*` 与 `JAP_focus_time_l_*` 经重新确认可视为完成。输出文件应统一为 UTF-8 with BOM 和 LF，继续时优先从 `JAP_decisions_l_*` 做二次核对。

## 第 3 批：角色、势力与路线名称

这些文件最容易影响后续批次的人名、头衔、组织名和路线名。先查项目角色引用，再联网核对英日写法。

- [x] `JAP_character_l_simp_chinese.yml`，约 53 键：角色姓名、别称、头衔；同时检查相关招募、晋升、事件文本是否使用同一译名。
- [x] `SEA_japan_foreign_policy_l_simp_chinese.yml`，约 2 键：外交政策相关短文本；术语跟随国策与决议。

完成记录：`JAP_character_l_simp_chinese.yml` 已补建 `localisation/english/JAP_character_l_english.yml` 与 `localisation/japanese/JAP_character_l_japanese.yml`。东方 Project 角色名、符卡/称号按常用英译和日文原名处理；要乐奈按 MyGO!!!!! 使用 `Rāna Kaname` / `要楽奈`；兰斯与大帝国角色按可核对资料和内部 key 保守处理，并补入 `localisation/translation_terminology.md`。

完成记录：`SEA_japan_foreign_policy_l_simp_chinese.yml` 已补建 `localisation/english/SEA_japan_foreign_policy_l_english.yml` 与 `localisation/japanese/SEA_japan_foreign_policy_l_japanese.yml`，覆盖 `SEA_japan_foreign_policy.4.c` / `.4.c_tt` 两个新增兜底 key。原版外语本地化未提供这些 key；`Indochina` / `インドシナ` 与 `faction` / `陣営` 沿用国策、决议批次译法。

## 第 4 批：风味、事件与文化文本

这些文件不宜机械直译。成语、诗句、俳句、日语固有名词和 Rance 系列表达需要逐条查证或保留原文。

- [x] `JAP_rance_event_l_simp_chinese.yml`，约 31 键：Rance 相关事件；角色名、作品术语和梗需要统一。
- [x] `JAP_kaguya_events_l_simp_chinese.yml`，约 3 键：辉夜相关事件；神话/民俗词汇优先查证。
- [x] `JAP_kodoha_events_l_simp_chinese.yml`，约 8 键：皇道派相关事件；核对派系、政治术语和历史表达。
- [x] `JAP_PRC_unification_l_simp_chinese.yml`，约 61 键：中日/中共统一相关文本；核对国家、政党、地名与政治术语，并重点检查长句表达。
- [x] `JAP_greater_asian_war_l_simp_chinese.yml`，约 6 键：大东亚战争相关文本；保持路线叙事与国策文本一致。

完成记录：`JAP_rance_event_l_simp_chinese.yml` 已补建 `localisation/english/JAP_rance_event_l_english.yml` 与 `localisation/japanese/JAP_rance_event_l_japanese.yml`。六条难度俳句选项英日均直接使用日文原句；PHANTASM 保留未完成提示，`会赢的` 按五条悟梗处理为 `Nah, I'd win.` / `勝つさ。`；`天堂之战` 与 `轮椅` 按玩家高数值 MOD 互殴和高难挑战辅助工具语境意译。

完成记录：`JAP_kaguya_events_l_simp_chinese.yml` 已补建 `localisation/english/JAP_kaguya_events_l_english.yml` 与 `localisation/japanese/JAP_kaguya_events_l_japanese.yml`。沿用 `Kaguya Houraisan` / `蓬莱山輝夜`、`Yukari Yakumo` / `八雲紫`、`Eientei` / `永遠亭`、`Mokou` / `妹紅` 等东方 Project 译名；正文保留大战略、HoI4、PvP 的元叙事玩笑，并用轻描淡写的旁白处理以贴近 ZUN 风味。

完成记录：`JAP_kodoha_events_l_simp_chinese.yml` 已补建 `localisation/english/JAP_kodoha_events_l_english.yml` 与 `localisation/japanese/JAP_kodoha_events_l_japanese.yml`。`皇道派` 沿用项目既有 `Kodoha` / `皇道派`，事件正文按行政效率取舍处理为简洁政治事件文本；选项和 tooltip 保留加速后续关键国策、奖励削弱或 AI 全拿的脚本含义。

完成记录：`JAP_PRC_unification_l_simp_chinese.yml` 已补建 `localisation/english/JAP_PRC_unification_l_english.yml` 与 `localisation/japanese/JAP_PRC_unification_l_japanese.yml`。固定 `Japanese Communist Party / JCP`、`Chinese Communist Party / CCP`、`Kuomintang`、`Kwantung Army`、`Pacific Soviet Union` 与 `Union of Pacific Soviet Socialist Republics` 等译法；同时修正简中源中 `jap_prc_union.1.a/.b` 选项误写为 `jap_communist.1.a/.b` 的 key，使其对应事件脚本调用。

完成记录：`JAP_greater_asian_war_l_simp_chinese.yml` 已补建 `localisation/english/JAP_greater_asian_war_l_english.yml` 与 `localisation/japanese/JAP_greater_asian_war_l_japanese.yml`。`大亚洲战争` 沿用决议批次 `Greater Asian War` / `大亜細亜戦争`；`我真是受够了亚洲的烂地了` 保留玩家吐槽感，处理为 `I have had it with Asia's miserable terrain.` / `もうアジアのクソ地形にはうんざりだ。`

## 第 5 批：规则、法案、理念、修正与单位

这些文件较短，但术语密度高，应在核心术语表稳定后处理。

- [x] `Rance_game_rules_l_simp_chinese.yml`，约 48 键：游戏规则；与原版规则 UI 译法保持一致。
- [x] `JAP_law_l_simp_chinese.yml`，约 31 键：法案；核对原版法案、经济、征兵和政治术语。
- [x] `JAP_idea_l_simp_chinese.yml`，约 27 键：民族精神；名称要与国策、决议效果保持一致。
- [x] `JAP_Modifiers_l_simp_chinese.yml`，清理后约 46 键：修正显示；对照 `Reference/modifier_trans.md` 与原版外语文件。
- [x] `JAP_special_units_l_simp_chinese.yml`，约 35 键：特殊单位；对照原版单位和装备术语。
- [x] `JAP_tech_card_l_simp_chinese.yml`，约 2 键：科技卡短文本；随相关科技术语处理。

完成记录：`JAP_law_l_simp_chinese.yml` 已补建 `localisation/english/JAP_law_l_english.yml` 与 `localisation/japanese/JAP_law_l_japanese.yml`，键集合对应简中源文件。固定采用 `Yamato Spirit` / `大和魂`、`Overthrow Local Despots and Redistribute the Land`、`Roll Up Our Sleeves and Work Hard` 等译法，并在 `localisation/translation_terminology.md` 记录。未改动简中源文件中既有重复根键和缩进问题。

完成记录：`Rance_game_rules_l_simp_chinese.yml` 已补建 `localisation/english/Rance_game_rules_l_english.yml` 与 `localisation/japanese/Rance_game_rules_l_japanese.yml`。规则组、是/否、重回巅峰、公平对决、日本开局部队、预设日本 AI 难度、脚本登陆、Boss 模式、玩家 AI 辅助、陆空/海军动态补给等 48 个 key 均与简中源一致；难度选项保留东方式“程度”命名与 PHANTASM 未完成提示。

完成记录：第五批剩余 `JAP_idea_l_simp_chinese.yml`、`JAP_Modifiers_l_simp_chinese.yml`、`JAP_special_units_l_simp_chinese.yml`、`JAP_tech_card_l_simp_chinese.yml` 已补建对应英日文件。`JAP_Modifiers_l_simp_chinese.yml` 已移除原版三语 `modifiers_l_*` 中已有的 25 个补丁条目，并压平为单一 `l_simp_chinese:` 根键；英日文件只覆盖保留的 46 个项目自定义 key。`JAP_idea` 中东方符卡按常见英译和日文原文处理，`JAP_special_units` 保留项目自设的 `Naval Special Forces` / `海軍特戦隊` 前缀。

## 受保护/延期文件

这些文件不参加普通英日翻译批次，也不要制作外语占位文件。等用户明确开始专门的英文/日文 MOD 或相关系统翻译时，再单独处理。

- [x] `JAP_ai_navy_ship_grant_l_simp_chinese.yml`，约 55 键：关系到海军 meta effect 效果文本，不能随普通翻译批次随意改写；已在英文版/日文版 MOD 专门 pass 中补建 `localisation/english/JAP_ai_navy_ship_grant_l_english.yml` 与 `localisation/japanese/JAP_ai_navy_ship_grant_l_japanese.yml`，并同步校验 scripted effect、舰船设计名、开局舰船 `version_name` 与自定义编制模板引用。

## 第 6 批：调试与低优先级文件

这些文件不影响普通玩家体验，可最后处理或仅做最低限度翻译。

- [ ] `JAP_rework_debug_extra_l_simp_chinese.yml`，约 25 键：调试说明；优先保持清晰和可维护。
- [ ] `JAP_debug_l_simp_chinese.yml`，当前约 0 键：确认是否为空文件或占位文件。

## 分批校验清单

- [ ] 对每批输出文件运行键集合对比：中文源键、英文键、日文键。
- [ ] 检查 `$...$`、`[?var]`、`§...§!`、`\n`、`£icon`、动态本地化和内嵌脚本语法未被破坏。
- [ ] 对同一角色、国策、理念、决议、事件标题做跨文件译名一致性检查。
- [ ] 对同名原版文件记录采用的原版版本和差异来源。
- [ ] 每批完成后运行 `git diff --check -- localisation`，如工作树有无关旧问题，则改为限定本批文件检查。
