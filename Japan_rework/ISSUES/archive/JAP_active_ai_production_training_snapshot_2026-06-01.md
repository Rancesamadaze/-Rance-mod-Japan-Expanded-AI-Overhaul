# JAP active AI production and training snapshot - 2026-06-01

状态：已完成

已处理：陆军部分装备降产策略；AI 扩军欲望随服役主装备充足度提升

This note records the strategy state shown in the user screenshot and the code paths that matter for the current production/training problem.

## Partial completion record

- Hardened decline strategy payloads for `infantry_equipment`, `support_equipment`, `artillery_equipment`, `anti_tank_equipment`, and `anti_air_equipment` in `common/ai_strategy/JAP_rework_ai_land_production_v2.txt`.
- All five target decline strategies now apply `equipment_production_min_factories_archetype value = -99` and `equipment_variant_production_factor value = -150`.
- Added an AI wanted-divisions layer in `common/ai_strategy/JAP_rework_ai_template_v2.txt`, driven by the 45-day land production/template loop.
- The new expansion-desire flag starts when any effective non-infantry main equipment has deployed fill ratio `> 1.50`, stops when all effective entries are at or below `1.20`, and adds `ai_wanted_divisions_factor value = 100` on top of the difficulty base `0/20/40/60/90/120`.

## Screenshot-active production and training strategies

Land production v2 strategies visible in the screenshot:

- Baselines: `JAP_ai_land_production_infantry_equipment_baseline`, `JAP_ai_land_production_mechanized_equipment_baseline`, `JAP_ai_land_production_amphibious_mechanized_equipment_baseline`, `JAP_ai_land_production_medium_tank_chassis_baseline_below_lunatic`, `JAP_ai_land_production_medium_tank_amphibious_chassis_baseline_below_lunatic`, `JAP_ai_land_production_support_equipment_baseline`, `JAP_ai_land_production_helicopter_equipment_baseline`, `JAP_ai_land_production_armored_support_vehicle_baseline`, `JAP_ai_land_production_medium_tank_destroyer_chassis_baseline`, `JAP_ai_land_production_medium_tank_artillery_chassis_baseline`, `JAP_ai_land_production_medium_tank_aa_chassis_baseline`, `JAP_ai_land_production_medium_tank_flame_chassis_baseline`.
- Declines: `JAP_ai_land_production_infantry_equipment_decline`, `JAP_ai_land_production_mechanized_equipment_decline`, `JAP_ai_land_production_amphibious_mechanized_equipment_decline`, `JAP_ai_land_production_medium_tank_chassis_decline`, `JAP_ai_land_production_medium_tank_amphibious_chassis_decline`, `JAP_ai_land_production_support_equipment_decline`, `JAP_ai_land_production_helicopter_equipment_decline`, `JAP_ai_land_production_armored_support_vehicle_decline`, `JAP_ai_land_production_medium_tank_destroyer_chassis_decline`, `JAP_ai_land_production_medium_tank_artillery_chassis_decline`, `JAP_ai_land_production_medium_tank_aa_chassis_decline`, `JAP_ai_land_production_medium_tank_flame_chassis_decline`, `JAP_ai_land_production_artillery_equipment_decline`, `JAP_ai_land_production_anti_air_equipment_decline`.

Air production strategies visible in the screenshot:

- `JAP_rework_default_air`
- `JAP_rework_air_banned_production`
- `JAP_rework_mothership_production_increase`
- `JAP_rework_fighter_production_reduce`
- `JAP_rework_heavy_fighter_production_reduce`
- `JAP_always_cv_production`
- `JAP_rework_maritime_patrol_plane_production_reduce`
- `JAP_rework_intercontinental_bomber_production_increase`
- Vanilla/default `build_patrol_bombers`

Supplemental screenshot count:

- Maritime patrol bombers: `2831` total, shown as `G5M1 九八式陆上攻击机 “鸣神”`.

Training/template strategy visible in the screenshot:

