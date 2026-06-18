# 讲座派军事 AI 重置计划

> 状态：计划文件，不被游戏读取。用于重建讲座派军事策略，并逐步替代旧 `common/ai_strategy/Jap_rework_cm_mil.md` 的设计思路。
>
> 写入顺序：先补剧情阶段，再拆军区，最后落到 `ai_strategy`、`ai_areas`、`scripted_triggers` 和 `on_actions`。

## 重置目标

- 废弃旧讲座派策略里散点式 `area_priority`、永久大区倾向和一次性登陆清单的写法。
- 按皇道派军事 AI 的经验，改成“剧情阶段 -> 军区定位 -> area 口径 -> 本地兵池 -> 前线/登陆/守备 -> 退出与完成”的结构。
- 每个军区必须有明确的开启、放弃、完成口径；不要只靠 `has_completed_focus` 长期开启。
- 先用计划文件承接剧情和战区草案，等剧情确定后再写 live 策略文件。

## 当前参考

- 旧讲座派素材：`common/ai_strategy/Jap_rework_cm_mil.md`，只作历史素材，不直接复制为新结构。
- 皇道派脚本样板：`common/ai_strategy/Jap_rework_kodoha_mil.txt`。
- 通用战争策略语法：`common/ai_strategy/AI_Strategy_Reference/AI_war_strategy_reference.md`。
- 皇道派数值与战区口径：`common/ai_strategy/AI_Strategy_Reference/JAP_kodoha_war_strategy_reference.md`。
- 皇道派军区拆分方法：`common/ai_strategy/AI_Strategy_Reference/JAP_kodoha_post_china_ai_area_plan.md`。

## 路由原则

- `allowed` 只做粗筛，例如 `original_tag = JAP`。
- 讲座派 AI 专属策略在 `enable` 中使用 `Rance_is_jap_lecture_ai = yes`；玩家可见决议或 AI 轮兼容内容另行按“完成焦点 + `Rance_is_jap_ai`”处理。
- 常用焦点节点：
  - `JAP_the_lecture_group_ascendant`：讲座派崛起。
  - `JAP_the_pacific_union_of_soviet_socialist_republics`：太平洋苏维埃社会主义共和国联盟。
  - `JAP_a_red_dawn_over_asia`：亚洲的红色黎明。
- 新策略 key 优先使用 `JAP_lecture_` 前缀；旧 `JAP_c_` / `JAP_l_` key 只在需要兼容旧行为时保留。

## 剧情阶段草案

先在这里写剧情，再决定军区。每一阶段至少补齐“为什么打、何时打、打到哪里算完成、失败时是否收缩”。

| 阶段 | 剧情定位 | 关键焦点/flag | 主要敌人 | 军事目标 | 完成/转段口径 |
| --- | --- | --- | --- | --- | --- |
| 0 | 内战 | 讲座派路线内战节点 | 内战敌方 | 无需额外军事策略处理 | 内战结束后进入朝鲜/满洲处理 |
| 1 | 内战后处理朝鲜、满洲 | 待补具体焦点/flag | 朝鲜、满洲方向敌人 | 朝鲜需要登陆，然后 rush；满洲按近岸/陆上目标处理 | 朝鲜、满洲关键目标由 ROOT 或盟友控制 |
| 2 | 与中共一起解放全中国 | 待补具体焦点/flag | 中国境内非红色敌对势力 | 作战思路继承皇道派侵华：正面推进、沿海登陆、登陆后扩大战果 | 中国全域进入己方/盟友控制，准备与中共合并 |
| 3 | 与中共合并后的整合期 | 合并相关焦点/flag | 无主要外敌 | 预期势力范围为日本地块 + 中国全域；不主动扩张 | 完成合并并准备加入共产国际 |
| 4 | 加入共产国际 | 加入共产国际相关焦点/flag | 同盟国、轴心国的远期威胁 | 苏联为队友，废弃皇道派北方对苏军区；保留本土/边缘防卫 | 加入共产国际后进入革命扩张准备 |
| 5 | 西亚/中东/南亚/印度支那革命扩张 | 国策解锁的决议链 | 革命内战敌对方 | 决议引爆内战、派志愿军支援属于外交部工作，军事策略只保留失败兜底 | 理想状态为红色势力胜利，决议吞并所有势力 |
| 6 | 决战前版图 | 革命吞并完成口径 | 同盟国、轴心国 | 版图西至土耳其及阿拉伯半岛，苏伊士以东；东至太平洋日本岛屿 | 准备先对同盟国开战 |
| 7 | 对同盟国战争 | 待补宣战/战争 flag | 同盟国 | 夺取苏伊士运河，拿下马六甲，推进东印度-澳新、太平洋岛链；苏伊士与亚历山大到手后建立地中海跳板，南亚主要作为敌军反攻或革命失败兜底 | 同盟国亚洲、中东-埃及与太平洋主目标基本清空 |
| 8 | 1941 年 6 月对轴心国宣战 | 时间/国策宣战口径 | 轴心国 | 与苏联共同打击德国、意大利；从地中海跳板转入意大利登陆与本土推进，当前不复用皇道派北方对苏军区 | 德国、意大利被击败或不再构成欧亚大陆主威胁 |
| 9 | 北美远征 | 德意被击败、太平洋条件满足 | 美国/北美敌人 | 继承皇道派北美军区的夏威夷集结、西海岸登陆和大陆推进，但启动条件改为讲座派远期决战口径 | 北美敌情清空或本土危机触发收缩 |

## 决战前版图认知

- 核心本土：日本列岛及太平洋方向日本岛屿。
- 东亚主体：合并后的中国全域。
- 革命吞并范围：西亚、中东、南亚、印度支那方向的红色内战胜利方。
- 西界口径：土耳其和阿拉伯半岛，苏伊士以东。
- 苏联关系：共产国际队友，不写对苏北方进攻军区。
- 外交部职责：革命内战引爆、志愿军支援和吞并决议不放进军事策略；军事策略只处理失败兜底、防御和后续对外战争。

## 新设军区范围设计原则

新设军区的 `ai_area` 是兵力服务半径，不是精确目标圈。设计时先根据战略部署、战略区域名称代表的地理信息和该军区解散前的可能作战路线拼出自定义军区范围；范围只可偏大，不可偏小。

- 军区范围必须覆盖“启用后到完成/放弃前”的全部作战半径，包括主目标、登陆链、补给海路、推进走廊、清场区域和可能的防守反击方向。
- 军区范围要和完成条件一起反推：先确认“打到哪里算本军区主要目标完成”，再把达成这些目标过程中部队可能推进到、绕行到、守住或被反推到的位置一并纳入 area；不要出现完成门槛还没满足，前线却已经自然推到 area 外的情况。
- 避免军区内部出现空心区域；如果多个已选战略区域围住某个中间战略区域，除非有明确的相邻军区同时负责，否则应一并纳入。
- 相邻军区允许重叠，尤其是登陆出发口、海峡、走廊、边境接触面和阶段交接区；重叠优先于断档。
- 完成条件涉及或依赖的州，其周边推进区也应在 area 内；不要让军区尚未完成时，战线已经推到 area 外导致 buffer 部队不支援。
- 如果某个可能推进方向已经明显越过本军区完成目标，且应由后续军区接手，计划里必须留下待确认问题，说明是扩 area、提前交接，还是另建后续军区。
- 岛链和海上军区必须同时覆盖目标岛屿与连接出发地、补给点、后续目标的战略海域；陆上军区必须同时覆盖屯兵口、主攻方向和可能被敌军反推的邻接区域。
- 继承皇道派策略时只继承“可用意图”和数值经验；新设讲座派军区的范围先按讲座派剧情和战役半径重新确认。

