# Formal Release Unique Content Inventory

Applies to:

- `rance_jap_chinese`
- `rance_jap_english`
- `rance_jap_japenese`

Purpose: track content that is allowed or expected to differ between formal release targets. Do not use this file as a general diff report. Temporary drift and outdated target files should stay in `release_maintenance/formal_release_diff_inventory.md` until they are either synchronized or intentionally promoted into this inventory.

Last checked: 2026-06-18.

## Long-Term Target-Owned Content

These paths are expected to remain target-specific and should be treated as release overlay or packaging metadata.

| Path | Why target-specific | Notes |
| --- | --- | --- |
| `descriptor.mod` | Store-facing mod identity differs per language release. | Do not sync `name` or `remote_file_id`; sync all other fields from `Japan_rework`. |
| sibling launcher file: `rance_jap_*.mod` | Same target identity as `descriptor.mod`, plus local `path`. | Do not sync `name`, `path`, or `remote_file_id`; sync all other fields from `Japan_rework`'s `descriptor.mod`. |
| `thumbnail.png` | Steam Workshop / launcher thumbnail can be localized per formal release. | Current scan found no differing files inside formal `gfx/`; only root `thumbnail.png` differs. |
| dedicated localization directory | Each formal release owns only its target language. | Chinese keeps `localisation/simp_chinese/`, English keeps `localisation/english/`, Japanese keeps `localisation/japanese/`. |

Descriptor identity fields that should be listed explicitly per target:

| Target | `name` | `path` in parent launcher `.mod` | `remote_file_id` |
| --- | --- | --- | --- |
| `rance_jap_chinese` | `[Rance-mod] 日本拓展与AI强化` | `C:/Users/Administrator/Documents/Paradox Interactive/Hearts of Iron IV/mod/rance_jap_chinese` | `3745946778` |
| `rance_jap_english` | `[Rance-mod] Japan Expanded & AI Overhaul` | `C:/Users/Administrator/Documents/Paradox Interactive/Hearts of Iron IV/mod/rance_jap_english` | `3745947516` |
| `rance_jap_japenese` | `[Rance-mod] 日本拡張＆AI強化` | `C:/Users/Administrator/Documents/Paradox Interactive/Hearts of Iron IV/mod/rance_jap_japenese` | `3745947764` |

Descriptor fields that should sync from `Japan_rework`:

- `version`
- `tags` (current full set: `National Focuses`, `Gameplay`, `Military`, `Balance`, `Historical`, `Alternative History`)
- `dependencies`
- `replace_path`
- `supported_version`

## Name Overlay Content

These files currently differ because HOI4 script fields require hard string names for equipment variants, templates, OOB entries, fleets, ships, or name pools. They should remain target-specific unless a later refactor makes them common.

| Path | Difference type | Maintenance direction |
| --- | --- | --- |
| `common/scripted_effects/JAP_equipment_scripted_effects.txt` | Equipment variant `name = "..."`. | Keep target-owned. |
| `common/scripted_effects/JAP_templates_scripted_effects.txt` | Template `name = "..."`, `has_template = "..."`, `division_template = "..."`. | Keep target-owned. |
| `common/scripted_effects/JAP_named_focus_scripted_effects.txt` | Focus reward equipment and ship names extracted from `common/national_focus/japan.txt`. | Keep target-owned as the language overlay for the common focus file. |
| `common/units/names_ships/JAP_ship_names.txt` | Ship fallback names and ship name pools. | Keep target-owned. |
| `history/general/taog_hq_template.txt` | HQ template names such as NKVD / general staff labels. | Keep target-owned unless all names are deliberately normalized. |
| `history/units/JAP_1936_air_bba_rance.txt` | Starting air equipment `version_name = "..."`. | Keep target-owned. |
| `history/units/JAP_1936_air_bba_vanilla.txt` | Starting air equipment `version_name = "..."`. | Keep target-owned. |
| `history/units/JAP_1936_naval_rance.txt` | Fleet names, ship names, and ship class `version_name = "..."`. | Keep target-owned. |
| `history/units/JAP_1936_nsb_rance.txt` | Starting unit/template visible names. | Keep target-owned. |
| `history/units/JAP_1936_nsb_vanilla.txt` | Starting unit/template visible names. | Keep target-owned. |

## Temporary Drift To Eliminate

These files differ in the formal releases today, but should not be treated as permanent unique content without a fresh decision.

| Path | Current reason | Desired state |
| --- | --- | --- |
| descriptor metadata outside identity fields | Formal descriptors should match `Japan_rework` except for `name`, parent launcher `path`, and `remote_file_id`. | Sync when preparing the final release descriptor pass. |

Recently eliminated from temporary drift:

- `common/national_focus/japan.txt`: unified across the three formal releases and `Japan_rework` after extracting named reward blocks to `common/scripted_effects/JAP_named_focus_scripted_effects.txt`.
- `events/JAP_jcp_events.txt`: localized `log = ...` block removed, so the file no longer needs a language overlay.
- non-dedicated localization directories: removed from all three formal releases; each release now carries only its target language.

## Not Currently Unique

- Formal `gfx/` directory contents matched by file count and did not appear in the hash-difference list; only root `thumbnail.png` differed.
- The formal release directories had the same top-level structure: `.git`, `common`, `events`, `gfx`, `history`, `interface`, `localisation`, `descriptor.mod`, and `thumbnail.png`.

## Checklist For Release Sync

Before overwriting a formal target from `Japan_rework`:

- Preserve `descriptor.mod`, the sibling `rance_jap_*.mod`, and `thumbnail.png`.
- For descriptors, preserve only `name`, parent launcher `path`, and `remote_file_id`; sync all other descriptor fields from `Japan_rework`.
- Preserve all files listed under `Name Overlay Content`.
- Preserve only the target's dedicated localization directory.
- Exclude all folders and patterns listed under `never_release` in `formal_release_diff_inventory.md`, especially `release_maintenance/`, `Reference/`, `ISSUES/`, `PLAN/`, `INTRODUCTION/`, `asset_sources/`, `tool/`, `tmp/`, `update_fit/`, `*.md`, and `AGENTS.md`.
- Do not preserve `common/national_focus/japan.txt` as target-specific once the named focus scripted-effect overlay exists in all formal releases.
- Do not delete `events/JAP_jcp_events.txt` alone while `common/decisions/JAP_jcp_decision.txt` still calls `japan_jcp.11`.
