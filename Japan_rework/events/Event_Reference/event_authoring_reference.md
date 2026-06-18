# Event Authoring Reference

Source: `events/AGENTS.md`.
Applies to: `events/`.

This file preserves detailed authoring notes migrated out of `events/AGENTS.md`. Keep the corresponding `AGENTS.md` file as a concise operating entrypoint, and update this reference when long examples, syntax notes, workflows, or lookup explanations need to be maintained.

## Migrated Notes

# Events Agents Notes

## Scope

These instructions apply to files under `events/`.

## File Encoding

- Before reading or editing event files, confirm the correct file encoding first.
- Unless the user specifies otherwise, event script files should preferably use `UTF-8 with BOM`.
- If an event localisation file is created or edited, use `UTF-8 with BOM`.
- Current vanilla reference for several newer event files also matches `UTF-8 with BOM`, so prefer following that convention in this project unless testing shows a reason not to.

## Current Workflow

- Event writing rules for this project are still being refined together with the user.
- Before introducing new event structure conventions, pause and follow the latest user guidance in the conversation.
- Treat this file as the future home for project-specific event authoring rules.

## Temporary Default

- When working on event-related content, prefer small, targeted edits over broad rewrites.
- Preserve the user's original paragraphing and line-break habits in event localisation text.
- If a national focus description is too long, it is acceptable to move part of the narrative into an event, but first align the event structure with the user's requested style.
- For simple narrative confirmation events, prefer a single option unless the design clearly needs branching.

## Basic Event Template

Use this baseline structure unless the user later provides a more specific project rule:

```txt
add_namespace = EVENT_NAMESPACE

country_event = {
    id = EVENT_NAMESPACE.X
    picture = GFX_EVENT_PICTURE
    title = EVENT_NAMESPACE.X.x
    desc = EVENT_NAMESPACE.X.x

    is_triggered_only = yes
    # or
    trigger = {
        ...
    }

    fire_only_once = no
    hidden = no

    immediate = {
        ...
    }

    option = {
        name = EVENT_NAMESPACE.X
        trigger = {
            ...
        }

        ...
    }

    option = {
        name = EVENT_NAMESPACE.X
    }
}
```

## Namespace And Id

- Declare `add_namespace = ...` before event definitions.
- Event ids should follow `事件前缀名.X`.
- Original vanilla style such as `germany.1` is a valid reference pattern.

## Title And Description Keys

- `title = ...` and `desc = ...` should both use localisation keys.
- These text keys must be written in the localisation file.
- The current project preference follows the user's simplified placeholder style first:
  - `title = 事件前缀名.X.x`
  - `desc = 事件前缀名.X.x`
- When following vanilla-style naming for localisation, use:
  - title: `事件前缀名.X.t`
  - desc: `事件前缀名.X.d`

## Triggering Rules

- In normal cases, `trigger = { ... }` and `is_triggered_only = yes` should be treated as alternatives.
- Prefer one or the other unless the user explicitly asks for an unusual setup.
- `trigger = { ... }` is commonly paired with `fire_only_once = yes` when the event should only happen once.
- These are working heuristics, not absolute engine laws. When a tutorial rule and vanilla code disagree, prefer verified in-game behavior and vanilla reference.

## Common Fields

- `fire_only_once = yes/no`
  - Whether the event can only fire once.
  - Default is effectively `no` unless specified otherwise.
- `hidden = yes/no`
  - Whether the event is hidden.
  - Default is effectively `no` unless specified otherwise.
- `immediate = { ... }`
  - Effects applied immediately when the event fires.

## Options

- Each `option = { ... }` should include `name = ...` using a localisation key.
- Option-specific appearance conditions can be written with `trigger = { ... }` inside the option block.
- Write the option's effects directly inside that option block.
- For multiple options, continue using additional `option = { ... }` blocks.
- Vanilla-style references for option localisation include:
  - `事件前缀名.X.a`
  - `事件前缀名.X.b`
  - `事件前缀名.X.c`

## News Event Template

Use this structure for news events:

```txt
news_event = {
    id = EVENT_NAMESPACE.X

    ...

    major = yes

    option = {
        name = EVENT_NAMESPACE.X.x
    }
}
```

## News Event Notes

- `news_event` generally follows the same structure as a normal event.
- `major = yes/no`
  - `yes`: shown globally
  - `no`: shown only to the local country

## Event Triggering Basics

Event triggering in this project is divided into:

- automatic triggering
- passive triggering

When manually firing an event from another effect such as a national focus, decision, or another event, use:

```txt
country_event = {
    id = PUM_game.1
    hours = 1
    days = 1
    random_hours = 12
    random_days = 10
}
```

Use the same general delay structure for `news_event` when needed.

## Passive Triggered Events

Passive triggered events are events fired by external effects such as:

- national focuses
- decisions
- other events

These should be treated as events without their own active trigger-checking logic.

Preferred pattern:

