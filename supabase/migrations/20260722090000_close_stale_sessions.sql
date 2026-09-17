-- Auto-close abandoned workout sessions.
--
-- A session row is created when the first set is logged and only gets its
-- completed_at when the user taps "Finish workout". Walking away instead
-- leaves it open forever, and the next launch happily resumes it -- which is
-- how a session came to span two days and report a 47-hour duration on the
-- new workout summary.
--
-- This closes any in-progress session that has been idle for STALE_AFTER,
-- backdating completed_at to the last thing that actually happened in it (its
-- most recent set, or started_at when nothing was ever logged) rather than to
-- "now" -- so the summary and history reflect when the user really trained.
--
-- Runs as SECURITY INVOKER against auth.uid(), so RLS applies and a caller can
-- only ever close their own sessions. Returns the number closed.
create or replace function public.close_stale_sessions()
returns integer
language plpgsql
security invoker
set search_path = public, pg_temp
as $$
declare
  stale_after constant interval := interval '4 hours';
  closed_count integer;
begin
  with stale as (
    select
      ws.id,
      -- Last real activity in the session: newest set, else when it started.
      coalesce(max(ls.completed_at), ws.started_at) as last_activity
    from public.workout_sessions ws
    left join public.logged_sets ls on ls.session_id = ws.id
    where ws.user_id = auth.uid()
      and ws.completed_at is null
    group by ws.id, ws.started_at
    having coalesce(max(ls.completed_at), ws.started_at) < now() - stale_after
  )
  update public.workout_sessions ws
     set completed_at = stale.last_activity
    from stale
   where ws.id = stale.id;

  get diagnostics closed_count = row_count;
  return closed_count;
end;
$$;

grant execute on function public.close_stale_sessions() to authenticated;
