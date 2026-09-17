-- "Ask Coach" chat history (spec Section 5, Phase 2 feature moved up).
-- Same per-user scoping pattern as the rest of the schema, with one
-- deliberate tightening: a regular user can only ever insert their own
-- 'user'-role messages. 'coach'-role rows are written by the ask-coach
-- Edge Function using the service role key (bypassing RLS entirely), never
-- by the client -- mirroring the security requirement that the app never
-- talks to Claude directly, extended to "the app never gets to put words
-- in the coach's mouth" either.

create table public.chat_messages (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users (id) on delete cascade,
  role text not null check (role in ('user', 'coach')),
  content text not null,
  created_at timestamptz not null default now()
);

create index chat_messages_user_id_created_at_idx on public.chat_messages (user_id, created_at);

alter table public.chat_messages enable row level security;

create policy "chat_messages_select_own" on public.chat_messages
  for select using (auth.uid() = user_id);

create policy "chat_messages_insert_own_user_message" on public.chat_messages
  for insert with check (auth.uid() = user_id and role = 'user');
