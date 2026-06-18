
NDefines.NProduction.MAX_CIV_FACTORIES_PER_LINE = 20 				-- 同时建厂最大数.
NDefines.NProduction.DEFAULT_MAX_NAV_FACTORIES_PER_LINE = 100				-- 同时建屏卫舰最大数.
NDefines.NProduction.FLOATING_HARBOR_MAX_NAV_FACTORIES_PER_LINE = 25			-- 同时建浮动港口最大数.
NDefines.NProduction.CONVOY_MAX_NAV_FACTORIES_PER_LINE = 25				-- 同时建运输船最大数.
NDefines.NProduction.CAPITAL_SHIP_MAX_NAV_FACTORIES_PER_LINE = 100				-- 同时建主力舰最大数.
NDefines.NProduction.RAILWAY_GUN_MAX_MIL_FACTORIES_PER_LINE = 25			-- 同时建列车炮最大数.
NDefines.NProduction.MINIMUM_NUMBER_OF_FACTORIES_TAKEN_BY_CONSUMER_GOODS_VALUE = 0   -- 消费品下限
NDefines.NProduction.MINIMUM_NUMBER_OF_FACTORIES_TAKEN_BY_CONSUMER_GOODS_PERCENT = 0  -- 消费品下限
NDefines.NProduction.MIN_FIELD_TO_TRAINING_MANPOWER_RATIO = 1      ----------可以训练部队占总部队的人数  原0.75
NDefines.NProduction.POWERED_FACTORY_SPEED_NAV = 6			--Powered factory speed multiplier.2.5




NDefines.NMilitary.MAX_ARMY_EXPERIENCE = 999	--陆军经验上限
NDefines.NMilitary.MAX_NAVY_EXPERIENCE = 999	--海军经验上限
NDefines.NMilitary.MAX_AIR_EXPERIENCE = 999	--空军经验上限
NDefines.NCountry.BASE_MAX_COMMAND_POWER = 2000					-- base value for maximum command power
NDefines.NCountry.BASE_COMMAND_POWER_GAIN = 2					-- base value for daily command power gain
NDefines.NCountry.ATTACHE_XP_SHARE = 0.5 ---军事顾问获得经验比例原0.15
NDefines.NMilitary.UNIT_LEADER_USE_NONLINEAR_XP_GAIN = false --是否不使用线性经验
NDefines.NMilitary.FIELD_EXPERIENCE_MAX_PER_DAY = 2.5 --每日经验获取上限
NDefines.NMilitary.DEPLOY_TRAINING_MAX_LEVEL = 2                     --银牌训练部署 原1
NDefines.NMilitary.PLAN_MIN_AUTOMATED_EMPTY_POCKET_SIZE = 4       -- 四个格子开始做饺子 原2
NDefines.NMilitary.PLAN_SPREAD_ATTACK_WEIGHT = 5	      -- 集中突击  原12 数值越高就不越不会多次强袭
NDefines.NMilitary.PLAN_PROVINCE_LOW_VP_IMPORTANCE_FRONT = 1    -- 低胜利点重要性 原2
NDefines.NMilitary.PLAN_PROVINCE_MEDIUM_VP_IMPORTANCE_FRONT = 2  --中胜利点重要性 原2.25
NDefines.NMilitary.PLAN_PROVINCE_HIGH_VP_IMPORTANCE_FRONT = 3    -- 高胜利点重要性 原2.75
NDefines.NMilitary.CORPS_COMMANDER_DIVISIONS_CAP = 48 --将军指挥上限
NDefines.NMilitary.FIELD_MARSHAL_DIVISIONS_CAP = 48 --元帅指挥集团军上限
NDefines.NMilitary.DEPLOY_TRAINING_MAX_LEVEL = 2                     --银牌训练部署 原1
NDefines.NProduction.MIN_FIELD_TO_TRAINING_MANPOWER_RATIO = 1    ----------可以训练部队占总部队的人数  原0.75
NDefines.NDeployment.BASE_DEPLOYMENT_TRAINING = 2   --基础部署速度--原来为1，加快训练

