create table public.user_feedback (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users (id) on delete cascade,
  category text not null
    check (category in ('feature_request', 'bug_report', 'general_feedback')),
  message text not null check (length(trim(message)) > 0),
  created_at timestamptz not null default now()
);

create index user_feedback_user_created_idx
  on public.user_feedback (user_id, created_at desc);

alter table public.user_feedback enable row level security;

create policy user_feedback_select_own on public.user_feedback
  for select to authenticated using (auth.uid() = user_id);
create policy user_feedback_insert_own on public.user_feedback
  for insert to authenticated with check (auth.uid() = user_id);

grant select, insert on public.user_feedback to authenticated;
