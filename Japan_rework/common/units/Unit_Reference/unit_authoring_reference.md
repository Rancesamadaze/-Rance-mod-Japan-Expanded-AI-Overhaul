# Unit Authoring Reference

Source: `common/units/AGENTS.md`.
Applies to: `common/units/`.

This file preserves detailed authoring notes migrated out of `common/units/AGENTS.md`. Keep the corresponding `AGENTS.md` file as a concise operating entrypoint, and update this reference when long examples, syntax notes, workflows, or lookup explanations need to be maintained.

## Migrated Notes

# Units Agents Notes

## JAP Special Unit Reference Paths

When planning or writing special units for JAP, use this directory as the target context:

`C:\Users\Administrator\Documents\Paradox Interactive\Hearts of Iron IV\mod\Japan_rework\common\units`

Use these four `rookie` unit files as temporary local reference sources:

- `C:\Users\Administrator\Documents\Paradox Interactive\Hearts of Iron IV\mod\rookie_ENG\common\units\rookie_ENG_units.txt`
- `C:\Users\Administrator\Documents\Paradox Interactive\Hearts of Iron IV\mod\rookie_GER\common\units\rookie_units_GER.txt`
- `C:\Users\Administrator\Documents\Paradox Interactive\Hearts of Iron IV\mod\rookie_ITA\common\units\rookie_ITA_units.txt`
- `C:\Users\Administrator\Documents\Paradox Interactive\Hearts of Iron IV\mod\rookie_SOV\common\units\rookie_SOV_units.txt`

Use the vanilla unit directory as the base-game reference:

`D:\SteamLibrary\steamapps\common\Hearts of Iron IV\common\units`

Do not analyze or redesign these unit definitions until the user explicitly asks for analysis or implementation.

## Unit Counter Icon Configuration

For custom special units, register all three unit icon sprites by default:

- `GFX_unit_<unit_key>_icon_medium`
- `GFX_unit_<unit_key>_icon_medium_white`
- `GFX_unit_<unit_key>_icon_small`

The `rookie_ENG_M_infantry` reference uses this pattern:

```txt
spriteType = {
	name = "GFX_unit_rookie_ENG_M_infantry_icon_medium"
	texturefile = "gfx/interface/counters/divisions_large/rookie_ENG_M_infantry_large.png"
	noOfFrames = 2
}
spriteType = {
	name = "GFX_unit_rookie_ENG_M_infantry_icon_medium_white"
	texturefile = "gfx/interface/counters/divisions_small/rookie_ENG_M_infantry_small.png"
	noOfFrames = 2
}
spriteType = {
	name = "GFX_unit_rookie_ENG_M_infantry_icon_small"
	texturefile = "gfx/texticons/rookie_ENG_M_infantry_small.png"
	legacy_lazy_load = no
	noOfFrames = 2
}
```

For a new unit key such as `Rance_JAP_M_infantry`, use the same naming convention:

```txt
GFX_unit_Rance_JAP_M_infantry_icon_medium
GFX_unit_Rance_JAP_M_infantry_icon_medium_white
GFX_unit_Rance_JAP_M_infantry_icon_small
```

Use the corresponding texture paths:

```txt
gfx/interface/counters/divisions_large/Rance_JAP_M_infantry_large.png
gfx/interface/counters/divisions_small/Rance_JAP_M_infantry_small.png
gfx/texticons/Rance_JAP_M_infantry_small.png
```

Reference image sizes from `rookie_ENG_M_infantry`:

- `divisions_large/*_large.png`: `152x42`
- `divisions_small/*_small.png`: `60x12`
- `gfx/texticons/*_small.png`: `60x12`

Keep `noOfFrames = 2` for all three sprites unless a later icon design explicitly requires a different frame count. For `icon_small`, also include `legacy_lazy_load = no`.
