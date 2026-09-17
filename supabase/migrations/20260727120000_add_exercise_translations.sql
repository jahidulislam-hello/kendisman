-- Localized display names for the built-in exercise library (Phase 3 i18n).
-- Exercise NAMES are reference data (529 rows), too many for the client i18n
-- JSON, so they live here keyed by locale. The English name on public.exercises
-- stays the canonical value: CSV import still matches on it, custom exercises
-- (is_custom = true) are never translated, and the app falls back to it when a
-- translation is missing. Muscle-group / equipment TAXONOMY labels are a small
-- fixed set and are translated client-side in the i18n JSON, not here.
create table public.exercise_translations (
  id uuid primary key default gen_random_uuid(),
  exercise_id uuid not null references public.exercises (id) on delete cascade,
  locale text not null,
  name text not null,
  created_at timestamptz not null default now(),
  constraint exercise_translations_exercise_locale_unique unique (exercise_id, locale)
);

-- Search matches localized names, so an index on (locale, name) supports the
-- per-language lookup path.
create index exercise_translations_locale_name_idx
  on public.exercise_translations (locale, name);

alter table public.exercise_translations enable row level security;

-- Reference data: world-readable, exactly like exercises_select_all. There are
-- deliberately no write policies -- rows are seeded by migrations / the service
-- role, which bypasses RLS, and regular users never create them.
create policy "exercise_translations_select_all" on public.exercise_translations
  for select using (true);
