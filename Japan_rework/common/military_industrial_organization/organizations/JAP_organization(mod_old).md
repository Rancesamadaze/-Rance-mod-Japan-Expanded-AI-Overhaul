#####################

###  ##  #  # # #  ## 
 #  #  # ## # # # #   
 #  #### # ## ##   #  
 #  #  # #  # # #   # 
 #  #  # #  # # # ## 

 #################### 
##坦克生产商
JAP_osaka_army_arsenal_organization = {
    include = JAP_generic_tank_refurbishment_plant_organization # 确保包含的模板名称与前缀一致
    icon = GFX_idea_osaka_army_arsenal
    allowed = { 
        original_tag = JAP
        has_dlc = "Arms Against Tyranny"
    }

    add_trait = {
        token = JAP_mio_trait_military_arsenal_trait
        name = JAP_mio_trait_military_arsenal_trait
        icon = GFX_generic_mio_trait_icon_production_capacity
        special_trait_background = yes

        # 已同步修改前缀
        relative_position_id = JAP_generic_mio_trait_enemy_tank_refitting

        position = { x = -1 y = 0 }  
        
        visible = {
            FROM = { original_tag = JAP }
        }

        available = {
            FROM = {
                JAP_army_faction_is_not_subdued = yes
            }
        }

        on_complete = {
            
        }

        organization_modifier = {
            
        }

        production_bonus = {
            production_capacity_factor = 0.05
        }

        ai_will_do = {
            base = 2
        }
    }

    add_trait = {
        token = JAP_mio_trait_foreign_research_and_development_cooperation
        name = JAP_mio_trait_foreign_research_and_development_cooperation
        icon = GFX_generic_mio_department_icon_facilities
        special_trait_background = yes

        # 已同步修改前缀
        relative_position_id = JAP_generic_mio_trait_enemy_tank_refitting

        position = { x = 1 y = 0 }  
        
        visible = {
            FROM = { original_tag = JAP }
        }

        available = {
            FROM = {
                has_completed_focus = JAP_foreign_tank_modernization_cooperation
                # NOT = { has_country_flag = JAP_mio_trait_foreign_research_and_development_cooperation_taken_flag }
            }
        }

        on_complete = {
            # custom_effect_tooltip = generic_trait_will_not_be_available_in_other_organizations
            # FROM = {
            #     set_country_flag = JAP_mio_trait_foreign_research_and_development_cooperation_taken_flag
            # }
        }

        organization_modifier = {
            military_industrial_organization_research_bonus = 0.1
        }

        production_bonus = {
            production_capacity_factor = 0.1
        }

        ai_will_do = {
            base = 2
        }
    }
}

JAP_sagami_army_arsenal_organization = {
	include = generic_medium_tank_organization
	icon = GFX_idea_JAP_sagami_arsenal
	allowed = {	
		original_tag = JAP
        always = no
		has_dlc = "Arms Against Tyranny"
	}

	initial_trait = {
		organization_modifier = {
			military_industrial_organization_research_bonus = 0.15
			military_industrial_organization_funds_gain = 0.15
			military_industrial_organization_size_up_requirement = -0.15
		}
		production_bonus = {
			production_capacity_factor = 0.05
			production_cost_factor = -0.05
			production_efficiency_cap_factor = 0.05
			production_efficiency_gain_factor = 0.1
			production_resource_need_factor = -0.25
		}
	}

	add_trait = {
		token = JAP_mio_trait_military_arsenal_trait
		name = JAP_mio_trait_military_arsenal_trait
		icon = GFX_generic_mio_trait_icon_production_capacity
		special_trait_background = yes

		relative_position_id = generic_mio_trait_armor_steel_working

		position = { x = -5 y = 0 }  
		
		visible = {
			FROM = { original_tag = JAP }
		}

		available = {
			FROM = {
				JAP_army_faction_is_not_subdued = yes
			}
		}

		on_complete = {
			
		}

		organization_modifier = {
		    
		}

		production_bonus = {
			production_capacity_factor = 0.05
		}

		ai_will_do = {
			base = 2
		}
	}

	add_trait = {
		token = JAP_mio_trait_foreign_research_and_development_cooperation
		name = JAP_mio_trait_foreign_research_and_development_cooperation
		icon = GFX_generic_mio_department_icon_facilities
		special_trait_background = yes

		relative_position_id = generic_mio_trait_aircraft_engines

		position = { x = 0 y = 1 }  
		
		visible = {
			FROM = { original_tag = JAP }
		}

		available = {
			FROM = {
				has_completed_focus = JAP_foreign_tank_modernization_cooperation
				NOT = { has_country_flag = JAP_mio_trait_foreign_research_and_development_cooperation_taken_flag }
			}
		}

		on_complete = {
			custom_effect_tooltip = generic_trait_will_not_be_available_in_other_organizations
			FROM = {
				set_country_flag = JAP_mio_trait_foreign_research_and_development_cooperation_taken_flag
			}
		}

		organization_modifier = {
		    military_industrial_organization_research_bonus = 0.15
		}

		production_bonus = {
			production_capacity_factor = 0.1
		}

		ai_will_do = {
			base = 2
		}
	}

} 
##步兵坦克设计商(三菱重工）
JAP_mitsubishi_heavy_industries_organization = {
	include = JAP_infantry_tank_organization
	icon = GFX_idea_JAP_mitsubishi_tanks
	allowed = {	
		OR ={
			AND = {
					original_tag = JAP
					has_dlc = "Arms Against Tyranny"
			}
			PHI_SEA = yes
		}
	}

	available = {
		IF = {
			limit = {
				FROM = { NOT = { original_tag = JAP } }
			}
			FROM = { NOT = { has_war_with = JAP } }
		}
		
		IF = {
			limit = {
				FROM = {
					original_tag = PHI
				}
			}
			FROM = {
				has_completed_focus = PHI_align_with_japan
				if = {
					limit = {
						has_completed_focus = PHI_declare_military_emergency
					}
					NOT = {
						has_completed_focus = PHI_declare_military_emergency
					}
				}
			}
		}
	}
    add_trait = {
        token = JAP_mio_trait_infantry_tank_ai_only_trait
        name = JAP_mio_trait_infantry_tank_ai_only_trait
        icon = GFX_generic_mio_trait_icon_efficiency_cap
        special_trait_background = yes
        relative_position_id = JAP_mio_trait_special_government_contracts_mitsubishi_trait
        position = { x = -2 y = 0 }
        visible = {
            JAP = {
                is_ai = yes
            }
        }
        available = {
            always = yes
        }
        production_bonus = {
            production_capacity_factor = 0.1
            production_cost_factor = -0.15
            production_conversion_speed_factor = 0.35
            production_resource_need_factor = -0.75
            production_efficiency_gain_factor = 0.2
        }
    }
	add_trait = {
		token = JAP_mio_trait_special_government_contracts_mitsubishi_trait
		name = JAP_mio_trait_special_government_contracts_mitsubishi_trait
		icon = GFX_generic_mio_trait_icon_efficiency_cap
		special_trait_background = yes

		relative_position_id = JAP_generic_mio_trait_battle_tank_specifications

		position = { x = 1 y = 0 }  
		
		visible = {
			FROM = { original_tag = JAP }
		}

		available = {
			has_mio_size > 5
			FROM = {
				NOT = { has_country_flag = JAP_mio_trait_special_government_contracts_taken_flag }
			}
		}

		on_complete = {
			custom_effect_tooltip = generic_trait_will_not_be_available_in_other_organizations
			FROM = {
				set_country_flag = JAP_mio_trait_special_government_contracts_taken_flag 
			}
			custom_effect_tooltip = generic_skip_one_line_tt
			FROM = {
				remove_trait = {
				    character = JAP_koyata_iwasaki
				    slot = political_advisor
				    trait = JAP_custom_mitsubishi_president
				}
				custom_effect_tooltip = generic_skip_one_line_tt
				add_trait = {
				    character = JAP_koyata_iwasaki
				    slot = political_advisor
				    trait = JAP_custom_mitsubishi_president_2
				}
			}
		}

		organization_modifier = {
		    military_industrial_organization_research_bonus = 0.02
		}

		production_bonus = {
			
		}

		ai_will_do = {
			base = 2
		}
	}

	add_trait = {
		token = JAP_mio_trait_zaibatsu_production_capabilities_trait
		name = JAP_mio_trait_zaibatsu_production_capabilities_trait
		icon = GFX_generic_mio_trait_icon_efficiency_gain
		special_trait_background = yes

		relative_position_id = JAP_generic_mio_trait_battle_tank_specifications

		position = { x = 2 y = 0 }  
		
		visible = {
			FROM = { original_tag = JAP }
		}

		available = {
			# FROM = {
			# 	JAP_zaibatsu_faction_is_at_least_influential = yes
			# }
			always = yes
		}

		on_complete = {
			JAP_small_zaibatsu_faction_gain = yes
		}

		production_bonus = {
			production_cost_factor = -0.05
		}

		production_bonus = {
			production_capacity_factor = 0.05
		}

		ai_will_do = {
			base = 2
		}
	}


	add_trait = {
		token = JAP_mio_trait_foreign_research_and_development_cooperation
		name = JAP_mio_trait_foreign_research_and_development_cooperation
		icon = GFX_generic_mio_department_icon_facilities
		special_trait_background = yes

		relative_position_id = JAP_generic_mio_trait_battle_tank_specifications

		position = { x = 3 y = 0 }  
		
		visible = {
			FROM = { original_tag = JAP }
		}

		available = {
			FROM = {
				has_completed_focus = JAP_foreign_tank_modernization_cooperation
				NOT = { has_country_flag = JAP_mio_trait_foreign_research_and_development_cooperation_taken_flag }
			}
		}

		on_complete = {
			# custom_effect_tooltip = generic_trait_will_not_be_available_in_other_organizations
			# FROM = {
			# 	set_country_flag = JAP_mio_trait_foreign_research_and_development_cooperation_taken_flag
			# }
		}

		organization_modifier = {
		    military_industrial_organization_research_bonus = 0.15
		}

		production_bonus = {
			production_capacity_factor = 0.1
		}

		ai_will_do = {
			base = 2
		}
	}

	add_trait = {
		token = PHI_mio_trait_ethanol_fuel_adaptations
		name = PHI_mio_trait_ethanol_fuel_adaptations
		icon = GFX_generic_mio_trait_icon_fuel_consumption
		special_trait_background = yes

		position = { x = 1 y = 3 }  
		
		visible = {
			FROM = { original_tag = PHI }
		}

		available = {
		}

		on_complete = {
		}

		equipment_bonus = {
			fuel_consumption = -0.05
		}

		ai_will_do = {
			base = 2
		}
	}

	add_trait = {
		token = PHI_mio_trait_coconut_fuel_adaptations
		name = PHI_mio_trait_coconut_fuel_adaptations
		icon = GFX_generic_mio_trait_icon_fuel_consumption
		special_trait_background = yes

		position = { x = 0 y = 1 }  
		
		visible = {
			FROM = { original_tag = PHI }
		}

		available = {
			FROM = {
				PHI_vicente_lava = {
					is_hired_as_advisor = yes
				}
			}
		}

		relative_position_id = PHI_mio_trait_ethanol_fuel_adaptations
		any_parent = { PHI_mio_trait_ethanol_fuel_adaptations }

		on_complete = {
		}

		equipment_bonus = {
			fuel_consumption = -0.10
			reliability = -0.05
		}

		ai_will_do = {
			base = 2
		}
	}

	add_trait = {
		token = PHI_mio_trait_ad_hoc_armor_reinforcement
		name = PHI_mio_trait_ad_hoc_armor_reinforcement
		icon = GFX_generic_mio_department_icon_tank_general_armor
		special_trait_background = yes

		position = { x = 8 y = 2 }  
		
		visible = {
			FROM = { original_tag = PHI }
		}

		available = {
		}

		any_parent = { generic_mio_trait_thick_armor }

		on_complete = {
		}

		equipment_bonus = {
			hardness = 0.05
			armor_value = 0.03
			maximum_speed = -0.03
		}

		ai_will_do = {
			base = 2
		}
	}

} 

##
#####################

 ## #  # ### ###   ## 
#   #  #  #  #  # #   
 #  ####  #  ###   #  
  # #  #  #  #      # 
##  #  # ### #    ##  
 
#####################

