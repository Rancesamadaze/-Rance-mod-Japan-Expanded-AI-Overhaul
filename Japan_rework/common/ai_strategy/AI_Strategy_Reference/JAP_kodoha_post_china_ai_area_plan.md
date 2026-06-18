# 皇道派中国战后 AI 区域计划

> 目的：为皇道派吞并中国、包含西藏后的后续战争策略准备 AI area 拆区方案。重点是对同盟国、共产国际多战线作战时，减少相隔很远的战线互相抽兵。
>
> 第一批已落地区域文件为 `common/ai_areas/JAP_rework_areas.txt`。后续新增区域继续使用唯一 area key，避免改原版 `default.txt`。

## 基础前提

- 日本为皇道派路线，已经吞并中国与西藏。
- `JAP_china_war_substantially_ended_flag` 已代表“中国战事基本结束”，皇道派对华主线战争策略应停止。
- 后续主要敌人分两类：
  - 同盟国：英属印度、缅甸、马来亚、荷属东印度、菲律宾、澳大利亚、太平洋岛链、美国。
  - 共产国际：苏联远东、外蒙古/中亚方向、西伯利亚纵深。
- 战争策略目标不是把 `area_priority` 堆高，而是把 area、buffer、front request、front control 指向同一战区，形成本地兵池。
- 日本本土防卫只认显式日本列岛 13 州，不使用 `surrender_progress` 或 `is_core_of = JAP`。皇道派后期可能在亚洲扩展核心，投降进度和核心状态都不能作为本土危机口径。

## AI Area 写法

AI area 文件放在 `common/ai_areas/`，基本结构如下：

战略区域 ID 与中文区域名先查 `Reference/strategic_region_reference.md`，再按实际部署需要组合进 `strategic_regions = { ... }`。

```txt
areas = {
	JAP_rework_example_front = {
		strategic_regions = {
			189 # Burma
			292 # Shan States
			293 # Tenasserim
			294 # Rangoon
			295 # Mandalay
			141 # East India
			153 # Northern India
			290 # Bengal
		}
	}
}
```

可用字段：

- `strategic_regions = { ... }`：推荐主用。适合精准拆分陆上战区、登陆区、海域控制区。
- `continents = { asia }`：只适合兜底大区，不适合后续皇道派多线战争主控。
- area key 在 AI strategy 中用两种方式：
  - `area_priority` 使用 `id = <area_key>`。
  - `front_unit_request`、`invasion_unit_request`、`front_control`、`put_unit_buffers` 使用 `area = <area_key>`。

对象对齐示意：

```txt
ai_strategy = {
	type = put_unit_buffers
	order_id = 2101
	ratio = 0.15
	states = {
		325 # 云南
		599 # 广西
	}
	area = JAP_rework_example_front
	subtract_invasions_from_need = yes
	subtract_fronts_from_need = yes
}

ai_strategy = {
	type = front_unit_request
	area = JAP_rework_example_front
	value = 20
}

ai_strategy = {
	type = front_control
	area = JAP_rework_example_front
	ratio = 0
	priority = 450
	ordertype = front
	execution_type = balanced
	execute_order = yes
	manual_attack = yes
}
```

写法规则：

- 新 area key 使用 `JAP_rework_` 前缀，避免与原版 `asia`、`burma`、`east_indies` 等 key 混淆；路线语义保留在策略、trigger 和 flag 名中。
- 陆上前线 area 不要混入太远的海域。海域制海、登陆航线可以单独建 naval/control area。
- `put_unit_buffers` 的 `states` 是屯兵位置，`area` 是这些 buffer 服务的作战范围。
- 对于“军区集结”用法，可以把 `states` 写在合适的后方集结州，但 `area` 必须和对应 `front_unit_request` / `front_control` 的 area 对齐，避免 buffer 服务范围和前线需求脱节。
- 只有 buffer 屯兵点、登陆点、补给建设点、防守锚点、停止/完成条件才直接写 `state = <id>` 或 `states = { ... }`。
- 若需要修改原版已有 area，不直接改原版；优先新增更细的本项目 area key。
- 本土预备队不写成 `area = asia` 或覆盖全亚洲的大军区；使用 `JAP_rework_home_islands_defense` 单独绑定战略区域 `154` 日本列岛。

## 东南亚军区第一版

本节记录东南亚军区第一版落地口径，用于后续扩展前统一命名、区域边界、buffer 认知与驻军停止口径。

预留 area key：

- `JAP_rework_southeast_asia_theater`
- 中文名：东南亚军区
- 定位：从华南、广西、云南出发，覆盖缅甸、印支、暹罗、马来亚、马六甲的单一大区。
- 实际文件：`common/ai_areas/JAP_rework_areas.txt`。

建议战略区域组合：

| 分类 | 战略区域 |
| --- | --- |
| 中国南方出发边 | `165` 华南、`248` 广西、`249` 云南 |
| 中南半岛/马来亚 | `142` 北印度支那、`228` 南印度支那、`229` 暹罗、`188` 马来亚 |
| 缅甸实际区域 | `292` 掸族诸邦、`293` 丹那沙林、`294` 仰光、`295` 曼德勒 |
| 相关海路 | `72` 马六甲海峡、`73` 暹罗湾、`75` 南中国海 |

暂不纳入：

- `189`：当前原版 `189-Burma.txt` 实际 province 数为 `0`，不作为东南亚军区组成部分。
- `101` 孟加拉湾：暂不纳入，避免东南亚军区过早牵到印度/安达曼方向。

落地策略规则：

- `put_unit_buffers` 使用中国南方州作为屯兵点：云南、广西、南宁、广州、广东、海南。中国战事基本结束、南方支点可用且核心走廊未完成时即可提前集结；不再额外要求南进国策或东南亚敌情。
- `put_unit_buffers`、`front_unit_request`、`front_control` 的服务范围统一为 `area = JAP_rework_southeast_asia_theater`。
- 具体州 ID 也用于“停止驻军/完成目标”的判断；但实际前线推进第一版只写 area 级策略，不拆多段州级推进。
- 主动登陆第一版采用登陆链：海南 `591` 控制后才尝试暹罗 `289` 和马来亚 `336`；马来亚 `336` 控制后才尝试勃固/仰光 `995`。
- “出发州”只作为 AI strategy 启停门槛，不代表能指定 HOI4 AI 的真实出发港。
- 新加坡 `1021` 只保留为核心走廊完成条件，不作为主动登陆目标。
- 不写非目标登陆点负向抑制；第一版只提高 `289/336/995` 三个目标本身的登陆需求。

军区编写要点模板：

