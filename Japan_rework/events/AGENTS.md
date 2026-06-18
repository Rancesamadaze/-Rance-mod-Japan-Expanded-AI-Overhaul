# Events Agents Notes

## Scope

Applies to files under `events/`.

## Required Reference

Read `events/Event_Reference/event_authoring_reference.md` before creating or substantially revising event structure, triggering style, news events, state events, scope handling, `THIS`, `FROM`, or `event_target` logic.

Use root references for localized event titles, state names, localization formatting, variables, and scripted localization when those topics appear in event work.

## Encoding

Event files generally follow the project event convention recorded in `events/Event_Reference/event_authoring_reference.md`.

`events/SEA_Japan.txt` is a documented exception: preserve UTF-8 with BOM and CRLF line endings.

Before editing any existing event file, verify its current encoding and line endings and preserve them unless the user explicitly requests a conversion.

## Operating Rules

- Keep namespace, id, title, desc, picture, trigger, immediate, and option structure consistent with existing nearby events.
- Use hidden effects when effect text should not appear in the event body.
- Treat `ROOT`, `FROM`, and `THIS` as context-dependent scopes; do not assume fixed meanings without checking the surrounding block.
- Use saved event targets when text or effects must refer back to a specific state or country after scope changes.
- If vanilla event behavior and tutorial-style notes conflict, prefer verified vanilla behavior or tested project examples.