##战列
JAP_kure_naval_arsenal_organization = {
    include = JAP_generic_battle_line_ship_organization
    icon = GFX_idea_kure_naval_arsenal

    allowed = { 
        original_tag = JAP
        has_dlc = "Arms Against Tyranny"
    }

    available = {
        # FROM = {
        #     has_completed_focus = JAP_expand_hiratsuka_navy_arsenal
        # }
		
    }

    # 海军工厂特质
    add_trait = {
        token = JAP_mio_trait_naval_arsenal_trait
        name = JAP_mio_trait_naval_arsenal_trait
        icon = GFX_generic_mio_trait_icon_production_capacity
        special_trait_background = yes

        # 同步校正前缀
        relative_position_id = JAP_generic_mio_trait_primary_battery_layout

        position = { x = -1 y = 0 }  
        
        visible = {
            FROM = { original_tag = JAP }
        }

        available = {
            FROM = {
                JAP_naval_faction_is_not_subdued = yes
            }
        }

        production_bonus = {
            production_capacity_factor = 0.05
        }

        ai_will_do = {
            base = 2
        }
    }

    # 快速注水平衡系统
    add_trait = {  
        token = JAP_mio_trait_rapid_counterflooding_system
        name = JAP_mio_trait_rapid_counterflooding_system
        icon = GFX_generic_mio_trait_icon_max_strength
        special_trait_background = yes

        # 同步校正前缀
        relative_position_id = JAP_generic_mio_trait_hardened_critical_components
        all_parents = { JAP_generic_mio_trait_hardened_critical_components }

        position = { x = 0 y = 1 } 

        equipment_bonus = {
            naval_torpedo_enemy_critical_chance_factor = -0.1
        }

        ai_will_do = {
            base = 2
        }
    }

    # 强化光学观测设备
    add_trait = {  
        token = JAP_mio_trait_enhanced_optics
        name = JAP_mio_trait_enhanced_optics
        icon = GFX_generic_mio_trait_icon_surface_detection
        special_trait_background = yes

        # 同步校正前缀
        relative_position_id = JAP_generic_mio_trait_secondary_battery_layout
        all_parents = { JAP_generic_mio_trait_secondary_battery_layout }

        position = { x = 0 y = 1 } 

        equipment_bonus = {
            lg_attack = 0.05
            hg_attack = 0.05
        }

        ai_will_do = {
            base = 2
        }
    }

    # 以量取胜
    add_trait = {
        token = JAP_mio_trait_strength_in_numbers
        name = JAP_mio_trait_strength_in_numbers
        icon = GFX_generic_mio_department_icon_facilities
        special_trait_background = yes

        # 同步校正前缀
        relative_position_id = JAP_generic_mio_trait_primary_battery_layout

        position = { x = 1 y = 0 }  
        
        visible = {
            FROM = { original_tag = JAP }
        }

        available = {
            FROM = {
                has_completed_focus = JAP_seek_strength_in_numbers
                NOT = { has_country_flag = JAP_mio_trait_strength_in_numbers_taken_flag }
            }
        }

        production_bonus = {
            production_capacity_factor = 0.1
        }

        ai_will_do = {
            base = 2
        }
    }
}
##特遣舰队
JAP_yokosuka_naval_arsenal_organization = {
    include = JAP_generic_task_force_ship_organization
    icon = GFX_idea_yokosuka_naval_arsenal

    allowed = { 
        OR = {
            AND = {
                original_tag = JAP
                has_dlc = "Arms Against Tyranny"
            }
            PHI_SEA = yes
        }
    }

    available = {
        IF = {
            limit = {
                FROM = { NOT = { original_tag = JAP } }
            }
            FROM = { NOT = { has_war_with = JAP } }
        }
        
        IF = {
            limit = {
                FROM = {
                    original_tag = PHI
                }
            }
            FROM = {
                has_completed_focus = PHI_align_with_japan
                if = {
                    limit = {
                        has_completed_focus = PHI_declare_military_emergency
                    }
                    NOT = {
                        has_completed_focus = PHI_declare_military_emergency
                    }
                }
            }
        }
    }

    # 海军工厂特质
    add_trait = {
        token = JAP_mio_trait_naval_arsenal_trait
        name = JAP_mio_trait_naval_arsenal_trait
        icon = GFX_generic_mio_trait_icon_production_capacity
        special_trait_background = yes

        # 同步校正前缀
        relative_position_id = JAP_generic_mio_trait_primary_fire_director_control

        position = { x = -1 y = 0 }  
        
        visible = {
            FROM = { original_tag = JAP }
        }

        available = {
            FROM = {
                JAP_naval_faction_is_not_subdued = yes
            }
        }

        production_bonus = {
            production_capacity_factor = 0.075
        }

        ai_will_do = {
            base = 2
        }
    }

    # 船体装甲化
    add_trait = {  
        token = JAP_mio_trait_armor_plating_to_hull_strength
        name = JAP_mio_trait_armor_plating_to_hull_strength
        icon = GFX_generic_mio_department_icon_ship_general_production
        special_trait_background = yes

        # 同步校正前缀
        relative_position_id = JAP_generic_mio_trait_long_range_cruising
        any_parent = { JAP_generic_mio_trait_long_range_cruising JAP_generic_mio_trait_high_speed_cruising }

        position = { x = 0 y = 1 } 

        visible = {
            FROM = { original_tag = JAP }
        }

        production_bonus = {
            production_capacity_factor = 0.075
        }

        ai_will_do = {
            base = 2
        }
    }

    # 强化光学设备
    add_trait = {  
        token = JAP_mio_trait_enhanced_optics
        name = JAP_mio_trait_enhanced_optics
        icon = GFX_generic_mio_trait_icon_surface_detection
        special_trait_background = yes

        # 同步校正前缀
        relative_position_id = JAP_generic_mio_trait_primary_fire_director_control
        all_parents = { JAP_generic_mio_trait_primary_fire_director_control }

        position = { x = 1 y = 1 } 

        visible = {
            FROM = { original_tag = JAP }
        }

        equipment_bonus = {
            lg_attack = 0.05
            hg_attack = 0.05
        }

        ai_will_do = {
            base = 2
        }
    }

    # 九四式射击指挥仪
    add_trait = {  
        token = JAP_mio_trait_type_94_fire_control
        name = JAP_mio_trait_type_94_fire_control
        icon = GFX_generic_mio_trait_icon_anti_air_attack
        special_trait_background = yes

        # 同步校正前缀
        relative_position_id = JAP_generic_mio_trait_secondary_fire_director_control
        all_parents = { JAP_generic_mio_trait_secondary_fire_director_control }

        position = { x = 0 y = 1 } 

        visible = {
            FROM = { original_tag = JAP }
        }

        limit_to_equipment_type = { mio_cat_eq_all_cruiser carrier }

        equipment_bonus = {
            anti_air_attack = 0.1
            naval_light_gun_hit_chance_factor = 0.05
        }

        ai_will_do = {
            base = 2
        }
    }

    # 鱼雷再装填
    add_trait = {  
        token = JAP_mio_trait_torpedo_reloads
        name = JAP_mio_trait_torpedo_reloads
        icon = GFX_generic_mio_trait_icon_torpedo_attack
        special_trait_background = yes

        # 内部引用已正确使用 JAP_ 前缀
        relative_position_id = JAP_mio_trait_enhanced_optics
        all_parents = { JAP_mio_trait_enhanced_optics }

        position = { x = 0 y = 1 } 

        visible = {
            FROM = { original_tag = JAP }
        }

        limit_to_equipment_type = { screen_ship }

        equipment_bonus = {
            torpedo_attack  = 0.1
        }

        ai_will_do = {
            base = 2
        }
    }

    # 以量取胜
    add_trait = {
        token = JAP_mio_trait_strength_in_numbers
        name = JAP_mio_trait_strength_in_numbers
        icon = GFX_generic_mio_department_icon_facilities
        special_trait_background = yes

        # 同步校正前缀
        relative_position_id = JAP_generic_mio_trait_primary_fire_director_control

        position = { x = 1 y = 0 }  
        
        visible = {
            FROM = { original_tag = JAP }
        }

        available = {
            FROM = {
                has_completed_focus = JAP_seek_strength_in_numbers
                NOT = { has_country_flag = JAP_mio_trait_strength_in_numbers_taken_flag }
            }
        }

        # on_complete = {
        #     custom_effect_tooltip = generic_trait_will_not_be_available_in_other_organizations
        #     FROM = {
        #         set_country_flag = JAP_mio_trait_strength_in_numbers_taken_flag
        #     }
        # }

        production_bonus = {
            production_capacity_factor = 0.1
        }

        ai_will_do = {
            base = 2
        }
    }

    # 菲律宾专属：乙醇燃料适配
    add_trait = {
        token = PHI_mio_trait_ethanol_fuel_adaptations
        name = PHI_mio_trait_ethanol_fuel_adaptations
        icon = GFX_generic_mio_trait_icon_fuel_consumption
        special_trait_background = yes

        position = { x = 9 y = 0 }  
        
        visible = {
            FROM = { original_tag = PHI }
        }

        equipment_bonus = {
            fuel_consumption = -0.05
        }

        ai_will_do = {
            base = 2
        }
    }

    # 菲律宾专属：椰子燃料适配
    add_trait = {
        token = PHI_mio_trait_coconut_fuel_adaptations
        name = PHI_mio_trait_coconut_fuel_adaptations
        icon = GFX_generic_mio_trait_icon_fuel_consumption
        special_trait_background = yes

        position = { x = 0 y = 1 }  
        
        visible = {
            FROM = { original_tag = PHI }
        }

        available = {
            FROM = {
                PHI_vicente_lava = {
                    is_hired_as_advisor = yes
                }
            }
        }

        relative_position_id = PHI_mio_trait_ethanol_fuel_adaptations
        any_parent = { PHI_mio_trait_ethanol_fuel_adaptations }

        equipment_bonus = {
            fuel_consumption = -0.10
            reliability = -0.05
        }

        ai_will_do = {
            base = 2
        }
    }
}

# 经过 Token 唯一化处理的 JAP 航母突袭舰队 MIO
# 剔除 name 前缀后的 JAP 航母突袭舰队 MIO
JAP_kawasaki_dockyards_organization = {
    
    icon = GFX_idea_JAP_kawasaki_dockyards

    allowed = { 
        original_tag = JAP
        has_dlc = "Arms Against Tyranny"
    }

    equipment_type = {
        carrier
        screen_ship
        submarine
    }
    research_categories = {
        mio_cat_tech_all_carrier_and_modules
        mio_cat_tech_all_screen_ship_and_modules
        mio_cat_tech_all_submarine_and_modules
    }
    
    tree_header_text = {
        text = mio_header_long_range_focus
        x = 1
    }

    tree_header_text = {
        text = mio_header_high_speed_focus
        x = 7
    }

    initial_trait = {
        name = JAP_rework_kawasaki_dockyards_org_name

        organization_modifier = {
            military_industrial_organization_research_bonus = 0.15
            military_industrial_organization_funds_gain = 0.15
            military_industrial_organization_size_up_requirement = -0.15
        }
        production_bonus = {
            production_capacity_factor = 0.05
            production_cost_factor = -0.05
            production_efficiency_cap_factor = 0.05
            production_efficiency_gain_factor = 0.1
            production_resource_need_factor = -0.25
        }
        equipment_bonus = {
            surface_visibility = -0.05
            carrier_size = 1
            surface_detection = 0.1
            sub_detection = 0.2
            naval_range = 0.1
            naval_speed = 0.05
        }
    }

    # --- 基础机动与航程分支 ---

    trait = {
        token = JAP_generic_mio_trait_long_range_raiding
        name = generic_mio_trait_long_range_raiding
        icon = GFX_generic_mio_department_icon_ship_general_engine
        position = { x=1 y=0 }
        equipment_bonus = {
            naval_range = 0.1
        }
    }

    trait = {
        token = JAP_generic_mio_trait_high_speed_raiding
        name = generic_mio_trait_high_speed_raiding
        icon = GFX_generic_mio_trait_icon_maximum_speed
        position = { x=6 y=0 }
        relative_position_id = JAP_generic_mio_trait_long_range_raiding
        equipment_bonus = {
            naval_speed = 0.1
        }
    }

    trait = {
        token = JAP_generic_mio_trait_diesel_powerplants
        name = generic_mio_trait_diesel_powerplants
        icon = GFX_generic_mio_trait_icon_fuel_consumption
        position = { x=-1 y=1 }
        relative_position_id = JAP_generic_mio_trait_long_range_raiding
        any_parent = { JAP_generic_mio_trait_long_range_raiding }
        equipment_bonus = {
            fuel_consumption = -0.1
        }
    }

    trait = {
        token = JAP_generic_mio_trait_high_speed_operation_stores
        name = generic_mio_trait_high_speed_operation_stores
        icon = GFX_generic_mio_trait_icon_mines
        position = { x=1 y=1 }
        relative_position_id = JAP_generic_mio_trait_high_speed_raiding
        any_parent = { JAP_generic_mio_trait_high_speed_raiding }
        visible = { has_dlc = "Man the Guns" }
        equipment_bonus = {
            naval_speed = 0.05
            mines_planting = 0.05
        }
    }

    trait = {
        token = JAP_generic_mio_trait_high_speed_operation_stores_no_mtg
        name = generic_mio_trait_high_speed_operation_stores
        icon = GFX_generic_mio_trait_icon_mines
        position = { x=0 y=0 }
        relative_position_id = JAP_generic_mio_trait_high_speed_operation_stores
        any_parent = { JAP_generic_mio_trait_high_speed_raiding }
        visible = { NOT = { has_dlc = "Man the Guns" } }
        equipment_bonus = {
            naval_speed = 0.1
        }
    }

    # --- 航母核心作战强化 ---

    trait = {
        token = JAP_generic_mio_trait_raiding_capital_ships
        name = generic_mio_trait_raiding_capital_ships
        icon = GFX_generic_mio_trait_icon_surface_visibility
        position = { x=1 y=2 }
        relative_position_id = JAP_generic_mio_trait_long_range_raiding
        any_parent = { JAP_generic_mio_trait_long_range_raiding JAP_generic_mio_trait_high_speed_raiding }
        limit_to_equipment_type = { carrier }
        equipment_bonus = {
            surface_visibility = -0.05
            naval_speed = 0.05
        }
    }

    trait = {
        token = JAP_generic_mio_trait_long_range_engagement_ethos
        name = generic_mio_trait_long_range_engagement_ethos
        icon = GFX_generic_mio_department_icon_ship_carrier_offense
        position = { x=-1 y=1 }
        relative_position_id = JAP_generic_mio_trait_raiding_capital_ships
        any_parent = { JAP_generic_mio_trait_raiding_capital_ships }
        limit_to_equipment_type = { carrier }
        equipment_bonus = {
            naval_range = 0.05
            anti_air_attack = 0.1
        }
    }

    trait = {
        token = JAP_generic_mio_trait_high_quality_optics
        name = generic_mio_trait_high_quality_optics
        icon = GFX_generic_mio_trait_icon_surface_detection
        position = { x=1 y=1 }
        relative_position_id = JAP_generic_mio_trait_raiding_capital_ships
        any_parent = { JAP_generic_mio_trait_raiding_capital_ships }
        equipment_bonus = {
            surface_detection = 0.15
        }
    }

    trait = {
        token = JAP_generic_mio_trait_raider_escort_requirements
        name = generic_mio_trait_raider_escort_requirements
        icon = GFX_generic_mio_department_icon_ship_screen_ship_engine
        position = { x=-1 y=1 }
        relative_position_id = JAP_generic_mio_trait_long_range_engagement_ethos
        any_parent = { JAP_generic_mio_trait_long_range_engagement_ethos }
        limit_to_equipment_type = { screen_ship }
        equipment_bonus = {
            naval_range = 0.1
            naval_speed = 0.1
        }
    }

    trait = {
        token = JAP_generic_mio_trait_unescorted_raider_requirements
        name = generic_mio_trait_unescorted_raider_requirements
        icon = GFX_generic_mio_trait_icon_max_strength
        position = { x=1 y=1 }
        relative_position_id = JAP_generic_mio_trait_long_range_engagement_ethos
        all_parents = { JAP_generic_mio_trait_long_range_engagement_ethos JAP_generic_mio_trait_high_quality_optics }
        limit_to_equipment_type = { carrier }
        equipment_bonus = {
            max_strength = 0.1
            naval_speed = 0.1
        }
    }

    # --- 辅助舰船与生产分支 ---

    trait = {
        token = JAP_generic_mio_trait_raiding_cruisers
        name = generic_mio_trait_raiding_cruisers
        icon = GFX_generic_mio_trait_icon_surface_visibility
        position = { x=-3 y=2 }
        relative_position_id = JAP_generic_mio_trait_high_speed_raiding
        any_parent = { JAP_generic_mio_trait_long_range_raiding JAP_generic_mio_trait_high_speed_raiding }
        limit_to_equipment_type = { ship_hull_cruiser }
        equipment_bonus = {
            surface_visibility = -0.1
        }
    }

    trait = {
        token = JAP_generic_mio_trait_raiding_submarines
        name = generic_mio_trait_raiding_submarines
        icon = GFX_generic_mio_department_icon_ship_submarine_survivability
        position = { x=2 y=0 }
        relative_position_id = JAP_generic_mio_trait_raiding_cruisers
        any_parent = { JAP_generic_mio_trait_high_speed_raiding JAP_generic_mio_trait_long_range_raiding }
        limit_to_equipment_type = { submarine }
        equipment_bonus = {
            surface_visibility = -0.05
            sub_visibility = -0.05
        }
    }

    trait = {
        token = JAP_generic_mio_trait_spotting_tops
        name = generic_mio_trait_spotting_tops
        icon = GFX_generic_mio_trait_icon_surface_visibility        
        position = { x=1 y=1 }
        relative_position_id = JAP_generic_mio_trait_raiding_cruisers
        all_parents = { JAP_generic_mio_trait_raiding_cruisers JAP_generic_mio_trait_raiding_submarines }
        limit_to_equipment_type = { carrier screen_ship }
        equipment_bonus = {
            surface_visibility = -0.1
        }
    }

    trait = {
        token = JAP_generic_mio_trait_large_torpedo_banks
        name = generic_mio_trait_large_torpedo_banks
        icon = GFX_generic_mio_trait_icon_torpedo_attack
        position = { x=1 y=1 }
        relative_position_id = JAP_generic_mio_trait_raiding_submarines
        any_parent = { JAP_generic_mio_trait_raiding_submarines }
        equipment_bonus = {
            torpedo_attack = 0.1
        }
    }

    trait = {
        token = JAP_generic_mio_trait_mass_produced_raiders
        name = generic_mio_trait_mass_produced_raiders
        icon = GFX_generic_mio_department_icon_ship_general_production
        position = { x=1 y=1 }
        relative_position_id = JAP_generic_mio_trait_spotting_tops
        all_parents = { JAP_generic_mio_trait_spotting_tops JAP_generic_mio_trait_large_torpedo_banks }
        production_bonus = {
            production_capacity_factor = 0.075
        }
    }

    # --- 日本/财阀专属加成 ---

    trait = {
        token = JAP_mio_trait_zaibatsu_production_capabilities_trait
        name = JAP_mio_trait_zaibatsu_production_capabilities_trait
        icon = GFX_generic_mio_trait_icon_efficiency_gain
        special_trait_background = yes
        relative_position_id = JAP_generic_mio_trait_high_speed_raiding
        position = { x = 1 y = 0 }
        visible = { FROM = { original_tag = JAP } }
        available = {
            FROM = { JAP_zaibatsu_faction_is_at_least_influential = yes }
        }
        production_bonus = {
            production_cost_factor = -0.05
            production_capacity_factor = 0.05
        }
        ai_will_do = { base = 2 }
    }

    trait = {
        token = JAP_mio_trait_strength_in_numbers
        name = JAP_mio_trait_strength_in_numbers
        icon = GFX_generic_mio_department_icon_facilities
        special_trait_background = yes
        relative_position_id = JAP_generic_mio_trait_high_speed_raiding
        position = { x = 2 y = 0 }
        visible = { FROM = { original_tag = JAP } }
        available = {
            FROM = {
                has_completed_focus = JAP_seek_strength_in_numbers
                # NOT = { has_country_flag = JAP_mio_trait_strength_in_numbers_taken_flag }
            }
        }
        production_bonus = {
            production_capacity_factor = 0.1
        }
        ai_will_do = { base = 2 }
    }
}