- 先写定位：说明军区负责的主方向、接替哪个旧军区、允许和哪些军区重合、明确不负责哪些方向。
- 再定 area：战略区域只纳入服务当前军区的陆上前线、必要岛屿与航路；无有效 province 的区域不要纳入，容易牵走兵力的海域延后单独规划。
- 写清边界：第一版宁可用一个清晰军区验证调兵行为，也不要把距离很远的印度、东印度群岛、澳大利亚等方向混成一个超远距离 area。
- 对齐兵池：`put_unit_buffers` 的 `states` 是屯兵点，`area` 才是服务军区；`put_unit_buffers`、`front_unit_request`、`front_control`、`invasion_unit_request` 要指向同一军区口径。
- 接替军区兵池：如果新军区是接替旧军区继续从同一前进基地推进，可以复用被接替军区的 `order_id` 来避免交接期双倍吸兵；但当两个军区的退出边界、debug 释放或本地守备生命周期不同，应优先拆分 `order_id`，避免旧军区残留需求和新军区需求互相污染。
- 不要只写屯兵州：如果 buffer 的驻军点和前线 area 没有服务关系，AI 容易把兵留在后方，不流向开战后的前线。
- 先写出发/放弃/完成三类 trigger：出发口或屯兵点可用才启用；出发口全丢就放弃军区需求。主战 buffer 的完成条件优先用关键目标已由 ROOT/盟友控制；`controller = { has_war_with = ROOT }` 的敌情更适合用于战时 `front_unit_request`、`front_control`、登陆和清理阶段。
- 大军区要分强度：主战阶段给正常 buffer、`front_unit_request` 和推进优先级；只剩重合区、小飞地或残余目标时进入清理阶段，保持不释放但显著降需求。
- 重合区要写主次：允许多个军区覆盖同一州，但要用 `front_control priority` 决定主处理军区，辅助军区的清理优先级低于主推进。
- 登陆层单独成链：出发州门槛只控制“该不该尝试登陆”，不代表能指定真实出发港；每个主动目标要同步写 `invade`、`invasion_unit_request`、共享登陆窗口和登陆后 flag。
- 登陆后巩固统一 30 天：`on_naval_invasion` 打国家 flag 与州 flag，后续 `front_unit_request` 和 `front_control priority = 700` 只覆盖登陆州及邻州，且低于补装备停攻。
- 登陆兵力请求要保守：皇道派多目标并发时普通主动登陆点按 `invasion_unit_request = 60` 左右起步，不默认写非目标负向抑制，除非实测 AI 乱飞。
- 每新增军区都同步文档和检查：area key、战略区域、屯兵州、释放/完成 trigger、登陆目标、登陆后 flag、优先级梯子和静态检查结果都要记录。

停止驻军口径：

- 放弃条件：云南、广西、南宁、广州、广东这些中国南方大陆出发口全部不由日本或盟友控制时，未来策略应停止在东南亚军区驻军。
- 完成条件：核心走廊由日本或盟友控制后释放兵力；建议核心州为景栋和永贵、掸族诸邦、曼德勒、勃固、丹那沙林、老挝、东京（北圻/Tonkin）、越南中部、占婆、柬埔寨、暹罗、马来亚、新加坡。
- 对应 trigger 放在 `common/scripted_triggers/JAP_kodoha_ai_area_scripted_triggers.txt`，只供 AI 条件使用，不提供玩家 UI tooltip。

## 南亚军区第一版

实际 area key：`JAP_rework_south_asia_theater`，位于 `common/ai_areas/JAP_rework_areas.txt`。

定位：从喜马拉雅边境与勃固两条入口服务南亚次大陆，覆盖印度、巴基斯坦、孟加拉、喜马拉雅、锡兰、法属印度、果阿，并补入塔克拉玛干、阿里、北阿富汗和南阿富汗作为西北接触线；允许和东南亚军区在缅甸有效战略区域重合，也允许和北方西线在塔克拉玛干重合。

战略区域组合：

| 分类 | 战略区域 |
| --- | --- |
| 南亚陆上主战区 | `146` 喜马拉雅、`141` 东印度、`153` 北印度、`290` 孟加拉、`31` 德干高原、`231` 东高止、`253` 温迪亚恰尔、`254` 塔尔沙漠、`296` 古吉拉特、`190` 巴基斯坦、`291` 俾路支 |
| 西北接触线 | `145` 塔克拉玛干、`251` 阿里、`162` 北阿富汗、`289` 南阿富汗 |
| 印度洋登陆/岛屿 | `101` 孟加拉湾、`104` 阿拉伯海、`230` 科摩林角 |
| 缅甸重合通道 | `292` 掸族诸邦、`293` 丹那沙林、`294` 仰光、`295` 曼德勒 |

不纳入：

- `189`：当前原版 `189-Burma.txt` 的 province 全部被注释，实际有效 province 数为 `0`。

屯兵口径：

- 主战阶段使用边境/出发口屯兵：那曲 `322`、日喀则 `757`、阿里 `758`、勃固 `995`。
- 中国战事基本结束、喜马拉雅边境或勃固任一路径可用且印度次大陆战略骨架未全控时即可提前集结；主战阶段 `put_unit_buffers order_id = 2401`，`ratio = 0.15`，服务 `area = JAP_rework_south_asia_theater`。
- 清理阶段仍不释放军区，但改用印度内部节点西孟加拉 `431`、比哈尔 `435`、联合省 `438`、孟买 `429`、海德拉巴 `427`、南马德拉斯 `423`，降到 `ratio = 0.06`、`front_unit_request = 10`、`front_control priority = 360`，避免为缅甸残余或小飞地长期吸走主力。
- 昌都 `601`、四川 `605`、云南 `325` 不再作为南亚 `2401` 屯兵点。

释放与完成口径：

- 主战 buffer 放弃条件：喜马拉雅边境屯兵点全部不可用，且勃固 `995` 不由 ROOT 或盟友控制。
- 战时执行/登陆放弃条件：喜马拉雅边境屯兵点全部不可用，且勃固 `995` 不由 ROOT 或盟友控制。
- 主战 buffer 完成条件：印度次大陆战略骨架州均由 ROOT 或盟友控制，使用 `JAP_kodoha_south_asia_main_objectives_secured`；锡兰 `422` 不参与该完成条件，避免海岛登陆目标长期锁住主战屯兵。
- 当前战略骨架州为 `423 424 425 426 427 428 429 430 431 432 433 435 436 437 438 439 440 443 983 986`。
- 战时执行完成条件：南亚主目标、缅甸重合区、法属印度 `320`、果阿 `321` 均不存在 `controller = { has_war_with = ROOT }`；该口径用于推进、登陆和清理，不再阻止和平期主战 buffer。
- 缅甸重合区阻塞南亚完成，但南亚清理优先级低于东南亚主推进，让东南亚军区仍是缅甸主处理方向。
- 法属印度和果阿不作为第一批主动登陆目标；若它们的控制者正与日本交战，会阻塞完成并进入低强度清理阶段。

主动登陆：

- 出发门槛使用勃固 `995`，复用东南亚登陆链中已有沿海目标。
- 主动登陆目标为西孟加拉 `431`、孟买 `429`、锡兰 `422`；锡兰保留独立登陆目标口径，但不再卡主战 buffer。
- 每个目标写一条反转 `invade value = 100` 和一条 `invasion_unit_request value = 60`。
- 三个目标共享 `naval_invasion_focus = 100`、`naval_invasion_dominance_weight = 40`，并要求 `enemies_naval_strength_ratio < 1.5`。
- 登陆后由 `JAP_kodoha_south_asia_landing_boost` 和 `JAP_kodoha_south_asia_landing_priority` 提供 30 天登陆场推进窗口，`front_control priority = 700`。

## 东印度-澳新军区第一版

实际 area key：`JAP_rework_east_indies_australia_theater`，位于 `common/ai_areas/JAP_rework_areas.txt`。

定位：东南亚军区基本完成马六甲-新加坡核心走廊后，由马来亚 `336` 和新加坡 `1021` 接替出发，向英荷葡殖民地岛屿、荷属东印度、新几内亚、澳大利亚和新西兰推进；不负责菲律宾-美国殖民地方向。

战略区域组合：

| 分类 | 战略区域 |
| --- | --- |
| 马六甲接替与东印度西段 | `188` 马来亚、`72` 马六甲海峡、`187` 苏门答腊、`159` 婆罗洲 |
| 东印度中东段与新几内亚 | `158` 巽他群岛、`93` 爪哇海、`167` 新几内亚、`91` 阿拉弗拉海、`99` 极东印度洋 |
| 澳大利亚与新西兰 | `193` 北澳大利亚、`156` 南澳大利亚、`194` 东澳大利亚、`195` 中澳大利亚、`98` 大澳大利亚湾、`157` 新西兰、`86` 塔斯曼海、`81` 珊瑚海 |

不纳入：

- 菲律宾和中太平洋战略区，避免本军区把舰队与登陆需求牵向美国殖民地岛链。

接替与释放口径：

