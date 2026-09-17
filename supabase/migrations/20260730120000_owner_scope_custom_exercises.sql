-- SECURITY: owner-scope custom exercises in public.exercises.
--
-- The prior SELECT policy `exercises_select_all` used `USING (true)`, so every
-- user (anon + authenticated) could read EVERY row -- including other users'
-- `is_custom = true` exercises. Combined with `fetchExerciseLibrary()` selecting
-- with no is_custom filter, that surfaced one user's custom exercises in every
-- other user's library. Decision (2026-07-30): custom exercises are PRIVATE to
-- their creator, not a shared pool.
--
-- Replace the open policy: canonical exercises (`is_custom = false`) stay
-- world-readable; custom exercises are visible only to their creator. A
-- NULL-owner custom row (e.g. one left by ON DELETE SET NULL when a creator is
-- deleted) then matches nobody, which is the intended private behaviour.
--
-- Safe to apply standalone (verified against the live DB 2026-07-30):
--   * `is_custom` is NOT NULL default false, 0 NULLs -> `= false` never yields
--     NULL, so no canonical row is hidden by three-valued logic.
--   * 0 custom rows have a NULL owner; the 525 NULL-owner rows are all canonical
--     (is_custom = false) and stay visible.
--   * No logged_set / routine_exercise references any custom exercise, so no
--     user has history pointing at a now-unreadable row -> no client crash path.
--
-- INSERT/UPDATE/DELETE policies are already own-scoped and are left unchanged.

drop policy if exists exercises_select_all on public.exercises;

create policy exercises_select_visible on public.exercises
  for select to public
  using (is_custom = false or auth.uid() = created_by_user_id);
