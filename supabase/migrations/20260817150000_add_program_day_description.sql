-- Per-day description for program template days, shown on the Program Detail
-- screen. Backfilled from each day's exercises' muscle groups so existing
-- templates get meaningful, content-derived text; can be overridden by hand.
alter table public.program_template_days add column if not exists description text;

update public.program_template_days d
set description = sub.descr
from (
  select pte.day_id,
    'Targets ' || string_agg(distinct initcap(e.muscle_group), ', ' order by initcap(e.muscle_group)) || '.' as descr
  from public.program_template_exercises pte
  join public.exercises e on e.id = pte.exercise_id
  where e.muscle_group is not null
  group by pte.day_id
) sub
where d.id = sub.day_id
  and d.description is null;