# 整合后的护卫舰支队：舞鹤海军工厂 MIO
# 独立化处理：JAP 护卫舰支队 MIO
# 修正命名索引：JAP 护卫舰支队 MIO
JAP_maizuru_naval_arsenal_organization = {
    icon = GFX_idea_maizuru_naval_arsenal

    allowed = {  
        OR = {
            original_tag = JAP 
            AND = {
                original_tag = ETH
                has_dlc = "By Blood Alone"
            }
        }
    }
    
    visible = {
        IF = {
            limit = { FROM = { original_tag = ETH } }
            FROM = { has_completed_focus = ETH_invite_foreign_industrialists }
        }
    }
    
    available = {
        IF = {
            limit = { FROM = { NOT = { original_tag = JAP } } }
            FROM = { NOT = { has_war_with = JAP } }
        }
        IF = {
            limit = { FROM = { original_tag = ETH } }
            custom_trigger_tooltip = {
                tooltip = has_invited_mio_tt
                FROM = { has_country_flag = has_invited_JAP_maizuru_naval_arsenal_organization_flag }
            }
        }
    }

    equipment_type = { screen_ship }
    research_categories = { mio_cat_tech_all_screen_ship_and_modules }
    
    tree_header_text = { text = mio_header_systems x = 1 }
    tree_header_text = { text = mio_header_weapons x = 5 }

    initial_trait = {
        name = JAP_generic_mio_initial_trait_escort_fleet
        organization_modifier = {
            military_industrial_organization_research_bonus = 0.15
            military_industrial_organization_funds_gain = 0.15
            military_industrial_organization_size_up_requirement = -0.15
        }
        production_bonus = {
            production_capacity_factor = 0.05
            production_cost_factor = -0.05
            production_efficiency_cap_factor = 0.05
            production_efficiency_gain_factor = 0.1
            production_resource_need_factor = -0.25
        }
        equipment_bonus = {
            surface_detection = 0.2
            sub_detection = 0.1
            surface_visibility = -0.1
            sub_attack = 0.2
            naval_light_gun_hit_chance_factor = 0.025
            naval_light_gun_hit_chance_factor = 0.025
        }
    }

    # --- 潜艇猎杀分支 ---
    trait = {
        token = JAP_generic_mio_trait_submarine_hunters
        name = generic_mio_trait_submarine_hunters
        icon = GFX_generic_mio_trait_icon_sub_attack
        position = { x=1 y=0 }
        equipment_bonus = { sub_detection = 0.1 sub_attack = 0.1 }
    }

    trait = {
        token = JAP_generic_mio_trait_high_speed_mine_hunting_equipment
        name = generic_mio_trait_high_speed_mine_hunting_equipment
        icon = GFX_generic_mio_trait_icon_sub_visibility
        position = { x=0 y=2 }
        relative_position_id = JAP_generic_mio_trait_submarine_hunters
        any_parent = { JAP_generic_mio_trait_submarine_hunters }
        equipment_bonus = { sub_detection = 0.1 mines_sweeping = 0.1 }
    }

    trait = {
        token = JAP_mio_trait_high_pressure_boilers
        name = mio_trait_high_pressure_boilers
        icon = GFX_generic_mio_trait_icon_maximum_speed
        special_trait_background = yes
        relative_position_id = JAP_generic_mio_trait_high_speed_mine_hunting_equipment
        any_parent = { JAP_generic_mio_trait_high_speed_mine_hunting_equipment }
        position = { x = -1 y = 1 } 
        equipment_bonus = { naval_speed = 0.15 }
        ai_will_do = { base = 2 }
    }

    trait = {
        token = JAP_mio_trait_type_94_fire_control
        name = mio_trait_type_94_fire_control
        icon = GFX_generic_mio_trait_icon_anti_air_attack
        special_trait_background = yes
        relative_position_id = JAP_generic_mio_trait_high_speed_mine_hunting_equipment
        any_parent = { JAP_generic_mio_trait_high_speed_mine_hunting_equipment }
        position = { x = 1 y = 1 } 
        limit_to_equipment_type = { mio_cat_eq_all_cruiser carrier }
        equipment_bonus = { anti_air_attack = 0.05 naval_light_gun_hit_chance_factor = 0.075 }
        ai_will_do = { base = 2 }
    }

    trait = {
        token = JAP_generic_mio_trait_advanced_hydrodynamic_design
        name = generic_mio_trait_advanced_hydrodynamic_design
        icon = GFX_generic_mio_trait_icon_maximum_speed
        position = { x=0 y=2 }
        relative_position_id = JAP_generic_mio_trait_high_speed_mine_hunting_equipment
        any_parent = { JAP_generic_mio_trait_high_speed_mine_hunting_equipment }
        equipment_bonus = { naval_speed = 0.1 }
    }

    # --- 舰队护航分支 ---
    trait = {
        token = JAP_generic_mio_trait_fleet_escorts
        name = generic_mio_trait_fleet_escorts
        icon = GFX_generic_mio_department_icon_ship_screen_ship_offense
        position = { x=5 y=0 }
        relative_position_id = JAP_generic_mio_trait_submarine_hunters
        equipment_bonus = { anti_air_attack = 0.05 lg_attack = 0.05 }
    }

    trait = {
        token = JAP_mio_trait_torpedo_reloads
        name = mio_trait_torpedo_reloads
        icon = GFX_generic_mio_trait_icon_torpedo_attack
        special_trait_background = yes
        relative_position_id = JAP_generic_mio_trait_fleet_escorts
        any_parent = { JAP_generic_mio_trait_fleet_escorts }
        position = { x = 0 y = 1 } 
        limit_to_equipment_type = { screen_ship }
        equipment_bonus = { torpedo_attack = 0.15 }
        ai_will_do = { base = 2 }
    }

    trait = {
        token = JAP_generic_mio_trait_anti_air_ships
        name = generic_mio_trait_anti_air_ships
        icon = GFX_generic_mio_trait_icon_anti_air_attack
        position = { x=-3 y=2 }
        relative_position_id = JAP_generic_mio_trait_fleet_escorts
        any_parent = { JAP_generic_mio_trait_fleet_escorts }
        equipment_bonus = { anti_air_attack = 0.05 }
    }

    trait = {
        token = JAP_generic_mio_trait_escort_in_force
        name = generic_mio_trait_escort_in_force
        icon = GFX_generic_mio_trait_icon_lg_attack
        position = { x=2 y=0 }
        relative_position_id = JAP_generic_mio_trait_anti_air_ships
        any_parent = { JAP_generic_mio_trait_fleet_escorts }
        equipment_bonus = { lg_attack = 0.05 }
    }

    trait = {
        token = JAP_generic_mio_trait_anti_air_layout
        name = generic_mio_trait_anti_air_layout
        icon = GFX_generic_mio_trait_icon_anti_air_attack
        position = { x=2 y=0 }
        relative_position_id = JAP_generic_mio_trait_escort_in_force
        any_parent = { JAP_generic_mio_trait_fleet_escorts }
        equipment_bonus = { anti_air_attack = 0.05 }
    }

    trait = {
        token = JAP_generic_mio_trait_improved_anti_air_gun_mounting
        name = generic_mio_trait_improved_anti_air_gun_mounting
        icon = GFX_generic_mio_trait_icon_anti_air_attack
        position = { x=0 y=2 }
        relative_position_id = JAP_generic_mio_trait_anti_air_ships
        any_parent = { JAP_generic_mio_trait_anti_air_ships JAP_generic_mio_trait_escort_in_force }
        equipment_bonus = { anti_air_attack = 0.05 }
    }

    trait = {
        token = JAP_generic_mio_trait_gyro_stabilized_mounts
        name = generic_mio_trait_gyro_stabilized_mounts
        icon = GFX_generic_mio_department_icon_ship_screen_ship_offense
        position = { x=0 y=1 }
        relative_position_id = JAP_generic_mio_trait_anti_air_layout
        any_parent = { JAP_generic_mio_trait_anti_air_layout }
        equipment_bonus = { anti_air_attack = 0.05 lg_attack = 0.05 }
    }

    trait = {
        token = JAP_generic_mio_trait_mass_production
        name = generic_mio_trait_mass_production
        icon = GFX_generic_mio_department_icon_ship_screen_ship_production
        position = { x=1 y=0 }
        relative_position_id = JAP_generic_mio_trait_improved_anti_air_gun_mounting
        any_parent = { JAP_generic_mio_trait_anti_air_ships JAP_generic_mio_trait_escort_in_force }
        production_bonus = { production_capacity_factor = 0.1 }
    }

    trait = {
        token = JAP_generic_mio_trait_improved_light_gun_mounting
        name = generic_mio_trait_improved_light_gun_mounting
        icon = GFX_generic_mio_department_icon_ship_screen_ship_offense
        position = { x=2 y=0 }
        relative_position_id = JAP_generic_mio_trait_mass_production
        any_parent = { JAP_generic_mio_trait_anti_air_ships JAP_generic_mio_trait_escort_in_force JAP_generic_mio_trait_gyro_stabilized_mounts }
        equipment_bonus = { anti_air_attack = 0.05 lg_attack = 0.05 }
    }

    # --- 日本专属生产与特质 ---
    trait = {
        token = JAP_mio_trait_strength_in_numbers
        name = mio_trait_strength_in_numbers
        icon = GFX_generic_mio_department_icon_facilities
        special_trait_background = yes
        relative_position_id = JAP_generic_mio_trait_fleet_escorts
        position = { x = 3 y = 0 }  
        visible = { FROM = { original_tag = JAP } }
        available = {
            FROM = {
                has_completed_focus = JAP_seek_strength_in_numbers
                # NOT = { has_country_flag = JAP_mio_trait_strength_in_numbers_taken_flag }
            }
        }
        production_bonus = { production_capacity_factor = 0.1 }
        ai_will_do = { base = 2 }
    }

    trait = {
        token = JAP_mio_trait_naval_arsenal_trait
        name = mio_trait_naval_arsenal_trait
        icon = GFX_generic_mio_trait_icon_production_capacity
        special_trait_background = yes
        relative_position_id = JAP_mio_trait_strength_in_numbers
        position = { x = -1 y = 0 }  
        visible = { FROM = { original_tag = JAP } }
        available = { FROM = { JAP_naval_faction_is_not_subdued = yes } }
        production_bonus = { production_capacity_factor = 0.05 }
        ai_will_do = { base = 2 }
    }
}
##突袭舰队