- `JAP_ai_template_v2_regular_armor_hard`
- No `JAP_ai_template_v2_suppress_*` strategy is visible in the screenshot segment, so the currently visible training problem is not explained by an active v2 suppression block alone.

## Relevant loops and thresholds

- `common/decisions/JAP_rework_equipment_design_decision.txt` starts the AI land production loop once military factories exceed 100.
- `JAP_ai_land_production_equipment_cycle_mission` refreshes production flags every 15 days.
- `JAP_ai_land_production_template_suppression_cycle_mission` refreshes training suppression flags every 45 days and also runs the extra-equipment grant cycle.
- Land production decline starts at deployed-fill ratio `> 1.15` for high-demand equipment and `> 1.10` for low-demand equipment in replenishment mode. Outside replenishment mode, infantry decline starts at stockpile ratio `> 0.25` at war and support equipment decline starts at stockpile ratio `> 0.35` at war.
- Training suppression starts when `(stockpile / 1000 + equipment in armies k) / target equipment in armies k < 0.90` and stops above `1.05`.
- Maritime patrol plane thresholds are low `200`, high `800`, increase-stop `400`, reduce-stop `600`; the trigger counts stockpile plus deployed planes.

## Useful findings for the current problem

### 1. Rifle and support-equipment factories（已处理）

The AI is reducing them, but the current v2 decline payload is too soft for the observed stockpile.

- Infantry baseline still guarantees `equipment_production_min_factories_archetype id = infantry_equipment value = 10`.
- Support baseline still guarantees `equipment_production_min_factories_archetype id = support_equipment value = 5`.
- Infantry decline only applies `equipment_variant_production_factor id = infantry_equipment value = -75`.
- Support decline only applies `equipment_variant_production_factor id = support_equipment value = -85`.
- Unlike several other decline blocks, infantry/support decline does not remove the minimum-factory floor with `equipment_production_min_factories_archetype`.

Likely implication: the decline flag is correctly active, but it is only biasing the chosen variant downward. It does not force the AI to clear the large existing allocation, so generic demand, role-ratio demand, stockpile/surplus management, and production-line inertia can still leave many factories on infantry equipment and support equipment.

Most relevant fix direction: add a negative `equipment_production_min_factories_archetype` entry to the infantry/support decline blocks, and consider making extreme-surplus decline stronger than the current `-75/-85` variant factor.

Implemented direction: hardened the land production decline payloads for infantry equipment and support equipment, alongside artillery, anti-tank, and anti-air equipment. The target decline strategies now apply negative minimum-factory archetype pressure and stronger variant production reduction so active decline flags can clear excessive allocations instead of only biasing variants downward.

### 2. Few training divisions despite surplus stockpile（已完成）

The visible active v2 template strategy is `JAP_ai_template_v2_regular_armor_hard`, which only sets composition weights:

- `JAP_infantry = 50`
- `JAP_special_infantry_tank = 50`
- `JAP_mechanized_tank = 100`
- `JAP_amphibious_mechanized = 150`

It does not set `ai_wanted_divisions_factor`, `template_prio`, or a direct recruitment count. Therefore it can tell the AI what kind of divisions to prefer, but it does not strongly force the AI to put more divisions into the training queue.

Likely implication: the stockpile surplus is real, but the current training layer is mostly a role-composition layer. If the goal is to spend the surplus on more divisions, production fixes alone are insufficient; we need a training-demand lever as well.

Most relevant fix direction: add a hard training demand/priority strategy for the desired templates, or use a controlled AI decision/effect to create/queue more divisions when stockpile is high and active fronts need units.

Implemented direction: the 45-day equipment/template loop now updates `JAP_ai_template_expansion_desire_active` after equipment grants. The trigger deliberately ignores stockpile surplus and checks only deployed fill ratio for effective non-infantry main equipment, so it asks the AI to train more when currently fielded mechanized/tank equipment is overfilled rather than merely stored.

