-- Free-tier lifetime workout cap (single-tier monetization pivot).
--
-- Model: every new account gets a 14-day trial (time-based, derived from
-- users.created_at -- matches TRIAL_DAYS in mobile/src/lib/trial.ts and the
-- edge functions). During the trial, or with a 'premium' subscription,
-- logging is unlimited. Once the trial lapses without subscribing, the
-- account may keep at most 4 COMPLETED workouts, ever (a hard lifetime total,
-- not monthly -- the Hevy model; matches FREE_WORKOUT_LIMIT in trial.ts).
--
-- Enforced here at the database as the authoritative, un-bypassable gate: the
-- app also pre-checks and shows an upgrade prompt, but this trigger is what
-- actually prevents a 5th free workout from ever being created. A new session
-- row is inserted at "start" (completed_at null), so blocking the INSERT is
-- what stops a new workout from beginning.

create or replace function public.enforce_free_workout_cap()
returns trigger
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_tier public.subscription_tier;
  v_created_at timestamptz;
  v_completed_count int;
begin
  select subscription_tier, created_at
    into v_tier, v_created_at
    from public.users
    where id = new.user_id;

  -- No profile row (shouldn't happen) -- fail open rather than trap a real
  -- user out of logging over a lookup race.
  if not found then
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

  -- Lapsed free account: enforce the 4-completed-workout lifetime cap. Only
  -- completed sessions count toward it, so an in-progress workout is always
  -- allowed to finish; it's the NEXT new one that gets blocked.
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

drop trigger if exists enforce_free_workout_cap on public.workout_sessions;

create trigger enforce_free_workout_cap
  before insert on public.workout_sessions
  for each row
  execute function public.enforce_free_workout_cap();