- 启用门槛：`JAP_kodoha_southeast_asia_core_corridor_secured = yes`，且马来亚 `336` 或新加坡 `1021` 由 ROOT 或盟友控制。
- 推进/守备门槛：接替点可用，或军区关键支点仍由 ROOT/盟友控制；避免马六甲-新加坡后来失守时连已登陆主支点也停摆。
- 放弃条件：军区关键支点全失。关键支点为马来亚 `336`、新加坡 `1021`、苏门答腊 `672`、爪哇 `335`、沙捞越 `333`、加里曼丹 `334`、苏拉威西 `673`、西巴布亚 `669`、巴布亚 `523`、北领地 `520`、西澳大利亚 `522`、北昆士兰 `872`、新南威尔士 `285`、北岛 `284`；小巽他、东帝汶、摩鹿加、内婆罗洲、塔斯马尼亚、南岛不维持整个军区。
- 完成条件：东印度大岛、澳新、残余小岛/内陆目标均不存在 `controller = { has_war_with = ROOT }`。
- 本军区接替/清理 buffer 使用独立 `order_id = 2501`，area 为 `JAP_rework_east_indies_australia_theater`；不再与东南亚 `order_id = 2301` 共池，避免东南亚退出残留和 EIA 本地守备互相污染。EIA 不做和平提前集结，仍按战时接替口径启用。

枢纽网络登陆：

- 第一波四门户并行：马来亚 `336` 或新加坡 `1021` 可用后，同时开放苏门答腊 `672`、爪哇 `335`、沙捞越 `333`、加里曼丹 `334`。
- 第二波东印度枢纽：由任一合理门户开放小巽他 `667`、东帝汶 `721`、摩鹿加 `668`、苏拉威西 `673`、西巴布亚 `669`、巴布亚 `523`。
- 第三波澳新登陆：主动登陆北领地 `520`、西澳大利亚 `522`、北昆士兰 `872`、新南威尔士 `285`，并在澳洲东岸桥头堡后开放北岛 `284`、南岛 `723`；塔斯马尼亚 `518` 作为晚期末端低强度主动登陆目标，只能由新南威尔士 `285` 或维多利亚 `517` 打开。
- 每个主动目标写一条反转 `invade value = 100` 和一条 `invasion_unit_request`；主门户/主桥头堡为 `45`，次级枢纽为 `35`，小岛或末端岛为 `25`。
- 共享登陆窗口：`naval_invasion_focus = 80`，`naval_invasion_dominance_weight = 40`，并要求 `enemies_naval_strength_ratio < 1.5`。

front control 分层：

- 登陆后桥头堡：`priority = 700`，`rush_weak`，30 天内覆盖有 `JAP_kodoha_eia_landing_priority` 的登陆州及邻州；小巽他、东帝汶、摩鹿加、南岛、塔斯马尼亚只给低强度登陆后巩固，主门户、巴布亚和澳洲桥头堡维持较高 followup。
- 澳新大陆推进：`priority = 480`，已有北领地、西澳大利亚、北昆士兰或新南威尔士桥头堡后启用。
- 东印度大岛推进：`priority = 440`，苏门答腊、爪哇、沙捞越、加里曼丹、苏拉威西、西巴布亚、巴布亚及邻州。
- 残余清理：`priority = 320`，主节点清完后低强度处理小岛、内陆和零散敌控州。

buffer 分层：

- 主阶段：使用独立 `order_id = 2501`，`ratio = 0.15`，屯兵马来亚 `336` 与新加坡 `1021`，并给本军区 `area_priority = 20`；只在 EIA 有战时目标且未进入清理阶段时启用。
- 清理阶段：同一 `order_id = 2501` 降到 `ratio = 0.04`，只在 `JAP_kodoha_eia_cleanup_enemy_presence = yes` 时启用，避免主力长期卡在小岛或内陆残余上。

本地弹性防备池：

- 本地守备与马来亚/新加坡接替集结、清理集结共用 `order_id = 2501`，全部写 `area = JAP_rework_east_indies_australia_theater`。
- 每个节点只在该州由 ROOT 或盟友控制时启用，避免敌控节点被当作 buffer 州并诱导进攻。
- 主阶段每个受控节点一条本地 buffer，`ratio = 0.15`，并按西侧、东侧、澳新方向敌情启用；清理阶段同节点列表降为 `ratio = 0.04`。
- 所有本地守备写 `subtract_invasions_from_need = yes`、`subtract_fronts_from_need = yes`，允许军区内登陆和前线调用守备兵。
- 节点列表：西侧为苏门答腊 `672`、爪哇 `335`、小巽他 `667`、东帝汶 `721`；东侧为沙捞越 `333`、加里曼丹 `334`、摩鹿加 `668`、苏拉威西 `673`、西巴布亚 `669`、巴布亚 `523`；澳新为北领地 `520`、西澳大利亚 `522`、北昆士兰 `872`、新南威尔士 `285`、维多利亚 `517`、北岛 `284`、南岛 `723`、塔斯马尼亚 `518`。

## 太平洋军区区域第一版

实际 area key：`JAP_rework_pacific_theater`，位于 `common/ai_areas/JAP_rework_areas.txt`。

定位：统一承接菲律宾、美国太平洋岛屿、日方岛链和对美远期岛屿争夺，不再拆分菲律宾近海、中太平洋、夏威夷三个 area。台湾 `524`、冲绳 `526`、北九州 `528`、南九州 `1018` 纳入本军区口径；北九州和南九州作为当前主体策略的囤兵处或本土相关目标。

战略区域组合：

| 分类 | 战略区域 |
| --- | --- |
| 本土近海与前进囤兵 | `154` 日本列岛、`90` 日本海岸、`76` 东中国海 |
| 菲律宾争夺核心区 | `75` 南中国海、`78` 菲律宾海、`160` 菲律宾 |
| 日方岛链与美国前沿岛屿 | `94` 马里亚纳海沟、`84` 俾斯麦海、`97` 东密克罗尼西亚 |
| 中太平洋连接区 | `95` 西天皇海山链、`96` 北天皇海山链、`180` 密克罗尼西亚裂谷 |
| 夏威夷与对美远期航线 | `177` 西北太平洋、`114` 北太平洋、`172` 太平洋海脊、`105` 夏威夷海脊 |

不纳入：

- `77` 黄海，避免太平洋军区牵扯朝鲜、华北和黄海侧翼方向。

关键州覆盖：

- 台湾 `524`、冲绳 `526`、北九州 `528`、南九州 `1018`。
- 菲律宾核心：马尼拉 `327`、吕宋 `623`、东米沙鄢 `625`、巴拉望 `626`、达沃 `627`、西米沙鄢 `628`、北棉兰老 `1026`。
- 日方岛链与美国岛屿：硫磺岛 `645`、塞班岛 `646`、加罗林群岛 `684`、马绍尔群岛 `633`、关岛 `638`、威克岛 `632`、中途岛 `631`、夏威夷 `629`。
- 主体策略已落地：包含九州集结、可调用弹性守备、两条逐跳登陆链、共享登陆窗口、登陆后 30 天推进、常态推进和两条不可调用岛链守备。

岛链规划：

