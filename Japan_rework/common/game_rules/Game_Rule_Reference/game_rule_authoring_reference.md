# Game Rule Authoring Reference

Source: `common/game_rules/AGENTS.md`.
Applies to: `common/game_rules/`.

This file preserves detailed authoring notes migrated out of `common/game_rules/AGENTS.md`. Keep the corresponding `AGENTS.md` file as a concise operating entrypoint, and update this reference when long examples, syntax notes, workflows, or lookup explanations need to be maintained.

## Migrated Notes

# Game Rules Agents Notes

## Purpose

This folder stores custom pre-game rules shown in the "Custom Game Rules" screen before selecting a country.

For new mod rules, prefer adding a project-owned file instead of editing or cloning the vanilla `00_game_rules.txt`.

The current project file is `000_Rance_game_rules.txt`. The `000_` prefix is a lightweight ordering hint intended to make the mod rule group load before vanilla `00_game_rules.txt` when the engine orders rule files by path. There is no observed `priority` or `sort_order` field in the vanilla rule syntax, so confirm the final group placement in-game after changing rule filenames or groups.

Use the vanilla reference at:

`D:\SteamLibrary\steamapps\common\Hearts of Iron IV\common\game_rules\00_game_rules.txt`

## Encoding

- Script files in this folder: UTF-8 without BOM, LF line endings.
- Do not put Chinese display text directly in game rule script files. Use localization keys.
- Simplified Chinese localization for rules belongs in `localisation/simp_chinese/`, encoded as UTF-8 with BOM and LF line endings.
- Do not add unrelated game rule localization to `localisation/simp_chinese/SEA_focus_l_simp_chinese.yml`.

## Rule Group

A custom game rule category is created by assigning a localized group key:

```txt
group = "RULE_GROUP_RANCE_JAPAN_REWORK"
```

There is no separate group registry file. Add localization for the group key and every rule using that group will appear under that category.

```yml
l_simp_chinese:
 RULE_GROUP_RANCE_JAPAN_REWORK: "日本重制规则"
```

## Minimal Rule Structure

Use this as the starting template for a normal custom rule:

```txt
rance_example_rule = {
	name = "RANCE_EXAMPLE_RULE"
	group = "RULE_GROUP_RANCE_JAPAN_REWORK"

	default = {
		name = DEFAULT
		text = "RULE_OPTION_DEFAULT"
		desc = "RANCE_EXAMPLE_RULE_DEFAULT_DESC"
		allow_achievements = yes
	}

	option = {
		name = ENABLED
		text = "RULE_OPTION_RANCE_ENABLED"
		desc = "RANCE_EXAMPLE_RULE_ENABLED_DESC"
		allow_achievements = no
	}
}
```

Notes:

- The outer key, such as `rance_example_rule`, is the rule token used by script triggers.
- `name` is the localization key for the rule title. Do not add rule-level `desc` in this project. Vanilla comments mention it, but vanilla's actual rule entries put displayed explanatory text on the selected `default` / `option` `desc`, and rule-level `desc` has produced parser error-log entries in testing.
- Put any rule-level semantics that players need to see into every relevant `default` / `option` `desc`, because that is the description the rule screen displays for the current selection.
- `default` explicitly marks the default option. If `default` is not used, vanilla comments indicate the first `option` is treated as default.
- `allow_achievements` should be written deliberately. Non-default or gameplay-changing options should normally use `allow_achievements = no`.
- `required_dlc = "DLC Name"` may be placed on the rule or on an individual option when needed.
- `icon = "GFX_some_icon"` is optional. If using a custom icon, verify the sprite exists.

## Minimal Localization Structure

Use a domain-specific file such as:

`localisation/simp_chinese/Rance_game_rules_l_simp_chinese.yml`

```yml
l_simp_chinese:
 RULE_GROUP_RANCE_JAPAN_REWORK: "日本重制规则"
 RANCE_EXAMPLE_RULE: "示例规则"
 RANCE_EXAMPLE_RULE_DEFAULT_DESC: "使用默认设置，并说明该规则影响的内容。"
 RULE_OPTION_RANCE_ENABLED: "启用"
 RANCE_EXAMPLE_RULE_ENABLED_DESC: "启用该规则，并说明启用后的影响。"
```

## Reading Rules In Script

Game rules do nothing by themselves. Use `has_game_rule` in focuses, events, decisions, scripted triggers, AI strategy plans, or other script logic:

```txt
has_game_rule = {
	rule = rance_example_rule
	option = ENABLED
}
```

For repeated checks, prefer a scripted trigger in `common/scripted_triggers/`.

## AI Behavior Rules

For country route selection rules, follow the vanilla pattern:

```txt
JAP_ai_behavior = {
	name = "JAP_AI_BEHAVIOR"
	group = "RULE_GROUP_AI_BEHAVIOR"

	default = {
		name = DEFAULT
		text = "RULE_OPTION_DEFAULT"
		desc = "RULE_OPTION_DEFAULT_AI_DESC"
	}

	option = {
		name = COMMUNIST
		text = "RULE_OPTION_COMMUNIST"
		desc = "RULE_OPTION_COMMUNIST_JAP_AI_DESC"
		allow_achievements = yes
	}
}
```

Then connect it to `common/ai_strategy_plans/` with:

```txt
enable = {
	has_game_rule = {
		rule = JAP_ai_behavior
		option = COMMUNIST
	}
}
```

If route or difficulty helper triggers are involved, also check `Reference/route_difficulty_scripted_trigger.md`.