NDefines.NCountry.REINFORCEMENT_MANPOWER_CHUNK = 0.3        --[[ 一次补充人力的百分比 ]]--原0.1 与装备补充速度平行，因为装备也是0.3
NDefines.NCountry.REINFORCEMENT_MANPOWER_DELIVERY_SPEED = 10   --[[ 人力补充速度 ]]--原10
NDefines.NPolitics.BASE_POLITICAL_POWER_INCREASE = 3 --每周获得political power 2
NDefines.NDiplomacy.PEACE_SCORE_SCALE_FACTOR = 2 -- 和平会议总分缩放，原版1.35

NDefines.NAir.ACE_EARN_CHANCE_BASE = 0					---王牌产生概率基础值
NDefines.NAir.ACE_EARN_CHANCE_PLANES_MULT = 0   ----王牌产生概率修正值
NDefines.NAir.COMBAT_DAMAGE_SCALE = 5 --数值越高，被击落的飞机越多

NDefines.NBuildings.AIRBASE_CAPACITY_MULT = 600 --每级机场的容量
NDefines.NBuildings.INFRASTRUCTURE_RESOURCE_BONUS = 0.25 --每级基建资源产出原0.2
NDefines.NBuildings.MAX_SHARED_SLOTS = 50 --建筑槽位原25

-- NDefines.NMilitary.LAND_COMBAT_STR_DAMAGE_MODIFIER = 0.045       --黄条伤害系数 0.06 
-- NDefines.NMilitary.LAND_COMBAT_ORG_DAMAGE_MODIFIER = 0.045    ---组织度伤害系数  0.053
-- NDefines.NMilitary.LAND_COMBAT_ORG_DICE_SIZE = 4      ---组织度伤害骰子
-- NDefines.NMilitary.LAND_COMBAT_STR_DICE_SIZE = 2           ---黄条伤害骰子

--mio
NDefines.NIndustrialOrganisation.MAX_FUNDS_FROM_MANUFACTURER_PER_DAY = 500 ---每日最大从产线获取的经费，原100 设置0为没有最大值
NDefines.NIndustrialOrganisation.ASSIGN_DESIGN_TEAM_PP_COST_PER_DAY = 0.01  ---使用军工组织研究每日消耗的政治点数，原版为0.1，设置为0则没有政治点花费
NDefines.NIndustrialOrganisation.FUNDS_FOR_SIZE_UP = 500 --MIO升级后升到下一级要增加基础值 --700
NDefines.NIndustrialOrganisation.FUNDS_FOR_SIZE_UP_LEVEL_FACTOR = 75 --MIO升级后下一级要乘以多少 --100
NDefines.NIndustrialOrganisation.FUNDS_FOR_RESEARCH_COMPLETION_PER_RESEARCH_COST = 1000  --research 的funds奖励 --500
NDefines.NIndustrialOrganisation.FUNDS_FROM_MANUFACTURER_PER_IC_PER_DAY = 0.25 --IC和funds比例 --0.1



--supply
-- 首都补给（）里是原版
NDefines.NSupply.CAPITAL_SUPPLY_CIVILIAN_FACTORIES = 0.6 --（0.3）
NDefines.NSupply.CAPITAL_SUPPLY_MILITARY_FACTORIES = 1.5 --（0.6）
NDefines.NSupply.CAPITAL_SUPPLY_DOCKYARDS = 1.2 --（0.4）
-- 首都补给递减
NDefines.NSupply.CAPITAL_STARTING_PENALTY_PER_PROVINCE = 0.4 --（0.5）
NDefines.NSupply.CAPITAL_ADDED_PENALTY_PER_PROVINCE = 1 --（1.2）
-- 补给中心及递减
NDefines.NSupply.NODE_INITIAL_SUPPLY_FLOW = 3.5 --（2.8）
-- 满级基建减少递减
-- NDefines.NSupply.SUPPLY_FLOW_DROP_REDUCTION_AT_MAX_INFRA = 0.6 --（0.3）
-- 铁路等级
NDefines.NSupply.RAILWAY_BASE_FLOW = 10.0 --（10.0）
NDefines.NSupply.RAILWAY_FLOW_PER_LEVEL = 10.0 --（5.0）
NDefines.NSupply.RAILWAY_FLOW_PENALTY_PER_DAMAGED = 10 --（5.0）
NDefines.NSupply.AI_THEATRE_SUPPLY_CRISIS_LIMIT = 0.4  --如果AI在一个地区补给数值低于0.5会试图逃跑
NDefines.NSupply.AI_FRONT_DIVISIONS_PER_SUPPLY_POINT = 0.4 -- How many divisions should the AI consider it can supply per available supply point(1)



