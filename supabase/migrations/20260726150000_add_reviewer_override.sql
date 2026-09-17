-- Permanent paid-access override for App Store / Play review accounts.
--
-- A reviewer demo account needs full paid access that does NOT depend on the
-- 14-day trial window or a RevenueCat sync. The client entitlement sync only
-- ever writes users.subscription_tier, so a separate `is_reviewer` flag it never
-- touches gives durable access: both the client gate (lib/trial.ts) and this
-- server-side free-workout-cap trigger treat a reviewer as unlimited, regardless
-- of tier or trial state. Defaults false, so it's a no-op for real users.
alter table public.users
  add column if not exists is_reviewer boolean not null default false;

-- Recreate the cap trigger function so reviewer accounts short-circuit before
-- the tier/trial/cap checks. Otherwise unchanged from enforce_free_workout_cap.
create or replace function public.enforce_free_workout_cap()
returns trigger
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_tier public.subscription_tier;
  v_created_at timestamptz;
  v_is_reviewer boolean;
  v_completed_count int;
begin
  select subscription_tier, created_at, is_reviewer
    into v_tier, v_created_at, v_is_reviewer
    from public.users
    where id = new.user_id;

  -- No profile row (shouldn't happen) -- fail open.
  if not found then
    return new;
  end if;

  -- Reviewer demo accounts: never capped, independent of tier or trial.
  if v_is_reviewer then
    return new;
  end if;

  -- Paid subscribers: never capped.
  if v_tier = 'premium' then
    return new;
  end if;

  -- Active 14-day trial: never capped.
  if now() < v_created_at + interval '14 days' then
    return new;
  end if;

  -- Lapsed free account: enforce the 4-completed-workout lifetime cap.
  select count(*)
    into v_completed_count
    from public.workout_sessions
    where user_id = new.user_id
      and completed_at is not null;

  if v_completed_count >= 4 then
    raise exception 'FREE_WORKOUT_CAP_REACHED'
      using hint = 'Subscribe for unlimited workout logging.';
  end if;

  return new;
end;
$$;