# 整合后的突袭舰队 MIO：佐世保海军工厂
# 修正本地化索引后的 JAP 突袭舰队 MIO
JAP_sasebo_naval_arsenal_organization = {
    icon = GFX_idea_sasebo_naval_arsenal

    allowed = {   
        original_tag = JAP
        has_dlc = "Arms Against Tyranny"
    }

    equipment_type = {
        capital_ship
        screen_ship
        submarine
    }
    research_categories = {
        mio_cat_tech_all_capital_ship_and_modules
        mio_cat_tech_all_screen_ship_and_modules
        mio_cat_tech_all_submarine_and_modules
    }
    
    tree_header_text = {
        text = mio_header_long_range_focus
        x = 1
    }

    tree_header_text = {
        text = mio_header_high_speed_focus
        x = 7
    }

    initial_trait = {
        name = JAP_generic_mio_initial_trait_raiding_fleet

        organization_modifier = {
            military_industrial_organization_research_bonus = 0.15
            military_industrial_organization_funds_gain = 0.15
            military_industrial_organization_size_up_requirement = -0.15
        }
        production_bonus = {
            production_capacity_factor = 0.05
            production_cost_factor = -0.05
            production_efficiency_cap_factor = 0.05
            production_efficiency_gain_factor = 0.1
            production_resource_need_factor = -0.25
        }
        equipment_bonus = {
            surface_visibility = -0.1
            torpedo_attack = 0.05
            hg_attack = 0.025
            surface_detection = 0.15
            naval_light_gun_hit_chance_factor = 0.1
        }
    }

    # --- 基础机动分支 ---

    trait = {
        token = JAP_beta_generic_mio_trait_long_range_raiding
        name = generic_mio_trait_long_range_raiding
        icon = GFX_generic_mio_department_icon_ship_general_engine
        position = { x=1 y=0 }
        equipment_bonus = {
            naval_range = 0.1
        }
    }

    trait = {
        token = JAP_beta_generic_mio_trait_high_speed_raiding
        name = generic_mio_trait_high_speed_raiding
        icon = GFX_generic_mio_trait_icon_maximum_speed
        position = { x=6 y=0 }
        relative_position_id = JAP_beta_generic_mio_trait_long_range_raiding
        equipment_bonus = {
            naval_speed = 0.1
        }
    }

    # 日本专属：数量优势
    trait = {
        token = JAP_beta_JAP_mio_trait_strength_in_numbers
        name = JAP_mio_trait_strength_in_numbers
        icon = GFX_generic_mio_department_icon_facilities
        special_trait_background = yes
        relative_position_id = JAP_beta_generic_mio_trait_high_speed_raiding
        position = { x = 2 y = 0 }  
        visible = { FROM = { original_tag = JAP } }
        available = {
            FROM = {
                has_completed_focus = JAP_seek_strength_in_numbers
                # NOT = { has_country_flag = JAP_mio_trait_strength_in_numbers_taken_flag }
            }
        }
        production_bonus = { production_capacity_factor = 0.1 }
        ai_will_do = { base = 2 }
    }

    # 日本专属：海军工厂特质
    trait = {
        token = JAP_beta_JAP_mio_trait_naval_arsenal_trait
        name = JAP_mio_trait_naval_arsenal_trait
        icon = GFX_generic_mio_trait_icon_production_capacity
        special_trait_background = yes
        relative_position_id = JAP_beta_JAP_mio_trait_strength_in_numbers
        position = { x = -1 y = 0 }  
        visible = { FROM = { original_tag = JAP } }
        available = { FROM = { JAP_naval_faction_is_not_subdued = yes } }
        production_bonus = { production_capacity_factor = 0.075 }
        ai_will_do = { base = 2 }
    }

    trait = {
        token = JAP_beta_generic_mio_trait_diesel_powerplants
        name = generic_mio_trait_diesel_powerplants
        icon = GFX_generic_mio_trait_icon_fuel_consumption
        position = { x=-1 y=1 }
        relative_position_id = JAP_beta_generic_mio_trait_long_range_raiding
        any_parent = { JAP_beta_generic_mio_trait_long_range_raiding }
        equipment_bonus = { fuel_consumption = -0.075 }
    }

    trait = {
        token = JAP_beta_generic_mio_trait_high_speed_operation_stores
        name = generic_mio_trait_high_speed_operation_stores
        icon = GFX_generic_mio_trait_icon_mines
        position = { x=1 y=1 }
        relative_position_id = JAP_beta_generic_mio_trait_high_speed_raiding
        any_parent = { JAP_beta_generic_mio_trait_high_speed_raiding }
        visible = { has_dlc = "Man the Guns" }
        equipment_bonus = { naval_speed = 0.15 mines_planting = 0.15 }
    }

    trait = {
        token = JAP_beta_generic_mio_trait_high_speed_operation_stores_no_mtg
        name = generic_mio_trait_high_speed_operation_stores
        icon = GFX_generic_mio_trait_icon_mines
        position = { x=0 y=0 }
        relative_position_id = JAP_beta_generic_mio_trait_high_speed_operation_stores
        any_parent = { JAP_beta_generic_mio_trait_high_speed_raiding }
        visible = { NOT = { has_dlc = "Man the Guns" } }
        equipment_bonus = { naval_speed = 0.05 }
    }

    # --- 主力舰强化分支 ---

    trait = {
        token = JAP_beta_generic_mio_trait_raiding_capital_ships
        name = generic_mio_trait_raiding_capital_ships
        icon = GFX_generic_mio_department_icon_ship_capital_ship_weapons
        position = { x=1 y=2 }
        relative_position_id = JAP_beta_generic_mio_trait_long_range_raiding
        any_parent = { JAP_beta_generic_mio_trait_long_range_raiding JAP_beta_generic_mio_trait_high_speed_raiding }
        limit_to_equipment_type = { capital_ship }
        equipment_bonus = { surface_visibility = -0.05 hg_attack = 0.075 }
    }

    trait = {
        token = JAP_beta_generic_mio_trait_long_range_engagement_ethos
        name = generic_mio_trait_long_range_engagement_ethos
        icon = GFX_generic_mio_department_icon_ship_capital_ship_weapons
        position = { x=-1 y=1 }
        relative_position_id = JAP_beta_generic_mio_trait_raiding_capital_ships
        any_parent = { JAP_beta_generic_mio_trait_raiding_capital_ships }
        # limit_to_equipment_type = { capital_ship }
        equipment_bonus = { surface_visibility = -0.05 hg_attack = 0.075 }
    }

    trait = {
        token = JAP_beta_generic_mio_trait_high_quality_optics
        name = generic_mio_trait_high_quality_optics
        icon = GFX_generic_mio_trait_icon_surface_detection
        position = { x=1 y=1 }
        relative_position_id = JAP_beta_generic_mio_trait_raiding_capital_ships
        any_parent = { JAP_beta_generic_mio_trait_raiding_capital_ships }
        equipment_bonus = { surface_detection = 0.1}
    }

    # 日本专属：97式鱼雷指挥仪
    trait = {  
        token = JAP_beta_JAP_mio_trait_type_97_torpedo_control_director
        name = JAP_mio_trait_type_97_torpedo_control_director
        icon = GFX_generic_mio_trait_icon_torpedo_attack
        special_trait_background = yes
        relative_position_id = JAP_beta_generic_mio_trait_high_quality_optics
        any_parent = { JAP_beta_generic_mio_trait_high_quality_optics JAP_beta_generic_mio_trait_spotting_tops }
        position = { x = 1 y = 1 } 
        # limit_to_equipment_type = { screen_ship }
        equipment_bonus = { naval_torpedo_hit_chance_factor = 0.1 }
        ai_will_do = { base = 2 }
    }

    trait = {
        token = JAP_beta_generic_mio_trait_raider_escort_requirements
        name = generic_mio_trait_raider_escort_requirements
        icon = GFX_generic_mio_department_icon_ship_screen_ship_engine
        position = { x=-1 y=1 }
        relative_position_id = JAP_beta_generic_mio_trait_long_range_engagement_ethos
        any_parent = { JAP_beta_generic_mio_trait_long_range_engagement_ethos }
        limit_to_equipment_type = { screen_ship }
        equipment_bonus = { naval_range = 0.1 naval_speed = 0.1 }
    }

    trait = {
        token = JAP_beta_generic_mio_trait_unescorted_raider_requirements
        name = generic_mio_trait_unescorted_raider_requirements
        icon = GFX_generic_mio_trait_icon_lg_attack
        position = { x=1 y=1 }
        relative_position_id = JAP_beta_generic_mio_trait_long_range_engagement_ethos
        all_parents = { JAP_beta_generic_mio_trait_long_range_engagement_ethos JAP_beta_generic_mio_trait_high_quality_optics }
        # limit_to_equipment_type = { capital_ship }
        equipment_bonus = { lg_attack = 0.1 }
    }

    # --- 巡洋舰与潜艇分支 ---

    trait = {
        token = JAP_beta_generic_mio_trait_raiding_cruisers
        name = generic_mio_trait_raiding_cruisers
        icon = GFX_generic_mio_trait_icon_surface_visibility
        position = { x=-3 y=2 }
        relative_position_id = JAP_beta_generic_mio_trait_high_speed_raiding
        any_parent = { JAP_beta_generic_mio_trait_long_range_raiding JAP_beta_generic_mio_trait_high_speed_raiding }
        # limit_to_equipment_type = { ship_hull_cruiser }
        equipment_bonus = { surface_visibility = -0.05 }
    }

    trait = {
        token = JAP_beta_generic_mio_trait_raiding_submarines
        name = generic_mio_trait_raiding_submarines
        icon = GFX_generic_mio_department_icon_ship_submarine_survivability
        position = { x=2 y=0 }
        relative_position_id = JAP_beta_generic_mio_trait_raiding_cruisers
        any_parent = { JAP_beta_generic_mio_trait_high_speed_raiding JAP_beta_generic_mio_trait_long_range_raiding }
        limit_to_equipment_type = { submarine }
        equipment_bonus = { surface_visibility = -0.05 sub_visibility = -0.05 }
    }

    # 日本专属：鱼雷再装填
    trait = {  
        token = JAP_beta_JAP_mio_trait_torpedo_reloads
        name = JAP_mio_trait_torpedo_reloads
        icon = GFX_generic_mio_department_icon_ship_screen_ship_offense
        special_trait_background = yes
        relative_position_id = JAP_beta_generic_mio_trait_raiding_submarines
        all_parents = { JAP_beta_generic_mio_trait_raiding_submarines }
        position = { x = 2 y = 1 } 
        # limit_to_equipment_type = { screen_ship submarine }
        equipment_bonus = { torpedo_attack = 0.1 }
        ai_will_do = { base = 2 }
    }

    trait = {
        token = JAP_beta_generic_mio_trait_spotting_tops
        name = generic_mio_trait_spotting_tops
        icon = GFX_generic_mio_trait_icon_surface_visibility        
        position = { x=1 y=1 }
        relative_position_id = JAP_beta_generic_mio_trait_raiding_cruisers
        all_parents = { JAP_beta_generic_mio_trait_raiding_cruisers JAP_beta_generic_mio_trait_raiding_submarines }
        limit_to_equipment_type = { capital_ship screen_ship }
        equipment_bonus = { surface_visibility = -0.05 }
    }

    trait = {
        token = JAP_beta_generic_mio_trait_large_torpedo_banks
        name = generic_mio_trait_large_torpedo_banks
        icon = GFX_generic_mio_trait_icon_torpedo_attack
        position = { x=1 y=1 }
        relative_position_id = JAP_beta_generic_mio_trait_raiding_submarines
        any_parent = { JAP_beta_generic_mio_trait_raiding_submarines }
        equipment_bonus = { torpedo_attack = 0.1 }
    }

    trait = {
        token = JAP_beta_generic_mio_trait_mass_produced_raiders
        name = generic_mio_trait_mass_produced_raiders
        icon = GFX_generic_mio_department_icon_ship_general_production
        position = { x=1 y=1 }
        relative_position_id = JAP_beta_generic_mio_trait_spotting_tops
        all_parents = { JAP_beta_generic_mio_trait_spotting_tops JAP_beta_generic_mio_trait_large_torpedo_banks }
        production_bonus = { production_capacity_factor = 0.075 }
    }
}
# JAP_hikari_naval_arsenal_organization = {
# 	include = generic_refurbishment_repair_organization
# 	icon = GFX_idea_JAP_hikari_naval_arsenal
# 	allowed = {	 
# 		original_tag = JAP
# 		has_dlc = "Arms Against Tyranny"
# 	}
	
# 	initial_trait = {
# 		organization_modifier = {
# 			military_industrial_organization_research_bonus = 0.15
# 			military_industrial_organization_funds_gain = 0.15
# 			military_industrial_organization_size_up_requirement = -0.15
# 		}
# 		production_bonus = {
# 			production_capacity_factor = 0.05
# 			production_cost_factor = -0.05
# 			production_efficiency_cap_factor = 0.05
# 			production_efficiency_gain_factor = 0.1
# 			production_resource_need_factor = -0.25
# 		}
# 	}
# }

