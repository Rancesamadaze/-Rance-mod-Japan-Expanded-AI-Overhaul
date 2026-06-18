# Doctrine Authoring Reference

## Rance Grand Doctrine Placement

Project-exclusive Rance grand doctrines belong in one shared script file:

`common/doctrines/grand_doctrines/rance_grand_doctrines.txt`

Do not split Rance land, naval, and air grand doctrines into subdirectories or separate per-branch files unless the user explicitly asks for that layout.

## Grand Doctrine Skeleton

Use one top-level block per grand doctrine. Keep the script key stable because history, decisions, AI, and modifiers can refer to it directly.

```hoi4
rance_example_grand_doctrine = {
    folder = land

    name = RANCE_GRAND_DOCTRINE_EXAMPLE
    description = RANCE_GRAND_DOCTRINE_EXAMPLE_DESC
    icon = GFX_doctrine_grand_battleplan_medium
    available = {
        always = yes
    }

    xp_cost = 100
    xp_type = army

    ai_will_do = {
        base = 0
    }

    tracks = {
        infantry
        combat_support
        armor
        operations
    }

    # Immediate activation effects go here.

    milestones = {
        {
            # Track 1 milestone effects.
        }
        {
            # Track 2 milestone effects.
        }
        {
            # Track 3 milestone effects.
        }
        {
            # Track 4 milestone effects.
        }
    }
}
```

Folder and XP type pairs:

- Land: `folder = land`, `xp_type = army`
- Naval: `folder = naval`, `xp_type = navy`
- Air: `folder = air`, `xp_type = air`

## Track And Milestone Order

Milestone blocks are positional. The first milestone belongs to the first track in `tracks`, the second milestone belongs to the second track, and so on.

Current default track orders:

- Land: `infantry`, `combat_support`, `armor`, `operations`
- Naval: `submarines`, `screens`, `carriers`, `capital_ships`
- Air: `fighter_aircraft`, `strike_aircraft`, `medium_aircraft`, `heavy_aircraft`

## Milestone Counter Blocks

Project grand doctrine milestones should keep the existing counter-effect pattern used by the vanilla-style files in this folder. Put one block in each milestone, using the variable that matches the track.

```hoi4
effect = {
    if = {
        limit = {
            NOT = {
                has_variable = infantry_milestone_var
            }
        }
        set_variable = { infantry_milestone_var = 1 }
    }
    else = {
        add_to_variable = { infantry_milestone_var = 1 }
    }
}
```

Default land variable names:

- `infantry_milestone_var`
- `support_milestone_var`
- `armor_milestone_var`
- `operations_milestone_var`

Default naval variable names:

- `submarines_milestone_var`
- `screens_milestone_var`
- `carriers_milestone_var`
- `capital_ships_milestone_var`

Default air variable names:

- `fighters_milestone_var`
- `strikers_milestone_var`
- `mediums_milestone_var`
- `heavies_milestone_var`

## Localization And Validation

Grand doctrine `name` and `description` should point to localization keys. For Rance/Japan-specific doctrine text, prefer `localisation/simp_chinese/JAP_rework_doctrines_l_simp_chinese.yml`; do not put these keys in `localisation/simp_chinese/SEA_focus_l_simp_chinese.yml` unless explicitly requested.

Useful checks after editing:

- Brace balance for touched doctrine scripts.
- `git diff --check -- <touched files>`
- Encoding and line endings for touched files.
