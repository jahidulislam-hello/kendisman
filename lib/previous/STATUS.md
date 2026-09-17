# Fitzella — pre-submission status

**Last updated:** 2026-08-02 · **Commit:** `9cac0e4` · **App version:** 1.0.0 · **Expo SDK:** 57

Single reference to check before an App Store submission. Sections are ordered
by how likely they are to block or embarrass a release.

> **Read this first.** Most features below were verified only on the **web
> target** (`react-native-web`, via `npm run web --workspace=mobile`). Web
> reports zero safe-area insets and cannot exercise native audio, haptics,
> push, or StoreKit, so treat "complete" as "complete and web-verified" unless
> section 1.1 lists it as device-verified.
>
> **Layout and the full rest-timer alert have been confirmed on a real iPhone**
> — see 1.1; push delivery is device-verified end to end, and signup-email
> delivery is now confirmed working (OTP received from `noreply@fitzella.com`).
> What remains in section 1: **in-app purchase** (still unproven). A batch of
> features landed **2026-07-25/26** (§1.3) — all web-verified only, not yet on a
> device build.
>
> **Three of them add native modules whose iOS path cannot run until the Aug 1
> build** — Live Activity, the export share sheet, and the import file picker.
> They are grouped in **§1.4** so the first thing done after that build is to
> exercise all three on hardware.

---

## Session log — 2026-08-02

### Onboarding rework — Phase 1 (branch `feature/onboarding-rework-phase1`, pending review)
Rebuilt the onboarding program generator; **not yet merged to master**. Full spec +
decisions in [`docs/ONBOARDING-REWORK-PLAN.md`](docs/ONBOARDING-REWORK-PLAN.md).
- New tested `packages/program-generator`: per-week volume by experience, splits
  (beginner Full Body 2–4 days; standard 5–6), goal×movement **rep ranges** (real
  min/max), session-length per-day cap, thin-pool notes, staple/isolation-aware
  selection (49 unit tests).
- `progression-engine` is now **range-aware** (double progression; +`reps_up`).
- **Migrations applied to prod:** `target_reps_min/max` on `routine_exercises`
  (nullable, `target_reps` kept for one release), `reps_up` enum value, and a
  `Dumbbell Stiff Leg Deadlift` core→legs data fix. A later cleanup migration
  drops `target_reps`.
- Mobile wired: temporary Goal step, Program **Preview** screen (generate→review→
  save), manual builder min–max reps, range fed into the live progression call.
- Verified live end-to-end (real account, DB-checked). **Phase 2 (9-step flow +
  4-tier equipment) deferred.**

### Closed
- **8-digit email OTP crash fixed (infra drift).** Real hardware received
  **8-digit** signup codes (e.g. `76660407`) while the OTP screen accepts only
  **6** ([`AuthScreen.tsx`](mobile/src/screens/AuthScreen.tsx) `OTP_LENGTH = 6`,
  `maxLength=6`, verify gated on 6) → verification always failed. Root cause was
  **not** the app: the **deployed GoTrue config had `mailer_otp_length = 8`**,
  even though the dashboard UI displayed 6. Confirmed via the Management API
  (`GET /v1/projects/<ref>/config/auth`) — the API is the source of truth, the
  console was stale. Fixed with a **targeted PATCH `mailer_otp_length → 6`**;
  re-read confirms 6. Resend SMTP (`smtp.resend.com` / `noreply@fitzella.com`,
  sender `Fitzella`) left untouched. No app change, no rebuild.
  - Resend custom SMTP only *delivers* — it does not generate the code.
  - No `send_email`/custom-access-token auth hook (`hook_send_email_enabled =
    False`); deployed edge-function list is only the 7 app functions.
  - **Do NOT run `supabase config push`** to manage this: `config.toml`'s SMTP
    block is commented out, so a push would disable the Resend custom SMTP. Edit
    deployed auth settings via the dashboard or a scoped Management API PATCH.
  - Retest: a *fresh* resend must arrive as 6 digits; codes already in the inbox
    stay 8 until `mailer_otp_exp` (3600s) expires.

## Session log — 2026-07-30

**Aug 1 test plan:** [`docs/AUG1-TEST-SCRIPT.md`](docs/AUG1-TEST-SCRIPT.md) — the
ordered test plan for the Aug 1 build, sequenced by risk and state dependency.

### Closed
- **RevenueCat App Store Connect API key fixed.** RC was **still holding the
  revoked `352V7HFRPT.p8`**; replaced with **`9XF95QFNHV.p8`**, now showing
  *Valid credentials*. (Corrects the earlier §11 B5 note, which assumed
  `9XF95QFNHV` was already the live RC key.)
- **Both RevenueCat iOS key blocks now green** — IAP key **`U7V6S79F2W`**, ASC
  API key **`9XF95QFNHV`**. No revoked credentials remain on the RC iOS app.
- **Email deliverability verified.** Signup OTP from `noreply@fitzella.com`
  landed in the Gmail **primary** inbox; **DKIM, SPF, and DMARC** confirmed
  correctly aligned via DNS lookup.
- **DMARC `rua` changed** from GoDaddy's default to `support@fitzella.com`.
- **iOS RevenueCat scheme `rc-ff2481c1cf` added** to `app.json` (commit
  `f0b3a67`).
- **Lifetime iOS product CREATED** — store product **`fitzella_pro_lifetime`**,
  non-consumable, **$149.99 / 1995 SEK**, all countries, English localization
  done. Added to RevenueCat, attached to the **`pro`** entitlement and to the
  **`$rc_lifetime`** package in the **`default`** offering. Restore-after-reinstall
  is now testable. (Closes the iOS side of §11 B6 / R7. Note: the created id is
  `fitzella_pro_lifetime` — §11 B6 had planned `com.ahmadyassine.ironcoach.lifetime`.)
- **Play service account completed (2026-07-29)** — Cloud project `fitzella-play`,
  3 APIs enabled, service account invited with 3 permissions, JSON uploaded to
  RevenueCat. (Closes **P4**; the Service Account Credentials JSON is no longer
  empty.)

### New / important
- **Google Play developer account RESTRICTED since 2026-07-07.** Identity
  verification failed; apps were removed from the Google Play listing, though the
  **closed testing track still works**.
- **Root cause:** identity verification lives in **Google Payments Center, NOT
  Play Console** — Play Console has no upload form for it.
- **Rejection reason:** "provide a document that clearly shows the current
  address" — the payments profile held an outdated address.
- **Address corrected** to `Aktrisgatan 8 LGH 1203, 215 83 Malmö` in the payments
  profile; Play Console pulls from it and updated automatically.
- **Personbevis** (Utdrag om folkbokföringsuppgifter, English) submitted to
  Google Payments; awaiting review, expected a few days.
- **Phone verification is blocked** until identity is approved.
- **Android device verification** will need a **borrowed physical Android phone**
  — emulators do not qualify.
- **Support ticket open** with Play (submitted 2026-07-29, Developer verification
  topic).

### Still open
- **`EXPO_PUBLIC_LIFETIME_ENABLED` must be ON for the Aug 1 test build, then OFF
  for the release build.**
- **Android/Play lifetime product not created** (§11 P5 still open; the iOS
  lifetime product is done, above).
- **Account deletion cascade — VERIFIED against the LIVE DB (2026-07-30); the
  earlier "does not cascade" note was WRONG and is retracted.** `public.users.id →
  auth.users` is `users_id_fkey` **ON DELETE CASCADE**, and every app table
  (`programs`, `routines`, `workout_sessions`, `chat_messages`, `progress_photos`,
  `body_measurements` + `body_measurement_entries`, `mcp_api_tokens`, `referrals`)
  is **CASCADE** on `public.users` — so deleting the `auth.users` row removes the
  whole graph. The `delete-account` header comment and §6 were **correct**; no
  correction needed there. **Not a launch blocker.** (`public.exercises.created_by_user_id`
  is **SET NULL** by design — see the privacy item below.)
- **Storage deletion — covered (verified 2026-07-30).** `delete-account` pages
  through and removes the user's `progress-photos` objects; that is the **only**
  user-writable bucket (`exercise-gifs` is public app content — no app code uploads
  there). Personal files are removed on account deletion, so there is **no separate
  GDPR storage gap**.
- **⚠️ PRE-LAUNCH REVIEW — custom exercises are world-readable across accounts.**
  RLS `exercises_select_all` is `USING (true)` for `{public}` and
  `fetchExerciseLibrary()` doesn't filter `is_custom`, so **every user's custom
  exercises are readable by every other authenticated user**. And because deletion
  is **SET NULL** (not cascade) for `exercises.created_by_user_id`, a **deleted
  user's custom exercises persist (ownerless) and stay globally visible** — a
  privacy / residual-personal-data concern. Currently 4 custom, 0 orphaned.
  Confirm whether cross-account visibility is intended (a shared pool) or a bug;
  if unintended it needs an RLS + client-filter fix **before launch**. Full detail
  in §8. *No fix written yet.*
- **AI-generated programs can't set rest days** (also in §4).
- **Play tester count stuck at 11 of 12** — moot until the restriction clears.

---

## 1. Blocking before submission

Nothing here is known-broken. These are unverified paths that a reviewer or a
first real user will hit immediately.