--ai
NDefines.NAI.NAVAL_DOCKYARDS_SHIP_FACTOR = 5	   -- 逼着AI造船  原1.5
NDefines.NAI.REFIT_SHIP_PERCENTAGE_OF_FORCES = 0 -- AI改装船的百分比，原0.1
NDefines.NAI.START_TRAINING_EQUIPMENT_LEVEL = 0.65               --凑齐60%装备开始训练 原0.4
NDefines.NAI.PRODUCTION_EQUIPMENT_SURPLUS_FACTOR = 0.25    -- 装备基础溢出比例，多了删产线原0.8
NDefines.NAI.FAILED_INVASION_AVOID_DURATION = 1               -- 如果同一块地入侵失败那么AI会等60天后再入侵这块地 原60
NDefines.NAI.CANCEL_COMBAT_DISADVANTAGE_RATIO = 1.3            -- 如果敌方在（正常）战斗中对我方的优势比大于 <值>，则允许取消攻击 原1.5
NDefines.NAI.CANCEL_COMBAT_MIN_DURATION_HOURS = 24            -- 只有在至少 <value> 小时后才允许取消（正常）战斗 原48
NDefines.NAI.CANCEL_INVASION_COMBAT_DISADVANTAGE_RATIO = 2.5    -- 如果入侵战斗中敌方对我方的优势比大于 <value>，则允许取消攻击 原3.5
NDefines.NAI.WANTED_CARRIER_PLANES_PER_CARRIER_CAPACITY_FACTOR = 0.75 ---1.5  AI现役航母甲板与舰载机需求比例
NDefines.NAI.WANTED_CARRIER_PLANES_PER_CARRIER_CAPACITY_IN_PRODUCTION_FACTOR = 0.5 ---1   AI在建航母甲板与舰载机需求比例
NDefines.NAI.AIR_AI_ENEMY_PROV_RATIO_FOR_COMBAT_REGION = 0.02 -- 敌方控制空域内超过2%省份即视为交战区域，AI会往此处派飞机 原0.15

NDefines.NAI.AREA_DEFENSE_SETTING_VP = false       ------ai是否默认（是默认情况）防守胜利点
NDefines.NAI.AREA_DEFENSE_SETTING_PORTS = true          -------港口
NDefines.NAI.AREA_DEFENSE_SETTING_AIRBASES = false      ----------空军基地
NDefines.NAI.AREA_DEFENSE_SETTING_FORTS = true         ----要塞
NDefines.NAI.AREA_DEFENSE_SETTING_COASTLINES = true	 --------海岸线
NDefines.NAI.AREA_DEFENSE_SETTING_RAILWAYS = false         -------铁路

--AI部署师修正
NDefines.NAI.WANTED_UNITS_INDUSTRY_FACTOR = 10                       -- ai想部署多少兵取决于ai有多少工厂原1.6
NDefines.NAI.WANTED_UNITS_THREAT_BASE = 1                             -- 根据世界紧张度的动态修正原0.7
NDefines.NAI.WANTED_UNITS_THREAT_MAX = 10                             -- 根据世界紧张度的动态修正（1~10）原6.0
NDefines.NAI.WANTED_UNITS_WAR_THREAT_FACTOR = 1.5                     -- 如果我们的头上有红色的东西（造宣战）原1.15
NDefines.NAI.WANTED_UNITS_DANGEROUS_NEIGHBOR_FACTOR = 2               -- 如果我们有个危险的邻居（造成紧张度高的国家）原1.15
NDefines.NAI.WANTED_UNITS_MANPOWER_DIVISOR = 10000                    -- 如果我们有多少人力我们需要一个师
NDefines.NAI.WANTED_UNITS_MAX_WANTED_CAP = 1000                      --最大能部署多少部队  原500