## 候选军区框架

这些只是承接剧情的空槽，不是最终 area key。等剧情补完后再删改、合并或拆细。

基础大洲倾向：讲座派常驻亚洲 `area_priority = 20`；完成 `JAP_the_pacific_union_of_soviet_socialist_republics` 后，中东作为重要前线给 `middle_east = 10`，欧洲作为对轴心国主方向给 `europe = 15`。这些只作为战略底色，具体强度仍由中东-埃及、地中海-意大利、安纳托利亚-巴尔干和欧洲总战区等军区的本地 `area_priority` 和 `front_unit_request` 决定。

| 候选军区 | 候选 area key | 负责范围 | 不负责范围 | 设计状态 |
| --- | --- | --- | --- | --- |
| 本土与近海防卫 | `JAP_rework_home_islands_defense` | 日本列岛、近海预警、危机收复 | 不承担亚洲外线推进 | 继承本土口径 |
| 朝鲜-满洲处理军区 | `JAP_rework_korea_theater` / `JAP_rework_manchuria_theater` | 朝鲜登陆、登陆后 rush、满洲关键目标 | 不吞并整个中国战线 | 新建 |
| 中国主战军区 | `JAP_rework_china_theater` | 华北、华东、华中、华南主战 | 不提前混入东南亚/印度 | 继承皇道派侵华思路 |
| 南亚兜底军区 | `JAP_rework_south_asia_theater` | 南亚被敌军主动打入时防守，或印度革命失败后手动打 | 不作为正常战前主动扩张军区 | 基本继承皇道派南亚 |
| 中东-埃及军区 | `JAP_rework_middle_east_egypt_theater` | 从苏伊士以东的中东、黎凡特、红海方向夺取苏伊士运河 | 不扩展为北非清场，不处理西地中海 | 新建草案 |
| 非洲军区 | `JAP_rework_africa_theater` | 拿下苏伊士后维持存在，并低强度推进非洲大陆关键目标 | 不要求全大洲控制，不登陆，不处理补给 | 新建草案 |
| 地中海-意大利军区 | `JAP_rework_mediterranean_italy_theater` | 拿下苏伊士和亚历山大后低强度清理地中海跳板，对轴心国开战后主登陆西西里和拉齐奥并推进意大利本土 | 不扩展非洲清场，不处理巴尔干/德国纵深、西班牙或全地中海无差别登陆 | 已落地首版 |
| 安纳托利亚-巴尔干军区 | `JAP_rework_anatolia_balkans_theater` | 以己方掌控的安纳托利亚和伊斯坦布尔为支点，经色雷斯、希腊、保加利亚、塞尔维亚打开欧洲陆上入口 | 不接手德国纵深、意大利本土、乌克兰或对苏方向 | 已落地首版 |
| 东南亚-马六甲军区 | `JAP_rework_southeast_asia_theater` | 印度支那基本掌控后的马六甲/马来亚目标 | 不重复处理已掌控的印度支那腹地 | 基本继承皇道派东南亚 |
| 东印度-澳新军区 | `JAP_rework_east_indies_australia_theater` | 东印度、澳大利亚、新西兰 | 不抢印度陆上前线和北美 | 继承皇道派 EIA |
| 太平洋岛链军区 | `JAP_rework_pacific_theater` | 台湾、菲律宾、中太平洋、夏威夷方向 | 不处理中国大陆或东印度陆战 | 继承皇道派太平洋 |
| 欧洲总战区 | `JAP_rework_europe_theater` | 欧洲已有支点后，以伊斯坦布尔为总 buffer，低强度维持欧洲大陆战线并推进巴黎、柏林、罗马解放 | 不写登陆，不要求清空全欧洲，不写成对苏北方军区 | 已落地首版 |
| 北美远征军区 | `JAP_rework_north_america_theater` | 夏威夷集结、西海岸登陆、北美大陆推进 | 德意未败前不启用，且不写南美军区 | 改门槛继承皇道派北美 |

## 皇道派策略继承判断

| 皇道派策略块 | 讲座派处理 | 主要改动 |
| --- | --- | --- |
| 北方军区 | 不继承 | 苏联是共产国际队友，不写对苏远东/西线推进；对轴心国欧洲战线改由欧洲总战区低强度承接。 |
| 对华战争 | 大体继承 | 讲座派与中共一起解放全中国，推进、沿海登陆、登陆后扩大战果可参考皇道派侵华；目标国、路线 gate 和合并完成口径要改。 |
| 南亚军区 | 基本继承 | 正常战前南亚已在红色版图中，皇道派敌情/完成口径会自然让其作为兜底启用；第一版不改数值和目标链。 |
| 东南亚军区 | 基本继承 | 印度支那正常已掌控时，皇道派核心走廊口径会自然收束到暹罗、马来亚、新加坡等未控点；第一版不缩窄。 |
| 东印度-澳新军区 | 基本继承 | 作战对象和地理问题与皇道派相近，可继承枢纽登陆、接替 buffer、清理阶段和本地弹性守备。 |
| 太平洋军区 | 基本继承 | 岛链、菲律宾、中太平洋、夏威夷方向与皇道派相近；只改讲座派路线 gate、前置版图和战争阶段。 |
| 北美军区 | 改门槛继承 | 夏威夷集结、西海岸登陆、北美推进可沿用；启动条件改为讲座派在帮苏联击败德国/意大利后，再考虑登陆北美。 |
| 本土防卫 | 可继承口径 | 继续采用显式日本列岛州表和本土危机优先，不用投降进度或扩展核心判断本土。 |

## 第一批迁移落地口径

- live 文件：`common/ai_strategy/Jap_rework_cm_mil.txt`，因为 `descriptor.mod` 已 `replace_path` 该 `.txt`。
- 文档/旧素材：`common/ai_strategy/Jap_rework_cm_mil.md` 暂不作为游戏读取文件处理。
- 第一批迁移范围：基础倾向、本土防卫、东南亚、南亚、东印度-澳新、太平洋。
- 明确排除：对华战争、北美远征、北方对苏、朝鲜/满洲内战后处理。
- 命名规则：策略、scripted trigger、landing flag 继续使用 `JAP_lecture_*`；area 使用路线中立 `JAP_rework_*`，不在讲座派 live 策略中引用 `JAP_kodoha_*` area。
- 路线 gate：`Rance_is_jap_lecture_ai = yes`。
- 后中国/战后外线 gate：从皇道派旧战后完成条件迁来的模块，统一改为 `has_completed_focus = JAP_the_pacific_union_of_soviet_socialist_republics`；第一批 live 策略不再使用旧国旗门槛。
- 太平洋登陆支援：在夏威夷登陆请求附近补 `JAP_lecture_pacific_hawaii_landing_support_priority`，只在 `JAP_lecture_pacific_hawaii_landing_available = yes` 且海军压力可控时启用。北天皇海山链 `96`、西北太平洋 `177`、太平洋海脊 `172` 为 `150`，北太平洋 `114`、夏威夷海脊 `105` 为 `200`，只抬远洋/夏威夷航线，不给每个小岛单独写支援优先级。