- [ ] **In-app purchase, end to end.** The RevenueCat flow has never run: offerings
      load, purchase sheet, entitlement propagation, restore purchases. The
      paywall screenshot used a **stubbed offering**, not a live one. App Review
      will exercise this. **Everything up to the transaction is now in place (2026-07-23):**
      Apple banking active; the code reads a single entitlement `pro` (commit
      `0c887ac`); RevenueCat's Apple auth is proven working (ASC key `9XF95QFNHV`,
      §11 B5), though the dashboard entitlement/product/offering wiring is not yet
      re-confirmed (§11 R1–R4, unknown); and all four
      `EXPO_PUBLIC_` vars (incl. the RevenueCat iOS key) are set in both the
      preview and production EAS environments, with each build profile pinned to
      its environment (commit `07716ee`). **Blocked only on a build:** the
      `preview` build to exercise this was rejected because the EAS Free plan's
      monthly iOS build quota is used up — resets **2026-08-01**, or upgrade the
      plan to build now. The env binding itself was confirmed working (EAS logged
      all four preview vars loading before the quota gate). Rerun
      `eas build --profile preview --platform ios` once unblocked; no further
      config changes needed.
      - **⚠️ RISK (2026-07-27): the subscription products are NOT attached to the
        1.0.0 build currently in App Store review**, and they sit in "Prepare for
        Submission", not "Ready to Submit." If 1.0.0 ships as-is, the IAP products
        won't exist in production and the paywall will have nothing to sell. They
        must be moved to "Ready to Submit" and attached to the app version before
        that version is released (see §11 B3).
      - **✅ Subscription review screenshots — DONE (2026-07-28).** The
        `04-paywall.png` shot was regenerated from the current paywall (with the
        framing fix) and uploaded to both **Fitzella Pro Monthly** and **Fitzella
        Pro Yearly** in App Store Connect — both now show Upgrade → Fitzella
        Premium → $9.99/mo, no AI Coach wording. (The "Ready to Submit" /
        build-attachment part above is still open.)
- [x] **Real signup email delivery — confirmed working 2026-07-23.** During live
      testing today the 6-digit signup **OTP email was received in the inbox,
      sent from `noreply@fitzella.com`** — which confirms the full custom-SMTP
      path is live: Resend sending on the verified `fitzella.com` domain, Supabase
      SMTP wired to it, and the "Confirm signup" template emitting the
      `{{ .Token }}` code. Combined with the code-based OTP flow (commits
      `2f3bc9f`/`ddc78ae`, web-verified: fresh signup → OTP, and already-registered
      routing — existing *unconfirmed* → OTP + resend, *confirmed* → "sign in", no
      dead-end), signup email confirmation now works end to end. This replaces the
      earlier constraint where accounts had to be confirmed via direct SQL because
      Supabase's default sender only reached the project-owner address.
      - **One spot-check still worth doing before launch:** delivery was observed
        to the tester's own inbox. A quick confirm that it lands in the *primary*
        inbox (not spam) across a couple of providers (Gmail/Outlook/iCloud) is
        cheap insurance, since deliverability reputation on a newly-verified
        domain builds over time.
- [x] **Reset Password email template — DONE (configured 2026-07-25, confirmed in
      the dashboard 2026-07-27).** The Supabase **"Reset Password"** template
      renders `{{ .Token }}` as the 6-digit code ("Your verification code is:", no
      link), so the forgot-password flow (§1.3, `971b058`) now works end to end.
      STATUS had gone stale here — the template was configured when the flow was
      built, it just wasn't reflected.
- [x] **Push notification delivery — device-verified 2026-07-23.** Moved to 1.1.
      An end-to-end APNs test delivered a visible banner to a real iPhone; the
      one caveat is that the *daily-reminder eligibility logic* (has-logged-today
      / 6pm-local) has still not been exercised against a real send — only the
      delivery path it shares has. See 1.1.
- [x] **App Group `group.com.ahmadyassine.ironcoach` — DONE 2026-07-27.**
      Capability enabled on App ID `com.ahmadyassine.ironcoach`, the group
      registered and attached (Enabled App Groups: 1). EAS picks it up from the
      `@use-voltra/ios-client` plugin config in `app.json` on the next build.
      Was the blocking prerequisite for the Live Activity item below.
- [x] **HealthKit capability on App ID `com.ahmadyassine.ironcoach` — DONE
      2026-07-27.** Enabled (Estimate Recalibration intentionally left off). The
      config plugin supplies the `com.apple.developer.healthkit` entitlement; the
      App ID now carries the capability so provisioning won't fail. Was the
      blocking prerequisite for the Apple Health item in §1.3.
- [ ] **Provisioning profiles will regenerate on the next build — expected, no
      action needed.** Enabling the two capabilities above invalidated the
      existing provisioning profiles; EAS regenerates them automatically on the
      next build. Nothing to do — just don't be surprised by the credential churn.
- [ ] **iOS Live Activity — verify on device (after the App Group above is
      enabled).** The live-workout Live Activity landed **code-only 2026-07-26
      (`85e0c44`)** using Voltra (`@use-voltra/ios` + `ios-client` 2.1.1). Shows
      current exercise + muscle-group glyph, "Set X of Y", the current set's
      weight × reps, and an elapsed timer on the lock screen + Dynamic Island;
      starts on session begin, updates as sets are logged, ends on
      finish/discard. **Verified today:** `tsc` clean, `expo config` resolves the
      plugin + iOS 16.4 target, web app still loads with no console errors, and
      the change is additive (the expo-notifications rest-timer notification is
      untouched). **Needs the Aug 1 build to confirm on hardware:** lock-screen /
      Dynamic Island rendering, the live per-set updates, start/stop lifecycle,
      Swift compilation of the generated widget target, and that the rest-timer
      notification still fires alongside it. Rerun the `eas build` once unblocked.

## 1.1 Verified on a real iPhone

Confirmed on real hardware, not the web target. The layout items were checked
against EAS build `deec8c4e-fb23-4984-ac14-05772932c1c0` (commit `7c62f83`) on
2026-07-23, and every one of them was a bug found on device first -- web
verification caught none of them.

- [x] **Top safe area / Dynamic Island.** Every screen derives top padding from
      the real inset with a floor (`useScreenTopPadding`) instead of a hardcoded
      56 — which was 3pt *inside* the status bar region on a 59pt-inset device.
- [x] **Tab bar bottom clearance.** The bar grows by `insets.bottom` rather than
      sitting at a fixed 60pt with its labels under the home indicator.
      `react-native-safe-area-context` was a dependency but entirely unused
      before this.
- [x] **Back buttons.** One `BackLink` everywhere: chevron + 17px semibold, 98x48
      target, replacing 13px grey text with no padding. Two are intentionally
      different — set-logging shows the routine name, the builder's exercise
      picker says "Cancel".
- [x] **Next Workout card** no longer clipped behind the tab bar. Home, History,
      Progress and Personal Records all pad by `useBottomTabBarHeight()`.
- [x] **Volume stat card** reads "10,560 lb" on one line. It was wrapping
      mid-number ("10,56" / "0") because 26pt type could not fit a five-figure
      value in a third-of-a-row card.
- [x] **Hero card overlap.** The muscle figure participates in layout instead of
      being absolutely positioned over the Start Workout button. Only reproduced
      on device, most likely because of the larger system font size there.
      **Superseded 2026-07-25 (`da7d26a`):** the muscle figure was removed from
      the Home "Today's Workout" card entirely, so there is no figure left to
      overlap — the copy and full-width Start Workout button use the whole card.
- [x] **Push notification delivery (end to end).** Confirmed 2026-07-23: a test
      push sent to `iostest1`'s fresh Expo token
      (`ExponentPushToken[cCXZVsMndNAwNZKjqL1VEl]`) returned an "ok" send ticket
      AND an "ok" delivery receipt from Expo's `getReceipts`, and the banner
      visually appeared on the real iPhone's lock screen. This exercises the full
      chain: on-device registration → `push_token` in the DB → Expo push API →
      APNs → device. Two things it implicitly proves: the **APNs key is correctly
      configured in EAS** (a bad key yields a credentials error on the receipt,
      not "ok"), and **Expo "Enhanced Security for Push" is off** on the account
      (the header-less send in `send-notifications`/`sendExpoPush` succeeded).
      Launch-time token refresh (`refreshPushTokenIfGranted`, commit `66e0488`)
      keeps the stored token from going stale on reinstall/OS update.
      - **Not yet exercised:** the daily-reminder *eligibility* logic in the
        `send-notifications` cron (skip users who already logged today; fire at
        6pm local). Only the shared *delivery* call is proven — a real cron send
        under those conditions has not been observed.
- [x] **Backgrounded rest-timer notification.** Confirmed 2026-07-23: the
      notification appears on the lock screen when the timer completes while the
      app is backgrounded. The scheduling path
      (`scheduleRestTimerNotification` / `useRestTimer`) last changed in
      `314a28d`, an ancestor of all three dev builds, so any of them exercises
      the same code.
- [x] **Rest timer in-app sound and vibration.** Confirmed 2026-07-23: the
      generated tone (`assets/rest-complete.wav` via `expo-audio`) plays and the
      device vibrates when the timer reaches zero with the app in the
      foreground. Separate mechanism from the backgrounded notification above.
      - **Silent-switch behaviour was not separately recorded.** If the tone
        only plays with the ringer on, that matters in practice — phones are
        commonly silenced in a gym, which is the exact context this alert
        exists for. Worth one deliberate check before submission.
      - iOS ignores the `[0,400,200,400]` pattern's timings and fires one
        standard buzz per entry, so the vibration is a double buzz rather than
        the long-short-long the array describes. Cosmetic, not a fault.

## 1.2 Built 2026-07-23 — not yet on a device build

Landed in code and web-verified where possible, but **no `preview`/dev build
has been cut since** (the build is quota-blocked to 2026-08-01), so none of
this has run on hardware yet.

