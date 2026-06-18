# Release Maintenance

This folder is the single workspace for maintaining the three formal `rance_jap_*` release targets from the `Japan_rework` test mod.

Use these files together:

- `formal_release_diff_inventory.md`: current sync differences, refactor status, never-release files, and recommended release-sync order.
- `formal_release_unique_content_inventory.md`: formal-release content that is expected to remain target-specific.

Current policy:

- Keep non-localization formal-release differences recorded here before syncing from `Japan_rework`.
- Keep target-language hardcoded visible names in explicit per-target overlay files.
- Do not maintain generation scripts until a repeated manual maintenance burden justifies them.

Default release-sync shape:

- Copy common gameplay files from `Japan_rework` only after applying the never-release exclusions in `formal_release_diff_inventory.md`.
- Preserve formal target-owned files listed in `formal_release_unique_content_inventory.md`.
- For `descriptor.mod` and parent launcher `.mod` files, preserve only formal identity fields (`name`, parent `path`, `remote_file_id`) and sync all other descriptor fields from `Japan_rework`.
- Keep descriptor `tags` complete in `Japan_rework` first, then sync them outward; current release tags are `National Focuses`, `Gameplay`, `Military`, `Balance`, `Historical`, and `Alternative History`.
- Never copy `release_maintenance/` itself into a formal target.
- Never copy Markdown/reference/agent files into formal targets unless a specific file is deliberately promoted to runtime content.