## 第二批迁移落地口径

- 范围：补齐现行讲座派 `COMMUNIST` 路线的朝鲜、满洲、中国早期外战模块；不兼容 `COMMUNIST_2`。
- 朝鲜 gate：`has_completed_focus = JAP_reclaim_lost_territories`，且正在对 `original_tag = KOR` 作战；覆盖京畿、平安-黄海、咸镜、江原、庆尚、忠清-全罗六州。
- 满洲 gate：`has_completed_focus = JAP_conquer_the_army_remnants`，且正在对 `original_tag = MAN` 作战；要求朝鲜北部通道可用，只写陆上强推，不新增大连登陆或满洲 on_action 分支。
- 中国 gate：`has_completed_focus = JAP_put_an_end_to_chinese_feudalism`，且仍有中国系敌国；沿用皇道派对华推进、沿海登陆、登陆后 30 天窗口、桥头堡推进、重庆终局和步枪保险数值。
- 中国停止口径：完成 `JAP_the_pacific_union_of_soviet_socialist_republics` 后，讲座派对华战争模块全部停止；对华缺装保险的显式 `abort` 也使用同一国策门槛。
- 战后休整口径：`JAP_lecture_post_china_land_front_rest_pulse` 是结构性前线层，不属于任何单一军区；完成 `JAP_the_pacific_union_of_soviet_socialist_republics` 后，每 60 天最后 15 天对非中国交战国陆上前线给 `front_control priority = 680`、`careful`、`execute_order = no`、`manual_attack = yes`，只压普通推进，不影响 `front_unit_request`、登陆需求、`area_priority` 或 buffer。
- landing flag：朝鲜使用 `JAP_lecture_korea_landing_boost` / `JAP_lecture_korea_landing_priority`；中国使用 `JAP_lecture_china_landing_boost` / `JAP_lecture_china_landing_priority`。

## 第三批迁移落地口径

- 范围：补齐讲座派北美远征军区，并收紧“大本营——筹备美国本土登陆”决议的 AI 路线门槛。
- 决议 gate：皇道派继续使用 `JAP_kodoha_major_asian_theaters_basic_missions_completed`；讲座派使用 `has_completed_focus = JAP_the_pacific_union_of_soviet_socialist_republics` 且 `64` 勃兰登堡、`2` 拉齐奥均由 ROOT/盟友控制；非皇道派/非讲座派路线沿用原放行行为。
- 北美 gate：`Rance_is_jap_lecture_ai = yes`、已完成 `JAP_the_pacific_union_of_soviet_socialist_republics`、对美作战、已获得 `JAP_us_mainland_invasion_preparation_completed_flag`、夏威夷可用、本土未受危机影响。
- 继承内容：从皇道派北美迁移夏威夷集结、对美装甲倾向、加利福尼亚/俄勒冈登陆请求、登陆窗口、30 天桥头堡 followup、西海岸集结转移和北美大陆推进；保留 `order_id = 2604`、数值、目标州和优先级。
- landing flag：北美使用 `JAP_lecture_north_america_landing_boost` / `JAP_lecture_north_america_landing_priority`；on_action 覆盖加利福尼亚、俄勒冈、华盛顿三州。

## 中东-埃及军区设计草案

### 中东-埃及军区