- [x] **6-digit OTP signup confirmation + already-registered routing**
      (`2f3bc9f`, `ddc78ae`). Web-verified, and the email delivery it depends on
      is now confirmed working end to end (OTP received from `noreply@fitzella.com`
      in live testing — see the signup-email item in §1).
- [ ] **Auth-screen keyboard avoidance** (`b1fd268`). The auth screen was a plain
      centered `View`; on device the soft keyboard covered the Sign up / Verify
      button and tapping outside didn't dismiss it. Now wrapped in
      `KeyboardAvoidingView` + `ScrollView` (`keyboardShouldPersistTaps="handled"`).
      **Device-only behaviour — the web target has no soft keyboard, so this is
      type-checked only and unverified on hardware.**
- [x] **GIF exercise thumbnails** (migration `20260723120000_add_exercise_gif_url`,
      GymVisual set). Wired into How-To, Library, Exercise Detail, and the Workout
      today-list; 16 of 17 matched (Pike Push-Up left `null`, no invented match).
      **Caveat: they render as a static first frame on iOS** — react-native's
      `Image` doesn't animate GIFs, and `expo-image` (which does) was reverted
      after its native binary crashed at launch (dyld/SIGABRT). Animated GIF
      support is deferred to separate follow-up work.

## 1.3 Built 2026-07-25/26 — not yet on a device build

This session's work. All web-verified against real Supabase data and
type-checked (engine tests still 13/13); **no `preview`/dev build has been cut
since** (still quota-blocked to 2026-08-01), so none of it has run on hardware.

- [x] **iOS Live Activity for live workout progress — code-only (`85e0c44`,
      2026-07-26).** Lock-screen + Dynamic Island showing current exercise +
      muscle-group glyph, "Set X of Y", the current set's weight × reps, and an
      elapsed timer; starts on session begin, updates as sets are logged, ends on
      finish/discard. Built with **Voltra** (`@use-voltra/ios` + `ios-client`
      2.1.1 — the first pick `expo-live-activity` was archived) as React
      components, no Swift. Additive and iOS-only: new isolated
      `LiveWorkoutProgressContext`, a platform-split headless controller
      (`.ios` drives Voltra, `.tsx` no-op keeps the native module out of the
      Android/web bundle), and the expo-notifications rest-timer notification is
      untouched. **Not on a device** — `tsc`/`expo config`/web-load verified only;
      needs the Aug 1 build **and** the App Group setup (see §1 checklist — that
      App-Group step must happen *before* the build). The muscle "GIF" is a static
      SF-Symbol glyph, since Live Activities can't animate GIFs.

- [x] **Exercise library expanded 17 → 529 (GymVisual 1301 pack import +
      audit, 2026-07-26).** 518 new exercises imported from the local pack:
      360p GIFs uploaded to the public `exercise-gifs` bucket (157 MiB, ~16% of
      the 1 GB tier) and rows inserted with mapped `muscle_group` (incl. a new
      `core` group — no schema change; `MuscleBody` already had the asset),
      heuristic `equipment_type`, empty primary/secondary muscles, and
      auto-generated names. neck (12) and cardio (2) were skipped. A follow-up
      **duplicate audit removed 6 near-dups** (keeping the curated original in
      each case → 529 total; all 17 originals intact) and **fixed 14 broken
      names** (5 mojibake incl. `Sled 45°`, 5 `Revers`→`Reverse`, 4 model-marker
      ` M` suffixes stripped). Incline/decline/grip/stance **variants were kept
      as distinct exercises** (~46). Verified live: library lists the full set,
      an imported exercise's GIF plays and its `core` muscle map + info render;
      equipment remains a heuristic. **Orphaned storage:** 8 objects (~2.3 MiB)
      linger — the 6 removed exercises' GIFs + 2 `zz-test-*.gif` — because the
      Storage delete API refused anon/authenticated deletes; harmless, deletable
      from the Supabase dashboard. See `tools/import-gifs/README.md`.

- [x] **Second name-cleanup pass (2026-07-26, `b9dba51` set + a follow-up).**
      Scanned all 529 names for characters lost/normalized during import and
      fixed **84**: the one lost fraction slash (`3 4 Sit Up` → `3/4 Sit-Up`),
      `30 Degrees` → `30°`, **~27 hyphenations** to match the curated originals
      (`Push-Up`/`Pull-Up`/`Sit-Up`/`Chin-Up`/`Step-Up`/`T-Bar`), and
      paren-qualifier casing (`(plate Loaded)` → `(Plate Loaded)`). Verified live:
      0 residual artifacts, 0 duplicate names. Parentheses themselves all
      survived the import intact — nothing was missing there.

- [x] **Lyfta-style category browse for the Exercise Library + Add Exercise
      picker (`a8c19c4`).** Replaced the flat A-Z list **and the old
      muscle/equipment filter chips** with a shared `ExerciseBrowser` component:
      a landing with **Browse by Muscle** (a highlighted `MuscleBody` card +
      live count per group) and **Browse by Equipment** (rows with counts), both
      derived from the data so empty categories drop out. Tapping a category
      opens its filtered list (`‹ All exercises` back header); a **pinned search
      bar searches all 529 directly, bypassing categories**. Filtered/search rows
      carry the 44×44 GIF thumbnail (muscle-map fallback, never a broken image).
      Both screens now share this UX and differ only in the row action — the
      Library opens the How-To detail, the picker shows an Add/Added button.
      FlatList windowing keeps the big list smooth. Web-verified end-to-end on
      both screens (landing, category filter, search bypass, add-to-session), no
      console errors.

