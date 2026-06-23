# Agent Reference Index

Source: `AGENTS.md`.
Applies to: `whole Japan_rework workspace`.

This file preserves detailed authoring notes migrated out of `AGENTS.md`. Keep the corresponding `AGENTS.md` file as a concise operating entrypoint, and update this reference when long examples, syntax notes, workflows, or lookup explanations need to be maintained.

## Migrated Notes

# Japan Rework Agents Notes

## Directory AGENTS

Before reading, editing, or creating files inside a specific directory, first check whether that directory or one of its relevant parent directories contains an `AGENTS.md` file, and follow those directory-specific instructions in addition to this root file.

## National Focus Naming

When discussing a national focus with the user, prefer using the localized Chinese focus name instead of only the internal focus key.

Use `Reference/focus_name.md` as the lookup table for `focus key -> localized focus name`.

If a focus is mentioned by key in script files such as `common/national_focus/japan.txt`, check `Reference/focus_name.md` and use the localized name in user-facing explanations whenever possible.

Before reading files under `Reference/`, confirm you are using the correct file encoding.

If the content appears garbled, first verify whether you are reading it with the correct encoding before assuming the file itself is broken.

If Chinese text still appears garbled, prefer adjusting the encoding read strategy according to project conventions before making content edits.

Do not lightly rewrite whole sections or whole reference files just because the current readout looks garbled, especially when the issue may only be a read/terminal encoding mismatch.

## Character Naming

When discussing a character with the user, prefer using the localized Chinese character name instead of only the internal character key.

Use `Reference/character_name.md` as the lookup table for `character key -> localized character name`.

If a character is mentioned by key in script files such as `common/characters/`, `history/countries/`, `common/national_focus/`, or `events/`, check `Reference/character_name.md` and use the localized name in user-facing explanations whenever possible.

## Event Title Naming

When discussing an event with the user, prefer using the localized Chinese event title instead of only the internal event localization key.

Use `Reference/event_title_reference.md` as the lookup table for `event title key (.t) -> localized Chinese event title`.

If an event title key is mentioned in script files such as `events/` or localization files, check `Reference/event_title_reference.md` and use the localized Chinese title in user-facing explanations whenever possible.

## State Naming

When discussing a state with the user, prefer using the localized Chinese state name instead of only the state ID or `STATE_x` localization key.

Use `Reference/state_name_reference.md` as the lookup table for `state id / STATE_x key -> localized Chinese state name`.

If a state ID or `STATE_x` key is mentioned in script files such as `history/states/`, `events/`, `common/decisions/`, `common/scripted_effects/`, `common/scripted_triggers/`, or localization files, check `Reference/state_name_reference.md` and use the localized Chinese state name in user-facing explanations whenever possible.

When working with province IDs contained within a state, use `Reference/state_province_reference.md` as the lookup table for `state id / STATE_x key -> localized Chinese state name -> province IDs`.

If state-to-province membership is relevant in files such as `history/states/`, `events/`, `common/decisions/`, `common/scripted_effects/`, `common/scripted_triggers/`, or province-level building logic, check `Reference/state_province_reference.md` before writing or explaining the logic.

## Strategic Region Naming

When discussing strategic regions, `STRATEGICREGION_x` localization keys, strategic region IDs, `map/strategicregions/`, or AI area composition using `strategic_regions = { ... }`, prefer using the localized Chinese strategic region name.

Use `Reference/strategic_region_reference.md` as the lookup table for `strategic region id / STRATEGICREGION_x key -> localized Chinese strategic region name`.

If strategic region IDs are used to build or explain AI areas in `common/ai_areas/`, `common/ai_strategy/`, or AI strategy references, check `Reference/strategic_region_reference.md` before writing or explaining the area composition.

## Formal Release Diff Inventory

When working on test-to-formal release synchronization, standalone `rance_jap_*` mods, name overlays, files that should never ship, or the gradual removal of hardcoded language-specific visible names from shared gameplay files, use `release_maintenance/README.md` as the primary workflow reference.

The detailed inventories live under `release_maintenance/`, including `release_maintenance/formal_release_diff_inventory.md` and `release_maintenance/formal_release_unique_content_inventory.md`.

## Building Reference