- 北/中太平洋主链：北九州 `528` / 南九州 `1018` -> 硫磺岛 `645` -> 塞班岛 `646` -> 关岛 `638` -> 威克岛 `632` -> 中途岛 `631` -> 夏威夷 `629`。
- 南/菲律宾支链：北九州 `528` / 南九州 `1018` -> 冲绳 `526` -> 台湾 `524` -> 马尼拉 `327` / 吕宋 `623` -> 北棉兰老 `1026` / 达沃 `627` -> 加罗林群岛 `684` -> 马绍尔群岛 `633` -> 威克岛 `632` -> 中途岛 `631` -> 夏威夷 `629`。
- 北/中太平洋主链是对美岛屿争夺主线，继承旧讲座派“塞班 -> 关岛 -> 威克 -> 中途 -> 夏威夷”的方向，但向内补上九州、硫磺岛和塞班岛防守纵深。
- 南/菲律宾支链负责菲律宾和南侧太平洋侧翼，避免太平洋军区只沿北线单点推进；菲律宾失守时应能回守台湾/冲绳，加罗林群岛失守时应能回守菲律宾或塞班方向。
- “从九州出发”是战略根节点和囤兵口径；脚本不假设 HOI4 能指定真实出发港，只用九州和内环岛屿作为启用、守备和释放门槛。
- 两条链在威克岛或中途岛方向汇合，夏威夷是共同终点，不拆第三条远洋链。
- 当前守备策略优先保护最近两级后路（当前推进节点 + 上一跳），关键汇合和终点节点保留到军区清空；可调用弹性守备与九州集结共用 `order_id = 2600`，旧北链和南链不可调用守备仍分用 `2601/2602`。
- 夏威夷方向应晚启用，至少要求威克岛或中途岛稳定，不在菲律宾和日方岛链仍危险时高权重直冲夏威夷。

主体策略数值：

- 九州集结：`JAP_kodoha_pacific_theater_buffer`，`put_unit_buffers order_id = 2600`，`ratio = 0.10`，屯兵北九州 `528` 与南九州 `1018`，`area_priority = 20`；中国战事基本结束、九州支点可用、重要目标未全控且日本列岛 13 州安全时即可提前集结。
- 可调用弹性守备：14 个主动/守备节点各一条 `put_unit_buffers order_id = 2600`、`ratio = 0.10`，复用对应旧守备 `_needed`，并允许登陆和前线需求抵扣。
- 主动登陆：十四个目标各有 `reversed = yes` 的 `invade` 与 `invasion_unit_request`；硫磺岛、塞班岛、关岛、冲绳、台湾、马尼拉、吕宋为 `50`，威克岛、中途岛、北棉兰老、达沃、加罗林群岛、马绍尔群岛为 `40`，夏威夷为 `30`。
- 登陆窗口：`JAP_kodoha_pacific_landing_window` 使用 `naval_invasion_focus = 80`、`naval_invasion_dominance_weight = 40`，所有主动登陆仍要求 `enemies_naval_strength_ratio < 1.5`。
- 登陆后推进分层：硫磺岛、威克岛、中途岛、马绍尔群岛不打 followup flag；冲绳、塞班岛、关岛、加罗林群岛、夏威夷使用 `front_unit_request = 5`、`front_control priority = 690`；台湾、马尼拉、吕宋、北棉兰老、达沃使用 `front_unit_request = 10`、`priority = 700`。
- 常态推进：`JAP_kodoha_pacific_theater_push` 给 `front_unit_request = 15`、`front_control priority = 420`、`balanced`，低于东印度-澳新澳新推进 `480` 和东南亚主推进 `520`。
- 不可调用岛链守备：旧北链 `order_id = 2601`，旧南链 `order_id = 2602`；普通小岛 `ratio = 0.02`，台湾/冲绳/菲律宾主节点 `0.03`，夏威夷 `0.04`，并保留 `subtract_invasions_from_need = no` 与 `subtract_fronts_from_need = no`。
- 夏威夷晚启用：要求中途岛 `631` 由 ROOT 或盟友控制，且日本内环与菲律宾主节点无敌情。
- 撤出和完成：日本列岛 13 州任一州失控即关闭太平洋主体策略；十四个主动登陆链目标全部由 ROOT 或盟友控制后视为军区完成，不再追逐菲律宾残余州。
- 完成后守备：夏威夷 `629` 保留 `JAP_kodoha_pacific_hawaii_permanent_guard`，`order_id = 2603`，`ratio = 0.03`；若日本列岛 13 州失控则该常驻守备也关闭。

## 北方军区拆分第一版

实际 area key：`JAP_rework_northern_east_theater` 和 `JAP_rework_northern_west_theater`，位于 `common/ai_areas/JAP_rework_areas.txt`。单体 `JAP_kodoha_northern_theater` 已废弃，不再作为有效 area key。北方东线与北方西线主体策略均已落地；西线不写登陆、`on_action` 或守岛 buffer。

东线战略区域：`154` 日本列岛、`143` 华北、`155` 西满洲、`242` 北满洲、`243` 东满洲、`186` 朝鲜、`148` 俄属远东、`149` 东西伯利亚、`255` 阿穆尔、`256` 外贝加尔、`257` 北远东、`258` 鄂霍茨克、`259` 东萨哈、`260` 西萨哈、`79` 日本海、`87` 鄂霍茨克海、`88` 白令海。

西线战略区域：`145` 塔克拉玛干、`144` 华西、`267` 外里海、`268` 费尔干纳、`269` 撒马尔罕、`270` 锡尔河、`200` 青海、`244` 察哈尔、`245` 山西、`252` 天山、`152` 外蒙古、`266` 乌梁海、`147` 北西伯利亚、`151` 西西伯利亚、`261` 阿尔泰、`262` 中西伯利亚、`14` 外乌拉尔、`138` 乌拉尔山区、`263` 外乌拉尔-涅涅茨、`264` 科米-涅涅茨。

用途：东线负责华北、满洲、朝鲜到苏联远东、阿穆尔、外贝加尔、东西伯利亚与萨哈方向，是对苏主陆战方向；北海道作为东线屯兵和大陆登陆支点纳入 area，但不参与东线 access lost。西线负责新疆、华西、青海、山西/察哈尔、外蒙古、乌梁海侧翼、阿尔泰、西伯利亚纵深到乌拉尔边界，并覆盖新疆外侧苏联中亚；本版只补 area，不扩大主动推进 state_trigger。`255` 阿穆尔用于补齐阿穆尔州；`259` 东萨哈、`260` 西萨哈用于补齐雅库茨克作战半径；`261` 阿尔泰用于补齐哈卡斯和卫拉特地区作战半径；`266` 乌梁海用于覆盖唐努图瓦；`264` 科米-涅涅茨用于覆盖北乌拉尔州，仍不代表向欧洲俄国核心推进。

明确排除：不纳入中国全域，排除华东、华中、华南、广西、云南等南方纵深；不纳入印度、巴基斯坦；不纳入 `150` 阿尔汉格尔斯克/北极俄国或欧洲俄国核心；不纳入 `77` 黄海和 `114` 北太平洋。阿富汗由南亚军区覆盖，塔克拉玛干允许与南亚军区重合。

关键覆盖核对：东线覆盖北海道、吉林、黑龙江、符拉迪沃斯托克、哈巴罗夫斯克、阿穆尔、赤塔、布里亚特、伊尔库茨克、雅库茨克、堪察加、北萨哈林、南萨哈林；西线覆盖乌鲁木齐、准噶尔、青海、绥远、察哈尔、乌兰巴托、唐努图瓦、哈卡斯、卫拉特地区、新西伯利亚、北乌拉尔、华西、山西，以及外里海、费尔干纳、撒马尔罕、锡尔河战略区域内的苏联中亚州。

战前准备态主战兵池预算按同 `order_id` 取最高 ratio，不按同 ID 条目相加：

| order_id | 军区 | ratio |
| --- | --- | --- |
| `2301` | 东南亚，与东印度-澳新互斥 | `0.15` |
| `2501` | 东印度-澳新主阶段，与东南亚互斥 | `0.15` |
| `2401` | 南亚主战 | `0.15` |
| `2600` | 太平洋 | `0.10` |
| `2701` | 北方东线预备 | `0.10` |
| `2702` | 北方西线预备 | `0.05` |
| `2800` | 本土常态预备 | `0.05` |
| 合计 | 东南亚/EIA 二者择一 | `0.60` |

北进论完成或对苏开战后的全量主战预算：