- 剧情阶段：对同盟国战争，决战前版图已到苏伊士以东后，从中东、黎凡特、红海方向夺取苏伊士运河。
- 负责目标：苏伊士、西奈、开罗、亚历山大，以及支撑运河进攻的巴勒斯坦、约旦、黎巴嫩、大马士革前进支点。
- 明确不负责：不扩展为整个北非清场；不因的黎波里、昔兰尼加、马特鲁等埃及以西残余敌情长期吸兵；不处理西地中海。
- 补给口径：非洲所有地块的补给问题不由本军区策略处理，后续交给决议派发；因此红海西侧登陆不因目标补给差而取消。
- area key：`JAP_rework_middle_east_egypt_theater`。
- 战略区域：`28` 中东、`69` 东地中海、`100` 红海、`102` 非洲东海岸、`104` 阿拉伯海、`116` 伊朗中央山脉、`128` 埃及、`129` 小亚细亚、`196` 中阿拉伯、`202` 爱琴海、`203` 波斯湾、`216` 上尼罗河、`232` 黎凡特、`236` 南阿拉伯、`237` 汉志、`238` 东阿拉伯、`239` 厄尔布尔士、`240` 西扎格罗斯、`241` 卡维尔盐漠、`273` 达纳基勒、`297` 东伊朗山脉、`298` 东扎格罗斯。
- area 覆盖半径说明：范围按“苏伊士以东出发，向埃及北部与运河推进”设计，覆盖中东陆路、阿拉伯半岛侧翼、波斯湾和阿拉伯海后方、红海补给线、东地中海登陆/海防线，以及埃及本土北部推进半径；宁可与南亚、欧洲总战区在伊朗/小亚细亚边缘重叠，也不能在黎凡特-西奈-苏伊士之间断档。
- 战前屯兵州：`454` 巴勒斯坦、`553` 黎巴嫩、`554` 大马士革、`455` 约旦。
- 屯兵口径：第一版只保留一批前沿战前屯兵州，不设置后方备用 buffer，避免策略层级过多；`291` 巴格达、`1011` 巴士拉、`656` 科威特只作为 area 覆盖内的后方通道，不作为独立屯兵层。
- 不作为战前屯兵州：`453` 西奈、`446` 苏伊士、`907` 开罗、`447` 亚历山大；这些是主目标/推进目标，不作为开战前吸兵点。
- 主目标州：`446` 苏伊士、`453` 西奈、`907` 开罗、`447` 亚历山大。
- 侧翼保险州：`454` 巴勒斯坦、`455` 约旦、`553` 黎巴嫩、`554` 大马士革；`457` 东部沙漠作为红海登陆侧翼目标，但不作为完成门槛。
- 完成条件：`446` 苏伊士、`453` 西奈、`907` 开罗、`447` 亚历山大均由 ROOT 或盟友控制，且 `454` 巴勒斯坦、`455` 约旦、`553` 黎巴嫩、`554` 大马士革这些东侧前进支点仍由 ROOT 或盟友控制；完成后释放中东-埃及主 buffer、主推进和登陆窗口。
- 放弃条件：讲座派路线 gate 或后中国/决战前基础 gate 失效；推进/登陆层不再与苏伊士/埃及方向目标控制者交战；`454`、`553`、`554`、`455` 全部不由 ROOT 或盟友控制，说明黎凡特前沿战前屯兵点全失，军区不应继续吸兵。
- 本土口径：中东-埃及军区距离日本列岛过远，且讲座派核心范围遍布亚洲，本军区不使用本土危机作为收缩或放弃条件；一旦展开，不为了本土危机回撤。
- 重合军区：与南亚军区在伊朗、阿拉伯海边缘可重合；与欧洲总战区在小亚细亚、东地中海边缘可重合；不与北美、太平洋、东印度-澳新共用目标。
- 主 buffer enable：`Rance_is_jap_lecture_ai = yes`；后中国/决战前基础 gate 成立；`JAP_lecture_middle_east_egypt_theater_clear = no`；`454`、`553`、`554`、`455` 任一由 ROOT 或盟友控制。战前 buffer 不检查是否正在交战，确保战前控制屯兵点时就开始囤兵。
- 主 buffer abort：使用 `abort_when_not_enabled = yes`；当路线/基础 gate 失效、军区完成、或 `454`、`553`、`554`、`455` 全部不由 ROOT 或盟友控制时释放。不要把“不再与苏伊士/埃及目标交战”写进 buffer abort，否则会阻止战前囤兵。
- 主 buffer 数值：计划 key 为 `JAP_lecture_middle_east_egypt_theater_buffer`，建议使用未占用的 `order_id = 2402`；`put_unit_buffers ratio = 0.15`，`states = { 454 553 554 455 }`，`area = JAP_rework_middle_east_egypt_theater`，`subtract_invasions_from_need = yes`，`subtract_fronts_from_need = yes`。
- 主推进 key：`JAP_lecture_middle_east_egypt_theater_push`，只在开战后启用；enable 使用路线/基础 gate、`JAP_lecture_middle_east_egypt_theater_clear = no`、前沿屯兵点未全失、苏伊士/埃及方向存在敌控目标，且 `global.num_days % 60 < 15`，保持进攻脉冲，不长期高强度进攻。
- 主推进数值：`area_priority id = JAP_rework_middle_east_egypt_theater value = 30`；`front_unit_request value = 30`；`front_control priority = 620`、`execution_type = rush_weak`、`execute_order = yes`、`manual_attack = yes`。苏伊士必须拿下，因此优先级高于普通南亚/东南亚主推，但低于登陆后 30 天桥头堡优先级。
- 主推进目标限制：由于本军区 area 很大，`front_unit_request` 和 `front_control` 必须加 `state_trigger`，主攻带只覆盖 `454` 巴勒斯坦、`553` 黎巴嫩、`554` 大马士革、`455` 约旦、`453` 西奈、`446` 苏伊士、`907` 开罗、`447` 亚历山大、`457` 东部沙漠及其邻近州；不要对整个 area 无条件强推，避免伊朗、阿拉伯半岛或东非侧翼吸走主力。
- 红海登陆链：新增 `JAP_lecture_middle_east_egypt_red_sea_landing_invade_target_owner`、`JAP_lecture_middle_east_egypt_red_sea_landing_request`、`JAP_lecture_middle_east_egypt_landing_window`、`JAP_lecture_middle_east_egypt_landing_followup`；从 `293` 北也门出发登陆 `457` 东部沙漠，`invasion_unit_request = 35`，`naval_invasion_focus = 60`，`naval_invasion_dominance_weight = 35`，登陆后 30 天 `front_unit_request = 20`、`front_control priority = 700`、`execution_type = rush_weak`。
- 红海出发点：`293` 北也门作为出发点，原版州文件有港；`659` 南也门不作为出发点。目标 `457` 东部沙漠直接服务苏伊士侧翼，即使补给差也不取消，补给由后续决议处理。
- landing flag：中东-埃及使用 `JAP_lecture_middle_east_egypt_landing_boost` / `JAP_lecture_middle_east_egypt_landing_priority`；on_action 覆盖 `457` 东部沙漠。
- 战线策略分层：buffer 负责战前集结，不检查交战；主推进负责开战后的有限走廊 rush，检查战争与敌控目标；红海登陆请求独立启用，落地后用 30 天 followup 把桥头堡接入苏伊士侧翼。
- 后续脚本提示：主 buffer 使用战前屯兵州；`put_unit_buffers` 的 `area` 必须使用本军区 area，`subtract_fronts_from_need = yes` 保持前线和本地 buffer 不重复计数；推进、front_control、登陆请求再单独检查战争与目标敌控。

## 非洲军区设计草案

### 非洲军区

- 剧情阶段：对同盟国战争中拿下苏伊士后启用；不要求中东-埃及军区全部完成，只看 `446` 苏伊士是否由 ROOT 或盟友控制。
- 负责目标：在非洲方向维持军事存在，并用低强度推进夺取非洲大陆历史/战略关键州。
- 明确不负责：不要求全大洲控制，不写登陆，不处理马达加斯加或其他非大陆外岛完成条件，不处理非洲补给。
- 补给口径：非洲补给仍由后续决议派发处理，本军区策略不因非洲补给问题取消推进。
- area key：`JAP_rework_africa_theater`。
- 战略区域：`17` 埃塞俄比亚高原、`29` 中地中海、`48` 非洲海岸、`60` 西印度洋、`61` 佛得角深海平原、`62` 几内亚湾、`65` 非洲海角、`66` 中南大西洋、`67` 大西洋-印度洋海脊、`68` 西地中海、`69` 东地中海、`85` 西南印度洋、`100` 红海、`102` 非洲东海岸、`103` 莫桑比克海峡、`126` 东马格里布、`127` 撒哈拉沙漠、`128` 埃及、`139` 南非洲、`140` 黑非洲、`181` 马达加斯加、`182` 西马格里布、`183` 中央非洲、`184` 喀麦隆、`185` 东南非洲、`215` 纳米比亚、`216` 上尼罗河、`217` 维多利亚湖、`223` 赞比西、`224` 安哥拉、`225` 的黎波里、`226` 西非洲、`227` 东北刚果、`271` 东南刚果、`272` 西刚果、`273` 达纳基勒、`274` 欧加登。
- area 覆盖半径说明：按“整个非洲，只可大不可小”处理，陆上覆盖北非、撒哈拉、东非、中非、刚果、南非和马达加斯加，海上覆盖地中海非洲侧、红海、非洲东西海岸、莫桑比克海峡和好望角外侧，避免苏伊士以西或非洲海岸线出现军区空心。
- 屯兵州：`446` 苏伊士。
- 完成条件：`JAP_lecture_africa_key_objectives_secured = yes`；只要求非洲大陆关键州由 ROOT 或盟友控制，不要求全大洲控制，也不要求 `543` 马达加斯加。
- 关键州清单：`446` 苏伊士、`907` 开罗、`447` 亚历山大、`448` 的黎波里、`450` 班加西、`458` 突尼斯、`459` 阿尔及尔、`461` 卡萨布兰卡、`551` 喀土穆、`550` 厄立特里亚、`559` 索马里兰、`835` 哈勒尔盖、`547` 内罗毕、`905` 蒙巴萨、`558` 拉各斯、`274` 加纳、`556` 巴马科、`773` 喀麦隆、`772` 中央刚果、`540` 罗安达、`889` 伊丽莎白维尔、`545` 罗得西亚、`897` 赞比西亚-莫桑比克、`681` 开普。
- 敌情判断：`JAP_lecture_africa_enemy_presence` 使用 `any_state = { is_on_continent = africa controller = { has_war_with = ROOT } }`，只服务推进启用，不作为完成条件。
- 启用条件：`Rance_is_jap_lecture_ai = yes`、`has_completed_focus = JAP_the_pacific_union_of_soviet_socialist_republics`、`JAP_lecture_africa_suez_available = yes`、`JAP_lecture_africa_theater_clear = no`。
- 放弃条件：使用 `abort_when_not_enabled = yes`；丢掉 `446` 苏伊士或完成关键州清单时，释放全部非洲军区策略，不另设本土危机收缩。
- buffer 数值：`JAP_lecture_africa_theater_buffer` 使用 `order_id = 2701`、`put_unit_buffers ratio = 0.1`、`states = { 446 }`、`area = JAP_rework_africa_theater`、`subtract_invasions_from_need = yes`、`subtract_fronts_from_need = yes`。
- 基础推进：`JAP_lecture_africa_theater_push` 只在苏伊士可用、非洲未完成、非洲仍有敌情时启用；`global.num_days % 60 < 30`；`area_priority value = 10`、`front_unit_request value = 10`、`front_control priority = 300`、`execution_type = balanced`，`state_trigger = { is_on_continent = africa }`。
- 战线策略分层：第一版只有苏伊士 buffer 和全非洲陆上低强度推进；不新增 `invasion_unit_request`、`naval_invasion_focus`、landing flag 或 on_action 分支。