```txt
country_event = {
    id = PUM_game.1

    title = {
        text = PUM_game.1.t
        trigger = { tag = PUM }
    }
    # title = PUM_game.1.t

    desc = {
        text = PUM_game.1.desc
        trigger = { tag = PUM }
    }
    # desc = PUM_game.1.desc

    picture = GFX_PUM_game_1

    immediate = {
        hidden_effect = {
            if = {
                limit = { tag = PUM }
                set_country_flag = win_in_war_flag
            }
        }
    }

    is_triggered_only = yes
    hidden = yes

    option = {
        name = PUM_game.1.a
        trigger = { tag = PUM }
        ai_chance = {
            base = 100
        }
    }
    option = {
        name = PUM_game.1.b
        trigger = { NOT = { tag = PUM } }
        ai_chance = {
            base = 100
        }
    }
}
```

### Passive Event Rules

- `is_triggered_only = yes` means the event is externally triggered.
- For passive triggered events, it is usually safer to avoid combining `is_triggered_only = yes` with:
  - `trigger = { ... }`
  - `mean_time_to_happen = { ... }`
  - `fire_only_once = yes`
- In other words, passive triggered events usually do not need self-checking trigger logic.
- However, this should not be treated as an absolute prohibition:
  - vanilla files do contain cases where `is_triggered_only = yes` appears together with `fire_only_once = yes`
  - if such a combination is used, treat it as a pattern that must be tested rather than rejected on sight

## Automatic Triggered Events

Automatic triggered events are events that check their own trigger conditions.

Preferred pattern:

```txt
country_event = {
    id = PUM_game.2

    title = {
        text = PUM_game.2.t
        trigger = { tag = PUM }
    }
    # title = PUM_game.2.t

    desc = {
        text = PUM_game.2.desc
        trigger = { tag = PUM }
    }
    # desc = PUM_game.2.desc

    picture = GFX_PUM_game_2

    immediate = {
        hidden_effect = {
            if = {
                limit = { tag = PUM }
                set_country_flag = win_in_war_flag
            }
        }
    }

    fire_only_once = yes

    trigger = {
        PUM = { has_war = no }
        original_tag = PUM
    }

    mean_time_to_happen = {
        days = 1
    }

    option = {
        name = PUM_game.2.a
        trigger = { tag = PUM }
        ai_chance = {
            base = 100
        }
    }
    option = {
        name = PUM_game.2.b
        trigger = { NOT = { tag = PUM } }
        ai_chance = {
            base = 100
        }
    }
}
```

### Automatic Event Rules

- Automatic events commonly use `fire_only_once = yes` to avoid repeated firing.
- `trigger = { ... }` defines when the event becomes eligible.
- `mean_time_to_happen = { ... }` controls the periodic checking window.
- Per the user's guidance:
  - every `days = 1` in `mean_time_to_happen` corresponds to 20 in-game days between checks
  - this should not be changed casually for performance reasons

## Dynamic Title And Description Blocks

When needed, `title` and `desc` may be written as triggered blocks instead of plain keys.

Example:

```txt
title = {
    text = PUM_game.1.t
    trigger = { tag = PUM }
}
```

This allows different countries or scopes to see different text depending on conditions.

Use plain single-key forms when no differentiated display is needed:

```txt
title = PUM_game.1.t
desc = PUM_game.1.desc
```

## Hidden Effects Practice

- `immediate = { ... }` often displays text under the event body unless hidden.
- In this project, prefer putting event-on-fire setup work inside `hidden_effect` when it is technical rather than player-facing.

## News Event Detailed Notes

Triggering from effects:

```txt
news_event = {
    id = PUM_news.1
    hours = 1
    days = 1
    random_hours = 12
    random_days = 10
}
```

Full structure example:

```txt
news_event = {
    id = PUM_news.1
    title = PUM_news.1.t
    picture = GFX_news_event_nuke

    major = yes

    is_triggered_only = yes
    hidden = yes
    fire_only_once = yes

    trigger = {
        ...
    }

    mean_time_to_happen = {
        ...
    }

    immediate = {
        ...
    }

    option = {
        name = PUM_news.1.a
        trigger = {}
    }

    option = {
        name = PUM_news.1.b
        trigger = {}
    }
}
```

### News Event Rules

- `major = yes` means the whole world sees the news.
- `major = no` means only the local country sees it.
- As with country events:
  - passive news events usually use `is_triggered_only = yes`
  - passive news events usually do not also need `trigger` or `mean_time_to_happen`
- `fire_only_once = yes` is recommended for automatically triggered news events, not for passive ones.
- As above, these are usage habits rather than absolute engine bans.

## State Events

State events use the same event structure as normal events.

The special part is how they are fired:

```txt
random_core_state = {
    state_event = {
        id = gal_state_event.1
        days = 1
        trigger_for = controller
    }
}
```

### State Event Notes

- `trigger_for = controller` sends the event to the controller of the selected state.
- Other receiving scopes such as `owner` may also be used.
- Important scope rule from the user's tutorial:
  - when a country triggers a state event for another country, `FROM` points to the sending country
  - `FROM` does **not** automatically point to the state