### 3. Too many factories on maritime patrol bombers（已处理）

The screenshot shows `JAP_rework_maritime_patrol_plane_production_reduce` active, and the supplemental count shows `2831` maritime patrol bombers. This is far above the current high threshold `800`, so the high production was not caused by a missing high-stock trigger or a threshold that was barely being crossed.

Important pressure sources originally still active:

- `JAP_rework_default_air` keeps `air_factory_balance = 33`.
- Vanilla/rookie default `build_patrol_bombers` was active for BBA countries with navy size `> 1` and added `unit_ratio id = maritime_patrol_plane value = 2`.
- `JAP_rework_air_factory_balance_all_high_stock_reduce` only reduces total air factory balance when fighter, CAS, heavy fighter, and every designed special aircraft are all above high thresholds. If mothership/intercontinental bomber demand is still low, total air allocation can remain high.
- With fighter/CAS/heavy fighter reduced and tactical/CV CAS banned, the remaining air-factory demand can pool into maritime patrol bombers and other large-plane lines.

Chosen fix direction: do not use negative `unit_ratio` or stockpile-gate the positive ratio to `0`, because both can make AI stop deploying that plane type. Instead, detach Japan from vanilla/rookie generic air `unit_ratio` and move Japan's air ratios into project-owned strategies for debugging.

Implemented direction: cloned `common/ai_strategy/default.txt` from `rookie_basic`, added `replace_path="common/ai_strategy/default.txt"`, and excluded `original_tag = JAP` from the cloned generic air ratio blocks `bba_air_prod_1`, `build_patrol_bombers`, `default_spyplanes_production`, and `minors_dont_spy`. Added `JAP_rework_air_unit_ratio_baseline` for Japan-owned positive air ratios and `JAP_rework_maritime_patrol_plane_unit_ratio` for maritime patrol bombers. Current baseline ratios are `fighter = 500`, `cas = 20`, `strategic_bomber = 5`, `heavy_fighter = 1`, `cv_fighter = 5`, and `cv_naval_bomber = 5`; `tactical_bomber` and `naval_bomber` are omitted from positive ratio demand and banned through production-side factors. The maritime patrol ratio stays positive when BBA, navy size, and the Japan maritime patrol design are valid; high-stock reduction is left to production-side levers instead of disabling deployment demand.

Follow-up tuning: softened `JAP_rework_fighter_production_reduce` so light fighters remain the main air-factory buffer. The high-stock fighter reduction now uses `equipment_production_factor fighter = -40` and no longer hard-blocks fighter production with `build_airplane fighter = -99999`; this should reduce factory spillover into maritime patrol bombers and other niche airframes.

### 4. Kodoha core-state decision AI usage tendency（已处理）

The Kodoha / `八纮一宇` route core decision appears to be underweighted compared with equivalent route decisions.

Relevant current blocks:

- `common/decisions/JAP.txt`: `JAP_core_asian_state`, unlocked by focus `JAP_hakko_ichiu` (`八纮一宇`).
- `common/decisions/JAP.txt`: `JAP_communist_core_asian_state`, unlocked by `JAP_the_pacific_union_of_soviet_socialist_republics` (`太平洋苏维埃社会主义共和国联盟`).
- `common/decisions/JAP.txt`: `JAP_democratic_core_asian_state`, unlocked by `JAP_greater_east_asian_federation` (`大东亚联邦`).
- `common/decisions/JAP_rework_ai_decision.txt`: `JAP_rai_kodoha_integrate_subjects` (`皇道派AI整合属国`).

Useful findings:

- `JAP_communist_core_asian_state` has `ai_will_do = { base = 50 }`.
- `JAP_democratic_core_asian_state` has `ai_will_do = { base = 50 }`.
- `JAP_core_asian_state` has no explicit `ai_will_do`, even though it is the comparable state-targeted core decision for `八纮一宇`.
- `JAP_rai_kodoha_integrate_subjects` has strong AI usage (`base = 1000`) and sets newly annexed subject states to `set_compliance = 50`.
- `JAP_core_asian_state` requires `compliance > 50`, so freshly integrated subject states at exactly `50` compliance are not immediately eligible for the core decision.

