# GymVisual 1301 exercise-GIF import (one-off, 2026-07-26)

Record of the bulk import that grew the exercise library from **17 → 535**
exercises using the GymVisual "1301 CLASSIC" pack. This is a **one-time
data migration**, not a maintained tool — kept here so the decisions and
mapping are reproducible.

## Source
- 543 ZIPs at `Desktop/1301-CLASSIC/*.ZIP`, each holding one exercise's GIF
  in 4 resolutions (`_1080/_720/_360/_180`). **360p was chosen** (~161 MiB
  total, ~16% of the 1 GB Supabase free tier; avg 0.30 MB/file).
- No CSV/JSON manifest — **the filename is the only metadata**:
  `<8-digit id>-<Name-hyphenated>_<BodyPart>_<res>.gif`.

## Parsing / mapping (`parse.js`)
- **name**: strip id + `_<bodypart>_<res>`, hyphens→spaces, title-case.
- **muscle_group**: GymVisual region → app group. `upper-arms/forearms/
  triceps/hands→arms`, `back→back`, `chest→chest`, `thighs/hips/calves→legs`,
  `waist→core`, `shoulders→shoulders`. **`neck` (12) and `cardio` (2) were
  skipped.** The `-FIX`/`-AFIX`/`-SFIX`/`-FIX2` correction tags are stripped.
  `core` needs no schema change — `muscle_group` is free-text and `MuscleBody`
  already renders a `core` state.
- **equipment_type** (heuristic from the leading word): `barbell/ez→barbell`,
  `dumbbell→dumbbell`, `cable→cable`, `lever/smith/sled→machine`, else
  `bodyweight`.
- **primary_muscles / secondary_muscles**: left empty (`{}`) — the pack has no
  per-muscle data; the muscle-map still highlights from `muscle_group`, and the
  chip breakdown is omitted (graceful, per the app's empty-state rule).

## Dedup
- Auto-skipped exercises whose **normalized name** (lowercase, alphanumerics
  only) matched one of the existing 17 → 3 skipped. 8 internal pack dups also
  collapsed. `review-possible-duplicates.md` lists 54 fuzzy near-matches
  (incline/decline/grip variants) that were imported as **separate** exercises
  for manual review — not auto-merged.
- One filename anomaly: ZIP `02911301` holds an inner GIF mislabeled
  `02911101` ("Dumbbell Bench Squat"); handled explicitly.

## Result — 518 new rows
arms 149 · legs 116 · back 85 · chest 64 · core 55 · shoulders 49
(535 total exercises; 534 with a GIF — only "Pike Push-Up" lacks one).

## Post-import dedup + name audit (2026-07-26)
- **6 near-duplicates removed** (the imported copy, never an original):
  Barbell Bent Over Row, Walking Lunge Male, Push Up M, Dumbbell Incline
  Bench Press, Cable Lat Pulldown Full Range Of Motion, Squat M. Variants
  (incline/decline/grip/stance/seated/standing) were **kept** as distinct
  exercises. 0 exact duplicates found.
- **14 names fixed**: 5 mojibake (`45�` → `Sled 45° …`), 5 `Revers` →
  `Reverse`, 4 trailing ` M` model-markers stripped.
- **Final: 529 exercises, 528 with a GIF, all 17 curated originals intact**
  (arms 152 · legs 118 · back 87 · chest 65 · core 55 · shoulders 52).

## How it was uploaded
- 360p GIFs extracted to `<catalogId>.gif` and uploaded to the public
  `exercise-gifs` bucket behind a **temporary anon-insert RLS policy**
  (dropped immediately after — same pattern the original 16 used). Uploads
  are plain `POST` (NOT `x-upsert`, which forces an update-path RLS check).
- Rows inserted via PostgREST behind a temporary `exercises` insert policy
  (also dropped after). `gif_url` = `…/exercise-gifs/<catalogId>.gif`.

## Known residue
- 8 orphaned objects remain in `exercise-gifs` (~2.3 MB): 2 throwaway
  `zz-test-*.gif` plus the 6 removed near-duplicates' GIFs (catalogIds
  00271301, 03141301, 06621301, 11971301, 14601301, 23301301). The Storage
  delete API refused both anon and authenticated deletes; harmless (no
  exercise row references them). Delete from the Supabase Storage dashboard
  if desired.
- The source name artifacts (`Push Up M`, `Revers`, `45�` mojibake) were
  fixed in the 2026-07-26 audit above.
