# Character Authoring Reference

Source: `common/characters/AGENTS.md`.
Applies to: `common/characters/ and related recruitment or promotion hooks`.

This file preserves detailed authoring notes migrated out of `common/characters/AGENTS.md`. Keep the corresponding `AGENTS.md` file as a concise operating entrypoint, and update this reference when long examples, syntax notes, workflows, or lookup explanations need to be maintained.

## Migrated Notes

# Characters Agents Notes

## Scope

These instructions apply to files under `common/characters/`.

## File Structure

Character definitions are written in `common/characters/XXX.txt` under the `characters = { ... }` root.

Use this general structure:

```txt
characters = {
    CHARACTER_ID = {
        name = CHARACTER_NAME_LOC_KEY

        portraits = {
            civilian = {
                large = ...
                small = ...
            }
            army = {
                large = ...
                small = ...
            }
        }

        country_leader = { ... }
        advisor = { ... }
        field_marshal = { ... }
        corps_commander = { ... }
        navy_leader = { ... }
    }
}
```

Only add the role blocks that are actually needed by the design.

## Portrait Usage

- Use `portraits.civilian` for civilian-facing roles such as national leaders and political advisors.
- Use `portraits.army` for military-facing roles such as generals, admirals, and military staff positions like army chiefs or similar armed-forces advisors.
- Portrait entries can use either direct gfx paths or `GFX_...` sprite names.
- If a character will never serve in a military-facing role, `army` portraits can be omitted.
- If a character will never serve in a civilian-facing role, `civilian` portraits can be omitted.

## Role Blocks

- Do not add military role blocks if the character is not intended to become a general, field marshal, or admiral.
- Do not add `country_leader` if the character is not intended to start as a national leader.
- Candidate or future leaders can be defined with only `name` and the needed portraits, then receive the leader role later through content.
- `advisor` roles follow the same general logic as legacy advisors, including `slot`, `idea_token`, `traits`, and `ai_will_do`.
- `field_marshal`, `corps_commander`, and `navy_leader` follow the same general logic as legacy military leaders.
- `legacy_id` may be kept when compatibility with older content matters.

## Project Conventions

- Group characters by purpose when helpful, such as leader candidates, advisors, and commanders.
- Prefer stable naming sets across linked content:
  - character id: `TAG_context_name`
  - advisor idea token: `TAG_name`
  - trait: `character_id_trait` or another clearly paired name
- Keep the naming relationship easy to trace across character, idea, trait, portrait, and localization files.

## Related Trait File

When creating custom leader traits for this mod's custom characters, use `common/country_leader/Japan_rework_trait.txt`.

- Treat `common/country_leader/Japan_rework_trait.txt` as the default file for self-created custom character leader traits.
- When generating a new custom leader trait for a Japan rework character, write it there unless the user explicitly asks for another file.

## Advisor Trait Sprite Lookup

When assigning advisor trait icons through `sprite = xx`, use `Reference/advisor_trait_sprite_reference.md` as the primary lookup reference.

- Check that reference first when choosing an icon for a new advisor trait.
- If the intended advisor type already has a confirmed project convention, prefer reusing the same sprite number.

## Naming Habits In This Mod

When adding Japanese rework custom characters, prefer following the naming style already used in `JAP_rework.txt`.

- Character ids often use `TAG_rework_name`, for example `JAP_rework_mimo`.
- Advisor `idea_token` values are usually shortened to `TAG_name`, for example `JAP_mimo`.
- Character traits usually stay paired with the character id, for example `JAP_rework_mimo_trait`.
- Portrait sprite names usually stay paired with the character id as well, for example:
  - small portrait: `GFX_JAP_rework_mimo_small`
  - large portrait when actually needed: `GFX_JAP_rework_mimo`
- Character `name = ...` should point to the localization key used for that person name. Keep it intentionally aligned with the localization setup and avoid ad-hoc display strings when possible.

Preferred relationship:

```txt
character id   = JAP_rework_mimo
name loc key   = JAP_rework_mimo
idea_token     = JAP_mimo
trait          = JAP_rework_mimo_trait
portrait small = GFX_JAP_rework_mimo_small
portrait large = GFX_JAP_rework_mimo (only when the role needs a large portrait)
```

If expanding an existing naming family, match the established pattern instead of inventing a new one.

If the user provides a name that does not follow the usual pattern, follow the actual user-provided name instead of forcing the convention.

