# Formal Release Diff Inventory

This note records the current release-maintenance split between the development mod and the three formal standalone mods.

Development source:

- `C:\Users\Administrator\Documents\Paradox Interactive\Hearts of Iron IV\mod\Japan_rework`

Formal targets:

- `C:\Users\Administrator\Documents\Paradox Interactive\Hearts of Iron IV\mod\rance_jap_chinese`
- `C:\Users\Administrator\Documents\Paradox Interactive\Hearts of Iron IV\mod\rance_jap_english`
- `C:\Users\Administrator\Documents\Paradox Interactive\Hearts of Iron IV\mod\rance_jap_japenese`

## Summary

The formal mods are not intended to carry extra gameplay logic beyond the development mod. Current non-localization differences are mainly hardcoded visible names inside game-loaded scripts:

- equipment variant names
- division template names
- OOB unit, fleet, ship, and aircraft names
- ship name pools
- a small number of remaining focus template/unit-name surfaces

The maintenance goal is to make most gameplay files directly syncable from `Japan_rework`, while keeping language-specific visible names in a small overlay layer.

Do not try to solve this by runtime language selection in HOI4 script. Fields such as `name = "..."`, `division_template = "..."`, and `has_template = "..."` are hard-string surfaces and may also be used for template matching. Prefer explicit publish-time overlays per formal target.

## Release Groups

### common_sync

Files in this group should be copied from `Japan_rework` to all formal targets, after excluding `never_release` and `name_overlay` paths.

Typical examples:

- most `common/ai_strategy/`
- most `common/decisions/`
- most `events/`
- most `history/countries/`
- most `interface/`
- shared scripted triggers, on actions, ideas, technologies, and decision logic

Rule of thumb: if a file does not contain target-language hardcoded visible names and is game-loaded gameplay logic, it should converge into this group.

### name_overlay

These files currently carry hardcoded visible names and should not be blindly overwritten across formal targets. Maintain them as explicit per-target overlays.

Chinese formal overlays use the same visible-name language as `Japan_rework`.
When the Chinese target differs from `Japan_rework` inside a `name_overlay` file,
treat the `Japan_rework` file as the source of truth unless a newer note records
an intentional Chinese-release-only exception. English and Japanese targets
still require their own translated overlay strings.

Initial overlay list:

- `common/scripted_effects/JAP_equipment_scripted_effects.txt`
- `common/scripted_effects/JAP_templates_scripted_effects.txt`
- `history/units/JAP_1936_air_bba_rance.txt`
- `history/units/JAP_1936_air_bba_vanilla.txt`
- `history/units/JAP_1936_naval_rance.txt`
- `history/units/JAP_1936_nsb_rance.txt`
- `history/units/JAP_1936_nsb_vanilla.txt`
- `common/units/names_ships/JAP_ship_names.txt`
- `history/general/taog_hq_template.txt`

Explicit overlay files:

- `JAP_equipment_scripted_effects.txt`
- `JAP_templates_scripted_effects.txt`
- `JAP_named_focus_scripted_effects.txt`
- the affected `history/units/JAP_1936_*` files
- `JAP_ship_names.txt`
- `taog_hq_template.txt`

### needs_refactor

These files still have name-sensitive fragments but should become common files over time. The long-term goal is to move hardcoded naming surfaces out to scripted effects or explicit overlay files.

| File | Current issue | Preferred direction |
| --- | --- | --- |
| `common/national_focus/japan.txt` | Primary named equipment and ship rewards now call `JAP_create_*` scripted effects; lower-priority template/unit-name sites remain. | Keep the focus file common; only extract remaining target-language visible names if they become a real formal-target sync blocker. |
| `events/JAP_jcp_events.txt` | Obsolete early JCP experiment. `japan_jcp.11` is still actively called by `common/decisions/JAP_jcp_decision.txt`. | Keep the log-free common event, or retire the event together with the calling decision hook and corresponding event localization. |

Remaining lower-priority `common/national_focus/japan.txt` hardcoded-name sites:

| Focus id | Current hardcoded surface | Suggested extraction |
| --- | --- | --- |
| `JAP_cast_the_die` | Creates `Japanese People's Regiment` and `Japanese Loyalist Regiment` templates and units. | Move the hidden template/unit creation blocks to scripted effects with per-target names. |
| `JAP_found_the_boeitai` | Deletes/recreates `Kokumin Giyu Sentotai`. | Move template reset into a named scripted effect. |
| `JAP_hokushin_ron` | Deletes/recreates `Asano Brigade` and creates a unit with that template. | Move template/unit creation into a named scripted effect. |
| `JAP_a_mongol_volunteer_army` | Deletes/recreates `Mongoru Dokuritsu-gun` and creates two named units. | Move template/unit creation into a named scripted effect. |
| `JAP_utilize_ainu_expertise` | Deletes/recreates `Ainu Giyu-tai`. | Move template reset into a named scripted effect. |
| `JAP_organize_the_fifth_column` | Deletes/recreates `Kokumin Giyu Sentotai` and creates numbered units. | Reuse or extend the Boeitai template effect. |
| `JAP_a_red_sun_rises_for_a_new_era` | Deletes `Soviet Volunteers`. | Move deletion into a named scripted effect if target-language variants are required. |

Current `events/JAP_jcp_events.txt` retirement blocker:

- `JAP_joint_ultimatum_to_warlords` in `common/decisions/JAP_jcp_decision.txt` sends `country_event = { id = japan_jcp.11 }`. Do not delete the event file alone.

Recently resolved from this group:

- `common/game_rules/000_Rance_game_rules.txt`: rule-level `desc` lines were removed, required meaning was moved into option descriptions, and obsolete outer `*_DESC` localization keys were removed. This file should now be treated as `common_sync` after the pending formal target changes are committed.
- `common/national_focus/japan.txt`: `JAP_the_ultimate_tank`, `JAP_develop_new_fighters`, `JAP_sea_bigger_better_yamato`, `JAP_akizuki_class_destroyers`, and the three `JAP_naval_armaments_program` path-production blocks now call `JAP_named_focus_scripted_effects.txt` effects instead of keeping visible equipment/ship names inline. The same unified focus file has been copied into all three formal targets.
- `common/scripted_effects/JAP_named_focus_scripted_effects.txt`: maintained as a per-target language overlay for focus reward equipment and ship names.
- `events/JAP_jcp_events.txt`: the localized `JAP = { effect_tooltip = { log = ... } }` block was removed, so the event no longer needs a language overlay.

### never_release

These files are useful in `Japan_rework` but should not be shipped into formal targets.

Top-level folders that should never be copied into formal targets:

- `.codex/`
- `.git/`
- `.vscode/`
- `asset_sources/`
- `CHANGELOG/`
- `INTRODUCTION/`
- `ISSUES/`
- `PLAN/`
- `Reference/`
- `release_maintenance/`
- `tmp/`
- `tool/`
- `update_fit/`

Global file and folder patterns that should never be copied into formal targets:

- `AGENTS.md`
- `*.md`
- `_documentation.md`
- `*_Reference/*.md`
- `*_Reference/`
- authoring reference files
- task/planning/reference markdown files under game-loaded directories

Top-level files that should never be copied into formal targets:

- `.gitignore`
- `.hoi4-dev-notes.json`
- `Japan_rework.code-workspace`
- `RA_mod_vanilla-japan-expanded-ai-overhaul.code-workspace`

Known examples:

- `common/game_rules/Game_Rule_Reference/game_rule_authoring_reference.md`
- `templates_JAP_old_for_reference.md`
- `JAP_rework_debug_ai_strategy.txt`

The earlier scan found no formal-target-only game-loaded files. The development mod had 52 extra game-loaded-path files versus formal targets, and they were primarily development notes, authoring references, and debug/reference files. Treat that set as `never_release` unless a future audit proves a specific file is actually required at runtime.

Do not use `descriptor.mod` `replace_path` entries as a blind copy list. Some historical descriptor entries point at documentation paths that are intentionally absent from formal targets.

### target_owned

These are not copied from `Japan_rework` during normal release sync. Preserve the existing formal-target version instead.

- `descriptor.mod` identity fields only: preserve `name` and `remote_file_id`; sync all other fields from `Japan_rework`, including the full descriptor tag set
- parent launcher files `rance_jap_chinese.mod`, `rance_jap_english.mod`, `rance_jap_japenese.mod` identity fields only: preserve `name`, `path`, and `remote_file_id`; sync all other fields from `Japan_rework`'s `descriptor.mod`, including the full descriptor tag set
- `thumbnail.png`
- the target's dedicated localization directory only:
  - Chinese target: `localisation/simp_chinese/`
  - English target: `localisation/english/`
  - Japanese target: `localisation/japanese/`
- all paths listed in `name_overlay`

### sync_risk_items

Check these before broad direct-copy work:

- `events/SEA_Japan.txt` intentionally uses UTF-8 with BOM and CRLF; do not normalize it during bulk copy.
- `common/decisions/JAP.txt` intentionally uses UTF-8 without BOM and CRLF; do not normalize it during bulk copy.
- Localization files must stay UTF-8 with BOM. Since formal targets now keep only one language, never copy the whole `localisation/` tree.
- `descriptor.mod` and parent launcher `.mod` files contain target identity (`name`, `path`, `remote_file_id`); preserve only those fields and sync the rest, including `tags`.
- `thumbnail.png` is target-owned even though it lives at the mod root.
- Name overlays contain hard strings used by HOI4 matching logic; do not overwrite them with another language.

## Localization Policy

Target direction: each formal mod should maintain only its dedicated language to avoid stale non-dedicated localization causing confusion.

- `rance_jap_chinese`: keep `localisation/simp_chinese/`
- `rance_jap_english`: keep `localisation/english/`
- `rance_jap_japenese`: keep `localisation/japanese/`

Dedicated-language cleanup has been applied: each formal target now carries only its target language directory. Do not reintroduce non-dedicated localization files during release sync.

## Recommended Order

1. Keep this inventory updated whenever a file changes groups.
2. Commit the completed game-rule cleanup in the development mod and in each formal target.
3. Decide whether the remaining low-priority focus template/unit-name sites actually need formal-target overlays.
4. Decide whether to retire the obsolete JCP event/decision module together, rather than deleting `events/JAP_jcp_events.txt` alone.
5. Keep the non-localization formal-release difference list current before broadening direct sync from `Japan_rework` to the three formal targets.

## Verification Checklist

Before copying a file into formal targets:

- Confirm it is not in `never_release`.
- Confirm it is not in `name_overlay`, unless intentionally applying the target overlay.
- Confirm it is not `target_owned`.
- Search for hardcoded visible-name fields: `name = "..."`, `division_template = "..."`, `has_template = "..."`, direct named ship/equipment/unit creation, and OOB visible names.
- Run `git diff --check` in the affected repo.
- Preserve project encoding: general script/reference files use UTF-8 without BOM and LF; localization files use UTF-8 with BOM and LF.
- If editing a descriptor or launcher-facing `.mod` file, check both the in-folder `descriptor.mod` and the parent launcher `.mod` file; only `name`, parent launcher `path`, and `remote_file_id` are non-sync fields.