# 整合后的潜艇 MIO：三菱神户造船厂
# 修正本地化索引后的 JAP 潜艇 MIO
JAP_mitsubishi_kobe_shipyard_organization = {
    icon = GFX_idea_JAP_kobe_shipyard

    allowed = { 
        OR = {
            AND = {
                original_tag = JAP 
                has_dlc = "Arms Against Tyranny"
            }
            PHI_SEA = yes
        }
    }

    available = {
        IF = {
            limit = { FROM = { NOT = { original_tag = JAP } } }
            FROM = { NOT = { has_war_with = JAP } }
        }
        
        IF = {
            limit = { FROM = { original_tag = PHI } }
            FROM = {
                has_completed_focus = PHI_align_with_japan
                if = {
                    limit = { has_completed_focus = PHI_declare_military_emergency }
                    NOT = { has_completed_focus = PHI_declare_military_emergency }
                }
            }
        }
    }

    equipment_type = { ship_hull_submarine }
    research_categories = { mio_cat_tech_all_submarine_and_modules }
    
    tree_header_text = { text = mio_header_stealth_focus x = 2 }
    tree_header_text = { text = mio_header_supremacy_focus x = 5 }

    initial_trait = {
        name = JAP_generic_mio_initial_trait_submarine_designer
        organization_modifier = {
            military_industrial_organization_research_bonus = 0.15
            military_industrial_organization_funds_gain = 0.15
            military_industrial_organization_size_up_requirement = -0.15
        }
		production_bonus = {
            production_capacity_factor = 0.05
            production_cost_factor = -0.05
            production_efficiency_cap_factor = 0.05
            production_efficiency_gain_factor = 0.1
            production_resource_need_factor = -0.25
        }
        equipment_bonus = { 
			sub_visibility = -0.05
			submarine_carrier_size = 2
		 }
    }

    # --- 隐蔽与推进分支 ---

    trait = {
        token = JAP_generic_mio_trait_long_range_raiding
        name = generic_mio_trait_long_range_raiding
        icon = GFX_generic_mio_trait_icon_sub_visibility
        position = { x=2 y=0 }
        # mutually_exclusive = { JAP_generic_mio_trait_decalin_fueled_torpedo }
        equipment_bonus = { sub_visibility = -0.05 }
    }

    trait = {
        token = JAP_generic_mio_trait_decalin_fueled_torpedo
        name = generic_mio_trait_decalin_fueled_torpedo
        icon = GFX_generic_mio_trait_icon_torpedo_attack
        position = { x=3 y=0 }
        relative_position_id = JAP_generic_mio_trait_long_range_raiding
        # mutually_exclusive = { JAP_generic_mio_trait_long_range_raiding }
        equipment_bonus = { torpedo_attack = 0.075 }
    }

    trait = {
        token = JAP_mio_trait_special_government_contracts_mitsubishi_trait
        name = mio_trait_special_government_contracts_mitsubishi_trait
        icon = GFX_generic_mio_trait_icon_efficiency_cap
        special_trait_background = yes
        relative_position_id = JAP_generic_mio_trait_decalin_fueled_torpedo
        position = { x = 2 y = 0 }  
        visible = { FROM = { original_tag = JAP } }
        available = {
            has_mio_size > 5
            FROM = { NOT = { has_country_flag = JAP_mio_trait_special_government_contracts_taken_flag } }
        }
        on_complete = {
            custom_effect_tooltip = mitsubishi_trait_will_not_be_available_in_other_organizations
            FROM = { set_country_flag = JAP_mio_trait_special_government_contracts_taken_flag }
            FROM = {
                remove_trait = { character = JAP_koyata_iwasaki slot = political_advisor trait = JAP_custom_mitsubishi_president }
                add_trait = { character = JAP_koyata_iwasaki slot = political_advisor trait = JAP_custom_mitsubishi_president_2 }
            }
        }
        organization_modifier = { military_industrial_organization_research_bonus = 0.02 }
        ai_will_do = { base = 2 }
    }

    trait = {
        token = JAP_mio_trait_zaibatsu_production_capabilities_trait
        name = zaibatsu_production_capabilities_trait
        icon = GFX_generic_mio_trait_icon_efficiency_gain
        special_trait_background = yes
        relative_position_id = JAP_generic_mio_trait_decalin_fueled_torpedo
        position = { x = 3 y = 0 }  
        visible = { FROM = { original_tag = JAP } }
        available = { FROM = { JAP_zaibatsu_faction_is_at_least_influential = yes } }
        production_bonus = { production_cost_factor = -0.05 production_capacity_factor = 0.05 }
        ai_will_do = { base = 2 }
    }

    trait = {
        token = JAP_mio_trait_strength_in_numbers
        name = strength_in_numbers
        icon = GFX_generic_mio_department_icon_facilities
        special_trait_background = yes
        relative_position_id = JAP_generic_mio_trait_decalin_fueled_torpedo
        position = { x = 4 y = 0 }  
        visible = { FROM = { original_tag = JAP } }
        available = {
            FROM = {
                has_completed_focus = JAP_seek_strength_in_numbers
                # NOT = { has_country_flag = JAP_mio_trait_strength_in_numbers_taken_flag }
            }
        }
        production_bonus = { production_capacity_factor = 0.1 }
        ai_will_do = { base = 2 }
    }

    # 菲律宾适配特质 (已剔除前缀)
    trait = {
        token = JAP_PHI_mio_trait_ethanol_fuel_adaptations
        name = PHI_mio_trait_ethanol_fuel_adaptations
        icon = GFX_generic_mio_trait_icon_fuel_consumption
        special_trait_background = yes
        position = { x = 9 y = 0 }  
        visible = { FROM = { original_tag = PHI } }
        equipment_bonus = { fuel_consumption = -0.05 }
        ai_will_do = { base = 2 }
    }

    trait = {
        token = JAP_PHI_mio_trait_coconut_fuel_adaptations
        name = PHI_mio_trait_coconut_fuel_adaptations
        icon = GFX_generic_mio_trait_icon_fuel_consumption
        special_trait_background = yes
        position = { x = 0 y = 1 }  
        visible = { FROM = { original_tag = PHI } }
        available = { FROM = { PHI_vicente_lava = { is_hired_as_advisor = yes } } }
        relative_position_id = JAP_PHI_mio_trait_ethanol_fuel_adaptations
        any_parent = { JAP_PHI_mio_trait_ethanol_fuel_adaptations }
        equipment_bonus = { fuel_consumption = -0.10 reliability = -0.05 }
        ai_will_do = { base = 2 }
    }

    trait = {
        token = JAP_generic_mio_trait_efficient_fuel_engines
        name = generic_mio_trait_efficient_fuel_engines
        icon = GFX_generic_mio_trait_icon_naval_range
        position = { x=1 y=1 }
        relative_position_id = JAP_generic_mio_trait_long_range_raiding
        all_parents = { JAP_generic_mio_trait_long_range_raiding }
        equipment_bonus = { naval_range = 0.1 }
    }

    trait = {
        token = JAP_generic_mio_trait_highly_efficient_diesel_electric_propulsion_systems
        name = generic_mio_trait_highly_efficient_diesel_electric_propulsion_systems
        icon = GFX_generic_mio_trait_icon_naval_range
        position = { x=0 y=1 }
        relative_position_id = JAP_generic_mio_trait_efficient_fuel_engines
        any_parent = { JAP_generic_mio_trait_high_powered_engines JAP_generic_mio_trait_efficient_fuel_engines }
        # mutually_exclusive = { JAP_generic_mio_trait_open_cycle_propulsion }
        equipment_bonus = { naval_range = 0.075 }
    }

    trait = {
        token = JAP_generic_mio_trait_high_powered_engines
        name = generic_mio_trait_high_powered_engines
        icon = GFX_generic_mio_trait_icon_maximum_speed
        position = { x=-1 y=1 }
        relative_position_id = JAP_generic_mio_trait_decalin_fueled_torpedo
        all_parents = { JAP_generic_mio_trait_decalin_fueled_torpedo }
        equipment_bonus = { naval_speed = 0.075 }
    }

    trait = {
        token = JAP_generic_mio_trait_open_cycle_propulsion
        name = generic_mio_trait_open_cycle_propulsion
        icon = GFX_generic_mio_trait_icon_maximum_speed
        position = { x=0 y=1 }
        relative_position_id = JAP_generic_mio_trait_high_powered_engines
        any_parent = { JAP_generic_mio_trait_high_powered_engines JAP_generic_mio_trait_efficient_fuel_engines }
        # mutually_exclusive = { JAP_generic_mio_trait_highly_efficient_diesel_electric_propulsion_systems }
        equipment_bonus = { naval_speed = 0.075 }
    }

    trait = {
        token = JAP_generic_mio_trait_experimental_anechoic_tiles
        name = generic_mio_trait_experimental_anechoic_tiles
        icon = GFX_generic_mio_department_icon_ship_submarine_survivability
        position = { x=0 y=1 }
        relative_position_id = JAP_generic_mio_trait_highly_efficient_diesel_electric_propulsion_systems
        any_parent = { JAP_generic_mio_trait_highly_efficient_diesel_electric_propulsion_systems JAP_generic_mio_trait_open_cycle_propulsion }
        equipment_bonus = { surface_visibility = -0.05 sub_visibility = -0.05 build_cost_ic = 0.05 }
    }

    trait = {
        token = JAP_generic_mio_trait_improved_torpedo_detonators
        name = generic_mio_trait_improved_torpedo_detonators
        icon = GFX_generic_mio_trait_icon_torpedo_attack
        position = { x=0 y=1 }
        relative_position_id = JAP_generic_mio_trait_open_cycle_propulsion
        any_parent = { JAP_generic_mio_trait_highly_efficient_diesel_electric_propulsion_systems JAP_generic_mio_trait_open_cycle_propulsion }
        equipment_bonus = { torpedo_attack = 0.075 }
    }

    trait = {
        token = JAP_generic_mio_trait_simplified_pressure_hull_design
        name = generic_mio_trait_simplified_pressure_hull_design
        icon = GFX_generic_mio_department_icon_ship_submarine_production
        position = { x=1 y=1 }
        relative_position_id = JAP_generic_mio_trait_experimental_anechoic_tiles
        all_parents = { JAP_generic_mio_trait_experimental_anechoic_tiles JAP_generic_mio_trait_improved_torpedo_detonators }
        production_bonus = { production_capacity_factor = 0.1 }
    }

    # --- 探测与生存分支 ---

    trait = {
        token = JAP_generic_mio_trait_advanced_periscope
        name = generic_mio_trait_advanced_periscope
        icon = GFX_generic_mio_trait_icon_surface_detection
        position = { x=-1 y=2 }
        relative_position_id = JAP_generic_mio_trait_long_range_raiding
        all_parents = { JAP_generic_mio_trait_long_range_raiding }
        equipment_bonus = { surface_detection = 0.05 }
    }

    trait = {
        token = JAP_generic_mio_trait_emergency_main_ballast_tank_blow
        name = generic_mio_trait_emergency_main_ballast_tank_blow
        icon = GFX_generic_mio_trait_icon_max_strength
        position = { x=-1 y=1 }
        relative_position_id = JAP_generic_mio_trait_advanced_periscope
        all_parents = { JAP_generic_mio_trait_advanced_periscope }
        equipment_bonus = { max_strength = 0.05 naval_speed = 0.05 }
    }

    trait = {
        token = JAP_generic_mio_trait_radar_warning_receiver
        name = generic_mio_trait_radar_warning_receiver
        icon = GFX_generic_mio_trait_icon_sub_visibility
        position = { x=1 y=1 }
        relative_position_id = JAP_generic_mio_trait_advanced_periscope
        all_parents = { JAP_generic_mio_trait_advanced_periscope }
        equipment_bonus = { sub_visibility = -0.05 }
    }

    trait = {
        token = JAP_generic_mio_trait_crash_dive_flood_tanks
        name = generic_mio_trait_crash_dive_flood_tanks
        icon = GFX_generic_mio_trait_icon_max_strength
        position = { x=1 y=1 }
        relative_position_id = JAP_generic_mio_trait_emergency_main_ballast_tank_blow
        all_parents = { JAP_generic_mio_trait_emergency_main_ballast_tank_blow JAP_generic_mio_trait_radar_warning_receiver }
        equipment_bonus = { max_strength = 0.1 sub_visibility = -0.025 }
    }

    # --- 生产与武装分支 ---

    trait = {
        token = JAP_generic_mio_trait_submarine_mass_production
        name = generic_mio_trait_submarine_mass_production
        icon = GFX_generic_mio_department_icon_ship_submarine_production
        position = { x=0 y=2 }
        relative_position_id = JAP_generic_mio_trait_decalin_fueled_torpedo
        all_parents = { JAP_generic_mio_trait_decalin_fueled_torpedo }
        production_bonus = { production_capacity_factor = 0.075 }
    }

    trait = {
        token = JAP_generic_mio_trait_advanced_sonar
        name = generic_mio_trait_advanced_sonar
        icon = GFX_generic_mio_trait_icon_surface_detection
        position = { x=2 y=0 }
        relative_position_id = JAP_generic_mio_trait_submarine_mass_production
        all_parents = { JAP_generic_mio_trait_decalin_fueled_torpedo }
        limit_to_equipment_type = { ship_hull_submarine }
        equipment_bonus = { surface_detection = 0.075 }
    }

    trait = {
        token = JAP_generic_mio_trait_deck_guns
        name = generic_mio_trait_deck_guns
        icon = GFX_generic_mio_trait_icon_max_strength
        position = { x=1 y=1 }
        relative_position_id = JAP_generic_mio_trait_submarine_mass_production
        all_parents = { JAP_generic_mio_trait_submarine_mass_production JAP_generic_mio_trait_advanced_sonar }
        equipment_bonus = { max_strength = 0.1 }
    }

    trait = {
        token = JAP_generic_mio_trait_large_torpedo_banks
        name = generic_mio_trait_large_torpedo_banks
        icon = GFX_generic_mio_trait_icon_torpedo_attack
        position = { x=1 y=1 }
        relative_position_id = JAP_generic_mio_trait_advanced_sonar
        all_parents = { JAP_generic_mio_trait_advanced_sonar }
        equipment_bonus = { torpedo_attack = 0.075 }
    }

    trait = {
        token = JAP_generic_mio_trait_high_capacity_mine_storage
        name = generic_mio_trait_high_capacity_mine_storage
        icon = GFX_generic_mio_trait_icon_mines
        position = { x=1 y=1 }
        relative_position_id = JAP_generic_mio_trait_deck_guns
        any_parent = { JAP_generic_mio_trait_deck_guns JAP_generic_mio_trait_large_torpedo_banks }
        visible = { has_dlc = "Man the Guns" }
        equipment_bonus = { mines_planting = 0.2 }
    }
}