## 地中海-意大利军区设计与落地口径

### 地中海-意大利军区

- 剧情阶段：对同盟国战争中拿下苏伊士和亚历山大后启用预备；地中海岛屿只作为低优先级清扫目标，意大利本土登陆必须等对轴心国开战或目标控制者已与 ROOT 交战。
- 负责目标：主登陆目标明确为西西里 `115` 和拉齐奥 `2`；西西里用于建立跨海中继和吸引意大利南部战线，拉齐奥用于直接打开首都州桥头堡。卡拉布里亚 `156` 作为西西里后的南部本土登陆/接续目标。
- 后续/侧翼目标：塞浦路斯 `183`、克里特 `182`、马耳他 `116`、撒丁 `114`、科西嘉 `1` 只作为低优先级清理或侧翼目标，不作为第一版完成门槛；不处理巴利阿里 `177`。
- 明确不负责：不扩展为非洲大陆清场，不处理巴尔干/德国纵深，不处理西班牙方向，不做全地中海无差别登陆，不处理补给决议。
- area key：`JAP_rework_mediterranean_italy_theater`。
- 战略区域：`128` 埃及、`232` 黎凡特、`129` 小亚细亚、`69` 东地中海、`202` 爱琴海、`29` 中地中海、`169` 第勒尼安海、`168` 亚得里亚海、`68` 西地中海、`126` 东马格里布、`23` 意大利。
- area 覆盖半径说明：范围按“苏伊士/亚历山大出发，低强度清理地中海岛屿，主力转入西西里和拉齐奥登陆”设计；必须覆盖埃及出发口、黎凡特与小亚细亚边缘、东地中海和爱琴海航路、马耳他和西西里中继、意大利南部登陆场、第勒尼安海与亚得里亚海侧翼，并把东马格里布作为西西里/中地中海侧向余量。宁可与中东-埃及、非洲军区在埃及/东地中海/东马格里布边缘重合，也不能让西西里、拉齐奥和意大利本土推进线断档。
- 屯兵州：`446` 苏伊士、`447` 亚历山大。
- 主目标州：`115` 西西里、`2` 拉齐奥、`156` 卡拉布里亚。塞浦路斯、克里特、马耳他、撒丁和科西嘉不作为主目标，只作为低优先级清理目标。
- 意大利推进州：卡拉布里亚 `156`、拉齐奥 `2`、阿布鲁佐 `157`、托斯卡纳 `162`、艾米利亚-罗马涅 `161` 可作为南部/中部推进和完成判定口径；伦巴第 `159`、威尼托 `160`、皮埃蒙特 `158` 属于后续北上推进，不作为第一版完成门槛。
- 重合军区：与中东-埃及军区在埃及、东地中海和爱琴海重合；与非洲军区只在苏伊士/亚历山大出发口和地中海海域边缘重合；与欧洲总战区在意大利和亚得里亚海边缘重合，但本军区只负责意大利登陆和本土桥头堡，不接手德国或巴尔干纵深。
- 启用条件：`Rance_is_jap_lecture_ai = yes`、`has_completed_focus = JAP_the_pacific_union_of_soviet_socialist_republics`、`446` 苏伊士与 `447` 亚历山大由 ROOT 或盟友控制、`JAP_lecture_mediterranean_italy_theater_clear = no`。主 buffer 不检查是否正在交战，确保苏伊士和亚历山大到手后即可预备；后续推进/登陆可在苏伊士丢失但意大利战役立足点仍存在时继续支撑。
- 放弃条件：路线 gate 或后中国/决战前基础 gate 失效；军区完成；或者 `446` 苏伊士不由 ROOT/盟友控制，且意大利战役立足州 `115`、`156`、`2`、`157`、`162`、`161` 全部不由 ROOT/盟友控制。也就是说，只在苏伊士出发口和西西里/意大利本土立足点都丢完时释放失败军区；单独丢苏伊士但意大利方向已有桥头堡时，不应立刻抽走登陆军。西西里只参与放弃判定，不参与完成判定。
- 完成条件：第一版使用 `JAP_lecture_mediterranean_italy_primary_objectives_secured = yes`；只要求意大利南部/中部推进到位，即 `156` 卡拉布里亚、`2` 拉齐奥、`157` 阿布鲁佐、`162` 托斯卡纳、`161` 艾米利亚-罗马涅均由 ROOT 或盟友控制。完成条件不包括任何地中海岛屿，确保意大利推进差不多后能释放军区。
- 主 buffer：`JAP_lecture_mediterranean_italy_theater_buffer`，`order_id = 2403`，`put_unit_buffers ratio = 0.12`，`states = { 446 447 }`，`area = JAP_rework_mediterranean_italy_theater`，`subtract_invasions_from_need = yes`，`subtract_fronts_from_need = yes`。
- 清理 buffer：第一版不单独设置清理 buffer；西西里和拉齐奥到手后如实测意大利北上推进吸兵不足，再考虑复用 `order_id = 2403` 增加低比例桥头堡 buffer。
- front_unit_request：岛屿阶段只依赖低值登陆请求，不做持续陆上索兵；意大利本土登陆后对南部/中部推进州给 `front_unit_request = 45`，目标限制在 `156`、`2`、`157`、`162`、`161` 及其邻近推进范围，并显式把 `158`、`159`、`160` 作为北上余量，不对整个 area 无条件索兵。
- invasion_unit_request：低优先级岛屿清理目标使用低值，塞浦路斯、克里特、马耳他、撒丁、科西嘉先按 `15` 到 `20` 处理；西西里是主登陆中继，使用 `60`；卡拉布里亚作为南部本土接续使用 `55`；拉齐奥作为首都州主登陆目标使用 `75`。不要让低价值岛屿和西西里/拉齐奥争抢登陆兵力。
- front_control priority：普通意大利本土推进提高到 `priority = 640`、`execution_type = rush_weak`，仍低于中国战后休整层 `680`；登陆后 30 天桥头堡使用 `priority = 720`，拉齐奥桥头堡可提高到 `740`，但仍低于装备不足停攻和本土危机层。
- 登陆链：主链为苏伊士/亚历山大可用后优先尝试西西里 `115`；西西里或拉齐奥到手后尝试卡拉布里亚 `156`；拉齐奥 `2` 可在苏伊士/亚历山大可用时直接启用，也可在西西里或卡拉布里亚任一由 ROOT/盟友控制后继续启用。塞浦路斯、克里特、马耳他、撒丁、科西嘉只作为并行低优先级清扫目标，不作为西西里或拉齐奥的前置门槛。
- 登陆窗口：共享窗口使用 `naval_invasion_focus = 80`、`naval_invasion_dominance_weight = 40`，并加海军优势门槛；为主登陆航线补 `naval_invasion_support_priority`，东地中海 `69`、中地中海 `29`、第勒尼安海 `169` 为 `200`，爱琴海 `202` 为 `150`。低优先级岛屿不得单独叠加全局登陆窗口，避免稀释西西里和拉齐奥登陆。
- 登陆后 flag：live 新增 `JAP_lecture_mediterranean_italy_landing_boost` / `JAP_lecture_mediterranean_italy_landing_priority`；30 天内只对西西里、卡拉布里亚和拉齐奥及邻近州给强桥头堡 followup。低优先级岛屿默认不打高强度 followup，除非实测登陆后立刻被反推。
- on_action 口径：`on_naval_invasion` 第一版重点覆盖西西里 `115`、卡拉布里亚 `156`、拉齐奥 `2`；克里特 `182`、马耳他 `116`、塞浦路斯 `183`、撒丁 `114`、科西嘉 `1` 暂不接入高强度 flag，避免清扫岛屿占用主战桥头堡窗口。
- order_id：主军区使用 `2403`，避免污染中东-埃及 `2402` 和非洲 `2701`；不复用欧洲总战区 order_id。
- 参考数值来源：低价值岛屿登陆使用太平洋小岛低档 `15` 到 `20`，对应 `invade = 30`；西西里、卡拉布里亚、拉齐奥分别使用 `invasion_unit_request = 60/55/75` 与 `invade = 150/120/180`；意大利本土普通推进提高但仍低于 `680` 休整层，主桥头堡 followup 使用 `720` 到 `740` 短窗口。
- 实测问题记录：后续重点观察低优先级岛屿是否仍分散主登陆兵力、西西里和拉齐奥是否能稳定成为主登陆目标、苏伊士丢失但意大利本土已有桥头堡时军区是否继续支撑、南部/中部意大利完成条件是否能及时释放军区。

