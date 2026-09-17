-- Per-user API tokens for the read-only Apps SDK MCP server (a separate Vercel
-- service that exposes this user's workout data to ChatGPT). The MCP server
-- connects with the service-role key and resolves the calling user ENTIRELY
-- from the bearer token below -- no tool ever accepts a user_id, so identity
-- cannot be spoofed by the caller.
--
-- The raw token is NEVER stored: only its sha256 hex digest. Revocation is
-- setting revoked_at. A fixed-window rate limiter lives on the row itself so the
-- auth check, revocation check, and rate limit are one atomic round trip
-- (mcp_authenticate) -- important for serverless latency.

create table public.mcp_api_tokens (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users (id) on delete cascade,
  token_hash text not null unique,           -- sha256 hex of the raw token
  label text,                                -- human note, e.g. "ChatGPT dev"
  created_at timestamptz not null default now(),
  last_used_at timestamptz,
  revoked_at timestamptz,                     -- non-null => rejected
  expires_at timestamptz,                     -- optional hard expiry
  -- Fixed-window rate limiter, reset when the window rolls over.
  window_started_at timestamptz not null default now(),
  window_count int not null default 0
);

create index mcp_api_tokens_user_id_idx on public.mcp_api_tokens (user_id);

-- RLS: the app/end-users must never read token rows (the hash is sensitive and
-- there's no client use for them). Only the service role (which bypasses RLS)
-- touches this table, so we enable RLS with NO policies -- default deny for
-- anon/authenticated, full access for service_role.
alter table public.mcp_api_tokens enable row level security;

-- Atomic authenticate + revocation-check + fixed-window rate-limit + identity.
-- Returns exactly one row when the token exists and is usable; zero rows when
-- the token is unknown/revoked/expired (caller treats absence as 401). `allowed`
-- is false when the per-window request cap is exceeded (caller treats as 429).
create or replace function public.mcp_authenticate(
  p_token_hash text,
  p_limit int,
  p_window_seconds int
)
returns table (user_id uuid, unit_preference public.unit_preference, allowed boolean)
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_id uuid;
  v_user_id uuid;
  v_window_started timestamptz;
  v_count int;
  v_allowed boolean;
begin
  select t.id, t.user_id, t.window_started_at, t.window_count
    into v_id, v_user_id, v_window_started, v_count
    from public.mcp_api_tokens t
    where t.token_hash = p_token_hash
      and t.revoked_at is null
      and (t.expires_at is null or t.expires_at > now())
    for update;

  if not found then
    return; -- zero rows => invalid token
  end if;

  -- Roll the window if it has elapsed.
  if now() - v_window_started >= make_interval(secs => p_window_seconds) then
    v_window_started := now();
    v_count := 0;
  end if;

  if v_count >= p_limit then
    v_allowed := false;               -- over the cap; do not increment further
  else
    v_allowed := true;
    v_count := v_count + 1;
  end if;

  update public.mcp_api_tokens
     set window_started_at = v_window_started,
         window_count = v_count,
         last_used_at = now()
   where id = v_id;

  return query
    select v_user_id,
           (select u.unit_preference from public.users u where u.id = v_user_id),
           v_allowed;
end;
$$;

-- Only the service role should ever call this.
revoke all on function public.mcp_authenticate(text, int, int) from public, anon, authenticated;
grant execute on function public.mcp_authenticate(text, int, int) to service_role;
