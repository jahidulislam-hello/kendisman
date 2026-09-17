# Aug 1 build — on-device test script

The ordered test plan for the first native build after the EAS quota reset
(≈2026-08-01). Sequenced by **risk × state dependency**: prerequisites first,
then the purchase critical path (highest risk — App Review hits it and none of it
has run on hardware), then the native modules that only exist in a real build,
then low-risk confirmations.

Source items this sequences: STATUS.md **§1.4** (native-dependency features) and
**§11 G1–G8** (go-live checklist), plus the entitlement-sync retest in §1.4.
Where a step maps to a checklist id it's noted as `[G4]`, `[§1.4]`, etc. Check
STATUS for the full rationale behind each.

> **Android note:** the Google Play developer account is **RESTRICTED** (see the
> 2026-07-30 session log in STATUS.md). Android purchase steps are **blocked until
> that clears** — run the iOS path now; defer Android purchase testing. The RC
> Android package-name mismatch (P4b) must also be fixed before Android can pass.

---

## Phase 0 — Pre-build state (set BEFORE cutting the build)

These are build-time inputs; getting them wrong means re-cutting the build.

- [ ] **`EXPO_PUBLIC_LIFETIME_ENABLED=true`** for this **test** build (so the
      lifetime card renders). It must be **`false`** for the release build (Phase 6).
- [ ] Apple Developer account: **App Group `group.com.ahmadyassine.ironcoach`** and
      the **HealthKit** capability are enabled (both are build-time; Live Activity
      and HealthKit fail without them). See §1 checklist.
- [ ] `app.json` `scheme` array carries all three schemes `["fitzella",
      "rc-8c245d12ce", "rc-ff2481c1cf"]` (committed `f0b3a67`) — build-time, tested
      in Phase 3.

## Phase 1 — Build & install (prerequisite for everything below)

- [ ] **[G1]** Cut a `preview` iOS build (`eas build --profile preview --platform
      ios`) once the EAS Free quota resets (2026-08-01) or the plan is upgraded.
      (Android internal-testing AAB is deferred — Play restriction.)
- [ ] **[G2]** Install via **TestFlight** — sandbox purchases do **not** work on a
      plain dev/dev-client build.

## Phase 2 — Purchase critical path (HIGHEST RISK — do in this order; stop on first failure)

Each step depends on the previous, so a failure early invalidates the rest.

- [ ] **[G3]** Open the paywall → `getOfferings()` returns the **`default`**
      offering. This alone proves the Group-1 store/RC wiring. If it returns null,
      stop and fix RC/store config before continuing.
- [ ] **[G4 / §1.4] Monthly + yearly purchase → entitlement propagation.** Buy with
      the **sandbox tester** (`vermonski+sandbox1@gmail.com`). Confirm:
  - [ ] `pro` activates and `addCustomerInfoUpdateListener` fires.
  - [ ] The paywall **dismisses immediately** (optimistic in-memory UI).
  - [ ] `public.users.subscription_tier` shows **`premium`** shortly after —
        **written by the `sync-entitlement` edge function, not the client** (the
        client can no longer write that column; §8 privilege-column lockdown).
  - [ ] A **capped free account can immediately log the 5th+ workout** — i.e. the
        `enforce_free_workout_cap` trigger no longer blocks it, proving the DB flip
        landed before the webhook would have.
- [ ] **[G5]** The **webhook** receives the event (Supabase function logs). With
      `REFERRAL_REWARDS_ENABLED=true` + `REVENUECAT_SECRET_KEY` set, a referred
      sandbox purchase grants both sides a real promotional month.
- [ ] **[G6]** **Restore purchases** (reinstall / second device) re-grants `pro`.
- [ ] **[G7] Lifetime** (flag on from Phase 0): the paywall shows the distinct
      one-time **Lifetime** card at the store-localized **$149.99 / 1995 SEK**
      (product `fitzella_pro_lifetime`, package `$rc_lifetime`). Confirm:
  - [ ] Buying flips the account to **premium + `is_lifetime`** and Settings shows
        **"Lifetime"**.
  - [ ] **Restore after reinstall / on a second device re-grants it** — the
        highest-risk path.
  - [ ] Buying it **while a subscription is still active** shows the
        cancel-your-subscription warning (we never auto-cancel).
  - [ ] The webhook receives the **`NON_RENEWING_PURCHASE`** event.
- [ ] **Reviewer account** (`is_reviewer = true`): signs in → **no paywall**,
      unlimited logging end-to-end (SQL-proven only so far — confirm on device).

## Phase 3 — URL schemes (quick; unblocks RC paywall preview)

- [ ] **[G8]** `fitzella://` opens the app (deep link).
- [ ] **[G8]** RevenueCat paywall preview opens via **`rc-ff2481c1cf`** on iOS
      (RC's iOS-app scheme). `rc-8c245d12ce` is the Android scheme — tested when
      Android is unblocked.

## Phase 4 — Native modules (never run on hardware; each can crash or silently no-op)

- [ ] **[§1.4] Live Activity** (Voltra `@use-voltra/ios-client`) — lock-screen /
      Dynamic Island render, live per-set updates, start/stop lifecycle. Needs the
      App Group (Phase 0).
- [ ] **[§1.4] Export share sheet** (`expo-sharing`) — the native
      `UIActivityViewController` presents; the written JSON/CSV opens/imports
      cleanly elsewhere.
- [ ] **[§1.4] Import file picker** (`expo-document-picker`) — the native
      Files/iCloud picker presents; a real exported CSV picks, parses, reviews, and
      imports end to end.
- [ ] **[§1.4] Share workout card capture** (`react-native-view-shot`) —
      `captureRef` produces a correct PNG, the share sheet presents, and an optional
      camera/library photo composites in (photo stays on device, never uploaded).
- [ ] **[§1.4] Apple Health / HealthKit** (`HEALTHKIT_ENABLED` on) — Settings
      "Apple Health" Connect shows the permission sheet; a completed workout appears
      in Health as Traditional Strength Training (right time/duration; energy only
      when a body weight exists); re-finishing doesn't duplicate; connecting imports
      the latest Health body weight; denying permission still saves the workout.

## Phase 5 — Lower-risk confirmations

- [ ] **[§1.4] i18n device-language** (`expo-localization`) — `getLocales()`
      resolves without error (functionally a no-op today; English only).
- [ ] **Auth-screen keyboard avoidance** on a real device (commit `b1fd268`; only
      ever web-checked, where insets read 0).
- [ ] **In-app rating prompt** (`expo-store-review`, commit `ca5bab5`) — the native
      prompt shows (only appears on device).

## Phase 6 — Post-test / release prep

- [ ] Set **`EXPO_PUBLIC_LIFETIME_ENABLED=false`** for the **release** build.
- [ ] Any iOS-purchase blocker from §11 B3 (subscriptions "Ready to Submit" +
      attached to the released app version) is resolved before shipping 1.0.0.
