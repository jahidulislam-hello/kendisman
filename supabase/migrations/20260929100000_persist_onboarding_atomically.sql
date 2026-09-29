alter table public.users
  add column if not exists equipment_preference text;

grant update (equipment_preference) on public.users to authenticated;

create or replace function public.complete_onboarding(
  p_username text,
  p_sex text,
  p_date_of_birth date,
  p_height_cm numeric,
  p_unit_preference public.unit_preference,
  p_goal text,
  p_experience_level text,
  p_training_days_per_week smallint,
  p_equipment_preference text,
  p_weight_lb numeric
)
returns boolean
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_user_id uuid := auth.uid();
  v_onboarded boolean;
begin
  if v_user_id is null then
    raise exception 'Authentication required';
  end if;

  select onboarded
    into v_onboarded
    from public.users
    where id = v_user_id
    for update;

  if not found then
    raise exception 'User profile not found';
  end if;

  if v_onboarded then
    return true;
  end if;

  insert into public.body_measurements (user_id, measured_on, weight_lb)
  values (v_user_id, current_date, p_weight_lb);

  update public.users
    set username = p_username,
        sex = p_sex::public.user_sex,
        date_of_birth = p_date_of_birth,
        height_cm = p_height_cm,
        unit_preference = p_unit_preference,
        goal = p_goal,
        experience_level = p_experience_level,
        training_days_per_week = p_training_days_per_week,
        equipment_preference = p_equipment_preference,
        onboarded = true
    where id = v_user_id;

  return true;
end;
$$;

revoke all on function public.complete_onboarding(
  text, text, date, numeric, public.unit_preference, text, text, smallint, text, numeric
) from public, anon;
grant execute on function public.complete_onboarding(
  text, text, date, numeric, public.unit_preference, text, text, smallint, text, numeric
) to authenticated;
