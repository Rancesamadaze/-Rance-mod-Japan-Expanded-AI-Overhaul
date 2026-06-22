# Japan Rework Agents Notes

## Directory AGENTS

Before reading, editing, or creating files inside a specific directory, first check whether that directory or one of its relevant parent directories contains an `AGENTS.md` file, and follow those directory-specific instructions in addition to this root file.

Keep `AGENTS.md` files as concise operating entrypoints. Longer syntax notes, examples, workflow records, and lookup explanations belong in reference files. The detailed root notes migrated from this file live in `Reference/agent_reference_index.md`.

## Core Workflow

- If the user's IDE selection, active file excerpt, or pasted snippet appears incomplete, recover the surrounding file context before asking them to reselect or paste more.
- If the user corrects or stops one mistaken direction, identify the precise mistaken change and preserve still-valid edits unless rollback scope is explicit.
- For doc-only requests, do not slip into live gameplay edits.
- 面向 MOD 作者阅读的参考文档、说明文档，正文默认使用简体中文，除非用户明确要求其他语言；代码标识符、文件路径和引用原文保持原样。
- For report-only, audit-only, search-only, or compatibility-review requests, stay read-only and do not edit files unless the user explicitly authorizes implementation changes.
- Do not insert new localization entries into `localisation/simp_chinese/SEA_focus_l_simp_chinese.yml` unless the user explicitly requests that file.
- For issue-tracked fixes, do not remove fixed items immediately; mark them as `待检验` until in-game or log verification confirms them.
- For generated image assets, keep only files directly referenced by game registrations under game-loaded paths such as `gfx/`; move preview PNGs, editable sources, and other non-direct-use image assets into `asset_sources/`.

## Optional HOI4 Tooling

RHoiScribe is optional and may not be installed on every work machine. If the `mcp__rhoiscribe` tools are already available, the following read-only helpers may be used for auxiliary evidence: `search_hoi4_knowledge`, `discover_hoi4_environment`, and `classify_error_log`.

Whether `search_hoi4_knowledge` can stand in for direct vanilla-file lookup depends on the task. It is acceptable for simple syntax reminders, scope overviews, and broad workflow hints; for exact vanilla behavior, version-sensitive mechanics, complex compatibility questions, or any user request to inspect source files, verify against installed vanilla files and this repository's references.

Do not invoke other RHoiScribe tools such as project indexing, validation, repair, generated edits, formatting, or asset generation during normal work unless the user explicitly authorizes that specific function. If RHoiScribe is absent, do not block the task or configure it unless requested; fall back to this repository's AGENTS rules, live file inspection, installed vanilla references, and targeted local validation scripts.

## User-Facing Names

Prefer localized Chinese names in user-facing explanations. Use these lookup tables before explaining internal keys:

- National focuses: `Reference/focus_name.md`
- Characters: `Reference/character_name.md`
- Event titles: `Reference/event_title_reference.md`
- States and provinces: `Reference/state_name_reference.md`, `Reference/state_province_reference.md`
- Strategic regions: `Reference/strategic_region_reference.md`

Before reading files under `Reference/`, confirm the correct encoding strategy. If Chinese text appears garbled, verify whether it is a terminal/read-encoding issue before editing content.

## Required Reference Routes

- Buildings: `Reference/building_reference.md`
- Defines: `Reference/defines_lua_reference.md`; edit project overrides in `common/defines/Rance_defines.lua`
- Equipment module names: `Reference/equipment_module_localisation_reference.md`
- Variables: `Reference/variable_syntax_reference.md`
- Route and difficulty triggers: `Reference/route_difficulty_scripted_trigger.md`
- Modifiers and trait modifiers: `Reference/modifier_trans.md`
- Localization formatting: `Reference/localisation_formatting_reference.md`
- Scripted localization and `defined_text`: `Reference/hoi4_scripted_localisation_dynamic_key.md`
- AI war strategy: `common/ai_strategy/AI_Strategy_Reference/AI_war_strategy_reference.md`
- Kodoha war strategy: `common/ai_strategy/AI_Strategy_Reference/JAP_kodoha_war_strategy_reference.md`
- Post-China Kodoha AI area planning: `common/ai_strategy/AI_Strategy_Reference/JAP_kodoha_post_china_ai_area_plan.md`
- 正式版发布维护：`release_maintenance/README.md`；这是将测试版 `Japan_rework` 更新/发布到 `rance_jap_*` 正式版时的维护参考。

For the full routing index, external source paths, and migrated root notes, read `Reference/agent_reference_index.md`.

## Encoding And Line Endings

- Before writing or editing code, confirm the target file's current encoding and line endings.
- General project files: UTF-8 without BOM, LF.
- Localization files: UTF-8 with BOM.
- All project files should use LF unless an existing documented exception applies.
- `events/SEA_Japan.txt` intentionally uses UTF-8 with BOM and CRLF. Preserve that format.
- `common/decisions/JAP.txt` intentionally uses UTF-8 without BOM and CRLF. Preserve that format.
- Do not rewrite whole files or sections merely because terminal output looks garbled; first determine whether the issue is file content, read strategy, terminal output encoding, or BOM usage.

Windows PowerShell notes:

- Do not assume `Format-Hex -Count` is available. Use `Get-Content -Encoding Byte -TotalCount N` or `[System.IO.File]::ReadAllBytes(...)` for first-byte checks.
- When piping objects produced by inline `foreach` loops or multi-statement snippets, wrap the producer in `& { ... } | ...`.

## External References

- Vanilla HOI4 path: `D:\SteamLibrary\steamapps\common\Hearts of Iron IV`
- The vanilla HOI4 path is also a local Git baseline for update tracking; ordinary `rg` may obey that baseline's exclude rules and miss vanilla files. Use `rg -u` for broad vanilla script searches, only escalating to `-uu` or `-uuu` if needed, or target exact files directly.
- Standalone English MOD copy: `C:\Users\Administrator\Documents\Paradox Interactive\Hearts of Iron IV\mod\rance_jap_english`
- Standalone Japanese MOD copy: `C:\Users\Administrator\Documents\Paradox Interactive\Hearts of Iron IV\mod\rance_jap_japenese`
- External reference mods under `钢四MOD写作\参考\`: resolve under `D:\hoi4参考mod`
- Sheep's Mod AI reference: `C:\Users\Rancesamadaze\Documents\Paradox Interactive\Hearts of Iron IV\mod\sheep's mod`
- Rookie series reference mods: sibling `rookie_basic`, `rookie_ENG`, `rookie_GER`, `rookie_ITA`, and `rookie_SOV` directories under the local HOI4 mod folder

Treat external reference mods as read-only unless the user explicitly asks to edit them.

## Vanilla Overrides

If achieving the requested goal requires modifying a vanilla file and the mod workspace does not already contain the corresponding override file, do not edit vanilla in place. Identify the vanilla source, ask for user review and approval to clone it into the matching mod path, then edit the mod copy.

When full override behavior is intended, use descriptor syntax such as `replace_path="path/from/game/root"` in `.mod` descriptor files.

When cloning a vanilla file into this mod, add a short comment above its new `replace_path` entry explaining why the override exists, and add the vanilla source path to the local vanilla HOI4 Git baseline with `git add -f` so future upstream drift is visible.

## Character Work

When working on character-related content, also follow `common/characters/AGENTS.md`. This includes files under `common/characters/` and related recruitment or promotion logic in `history/countries/`, `common/national_focus/`, and `events/`.
