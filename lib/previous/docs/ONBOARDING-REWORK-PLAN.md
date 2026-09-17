# Onboarding Rework — Implementation Plan

Benchmarked against Hevy and Lyfta. Replaces the single-scroll, three-question
onboarding + a generator that emits 3×8 on every exercise (with intermediate and
advanced producing identical programs).

**Status:** approved spec, not yet implemented. Test-case lists for Step 2 and
Step 5 are drafted for approval before any implementation code.

## Approved decisions

- **Rep ranges** (movement × goal), approved as-is:

  | Goal | Compound | Isolation | Sets (compound / isolation) |
  |---|---|---|---|
  | Gain Strength | 3–6 | 6–10 | 4 / 3 |
  | Build Muscle | 6–10 | 10–15 | 4 / 3 |
  | Fat Loss | 10–15 | 15–20 | 3 / 3 |

  Sets stay single integers (no schema change).
- **Splits:** beginner locked to **Full Body at 2–4 days only**; at **5–6 days
  beginners get the same splits as intermediate/advanced** (Full Body 5–6×/week
  is not shipped to anyone).

  | Days | Beginner | Intermediate / Advanced |
  |---|---|---|
  | 2 | Full Body A/B | Upper / Lower |
  | 3 | Full Body A/B/A | Push / Pull / Legs |
  | 4 | Full Body A/B/A/B | Upper / Lower / Upper / Lower |
  | 5 | **PPL + Upper/Lower** | Push / Pull / Legs / Upper / Lower |
  | 6 | **PPL ×2** | Push / Pull / Legs ×2 |

- **Volume per major muscle group, per week:** beginner 2 / intermediate 3 /
  advanced 4. Minor groups (shoulders, arms) get **V−1** (1 / 2 / 3). Core is
  **included** (1 / 2 / 2) — currently it's never trained.
- **Per-day cap from session length:** 40 / 60 / 80 min → **4 / 6 / 8** exercises.
- **Equipment: 4-tier model** (Large-vs-Commercial dropped — unsupportable from
  our data):

  | Tier | equipment_types | Qualifying exercises |
  |---|---|---|
  | Commercial Gym | all 5 | 525 |
  | Garage Gym | barbell + dumbbell + bodyweight | 292 |
  | Home | dumbbell + bodyweight | 193 |
  | Bodyweight Only | bodyweight | 86 |

- **Rep ranges are real min/max** (schema change). **Progression engine
  prescribes within the range** (double progression), not display-only.
- **Thin pool (Design D):** cap to available and surface a note; no silent shrink.
- **Plan length** (4/6/8/12 wk, 12 recommended): informational on the summary
  for v1.
- **Days-of-week:** store `scheduled_weekdays` now; wire reminders in a later pass.
- **Onboarding nav:** dedicated stack navigator + `OnboardingContext`.
- **Generator is extracted into a tested `packages/` engine.**

## Data limitations (confirmed)

- `exercises` has only `equipment_type text` (barbell/dumbbell/machine/cable/
  bodyweight) and `muscle_group text`. No gym-size/location/inventory data — so
  Hevy's Large-vs-Commercial distinction is not supportable; the 4-tier model
  above is derived purely from equipment_type subsets and needs no new data.
- Thin bodyweight pools (e.g. **shoulders bodyweight = 1**, chest = 8) drive the
  Design-D capping/notes path.

## Constraints in current code

- `routine_exercises.target_reps integer not null` — single value; ranges need a
  migration. Surfaced as `targetReps: number` in `programData.ts`, `workout.ts`,
  and the progression engine.
- **Three code paths write programs** — onboarding generator, manual builder
  (`ProgramBuilderScreen`), AI path (`aiProgramGeneration` + generate-program
  edge fn). All must emit the new rep shape.
- `mobile/` has no unit tests; only `packages/*` do → generator extraction is
  what makes this testable.

---

## PHASE 1 — rep-range schema + tested generator + preview

Ships through the existing single onboarding screen (with a temporary Goal
selector) so it's independently releasable. Phase-2-only inputs use defaults in
Phase 1 (session length defaults to 1 h → 6-exercise cap).

Branch: `feature/onboarding-rework-phase1`.

1. **Migration A — rep ranges.** Add `target_reps_min/max int` to
   `routine_exercises`; backfill `min=max=target_reps`; set NOT NULL. Keep
   `target_reps` for now (dropped in a later cleanup migration). Verify against
   live DB.
2. **Extract `packages/program-generator`** (ts-jest, `npm run test:generator`).
   Pure inputs → `{ name, days[], notes[] }`. Move `classifyExerciseCategory`
   into the package; `restTimer.ts` re-imports it. **Test cases approved first.**
3. **Generator algorithm** — volume model, splits (approved beginner rule), reps
   by goal, sets, per-day cap, thin-pool notes.
4. **Rep-range shape through data layer** — `DayDraft` min/max, `saveProgram`
   insert + fetch, `workout.ts`/`workoutData.ts`.
5. **Progression engine range-aware** — prescribe within `[min,max]` via double
   progression (hit `repMax` on all sets → +weight, reset to `repMin`; else step
   reps toward `repMax`). **Test cases approved first.**
6. **Update the other two write paths** — manual builder min/max inputs; AI path +
   templates emit ranges; seed + spec.
7. **Temporary Goal selector** on existing onboarding screen.
8. **Program Preview screen** — summary card + every day/exercise with
   sets × rep-range + thin-pool notes; generate → preview → Save Program.

Checkpoint: `tsc` + both engine suites green + live preview screenshot → merge.

## PHASE 2 — 9-step flow + 4-tier equipment

Branch: `feature/onboarding-rework-phase2`.

9. **Migration B — program metadata** on `programs`: `goal, experience,
   equipment, days_per_week, session_length_minutes, plan_length_weeks,
   start_date, scheduled_weekdays int[]` (nullable).
10. **Onboarding stack + `OnboardingContext`** — progress bar / back / Continue.
11. **9 step screens:** Sex · Units · Goal · Experience (year subtitles) · Days
    2–6 (Recommended marker beg3/int4/adv5, pre-fill only) · Days-of-week
    (multi-select = day count) · Session length (40/60/80 → 4/6/8) · Equipment
    (4-tier) · Plan length (4/6/8/12, 12 recommended).
12. **4-tier equipment** in generator + onboarding.
13. **Persist metadata + summary** (start date computed; plan length
    informational; store `scheduled_weekdays`).
14. **i18n** for new steps + preview + tier labels (6 locales).

Checkpoint: `tsc` + run-mobile through all 9 steps → preview → save → merge.
Later cleanup migration drops `target_reps`.

## Risk watchpoints

- Three write paths must all emit min/max (Step 6 easy to miss).
- Engine range logic changes tested behavior — tests first.
- Generator distribution + thin-pool is novel logic — tested package de-risks it.
- Beginner 5–6 boundary is the spec-critical correctness point — explicit test.