| order_id | 军区 | ratio |
| --- | --- | --- |
| `2301` | 东南亚，与东印度-澳新互斥 | `0.15` |
| `2501` | 东印度-澳新主阶段，与东南亚互斥 | `0.15` |
| `2401` | 南亚主战 | `0.15` |
| `2600` | 太平洋 | `0.10` |
| `2701` | 北方东线全量 | `0.25` |
| `2702` | 北方西线全量 | `0.14` |
| `2800` | 本土常态预备 | `0.05` |
| 合计 | 东南亚/EIA 二者择一 | `0.84` |

北美本土登陆属于更晚阶段，不计入上述亚洲/北方主战预算；满足四个亚洲主战区基本完成、对美战争仍在且夏威夷完全控制后，启用 `order_id = 2604`、`ratio = 0.25`。夏威夷集结和西海岸转移囤兵共用该 `order_id` 且互斥。

本土预警和危机仍使用同一 `order_id = 2800`，常态 `0.05`、预警 `0.15`、危机 `0.25` 只取最高层，不叠加。朝鲜止血使用独立 `order_id = 2810`、`ratio = 0.04`，仅在满洲关键州预警且本土未危机时额外启用。

北方东线主体策略：`JAP_kodoha_northern_east_theater_reserve_buffer` 使用 `order_id = 2701`、`ratio = 0.10`，未完成北进论且未对苏开战时先行集结；`JAP_kodoha_northern_east_theater_buffer` 在完成北进论 `JAP_hokushin_ron` 或与苏联开战后切到 `ratio = 0.25`、`area_priority = 35`。屯兵州均为北海道 `536`、热河 `610`、辽宁 `716`、吉林 `328`、黑龙江 `714`、平安-黄海 `527`、咸镜 `1028`；北海道在东线 area 内，东线 area 也补入东萨哈/西萨哈以覆盖雅库茨克作战半径，但 `JAP_kodoha_northern_east_access_lost` 只看热河、辽宁、吉林、黑龙江、平安-黄海、咸镜这些前进支点。`JAP_kodoha_northern_east_main_pressure` 使用 `front_unit_request = 45`、`front_control priority = 560`、`balanced`。完成北进论且与苏联交战时，`JAP_kodoha_northern_soviet_armor_score` 给 `SOV` `front_armor_score = 200`，用于把装甲/进攻模板推向苏联前线。北海道作为登陆支点，主动登陆符拉迪沃斯托克 `408` 与哈巴罗夫斯克 `409`，登陆请求分别为 `45/35`，共享 `naval_invasion_focus = 60`、`naval_invasion_dominance_weight = 35`；不登陆萨哈林/堪察加，不新增岛链守备。

北方西线主体策略：`JAP_kodoha_northern_west_theater_reserve_buffer` 使用 `order_id = 2702`、`ratio = 0.05`，未完成北进论且未对苏开战时先行集结；`JAP_kodoha_northern_west_theater_buffer` 在完成北进论 `JAP_hokushin_ron` 或与苏联开战后切到 `ratio = 0.14`、`area_priority = 15`。屯兵州均为乌鲁木齐 `617`、准噶尔 `618`、青海 `604`、绥远 `621`、察哈尔 `611`、乌兰巴托 `330`。西线 area 覆盖华西、山西、阿尔泰，以及外里海、费尔干纳、撒马尔罕、锡尔河内的苏联中亚州，但本版不把这些州加入侧翼敌情、推进 state_trigger 或完成条件。`JAP_kodoha_northern_west_side_pressure` 只在侧翼敌情存在时启用，用 `front_unit_request = 20`、`front_control priority = 400` 稳推外蒙古、乌梁海、新疆和青海侧翼；`JAP_kodoha_northern_west_deep_pressure` 只在北方东线远东主轴完成，或西线已控制克拉斯诺亚尔斯克 `568`、新西伯利亚 `570`、鄂木斯克 `571` 任一桥头堡后启用，用 `front_unit_request = 15`、`front_control priority = 340` 低强度推向乌拉尔边界。

北方东线完成/撤出：符拉迪沃斯托克 `408`、哈巴罗夫斯克 `409`、阿穆尔 `561`、赤塔 `563`、布里亚特 `564`、伊尔库茨克 `566` 全控后关闭东线主体；日本列岛 13 州任一州失控时由统一 `JAP_kodoha_home_islands_compromised` 立即关闭东线主体。

北方西线完成/撤出：乌兰巴托 `330`、唐努图瓦 `329`、克拉斯诺亚尔斯克 `568`、新西伯利亚 `570`、鄂木斯克 `571`、北乌拉尔 `581`、斯维尔德洛夫斯克 `653`、车里雅宾斯克 `572`、马格尼托哥尔斯克 `582` 全控后关闭西线主体；日本列岛 13 州任一州失控时由统一 `JAP_kodoha_home_islands_compromised` 立即关闭西线主体。西线不写登陆、不写 `on_action`、不新增守备 `order_id`。

## 北美军区第一版

实际 area key：`JAP_rework_north_america_theater`，位于 `common/ai_areas/JAP_rework_areas.txt`。

定位：皇道派日本完成四个亚洲主战区基本使命、对美国开战并完全控制夏威夷 `629` 后，先在夏威夷集结，再登陆美国西海岸；登陆后把囤兵地从夏威夷转移到西海岸节点，并用同一北美军区服务整个北美战线。

战略区域组合：

| 分类 | 战略区域 |
| --- | --- |
| 夏威夷与太平洋接近路 | `105` 夏威夷海脊、`114` 北太平洋、`115` 东北太平洋、`89` 西美利坚沿海、`171` 西北海岸 |
| 北美东侧与环海 | `54` 东美利坚沿海、`55` 纽芬兰海、`52` 墨西哥湾、`53` 加勒比海、`106` 墨西哥海岸、`107` 西运河区、`170` 佛罗里达海岸、`166` 哈得逊湾 |
| 美国、加拿大、墨西哥与中美洲 | `33` 阿拉斯加、`34` 中美洲、`36` 格陵兰、`117` 美利坚东海岸、`118` 喀斯喀特、`119` 西南美利坚、`120` 中美利坚、`121` 东加拿大、`122` 育空、`123` 跨墨西哥火山带、`197` 新英格兰、`198` 五大湖区、`199` 北落基山脉、`204` 马德雷山脉、`205` 尤卡坦半岛、`211` 墨西哥湾、`212` 曼尼托巴、`213` 滨海诸地、`214` 阿巴拉契亚、`218` 加利福尼亚、`219` 南落基山脉、`220` 拉布拉多与纽芬兰、`221` 萨斯喀彻温、`222` 北加拿大、`233` 魁北克、`234` 安大略地区、`235` 不列颠哥伦比亚 |

触发与释放口径：

- 启动门槛：`JAP_kodoha_major_asian_theaters_basic_missions_completed = yes`、与美国开战、已完成大本营决议“筹备美国本土登陆”并获得 `JAP_us_mainland_invasion_preparation_completed_flag`、夏威夷 `629` 由 ROOT 或附庸完全控制、日本本土未失守。
- 作战支点：初始支点为夏威夷；控制加利福尼亚 `378`、俄勒冈 `385`、华盛顿 `386` 任一州后，西海岸成为新支点。西海岸支点存在时，即使夏威夷后来失守，也继续用西海岸推进北美。
- 完成/放弃：北美洲没有交战敌方控制州，或日本本土失守时，北美军区停止。

兵池与登陆：

