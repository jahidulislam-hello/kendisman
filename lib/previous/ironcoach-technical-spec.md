# IronCoach — Technical Spec / PRD
**Version 0.1 — Planning document for MVP build**

---

## 1. Product Summary

An AI-coached strength training app. Users log workouts (sets, reps, weight); the app can either auto-generate and adjust their training program (AI Coach mode) or simply track what the user programs themselves (Manual mode), with a middle ground where AI suggests but the user approves before it locks in.

Core differentiation vs. Strong/Hevy/Fitbod:
- Personality-led distribution via YouTube content (not cold App Store discovery)
- Content and app are one retention loop, not two separate products
- Transparent AI reasoning ("coach notes") rather than a black-box number change
- Auto-logging (camera/sensor rep detection) as a longer-term differentiator — explicitly out of scope for MVP, noted here as a Phase 3+ consideration

---

## 2. User Modes

Three modes, selectable per user, changeable anytime in settings:

| Mode | Behavior | Tier |
|---|---|---|
| **Manual** | User builds routines, sets, and weights themselves. No AI suggestions, no auto-progression. Pure logger. | Free / low tier |
| **AI Suggests** | AI proposes next session's exercises/sets/weights based on history. User reviews and taps to accept or override before it's locked in. | Mid tier |
| **AI Coach** | AI fully builds and adjusts the program automatically each session. User can still override any single value in the moment, but no approval step is required. | Premium tier |

Mode is a **user-level setting**, not a one-time onboarding choice — must be changeable at any time without losing history.

---

## 3. Core Data Model

```
User
 - id, email, auth_provider
 - mode: enum(manual, ai_suggest, ai_coach)
 - subscription_tier: enum(free, plus, premium)
 - unit_preference: enum(lb, kg)
 - created_at

Exercise (reference library)
 - id, name, muscle_group, equipment_type, video_url
 - is_custom: bool, created_by_user_id (nullable)

Routine
 - id, user_id, name, is_ai_generated: bool
 - created_at, last_modified_at

RoutineExercise
 - id, routine_id, exercise_id, order_index
 - target_sets, target_reps, target_weight

WorkoutSession
 - id, user_id, routine_id (nullable — can log ad hoc)
 - started_at, completed_at
 - mode_at_time: enum(manual, ai_suggest, ai_coach)  // for analytics on which mode retains better

LoggedSet
 - id, session_id, exercise_id, set_index
 - reps, weight, rpe (optional), completed_at

AICoachNote
 - id, session_id, exercise_id
 - reasoning_text  // e.g. "Bumped bench 5lb — you hit all reps clean last session"
 - change_type: enum(weight_up, weight_down, volume_up, volume_down, hold, new_exercise)

ProgressionEngine (not a table — a service, detailed in Section 4)
```

Design note: `mode_at_time` on every session is intentional — you'll want to compare retention and progression outcomes between Manual and AI users from day one. This is a real product question worth having data on early.

---

## 4. AI Programming Logic (MVP scope)

**Do not start with a live LLM for core programming logic.** Use deterministic, rules-based progression — cheaper, faster, more predictable, and it's what Fitbod and Hevy Trainer both run on for their core loop. Reserve LLM calls for optional conversational coaching (Section 5), which is a separate, higher-tier feature.

Baseline progression rules (classic double progression / linear periodization, adjustable later):
- If user hit all target reps across all sets last session at a given weight → increase weight next session (typically 2.5–5 lb upper body, 5–10 lb lower body — configurable)
- If user missed reps on 2+ sets → hold weight, repeat
- If user missed reps for 2 consecutive sessions on the same exercise → reduce weight ~10% or reduce volume (drop a set), and generate a coach note explaining which action was taken and why
- Exercise rotation/volume balancing: track weekly volume per muscle group; if an exercise has stalled 2+ sessions, either swap for a variation or shift volume to a different exercise in the same muscle group

Every automatic change must generate a corresponding `AICoachNote` — this is core to the trust-building UX shown in the prototype, not optional polish.

---

## 5. AI Coach Chat (Phase 2, not MVP)

A conversational layer on top of the rules engine — user can ask "why did you drop my OHP volume" or "I'm sore, can you swap today's leg day." This is where an LLM API call (Claude) is actually justified, since it needs to reason over the user's recent history and respond in natural language.

Cost implication: this is the expensive feature (Section 7). Gate it behind the top subscription tier, and consider rate-limiting (e.g., a capped number of coach messages per week on mid tier).

---

## 6. Tech Stack Recommendation

| Layer | Recommendation | Why |
|---|---|---|
| Mobile app | React Native (Expo) | Single codebase for iOS + Android, fastest path to MVP, large ecosystem |
| Backend | Supabase (Postgres + Auth + Realtime) | Managed, cheap at low scale, avoids building auth/infra from scratch |
| AI programming logic | Runs server-side as a scheduled/triggered function, not client-side | Keeps logic centralized and updatable without app store review cycles |
| AI chat (Phase 2) | Claude API (Sonnet-tier) via server-side proxy | Never call LLM APIs directly from the client — keys must stay server-side |
| Payments | Apple In-App Purchase (iOS) / Google Play Billing (Android), RevenueCat to unify both | Required by app stores for digital subscriptions; RevenueCat avoids building this twice |
| Watch app (Phase 2/3) | watchOS (Swift) + WearOS (Kotlin), syncing through the same backend | Separate builds, shared data layer |

This stack is what I'd hand to Claude Code as the starting brief — it can scaffold the Expo app and Supabase schema directly from Section 3.

---

## 7. Cost Model (recap, tied to architecture above)

| Item | MVP (<1,000 users) | Growth (10–50k users) |
|---|---|---|
| Supabase hosting | $0–25/mo (free tier likely sufficient) | $300–800/mo |
| Rules-based progression compute | Negligible (runs in Supabase functions) | Negligible |
| AI chat coaching (if enabled) | $50–150/mo at low usage | $500–2,000+/mo, scales with engagement |
| Apple/Google developer accounts | $99/yr + $25 one-time | — |
| App store revenue cut | 15% (small business program, <$1M/yr) | 15–30% depending on revenue |
| RevenueCat | Free under $2.5k MTR, then % of tracked revenue | Scales with revenue |

---

## 8. Phased Roadmap

**Phase 1 — MVP**
- Manual mode + AI Suggest mode (skip full AI Coach auto-lock initially — let users approve first, lower trust risk)
- iOS + Android via React Native
- Core logging, routine builder, rules-based progression engine, coach notes
- Apple/Google subscription billing via RevenueCat

**Phase 2**
- Full AI Coach auto-mode
- AI chat coaching (LLM-backed)
- Apple Watch / WearOS companion apps
- Content integration hooks (e.g., "this week's program" syncing with YouTube uploads)

**Phase 3**
- Auto-logging exploration (camera-based rep counting) — genuinely hard, treat as R&D, not a committed roadmap item
- Social/community features if retention data shows demand

---

## 9. Open Product Decisions (need your input before build starts)

1. Default mode for new users — Manual (lower trust barrier) or AI Suggest (showcases the differentiator immediately)?
2. Pricing tiers — proposed starting point: Manual free, AI Suggest ~$6.99/mo, AI Coach + chat ~$12.99/mo. Needs validation against your audience's willingness to pay.
3. How tightly should the app integrate with YouTube content in Phase 1 vs. treating that as a Phase 2 add-on?

---

*This document is the working brief to hand to Claude Code for scaffolding the actual MVP build.*