- If state names or state-specific references are needed inside the event, use an `event_target` approach rather than assuming `FROM` is the state.

## Scope Reference

When reading or writing events, scope words such as `ROOT`, `FROM`, and `THIS` should be treated as context-dependent references, not fixed meanings.

### Core Scope Names

- `ROOT`
  - Usually the current primary scope of the event or effect block.
  - In a `country_event`, this is usually the country currently receiving or executing the event content.
- `FROM`
  - Usually the sender scope or previous external scope that triggered the current event/effect.
  - In cross-country event chains, `FROM` often points to the country that sent the event.
- `THIS`
  - Usually the current exact scope you are standing in right now.
  - Most useful in nested blocks where `ROOT` and `FROM` are broader references.
- `PREV`
  - Refers to the immediately previous outer scope.
  - Useful in nested loops or when saving / adding the previously iterated scope.

### Important Caution

- Do not treat `ROOT`, `FROM`, or `THIS` as globally fixed meanings.
- Their meaning depends on:
  - what type of event is firing
  - which scope fired it
  - how many nested blocks you are inside
  - whether you are inside an `event_target`, loop, or state scope

## Cross-Country Event Triggering

Common cross-country firing pattern:

```txt
FROM = { country_event = { id = some_event.2 days = 1 } }
```

Typical reading:

- the current scope sends an event to `FROM`
- when that follow-up event opens, `ROOT` is usually the receiving country
- `FROM` inside the follow-up event usually points back to the sender country

This is a very common vanilla pattern and should be treated as normal event chaining practice.

### Example Interpretation

If country A triggers an event for country B like this:

```txt
B = { country_event = { id = example.2 days = 1 } }
```

Then inside `example.2`:

- `ROOT` is usually country B
- `FROM` is usually country A

This is why vanilla event chains often use patterns such as:

```txt
FROM = { add_opinion_modifier = { target = ROOT modifier = some_modifier } }
```

That usually means:

- the sending country modifies opinion toward the receiving country

## Scope Usage In Nested Event Blocks

Inside nested blocks, scope meanings can shift:

```txt
option = {
    name = some_event.1.a
    FROM = {
        country_event = { id = some_event.2 days = 1 }
    }
}
```

Here:

- the option is being resolved for `ROOT`
- inside `FROM = { ... }`, the scope temporarily moves into `FROM`
- the nested `country_event` call is therefore executed from that moved scope

Always read events from the outside inward when tracking scopes.

## THIS In Triggered Title/Desc Blocks

When using triggered `title = { ... }` or `desc = { ... }`, remember:

- `THIS` is the scope currently evaluating the event text block
- in many normal country events this behaves like the recipient country scope
- but when text is evaluated through unusual scoped calls, test assumptions rather than relying on habit

## Event Targets And Scope Stability

- `event_target:some_name` is often the safest way to preserve a needed scope across later blocks.
- Prefer `event_target` when:
  - a later option must refer back to a country, state, or character selected earlier
  - plain `FROM` or `PREV` would become ambiguous after more nesting
- Vanilla Japan content uses this heavily in multi-country diplomatic chains.

## Practical Scope Guidance

- When unsure what `ROOT` or `FROM` is, inspect nearby vanilla examples first.
- For event chains involving multiple countries, prefer explicit test events or small isolated prototypes over assumption-heavy writing.
- In comments or explanation text, describe scope meaning in that specific event instead of teaching it as a universal rule.

## Event Target Guidance

Treat `event_target` like a temporary marker used to preserve and later reference a specific scope.

One especially common use is referencing a state name in event text.

Example event pattern:

```txt
country_event = {
    id = usa_state_event.1
    title = usa_state_event.1.t
    desc = usa_state_event.1.desc
    picture = GFX_event_1

    immediate = {
        hidden_effect = {
            every_core_state = {
                limit = { has_state_flag = stae_flag_2 }
                save_event_target_as = independent_usa_state
            }
        }
    }

    is_triggered_only = yes

    option = {
        name = usa_state_event.1.a
        event_target:independent_usa_state = {
            clr_state_flag = stae_flag_2
        }
        ai_chance = {
            base = 10
        }
    }
}
```

### Event Target Notes

- `save_event_target_as = ...` stores the scoped object for later use within the event.
- `event_target:some_name = { ... }` re-enters that saved scope.
- This is especially useful when:
  - the event was triggered by a country scope
  - but the text or effect should reference a specific state
- For localisation, the saved target can be referenced like:

```txt
"[independent_usa_state.GetName]宣布独立"
```

### Event Target Cleanup

- If a temporary state flag is only used to identify the target for an `event_target`, clear it after the event has locked onto the needed scope.
- Avoid leaving temporary identification flags behind if they would interfere with future event targeting.

## Project Preference From User Tutorial

- Prefer learning and authoring events in a structure that is easy to read in editors such as VS Code or Notepad++.
- Keep the distinction between passive and automatic events explicit.
- When in doubt, preserve the user's terminology and teaching framing rather than rewriting everything into abstract engine language.