- 夏威夷集结使用 `put_unit_buffers order_id = 2604`、`ratio = 0.25`、`states = { 629 }`、`area = JAP_rework_north_america_theater`，并给北美军区 `area_priority = 30`。
- 已完成大本营决议“筹备美国本土登陆”且仍与美国交战时，`JAP_kodoha_north_america_usa_armor_score` 给 `USA` `front_armor_score = 200`，用于把装甲/进攻模板推向美国前线。
- 西海岸登陆只主动抬加利福尼亚 `378` 和俄勒冈 `385`：加利福尼亚 `invasion_unit_request = 80`，俄勒冈 `60`，共享 `naval_invasion_focus = 100` 与 `naval_invasion_dominance_weight = 45`。
- 登陆后 30 天用 `JAP_kodoha_north_america_landing_boost` 与 `JAP_kodoha_north_america_landing_priority` 提供桥头堡推进，`front_unit_request = 35`，`front_control priority = 720`。
- 西海岸囤兵复用 `order_id = 2604` 和 `ratio = 0.25`，同一时间只启用一个节点，优先级为加利福尼亚 `378` > 俄勒冈 `385` > 华盛顿 `386`；`area` 仍为整个北美军区，确保北美全线都能从该囤兵点获得支援。
- 西海岸支点存在后，北美大陆推进使用 `front_unit_request = 45`、`front_control priority = 650`、`balanced`，覆盖整个 `JAP_rework_north_america_theater`。

## 本土防卫与朝鲜止血第一版

实际 area key：`JAP_rework_home_islands_defense` 与 `JAP_rework_korea_theater`，位于 `common/ai_areas/JAP_rework_areas.txt`。前者只含 `154` 日本列岛，后者只含 `186` 朝鲜；都不改原版 area。

日本本土州表固定为 13 州：北海道 `536`、北东北 `533`、南东北 `1019`、甲信越 `534`、北陆 `535`、关东 `282`、东海道 `532`、关西 `531`、四国 `530`、山阳 `529`、山阴 `1020`、北九州 `528`、南九州 `1018`。所有本土危机、撤出和外线释放逻辑必须调用这张显式州表，不用 `surrender_progress` 或 `is_core_of = JAP`。

本土预备队使用 `order_id = 2800` 三层：常态 `ratio = 0.05`，预警 `ratio = 0.15`，危机 `ratio = 0.25`。屯兵关东、东海道、关西、北九州、南九州、北海道，服务 `area = JAP_rework_home_islands_defense`，并保留 `subtract_invasions_from_need = no` 与 `subtract_fronts_from_need = no`，避免常态本土预备被外线直接抵扣。

预警触发分三类：太平洋内环敌情；满洲关键州热河 `610`、辽宁 `716`、大连 `745`、吉林 `328`、黑龙江 `714` 任一敌控；中国战事基本结束后华东沿海上海 `613`、浙江 `596`、江苏 `598`、苏州 `1034`、南京 `1035`、福建 `595` 任一敌控。华东沿海只触发本土预警，不创建华东防守军区。

本土危机只等于日本列岛 13 州任一州敌控。危机时本土 `front_unit_request = 70`、`front_control priority = 900`、`rush_weak`；同时对 `JAP_kodoha_is_home_islands_state = no` 的州降低外线 `front_unit_request = -80` 和 `invasion_unit_request = -120`，把太平洋、北方与其他外线需求压下去。

北方止血只守朝鲜，不守北海道。`JAP_kodoha_northern_korea_delay_buffer` 使用 `order_id = 2810`、`ratio = 0.04`，只驻平安-黄海 `527` 与咸镜 `1028`；朝鲜敌控时 `JAP_kodoha_northern_korea_delay_front` 给 `front_unit_request = 12`、`front_control priority = 690`、`balanced`。本土危机时朝鲜止血停用。

## 第一批候选区域

| area key | 战略区域 | 用途 |
| --- | --- | --- |
| `JAP_kodoha_china_rear_staging` | `143` Eastern China、`144` Western China、`164` South East China、`165` South West China、`245` Shanxi Region、`246` Central China、`146` Himalayas | 中国战后内线与后方集结，不作为主战场高权重 area |
| `JAP_rework_home_islands_defense` | `154` Home Islands | 本土防卫专用 area，只覆盖日本列岛 13 州所在战略区域；用于 `order_id = 2800` 常态/预警/危机预备和危机收复 |
| `JAP_rework_korea_theater` | `186` Korea | 北方止血专用 area，只覆盖朝鲜；用于平安-黄海、咸镜短期拖延，不守北海道 |
| `JAP_rework_northern_east_theater` | `154` Home Islands、`143` Eastern China、`155` Manchuria、`242` Northern Manchuria、`243` Eastern Manchuria、`186` Korea、`148` Russian Far East、`149` Eastern Siberia、`255` Amur、`256` Transbaikal、`257` Northern Far East、`258` Okhotsk、`259` Sakha、`260` Western Sakha、`79` Sea of Japan、`87` Sea of Okhotsk、`88` Bering Sea | 北方东线：北海道/满洲/朝鲜集结，远东、阿穆尔、外贝加尔、东西伯利亚、萨哈和远东北方海域；北海道不参与 access lost；萨哈只补作战半径 |
| `JAP_rework_northern_west_theater` | `145` Central Asia、`144` Western China、`267` Tanscaspia、`268` Ferghana、`269` Samarkand、`270` Syr Darya、`200` Quinghai、`244` Chahar、`245` Shanxi Region、`252` Tien Shan、`152` Central Steppe、`266` Uriankhai、`147` Siberian Region、`151` Western Siberia、`261` Altai、`262` Central Siberia、`14` TransUrals、`138` Ural Region、`263` Eastern Nenetsia、`264` Komi-Nenetsia | 北方西线：新疆、华西、苏联中亚、青海、察哈尔/山西、外蒙古、乌梁海、阿尔泰侧翼和西伯利亚纵深到乌拉尔边界；华西、山西、苏联中亚和阿尔泰只补 area |
| `JAP_kodoha_northern_theater` | 原单体北方区域 | 旧口径；已拆为 `JAP_rework_northern_east_theater` 与 `JAP_rework_northern_west_theater`，不再作为有效 area key |
| `JAP_kodoha_manchuria_korea_staging` | `155` Manchuria、`242` Northern Manchuria、`243` Eastern Manchuria、`186` Korea | 旧候选名；实际落地已并入 `JAP_rework_northern_east_theater` |
| `JAP_kodoha_soviet_far_east_front` | `148` Russian Far East、`149` Eastern Siberia、`256` Transbaikal | 旧候选名；实际落地已并入 `JAP_rework_northern_east_theater` |
| `JAP_kodoha_siberia_deep_front` | `147` Siberian Region、`151` Western Siberia、`262` Central Siberia、`150` Artic Russia | 旧候选名；实际西伯利亚纵深落入 `JAP_rework_northern_west_theater`，且不纳入 `150` 阿尔汉格尔斯克/北极俄国 |
| `JAP_kodoha_central_asia_tibet_front` | `252` Tien Shan、`145` Central Asia、`152` Central Steppe、`162` Afghanistan Area、`289` Southern Afghanistan | 旧候选名；不再作为有效 area key。新疆/外蒙古侧翼仍由 `JAP_rework_northern_west_theater` 处理，阿富汗和阿里方向由 `JAP_rework_south_asia_theater` 承接 |
| `JAP_rework_southeast_asia_theater` | `165` South West China、`248` Guangxi、`249` Yunnan、`142` South East Asia、`228` South Indochina、`229` Siam、`188` Malaya、`292` Shan States、`293` Tenasserim、`294` Rangoon、`295` Mandalay、`72` Straits of Malacca、`73` Gulf of Thailand、`75` South China Sea | 东南亚军区第一版：华南/云南/广西集结，缅甸、印支、暹罗、马来亚、马六甲推进 |
| `JAP_rework_south_asia_theater` | `146` Himalayas、`141` East India、`153` Northern India、`290` Bengal、`31` Indian Area、`231` Coromandel Coast、`253` Vindhyachal、`254` Thar Desert、`296` Gujarat、`190` Pakistan、`291` Baluchistan、`145` Central Asia、`251` Ngari、`162` Afghanistan Area、`289` Southern Afghanistan、`101` Bay of Bengal、`104` Arabian Sea、`230` Cape Comorin、`292` Shan States、`293` Tenasserim、`294` Rangoon、`295` Mandalay | 南亚军区：喜马拉雅边境/勃固集结，清理阶段转印度内部节点；覆盖印度、孟加拉、巴基斯坦、锡兰、法属印度、果阿、阿里/阿富汗接触线和缅甸重合区，并与北方西线重合塔克拉玛干 |
| `JAP_rework_east_indies_australia_theater` | `188` Malaya、`72` Straits of Malacca、`187` Sumatra、`159` Borneo、`158` Sunda Islands、`93` Java Sea、`167` New Guinea、`91` Arafura Sea、`99` Far Eastern Indian Ocean、`193` Northern Australia、`156` Australia、`194` Eastern Australia、`195` Central Australia、`98` Great Australian Bight、`157` New Zealand、`86` Tasman Sea、`81` Coral Sea | 东印度-澳新军区第一版：马六甲/新加坡接替，按枢纽网络登陆荷属东印度、新几内亚、澳大利亚、新西兰，并用本地弹性防备池守已控节点；不覆盖菲律宾-美国殖民地方向 |
| `JAP_kodoha_burma_india_front` | `292` Shan States、`293` Tenasserim、`294` Rangoon、`295` Mandalay、`141` East India、`153` Northern India、`290` Bengal | 旧候选名；实际落地优先使用 `JAP_rework_south_asia_theater`，不再使用有效 province 为 0 的 `189` |
| `JAP_kodoha_malaya_indochina_front` | `142` South East Asia、`228` South Indochina、`229` Siam、`188` Malaya、`73` Gulf of Thailand | 中南半岛、暹罗、马来亚方向 |
| `JAP_kodoha_east_indies_front` | `159` Borneo、`187` Sumatra、`93` Banda Sea、`158` Guinea、`167` New Guinea、`99` Far Eastern Indian Ocean | 旧候选名；实际落地已并入 `JAP_rework_east_indies_australia_theater` |
| `JAP_rework_pacific_theater` | `154` Home Islands、`90` Coast of Japan、`76` East China Sea、`75` South China Sea、`78` Philippine Sea、`160` Philippines、`94` Western Pacific、`84` Bismarck Sea、`97` South West Pacific、`95` Western Pacific 2、`96` North West Pacific、`180` Micronesian Gap、`177` Western North Pacific、`114` North Pacific、`172` South Central Pacific、`105` Eastern Pacific 1 | 太平洋军区第一版：统一覆盖台湾、九州/日本近海、菲律宾、日方岛链、中途、夏威夷和对美岛屿争夺；不纳入黄海 `77` |
| `JAP_kodoha_australia_front` | `156` Australia、`193` Northern Australia、`194` Eastern Australia、`195` Central Australia、`86` Tasman Sea、`91` Arafura Sea | 旧候选名；实际落地已并入 `JAP_rework_east_indies_australia_theater` |