--AIequipment
NDefines.NAI.DESIRE_USE_XP_TO_UPGRADE_LAND_EQUIPMENT = 100   ---1  更新设计积累系数
NDefines.NAI.DESIRE_USE_XP_TO_UPGRADE_NAVAL_EQUIPMENT = 100   ---1
NDefines.NAI.DESIRE_USE_XP_TO_UPGRADE_AIR_EQUIPMENT = 100     ---1
NDefines.NAI.EQUIPMENT_DESIGN_MAX_FAILED_DAYS = 5 ---60 更新失败最大天数
NDefines.NAI.DEFAULT_LEGACY_VARIANT_CREATION_XP_CUTOFF_LAND = 5
NDefines.NAI.DEFAULT_MODULE_VARIANT_CREATION_XP_CUTOFF_LAND = 5
NDefines.NAI.DEFAULT_MODULE_VARIANT_CREATION_XP_CUTOFF_NAVY = 5
NDefines.NAI.DEFAULT_MODULE_VARIANT_CREATION_XP_CUTOFF_AIR = 1
NDefines.NAI.DEFAULT_LEGACY_VARIANT_CREATION_XP_CUTOFF_AIR = 1
NDefines.NAI.DEFAULT_LEGACY_VARIANT_CREATION_XP_CUTOFF_LAND = 10
NDefines.NAI.DEFAULT_MODULE_VARIANT_CREATION_XP_CUTOFF_LAND = 20
NDefines.NAI.DEFAULT_MODULE_VARIANT_CREATION_XP_CUTOFF_NAVY = 10

-- ----ai海军
-- NDefines.NAI.ENEMY_NAVY_STRENGTH_DONT_BOTHER = 10  --敌方海军能力强于我方1.5倍则禁止登陆 5
-- NDefines.NAI.SHIPS_PRODUCTION_BASE_COST = 20000  --AI标准化海军造价，原1万，此值防止AI抽风捏低造价垃圾船
NDefines.NAI.NAVY_PREFERED_MAX_SIZE = 108  --AI尝试将舰队规模合并到这个规模，原25，但此值是一个软指标，AI可能不会强制执行
NDefines.NAI.DOCKYARDS_PER_NAVAL_DESIRE_EFFECT = 10  --AI对舰船的关注程度，原-10
-- NDefines.NAI.PRODUCTION_MAX_PROGRESS_TO_SWITCH_NAVAL = 0   --如果进度高于此数值，AI不会删除产线已经在建造的船 原0.1
NDefines.NAI.PRODUCTION_WAIT_TO_FINISH_IF_EXPENSIVE = 0 --如果生产的船造价较高，AI不会删除此进度的船  

NDefines.NAI.CARRIER_TASKFORCE_MAX_CARRIER_COUNT = 6 --AI舰队设定的最佳航母数量 
NDefines.NAI.CAPITAL_TASKFORCE_MAX_CAPITAL_COUNT = 14  --AI舰队设定的最佳主力舰数量 原12
NDefines.NAI.SCREEN_TASKFORCE_MAX_SHIP_COUNT = 120 --AI舰队设定的最佳屏位舰数量 原12
NDefines.NAI.SUB_TASKFORCE_MAX_SHIP_COUNT = 50  --AI舰队设定的最佳潜艇数量 原16
NDefines.NAI.SCREENS_TO_CAPITAL_RATIO = 10 --AI舰队屏位舰比上主力舰的比例原4

