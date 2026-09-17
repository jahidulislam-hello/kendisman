-- New users default back to 'ai_coach' mode, superseding the July 7
-- default-to-manual change.
--
-- The reasoning that motivated defaulting to manual no longer applies: a
-- brand-new signup's mode and tier were inconsistent under the old 3-tier
-- model because `free` didn't unlock any AI mode at all. Under the
-- simplified 2-tier model, every new signup gets a 14-day AI Coach trial
-- automatically, no credit card required (see mobile/src/lib/trial.ts,
-- which derives trial eligibility from `created_at` alone -- nothing here
-- needs to track trial state directly). Defaulting `mode` to 'ai_coach'
-- again means that trial's features show up immediately, with no Settings
-- visit required to "turn it on."
--
-- subscriptionTiers.ts's resolveEffectiveMode() is what actually gates
-- this: it only honors a stored mode of 'ai_coach' when the profile is
-- either subscribed or still inside its trial window, and quietly falls
-- back to treating the user as 'manual' once the trial lapses without a
-- subscription -- so this default staying 'ai_coach' forever in the row
-- doesn't grant AI Coach features past day 14.
--
-- Existing rows are intentionally left untouched -- this only changes the
-- default applied to future inserts.
alter table public.users alter column mode set default 'ai_coach';

comment on column public.users.mode is
  'Default is ai_coach: every new signup gets a 14-day AI Coach trial '
  'automatically (see mobile/src/lib/trial.ts and resolveEffectiveMode() in '
  'subscriptionTiers.ts, which is what actually gates whether this stored '
  'value is honored once the trial lapses without a subscription). '
  'Switching to Free (manual) or back is a deliberate user action via '
  'Settings.';