## 分阶段使用计划

### 阶段 1：战后重整

- 激活条件：`JAP_china_war_substantially_ended_flag` 已设置，且日本未进入同盟国/共产国际大战。
- 目标：
  - 使用 `JAP_kodoha_china_rear_staging` 做低比例后方 buffer。
  - 不给中国后方高 `area_priority`，避免吞并后仍把主力锁在内陆。
  - 准备东北、缅甸、华南沿海三个前进集结方向。

### 阶段 2：对共产国际

- 使用 `JAP_rework_northern_east_theater` 处理北海道、满洲/朝鲜前进集结、远东主攻、北海道到符拉迪沃斯托克/哈巴罗夫斯克大陆登陆、外贝加尔方向和萨哈作战半径；东线放弃只看满洲/朝鲜前进支点，不让北海道或萨哈单独维持 `2701`。
- 使用 `JAP_rework_northern_west_theater` 处理外蒙古/乌梁海/新疆侧翼、华西/山西过渡区域、苏联中亚覆盖、阿尔泰作战半径和西伯利亚纵深，当前已落地为 `2702` 兵池、侧翼推进和纵深推进两段；华西、山西、苏联中亚和阿尔泰暂不扩大主动推进口径。
- 满洲关键州敌控时，同时触发本土预警 `order_id = 2800` 升到 `0.15`，并启用朝鲜止血 `order_id = 2810`、`ratio = 0.04`；止血只守平安-黄海与咸镜，不把北海道作为北方止血目标。
- 西伯利亚纵深只在北方东线远东主轴完成，或西线已控制克拉斯诺亚尔斯克/新西伯利亚/鄂木斯克任一桥头堡后启用，避免过早长距离吸兵。
- 常态数值建议：
  - 远东主线当前为 `front_unit_request = 45`，`front_control priority = 560`，`balanced`；符拉迪沃斯托克/哈巴罗夫斯克大陆登陆后 30 天 `priority = 700`。
  - 西线侧翼当前为 `front_unit_request = 20`，`front_control priority = 400`，`balanced`。
  - 西线纵深当前为 `front_unit_request = 15`，`front_control priority = 340`，`balanced`，等条件成熟后才启用。

### 阶段 3：对同盟国亚洲方向

- 南亚使用 `JAP_rework_south_asia_theater`，主战阶段配套喜马拉雅边境/勃固 buffer，清理阶段切到印度内部节点；主战阶段中等需求推进，主目标清完后降级清理缅甸重合区和法属印度/果阿。
- 马来亚/中南半岛使用 `JAP_kodoha_malaya_indochina_front`，配套广州、海南、越南沿海登陆/补给策略。
- 东南亚登陆链第一版为海南到暹罗/马来亚，再由马来亚到勃固/仰光；皇道派登陆点比菜鸟意大利更多，当前普通目标按 `invasion_unit_request = 60` 起步。
- 南亚登陆链第一版以勃固为出发门槛，登陆西孟加拉、孟买、锡兰；锡兰作为独立海岛目标处理，不主动登陆法属印度和果阿。
- 东印度-澳新使用 `JAP_rework_east_indies_australia_theater`，从马六甲-新加坡接替东南亚军区，按枢纽网络登陆并用本地弹性防备池守已控节点，不和印度陆上前线共用同一 area。
- 常态数值建议：
  - 南亚主战 `front_unit_request = 25`，`front_control priority = 500`；清理阶段 `front_unit_request = 10`，`priority = 360`。
  - 马来亚登陆或推进 `invasion_unit_request = 50` 到 `80`，当前第一版普通目标为 `60`；站稳后切 `front_unit_request = 15` 到 `25`。
  - 东印度-澳新主动登陆请求按目标重要度使用 `25` 到 `45`，共享 `naval_invasion_focus = 80`；登陆后 30 天主桥头堡 `priority = 700`，末端小岛低强度巩固；东印度大岛常态 `priority = 440`；澳新大陆 `priority = 480`；残余清理 `priority = 320`；本地防备池与接替集结共用独立 `order_id = 2501`。

### 阶段 4：太平洋与澳大利亚

- 太平洋使用统一 `JAP_rework_pacific_theater`，不再拆成菲律宾近海、中太平洋和夏威夷/美国三个 area。
- 台湾、冲绳、北九州、南九州纳入本军区口径；北九州与南九州作为当前太平洋策略的囤兵处。
- 太平洋主体策略由中国战事基本结束后启用；九州集结与可调用弹性守备共用 `order_id = 2600`、`ratio = 0.10`，两条岛链逐跳登陆并在威克岛/中途岛汇合。
- 本土防卫常态保留 `order_id = 2800`、`ratio = 0.05`；太平洋内环、满洲关键州或中国战后华东沿海敌控时升到 `0.15`，日本列岛 13 州敌控时升到 `0.25` 并释放外线需求。
- 夏威夷登陆晚启用，必须中途岛稳定，且日本内环与菲律宾主节点没有敌情。
- 日本列岛 13 州失控会立即放弃太平洋军区；十四个重要目标全控后完成军区，只保留夏威夷 `ratio = 0.03` 常驻守备。
- 澳大利亚和新西兰已并入 `JAP_rework_east_indies_australia_theater`，只在澳新桥头堡存在后启用大陆推进层。
- 夏威夷与对美远期航线纳入同一太平洋军区，但主动请求仅为 `30`，不作为亚洲主战未稳定时的高权重直冲目标。
- 美国本土登陆另用 `JAP_rework_north_america_theater`：四个亚洲主战区基本完成、对美战争仍在、已完成大本营决议“筹备美国本土登陆”且夏威夷 `629` 完全控制后，夏威夷集结 `order_id = 2604`、`ratio = 0.25`，同时对 `USA` 给 `front_armor_score = 200`；拿下加利福尼亚 `378`、俄勒冈 `385` 或华盛顿 `386` 后，囤兵点转移到西海岸，并由整个北美军区承接后续前线。

