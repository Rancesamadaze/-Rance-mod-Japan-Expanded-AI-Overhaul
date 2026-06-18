


##狠狠登陆

JAP_rework_cm_mil_1 = {
	allowed = {
		tag = JAP
	}
	enable = {
		has_completed_focus = JAP_the_lecture_group_ascendant
	}
	abort = {
		always = no
	}
	ai_strategy = {
		type = naval_invasion_focus
		value = 50
	}
}
##日共登陆朝鲜
JAP_rework_cm_mil_2 = {
	allowed = {
		tag = JAP
	}
	enable = {
		has_completed_focus = JAP_reclaim_lost_territories
		525 = {
			is_controlled_by_ROOT_or_ally = no
		}
	}
	abort = {
		525 = {
			is_controlled_by_ROOT_or_ally = yes
		}
	}
	ai_strategy = {
		type = antagonize
		id = KOR
		value = 50
	}
	ai_strategy = {
		type = invasion_unit_request
		
		state = 1030
		value = 50
	}
	# ai_strategy = {
	# 	type = invasion_unit_request
	# 	strategic_region = 186
	# 	value = 10
	# }
	ai_strategy = {
		type = front_unit_request
		tag = KOR
		value = 50
	}
	ai_strategy = {
	type = naval_invasion_dominance_weight
	value = 30
	}
	ai_strategy = {
		type = front_control
		ratio = 0
		ordertype = invasion
		execution_type = rush
		execute_order = yes
	}
	
}
#备战满洲
JAP_rework_cm_mil_3 = {
	allowed = {
		tag = JAP
	}
	enable = {
		has_government = communism
		527 = {
			is_controlled_by_ROOT_or_ally = yes

		}
		1028 = {
			is_controlled_by_ROOT_or_ally = yes
		}
		has_completed_focus = JAP_reclaim_lost_territories
		MAN = {
			is_JAP_or_ally_of_JAP = no
		}
	}
	abort = {
		has_war_with = MAN
	}
	ai_strategy = {
		type = prepare_for_war
		id = MAN
		value = 200
	}
}
#击溃关东军
JAP_rework_cm_mil_4 = {
	allowed = {
		tag = JAP
	}
	enable = {
		has_completed_focus = JAP_conquer_the_army_remnants
		has_government = communism
	}
	abort = {
		MAN = {
			exists = no
		}
	}
	ai_strategy = {
		type = antagonize
		id = MAN
		value = 100
	}
	ai_strategy = {
		type = conquer
		id = MAN
		value = 100
	}
	ai_strategy = {
		type = front_control
		state = 328
		tag = MAN
		ratio = 0
		execution_type = rush
		execute_order = yes
		ordertype = front

	}
	ai_strategy = {
		type = front_unit_request
		strategic_region = 243
		tag = MAN
		value = 500
	}
}
#登陆上海

JAP_rework_cm_mil_5 = {
	allowed = {
		tag = JAP
	}
	enable = {
		has_government = communism
		has_completed_focus = JAP_put_an_end_to_chinese_feudalism
		has_war_with = CHI
		OR = {
			597 = {
				state_is_fully_controlled_by_ROOT_or_subject = no
			}
			1038 = {
				state_is_fully_controlled_by_ROOT_or_subject = no
			}
		}

		613 = {
			state_is_fully_controlled_by_ROOT_or_subject = no
		}
	}
	abort_when_not_enabled = yes
	ai_strategy = {
		type = invasion_unit_request
		state = 613
		value = 100
	}
	# ai_strategy = {
	# 	type = front_control
	# 	state = 1035
	# 	strategic_region = 247
	# 	priority = 200
	# 	ratio = 0.25
	# 	ordertype = invasion
	# 	execution_type = rush
	# 	execute_order = yes
	# }
}
#解放中国
JAP_rework_cm_mil_6 = {
	allowed = {
		tag = JAP
	}
	enable = {
		has_government = communism
		has_completed_focus = JAP_put_an_end_to_chinese_feudalism

	}
	abort = {
		NOT = {
			country_exists = CHI
		}
		
	}
	ai_strategy = {
		type = antagonize
		id = CHI
		value = 100
	}
	ai_strategy = {
		type = conquer
		id = CHI
		value = 100
	}
	ai_strategy = {
		type = front_unit_request
		tag = CHI
		value = 150
	}
	ai_strategy = {
		type = garrison
		value = -9999
	}
	ai_strategy = {
		type = front_control
		id = CHI
		ratio = 0
		execution_type = rush
		execute_order = yes
	}
	ai_strategy = {
		type = force_defend_ally_borders
		id = PRC
		value = 200
	}
}
##讲座派
#解放战争前区域优先级
#AI区域重心
# JAP_l_area_priority_early = {
# 	allowed = {
# 		original_tag = JAP
# 	}
# 	enable = {
# 		has_completed_focus = JAP_the_lecture_group_ascendant
# 		NOT = {
# 			has_completed_focus = JAP_the_pacific_union_of_soviet_socialist_republics
# 		}
# 	}
# 	abort_when_not_enabled = yes

