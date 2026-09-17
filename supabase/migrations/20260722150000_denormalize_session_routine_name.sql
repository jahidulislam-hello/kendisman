-- Preserve which program day a workout was performed as, permanently.
--
-- workout_sessions.routine_id is ON DELETE SET NULL, and saveProgram deletes
-- and re-inserts a program's routines on every edit. The combination meant
-- each program edit silently erased the day label from every past session --
-- History cards lost their routine name and the program-day filter lost its
-- options. A denormalized name survives both the edit and a genuine day
-- deletion, which the foreign key alone never can.
--
-- routine_id is deliberately kept: it is still the live link while the routine
-- exists, and homeData relies on it to count sessions per program day.

alter table public.workout_sessions
  add column if not exists routine_name text;

comment on column public.workout_sessions.routine_name is
  'Program day name captured at session creation. Survives the routine row being deleted, unlike routine_id. Null for sessions created before this column existed whose routine had already been deleted -- those labels are unrecoverable.';

-- Recover every session whose routine row still exists. Sessions whose routine
-- was already deleted stay null: the name is genuinely gone and inventing one
-- would put fiction in the user's training history.
update public.workout_sessions s
   set routine_name = r.name
  from public.routines r
 where r.id = s.routine_id
   and s.routine_name is null;

-- Capture the name at insert, so going forward no client has to remember to.
-- Runs as the invoking user (not SECURITY DEFINER) so RLS still governs which
-- routine names are readable; a session pointing at a routine the caller
-- cannot see simply gets a null label rather than leaking the name.
create or replace function public.set_session_routine_name()
returns trigger
language plpgsql
set search_path = public
as $$
begin
  if new.routine_id is not null and new.routine_name is null then
    select r.name into new.routine_name
      from public.routines r
     where r.id = new.routine_id;
  end if;
  return new;
end;
$$;

drop trigger if exists workout_sessions_set_routine_name on public.workout_sessions;

-- BEFORE UPDATE OF routine_id matters as much as INSERT: when ON DELETE SET
-- NULL nulls the link, this fires with new.routine_id null, the guard is false,
-- and the already-captured name is left untouched. That is the whole point.
create trigger workout_sessions_set_routine_name
  before insert or update of routine_id on public.workout_sessions
  for each row execute function public.set_session_routine_name();
