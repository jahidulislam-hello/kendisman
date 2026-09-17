-- Refines close_stale_sessions (20260722090000): a stale session that never
-- had a single set logged is now DELETED rather than closed.
--
-- Closing an empty session turned it into a completed workout with zero sets,
-- which showed up in History and on the Calendar and -- worse -- counted
-- against the 4-workout lifetime free cap. Someone who opened an exercise and
-- wandered off could burn a free workout on nothing. There's no history worth
-- keeping in a session with no sets, so it just goes away.
--
-- Sessions that DID have sets are still backdate-closed to their last set, so
-- real training is preserved with an honest timestamp.
create or replace function public.close_stale_sessions()
returns integer
language plpgsql
security invoker
set search_path = public, pg_temp
as $$
declare
  stale_after constant interval := interval '4 hours';
  closed_count integer;
  deleted_count integer;
begin
  -- 1. Real-but-abandoned sessions: close at the last set that was logged.
  --    Inner join, so only sessions with at least one set qualify.
  with stale as (
    select ws.id, max(ls.completed_at) as last_activity
    from public.workout_sessions ws
    join public.logged_sets ls on ls.session_id = ws.id
    where ws.user_id = auth.uid()
      and ws.completed_at is null
    group by ws.id
    having max(ls.completed_at) < now() - stale_after
  )
  update public.workout_sessions ws
     set completed_at = stale.last_activity
    from stale
   where ws.id = stale.id;
  get diagnostics closed_count = row_count;

  -- 2. Empty sessions: nothing was ever logged, so there's nothing to keep.
  --    started_at is the only activity marker they have.
  delete from public.workout_sessions ws
   where ws.user_id = auth.uid()
     and ws.completed_at is null
     and ws.started_at < now() - stale_after
     and not exists (select 1 from public.logged_sets ls where ls.session_id = ws.id);
  get diagnostics deleted_count = row_count;

  -- Total stale sessions retired, closed or deleted.
  return closed_count + deleted_count;
end;
$$;