## Advisor Patterns In This Mod

Common custom advisor entries in this mod often use a structure like:

```txt
advisor = {
    idea_token = TAG_name
    desc = TAG_name_desc
    slot = political_advisor
    cost = 100
    allowed = {
        original_tag = JAP
    }
    traits = {
        SOME_TRAIT
    }
    ai_will_do = {
        base = 100
    }
}
```

When editing or generating similar Japanese custom advisors:

- Prefer `allowed = { original_tag = JAP }` when the design is meant for Japan-origin countries rather than only the current `JAP` tag.
- Reuse the established `cost`, `allowed`, and `ai_will_do` structure unless the design calls for something different.
- Common `ai_will_do.base` values in existing content include `75` and `100`.
- Advisor descriptions can be written directly in the advisor block with `desc = SOME_KEY`.
- When using advisor descriptions, prefer pairing them with the advisor `idea_token`, for example:
  - `idea_token = JAP_erin`
  - `desc = JAP_erin_desc`
- Put the matching localization in the character localization file when the description belongs to a Japan rework custom character.
- For long character `desc` text, it is acceptable to wrap the full localization string in `§L ... §!` so the body text appears in a light gray style by default.

## Advisor Weighting

When managing AI weights for advisors, use the same 1/50/100 gradient for every advisor slot: `political_advisor`, `theorist`, `high_command`, `army_chief`, `navy_chief`, and `air_chief`.

Default pattern:

```txt
ai_will_do = {
    base = 1
}
```

Tier pattern:

- default / no planned route tier: `1`
- second tier: `1 * 50 = 50`
- first tier: `1 * 100 = 100`

Recommended route-sensitive structure:

```txt
ai_will_do = {
    base = 1
    modifier = {
        factor = 100
        Rance_is_jap_lecture_ai = yes
    }
}
```

or:

```txt
ai_will_do = {
    base = 1
    modifier = {
        factor = 50
        Rance_is_jap_lecture_ai = yes
    }
}
```

Project habit:

- Treat `base = 1` as the neutral fallback weight for every advisor unless the user explicitly requests another baseline.
- Only route-tier `modifier` blocks containing a scripted trigger such as `Rance_is_jap_lecture_ai = yes` or `Rance_is_jap_kodoha_ai = yes` may contain `factor`.
- Route-tier `factor` values are limited to `50` for second tier and `100` for first tier.
- Advisors outside the planned route tiers must have only `base = 1` inside `ai_will_do`; do not add top-level `factor`, non-route conditional `factor`, or other weighting modifiers.
- Write each route's multiplier as its own `modifier` block so later routes can be extended without rewriting the whole advisor.

Typical route-layering example:

```txt
ai_will_do = {
    base = 1
    modifier = {
        factor = 100
        Rance_is_jap_lecture_ai = yes
    }
    modifier = {
        factor = 50
        Rance_is_jap_kodoha_ai = yes
    }
}
```

Use this pattern when a character should keep an explicit tier on more than one route without replacing the earlier route setup.

## Minimal Authoring Principle

Do not pad a character with unused portraits or unused roles.

Write the minimum valid definition for the roles the character is actually expected to perform in content.

## Recruitment Hook

After creating a new custom Japanese character intended to be available in-game, also update the recruitment setup in `history/countries/JAP - Japan.txt` when needed.

- For characters that should be available from country history setup, add the matching `recruit_character = CHARACTER_ID` entry there.
- Place new entries inside the dedicated Japan rework custom character recruitment block in that file.
- Preserve and extend the block markers, separator comments, and subgroup comments so the section remains easy to locate later.
- If the design is not meant to recruit the character from history setup, do not add the entry automatically.

## Focus Tooltip Pattern For Unlocking Political Advisors

When a national focus unlocks an advisor, prefer following the existing `JAP_fukumotoism` pattern from `common/national_focus/japan.txt`.

Before choosing the standard tooltip key, check `Reference/advisor_unlock_tooltip_reference.md`.

Recommended `completion_reward` structure:

```txt
completion_reward = {
    ...
    custom_effect_tooltip = generic_skip_one_line_tt
    custom_effect_tooltip = SOME_FOCUS_CUSTOM_TT
    custom_effect_tooltip = generic_skip_one_line_tt
    custom_effect_tooltip = available_political_advisor
    show_ideas_tooltip = TAG_name
}
```

Meaning of each line:

- First `generic_skip_one_line_tt`: visually separates the advisor unlock section from the effects above it.
- `SOME_FOCUS_CUSTOM_TT`: describes the focus-specific extra effect if there is one.
- Second `generic_skip_one_line_tt`: visually separates the extra effect line from the advisor unlock line.
- `available_xxx`: uses the standard game wording for unlocking the relevant advisor type.
- `show_ideas_tooltip = TAG_name`: displays the advisor being unlocked in the tooltip area.

Project habit:

- If the focus only unlocks an advisor and has no extra effect worth calling out, it is acceptable to omit `SOME_FOCUS_CUSTOM_TT` and keep the unlock lines concise.
- If the focus both grants a special effect and unlocks an advisor, prefer the `福本主义` ordering above instead of collapsing everything into one custom tooltip line.
- When possible, prefer the standard advisor unlock line plus `show_ideas_tooltip` over writing the advisor name entirely inside a custom tooltip string.
- Choose the unlock line by advisor `slot`, for example:
  - `political_advisor` -> `available_political_advisor`
  - `theorist` -> `available_theorist`
  - `high_command` -> `available_military_high_command`

## Promoting Alternate Leaders

When a character is only a candidate or alternate national leader, do not prefill `country_leader = { ... }` in the character file unless the design truly needs the role at game start.

Instead, make the character become leader from the relevant focus, event, or other effect with this pattern:

```txt
add_country_leader_role = {
    character = CHARACTER_ID
    promote_leader = yes
    country_leader = {
        ideology = ...
        expire = "YYYY.M.D.H"
        traits = { ... }
    }
}
```

For current project needs, prefer this direct promotion pattern for alternate leaders and do not add extra fallback logic unless the user explicitly asks for it.

## Leader Traits On Promotion

When an alternate leader takes power through a focus, event, or similar effect, prefer giving the leader traits directly inside the promoted `country_leader = { ... }` block:

```txt
add_country_leader_role = {
    character = CHARACTER_ID
    promote_leader = yes
    country_leader = {
        ideology = ...
        expire = "YYYY.M.D.H"
        traits = { LEADER_TRAIT }
    }
}
```

This is the default pattern to use when the promoted leader should immediately gain the intended trait set on taking office.

## Leader Desc On Promotion

For leaders who take power later through `add_country_leader_role`, leader description display may need to be set in the promotion block itself instead of relying only on the base character definition.

Preferred pattern:

```txt
add_country_leader_role = {
    character = CHARACTER_ID
    promote_leader = yes
    country_leader = {
        ideology = ...
        desc = CHARACTER_DESC_KEY
        expire = "YYYY.M.D.H"
        traits = { LEADER_TRAIT }
    }
}
```

Recommended practice in this project:

- if a character is expected to become national leader later, keep the matching localization key such as `CHARACTER_ID_desc`
- when promoting that character into power through an event, focus, or similar effect, also set `desc = CHARACTER_ID_desc` inside the promoted `country_leader = { ... }` block
- do not assume that putting `desc = ...` only in the base character definition is always enough for post-promotion leaders

Example based on current project behavior:

- character: `JAP_rework_kaguya`
- desc key: `JAP_rework_kaguya_desc`
- promotion block should include: `desc = JAP_rework_kaguya_desc`

If the promotion flow also needs to clean up or replace traits after the leader is in power, follow the pattern used in `JAP_cede_leadership_to_mao`:

```txt
add_country_leader_role = {
    character = CHARACTER_ID
    promote_leader = yes
    country_leader = {
        ideology = ...
        expire = "YYYY.M.D.H"
        traits = { NEW_TRAIT }
    }
}

CHARACTER_ID = {
    remove_country_leader_trait = OLD_TRAIT
    add_country_leader_trait = NEW_TRAIT
}
```

Use the second pattern only when there is a real need to normalize, replace, or clean up existing leader traits after promotion.

## Leader Traits After Promotion

When the trait recipient is already the active country leader, prefer using only:

```txt
add_country_leader_trait = LEADER_TRAIT
```

Do not also add a redundant:

```txt
hidden_effect = {
    add_trait = {
        character = CHARACTER_ID
        ideology = ...
        trait = LEADER_TRAIT
    }
}
```

Use the extra character-scoped `add_trait` pattern only when the user explicitly wants dual-writing for a special persistence reason, or when the content is handling a real post-promotion cleanup / replacement case that requires it.
