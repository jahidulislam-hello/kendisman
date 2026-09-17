-- Stale-session sweeper: never auto-complete an EMPTY session.
--
-- The original close_stale_sessions() backdated completed_at to
-- coalesce(max(set.completed_at), started_at) for every idle session -- which
-- turned an abandoned, never-logged-into freestyle session into a "completed"
-- 0-set workout. That inflated the workout count, reset recovery to 0, and left
-- a phantom entry that some surfaces showed and others (volume, PRs) didn't.
--
-- New rule, matching the client (see mobile/src/lib/workoutValidation.ts): a
-- session only counts once it has at least one real (non-warmup) set. So the
-- sweeper now:
--   * COMPLETES stale sessions that have real work, backdated to the last set;
--   * DELETES stale sessions with no real set (cascades to any warm-up-only
--     logged_sets), so an empty session never becomes a completed workout.
-- Returns the number COMPLETED (unchanged contract for callers).
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
  -- Complete stale in-progress sessions that contain real (non-warmup) work,
  -- backdated to their most recent real set rather than "now".
  update public.workout_sessions ws
     set completed_at = sub.last_activity
    from (
      select ls.session_id, max(ls.completed_at) as last_activity
      from public.logged_sets ls
      join public.workout_sessions w on w.id = ls.session_id
      where w.user_id = auth.uid()
        and w.completed_at is null
        and ls.set_type <> 'warmup'
      group by ls.session_id
      having max(ls.completed_at) < now() - stale_after
    ) sub
   where ws.id = sub.session_id;
  get diagnostics closed_count = row_count;

  -- Delete stale EMPTY sessions -- idle past the threshold with no real set.
  -- These never became workouts; completing them would corrupt counts,
  -- recovery, and history. Measured from started_at so a session mid-workout
  -- (recently opened, not yet logged) is left alone.
  delete from public.workout_sessions ws
   where ws.user_id = auth.uid()
     and ws.completed_at is null
     and ws.started_at < now() - stale_after
     and not exists (
       select 1
       from public.logged_sets ls
       where ls.session_id = ws.id
         and ls.set_type <> 'warmup'
     );

  return closed_count;
end;
$$;

grant execute on function public.close_stale_sessions() to authenticated;
