# Japan Rework Agents Notes

## Directory AGENTS

Before reading, editing, or creating files inside a specific directory, first check whether that directory or one of its relevant parent directories contains an `AGENTS.md` file, and follow those directory-specific instructions in addition to this root file.

Keep `AGENTS.md` files as concise operating entrypoints. Longer syntax notes, examples, workflow records, and lookup explanations belong in reference files. The detailed root notes migrated from this file live in `Reference/agent_reference_index.md`.

## Core Workflow

- If the user's IDE selection, active file excerpt, or pasted snippet appears incomplete, recover the surrounding file context before asking them to reselect or paste more.
- If the user corrects or stops one mistaken direction, identify the precise mistaken change and preserve still-valid edits unless rollback scope is explicit.
- For doc-only requests, do not slip into live gameplay edits.
- For report-only, audit-only, search-only, or compatibility-review requests, stay read-only and do not edit files unless the user explicitly authorizes implementation changes.
- Do not insert new localization entries into `localisation/simp_chinese/SEA_focus_l_simp_chinese.yml` unless the user explicitly requests that file.
- For issue-tracked fixes, do not remove fixed items immediately; mark them as `待检验` until in-game or log verification confirms them.
- For generated image assets, keep only files directly referenced by game registrations under game-loaded paths such as `gfx/`; move preview PNGs, editable sources, and other non-direct-use image assets into `asset_sources/`.

## Optional HOI4 Tooling

RHoiScribe 0.2.1 is temporarily disabled for this repository. Do not invoke the local `rhoiscribe-hoi4` skill, RHoiScribe MCP/tools, or RHoiScribe-generated repairs/formatting during normal work.

Re-enable RHoiScribe only after the user explicitly says it is usable again and asks to restore the workflow. Until then, rely on this repository's AGENTS rules, live file inspection, installed vanilla references, and targeted local validation scripts.

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