# 	ai_strategy = {
# 		type = area_priority
# 		id = asia
# 		value = 100
# 	}
# }
# ##讲座派太平洋战争前期区域控制
# JAP_l_area_priority_2 = {
# 	allowed = {
# 		tag = JAP
# 	}
# 	enable = {
# 		has_completed_focus = JAP_the_pacific_union_of_soviet_socialist_republics
# 	}
# 	abort = {
# 		has_completed_focus = JAP_a_red_dawn_over_asia
# 	}
# 	ai_strategy = {
# 		type = area_priority
# 		id = asia
# 		value = 80
# 	}
# 	ai_strategy = {
# 		type = area_priority
# 		id = pacific
# 		value = 120
# 	}
# 	ai_strategy = {
# 		type = area_priority
# 		id = oceania
# 		value = 80
# 	}
# 	ai_strategy = {
# 		type = area_priority
# 		id = middle_east
# 		value = 50
# 	}
# 	ai_strategy = {
# 		type = area_priority
# 		id = suez
# 		value = 50
# 	}
# 	ai_strategy = {
# 		type = area_priority
# 		id = south_america
# 		value = 20
# 	}
# }
# ##讲座派后期
# JAP_l_area_priority_3 = {
# 	allowed = {
# 		tag = JAP
# 	}
# 	enable = {
# 		has_completed_focus = JAP_a_red_dawn_over_asia
# 	}
# 	abort = {
# 		always = no
# 	}
# 	ai_strategy = {
# 		type = garrison
# 		value = -1000
# 	}
# 	ai_strategy = {
# 		type = area_priority
# 		id = europe
# 		value = 100
# 	}
# 	ai_strategy = {
# 		type = area_priority
# 		id = asia
# 		value = 30
# 	}
# 	ai_strategy = {
# 		type = area_priority
# 		id = pacific
# 		value = 30
# 	}
# 	ai_strategy = {
# 		type = area_priority
# 		id = north_america
# 		value = 100
# 	}
# 	ai_strategy = {
# 		type = area_priority
# 		id = south_america
# 		value = 50
# 	}
# 	ai_strategy = {
# 		type = area_priority
# 		id = italy
# 		value = 50
# 	}
# 	ai_strategy = {
# 		type = area_priority
# 		id = uk
# 		value = 50
# 	}
# 	ai_strategy = {
# 		type = invade
# 		id = ENG
# 		value = 100
# 	}
# 	ai_strategy = {
# 		type = invade
# 		id = ITA
# 		value = 100
# 	}
# 	ai_strategy = {
# 		type = invade
# 		id = USA
# 		value = 100
# 	}
# }