## 安纳托利亚-巴尔干军区设计草案

### 安纳托利亚-巴尔干军区

- 剧情阶段：对轴心国战争阶段，以讲座派决战前版图中已掌控的安纳托利亚为欧陆支点，从伊斯坦布尔、埃迪尔内和色雷斯方向压入巴尔干，配合苏联从东欧方向牵制轴心国。
- 负责目标：主轴是安纳托利亚集结、伊斯坦布尔渡口、色雷斯突破、保加利亚/希腊/塞尔维亚推进，并打开通往中欧的陆上入口。
- 明确不负责：不接手德国本土纵深，不处理意大利本土登陆与北上，不处理乌克兰、波兰、苏联边境或对苏方向，不处理西班牙和全欧洲无差别清场。
- area key：`JAP_rework_anatolia_balkans_theater`。
- 战略区域：`129` 小亚细亚、`202` 爱琴海、`30` 黑海、`25` 希腊、`26` 东巴尔干、`27` 北巴尔干、`24` 西巴尔干、`168` 亚得里亚海。
- area 覆盖半径说明：范围按“安纳托利亚支点 -> 伊斯坦布尔/埃迪尔内出口 -> 色雷斯/保加利亚/希腊/塞尔维亚主战 -> 巴尔干侧翼余量”设计。必须覆盖安纳托利亚屯兵后方、黑海与爱琴海侧翼、色雷斯突破口、保加利亚和希腊主战区、塞尔维亚与南塞尔维亚中继，以及西巴尔干和亚得里亚海侧翼；宁可与地中海-意大利军区在亚得里亚海边缘重合，也不能在伊斯坦布尔到索非亚、雅典、贝尔格莱德之间断档。
- area 与完成条件的兼顾口径：完成门槛只要求巴尔干主通道和多瑙河下游入口，但 area 额外覆盖西巴尔干、北巴尔干、黑海、爱琴海和亚得里亚海，是为了保证在拿下索非亚、雅典、塞尔维亚、多布罗加和蒙特尼亚之前，部队自然推到阿尔巴尼亚、黑山、波斯尼亚、克罗地亚、伏伊伏丁那、巴纳特、北匈牙利或北斯洛文尼亚边缘时仍在军区服务半径内。德国、捷克斯洛伐克、阿尔卑斯和乌克兰方向不纳入本军区，是因为这些已经越过第一版完成门槛，应由欧洲总战区或后续德国纵深军区承接。
- 安纳托利亚支点州：`49` 安卡拉、`340` 布尔萨、`347` 伊兹密特、`797` 伊斯坦布尔；`339` 伊兹密尔作为爱琴海后方余量，不作为第一版支点必需项。
- 巴尔干入口州：`341` 埃迪尔内、`184` 色雷斯、`48` 索非亚。入口州用于判断是否已经打开欧洲陆上门，不等同于完成条件。
- 主目标州：`341` 埃迪尔内、`184` 色雷斯、`48` 索非亚、`731` 中马其顿、`106` 马其顿、`47` 阿提卡、`803` 南塞尔维亚、`107` 塞尔维亚、`77` 多布罗加、`971` 北多布罗加、`46` 蒙特尼亚。
- 侧翼清理州：`44` 中阿尔巴尼亚、`105` 黑山、`104` 波斯尼亚、`109` 克罗地亚、`103` 达尔马提亚、`45` 伏伊伏丁那、`82` 巴纳特、`43` 北匈牙利、`102` 北斯洛文尼亚只作为推进余量或后续清理，不作为第一版完成门槛。
- 重合军区：与中东-埃及军区在小亚细亚边缘重合；与地中海-意大利军区在爱琴海、亚得里亚海和西巴尔干边缘重合；与欧洲总战区在北巴尔干/中欧入口重合。本军区只负责从安纳托利亚进入巴尔干，不接管德国、意大利或乌克兰战场。
- 启用条件：`Rance_is_jap_lecture_ai = yes`、`has_completed_focus = JAP_the_pacific_union_of_soviet_socialist_republics`、安纳托利亚支点可用、`JAP_lecture_anatolia_balkans_theater_clear = no`。主 buffer 不检查是否正在交战，确保安纳托利亚到手后即可预置重兵；推进层再检查巴尔干方向敌情。
- 放弃条件：路线 gate 或后中国/决战前基础 gate 失效；军区完成；或者安纳托利亚支点不可用，且巴尔干入口/主目标中没有任何 ROOT 或盟友控制的立足州。也就是说，单独丢安纳托利亚但已经在色雷斯、保加利亚或塞尔维亚站稳时，不应立刻抽走欧陆军。
- 完成条件：第一版使用 `JAP_lecture_anatolia_balkans_primary_objectives_secured = yes`；要求 `341` 埃迪尔内、`184` 色雷斯、`48` 索非亚、`731` 中马其顿、`106` 马其顿、`47` 阿提卡、`803` 南塞尔维亚、`107` 塞尔维亚、`77` 多布罗加、`971` 北多布罗加、`46` 蒙特尼亚均由 ROOT 或盟友控制。完成条件不要求克罗地亚、波斯尼亚、斯洛文尼亚、匈牙利或德国，避免军区在主通道完成后长期吸兵。
- 主 buffer：`JAP_lecture_anatolia_balkans_theater_buffer`，`order_id = 2404`，`put_unit_buffers ratio = 0.2`，`states = { 49 340 347 797 341 }`，`area = JAP_rework_anatolia_balkans_theater`，`subtract_invasions_from_need = yes`，`subtract_fronts_from_need = yes`。`341` 埃迪尔内未控制时，落地可视实测改为只在支点触发后使用安纳托利亚四州屯兵。
- front_unit_request：主推进使用 `front_unit_request = 50`，目标限制在主目标州及其邻近州；不要对整个 area 无条件索兵，避免西巴尔干、黑海或未来中欧入口把 `ratio = 0.2` 的重兵池拖散。
- front_control priority：普通巴尔干推进使用 `priority = 660`、`execution_type = rush_weak`、`execute_order = yes`、`manual_attack = yes`；优先级高于地中海-意大利普通推进 `640`，但低于中国战后休整层 `680` 和登陆后桥头堡短窗口。推进脉冲建议 `global.num_days % 60 < 30`，维持重兵进攻但不长期满强度碾压。
- area_priority：主推进给 `JAP_rework_anatolia_balkans_theater` `area_priority value = 35`，高于中东-埃及和地中海-意大利常规外线，体现本军区是欧洲陆上入口的重兵主轴。
- 登陆定位：本军区仍以伊斯坦布尔/埃迪尔内陆上突破为主，登陆只作为“打开第二支点、切断希腊/保加利亚侧翼、解除黑海和爱琴海阻滞”的辅助层。不要把登陆写成替代主推进的全巴尔干抢点；只要陆桥推进已经顺畅，登陆层应自然降到补侧翼和清扫岛屿。
- 主登陆链：第一主目标为 `731` 中马其顿，代表从爱琴海直插萨洛尼卡方向，目标是绕开色雷斯-索非亚正面并连接希腊/塞尔维亚主通道；建议 `invade = 130`、`invasion_unit_request = 55`。第二目标为 `47` 阿提卡，只有在希腊方向仍有敌情且 `731` 已可支撑或陆桥已进入色雷斯后启用；建议 `invade = 95`、`invasion_unit_request = 40`。这两个目标参与主桥头堡 followup。
- 黑海侧翼登陆：`77` 多布罗加和 `971` 北多布罗加用于从黑海侧翼压保加利亚/罗马尼亚下游，服务完成条件里的多瑙河下游入口；允许与陆上突破和爱琴海登陆并行，只要 `797` 伊斯坦布尔安全、安纳托利亚支点可用、黑海目标有敌情且海军压力可控即可启用，不等待 `341` 埃迪尔内、`184` 色雷斯或 `731` 中马其顿站稳。建议 `77` 使用 `invade = 90`、`invasion_unit_request = 35`，`971` 使用 `invade = 70`、`invasion_unit_request = 30`。两个目标参与主桥头堡 followup，但优先级低于 `731`。
- 低优先级清扫登陆：`187` 爱琴群岛只作为爱琴海航线和希腊侧翼清理，建议 `invade = 40`、`invasion_unit_request = 20`；`44` 中阿尔巴尼亚、`103` 达尔马提亚或 `105` 黑山只作为亚得里亚侧翼清扫/意大利军区交界余量，建议单点 `invade = 35` 到 `45`、`invasion_unit_request = 20`。这些低优先级目标不参与第一版完成条件，也默认不打高强度桥头堡 followup，除非实测登陆后频繁被反推；归属可以放在本军区或地中海-意大利军区，脚本落地时按文件维护和触发条件顺手处理，不把清扫归属作为设计风险。
- 登陆窗口：主目标存在时使用 `JAP_lecture_anatolia_balkans_main_landing_window`，`naval_invasion_focus = 70`、`naval_invasion_dominance_weight = 35`，低于地中海-意大利的 `80/40`，但高于中东-埃及红海单点 `60/35`。若只剩爱琴群岛或亚得里亚低优先级目标，另设 `JAP_lecture_anatolia_balkans_cleanup_landing_window`，`naval_invasion_focus = 35`、`naval_invasion_dominance_weight = 25`，避免清扫点和主登陆抢登陆能力。
- 登陆后 flag：新增 `JAP_lecture_anatolia_balkans_landing_boost` / `JAP_lecture_anatolia_balkans_landing_priority`；on_action 第一版只覆盖 `731` 中马其顿、`47` 阿提卡、`77` 多布罗加和 `971` 北多布罗加。登陆后 30 天 followup 使用 `front_unit_request = 30`、`front_control priority = 720`、`execution_type = rush_weak`，只覆盖登陆州及邻近州；不覆盖爱琴群岛、阿尔巴尼亚、黑山、达尔马提亚这些清扫目标。
- 本土口径：本军区是讲座派欧洲决战主攻，第一版不把本土危机写入立即 abort；若后续实测本土压力过大，优先考虑给推进层降权或缩短脉冲，不直接释放安纳托利亚重兵支点。
- order_id：主军区使用 `2404`，避免污染中东-埃及 `2402`、地中海-意大利 `2403`、东印度-澳新 `2501`、太平洋/北美 `2600-2604` 和非洲 `2701`。
- 参考数值来源：主 buffer `ratio = 0.2` 明确高于中东-埃及 `0.15`、地中海-意大利 `0.12` 和非洲 `0.1`；front request `50` 与 `area_priority = 35` 表示欧洲陆上主攻，但完成门槛只收束到巴尔干主通道，防止长期吸走德国、意大利或其他欧洲战场兵力。
- live 落地：已补 `JAP_rework_anatolia_balkans_theater` area、安纳托利亚/巴尔干支点与完成触发、主推进、主/清扫登陆请求、主/清扫登陆窗口，以及 `JAP_lecture_anatolia_balkans_landing_boost` / `JAP_lecture_anatolia_balkans_landing_priority` on_action。推进、front request、front control、主登陆 followup 共用同一主目标 state_trigger 口径，保证 area、buffer、登陆和推进一致。
- 落地后观察：如果实测或剧情预期要求在巴尔干完成前就持续推进到维也纳、布拉格、布达佩斯以西或乌克兰方向，默认不扩大安纳托利亚-巴尔干军区，而由欧洲总战区低强度承接，避免 `ratio = 0.2` 的重兵池无限吞入德国纵深。黑海登陆按并行口径落地；亚得里亚清扫归属弹性处理，只保持低优先级和不参与完成条件。
- 实测问题记录：重点观察 `ratio = 0.2` 是否过度抽走中东/意大利方向兵力、伊斯坦布尔/埃迪尔内通道未完全掌控时是否提前囤兵卡死、中马其顿/阿提卡登陆是否能形成有效第二支点、黑海登陆是否过早孤军深入、塞尔维亚和多布罗加完成门槛是否能及时释放军区、以及侧翼清理州是否需要拆成后续低强度清场层。

