-- SECURITY: lock down write access to public.users privilege columns.
--
-- Before this, `authenticated` (and `anon`) held a TABLE-WIDE UPDATE grant on
-- public.users, and the users_update_own RLS policy has USING (auth.uid() = id)
-- with NO WITH CHECK -- so a signed-in user could PATCH *any* column on their
-- own row via PostgREST, including is_reviewer, subscription_tier and
-- is_lifetime. That let anyone grant themselves permanent unlimited Pro and
-- bypass both the paywall and the enforce_free_workout_cap trigger.
--
-- Fix: revoke the blanket UPDATE and re-grant UPDATE on ONLY the columns the
-- app legitimately writes from the client (user preferences). The entitlement
-- columns (subscription_tier, is_lifetime) and the reviewer override
-- (is_reviewer) become writable by the service role ONLY -- i.e. the
-- revenuecat-webhook and the new sync-entitlement edge function, both of which
-- verify the entitlement with RevenueCat before writing. PostgREST enforces
-- column-level grants ahead of RLS, so a PATCH that touches a non-granted
-- column is rejected with "permission denied for column ...".
--
-- Service role and the SECURITY DEFINER cap trigger are unaffected: this only
-- revokes from anon/authenticated.

revoke update on public.users from anon, authenticated;

-- Exactly the columns the client updates today, and nothing else:
--   preferences   -> AuthContext.tsx (mode, unit_preference, theme_preference,
--                    sex, rest_timer_enabled, rpe_tracking_enabled)
--   rest timer    -> restTimerSettings.ts (rest_timer_exercise_overrides,
--                    rest_timer_default_override_seconds)
--   notifications -> notifications.ts (push_token, notifications_enabled, timezone)
--
-- anon deliberately gets NO update grant: an unauthenticated caller can't pass
-- the RLS auth.uid() = id check anyway, and nothing legitimate updates as anon.
grant update (
  mode,
  unit_preference,
  theme_preference,
  sex,
  rest_timer_enabled,
  rpe_tracking_enabled,
  rest_timer_exercise_overrides,
  rest_timer_default_override_seconds,
  push_token,
  notifications_enabled,
  timezone
) on public.users to authenticated;