##讲座派区域倾向重置开始###################################################
#基础战略倾向
JAP_c_area_priority_default = {
	allowed = {
		tag = JAP
	}
	enable = {
		has_government = communism
	}
	abort_when_not_enabled = yes
	ai_strategy = {
		type = area_priority
		id = asia
		value = 75
	}
	ai_strategy = {
		type = area_priority
		id = oceania
		value = 30
	}
	ai_strategy = {
		type = area_priority
		id = middle_east
		value = 10
	}
	ai_strategy = {
		type = area_priority
		id = europe
		value = 10
	}
	ai_strategy = {
		type = area_priority
		id = africa
		value = -20
	}
	ai_strategy = {
		type = area_priority
		id = north_africa
		value = 40
	}
	ai_strategy = {
		type = area_priority
		id = south_america
		value = 10
	}
	ai_strategy = {
		type = area_priority
		id = north_america
		value = 10
	}
}
#天命三城没有被控制时加大亚洲权重
JAP_c_area_priority_china = {
	allowed = {
		tag = JAP
	}
	enable = {
		has_government = communism
		OR = {
		1035 = {
			is_controlled_by_ROOT_or_ally = no
		}
		592 = {
			is_controlled_by_ROOT_or_ally = no
		}
		608 = {
			is_controlled_by_ROOT_or_ally = no
		}
		}
		
	}
	abort = {
		1035 = {
			is_controlled_by_ROOT_or_ally = yes
		}
		592 = {
			is_controlled_by_ROOT_or_ally = yes
		}
		608 = {
			is_controlled_by_ROOT_or_ally = yes
		}
	}
	ai_strategy = {
		type = area_priority
		id = asia
		value = 50
	}
}
# 当日本本土核心省份被敌方控制时，极大提升亚洲权重以优先收复失地
JAP_c_area_priority_defend_home = {
    allowed = {
        tag = JAP
    }
    enable = {
        has_government = communism
        any_core_state = {
            JAP_is_home_islands_state = yes
            state_is_fully_controlled_by_ROOT_or_subject = no
        }
    }
    abort_when_not_enabled = yes
    ai_strategy = {
        type = area_priority
        id = home_islands
        value = 100
    }
}
# 当控制了亚洲关键节点后，降低对亚洲的战略权重，使AI转向全球扩张
JAP_c_area_priority_asia_secured = {
    allowed = {
        tag = JAP
    }
    enable = {
        has_government = communism
        282 = { is_controlled_by_ROOT_or_ally = yes }
        613 = { is_controlled_by_ROOT_or_ally = yes }
        1021 = { is_controlled_by_ROOT_or_ally = yes }
        995 = { is_controlled_by_ROOT_or_ally = yes }
        524 = { is_controlled_by_ROOT_or_ally = yes }
        629 = { is_controlled_by_ROOT_or_ally = yes }
        328 = { is_controlled_by_ROOT_or_ally = yes }
        327 = { is_controlled_by_ROOT_or_ally = yes }
        289 = { is_controlled_by_ROOT_or_ally = yes }
    }
    abort_when_not_enabled = yes
    ai_strategy = {
        type = area_priority
        id = asia
        value = -60
    }
}
# 中东防御倾向：控制关键枢纽后增加中东权重
JAP_c_area_priority_middle_east_defense = {
    allowed = {
        tag = JAP
    }
    enable = {
        has_government = communism
        OR = {
            49 = { is_controlled_by_ROOT_or_ally = yes }  # 安卡拉
            554 = { is_controlled_by_ROOT_or_ally = yes } # 大马士革
            291 = { is_controlled_by_ROOT_or_ally = yes } # 巴格达
            266 = { is_controlled_by_ROOT_or_ally = yes } # 德黑兰
        }
    }
    abort_when_not_enabled = yes
    ai_strategy = {
        type = area_priority
        id = middle_east
        value = 40
    }
}
# 中东安全倾向：全面控制关键枢纽及周边重镇后降低权重
JAP_c_area_priority_middle_east_secured = {
    allowed = {
        tag = JAP
    }
    enable = {
        has_government = communism
        # 必须全部控制以下省份
        49 = { is_controlled_by_ROOT_or_ally = yes }   # 安卡拉
        554 = { is_controlled_by_ROOT_or_ally = yes }  # 大马士革
        291 = { is_controlled_by_ROOT_or_ally = yes }  # 巴格达
        266 = { is_controlled_by_ROOT_or_ally = yes }  # 德黑兰
        907 = { is_controlled_by_ROOT_or_ally = yes }  # 开罗
        48 = { is_controlled_by_ROOT_or_ally = yes }   # 索非亚
        341 = { is_controlled_by_ROOT_or_ally = yes }  # 埃迪尔内 (埃尔迪内)
    }
    abort_when_not_enabled = yes
    ai_strategy = {
        type = area_priority
        id = middle_east
        value = -40
    }
}
# 苏伊士推进倾向：在利凡特地区拥有据点但尚未夺取运河区时，加大对苏伊士区域的关注
JAP_c_area_priority_suez_push = {
    allowed = {
        tag = JAP
    }
    enable = {
        has_government = communism
        # 1. 已经在中东门户站稳脚跟（巴勒斯坦或大马士革任一被控制）
        OR = {
            454 = { is_controlled_by_ROOT_or_ally = yes } # 巴勒斯坦
            554 = { is_controlled_by_ROOT_or_ally = yes } # 大马士革
        }
        # 2. 运河区及周边关键支点尚未落入我方或盟友之手
        446 = { is_controlled_by_ROOT_or_ally = no } # 苏伊士
        447 = { is_controlled_by_ROOT_or_ally = no } # 亚历山大
        907 = { is_controlled_by_ROOT_or_ally = no } # 开罗
    }
    abort_when_not_enabled = yes
    ai_strategy = {
        type = area_priority
        id = suez
        value = 30
    }
}
# 进军欧洲倾向：控制安卡拉与开罗后，将战略重心转向欧洲
JAP_c_area_priority_europe_push = {
    allowed = {
        tag = JAP
    }
    enable = {
        has_government = communism
        # 必须同时控制欧非门户
        49 = { is_controlled_by_ROOT_or_ally = yes }  # 安卡拉
        907 = { is_controlled_by_ROOT_or_ally = yes } # 开罗
    }
    abort_when_not_enabled = yes
    ai_strategy = {
        type = area_priority
        id = europe
        value = 40
    }
}
# 苏联援助倾向：当苏联重要省份失守且莫斯科/斯大林格勒尚存时，增加欧洲权重
JAP_c_area_priority_save_soviet = {
    allowed = {
        tag = JAP
    }
    enable = {
        has_government = communism
        is_in_faction_with = SOV
        # 只要以下任一省份不在我方或盟友手中，就启动倾向
        OR = {
            195 = { is_controlled_by_ROOT_or_ally = no } # 列宁格勒
            242 = { is_controlled_by_ROOT_or_ally = no } # 斯摩棱斯克
            227 = { is_controlled_by_ROOT_or_ally = no } # 斯大林诺
        }
    }
    # 退出条件：当目标达成，或苏联彻底绝望（莫斯科和斯大林格勒双失）
    abort = {
        OR = {
            # 成功收复：列宁格勒、斯摩棱斯克、斯大林诺全部回到我方或盟友手中
            AND = {
                195 = { is_controlled_by_ROOT_or_ally = yes } # 列宁格勒
                242 = { is_controlled_by_ROOT_or_ally = yes } # 斯摩棱斯克
                227 = { is_controlled_by_ROOT_or_ally = yes } # 斯大林诺
            }
            # 绝望时刻：莫斯科和斯大林格勒均已陷落
            AND = {
                219 = { is_controlled_by_ROOT_or_ally = no } # 莫斯科
                217 = { is_controlled_by_ROOT_or_ally = no } # 斯大林格勒
            }
            # 阵营变动
            NOT = { is_in_faction_with = SOV }
        }
    }
    ai_strategy = {
        type = area_priority
        id = europe
        value = 40
    }
}
# 北美扩张倾向：控制夏威夷后，将重心转向美国本土
JAP_c_area_priority_usa_invasion_hawaii = {
    allowed = {
        tag = JAP
    }
    enable = {
        has_government = communism
        has_war_with = USA
        # 控制了通往北美的跳板：夏威夷
        629 = { is_controlled_by_ROOT_or_ally = yes } # 夏威夷
    }
    abort_when_not_enabled = yes
    ai_strategy = {
        type = area_priority
        id = north_america
        value = 30
    }
}