When working with buildings, including building names, building keys, building construction effects, building level effects, or building slot logic, use `Reference/building_reference.md` as the primary lookup reference.

If a building-related script or localization entry is mentioned in files such as `common/buildings/`, `common/decisions/`, `common/national_focus/`, `common/scripted_effects/`, `common/scripted_triggers/`, `events/`, `history/states/`, or localization files, check `Reference/building_reference.md` first before writing or explaining the logic.

## Defines Reference

When working with HOI4 defines, `NDefines` keys, default define values, AI/theatre/front behavior controlled by defines, or `common/defines/Rance_defines.lua`, use `Reference/defines_lua_reference.md` as the primary lookup reference.

This reference contains AI-generated Chinese interpretation imported from the rookie series notes, so verify high-impact behavior against vanilla `common/defines/00_defines.lua` or tested project examples before making risky changes.

When changing defines in this project, prefer editing `common/defines/Rance_defines.lua` with `NDefines.<Group>.<KEY> = <value>` overrides, preserve non-localization script encoding as UTF-8 without BOM, and avoid duplicate assignments for the same define key.

## Technology Sharing Reference

When working with technology sharing groups, `common/technology_sharing/`, `add_to_tech_sharing_group`, `remove_from_tech_sharing_group`, `is_in_tech_sharing_group`, `num_tech_sharing_groups`, or `research_sharing_per_country_bonus`, use `Reference/technology_sharing_reference.md` as the primary lookup reference.

For technology sharing categories, verify the category keys against the relevant vanilla or project `common/technologies/` files before adding them to a sharing group.

## Combat Tactics Reference

When working with land combat tactics, `common/combat_tactics.txt`, `enable_tactic`, `unlock_tactic`, tactic phases, tactic counters, preferred tactic weight modifiers, tactic icons, or Japan/Rance-exclusive tactic upgrades, use `Reference/combat_tactics_reference.md` as the primary lookup reference. This reference is written in Chinese for direct study and keeps script keys in their original form.

## Equipment Module Localization Reference

When working with equipment modules or module-related localization, including module keys, module category keys, module slot keys, or user-facing module names, use `Reference/equipment_module_localisation_reference.md` as the primary lookup reference.

This reference intentionally stores names only and does not include module description (`*_desc`) localization.

## Variable Syntax Lookup

When working with HOI4 variables, especially for creation, arithmetic, scoped storage, temporary variables, or `check_variable` conditions, use `Reference/variable_syntax_reference.md` as the primary lookup reference.

If variable syntax is uncertain, check that reference first before writing or explaining variable logic.

## Route And Difficulty Trigger Lookup

When working with route-related AI conditions, difficulty-related conditions, or scripted triggers such as route and difficulty checks, use `Reference/route_difficulty_scripted_trigger.md` as the primary lookup reference.

If route or difficulty trigger usage is uncertain, check that reference first before writing or explaining the condition.

## AI War Strategy Reference

When working with AI war strategy (`war_strategy`), military/front behavior, invasion execution, garrison or area defense, front unit requests, invasion unit requests, unit buffers, theatre distribution pressure, or when the user mentions `战争策略参考` / `war_strategy` reference, use `common/ai_strategy/AI_Strategy_Reference/AI_war_strategy_reference.md` as the primary lookup reference.

When working specifically with 皇道派 / Kodoha military AI strategy, old Kodoha war-strategy entries, or `common/ai_strategy/Jap_rework_kodoha_mil.txt`, also use `common/ai_strategy/AI_Strategy_Reference/JAP_kodoha_war_strategy_reference.md` for current old-entry content, numeric values, target states, landing flags, and front-control priority layers.

When working on post-China 皇道派 / Kodoha war planning, custom AI areas, or later Allied/Comintern war strategy after Japan has annexed China and Tibet, also use `common/ai_strategy/AI_Strategy_Reference/JAP_kodoha_post_china_ai_area_plan.md` before creating area keys or writing area-targeted military AI strategies.

## Modifier Lookup

When working with modifiers, especially when creating or editing traits, use `Reference/modifier_trans.md` as the primary lookup reference.

## 情报机构决议参考

处理日本情报机构决议、La Resistance 机构创建、特工位、反间谍奖励、行动令牌，或情报行动 AI 引导时，使用 `Reference/intelligence_agency_decision_reference.md` 作为本项目优先参考。

