# templates_JAP old_for_reference

```hoi4
##步兵
JAP_infantry = {
	available_for = {
		JAP
	}
	role = infantry
	upgrade_prio = {
		base = 0
	}
	JAP_infantry_defult = {
		upgrade_prio = {
			base = 0
		}
		target_template = {
			regiments = { 
				infantry = 12
				artillery_brigade = 3
				anti_tank_brigade = 2
				anti_air_brigade = 1
			}
			support = {
				engineer = 1
				field_hospital = 1
				recon = 1
				logistics_company = 1
				signal_company = 1
			}
		}
	}
}
#步坦
JAP_infantry_tank = {
	available_for = {
		JAP
	}
	front_role_override = offence
	role = infantry_armor
	upgrade_prio = {
		base = 0
	}
	JAP_infantry_tank_defult = {
		upgrade_prio = {
			base = 0
		}
		target_template = {
			regiments = { 
				infantry = 8
				medium_armor = 8
				medium_tank_destroyer_brigade = 1
				medium_sp_anti_air_brigade = 1
			}
			support = {
				medium_flame_tank = 1
				helicopter_field_hospital = 1
				helicopter_recon = 1
				helicopter_transport = 1
				armored_engineer = 1
			}
		}
	}
}
#机坦
JAP_mechanized_tank = {
	available_for = {
		JAP
	}
	role = medium_armor
	front_role_override = offence
	upgrade_prio = {
		base = 0
	}
	JAP_mechanized_tank_defult = {
		upgrade_prio = {
			base = 0
		}
		target_template = {
			regiments = { 
				mechanized = 8
				medium_armor = 8
				medium_tank_destroyer_brigade = 1
				medium_sp_anti_air_brigade = 1
			}
			support = {
				medium_flame_tank = 1
				helicopter_field_hospital = 1
				helicopter_recon = 1
				helicopter_transport = 1
				armored_engineer = 1
			}
		}
	}
}
#重机坦
JAP_mechanized_heavy_tank = {
	available_for = {
		JAP
	}
	role = heavy_armor
	front_role_override = offence
	upgrade_prio = {
		base = 0
	}
	JAP_mechanized_heavy_armor_defult = {
		upgrade_prio = {
			base = 0
		}
		target_template = {
			regiments = { 
				mechanized = 8
				heavy_armor = 8
				heavy_tank_destroyer_brigade = 1
				heavy_sp_anti_air_brigade = 1
			}
			support = {
				medium_flame_tank = 1
				helicopter_field_hospital = 1
				helicopter_recon = 1
				helicopter_transport = 1
				armored_engineer = 1
			}
		}
	}
}
#两栖机坦
JAP_amphibious_mechanized = {
	available_for = {
		JAP
	}
	role = marine_armor
	front_role_override = offence
	upgrade_prio = {
		base = 0
	}
	JAP_amphibious_mechanized_defult = {
		upgrade_prio = {
			base = 0
		}
		target_template = {
			regiments = { 
				amphibious_mechanized = 8
				amphibious_medium_armor = 8
				medium_tank_destroyer_brigade = 1
				medium_sp_anti_air_brigade = 1
			}
			support = {
				medium_flame_tank = 1
				helicopter_field_hospital = 1
				helicopter_recon = 1
				helicopter_transport = 1
				armored_engineer = 1
			}
		}
	}
}
#两栖重机坦
JAP_heavy_amphibious_mechanized = {
	available_for = {
		JAP
	}
	role = marine_heavy_armor
	front_role_override = offence
	upgrade_prio = {
		base = 0
	}
	JAP_heavy_amphibious_mechanized_defult = {
		upgrade_prio = {
			base = 0
		}
		target_template = {
			regiments = { 
				amphibious_mechanized = 8
				amphibious_heavy_armor = 8 
				heavy_tank_destroyer_brigade = 1
				heavy_sp_anti_air_brigade = 1
			}
			support = {
				medium_flame_tank = 1
				helicopter_field_hospital = 1
				helicopter_recon = 1
				helicopter_transport = 1
				armored_engineer = 1
			}
		}
	}
}
#陆巡两栖重机坦
JAP_land_crushier = {
	available_for = {
		JAP
	}
	role = land_crushier
	front_role_override = offence
	upgrade_prio = {
		base = 0
	}
	JAP_land_crushier_defult = {
		upgrade_prio = {
			base = 0
		}
		target_template = {
			regiments = { 
				amphibious_mechanized = 8
				amphibious_heavy_armor = 8 
				heavy_tank_destroyer_brigade = 1
				heavy_sp_anti_air_brigade = 1
			}
			support = {
				medium_flame_tank = 1
				helicopter_brigade = 1
				helicopter_recon = 1
				land_cruiser = 1
				armored_engineer = 1
			}
		}
	}
}
#镇压
JAP_suppression = {
	
	role = suppression
	upgrade_prio = {
		base = 0.5
		modifier = {
			factor = 0
			has_war = yes
		}
	}
	JAP_suppression = {
		upgrade_prio = {
			base = 0
		}
		
		target_template = {
			
			support = { 
				military_police = 1
			}

			regiments = {
				cavalry = 25
			}
		}
	}
}
```
