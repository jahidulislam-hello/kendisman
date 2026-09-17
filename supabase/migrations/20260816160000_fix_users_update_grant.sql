-- Fix: the `authenticated` role had no table-level UPDATE privilege on
-- public.users, so every profile edit (username, theme, unit, etc.) failed with
-- "permission denied for table users" -- table privileges are checked before
-- RLS, so the own-row policy never even ran.
--
-- Grant UPDATE scoped to the columns the client legitimately edits, NOT the
-- entitlement/identity columns (subscription_tier, is_lifetime, is_reviewer, id,
-- email, ...). Combined with the row-only RLS policy below, an authenticated
-- user can update only their own row, and only these profile fields -- they
-- cannot self-grant Pro/reviewer via a direct API call.
grant update (
  username,
  unit_preference,
  theme_preference,
  sex,
  date_of_birth,
  height_cm,
  mode,
  notifications_enabled,
  push_token,
  timezone,
  rest_timer_enabled,
  rest_timer_default_override_seconds,
  rest_timer_exercise_overrides,
  rpe_tracking_enabled
) on public.users to authenticated;

-- State the own-row restriction explicitly on writes. WITH CHECK was previously
-- omitted (Postgres implicitly reuses the USING expression for UPDATE), so this
-- is behavior-preserving -- just self-documenting and robust to future edits.
drop policy if exists users_update_own on public.users;
create policy users_update_own on public.users
  for update
  to authenticated
  using (auth.uid() = id)
  with check (auth.uid() = id);