## 欧洲总战区设计草案

### 欧洲总战区

- 剧情阶段：对轴心国欧洲战争进入意大利或巴尔干立足后启用，作为覆盖欧洲的总支援层，防止具体军区完成后前线部队因失去 buffer 被其他战线抽走。
- 负责目标：以伊斯坦布尔为总屯兵点，低强度维持欧洲大陆前线，并推动巴黎、柏林、罗马三处解放目标。
- 明确不负责：不写主动登陆，不要求清空全欧洲，不接手对苏北方军区，不把英国、西班牙、北欧或东欧残余写成完成门槛。
- area key：`JAP_rework_europe_theater`。
- 战略区域：覆盖英国、爱尔兰、低地、德国、法国、阿尔卑斯、意大利、巴尔干、波兰、波罗的海、斯堪的纳维亚、伊比利亚及欧洲周边主要海域。
- area 与完成条件的兼顾口径：area 足够大，用来保证部队自然推进到欧洲各处仍在军区服务半径内；完成条件只要求 `16` 法兰西岛、`64` 勃兰登堡、`2` 拉齐奥均由 ROOT 或盟友控制，避免全欧洲清场长期吸兵。
- 屯兵州：`797` 伊斯坦布尔。
- 立足州：伊斯坦布尔、埃迪尔内、色雷斯、中马其顿、塞尔维亚、多布罗加、北多布罗加，以及意大利本土推进州可作为欧洲总战区已经接上前线的口径。
- 启用条件：`Rance_is_jap_lecture_ai = yes`、`has_completed_focus = JAP_the_pacific_union_of_soviet_socialist_republics`、欧洲仍有敌情、欧洲总战区未完成；buffer 还要求 `797` 伊斯坦布尔由 ROOT 或盟友控制。
- 完成条件：`JAP_lecture_europe_key_objectives_secured = yes`，即 `16` 法兰西岛、`64` 勃兰登堡、`2` 拉齐奥由 ROOT 或盟友控制。
- 主 buffer：`JAP_lecture_europe_theater_buffer`，`order_id = 2405`，`put_unit_buffers ratio = 0.15`，`states = { 797 }`，`area = JAP_rework_europe_theater`，`subtract_invasions_from_need = yes`，`subtract_fronts_from_need = yes`。
- 基础推进：`JAP_lecture_europe_theater_push` 使用 `area_priority value = 20`、`front_unit_request value = 12`、`front_control priority = 350`、`execution_type = balanced`，`state_trigger = { is_on_continent = europe }`，并用 `global.num_days % 60 < 30` 控制低强度推进脉冲。
- live 落地：已补 `JAP_rework_europe_theater` area、伊斯坦布尔/欧洲立足/三州解放触发、伊斯坦布尔总 buffer 和欧洲低强度推进。不新增登陆请求、登陆窗口或 on_action。
- 实测问题记录：重点观察 `ratio = 0.15` 与安纳托利亚-巴尔干 `0.2`、地中海-意大利 `0.12` 同时启用时是否过度集中欧陆兵力，以及三州完成后是否能及时释放欧洲总战区。