## Localization Formatting Lookup

When writing or revising localization text that uses formatting controls such as `§R`, `§Y`, or `\n`, use `Reference/localisation_formatting_reference.md` as the primary lookup reference.

If color usage is uncertain, check that reference first before choosing or explaining a color code.

## Scripted Localisation Dynamic Key Reference

When working with scripted localisation, dynamic localization keys, `defined_text`, or conditional `localization_key` selection, use `Reference/hoi4_scripted_localisation_dynamic_key.md` as a temporary trusted reference.

For `defined_text`, treat each `text = { ... }` block as an alternative candidate that returns one `localization_key`, not as text that will be appended together. Do not rely on overlapping triggers being resolved in the desired order. Prefer mutually exclusive triggers, an explicit no-trigger fallback, or exhaustive combination entries when multiple conditions can be true at once.

This reference was generated by GPT and later corrected against vanilla scripted localisation patterns. Prefer confirming high-impact edge cases against vanilla files or tested project examples.

## Localization File Placement

Do not insert newly added localization entries into `localisation/simp_chinese/SEA_focus_l_simp_chinese.yml` unless the user explicitly requests that exact file.

When adding new localization, place it in the most appropriate domain-specific localization file instead, so related entries stay grouped together.

This rule exists because continuing to append unrelated localization to `SEA_focus_l_simp_chinese.yml` increases the workload for future localization work in other languages.

## IDE Context Completion

If the user's IDE selection, active file excerpt, or pasted snippet appears incomplete, do not rely only on the selected fragment by default.

First try to recover the full context from nearby lines, the surrounding file, related referenced files, or other obvious project context before asking the user to reselect or paste more content.

This applies especially when the user only highlights part of a decision, focus, event, localization block, trigger, effect, or scripted structure and the missing context can be inferred by reading the file directly.

If a correction or interruption says the user has reverted or stopped one mistaken direction, do not interpret that as permission to remove all previous work from the broader request. First identify the precise mistaken change, preserve still-valid edits, and ask if the intended rollback scope is unclear.

## Windows PowerShell Notes

When using PowerShell to inspect files in this project, prefer commands compatible with the local Windows PowerShell version.

- Do not assume `Format-Hex -Count` is available. When checking BOMs or first bytes, use `Get-Content -Encoding Byte -TotalCount N` or `[System.IO.File]::ReadAllBytes(...)` instead.
- When piping objects produced by an inline `foreach` loop or multi-statement snippet, wrap the producer in `& { ... } | ...` so PowerShell parses the pipeline correctly.

## File Encoding

Unless the user specifies otherwise, use these encoding conventions:

- Before writing or editing code, always confirm the correct file encoding first.
- General project files: `UTF-8`
- Localization files: `UTF-8 with BOM`
- All project files must use LF line endings.
- When editing an existing file, generally do not change its current line-ending style. New content should follow the existing file's line-ending style first; if the file already mixes line endings, use the current default project line ending for new content.

Format exception:

- `events/SEA_Japan.txt` intentionally follows the vanilla HOI4 file format: `UTF-8 with BOM` and CRLF line endings. Preserve this format when editing this file, even though it differs from the general project rule.
- `common/decisions/JAP.txt` intentionally follows the vanilla HOI4 file format: `UTF-8 without BOM` and CRLF line endings. Preserve this format when editing this file, even though its CRLF line endings differ from the general project rule.

Any task that involves encoding, garbled text, BOM handling, conversion, or file re-saving must be checked against these project conventions first.

When handling encoding-related issues:

- always verify the expected encoding from project rules before reading, writing, converting, or re-saving a file
- do not change file encoding unless the target encoding is explicitly supported by project rules or explicitly requested by the user
- do not attempt trial-and-error encoding conversion that conflicts with project rules
- do not rewrite whole files or sections merely because terminal output looks garbled; first determine whether the issue is file content, read strategy, terminal output encoding, or BOM usage
- if a file appears corrupted, prefer the most conservative fix that preserves existing content and structure
- encoding rules in this project are mandatory constraints, not loose suggestions

If Chinese-related content appears garbled while reading, first retry with the encoding strategy implied by these project conventions before deciding the file content itself needs repair.