- [x] **Onboarding fixes** (`dac991f`). The auth screen now defaults to **sign
      up** (was sign in); the days-per-week control is a **2 / 3 / 4 segmented
      control** and the deterministic `generateStarterProgram` now emits exactly
      the chosen number of days (cycling the split's templates) instead of the
      count barely affecting output; and two escape hatches keep a failed program
      generation from hard-blocking a new user — **"Choose a ready-made program
      instead"** (activates a `PROGRAM_TEMPLATES` program) and **"Skip for now"**.
      Web-verified end to end, incl. the generator honoring the count
      (Intermediate + 4 days → a 4-day Upper/Lower, every day populated).
- [x] **Forgot-password flow, OTP variant** (`971b058`). "Forgot password?" on
      the sign-in screen → email entry → 6-digit code (Supabase `recovery` OTP,
      reusing the signup OTP screen) → set-new-password. A `pendingPasswordRecovery`
      gate in `AuthContext` keeps the app root on the auth flow after the recovery
      session lands, so it can't flash into the tabs before the new password is
      set; abandoning mid-flow signs the recovery session out. **Web-verified end
      to end** including re-login with the new password (by injecting a known OTP
      hash for a test account). Its one external dependency — the "Reset Password"
      template emitting `{{ .Token }}` — is **confirmed configured** (see §1), so
      this is complete (device keyboard behaviour aside, per §1.2).
- [x] **Delete-account now removes Storage objects** (`f733ff1`, edge fn v2).
      The DB cascade deleted the `progress_photos` rows but left the actual image
      files orphaned in the `progress-photos` bucket (`storage.objects` has no FK
      to the user). The function now lists and deletes everything under the
      user's folder before deleting the account — paged, best-effort (a storage
      hiccup can't trap a user in an undeletable account). **Verified end to end**
      against the deployed function: a real uploaded photo plus the auth user,
      `public.users` row, and `progress_photos` row were all gone after deletion.
- [ ] **In-app rating prompt** (`ca5bab5`). `expo-store-review` shows the native
      Apple/Google rating dialog **once ever**, after the user's **6th** completed
      workout (single `WORKOUT_REVIEW_THRESHOLD` constant), fired from the
      post-workout summary. Persisted via an AsyncStorage flag; "completed
      workout" counts only sessions with ≥1 non-warm-up set. A `__DEV__`-only
      "trigger review prompt" button tests it without logging six workouts.
      **Native dialog is device-only** — the web target's `isAvailableAsync()` is
      false, so web only proved the guard no-ops silently; iOS also throttles the
      real dialog (≈3×/year).
- [x] **Superset support** (`b8f1179`, migration `add_workout_supersets`).
      Long-press an exercise in an active workout to group it into a superset
      (colored left-edge bar, one color per group); **round-robin logging** — a
      set checked on a non-last group member skips the rest timer and jumps to
      the next member, and the rest timer fires normally after the last; a
      "Remove from superset" action dissolves the group (a group down to one
      member auto-dissolves). Session-scoped `workout_supersets` join table,
      RLS owner-only via the parent session, cascades with it. In-progress set
      rows are preserved across the round-robin jumps. **Normal (non-superset)
      logging is unchanged by construction** — every superset path is gated on
      membership; web-verified that the ordinary rest-timer / persistence / PR /
      advance flow is byte-for-byte identical.
- [x] **Per-set "Previous" column on the set-logging screen** (`045a277`,
      `3d5dce4`). Each set row shows the weight × reps **actually performed on the
      same set number within its class** last session (working↔working,
      warm-up↔warm-up; dash when no match; real logged reps, never target reps),
      muted, Strong-style. Replaces the old top-of-exercise "Last time"/Target
      card. Manual mode also pre-fills each row from its per-set previous. A
      follow-up (`3d5dce4`) based the manual-mode **set count and target weight on
      the last session's working sets only**, so a warm-up no longer inflates the
      row count or supplies the target weight.
- [x] **Muscle-map images replaced on two screens** (`da7d26a`). The set-logging
      screen's top-right muscle map is now the exercise's **GymVisual GIF**
      (fallback to the muscle map when there's no `gif_url`), tappable to open the
      full **Exercise Detail in-flow** (ExerciseDetail + its ExerciseHowTo
      dependency are now registered in the Workout stack, so Back returns to
      logging instead of jumping tabs). The **body figure was removed from Home's
      "Today's Workout" card** (see §1.1). Muscle maps in **Exercise Library** and
      **Exercise Detail** are deliberately untouched.

- [x] **Data export — JSON backup + CSV (`1ab83c2`, `2cbcc28`).** Settings > Data
      > **Export data** offers a full **JSON** backup (workouts, sets, body
      measurements, progress-photo dates — RLS-scoped to the caller) and a
      Strong/Hevy-style **CSV** (one row per set: Date, Workout, Exercise, Set
      Order, Weight + unit, Reps, RPE, Set Type, Notes; weights canonical lb).
      Added **`expo-sharing` + `expo-file-system`** (native modules). Web-verified
      end to end via the browser-download fallback. **The iOS share sheet
      (`UIActivityViewController`) is native and post-dates the last build — see
      section 1.4.**

- [x] **CSV import from Strong / Hevy / Lyfta (`9056760`, 2026-07-26).** Settings
      > Data > **Import data**: a 3-step wizard (source -> upload -> review). Pure,
      fixture-tested parser (`workoutImport.ts`) — Strong "Rest Timer" rows
      dropped, `W`/`F` -> warmup/failure, Hevy always-kg / 0-based index, Lyfta's
      `*_SET` enum + stray-space header; unit is **forced** for Strong/Lyfta (they
      don't record it) and the upload CTA is gated on that choice. Weights convert
      to canonical lb; exercises fuzzy-matched to the 529-lib with per-name
      remap/skip on the review screen; the writer (`workoutImportRun.ts`) is
      idempotent (de-dupes by exact start instant) and per-session rollback-safe.
      **Import is gated to unlimited-logging accounts** (a real import exceeds the
      free 4-workout cap); free users get an upgrade prompt. Verified: parser
      against all three provided sample files (Strong 3426->3264 sets, 162 Rest
      Timer skipped / 0 leaked, 161 sessions, 89/97 matched; Hevy 12 sessions
      13/13; Lyfta 5 sessions 10/10), `tsc` clean, web-verified wizard + gating +
      unit gate, and the exact insert shape accepted by the live schema (a
      self-cleaning probe; the review account stayed at 4 sessions). Added
      **`expo-document-picker`** (native module). **iOS uses the native
      `UIDocumentPickerViewController` — needs the Aug 1 build, see section 1.4.**

- [x] **i18n Phase 3 — exercise-name + taxonomy translation (2026-07-27).**
      Builds on Phase 1 (UI-string extraction) and Phase 2 (five locale JSONs:
      es/pt/de/fr/it). **New `exercise_translations` table** (migration
      `20260727120000`, FK→exercises ON DELETE CASCADE, unique (exercise_id,
      locale), `(locale, name)` search index, world-readable RLS) holds **2,625
      rows = all 525 built-in exercises × 5 languages**, generated by a
      per-language composition lexicon (`supabase/scripts/lex/*.mjs`) using each
      lifting community's real terminology (not literal translation) with
      equipment prefixes localized (Barbell→con barra / mit Langhantel / à la
      barre / con bilanciere …). **Muscle/equipment taxonomy** (6+5 labels) lives
      in the client i18n `taxonomy` namespace, not the DB (PT Cable = "Cabo").
      **Display:** `useExerciseName()` hook loads the active locale's map and
      renders localized names everywhere (library/browse, exercise detail,
      how-to, workout logging + superset sheet, session detail, PRs list +
      celebration, progress list, workout summary, program builder, settings
      rest-overrides, rest-timer overlay, history list); `lib/taxonomy.ts`
      localizes browse cards, radar axes, and history filter chips. **The
      canonical English `name` is untouched** — CSV import still matches on it,
      it's the fallback, and **custom exercises (no translation row) always
      render in English by design.** **Search** matches the localized name AND
      the English name, accent-insensitive (NFD + combining-mark strip), so
      "sentadilla" and "squat" both find squats. Web-verified end to end in
      Spanish (browse taxonomy Pecho/…/Polea, localized names in Progress +
      Library, dual-language accent-insensitive search, no console errors); `tsc`
      clean. Commits: schema `9f90ac9`, es `a7905b2`, pt `93a76da`, de `7584313`,
      fr `6361d8b`, it `add4f6f`, taxonomy `43158aa`, display+search `95d914c`,
      history `dbfc789`. **Device note:** device-language auto-detect
      (`expo-localization`) is still the §1.4 item to confirm on the Aug 1 build.

- [x] **Referral program — built, flagged OFF at launch (2026-07-27).**
      Invite-a-friend: both sides get one free month when a referred user
      converts to paid. **Flag:** client `REFERRALS_ENABLED`
      (`EXPO_PUBLIC_REFERRALS_ENABLED`, unset/off) hides all UI; a matching
      server guard (`REFERRAL_REWARDS_ENABLED` secret, set to `false`) gates
      payout — same pattern as the AI flag. **Data layer (always on):** every
      user gets a unique 8-char code (unambiguous alphabet, minted in
      `handle_new_auth_user`, existing users backfilled); `referrals` table
      (`referred_id` UNIQUE = referred once); `record_referral()` RPC does
      attribution with self- and same-device fraud blocks; migration
      `20260727130000`. **Reward (gated):** new `revenuecat-webhook` edge fn
      (verify_jwt=false, shared-secret auth) pays out only on a real paid
      conversion (`period_type NORMAL` + `pro` entitlement — trial/promo/cancel
      never trigger), grants one month to both sides via the RevenueCat v1
      promotional-entitlement REST API, idempotent via an atomic
      `reward_granted_at` claim, capped per-referrer-per-month
      (`REFERRAL_MONTHLY_CAP`, config). **UI (behind flag):** Settings "Invite
      friends" row, a Referral screen (code + native Share-sheet invite +
      invited/subscribed/rewards counts), optional signup code field with
      format validation; i18n in all six locales. **Verified:** the reward
      engine end to end against the deployed webhook with synthetic events —
      attribution, self-referral + same-device blocks, invalid/duplicate codes,
      trial/promo events ignored, conversion recorded with rewards off,
      both-side reward with rewards on, idempotent no double-grant, monthly cap;
      plus the live UI in both flag states (row/screen/signup-field appear ON,
      absent OFF; `tsc` clean, no console errors). **Could NOT test without a
      live RevenueCat account + device build:** the actual promotional-
      entitlement grant (the fn dry-runs it — ledger updates, no real entitlement
      — until `REVENUECAT_SECRET_KEY` is set) and a real store purchase emitting
      a real webhook. **To turn on later:** (1) set `EXPO_PUBLIC_REFERRALS_ENABLED`
      in the EAS build profile; (2) set `REFERRAL_REWARDS_ENABLED=true` and
      `REVENUECAT_SECRET_KEY` (RC secret key) as Supabase secrets; (3) in the
      RevenueCat dashboard add a webhook to
      `https://<project>.supabase.co/functions/v1/revenuecat-webhook` with its
      Authorization header set to the `REVENUECAT_WEBHOOK_AUTH` secret value.

- [x] **Apple Health (HealthKit) integration — built, iOS-only, flagged OFF
      (2026-07-27).** Minimal scope: **write** completed workouts as
      `traditionalStrengthTraining` (start, end, duration, + MET-estimated active
      energy only when body weight is known, else omitted); **read** body weight
      only, into Body Measurements. No heart rate/steps/sleep; Android does
      nothing. **Flag:** `HEALTHKIT_ENABLED` (`EXPO_PUBLIC_HEALTHKIT_ENABLED`,
      off) — off means no Health UI, no prompt, no read/write. Library:
      **`@kingstinct/react-native-healthkit@14`** (+ `react-native-nitro-modules`)
      via its Expo config plugin; app.json carries plain-language read
      (`NSHealthShareUsageDescription`) + write (`NSHealthUpdateUsageDescription`)
      strings and the plugin injects the `com.apple.developer.healthkit`
      entitlement (confirmed via `expo config`). The native module is kept out of
      the web/Android bundle by a **platform split** (`lib/healthkit.ts` no-op
      stub vs `lib/healthkit.ios.ts` real impl) — same pattern as the Live
      Activity controller. Permission is requested **only** from the Settings
      "Apple Health" Connect button, never on launch; every read/write is
      best-effort and never throws (the workout still saves if Health fails);
      workout writes are **idempotent** (a per-session synced-id set + an
      `HKExternalUUID` metadata backstop). **Verified:** `tsc` clean with the iOS
      impl type-checked against the installed native types; `expo config` resolves
      the plugin, plist strings, and entitlement; the web bundle builds and loads
      with the stub (no native import leak, no console/bundler errors). **Could
      NOT test without the Aug 1 device build:** the permission prompt, real
      read/write, the Info.plist prompt copy, and on-device idempotency — HealthKit
      does not exist on web or in Expo Go. **Prerequisite:** enable the HealthKit
      capability on the App ID before the build (see §1 checklist).

- [x] **Lifetime purchase — built, flagged OFF (2026-07-27).** A one-time
      **NON-CONSUMABLE** purchase ($149.99): iOS non-consumable IAP (OUTSIDE the
      subscription group), Android one-time product. **Flag:** `LIFETIME_ENABLED`
      (`EXPO_PUBLIC_LIFETIME_ENABLED`, off) hides all lifetime UI; the
      purchase-handling + restore code paths are **not** gated, so an existing
      lifetime owner is never locked out by the flag being off. **Entitlement:**
      grants the SAME `pro` entitlement the subscription grants — every existing
      gate keys on `subscription_tier = 'premium'` with zero special-casing.
      **Explicit boundary (do not break when re-enabling AI Coach):** lifetime is
      attached to `pro` ONLY; a future AI Coach must be a SEPARATE RevenueCat
      entitlement (reserved `AI_COACH_ENTITLEMENT = 'ai_coach'` in `purchases.ts`)
      that lifetime is NOT attached to — see the `add_lifetime` migration comment.
      **Behaviour:** no expiry/renewal (RC reports lifetime as the `pro`
      entitlement with `expirationDate === null` — the detection signal);
      **Restore** reuses the shared `restorePurchases` → `pro` path (the highest
      risk — a durable `users.is_lifetime` + `subscription_tier=premium` is also
      written by the webhook so a reinstall can't strand a buyer); buying lifetime
      with an **active subscription** shows a "cancel it yourself" warning (stores
      don't auto-cancel; we never cancel programmatically); buying during the
      14-day trial ends trial state cleanly (trial is `created_at`-derived and a
      paid account is never "trialing"); **does not touch `is_reviewer` or the
      free-cap trigger** (both key off `subscription_tier`/`is_reviewer` only).
      **Webhook:** `revenuecat-webhook` now handles `NON_RENEWING_PURCHASE`
      (period_type NORMAL + `pro`) → idempotent `premium` + `is_lifetime` backstop;
      PROMOTIONAL (our referral grants) excluded. **UI:** distinct one-time card on
      the paywall (store-localized price from the `$rc_lifetime` package — never
      hardcoded), "Lifetime" plan status in Settings (no renewal/manage link);
      i18n in six locales. **Verified:** `tsc` clean; webhook event-classification
      cases + idempotent lifetime DB write (is_reviewer untouched); web bundle
      builds + loads clean with the flag on and off. **Could NOT test without the
      Aug 1 build + RC products:** the real purchase, **restore after reinstall**
      (highest-risk), the paywall card rendering + store-localized price, and a
      real store webhook — IAP doesn't exist on web. See the store steps in §11.

## 1.4 Native-dependency features — the Aug 1 build must exercise these

> **Full Aug 1 test plan (ordered by risk + state dependency):**
> [`docs/AUG1-TEST-SCRIPT.md`](docs/AUG1-TEST-SCRIPT.md). This section and §11
> G1–G8 are the source items it sequences.

These three landed after the last device build (`deec8c4e...`, commit `7c62f83`)
and each adds a **native module**. Their non-iOS paths are verified (web
fallbacks / no-ops), but the actual iOS behaviour has **never run on hardware** —
it compiles into the binary, it does not ship over JS. Cut the Aug 1 EAS build,
then verify all three on device before submission.

- [ ] **Live Activity** — Voltra (`@use-voltra/ios` + `ios-client`). Lock-screen /
      Dynamic Island rendering, live per-set updates, start/stop lifecycle, Swift
      compilation of the generated widget target. **Also needs the App Group
      `group.com.ahmadyassine.ironcoach` enabled *before* the build** (section 1
      checklist). Full detail in section 1.3.
- [ ] **Export share sheet** — `expo-sharing` + `expo-file-system`. On iOS the
      export opens the native `UIActivityViewController` to save/share the JSON or
      CSV file; web only exercised the browser-download fallback. Confirm the sheet
      presents and the written file opens/imports cleanly elsewhere.
- [ ] **Import file picker** — `expo-document-picker`. On iOS `getDocumentAsync()`
      presents the native Files/iCloud picker (`UIDocumentPickerViewController`);
      web used the `<input type=file>` shim, which shares no code with the native
      picker. Confirm a real exported CSV can be picked, parsed, reviewed, and
      imported end to end on device.
- [ ] **Share workout card capture** — `react-native-view-shot` (5.1.0, Expo
      SDK-57 bundled). The post-workout Share button renders the summary card and
      captures it to a PNG via `captureRef`, then hands it to the native share
      sheet (`expo-sharing`); web uses a Blob download (view-shot has a web path,
      exercised in the browser). Confirm on device: `captureRef` produces a
      correct PNG, the share sheet presents, and an **optional** photo picked from
      camera/library composites in — the photo stays on device (never uploaded,
      never saved to progress photos). `expo-image-picker` is already installed
      but its native camera/library pickers are also only exercisable on device.
- [ ] **i18n device-language detection** — `expo-localization` (~57.0.0, Expo
      SDK-57 bundled). Added for i18n Phase 1; used once at launch to pick the
      device language (`getLocales()`), falling back to English. Functionally a
      no-op today (English is the only language) and best-effort — on web/older
      builds it silently falls back — so nothing looks different. Confirm on the
      Aug 1 build only that `getLocales()` resolves without error; the framework
      itself (i18next/react-i18next) is pure JS and already web-verified.
- [ ] **Apple Health (HealthKit)** — `@kingstinct/react-native-healthkit`
      (Nitro). iOS only, behind `HEALTHKIT_ENABLED` (off). Needs the HealthKit
      App-ID capability enabled first (see §1 checklist). On the build, flip the
      flag on and confirm: the Settings "Apple Health" Connect button shows the
      system permission sheet with our read/write copy; a completed workout
      appears in the Health app as a Traditional Strength Training session (right
      time/duration, energy present only when a body weight exists); re-finishing
      doesn't duplicate it; connecting imports the latest Health body weight into
      Body Measurements; and denying permission leaves the workout saving
      normally. Full detail in §1.3.
- [ ] **Entitlement sync after the privilege-column lockdown (§8)** — the client
      can no longer write `subscription_tier`/`is_lifetime`; the `sync-entitlement`
      edge function does, after verifying with RevenueCat. This is the same purchase
      flow the §11 go-live checklist exercises (**G4**) — this entry is the detailed
      retest. This path can't be exercised on web (purchases are a no-op there —
      StoreKit only runs on device).
      On the Aug 1 build confirm, with a real sandbox purchase:
      **(a)** buying monthly/yearly dismisses the paywall **immediately** (optimistic
      UI) AND the user can log the capped (5th+) workout right away — i.e. the server
      trigger no longer blocks them, proving `sync-entitlement` wrote `premium`
      before the webhook would have; **(b)** the lifetime purchase sets `is_lifetime`
      (function + webhook) and Settings shows lifetime; **(c)** Restore Purchases
      re-grants correctly; **(d)** the deployed function accepts a real user JWT and
      returns `{tier:'premium'}` (only the no-JWT 401 path was testable on web);
      **(e)** the reviewer account (is_reviewer=true) signs in and hits **no paywall**
      with unlimited logging end-to-end (SQL-proven only so far); **(f)** the
      RevenueCat webhook still reconciles a renewal/expiry as the async backstop.

## 2. Placeholder content (intentional)

- **Exercise How-To screen** — structure and navigation are real. As of
  2026-07-28, written coaching content (Setup / Execution / Common mistakes) is
  **authored for the 50 most-used exercises**, keyed by exact canonical English
  name in `mobile/src/content/exerciseHowTo.ts` and rendered by
  `ExerciseHowToScreen` (3 sections). The remaining ~475 exercises have no entry
  and keep the honest "Instructions coming soon" placeholder. Content is
  English-only for now — the section **headers** localize (de/es/fr/it/pt) but
  the step text does not. The 50 were reviewed line-by-line before shipping;
  contested cues (squat bar height, conventional vs sumo, row torso angle, dip
  depth) state what varies rather than asserting one way. Other real data shown:
  muscle group, equipment, primary/secondary muscles, and a **GymVisual GIF
  demo** where the exercise matched one (static first frame on iOS, see §1.2);
  unmatched exercises keep the "Video demo coming soon" placeholder.

## 3. Working as intended, but easy to mistake for a gap

- **Recovery is a computed proxy, not biometric data.** Derived from hours since
  the last completed session, ramping to 100% over 48h. The Recovery screen
  labels it an estimate. It reads `—` / "After 1st workout" until the first
  session, because with no history the elapsed time is infinite and it would
  otherwise show a confident "100% / Good" for a body that has never trained.
- **AI features are disabled, not removed.** `mobile/src/lib/featureFlags.ts` →
  `AI_FEATURES_ENABLED = false`. Hides Ask Coach, AI Coach Report, and AI program
  generation; entry points hidden, server-side guards in each edge function.
  Flipping the flag restores the whole surface. Onboarding does **not** depend on
  it — it uses a local deterministic `generateStarterProgram`.
- **Free-tier cap ceiling is effectively 5 completed workouts**, not 4. The DB
  trigger blocks starting a new session past the cap but always allows an
  already-open session to finish. Settings clamps the display to `4/4`.
- **Empty rows/days are omitted entirely** rather than rendering "no data"
  placeholder text. This is a deliberate product rule.

## 4. Known data caveats

- **Five completed sessions on `iostest1` have no program-day label.** Their
  `routine_id` was nulled by program edits before the fix in migration
  `20260722150000`. The names are unrecoverable and are left `null` — not
  guessed. Those History cards show no routine name, and they are invisible to
  the History "Program day" filter.
- **Going forward this cannot recur.** `workout_sessions.routine_name` is
  captured by a `BEFORE INSERT` trigger and survives the routine row being
  deleted (verified: name persisted after deleting its routine, with
  `routine_id` going `null`).
- **Rest days cannot be set by AI-generated programs.**
  `ProgramBuilderInitialDay.isRestDay` is optional and generated drafts default
  to `false`. Manual builder supports the toggle.
- **`generate-report` degrades when Anthropic credits are exhausted** — returns
  scores without the AI insight rather than failing. Currently moot (AI off).
- **BUG (unfixed): the exercise "Side Plank (Male)" renders its "(Male)" suffix
  as the on-screen title.** The suffix is in the canonical `name` in
  `public.exercises`, and English is the identity locale, so `exerciseNames.ts`
  returns the raw name untouched — the suffix shows anywhere the name is
  displayed (How-To title, library, logging), not just How-To. Flagged
  2026-07-28, deliberately left unfixed. Fix options when picked up: rename the
  row's `name`, or strip a trailing `(Male)`/`(Female)` marker at display time.
  The how-to content key must track whichever fix is chosen (it currently keys
  on the literal `'Side Plank (Male)'`).

## 5. Screen inventory

Status legend: **Complete** = built, wired, web-verified with real Supabase data ·
**Placeholder** = intentionally unfinished content · **Disabled** = behind
`AI_FEATURES_ENABLED` · **Unverified** = built but the critical path never ran.

### Home tab
| Screen | Status |
|---|---|
| Home | Complete |
| Recovery detail | Complete (labelled estimate) |
| Rest Day | Complete |

### Workout tab
| Screen | Status |
|---|---|
| Workout (today's list) | Complete |
| Exercise Log (sets/reps/weight/RPE, per-set Previous, supersets, GIF thumbnail → detail) | Complete |
| Add Exercise (ad hoc) | Complete |
| Workout Summary | Complete |
| New PR celebration | Complete |
| Rest Timer overlay | Complete; sound, vibration and backgrounded notification all device-verified |

### Progress tab
| Screen | Status |
|---|---|
| Progress list | Complete |
| Exercise Detail (weight-over-time chart, Epley 1RM) | Complete |
| Personal Records | Complete |
| Exercise Library | Complete — **529 exercises** after the 2026-07-26 GymVisual import + dedup/name audit (search is essential at this size); see §1.3 |
| Exercise How-To | **Placeholder** |

### Profile tab
| Screen | Status |
|---|---|
| Profile | Complete |
| Program Manager | Complete |
| Program Builder (incl. rest-day toggle) | Complete |
| History (incl. filters) | Complete |
| Session Detail | Complete |
| Calendar | Complete |
| Achievements / XP | Complete |
| Settings (incl. Data export JSON/CSV + import from Strong/Hevy/Lyfta) | Complete — web-verified; native iOS share sheet / file picker await the Aug 1 build (§1.4) |

### Entry & monetization
| Screen | Status |
|---|---|
| Auth (sign in / sign up / forgot password) | Complete: 6-digit OTP confirmation + already-registered routing + keyboard avoidance + **forgot-password (OTP)**. **Email delivery confirmed** (Resend, `noreply@fitzella.com`) and the **Reset Password template `{{ .Token }}` is confirmed configured** (§1). Only device keyboard behaviour remains unverified on hardware. See §1.2/§1.3 |
| Onboarding | Complete — sign-up default, 2/3/4-day generator, ready-made-program + skip escape hatches (§1.3) |
| Paywall | **Unverified** — no real purchase has run |

### Disabled behind the AI flag
| Screen |
|---|
| Ask Coach |
| AI Coach Report |
| AI Program Questionnaire |

## 6. Backend

| Piece | Status |
|---|---|
| `delete-account` | Deployed (**v2, 2026-07-25**: now also deletes the user's progress-photo Storage objects); exercised from Settings, storage cleanup verified end to end (§1.3) |
| `send-notifications` + Supabase cron | Deployed; **APNs delivery device-verified 2026-07-23** (reminder *eligibility* logic still unexercised) |
| `generate-report` | Deployed, gated off |
| `ask-coach` | Deployed, gated off |
| `generate-program` | Deployed, gated off |
| `revenuecat-webhook` | Deployed (2026-07-27); referral reward payout, gated by `REFERRAL_REWARDS_ENABLED` (off). Reward engine verified with synthetic events; real grant needs `REVENUECAT_SECRET_KEY` + RC dashboard webhook config (see §1.3) |

Migrations applied and verified in SQL: free-workout cap trigger, exercise
muscles, stale-session close, empty-stale-session delete, rest days, session
`routine_name` denormalization, and **`add_workout_supersets`** (2026-07-25 —
session-scoped superset grouping, RLS owner-only via the parent session).

**POST-LAUNCH CLEANUP — reconcile the migration ledger.** Recent migrations were
applied via `npx supabase db query --file`, which runs the SQL but does **not**
record it in `supabase_migrations.schema_migrations`. So ~10 committed files
(everything from `20260726140000_add_body_measurement_entries` through the
exercise-translation set, `add_referrals`, and `add_lifetime`) are applied on the
live DB but absent from the ledger. Only `20260728120000_lock_users_privilege_columns`
was back-recorded (via `supabase migration repair`, 2026-07-28). **Not urgent:**
every migration is a committed, timestamp-ordered file, so a fresh `db reset`/replay
reproduces the schema correctly — the ledger only matters for incremental
`supabase db push`, which is not being run before launch. **When reconciling, fix
the timestamp divergence FIRST:** the ledger already tracks some older migrations
under different versions than their repo filenames (e.g. `add_mcp_tokens` is
recorded as `20260726190329` but the file is `20260726160000`), so a blind
bulk `migration repair` would create duplicate/inconsistent ledger rows. Map the
mismatches, then backfill the contiguous missing set.

## 7. Build & credentials

- **EAS project:** `@ironcoach2/mobile` · bundle `com.ahmadyassine.ironcoach`
- **Latest iOS build:** `deec8c4e-fb23-4984-ac14-05772932c1c0` — development
  profile, internal distribution, commit `7c62f83`. This is the build the
  section 1.1 device pass was run against.
- **No production or `preview` build has ever been made.** Every build so far
  bundles `expo-dev-client`, so nothing has been seen without developer tooling
  attached. A `preview` build is also what would settle whether the gear icon
  seen on device is the dev-client menu rather than app UI.
- **Signing:** ad-hoc distribution certificate + provisioning profile stored on
  EAS, containing one registered device UDID. Builds run without an Apple login.
- **EAS Submit:** configured in `mobile/eas.json` via `ascApiKeyPath` /
  `ascApiKeyId` / `ascApiKeyIssuerId`. The path is **absolute and
  machine-specific** — CI or a second machine needs the key at the same path, or
  an `eas credentials` upload instead.
- **`scheme` is set in `app.json` (2026-07-28): `["fitzella", "rc-8c245d12ce",
  "rc-ff2481c1cf"]`.** `fitzella` is our own deep-link scheme; the two `rc-*`
  entries are RevenueCat's per-app paywall-preview schemes — **`rc-8c245d12ce` for
  the Play Store app, `rc-ff2481c1cf` for the iOS app** (RC issues a distinct
  scheme per platform app, so both must be present). The array form is supported on
  SDK 57 (verified in the installed `@expo/config-types` + `@expo/config-plugins`
  `getScheme`).
  Build-time config with **no effect until the next native build** (no effect in
  Expo Go / the current dev client) — verify on the Aug 1 build (§11).

## 8. Security follow-ups

- [x] **Custom exercises cross-account read — FIXED (2026-07-30, migration
      `20260730120000_owner_scope_custom_exercises.sql`, applied + ledger-repaired).**
      Decision: custom exercises are **private to their creator**, not a shared pool.
      The old SELECT policy `exercises_select_all` (`USING (true)`) exposed every
      user's `is_custom` rows to all users; replaced with `exercises_select_visible`
      → `using (is_custom = false or auth.uid() = created_by_user_id)`. Canonical
      exercises stay world-readable; custom rows are visible only to their owner;
      NULL-owner custom rows are visible to nobody. RLS alone closes the leak —
      `fetchExerciseLibrary()` relies on RLS, so no client change was needed to
      ship. Verified via role simulation on the live DB: non-owner/anon see **0**
      custom + 525 canonical, owner sees **4** custom. Pre-checks: `is_custom` is
      NOT NULL default false (0 NULLs); 0 orphaned custom rows; no logged-set /
      routine-exercise references any custom exercise.
      - [ ] **Follow-up A — render hardening (Aug 1 build).** `historyData.ts`
            accesses `set.exercise.name` unguarded at
            [:40-41](mobile/src/lib/historyData.ts) (list) and
            [:152](mobile/src/lib/historyData.ts) (detail); an RLS-hidden embedded
            exercise returns `null` and would crash. Not reachable today (no logged
            set references any custom exercise), so it's defense-in-depth — null-guard
            both, shipping with the Aug 1 build.
      - [ ] **Follow-up B — hard-delete custom exercises on account deletion (GDPR).**
            `exercises.created_by_user_id` is **ON DELETE SET NULL**, leaving a
            deleted user's custom exercises as ownerless rows (now invisible to all,
            but still residual personal data). A naive FK→CASCADE is unsafe:
            `logged_sets` / `routine_exercises` / `ai_coach_notes` reference
            `exercises` with **ON DELETE RESTRICT**, so the exercise delete can fail
            on cascade ordering. Do it deterministically in the `delete-account` edge
            function (capture the user's custom-exercise ids before the auth-user
            delete, then delete those rows after the cascade clears the RESTRICT
            references). Deploys independently of the app build.
- [x] **Privilege-escalation via public.users UPDATE — FIXED (2026-07-28,
      migration `20260728120000_lock_users_privilege_columns.sql`).** `authenticated`
      held a TABLE-WIDE UPDATE grant and `users_update_own` has no WITH CHECK, so
      any signed-in user could `PATCH /rest/v1/users?id=eq.<own-uid>` with
      `{is_reviewer:true}` (or `subscription_tier:'premium'`, or `is_lifetime:true`)
      and grant themselves permanent unlimited Pro — bypassing the paywall and the
      `enforce_free_workout_cap` trigger. Fix: revoked the blanket UPDATE and
      re-granted UPDATE on only the 11 preference columns the client writes; the
      three privilege columns are now service-role-only. Because the client used to
      self-write `subscription_tier`/`is_lifetime` (same class of hole), that write
      moved server-side: new **`sync-entitlement`** edge function verifies the
      entitlement with RevenueCat's REST API and writes via the service role
      (upgrade-only); the client now calls it after purchase/restore and on launch,
      with optimistic in-memory UI so the paywall still dismisses instantly.
      Verified device-free (role-simulated exploit now denied on all 3 columns;
      preference write still allowed; reviewer still bypasses the cap; 401 on the
      function without a JWT). **Aug 1 device retest — see §1.4.**
- [x] **`352V7HFRPT` — REVOKED (2026-07-22, confirmed in the Apple Developer
      portal revoked list 2026-07-27).** Was committed/pushed on 2026-07-22
      (commit `352872e`); history was rewritten + force-pushed and a fresh clone
      confirms no `.p8` / `BEGIN PRIVATE KEY` in remote history. Revoked, closed.
- [ ] **`9DY8U8WP8V` — revocation UNVERIFIED.** Also committed on 2026-07-22 and
      must be treated as compromised. It did **not** appear in the ASC **API key**
      list, so it may live under the **In-App Purchase key** page — check there and
      revoke it. (Likely the same object as the "In-App Purchase key reissue"
      question below.)
- [ ] **Confirm the In-App Purchase key was reissued** (probably `9DY8U8WP8V`
      above). Nothing server-side uses it today.
- [ ] **`9XF95QFNHV` — ACTIVE and in use, do NOT casually rotate.** This is the
      ASC API key RevenueCat authenticates Apple with (App Manager access, **Last
      Used 2026-07-22** — so RC's Apple auth is proven, see §11 B5). It passed
      through a chat transcript as an attachment, so it's a known exposure, but
      rotating it means reissuing the key AND reconfiguring RevenueCat — a
      deliberate decision with a cost, not free housekeeping. `L77U44AF4Z` also
      passed through chat; rotate it if it isn't the RC key.
- Root `../../.gitignore` now carries `*.p8` and `ironcoach-legal/`. Note
  `mobile/.gitignore` already had `*.p8`; the keys sat at the **repo root**,
  outside its scope, which is exactly how they slipped through.
- Both current keys live at `C:\Users\ahmad\.appstoreconnect\private_keys\`,
  outside the repo and outside OneDrive sync, with ACLs restricted to the user.
- [x] **Legal-pages contact email — DONE (verified live 2026-07-28).** All public
  pages in the `ironcoach-legal` repo (account-deletion, support, privacy, terms)
  use **`support@fitzella.com`** (ImprovMX forwarding confirmed working), not the
  old `vermonski@gmail.com` placeholder. The swap landed in commit `e93328d`
  ("Replace placeholder contact email with real support address"). Verified on the
  live GitHub Pages site (account-deletion / support / privacy pages all serve
  `support@fitzella.com`); local `main` == `origin/main` (`024ec98`), and a
  repo-wide grep finds zero `vermonski@gmail.com`.

## 9. Testing notes

- Run the web target: `npm run web --workspace=mobile` (port 8081).
- Type-check: `cd mobile && npx tsc --noEmit -p tsconfig.json`.
- Engine unit tests: `npm run test:engine` (13 tests). `mobile` itself has **no
  unit tests** — browser-driven checks are currently the only coverage.
- A brand-new account **cannot reach the tabs**: `App.tsx` routes any user with
  zero programs to `OnboardingScreen`. To test tab empty states, deactivate a
  program rather than creating a fresh account.
- Confirm a test signup without waiting for email:
  `update auth.users set email_confirmed_at = now() where email = '<addr>';`
- **The web target reports every safe-area inset as 0.** Any padding derived
  from insets computes to its floor there, so a layout can look correct on web
  and still be wrong on hardware. Every bug in section 1.1 was found on device
  first. The hero-card overlap in particular never reproduced on web, most
  likely because the device uses a larger system font.
- **Inactive tabs stay mounted under react-native-web.** A text or style query
  can match an element belonging to a hidden screen — this produced two false
  readings during the section 1.1 work, including a "failure" that was not real.
  Hit-test with `document.elementFromPoint` before trusting a measurement.

## 10. ChatGPT MCP server (separate service — built, deployed, blocked on OAuth)

A **standalone read-only service** (`mcp-server`, Next.js + `mcp-handler`) that
exposes this user's workout data to ChatGPT via the OpenAI Apps SDK. **Not part
of the app build** — it reads the same Supabase project. Phase 1 (token auth,
read-only) is complete and live; ChatGPT connection is **blocked** pending OAuth.

**Built, deployed, and verified working:**
- Live at **`https://fitzella-mcp-server.vercel.app/mcp`** (streamable HTTP).
- **Vercel project:** `fitzella-mcp-server`, **Root Directory = `mcp-server`**
  (monorepo); env vars `SUPABASE_URL` + `SUPABASE_SERVICE_ROLE_KEY` set in Vercel.
- All **5 tools** (`get_recent_workouts`, `get_exercise_history`,
  `get_personal_records`, `get_training_volume`, `get_body_measurements`) return
  **real, RLS-scoped data** for the token's user, with **weights labelled in the
  user's unit** (verified end to end against `iostest1`: the four seeded sessions,
  PRs, and volume all came back correct in `lb`).
- **Auth gate confirmed in production:** `/mcp` with no token → **401**
  (`invalid_token`); identity is resolved server-side from the token only (no tool
  takes a `user_id`), with per-token rate limiting + revocation (see the
  `mcp_authenticate` RPC / `mcp_api_tokens` migration).

**⛔ BLOCKED for ChatGPT use — requires OAuth 2.1.** ChatGPT's custom-connector
dialog offers only **OAuth, No Auth, or Mixed** — there is **no bearer-token
field**, so the Phase 1 per-user token cannot be entered. Connecting returns
**"MCP server does not implement OAuth."** ChatGPT specifically needs OAuth 2.1
**with dynamic client registration**. (The server itself works — bearer auth is
verifiable today via MCP Inspector / direct HTTP, just not via ChatGPT.)

**Phase 2 = build OAuth 2.1 (dynamic client registration) for the MCP server.**
**Deferred until after launch.** The existing token layer stays as-is and can back
the OAuth token exchange later; no Phase 1 work is thrown away.

## 11. RevenueCat go-live runbook

The RevenueCat purchase flow has **never run** — every build so far bundles
`expo-dev-client`, `getOfferings()` returns null, and no store purchase has been
made. This is the checklist to get it working end to end. It also unblocks the
**referral reward payout** (§1.3), which pays out on a real RevenueCat webhook
event and needs the server secret key.

**Resolved decisions (do not revisit):**
- **Bundle IDs are intentional and permanent.** iOS `com.ahmadyassine.ironcoach`
  (in App Store review) and Android `com.ahmadyassine.fitzella` (live on Play);
  changing either would break a live submission. Two apps in one RevenueCat
  project is the correct, supported setup.
- **Trial stays app-level.** Store products are **plain auto-renewable
  subscriptions with NO introductory offer**; the 14-day trial is app-side
  (`trial.ts`, from `created_at`). A store free trial would double the free
  period and muddy "converts to paid."
- Entitlement id is **`pro`**; product ids e.g.
  `com.ahmadyassine.ironcoach.monthly` / `.annual` mapped to RC's
  `$rc_monthly` / `$rc_annual` packages in the `default` offering.

**Already done (per §1):** Apple banking active; SDK integrated (`pro`
entitlement, offerings/purchase/restore/listener in `purchases.ts`); public RC
SDK keys set in `.env` + EAS preview/production; EAS Submit wired; RC dashboard
*reportedly* has `pro` + products + `default` offering (verify — no build has
fetched them).

**Still genuinely missing / blocking:**
- **Subscription products aren't "Ready to Submit" or attached to the 1.0.0
  build in review (B3)** — the most important gap; if 1.0.0 ships as-is there are
  no products in production (see §1).
- **Play service-account credential (P4)** — the last blocker for Android
  purchases in RC.
- ~~Review screenshots~~ — **DONE 2026-07-28** (regenerated from the current
  paywall + uploaded to both subscription products; no AI Coach wording).
- **Not yet checked (unknown):** Paid Applications Agreement status (B1) and the
  RC dashboard state (R1–R4: `pro` entitlement, products attached, offering,
  public keys). Treat as unverified until confirmed in the dashboards.

RevenueCat's Apple authentication itself is **proven working** (the ASC API key
`9XF95QFNHV` shows Last Used 2026-07-22 — B5 done), and the secret key (R5) +
webhook (R6) are set.

### Group 1 — can be done now (no build required)

App Store Connect
- [ ] **B1 (not checked)** Confirm the **Paid Applications Agreement** shows
      *Active* (banking is active, but the agreement itself must be signed) or IAP
      won't load. Not yet verified in the dashboard.
- [ ] **B2** App record exists under `com.ahmadyassine.ironcoach`.
- [ ] **B3 — PARTIAL, and the last blocker for iOS purchases.** Pricing +
      localizations are **DONE** (2026-07-27): **$9.99 monthly** base across 175
      countries, **Introductory Offers = 0**, Family Sharing off, all countries
      available, localizations complete, descriptions **de-AI'd**. **Still open,
      and it matters:**
      - The products are in **"Prepare for Submission", NOT "Ready to Submit."**
      - They were **never attached to the 1.0.0 build currently in review**, so
        **if 1.0.0 ships as-is the subscriptions won't exist in production** (see
        the §1 risk note). Move them to "Ready to Submit" and attach them to the
        app version before it releases.
      - ✅ **Review screenshots — DONE (2026-07-28).** `04-paywall.png`
        regenerated from the current paywall and uploaded to both Fitzella Pro
        Monthly + Yearly; both show Upgrade → Fitzella Premium → $9.99/mo, no AI
        Coach wording.
      - *(Only the monthly `.monthly` is confirmed; verify the `.annual` product
        exists and is priced too.)*
- [x] **B4 — DONE 2026-07-27.** Sandbox tester **`vermonski+sandbox1@gmail.com`**
      created and verified; its purchase history was cleared so the Aug 1 sandbox
      purchase starts clean.
- [x] **B5 — DONE (corrected 2026-07-30).** RevenueCat's iOS app now authenticates
      Apple with the **ASC API key `9XF95QFNHV`** (App Manager access), showing
      **Valid credentials**. ⚠️ **Correction:** on 2026-07-30 the RC ASC-API-key
      slot was found **still holding the revoked `352V7HFRPT.p8`**, and was replaced
      with `9XF95QFNHV.p8` that day — so the earlier "proven working / Last Used
      2026-07-22" reading was that key's own usage history, not proof RC's slot
      actually held it. Both RC iOS key blocks are now green: **IAP key
      `U7V6S79F2W`**, **ASC API key `9XF95QFNHV`** — no revoked credentials remain.
      (Security note: `9XF95QFNHV` passed through a chat transcript — known exposure;
      rotating later means reissuing + reconfiguring RC. See §8.) `352V7HFRPT` is
      revoked; `9DY8U8WP8V` revocation is still unverified.
- [x] **B6 (Lifetime) — DONE 2026-07-30.** Non-consumable IAP created:
      **`fitzella_pro_lifetime`** — this is the actual product id, **not** the
      earlier-planned `com.ahmadyassine.ironcoach.lifetime`. **$149.99 / 1995 SEK**,
      all countries, English localization done, outside the subscription group.
      Imported into RevenueCat and attached to the `$rc_lifetime` package (see R7).

Google Play
- [ ] **P1** Play app configured under `com.ahmadyassine.fitzella`; listing
      complete enough to reach a testing track.
- [ ] **P2** Create the two **subscriptions** (Monetize → Subscriptions) with
      base plans matching the iOS product ids. *(Play may require the first
      internal-testing AAB — the Aug 1 build, G1 — before it will let you
      **activate** them; create them now, activate when that AAB lands.)*
- [ ] **P3** Add **license testers** (Settings → License testing) so test
      purchases don't charge.
- [x] **P4 — DONE 2026-07-29.** Google Cloud project **`fitzella-play`** created,
      3 APIs enabled, service account invited with 3 permissions, JSON downloaded
      and **uploaded to the RevenueCat Android app** — the Credentials JSON is no
      longer empty. *(Does not on its own unblock Android: see P4b and the Play
      developer-account restriction in the 2026-07-30 session log.)*
- [ ] **P4b (open — BLOCKING Android purchases)** The RevenueCat **Android app
      package name is `com.ironcoach.app`**, but the real Play package is
      **`com.ahmadyassine.fitzella`** (last checked 2026-07-28; **not** addressed by
      the 2026-07-29 service-account work). A one-field RC dashboard edit (Android
      app → package name → `com.ahmadyassine.fitzella`); purchases can't validate
      against a mismatched package. **Doubly gated now:** the Play developer account
      is also RESTRICTED (2026-07-30 session log), so Android purchases are blocked
      regardless until that clears — fix the package name when the RC Android app is
      next reconfigured. See also R1.
- [ ] **P5 (Lifetime)** Create a **one-time product (in-app product, NOT a
      subscription)** `fitzella_lifetime`, **$149.99**, activated. *(Play may
      require the first internal-testing AAB — G1 — before activation.)*

RevenueCat dashboard — **R1–R4 not yet checked in the dashboard (unknown).** The
Apple auth path is proven (B5), but the entitlement/product/offering wiring below
has not been visually confirmed.
- [ ] **R1 (partially checked; updated 2026-07-30)** Two apps in the project:
      **iOS** (`com.ahmadyassine.ironcoach`, ASC API key `9XF95QFNHV` + app-specific
      shared secret — now green, see B5) and **Android** (should be
      `com.ahmadyassine.fitzella`). **⚠️ The Android app package name is still wrong
      — `com.ironcoach.app` (P4b, unfixed).** The service-account JSON is now
      uploaded (P4 done 2026-07-29), so that half is resolved; the package mismatch
      remains and still blocks Android validation.
- [ ] **R2 (not checked)** Verify the **`pro` entitlement** exists.
- [ ] **R3 (not checked)** Verify the store products are **imported and attached
      to `pro`**, and the `default` offering's `$rc_monthly` / `$rc_annual` point
      at the real products.
- [ ] **R4 (not checked)** Confirm the **public SDK keys** match `.env` / EAS env;
      regenerate + update if not.
- [x] **R5 — DONE 2026-07-27.** RevenueCat **secret (v1) server API key** created
      and stored as the Supabase secret **`REVENUECAT_SECRET_KEY`** (distinct from
      the public SDK keys) — the referral webhook can now grant real promotional
      months once rewards are switched on.
- [x] **R6 — DONE 2026-07-27 (created, not yet proven).** RevenueCat webhook
      **"Supabase"** created → the `revenuecat-webhook` Edge Function, **bare-token
      Authorization** (no `Bearer` prefix), enabled for **both Production and
      Sandbox**, **all events**, **HMAC disabled**. The `REVENUECAT_WEBHOOK_AUTH`
      secret was **rotated to the new `rcwh_` token** to match. First real
      end-to-end test is the Aug 1 sandbox purchase (G5).
- [ ] **R7 (Lifetime) — iOS DONE 2026-07-30, Android pending.** The iOS lifetime
      product `fitzella_pro_lifetime` (B6) is imported into RevenueCat, attached to
      the **`pro` entitlement ONLY** (never a future `ai_coach` entitlement), and
      added to the `default` offering as the reserved **`$rc_lifetime`** package
      (the paywall looks it up by that id — code match confirmed). Restore-after-
      reinstall is now testable on the Aug 1 iOS build. **Still open:** import the
      Android one-time product (P5) and attach it to the same package once it exists.

### Group 2 — requires the Aug 1 build

- [ ] **G1** Cut a **`preview` build** (`eas build --profile preview --platform
      ios`) + an Android **internal-testing AAB**, once the EAS Free quota resets
      (2026-08-01) or the plan is upgraded. Activate the Play subscriptions (P2)
      once this AAB is uploaded.
- [ ] **G2** Install via **TestFlight (iOS)** / **Internal testing (Android)** —
      sandbox purchases don't work on a plain dev build.
- [ ] **G3** Open the paywall → confirm **`getOfferings()` returns the
      offering** (this alone proves the Group 1 store/RC config).
- [ ] **G4** Buy with the **sandbox / license tester** → confirm `pro` activates
      and `addCustomerInfoUpdateListener` fires. **NOTE (2026-07-28): the client no
      longer writes `subscription_tier` itself** — the privilege-column lockdown
      (§8) made that column service-role-only. So the DB flip to `premium` now comes
      from the **`sync-entitlement`** edge function (verified against RevenueCat and
      called right after purchase), with the webhook as the async backstop. Confirm:
      the paywall dismisses immediately (optimistic UI) AND `public.users.subscription_tier`
      shows `premium` shortly after (written by `sync-entitlement`, not the client),
      AND a capped free account can log the 5th+ workout right away. Full retest
      detail — including restore, lifetime, reviewer sign-in, and the RC-verified
      write path that couldn't be exercised on web — is in **§1.4** ("Entitlement
      sync after the privilege-column lockdown").
- [ ] **G5** Confirm the **webhook receives the event** (Supabase function logs).
      With `REFERRAL_REWARDS_ENABLED=true` + `REVENUECAT_SECRET_KEY` set, a
      referred sandbox purchase grants both sides a real promotional month.
- [ ] **G6** Test **restore purchases** (reinstall / second device).
- [ ] **G7 (Lifetime)** With `EXPO_PUBLIC_LIFETIME_ENABLED=true`: the paywall
      shows the distinct one-time Lifetime card with the store-localized $149.99
      price; buying it flips the account to premium + `is_lifetime` and shows
      "Lifetime" in Settings; **restore after a reinstall / on a second device
      re-grants it** (the highest-risk path); buying it while a subscription is
      active shows the cancel-your-subscription warning; and the webhook receives
      the `NON_RENEWING_PURCHASE` event (function logs).
- [ ] **G8 (URL schemes)** The `app.json` `scheme` array `["fitzella",
      "rc-8c245d12ce", "rc-ff2481c1cf"]` (added 2026-07-28, §7) is build-time only,
      so it first exists on this build. Confirm all three are registered natively:
      **`fitzella://` opens the app** (deep link); the **RevenueCat paywall preview
      opens via `rc-ff2481c1cf` on the iOS build** (RC's iOS-app scheme); and the
      **paywall preview opens via `rc-8c245d12ce` on the Android build** (RC's
      Play-app scheme). Each platform build carries both `rc-*` schemes but only its
      own resolves to that platform's RC app.