## 单个军区设计卡

复制本卡片到对应军区小节，填完后再写脚本。

```text
### 军区名

- 剧情阶段：
- 负责目标：
- 明确不负责：
- area key：
- 战略区域：
- area 覆盖半径说明：
- 屯兵州：
- 主目标州：
- 重合军区：
- 启用条件：
- 放弃条件：
- 完成条件：
- 主 buffer：
- 清理 buffer：
- front_unit_request：
- invasion_unit_request：
- front_control priority：
- 登陆链：
- 登陆后 flag：
- on_action 需求：
- order_id：
- 参考数值来源：
- 实测问题记录：
```

## 数值占位

先沿用皇道派的数值梯子作占位，后续按讲座派剧情实测微调。

- 本土危机默认最高；除非单个军区设计卡明确标注不回援，外线策略遇到本土危机必须收缩或降权。
- 中国战后休整层固定在 `priority = 680`：高于普通外线推进，低于登陆后 30 天桥头堡、装备不足停攻和本土危机。
- 登陆后 30 天桥头堡高于普通推进和战后休整层，但低于装备不足停攻和本土危机。
- 普通大军区推进不要长期写成最高强推；主战、接替、清理应分强度。
- `put_unit_buffers` 的 `states` 是屯兵点，`area` 才是服务范围；buffer、front request、front control 和 invasion request 应指向同一军区口径。
- 登陆请求先保守，优先写门槛、链式目标和登陆后 flag，不用一次性给大量目标 `100+`。

## 旧文件搬运规则

- 旧 `Jap_rework_cm_mil.md` 中的每个旧条目先抽象为“剧情目的”，再决定是否重写成新军区条目。
- 旧的大区权重只作为意图参考，不直接搬运 `asia`、`pacific`、`europe` 等永久高权重。
- 旧登陆清单必须改写为链式登陆：启用门槛、目标请求、制海窗口、登陆后 30 天推进、完成释放。
- 旧装甲和 front control 条目要放进对应军区或全局保险层，不单独漂浮在文件末尾。

## 落地顺序

1. 在本文件补完讲座派剧情阶段。
2. 根据剧情确定第一批军区、area key、战略区域和屯兵州。
3. 新建或更新讲座派 area 文件。
4. 新建或更新讲座派 AI area scripted triggers。
5. 补登陆后 `on_actions` flag 链。
6. 重写 live 讲座派军事策略文件。
7. 同步新增讲座派战争策略参考和维护检查清单。

## 落地前检查

- 每个策略都有 `allowed`、`enable`、`abort` 或 `abort_when_not_enabled`。
- 路线判断在 `enable`，不是只放在 `allowed`。
- 每个军区有放弃条件，出发口或屯兵点全丢时不会继续吸兵。
- 每个军区有完成条件，主目标结束后不会永久占用主力。
- 每个新设军区的 area 范围足够覆盖完成/放弃前的作战半径，不出现空心区域或推进断档。
- area、buffer、front request、front control、landing request 口径一致。
- 新增 area、trigger、on_action 和策略 key 后，同步更新参考文档。
