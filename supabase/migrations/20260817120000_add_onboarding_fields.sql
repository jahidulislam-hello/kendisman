-- Onboarding wizard fields. goal/experience_level feed the starter-program
-- generator; training_days_per_week seeds the default split; email_opt_in and
-- referral_source capture the opt-in / attribution steps. `onboarded` gates the
-- new multi-step onboarding flow (true = already done). Existing rows are
-- backfilled to onboarded = true so only brand-new signups see the wizard.
alter table public.users
  add column if not exists goal text,
  add column if not exists experience_level text,
  add column if not exists training_days_per_week smallint,
  add column if not exists email_opt_in boolean not null default false,
  add column if not exists referral_source text,
  add column if not exists onboarded boolean not null default false;

update public.users set onboarded = true where onboarded = false;

-- The client (onboarding wizard) writes these; the column-scoped UPDATE grant
-- on public.users (see 20260816160000) must be extended to cover them, or the
-- writes are denied before the own-row RLS policy runs.
grant update (
  goal,
  experience_level,
  training_days_per_week,
  email_opt_in,
  referral_source,
  onboarded
) on public.users to authenticated;