###########################

###  #    ##  #  # ###  ## 
#  # #   #  # ## # #   #   
###  #   #### # ## ##   #  
#    #   #  # #  # #     # 
#    ### #  # #  # ### ##  

###########################

#高机动
JAP_mitsubishi_organization = {
    include = JAP_generic_high_agility_fighter_aircraft_organization # 包含已修改前缀的模板 
    icon = GFX_idea_JAP_mitsubishi_airplanes
    
    allowed = {  
        OR = {
            original_tag = JAP 
            AND = {
                original_tag = ETH
                has_dlc = "By Blood Alone"
            }
            PHI_SEA = yes
        }
        has_dlc = "Arms Against Tyranny"
    }
    
    visible = {
        IF = {
            limit = {
                FROM = { original_tag = ETH }
            }
            FROM = { has_completed_focus = ETH_invite_foreign_industrialists }
        }
    }
    
    available = {
        # 当作为外国MIO时，国家需要与原产国保持和平 [cite: 1]
        IF = {
            limit = {
                FROM = { NOT = { original_tag = JAP } }
            }
            FROM = { NOT = { has_war_with = JAP } }
        }

        IF = {
            limit = {
                FROM = { original_tag = ETH }
            }
            custom_trigger_tooltip = {
                tooltip = has_invited_mio_tt
                FROM = {
                    has_country_flag = has_invited_JAP_mitsubishi_organization_flag
                }
            }
        }

        IF = {
            limit = {
                FROM = {
                    original_tag = PHI
                }
            }
            FROM = {
                has_completed_focus = PHI_align_with_japan
                if = {
                    limit = {
                        has_completed_focus = PHI_declare_military_emergency
                    }
                    NOT = {
                        has_completed_focus = PHI_declare_military_emergency
                    }
                }
            }
        }
    }

    # 财阀生产能力性状
    add_trait = {
        token = JAP_mio_trait_zaibatsu_production_capabilities_trait
        name = JAP_mio_trait_zaibatsu_production_capabilities_trait
        icon = GFX_generic_mio_trait_icon_efficiency_gain
        special_trait_background = yes

        # 已同步前缀 
        relative_position_id = JAP_generic_mio_trait_minimum_weapon_requirements

        position = { x = 1 y = 0 }  
        
        visible = {
            FROM = { original_tag = JAP }
        }

        available = {
            always = yes
        }

        on_complete = {
            ROOT = {
                JAP_small_zaibatsu_faction_gain = yes
            }
        }

        production_bonus = {
            production_cost_factor = -0.05
            production_capacity_factor = 0.05
        }

        ai_will_do = {
            base = 2
        }
    }

    # 三菱特别政府合同
    add_trait = {
        token = JAP_mio_trait_special_government_contracts_mitsubishi_trait
        name = JAP_mio_trait_special_government_contracts_mitsubishi_trait
        icon = GFX_generic_mio_trait_icon_efficiency_cap
        special_trait_background = yes

        # 已同步前缀 
        relative_position_id = JAP_generic_mio_trait_minimum_weapon_requirements

        position = { x = 2 y = 1 }  
        
        visible = {
            FROM = { original_tag = JAP }
        }

        available = {
            has_mio_size > 5
            FROM = {
                NOT = { has_country_flag = JAP_mio_trait_special_government_contracts_taken_flag }
            }
        }

        on_complete = {
            custom_effect_tooltip = generic_trait_will_not_be_available_in_other_organizations
            FROM = {
                set_country_flag = JAP_mio_trait_special_government_contracts_taken_flag 
            }
            custom_effect_tooltip = generic_skip_one_line_tt
            FROM = {
                remove_trait = {
                    character = JAP_koyata_iwasaki
                    slot = political_advisor
                    trait = JAP_custom_mitsubishi_president
                }
                custom_effect_tooltip = generic_skip_one_line_tt
                add_trait = {
                    character = JAP_koyata_iwasaki
                    slot = political_advisor
                    trait = JAP_custom_mitsubishi_president_2
                }
            }
        }

        organization_modifier = {
            military_industrial_organization_research_bonus = 0.02
        }

        ai_will_do = {
            base = 2
        }
    }

    # 统一研发
    add_trait = {
        token = JAP_mio_trait_unified_research_and_development
        name = JAP_mio_trait_unified_research_and_development
        icon = GFX_generic_mio_department_icon_facilities
        special_trait_background = yes

        # 已同步前缀 
        relative_position_id = JAP_generic_mio_trait_minimum_weapon_requirements

        position = { x = 2 y = 0 }  
        
        visible = {
            FROM = { original_tag = JAP }
        }

        available = {
            FROM = {
                has_completed_focus = JAP_sea_unify_the_air_forces
                NOT = { has_country_flag = JAP_mio_trait_unified_research_and_development_taken_flag }
            }
        }

        on_complete = {
            # custom_effect_tooltip = generic_trait_will_not_be_available_in_other_organizations
            # FROM = {
            #     set_country_flag = JAP_mio_trait_unified_research_and_development_taken_flag
            # }
        }

        organization_modifier = {
            military_industrial_organization_research_bonus = 0.15
        }

        production_bonus = {
            production_capacity_factor = 0.1
        }

        ai_will_do = {
            base = 200
        }
    }

    # 菲律宾专属性状
    add_trait = {
        token = PHI_mio_trait_engine_filters
        name = PHI_mio_trait_engine_filters
        icon = GFX_generic_mio_trait_icon_reliability
        special_trait_background = yes

        position = { x = 1 y = 1 }  
        
        visible = {
            FROM = { original_tag = PHI }
        }

        # 已同步前缀 
        relative_position_id = JAP_generic_mio_trait_fabric_skin
        any_parent = { JAP_generic_mio_trait_fabric_skin JAP_generic_mio_trait_metal_skin }

        equipment_bonus = {
            reliability = 0.10
        }

        ai_will_do = {
            base = 2
        }
    }
}

JAP_aichi_organization = {
	include = generic_range_focused_aircraft_organization
	icon = GFX_idea_aichi
	allowed = {	
		original_tag = JAP
		has_dlc = "Arms Against Tyranny"
        always = no
	}
	available = {
		
	}
 
	initial_trait = {
		organization_modifier = {
			military_industrial_organization_research_bonus = 0.15
			military_industrial_organization_funds_gain = 0.15
			military_industrial_organization_size_up_requirement = -0.15
		}
		production_bonus = {
			production_capacity_factor = 0.05
			production_cost_factor = -0.05
			production_efficiency_cap_factor = 0.05
			production_efficiency_gain_factor = 0.1
			production_resource_need_factor = -0.25
		}
	}

	add_trait = {
		token = JAP_mio_trait_unified_research_and_development
		name = JAP_mio_trait_unified_research_and_development
		icon = GFX_generic_mio_department_icon_facilities
		special_trait_background = yes

		relative_position_id = generic_mio_trait_extra_cargo_doors

		position = { x = -1 y = 0 }  
		
		visible = {
			FROM = { original_tag = JAP }
		}

		available = {
			FROM = {
				has_completed_focus = JAP_sea_unify_the_air_forces
				NOT = { has_country_flag = JAP_mio_trait_unified_research_and_development_taken_flag }
			}
		}

		on_complete = {
			custom_effect_tooltip = generic_trait_will_not_be_available_in_other_organizations
			FROM = {
				set_country_flag = JAP_mio_trait_unified_research_and_development_taken_flag
			}
		}

		organization_modifier = {
		    military_industrial_organization_research_bonus = 0.15
		}

		production_bonus = {
			production_capacity_factor = 0.1
		}

		ai_will_do = {
			base = 2
		}
	}

}
#重型
JAP_nakajima_organization = {
    include = JAP_generic_heavy_aircraft_organization # 包含已修改前缀的模板 [cite: 6]
    icon = GFX_idea_nakajima
    allowed = { 
        original_tag = JAP
        has_dlc = "Arms Against Tyranny"
    }

    # 中岛特别政府合同
    add_trait = {
        token = JAP_mio_trait_special_government_contracts_nakajima_trait
        name = JAP_mio_trait_special_government_contracts_nakajima_trait
        icon = GFX_generic_mio_trait_icon_efficiency_cap
        special_trait_background = yes

        # 已同步前缀 [cite: 6]
        relative_position_id = JAP_generic_mio_trait_extended_rear_fuselage

        position = { x = -3 y = 0 }  
        
        visible = {
            FROM = { original_tag = JAP }
        }

        available = {
            has_mio_size > 5
        }

        on_complete = {
            FROM = {
                remove_trait = {
                    character = JAP_chikuhei_nakajima
                    slot = political_advisor
                    trait = JAP_nakajima_president
                }
                custom_effect_tooltip = generic_skip_one_line_tt
                add_trait = {
                    character = JAP_chikuhei_nakajima
                    slot = political_advisor
                    trait = JAP_nakajima_president_2
                }
            }
        }

        organization_modifier = {
            military_industrial_organization_research_bonus = 0.02
        }

        ai_will_do = {
            base = 2
        }
    }

    # 财阀生产能力
    add_trait = {
        token = JAP_mio_trait_zaibatsu_production_capabilities_trait
        name = JAP_mio_trait_zaibatsu_production_capabilities_trait
        icon = GFX_generic_mio_trait_icon_efficiency_gain
        special_trait_background = yes

        # 已同步前缀 [cite: 6]
        relative_position_id = JAP_generic_mio_trait_extended_rear_fuselage

        position = { x = -1 y = 0 }  
        
        visible = {
            FROM = { original_tag = JAP }
        }

        available = {
            FROM = {
                JAP_zaibatsu_faction_is_at_least_influential = yes
            }
        }

        production_bonus = {
            production_cost_factor = -0.05
            production_capacity_factor = 0.05
        }

        ai_will_do = {
            base = 2
        }
    }

    # 统一研发
    add_trait = {
        token = JAP_mio_trait_unified_research_and_development
        name = JAP_mio_trait_unified_research_and_development
        icon = GFX_generic_mio_department_icon_facilities
        special_trait_background = yes

        # 已同步前缀 [cite: 6]
        relative_position_id = JAP_generic_mio_trait_extended_rear_fuselage

        position = { x = 1 y = 0 }  
        
        visible = {
            FROM = { original_tag = JAP }
        }

        available = {
            FROM = {
                has_completed_focus = JAP_sea_unify_the_air_forces
                NOT = { has_country_flag = JAP_mio_trait_unified_research_and_development_taken_flag }
            }
        }

        organization_modifier = {
            military_industrial_organization_research_bonus = 0.15
        }

        production_bonus = {
            production_capacity_factor = 0.1
        }

        ai_will_do = {
            base = 2
        }
    }
}
##舰载机
JAP_yokosuka_organization = {
    include = JAP_generic_naval_aircraft_organization 
    icon = GFX_idea_yokosuka
    allowed = { 
        original_tag = JAP
        has_dlc = "Arms Against Tyranny"
    }

    # 九一式航空鱼雷集成
    add_trait = {
        token = JAP_mio_trait_type_91_aerial_torpedo_integration
        name = JAP_mio_trait_type_91_aerial_torpedo_integration
        icon = GFX_generic_mio_trait_icon_air_ground_attack
        special_trait_background = yes

        # 已同步前缀
        relative_position_id = JAP_generic_mio_trait_navigation_equipment
        all_parents = { JAP_generic_mio_trait_navigation_equipment }

        position = { x = 2 y = 1 }  
        
        visible = {
            FROM = { original_tag = JAP }
        }

        available = {
            FROM = {
                has_completed_focus = JAP_improve_the_type_91_aerial_torpedo
            }
        }

        on_complete = {
        }

        equipment_bonus = {
            naval_strike_attack = 0.1
            naval_strike_targetting = 0.05
        }

        ai_will_do = {
            base = 5
        }
    }

    # 海军工厂特质
    add_trait = {
        token = JAP_mio_trait_naval_arsenal_trait
        name = JAP_mio_trait_naval_arsenal_trait
        icon = GFX_generic_mio_trait_icon_production_capacity
        special_trait_background = yes

        # 已同步前缀
        relative_position_id = JAP_generic_mio_trait_navigation_equipment

        position = { x = 4 y = 0 }  
        
        visible = {
            FROM = { original_tag = JAP }
        }

        available = {
            FROM = {
                JAP_naval_faction_is_not_subdued = yes
            }
        }

        on_complete = {
            
        }

        organization_modifier = {
            
        }

        production_bonus = {
            production_capacity_factor = 0.05
        }

        ai_will_do = {
            base = 2
        }
    }

    # 统一研发
    add_trait = {
        token = JAP_mio_trait_unified_research_and_development
        name = JAP_mio_trait_unified_research_and_development
        icon = GFX_generic_mio_department_icon_facilities
        special_trait_background = yes

        # 已同步前缀
        relative_position_id = JAP_generic_mio_trait_navigation_equipment

        position = { x = 5 y = 0 }  
        
        visible = {
            FROM = { original_tag = JAP }
        }

        available = {
            FROM = {
                has_completed_focus = JAP_sea_unify_the_air_forces
                NOT = { has_country_flag = JAP_mio_trait_unified_research_and_development_taken_flag }
            }
        }

        on_complete = {
            # custom_effect_tooltip = generic_trait_will_not_be_available_in_other_organizations
            # FROM = {
            #     set_country_flag = JAP_mio_trait_unified_research_and_development_taken_flag
            # }
        }

        organization_modifier = {
            military_industrial_organization_research_bonus = 0.15
        }

        production_bonus = {
            production_capacity_factor = 0.1
        }

        ai_will_do = {
            base = 2
        }
    }
}