# 北美扩张倾向：控制巴拿马运河后，进一步加大对北美的压力
JAP_c_area_priority_usa_invasion_panama = {
    allowed = {
        tag = JAP
    }
    enable = {
        has_government = communism
        has_war_with = USA
        # 控制了切断美军调度的咽喉：巴拿马运河
        685 = { is_controlled_by_ROOT_or_ally = yes } # 巴拿马运河
    }
	
    abort_when_not_enabled = yes
    ai_strategy = {
        type = area_priority
        id = north_america
        value = 30
    }
}
# 南美支援倾向：当南美洲存在未投降的盟友时，增加该区域权重
JAP_c_area_priority_south_america_support = {
    allowed = {
        tag = JAP
    }
    enable = {
        has_government = communism
        # 检查是否有未投降且首都位于南美洲的盟友
        any_allied_country = {
			has_war_with = USA
			USA = {
				has_capitulated = no
			}
            has_capitulated = no
            capital_scope = {
                is_on_continent = south_america
            }
        }
    }
    abort_when_not_enabled = yes
    ai_strategy = {
        type = area_priority
        id = south_america
        value = 20
    }
}
#与苏联并肩时增加20欧洲基础权重
JAP_c_area_priority_with_sov = {
	enable = {
		has_government = communism
		is_in_faction_with = SOV
		SOV = {
			OR = {
				has_war_with = GER
				has_war_with = ENG
				has_war_with = FRA
			}
			

		}
	}
	abort_when_not_enabled = yes
	ai_strategy = {
		type = area_priority
		id = europe
		value = 20
	}
}