NDefines.NAI.REPAIR_TASKFORCE_SIZE = 150  --AI修船最大船坞数量  原4 （TM的怪不得AI分配修船数量那么少，老是修不起船）
NDefines.NAI.REGION_THREAT_PER_SUNK_CONVOY = 1000
NDefines.NAI.REGION_THREAT_LEVEL_TO_AVOID_REGION = 1000 * 1000
NDefines.NAI.REGION_THREAT_LEVEL_TO_BLOCK_REGION = 1000 * 1000

--ai trainning
NDefines.NAI.DEPLOY_MIN_TRAINING_SURRENDER_FACTOR = 1 -- 当投降进度高于0时，AI在战时部署部队所需的训练百分比（1.0 = 100%）。
NDefines.NAI.DEPLOY_MIN_EQUIPMENT_SURRENDER_FACTOR = 1 -- 当投降进度高于0时，AI在战时部署部队所需的装备百分比（1.0 = 100%）。
NDefines.NAI.DEPLOY_MIN_TRAINING_PEACE_FACTOR = 1 -- AI在和平时期部署部队所需的训练百分比（1.0 = 100%）。
NDefines.NAI.DEPLOY_MIN_EQUIPMENT_PEACE_FACTOR = 1 -- AI在和平时期部署部队所需的装备百分比（1.0 = 100%）。
NDefines.NAI.DEPLOY_MIN_TRAINING_WAR_FACTOR = 1 -- AI在战时部署部队所需的训练百分比（1.0 = 100%）。
NDefines.NAI.DEPLOY_MIN_EQUIPMENT_WAR_FACTOR = 1 -- AI战时部署部队所需的装备百分比（1.0 = 100%）。
NDefines.NAI.DEPLOY_MIN_EQUIPMENT_CAP_DEPLOY_FACTOR = 1 -- 装备不足训练被卡住，但是我们的装备量高于这个85%数值，则无论如何都要部署部队


NDefines.NAI.ARMY_LEADER_ASSIGN_DONT_STEAL_OTHER_FACTOR = 0.01
NDefines.NMilitary.UNIT_LEADER_MODIFIER_COOLDOWN_ON_GROUP_CHANGE = 0



--land AI
NDefines.NAI.LENDLEASE_FRACTION_OF_PRODUCTION = 0.25 --0.5
NDefines.NAI.LENDLEASE_FRACTION_OF_STOCKPILE = 0.125 --0.25
NDefines.NAI.NUM_SILOS_PER_CIVILIAN_FACTORIES = 0.0					-- ai will try to build a silo per this ratio of civ factories
NDefines.NAI.NUM_SILOS_PER_MILITARY_FACTORIES = 0.0					-- ai will try to build a silo per this ratio of mil factories
NDefines.NAI.NUM_SILOS_PER_DOCKYARDS = 0.0	
NDefines.NAI.MIN_AI_UNITS_PER_TILE_FOR_STANDARD_COHESION = 2.0	-- How many units should we have for each tile along a front in order to switch to standard cohesion (less moving around)
NDefines.NAI.MIN_FRONT_SIZE_TO_CONSIDER_STANDARD_COHESION = 2000	-- How long should fronts be before we consider switching to standard cohesion (under this, standard cohesion fronts will switch back to relaxed)
NDefines.NAI.FALLBACK_LOSING_FACTOR = 0.0 	


---AI research 
NDefines.NAI.RESEARCH_AHEAD_BONUS_FACTOR = 10.0 --7  超前
NDefines.NAI.RESEARCH_AHEAD_OF_TIME_FACTOR = 1.5 --4 超前惩罚
NDefines.NAI.RESEARCH_BONUS_FACTOR = 2 --5 
NDefines.NAI.MAX_AHEAD_RESEARCH_PENALTY = 4 --3 ai考虑最大超前年份

-- AI修船
	NDefines.NAI.DeSHIP_STR_RATIO_PUT_ON_REPAIRS = 0.5   ---(0.8)					-- if ships are damaged below this ratio, they are put for repairs
	NDefines.NAI.SHIP_STR_RATIO_EXIT_REPAIRS = 1	   ---(1)				-- the ships will leave repairs if they are >= this ratio of total str
	NDefines.NAI.REPAIR_TASKFORCE_SIZE = 10        ----4,-- repair taskforce sizes are limited to this many ships