JAP_kawanishi_aircraft_company_organization = {
	include = generic_multi_role_aircraft_organization
	icon = GFX_idea_JAP_kawanishi
	allowed = {	
		original_tag = JAP
		has_dlc = "Arms Against Tyranny"
        always = no
	}
 
	initial_trait = {
		organization_modifier = {
			military_industrial_organization_research_bonus = 0.15
			military_industrial_organization_funds_gain = 0.15
			military_industrial_organization_size_up_requirement = -0.15
		}
		production_bonus = {
			production_capacity_factor = 0.05
			production_cost_factor = -0.05
			production_efficiency_cap_factor = 0.05
			production_efficiency_gain_factor = 0.1
			production_resource_need_factor = -0.25
		}
	}

	add_trait = {
		token = JAP_mio_trait_unified_research_and_development
		name = JAP_mio_trait_unified_research_and_development
		icon = GFX_generic_mio_department_icon_facilities
		special_trait_background = yes

		relative_position_id = generic_mio_trait_escort_designs

		position = { x = 3 y = 0 }  
		
		visible = {
			FROM = { original_tag = JAP }
		}

		available = {
			FROM = {
				has_completed_focus = JAP_sea_unify_the_air_forces
				NOT = { has_country_flag = JAP_mio_trait_unified_research_and_development_taken_flag }
			}
		}

		on_complete = {
			custom_effect_tooltip = generic_trait_will_not_be_available_in_other_organizations
			FROM = {
				set_country_flag = JAP_mio_trait_unified_research_and_development_taken_flag
			}
		}

		organization_modifier = {
		    military_industrial_organization_research_bonus = 0.15
		}

		production_bonus = {
			production_capacity_factor = 0.1
		}

		ai_will_do = {
			base = 2
		}
	}

}
##中型飞机
JAP_kawasaki_aircraft_industries_organization = {
    # 包含已修改前缀的模板 [cite: 6]
    include = JAP_generic_medium_aircraft_organization
    icon = GFX_idea_JAP_kawasaki_aircraft
    allowed = { 
        original_tag = JAP
        has_dlc = "Arms Against Tyranny"
    }

    # 财阀生产能力特质
    add_trait = {
        token = JAP_mio_trait_zaibatsu_production_capabilities_trait
        name = JAP_mio_trait_zaibatsu_production_capabilities_trait
        icon = GFX_generic_mio_trait_icon_efficiency_gain
        special_trait_background = yes

        # 已同步修改前缀 [cite: 6]
        relative_position_id = JAP_generic_mio_trait_skip_bombing

        position = { x = -1 y = 0 }  
        
        visible = {
            FROM = { original_tag = JAP }
        }

        available = {
            FROM = {
                JAP_zaibatsu_faction_is_at_least_influential = yes
            }
        }

        on_complete = {
            
        }

        production_bonus = {
            production_cost_factor = -0.05
        }

        production_bonus = {
            production_capacity_factor = 0.05
        }

        ai_will_do = {
            base = 2
        }
    }

    # 统一研发特质
    add_trait = {
        token = JAP_mio_trait_unified_research_and_development
        name = JAP_mio_trait_unified_research_and_development
        icon = GFX_generic_mio_department_icon_facilities
        special_trait_background = yes

        # 已同步修改前缀 [cite: 6]
        relative_position_id = JAP_generic_mio_trait_skip_bombing

        position = { x = 1 y = 0 }  
        
        visible = {
            FROM = { original_tag = JAP }
        }

        available = {
            FROM = {
                has_completed_focus = JAP_sea_unify_the_air_forces
                NOT = { has_country_flag = JAP_mio_trait_unified_research_and_development_taken_flag }
            }
        }

        on_complete = {
            # custom_effect_tooltip = generic_trait_will_not_be_available_in_other_organizations
            # FROM = {
            #     set_country_flag = JAP_mio_trait_unified_research_and_development_taken_flag
            # }
        }

        organization_modifier = {
            military_industrial_organization_research_bonus = 0.15
        }

        production_bonus = {
            production_capacity_factor = 0.1
        }

        ai_will_do = {
            base = 2
        }
    }

}
#CAS设计商
JAP_tachikawa_aircraft_company_organization = {
	include = JAP_generic_cas_aircraft_organization
	icon = GFX_idea_JAP_tachikawa_aircraft_company
	
	allowed = {	 
		original_tag = JAP
		has_dlc = "Arms Against Tyranny"
	}

	# initial_trait = {
	# 	name = JAP_mio_trait_army_aircraft_manufacturer
		
	# 	limit_to_equipment_type = { 
	# 		small_plane_cas_airframe
	# 	}
		
	# 	production_bonus = {
	# 		production_capacity_factor = 0.03
	# 	}

	# 	equipment_bonus = {
	# 		air_ground_attack = 0.02
	# 	}

	# }

	add_trait = {
		token = JAP_mio_trait_unified_research_and_development
		name = JAP_mio_trait_unified_research_and_development
		icon = GFX_generic_mio_department_icon_facilities
		special_trait_background = yes

		relative_position_id = generic_mio_heat_bombs

		position = { x = 2 y = 0 }  
		
		visible = {
			FROM = { original_tag = JAP }
		}

		available = {
			FROM = {
				has_completed_focus = JAP_sea_unify_the_air_forces
				NOT = { has_country_flag = JAP_mio_trait_unified_research_and_development_taken_flag }
			}
		}

		# on_complete = {
		# 	custom_effect_tooltip = generic_trait_will_not_be_available_in_other_organizations
		# 	FROM = {
		# 		set_country_flag = JAP_mio_trait_unified_research_and_development_taken_flag
		# 	}
		# }

		organization_modifier = {
		    military_industrial_organization_research_bonus = 0.15
		}

		production_bonus = {
			production_capacity_factor = 0.1
		}

		ai_will_do = {
			base = 2
		}
	}

}



################################### 

#   #  ##  ### ### ###  ### ### #   
## ## #  #  #  #   #  #  #  #   #   
# # # ####  #  ##  ###   #  ##  #   
#   # #  #  #  #   #  #  #  #   #   
#   # #  #  #  ### #  # ### ### ### 


###################################

JAP_kokura_arsenal_organization = {
	include = generic_infantry_equipment_organization
	icon = GFX_idea_tokyo_arsenal
	allowed = {	
		OR = {
			AND = {
				original_tag = JAP
				has_dlc = "Arms Against Tyranny"
			}
			PHI_SEA = yes
		}

	}

	available = {
		IF = {
			limit = {
				FROM = { NOT = { original_tag = JAP } }
			}
			FROM = { NOT = { has_war_with = JAP } }
		}
		
		IF = {
			limit = {
				FROM = {
					original_tag = PHI
				}
			}
			FROM = {
				has_completed_focus = PHI_align_with_japan
				if = {
					limit = {
						has_completed_focus = PHI_declare_military_emergency
					}
					NOT = {
						has_completed_focus = PHI_declare_military_emergency
					}
				}
			}
		}
	}
	initial_trait = {
		organization_modifier = {
            military_industrial_organization_research_bonus = 0.15
            military_industrial_organization_funds_gain = 0.15
            military_industrial_organization_size_up_requirement = -0.15
        }
		production_bonus = {
            production_capacity_factor = 0.05
            production_cost_factor = -0.05
            production_efficiency_cap_factor = 0.05
            production_efficiency_gain_factor = 0.1
            production_resource_need_factor = -0.25
        }
	}
	add_trait = {
		token = JAP_mio_trait_military_arsenal_trait
		name = JAP_mio_trait_military_arsenal_trait
		icon = GFX_generic_mio_trait_icon_production_capacity
		special_trait_background = yes

		relative_position_id = generic_mio_trait_heavy_anti_armor_ammunition

		position = { x = 1 y = 0 }  
		
		visible = {
			FROM = { original_tag = JAP }
		}

		available = {
			FROM = {
				JAP_army_faction_is_not_subdued = yes
			}
		}

		on_complete = {
			
		}

		organization_modifier = {
		    
		}

		production_bonus = {
			production_capacity_factor = 0.05
		}

		ai_will_do = {
			base = 2
		}
	}

	add_trait = { 
		token = PHI_mio_trait_rugged_construction
		name = PHI_mio_trait_rugged_construction
		icon = GFX_generic_mio_trait_icon_reliability
		special_trait_background = yes

		position = { x=0 y=0 }  

		visible = {
			FROM = {
				original_tag = PHI
			}
		}

		equipment_bonus = {
			reliability = 0.05
		}
	}

	add_trait = { 
		token = PHI_mio_trait_use_local_materials
		name = PHI_mio_trait_use_local_materials
		icon = GFX_generic_mio_department_icon_facilities
		special_trait_background = yes

		position = { x=0 y=1 }  

		visible = {
			FROM = {
				original_tag = PHI
			}
		}

		any_parent = { PHI_mio_trait_rugged_construction }

		production_bonus = { 
			production_cost_factor = -0.05 
		}
	}

}