#太平洋战争登陆计划开始
#登陆越南
JAP_pacific_war_invade_286 = {
	allowed = {
		tag = JAP
	}
	enable = {
		286 = {
			controller = {
				has_war_with = JAP
			}
		}
	}
	abort = {
		286 = {
			is_controlled_by_ROOT_or_ally = yes
		}
	}
	ai_strategy = {
		type = invasion_unit_request
		strategic_region = 228
		value = 100
	}
	ai_strategy = {
		type = naval_invasion_dominance_weight
		value = 50
	}
	ai_strategy = {
		type = front_control
		ratio = 0
		ordertype = invasion
		execution_type = rush
		execute_order = yes
	}
}
#登陆新加坡
JAP_pacific_war_invade_singapo = {
	allowed = {
		tag = JAP
	}
	enable = {
		336 = {
			controller = {
				has_war_with = JAP
			}
		}
		286 = {
			is_controlled_by_ROOT_or_ally = yes
		}

	}
	abort = {
		336 = {
			is_controlled_by_ROOT_or_ally = yes
		}
	}
	ai_strategy = {
		type = invasion_unit_request
		strategic_region = 188
		value = 100
	}
	ai_strategy = {
		type = naval_invasion_dominance_weight
		value = 50
	}
	ai_strategy = {
		type = front_control
		ratio = 0
		ordertype = invasion
		execution_type = rush
		execute_order = yes
	}
}
#登陆巴达维亚
JAP_pacific_war_invade_batavia = {
	allowed = {
		tag = JAP
	}
	enable = {
		335 = {
			controller = {
				has_war_with = ROOT
			}
		}
		336 = {
			is_controlled_by_ROOT_or_ally = yes
		}
	}
	abort = {
		335 = {
			is_controlled_by_ROOT_or_ally = yes
		}
	}
	ai_strategy = {
		type = invasion_unit_request
		strategic_region = 158
		value = 100
	}
	ai_strategy = {
		type = naval_invasion_dominance_weight
		value = 50
	}
	ai_strategy = {
		type = front_control
		ratio = 0
		ordertype = invasion
		execution_type = rush
		execute_order = yes
	}
}
#登陆巴布亚
JAP_pacific_war_invade_papua = {
	allowed = {
		tag = JAP
	}
	enable = {
		523 = {
			controller = {
				has_war_with = ROOT
			}
		}
		335 = {
			is_controlled_by_ROOT_or_ally = yes
		}
	}	
	abort = {
		523 = {
			is_controlled_by_ROOT_or_ally = yes
		}
	}
	ai_strategy = {
		type = invasion_unit_request
		strategic_region = 167
		value = 100
	}
	ai_strategy = {
		type = naval_invasion_dominance_weight
		value = 50
	}
	ai_strategy = {
		type = front_control
		ratio = 0
		ordertype = invasion
		execution_type = rush
		execute_order = yes
	}
}
#登陆悉尼
JAP_pacific_war_invade_sydney = {
	allowed = {
		tag = JAP
	}
	enable = {
		285 = {
			controller = {
				has_war_with = ROOT
			}
		}
		523 = {
			is_controlled_by_ROOT_or_ally = yes
		}
	}	
	abort = {
		285 = {
			is_controlled_by_ROOT_or_ally = yes
		}
	}
	ai_strategy = {
		type = invasion_unit_request
		strategic_region = 194
		value = 100
	}
	ai_strategy = {
		type = naval_invasion_dominance_weight
		value = 50
	}
	ai_strategy = {
		type = front_control
		ratio = 0
		ordertype = invasion
		execution_type = rush
		execute_order = yes
	}
}
#登陆菲律宾
JAP_pacific_war_invade_phil = {
		allowed = {
		tag = JAP
	}
	enable = {
		327 = {
			controller = {
				has_war_with = ROOT
			}
		}
		524 = {
			is_controlled_by_ROOT_or_ally = yes
		}
	}	
	abort = {
		327 = {
			is_controlled_by_ROOT_or_ally = yes
		}
	}
	ai_strategy = {
		type = invasion_unit_request
		strategic_region = 160
		value = 100
	}
	ai_strategy = {
		type = naval_invasion_dominance_weight
		value = 50
	}
	ai_strategy = {
		type = front_control
		ratio = 0
		ordertype = invasion
		execution_type = rush
		execute_order = yes
	}
}
#登陆关岛
JAP_pacific_war_invade_guam = {
		allowed = {
		tag = JAP
	}
	enable = {
		638 = {
			controller = {
				has_war_with = ROOT
			}
		}
		646 = {
			is_controlled_by_ROOT_or_ally = yes
		}
	}	
	abort = {
		638 = {
			is_controlled_by_ROOT_or_ally = yes
		}
	}
	ai_strategy = {
		type = invasion_unit_request
		state = 638
		value = 50
	}
	ai_strategy = {
		type = naval_invasion_dominance_weight
		value = 50
	}
	ai_strategy = {
		type = front_control
		ratio = 0
		ordertype = invasion
		execution_type = rush
		execute_order = yes
	}
}
#登陆威克岛
JAP_pacific_war_invade_wake = {
		allowed = {
		tag = JAP
	}
	enable = {
		632 = {
			controller = {
				has_war_with = ROOT
			}
		}
		638 = {
			is_controlled_by_ROOT_or_ally = yes
		}
	}	
	abort = {
		632 = {
			is_controlled_by_ROOT_or_ally = yes
		}
	}
	ai_strategy = {
		type = invasion_unit_request
		state = 632
		value = 50
	}
	ai_strategy = {
		type = naval_invasion_dominance_weight
		value = 50
	}
	ai_strategy = {
		type = front_control
		ratio = 0
		ordertype = invasion
		execution_type = rush
		execute_order = yes
	}
}
#登陆中途岛
JAP_pacific_war_invade_midway = {
			allowed = {
		tag = JAP
	}
	enable = {
		631 = {
			controller = {
				has_war_with = ROOT
			}
		}
		632 = {
			is_controlled_by_ROOT_or_ally = yes
		}
	}	
	abort = {
		631 = {
			is_controlled_by_ROOT_or_ally = yes
		}
	}
	ai_strategy = {
		type = invasion_unit_request
		state = 631
		value = 50
	}
	ai_strategy = {
		type = naval_invasion_dominance_weight
		value = 50
	}
	ai_strategy = {
		type = front_control
		ratio = 0
		ordertype = invasion
		execution_type = rush
		execute_order = yes
	}
}
#登陆夏威夷
JAP_pacific_war_invade_hawaii = {
			allowed = {
		tag = JAP
	}
	enable = {
		629 = {
			controller = {
				has_war_with = ROOT
			}
		}
		631 = {
			is_controlled_by_ROOT_or_ally = yes
		}
	}	
	abort = {
		629 = {
			is_controlled_by_ROOT_or_ally = yes
		}
	}
	ai_strategy = {
		type = invasion_unit_request
		state = 629
		value = 50
	}
	ai_strategy = {
		type = naval_invasion_dominance_weight
		value = 50
	}
	ai_strategy = {
		type = front_control
		ratio = 0
		ordertype = invasion
		execution_type = rush
		execute_order = yes
	}
}
#太平洋战争登陆计划结束
#AI装甲师运用
JAP_armor_use_defult = {
	allowed = {
		original_tag = JAP
	}
	enable = {
			has_war_with = JAP
	}
	abort_when_not_enabled = yes
	reversed = yes
	enable_reverse = {
		date > 1938.6.1
	}
	ai_strategy = {
		type = front_armor_score
		id = JAP
		value = 100
	}
}