--coal
NDefines.NProduction.RESOURCE_TO_ENERGY_COEFFICIENT = 10 --每个煤生产多少能量 9
NDefines.NProduction.BASE_COUNTRY_ENERGY_PRODUCTION = 10 --能源系数越大煤产能源越多 10
NDefines.NProduction.ENERGY_SCALING_COST_BY_FACTORY_COUNT = 0 --工厂越多耗煤系数越大,越大厂越多会变成指数 0.0225
NDefines.NProduction.BASE_ENERGY_COST = 2 --每个工厂消耗的煤 0.25

--doctrines
NDefines.NDoctrines.DEFAULT_REWARD_MASTERY = 75 --精通解锁需要的精通点，100
NDefines.NDoctrines.TRAINING_MASTERY_GAIN_FACTOR = 0.5 --训练获得精通点 0.1
NDefines.NDoctrines.MAX_MONTHLY_MASTERY_GAIN = 300 --每个月最多获得的精通点 50
NDefines.NDoctrines.MIN_MASTERY_GAIN_PER_DAY = 0.5 --每天最少拿0.5精通点 0
NDefines.NDoctrines.NAVAL_MISSION_MASTERY_GAIN_FACTORS = {  -- 海军精通点
		0.0, -- HOLD
		0.5, -- PATROL
		0.05, -- STRIKE FORCE
		0.5, -- CONVOY RAIDING
		0.5, -- CONVOY ESCORT
		0.2, -- MINES PLANTING
		0.2, -- MINES SWEEPING
		0.0, -- TRAIN # NOT USED - handled by TRAINING_MASTERY_GAIN_FACTOR
		0.0, -- RESERVE_FLEET
		0.3, -- NAVAL_INVASION_SUPPORT
	}
NDefines.NNavy.AGGRESSION_LEVEL_BY_MISSION_WEAKER = { -- the aggression level per mission when the AI has a weaker navy than its opponent
		---- values correspond to the indexes of the AGGRESSION_SETTINGS_VALUES. 0 = do not engage, 1 = low, 2 = medium, etc. 
		---- If set to (-1), will use the hardcoded behavior (low if navy is generally weaker than opponent, medium if stronger)
		-1, -- HOLD
		0, -- PATROL
		4, -- STRIKE FORCE
		2, -- CONVOY RAIDING
		1, -- CONVOY ESCORT
		-1, -- MINES PLANTING
		-1, -- MINES SWEEPING
		-1, -- TRAINING
		-1, -- RESERVE_FLEET
		2, -- NAVAL_INVASION_SUPPORT
	}
NDefines.NNavy.AGGRESSION_LEVEL_BY_MISSION_STRONGER_OR_EQUAL = { -- the aggression level per mission when the AI has a stronger navy than its opponent
		---- values correspond to the indexes of the AGGRESSION_SETTINGS_VALUES. 0 = do not engage, 1 = low, 2 = medium, etc. 
		---- If set to (-1), will use the hardcoded behavior (low if navy is generally weaker than opponent, medium if stronger)
		-1, -- HOLD
		1, -- PATROL
		4, -- STRIKE FORCE
		2, -- CONVOY RAIDING
		2, -- CONVOY ESCORT
		-1, -- MINES PLANTING
		-1, -- MINES SWEEPING
		-1, -- TRAINING
		-1, -- RESERVE_FLEET
		3, -- NAVAL_INVASION_SUPPORT
	}
