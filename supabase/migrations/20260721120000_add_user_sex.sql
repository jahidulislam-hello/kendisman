-- Body sex for the profile silhouette. Collected as a required step during
-- onboarding for new users (see OnboardingScreen), and settable from
-- Settings for anyone. Nullable rather than defaulted: accounts created
-- before this column existed genuinely have no answer, and we render a
-- neutral silhouette for them until they choose one -- defaulting would
-- silently assert a value the user never gave.
create type public.user_sex as enum ('male', 'female');

alter table public.users add column sex public.user_sex;

comment on column public.users.sex is
  'Selected during onboarding (required for new signups) and editable in '
  'Settings. Drives the Home body silhouette. Null for pre-existing accounts '
  'that never chose one -- they get a neutral silhouette until they do.';