## 策略接入原则

- 每个大方向至少拆成三层：准备/集结、发起、巩固。
- 准备层优先 `put_unit_buffers`，发起层用 `front_unit_request` 或 `invasion_unit_request`，巩固层用局部 `front_control`。
- 一个策略块中 area、state、country 条件要一致，不要 `area = JAP_kodoha_burma_india_front` 却用澳大利亚 state 作为 buffer。
- 接替军区的 buffer 可以复用被接替军区的 `order_id`，但只有在双方退出边界明确且不会互相污染时才这样做；当前东印度-澳新已拆出独立 `order_id = 2501`。
- 多线战争不要用一个 `area_priority asia = 100` 解决；应给各战区独立小额 request 和独立 buffer。
- 停用战区时要同时释放 buffer、降低 request，防止旧 area 继续吸兵。
- 本土防卫不要用亚洲大 area，也不要靠投降进度或日本核心判断；只使用 `JAP_rework_home_islands_defense` 和显式 13 州本土 trigger。
- 朝鲜止血是北方预警的短期拖延层，不替代北方东线主体，也不把北海道纳入止血 buffer。

### 军区 `front_control` 节奏调整草案

- 大军区常态推进不宜长期锁定 `execute_order = yes`。后续调整方向是把整军区范围的大范围强制推进改成脉冲式：一段时间高强度推进，一段时间停止强制执行，让前线计划值和组织度有恢复窗口。
- `global.num_days % 60 < 30` 的含义：取全局开局天数除以 `60` 的余数；余数为 `0` 到 `29` 时条件成立，余数为 `30` 到 `59` 时条件不成立。配合 `abort_when_not_enabled = yes` 时，就是每 60 天中前 30 天启用、后 30 天停用，再循环。`60/30` 只是示例比例，实际进攻/休整占比待测试决定。
- `global.num_days` 是全局计时，不是军区专属计时。多个军区如果照抄同一个周期，会在同一天一起冲、一起停；若需要错峰，可给不同军区使用不同周期，或在取模前加入固定偏移量。
- 对华战争不参与普通脉冲/休整规则：在 `NOT = { has_country_flag = JAP_china_war_substantially_ended_flag }` 且仍有中国系敌国时，对华 `front_control` 按各自目标条件持续强推，除步枪不足保险外不主动停。`JAP_kodoha_china_war_cyclic_offensive` 与 `JAP_kodoha_china_war_chongqing_cyclic_offensive` 均应去掉周期判断，改成持续总攻/持续冲击口径；旧 key 保留 `cyclic` 只是历史命名。
- 中国战后大范围军区推进可以先按更保守的 `global.num_days % 60 < 15` 处理：每 60 天只有前 15 天强制推进，其余 45 天不写强制执行，让 AI 自己判断是否继续执行计划。
- 中国战后的非例外小范围微操推进可以用较长的 `global.num_days % 60 < 30`：每 60 天前 30 天给局部 `rush_weak` 或 `rush` + `execute_order = yes` + `manual_attack = yes`，适用于目标较明确、风险较低但仍需要人为帮一把的局部方向。
- 每 60 天的最后 15 天，即 `global.num_days % 60 >= 45`，可用一条通用陆上前线休整策略强制不冲：`ordertype = front`、`execute_order = no`、`execution_type = careful`、`manual_attack = yes`。这条策略只控制陆地前线的 `front_control`，不限制 `front_unit_request`、`invasion_unit_request`、`area_priority` 或 `put_unit_buffers`，避免把调兵和战区兴趣一起关掉。
- 通用休整层主要用于中国战后的普通大范围推进和普通小范围微操推进。若休整层写成全局通用策略，`enable` 应优先限定 `has_country_flag = JAP_china_war_substantially_ended_flag`；若未来需要战争中也启用，则必须通过 `country_trigger` 排除 `is_literally_china = yes`，避免压住对华前线。
- 通用休整层不能覆盖登陆后扩大、小岛屿作战、本土危机收复、缺装保险等拖不得或胜算极高的例外窗口。落地前需要重排 `front_control priority` 梯子：普通常态层最低，普通大范围/小范围脉冲层在其上，通用休整层再高一层，例外强推窗口和危机/缺装保险必须高于通用休整层；对华推进则通过触发隔离保持持续强推，而不是全体抬高到例外档。
- 如果某个例外窗口当前优先级低于通用休整层，优先调整该例外窗口的优先级或触发条件，而不是降低休整层到无法压住普通推进。例外清单应同步写进战争策略参考，避免以后新增普通 `front_control` 时误放到休整层之上。
- 休整段 `execute_order = no` + `manual_attack = yes` 的实际效果需要实测确认：如果 `execute_order = no` 会连带压住 `manual_attack`，则休整段改为只降到 `careful`，或者保留通用休整层但不再期待 AI 做局部 poke。

### 小战役决议控制草案

- 更精细的 `front_control` 不放进永久军区常态层，改由小战役决议启动。决议设置国家 flag 和目标州/邻州 flag，持续 `30`、`45` 或 `60` 天；AI 策略只在这些 flag 存续期间给目标地块 `front_unit_request`、局部 `front_control` 或必要的登陆执行控制。
- 小战役决议适合处理桥头堡扩张、山地/河线突破、终局首都推进、北美西海岸登陆后扩张等明确战役目标；不适合替代东南亚、南亚、北方、太平洋这类常态军区的全部推进逻辑。
- 决议到期后应自动回落到普通军区 AI：删除或过期战役 flag，停止局部高优先级 `front_control`，保留常态 `buffer`、小额 request 和完成/撤出条件。
- 后续可给小战役决议配套临时地块 BUFF：点决议时对目标州或邻近州添加短期 state modifier/dynamic modifier，并用同一批 flag 驱动 AI 冲击。BUFF 应保持局部、短期、可移除，避免把整个军区永久强化。
- 决议、地块 BUFF 和 AI 策略要共用同一套目标州清单，并同步记录在本文件或战争策略参考中；新增目标时同时检查决议可见条件、flag 持续时间、BUFF 移除逻辑、`front_unit_request` 和 `front_control priority` 梯子。

## 落地检查清单

真正创建 AI area 文件时检查：

1. 文件路径是否为 `common/ai_areas/JAP_rework_areas.txt`。
2. 文件编码是否为 UTF-8 无 BOM，CRLF，与现有 `common/ai_areas/` 文件一致。
3. 外层是否只有一个 `areas = { ... }`。
4. area key 是否全部带 `JAP_rework_` 前缀。
5. strategic region ID 是否存在于原版 `map/strategicregions/`。
6. 新策略是否先确认 area key 已创建，再引用 `id =` 或 `area =`。
7. 每个 area 是否服务一个清晰战区，避免跨越印度、苏联远东、澳大利亚这种远距离混合。
8. 接替军区是否应复用被接替军区的 buffer `order_id`，还是拆出独立兵池以保证退出和 debug 释放边界清晰。
9. 本土相关新逻辑是否没有使用 `surrender_progress` 或 `is_core_of = JAP`。