Likely implication: Kodoha AI can aggressively integrate subjects, but may then fail to reliably continue into the normal Asian state coring flow. Even when states become eligible, the core decision lacks the explicit AI-use tendency that the communist and democratic equivalents already have.

Most relevant fix direction: give `JAP_core_asian_state` an explicit `ai_will_do` at least matching the communist/democratic base value, with a higher modifier for `Rance_is_jap_kodoha_ai` if needed. Also align the subject-integration compliance handoff by either setting compliance slightly above the threshold or changing the core decision threshold to accept exactly `50` compliance.

Implemented direction: added `ai_will_do = { base = 50 }` to `JAP_core_asian_state`, matching the communist and democratic Asian state core decisions. This fixes the missing AI-use tendency for the `八纮一宇` core flow without changing the decision's cost, compliance threshold, or target eligibility.

### 5. Northern Asian Soviet areas outside Kodoha operational radius（已处理）

New screenshot issue: the decision `JAP_demand_soviet_unions_surrender` (`要求苏维埃联盟投降`) has strong AI intent with `ai_will_do = { base = 400 }`, but its availability checks several Asian Soviet states that are not all clearly covered by the current Kodoha northern operational areas.

Decision-critical states checked by `JAP_demand_soviet_unions_surrender`:

- `566` 伊尔库茨克
- `564` 布里亚特
- `563` 赤塔
- `408` 符拉迪沃斯托克
- `655` 北萨哈林
- `574` 雅库茨克
- `569` 哈卡斯
- `654` 卫拉特地区
- `409` 哈巴罗夫斯克

Relevant current area coverage:

- `JAP_rework_northern_east_theater` originally covered Japan / Manchuria / Korea plus `148` 俄属远东, `149` 东西伯利亚, `255` 阿穆尔, `256` 外贝加尔, `257` 北远东, `258` 鄂霍茨克, and nearby sea regions.
- `JAP_rework_northern_west_theater` originally covered Central Asia / western China / Mongolia side pressure plus `147` 北西伯利亚, `151` 西西伯利亚, `262` 中西伯利亚, and Ural-side regions.
- Strategic region `260` 西萨哈 (`260-Western Sakha.txt`) was absent from both northern area keys. Its province list overlaps `574` 雅库茨克.
- Strategic region `261` 阿尔泰 (`261-Altai.txt`) was also absent from both northern area keys. Its province list overlaps `569` 哈卡斯 and `654` 卫拉特地区.
- Strategic region `259` 东萨哈 was also outside the northern area keys, so the whole Sakha belt was not intentionally covered except for adjacent east/west Siberian regions.

Original likely implication: the AI can want to use `要求苏维埃联盟投降`, and can even satisfy the Far East / Transbaikal part through the current east-line plan, but it may not assign an active front radius or sufficient front pressure into 雅库茨克, 哈卡斯, and 卫拉特地区. This can leave the decision blocked even though the decision has high AI weight.

Chosen fix direction: expand the Kodoha northern operational coverage to include the missing decision-critical northern regions, using the area service-radius approach rather than adding a new active cleanup layer. This keeps the documented completion and withdrawal logic narrow while matching the actual decision requirements.

Implemented direction: expanded `JAP_rework_northern_east_theater` with `259` 东萨哈 and `260` 西萨哈 to keep `574` 雅库茨克 inside the eastern operational radius, and expanded `JAP_rework_northern_west_theater` with `261` 阿尔泰 to keep `569` 哈卡斯 and `654` 卫拉特地区 inside the western operational radius. The change only expands area service radius; it does not add these states to active push `state_trigger`, landing logic, or northern theater completion gates. Updated the Kodoha post-China AI area plan and war strategy reference with the same scope note.