JAP_osaka_army_arsenal_artillery_organization = {
	include = generic_artillery_organization
	icon = GFX_idea_osaka_army_arsenal
	allowed = {	
		original_tag = JAP
		has_dlc = "Arms Against Tyranny"
	}
	initial_trait = {
		organization_modifier = {
            military_industrial_organization_research_bonus = 0.15
            military_industrial_organization_funds_gain = 0.15
            military_industrial_organization_size_up_requirement = -0.15
        }
		production_bonus = {
            production_capacity_factor = 0.05
            production_cost_factor = -0.05
            production_efficiency_cap_factor = 0.05
            production_efficiency_gain_factor = 0.1
            production_resource_need_factor = -0.25
        }
	}
	add_trait = {
		token = JAP_mio_trait_military_arsenal_trait
		name = JAP_mio_trait_military_arsenal_trait
		icon = GFX_generic_mio_trait_icon_production_capacity
		special_trait_background = yes

		relative_position_id = generic_mio_trait_big_guns

		position = { x = 1 y = 0 }  
		
		visible = {
			FROM = { original_tag = JAP }
		}

		available = {
			FROM = {
				JAP_army_faction_is_not_subdued = yes
			}
		}

		on_complete = {
			
		}

		organization_modifier = {
		    
		}

		production_bonus = {
			production_capacity_factor = 0.05
		}

		ai_will_do = {
			base = 2
		}
	}

} 
#机械化
JAP_nissan_organization = {
	include = generic_motorized_mechanized_organization 
	icon = GFX_idea_nissan
	allowed = {	 
		OR = {
			original_tag = JAP 
			AND = {
				original_tag = ETH
				has_dlc = "By Blood Alone"
			}
			AND = {
				original_tag = MAN
				has_dlc = "No Compromise, No Surrender"
			}
			PHI_SEA = yes
		}
		has_dlc = "Arms Against Tyranny"
	}
	
	visible = {
		IF = {
			limit = {
				FROM = { original_tag = ETH }
			}
			FROM = { has_completed_focus = ETH_invite_foreign_industrialists }
		}
		IF = {
			limit = {
				FROM = { original_tag = MAN }
			}
			FROM = { has_completed_focus = MAN_tsr_strengthen_ties_with_nissan }
		}
	}
	
	available = {
		# When in a Foreign MIO, countries need to be at peace with original country
		IF = {
			limit = {
				FROM = { NOT = { original_tag = JAP } }
			}
			FROM = { NOT = { has_war_with = JAP } }
		}

		IF = {
			limit = {
				FROM = { original_tag = ETH }
			}
			custom_trigger_tooltip = {
				tooltip = has_invited_mio_tt
				FROM = {
					has_country_flag = has_invited_JAP_nissan_organization_flag
				}
			}
		}

		IF = {
			limit = {
				FROM = {
					original_tag = PHI
				}
			}
			FROM = {
				has_completed_focus = PHI_align_with_japan
				if = {
					limit = {
						has_completed_focus = PHI_declare_military_emergency
					}
					NOT = {
						has_completed_focus = PHI_declare_military_emergency
					}
				}
			}
		}
	}
    research_categories = {
        mio_cat_tech_all_motorized_mechanized
    }
    equipment_type = {
     motorized_equipment #摩托化
	 mechanized_equipment #机械化
	 amphibious_mechanized_equipment #水陆车
     motorized_rocket_equipment
    }
	initial_trait = {
		organization_modifier = {
            military_industrial_organization_research_bonus = 0.15
            military_industrial_organization_funds_gain = 0.15
            military_industrial_organization_size_up_requirement = -0.15
        }
		production_bonus = {
            production_capacity_factor = 0.05
            production_cost_factor = -0.05
            production_efficiency_cap_factor = 0.05
            production_efficiency_gain_factor = 0.1
            production_resource_need_factor = -0.25
        }
		equipment_bonus = {
			reliability = 0.1
		}

	}
	##
	override_trait = {
		token = generic_mio_trait_medium_machinegun_mounts

		name = AUS_mio_trait_improved_suspensions

		equipment_bonus = {
			maximum_speed = 0.1
		}
	}

	override_trait = {
		token = generic_mio_trait_attached_wood_gas_generator

		name = AUS_mio_trait_fuel_effeicient_engines

		position = { x=-1 y=2 }
		relative_position_id = generic_mio_trait_medium_machinegun_mounts

		all_parents = { generic_mio_trait_medium_machinegun_mounts }
	}

	override_trait = {
		token = generic_mio_trait_high_powered_engine

		position = { x=1 y=2 }
		relative_position_id = generic_mio_trait_medium_machinegun_mounts

		all_parents = { generic_mio_trait_medium_machinegun_mounts }
	}

	override_trait = {
		token = generic_mio_trait_advanced_artillery_racks

		position = { x=0 y=2 }
		relative_position_id = generic_mio_trait_attached_wood_gas_generator

		any_parent = { generic_mio_trait_attached_wood_gas_generator generic_mio_trait_high_powered_engine }
        ai_will_do = {
            base = -10
        }
	}

	override_trait = {
		token = generic_mio_trait_heavy_machinegun_mount

		position = { x=2 y=2 }
		relative_position_id = generic_mio_trait_attached_wood_gas_generator

		any_parent = { generic_mio_trait_attached_wood_gas_generator generic_mio_trait_high_powered_engine }
	}

	add_trait = {
		token = AUS_mio_trait_thorough_construction
		name = AUS_mio_trait_thorough_construction
		icon = GFX_generic_mio_trait_icon_hardness
		special_trait_background = yes

		mutually_exclusive = { AUS_mio_trait_modular_construction }

		position = {x=-1 y=2}
		relative_position_id = generic_mio_trait_all_wheel_drive

		all_parents = { generic_mio_trait_all_wheel_drive }

		equipment_bonus = {
			hardness = 0.05
			reliability = 0.05
			build_cost_ic = 0.05
		}
		ai_will_do = {
			base = -20
		}

	}

	add_trait = {
		token = AUS_mio_trait_modular_construction
		name = AUS_mio_trait_modular_construction
		icon = GFX_generic_mio_trait_icon_build_cost_ic
		special_trait_background = yes

		mutually_exclusive = { AUS_mio_trait_thorough_construction }

		position = {x=1 y=2}
		relative_position_id = generic_mio_trait_all_wheel_drive

		all_parents = { generic_mio_trait_all_wheel_drive }

		equipment_bonus = {
			build_cost_ic = -0.15
			reliability = -0.05
		}
		ai_will_do = {
			base = 20
		}
	}
	##
	add_trait = {
		token = JAP_mio_trait_special_government_contracts_nissan_trait
		name = JAP_mio_trait_special_government_contracts_nissan_trait
		icon = GFX_generic_mio_trait_icon_efficiency_cap
		special_trait_background = yes

		relative_position_id = generic_mio_trait_closed_chassi

		position = { x = 1 y = 2 }  
		
		visible = {
			FROM = { original_tag = JAP }
		}

		available = {
			has_mio_size > 5
		}

		on_complete = {
			FROM = {
				remove_trait = {
				    character = JAP_yoshisuke_aikawa
				    slot = political_advisor
				    trait = JAP_nissan_president
				}
				custom_effect_tooltip = generic_skip_one_line_tt
				add_trait = {
				    character = JAP_yoshisuke_aikawa
				    slot = political_advisor
				    trait = JAP_nissan_president_2
				}
			}
		}

		organization_modifier = {
		    military_industrial_organization_research_bonus = 0.02
		}

		production_bonus = {
			
		}

		ai_will_do = {
			base = 2
		}
	}

	add_trait = {
		token = JAP_mio_trait_zaibatsu_production_capabilities_trait
		name = JAP_mio_trait_zaibatsu_production_capabilities_trait
		icon = GFX_generic_mio_trait_icon_efficiency_gain
		special_trait_background = yes

		relative_position_id = generic_mio_trait_closed_chassi

		position = { x = 1 y = 1 }  
		
		visible = {
			FROM = { original_tag = JAP }
		}

		available = {
			FROM = {
				JAP_zaibatsu_faction_is_at_least_influential = yes
			}
		}

		on_complete = {
			
		}

		production_bonus = {
			production_cost_factor = -0.05
		}

		production_bonus = {
			production_capacity_factor = 0.05
		}

		ai_will_do = {
			base = 2
		}
	}

	add_trait = {
		token = JAP_mio_trait_cooperation_with_kurogane
		name = JAP_mio_trait_cooperation_with_kurogane
		icon = GFX_generic_mio_department_icon_facilities
		special_trait_background = yes

		relative_position_id = generic_mio_trait_closed_chassi

		position = { x = 1 y = 0 }  
		
		visible = {
			FROM = { original_tag = JAP }
		}

		available = {
			
		}

		on_complete = {
		}

		production_bonus = {
			production_capacity_factor = 0.1
		}

		ai_will_do = {
			base = 2
		}
	}

	add_trait = {
		token = PHI_mio_trait_ethanol_fuel_adaptations
		name = PHI_mio_trait_ethanol_fuel_adaptations
		icon = GFX_generic_mio_trait_icon_fuel_consumption
		special_trait_background = yes

		position = { x = 9 y = 0 }  
		
		visible = {
			FROM = { original_tag = PHI }
		}

		available = {
		}

		on_complete = {
		}

		equipment_bonus = {
			fuel_consumption = -0.05
		}

		ai_will_do = {
			base = 2
		}
	}

	add_trait = {
		token = PHI_mio_trait_coconut_fuel_adaptations
		name = PHI_mio_trait_coconut_fuel_adaptations
		icon = GFX_generic_mio_trait_icon_fuel_consumption
		special_trait_background = yes

		position = { x = 0 y = 1 }  
		
		visible = {
			FROM = { original_tag = PHI }
		}

		available = {
			FROM = {
				PHI_vicente_lava = {
					is_hired_as_advisor = yes
				}
			}
		}

		relative_position_id = PHI_mio_trait_ethanol_fuel_adaptations
		any_parent = { PHI_mio_trait_ethanol_fuel_adaptations }

		on_complete = {
		}

		equipment_bonus = {
			fuel_consumption = -0.10
			reliability = -0.05
		}

		ai_will_do = {
			base = 2
		}
	}

}

JAP_tokyo_automobile_industries_organization = {
	include = generic_armored_car_organization
	icon = GFX_idea_JAP_isuzu_mot_1 # Can become GFX_idea_JAP_isuzu_mot_2
	
	allowed = {	
		OR = {
			AND = {
				original_tag = JAP
				has_dlc = "La Resistance"
                always = no
			}
			PHI_SEA = yes
		}
		has_dlc = "Arms Against Tyranny"
	}
	
	available = {
		IF = {
			limit = {
				FROM = { NOT = { original_tag = JAP } }
			}
			FROM = { NOT = { has_war_with = JAP } }
		}
		
		IF = {
			limit = {
				FROM = {
					original_tag = PHI
				}
			}
			FROM = {
				has_completed_focus = PHI_align_with_japan
				if = {
					limit = {
						has_completed_focus = PHI_declare_military_emergency
					}
					NOT = {
						has_completed_focus = PHI_declare_military_emergency
					}
				}
			}
		}
	}

	initial_trait = {
		organization_modifier = {
			military_industrial_organization_research_bonus = 0.15
			military_industrial_organization_funds_gain = 0.15
			military_industrial_organization_size_up_requirement = -0.15
		}
		production_bonus = {
			production_capacity_factor = 0.05
			production_cost_factor = -0.05
			production_efficiency_cap_factor = 0.05
			production_efficiency_gain_factor = 0.1
			production_resource_need_factor = -0.25
		}
	}

	add_trait = {
		token = PHI_mio_trait_ethanol_fuel_adaptations
		name = PHI_mio_trait_ethanol_fuel_adaptations
		icon = GFX_generic_mio_trait_icon_fuel_consumption
		special_trait_background = yes

		position = { x = 9 y = 0 }  
		
		visible = {
			FROM = { original_tag = PHI }
		}

		available = {
		}

		on_complete = {
		}

		equipment_bonus = {
			fuel_consumption = -0.05
		}

		ai_will_do = {
			base = 2
		}
	}

	add_trait = {
		token = PHI_mio_trait_coconut_fuel_adaptations
		name = PHI_mio_trait_coconut_fuel_adaptations
		icon = GFX_generic_mio_trait_icon_fuel_consumption
		special_trait_background = yes

		position = { x = 0 y = 1 }  
		
		visible = {
			FROM = { original_tag = PHI }
		}

		available = {
			FROM = {
				PHI_vicente_lava = {
					is_hired_as_advisor = yes
				}
			}
		}

		relative_position_id = PHI_mio_trait_ethanol_fuel_adaptations
		any_parent = { PHI_mio_trait_ethanol_fuel_adaptations }

		on_complete = {
		}

		equipment_bonus = {
			fuel_consumption = -0.10
			reliability = -0.05
		}

		ai_will_do = {
			base = 2
		}
	}

	add_trait = {
		token = PHI_mio_trait_ad_hoc_armor_reinforcement
		name = PHI_mio_trait_ad_hoc_armor_reinforcement
		icon = GFX_generic_mio_department_icon_tank_general_armor
		special_trait_background = yes

		position = { x = 0 y = 1 }  
		
		visible = {
			FROM = { original_tag = PHI }
		}

		available = {
		}

		relative_position_id = generic_mio_trait_command_upgrades
		any_parent = { generic_mio_trait_command_upgrades }

		on_complete = {
		}

		equipment_bonus = {
			hardness = 0.05
			armor_value = 0.03
			maximum_speed = -0.03
		}

		ai_will_do = {
			base = 2
		}
	}

	add_trait = {
		token = PHI_mio_trait_widened_tires
		name = PHI_mio_trait_widened_tires
		icon = GFX_generic_mio_trait_icon_maximum_speed
		special_trait_background = yes

		position = { x = 0 y = 1 }  
		
		visible = {
			FROM = { original_tag = PHI }
		}

		available = {
		}

		relative_position_id = generic_mio_trait_reinforced_wheels
		any_parent = { generic_mio_trait_reinforced_wheels }

		on_complete = {
		}

		equipment_bonus = {
			reliability = 0.07
			maximum_speed = 0.03
		}

		ai_will_do = {
			base = 2
		}
	}
}
##支援装备
JAP_nagoya_arsenal_organization = {
	include = generic_support_equipment_organization
	icon = GFX_idea_JAP_nagoya_arsenal
	
	allowed = {	
		OR = {
			original_tag = JAP 
			original_tag = MAN
		}
		has_dlc = "Arms Against Tyranny"
	}

	available = {
		# When in a Foreign MIO, countries need to be at peace with original country
		IF = {
			limit = {
				FROM = { NOT = { original_tag = JAP } }
			}
			FROM = { NOT = { has_war_with = JAP } }
		}

		IF = {
			limit = {
				FROM = { original_tag = MAN }
			}
			FROM = {
				OR = {
					is_subject_of = JAP
					is_in_faction_with = JAP
				}
			}
		}
	}
	initial_trait = {
		organization_modifier = {
            military_industrial_organization_research_bonus = 0.15
            military_industrial_organization_funds_gain = 0.15
            military_industrial_organization_size_up_requirement = -0.15
        }
		production_bonus = {
            production_capacity_factor = 0.05
            production_cost_factor = -0.05
            production_efficiency_cap_factor = 0.05
            production_efficiency_gain_factor = 0.1
            production_resource_need_factor = -0.25
        }
	}
	add_trait = {
		token = JAP_mio_trait_military_arsenal_trait
		name = JAP_mio_trait_military_arsenal_trait
		icon = GFX_generic_mio_trait_icon_production_capacity
		special_trait_background = yes

		relative_position_id = generic_mio_trait_anti_tank_rifle

		position = { x = 1 y = 0 }  
		
		visible = {
			FROM = { original_tag = JAP }
		}

		available = {
			FROM = {
				JAP_army_faction_is_not_subdued = yes
			}
		}

		on_complete = {
			
		}

		organization_modifier = {
		    
		}

		production_bonus = {
			production_capacity_factor = 0.05
		}

		ai_will_do = {
			base = 2
		}
	}

}
#直升机
JAP_kayaba_industry_organization = {
	include = generic_helicopter_organization
	icon = GFX_idea_JAP_kayaba_industry
	
	allowed = {	
		original_tag = JAP 
		has_dlc = "Gotterdammerung"		
		has_dlc = "Arms Against Tyranny"
	}
	initial_trait = {
		organization_modifier = {
            military_industrial_organization_research_bonus = 0.15
            military_industrial_organization_funds_gain = 0.15
            military_industrial_organization_size_up_requirement = -0.15
        }
		production_bonus = {
            production_capacity_factor = 0.05
            production_cost_factor = -0.05
            production_efficiency_cap_factor = 0.05
            production_efficiency_gain_factor = 0.1
            production_resource_need_factor = -0.25
        }
		equipment_bonus = {
			build_cost_ic = -0.05
			armor_value = 0.05
			maximum_speed = 0.05
			reliability = 0.05
			defense = 0.05
		}
	}
}

JAP_hitachi_arms_department_organization = {
	include = generic_assault_guns_organization
	icon = GFX_idea_JAP_hitachi_arms
	
	allowed = {	
		original_tag = JAP
		has_dlc = "Arms Against Tyranny"
        always = no
	}
	
	available = {
		
	}

	initial_trait = {
		organization_modifier = {
			military_industrial_organization_research_bonus = 0.15
			military_industrial_organization_funds_gain = 0.15
			military_industrial_organization_size_up_requirement = -0.15
		}
		production_bonus = {
			production_capacity_factor = 0.05
			production_cost_factor = -0.05
			production_efficiency_cap_factor = 0.05
			production_efficiency_gain_factor = 0.1
			production_resource_need_factor = -0.25
		}
	}

	add_trait = {
		token = JAP_mio_trait_foreign_research_and_development_cooperation
		name = JAP_mio_trait_foreign_research_and_development_cooperation
		icon = GFX_generic_mio_department_icon_facilities
		special_trait_background = yes

		relative_position_id = generic_mio_trait_heavy_assault_gun_improvements

		position = { x = 2 y = 0 }  
		
		visible = {
			FROM = { original_tag = JAP }
		}

		available = {
			FROM = {
				has_completed_focus = JAP_foreign_tank_modernization_cooperation
				NOT = { has_country_flag = JAP_mio_trait_foreign_research_and_development_cooperation_taken_flag }
			}
		}

		on_complete = {
			custom_effect_tooltip = generic_trait_will_not_be_available_in_other_organizations
			FROM = {
				set_country_flag = JAP_mio_trait_foreign_research_and_development_cooperation_taken_flag
			}
		}

		organization_modifier = {
		    military_industrial_organization_research_bonus = 0.15
		}

		production_bonus = {
			production_capacity_factor = 0.1
		}

		ai_will_do = {
			base = 2
		}
	}

}