If encoding is wrong, the game may report errors similar to:

- `Unexpected token: ﻿leader_traits`
- `Unexpected token: ﻿...`

Such errors often indicate a BOM problem in a non-localization script file.

## Vanilla HOI4 Reference

When it is necessary to inspect or verify vanilla Hearts of Iron IV content, use the base game directory at:

`D:\SteamLibrary\steamapps\common\Hearts of Iron IV`

This path should be used for checking original script definitions, traits, ideas, events, focuses, localization, and other vanilla references when the relevant content is not present in the mod workspace.

The vanilla directory is also maintained as a local Git baseline for update tracking. Its `.git/info/exclude` can ignore broad untracked paths, so ordinary `rg` may skip vanilla files even when they exist. For broad vanilla script searches, use:

```powershell
rg -u -n "PATTERN" "D:\SteamLibrary\steamapps\common\Hearts of Iron IV"
```

Escalate to `-uu` or `-uuu` only when hidden paths or binary-like files are genuinely relevant. When the likely target file is known, prefer direct file reads or `Select-String -Path <exact file> -Pattern ...` so the Git exclude rules cannot hide the result.

## External Reference Mods

When the user references files from other mods, especially paths starting with `钢四MOD写作\参考\`, first try resolving them under:

`D:\hoi4参考mod`

For example, `钢四MOD写作\参考\菜鸟配件修改\common\units\equipment\modules\00_tank_modules.txt` should be read from `D:\hoi4参考mod\钢四MOD写作\参考\菜鸟配件修改\common\units\equipment\modules\00_tank_modules.txt`.

## Sheep's Mod AI Reference

When the user refers to `羊头`, `sheep's mod`, or paths beginning with `sheep's mod\`, interpret this as the AI reference mod located at:

`C:\Users\Rancesamadaze\Documents\Paradox Interactive\Hearts of Iron IV\mod\sheep's mod`

Use this mod as a reference source for AI behavior, especially files under `common/ai_strategy/`, when comparing, explaining, or adapting AI logic for this project.

Unless the user explicitly asks to edit Sheep's Mod itself, treat it as read-only reference material and make implementation changes in the current mod workspace.

## Rookie Series Reference Mods

If the device and local mod setup are correct, the parent directory of this project:

`C:\Users\Administrator\Documents\Paradox Interactive\Hearts of Iron IV\mod`

contains a series of `rookie` reference mods.

When the user refers to the `菜鸟` series, first search these local mod folders:

- `C:\Users\Administrator\Documents\Paradox Interactive\Hearts of Iron IV\mod\rookie_basic`
- `C:\Users\Administrator\Documents\Paradox Interactive\Hearts of Iron IV\mod\rookie_ENG`
- `C:\Users\Administrator\Documents\Paradox Interactive\Hearts of Iron IV\mod\rookie_GER`
- `C:\Users\Administrator\Documents\Paradox Interactive\Hearts of Iron IV\mod\rookie_ITA`
- `C:\Users\Administrator\Documents\Paradox Interactive\Hearts of Iron IV\mod\rookie_SOV`

## Vanilla File Cloning Rule

If achieving the requested goal requires modifying a vanilla file and the mod workspace does not already contain the corresponding override file, do not edit vanilla files in place.

Instead:

- first identify the corresponding vanilla file that needs to be overridden
- after user review and approval, clone that vanilla file into the matching path inside the mod workspace
- then make the required edits in the mod copy

This rule applies especially to script, localization, interface, focus, event, idea, decision, and similar content files that are normally overridden by path in HOI4 mods.

## Descriptor Replace Path Overrides

When a mod needs to fully override a vanilla file or directory, the descriptor can declare the override with:

`replace_path="path/from/game/root"`

Examples include `replace_path="common/technologies/industry.txt"` for a single file, `replace_path="common/military_industrial_organization/policies"` for a directory, or `replace_path="events/WTT_Japan.txt"` for an event file.

Use this syntax in `.mod` descriptor files when the intended behavior is full replacement of the target path rather than additive loading or partial merging.

## Characters

When working on character-related content, also follow `common/characters/AGENTS.md`.

This includes not only files under `common/characters/`, but also related recruitment or promotion logic in places such as:

- `history/countries/`
- `common/national_focus/`
- `events/`