NDefines.NBuildings.NAVALBASE_REPAIR_MULT = 2		-- (0.05)Each level of navalbase building repairs X strength and can repair as many ships as its level
-- REPAIR_AND_RETURN_PRIO_LOW = 0.45,								-- % of total Strength. When below, navy will go to home base to repair.
-- 	REPAIR_AND_RETURN_PRIO_MEDIUM = 0.65,							-- % of total Strength. When below, navy will go to home base to repair.
-- 	REPAIR_AND_RETURN_PRIO_HIGH = 0.90,								-- % of total Strength. When below, navy will go to home base to repair.
NDefines.NNavy.REPAIR_AND_RETURN_PRIO_LOW_COMBAT = 0.7 -- 战斗中低维修优先级回港血线 原0.9
NDefines.NNavy.REPAIR_AND_RETURN_PRIO_MEDIUM_COMBAT = 0.5 -- 战斗中中维修优先级回港血线 原0.6
NDefines.NNavy.REPAIR_AND_RETURN_PRIO_HIGH_COMBAT = 0.3 -- 战斗中高维修优先级回港血线 原0.4
-- 	REPAIR_AND_RETURN_AMOUNT_SHIPS_LOW = 0.2,						-- % of total damaged ships, that will be sent for repair-and-return in one call.
-- 	REPAIR_AND_RETURN_AMOUNT_SHIPS_MEDIUM = 0.2,					-- % of total damaged ships, that will be sent for repair-and-return in one call.
-- 	REPAIR_AND_RETURN_AMOUNT_SHIPS_HIGH = 0.2,						-- % of total damaged ships, that will be sent for repair-and-return in one call.
-- 	REPAIR_AND_RETURN_UNIT_DYING_STR = 0.2,							-- Str below this point is considering a single ship "dying", and a high priority to se
-- REPAIR_SPLIT_TASKFORCE_SIZE = 5,								-- if a country does not have empty naval naval bases for repairs, it will split ships with this sizes and distribute them around
-- 	NAVY_REPAIR_BASE_SEARCH_SCORE_PER_SHIP_WAITING_EXTRA_SHIP = 5,  -- if a naval base has more ships than it can repair, it will get penalties
-- 	NAVY_REPAIR_BASE_SEARCH_SCORE_PER_SLOT = 1.0,					-- while searching for a naval base for repairs, the bases gets a bonus to their scores per empty slot they have
-- 	NAVY_REPAIR_BASE_SEARCH_BOOST_FOR_SAME_COUNTRY = 5,				-- while searching for a naval base for repairs, your own bases gets a bonus
-- 	NAVY_REPAIR_BASE_PRIORITY_THRESHOLD_LOW = 2,					-- bases with a level above this value will be set to low prio	(bases between these levels will get medium prio)
-- 	NAVY_REPAIR_BASE_PRIORITY_THRESHOLD_HIGH = 7,					-- bases with a level above this value will be set to high prio (bases between these levels will get medium prio)
-- MIN_REPAIR_FOR_JOINING_COMBATS = { -- strikeforces/patrol forces will not join combats if they are not repaired enough
-- 		0.0,	-- do not repair
-- 		0.5,	-- low
-- 		0.7,	-- medium
-- 		0.9,	-- high
-- 	}
-- NDefines.NNavy.
	NDefines.NNavy.REPAIR_SPLIT_TASKFORCE_SIZE = 5								-- if a country does not have empty naval naval bases for repairs, it will split ships with this sizes and distribute them around
	NDefines.NNavy.NAVY_REPAIR_BASE_SEARCH_SCORE_PER_SHIP_WAITING_EXTRA_SHIP = 10  --5 if a naval base has more ships than it can repair, it will get penalties
	NDefines.NNavy.NAVY_REPAIR_BASE_SEARCH_SCORE_PER_SLOT = 10				--1 1while searching for a naval base for repairs, the bases gets a bonus to their scores per empty slot they have
	NDefines.NNavy.NAVY_REPAIR_BASE_SEARCH_BOOST_FOR_SAME_COUNTRY = 5				-- while searching for a naval base for repairs, your own bases gets a bonus
	NDefines.NNavy.NAVY_REPAIR_BASE_PRIORITY_THRESHOLD_LOW = 5 --(2)				-- bases with a level above this value will be set to low prio	(bases between these levels will get medium prio)
	NDefines.NNavy.NAVY_REPAIR_BASE_PRIORITY_THRESHOLD_HIGH = 8				--(7)	-- bases with a level above this value will be set to high prio (bases between these levels will get medium prio)


