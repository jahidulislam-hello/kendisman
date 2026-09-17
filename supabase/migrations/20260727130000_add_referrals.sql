-- Referral program data layer. This runs regardless of the client feature
-- flag (EXPO_PUBLIC_REFERRALS_ENABLED) -- codes are minted for every account
-- and attribution is recorded whenever a code is entered, so the history
-- exists before rewards are ever switched on. Reward payout itself is gated
-- separately, server-side, in the revenuecat-webhook edge function.

-- ---------------------------------------------------------------------------
-- Referral code on every user
-- ---------------------------------------------------------------------------

alter table public.users
  add column if not exists referral_code text unique,
  -- Best-effort device fingerprint captured at signup (a persisted install id
  -- from the client). Used only to block same-device self-referral; null on
  -- platforms/builds where it can't be read, so the check is "where detectable".
  add column if not exists signup_device_id text;

-- Short, human-readable code from an unambiguous alphabet: no 0/O, no 1/I/L.
-- 31 chars ^ 8 places ~= 8.5e11 combinations, so collisions are astronomically
-- rare; we still loop-and-retry to guarantee uniqueness.
create or replace function public.generate_referral_code()
returns text
language plpgsql
security definer set search_path = public
as $$
declare
  alphabet constant text := '23456789ABCDEFGHJKMNPQRSTUVWXYZ';
  candidate text;
  i int;
begin
  loop
    candidate := '';
    for i in 1..8 loop
      candidate := candidate || substr(alphabet, 1 + floor(random() * length(alphabet))::int, 1);
    end loop;
    -- Unique across the table; retry on the (astronomically rare) collision.
    exit when not exists (select 1 from public.users where referral_code = candidate);
  end loop;
  return candidate;
end;
$$;

-- Backfill every existing user with a code (idempotent: only null ones).
update public.users
set referral_code = public.generate_referral_code()
where referral_code is null;

-- ---------------------------------------------------------------------------
-- Mint a code for each new account. Extends the existing profile-creation
-- trigger rather than adding a second one.
-- ---------------------------------------------------------------------------

create or replace function public.handle_new_auth_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.users (id, email, auth_provider, referral_code)
  values (
    new.id,
    new.email,
    coalesce(new.raw_app_meta_data ->> 'provider', 'email'),
    public.generate_referral_code()
  );
  return new;
end;
$$;

-- ---------------------------------------------------------------------------
-- referrals
-- ---------------------------------------------------------------------------

create table public.referrals (
  id uuid primary key default gen_random_uuid(),
  referrer_id uuid not null references public.users (id) on delete cascade,
  -- Unique: a user can only ever be referred once, so no one can be claimed by
  -- two referrers or have their attribution overwritten.
  referred_id uuid not null unique references public.users (id) on delete cascade,
  code_used text not null,
  status text not null default 'pending'
    check (status in ('pending', 'converted', 'rewarded')),
  -- Set only when both sides have been granted their reward; also the
  -- idempotency key the webhook claims against (null => not yet paid out).
  reward_granted_at timestamptz,
  created_at timestamptz not null default now(),

  -- A user cannot refer themselves.
  constraint referral_not_self check (referrer_id <> referred_id)
);

create index referrals_referrer_id_idx on public.referrals (referrer_id);
-- For the monthly per-referrer reward cap.
create index referrals_referrer_reward_month_idx
  on public.referrals (referrer_id, reward_granted_at);

alter table public.referrals enable row level security;

-- A user can see referrals they are part of (either side); no client writes --
-- attribution goes through record_referral() and payout through the webhook
-- (service role), both of which bypass or satisfy this on their own.
create policy "referrals_select_own" on public.referrals
  for select using (auth.uid() = referrer_id or auth.uid() = referred_id);

-- ---------------------------------------------------------------------------
-- Attribution RPC. Called by the referred user (authenticated) right after
-- their account exists. Returns a short status string the client maps to a
-- validation message. SECURITY DEFINER so it can read the referrer row and
-- insert past RLS, but every decision is keyed on auth.uid() so a caller can
-- only ever create their OWN referral row.
-- ---------------------------------------------------------------------------

create or replace function public.record_referral(p_code text)
returns text
language plpgsql
security definer set search_path = public
as $$
declare
  v_referred uuid := auth.uid();
  v_referrer uuid;
  v_referred_device text;
  v_referrer_device text;
begin
  if v_referred is null then
    return 'unauthenticated';
  end if;

  select id, signup_device_id into v_referrer, v_referrer_device
  from public.users
  where upper(referral_code) = upper(btrim(p_code));

  if v_referrer is null then
    return 'invalid_code';
  end if;

  -- Self-referral: same account.
  if v_referrer = v_referred then
    return 'self_referral';
  end if;

  -- Same-device self-referral, where detectable (both device ids known).
  select signup_device_id into v_referred_device
  from public.users where id = v_referred;
  if v_referrer_device is not null
     and v_referred_device is not null
     and v_referrer_device = v_referred_device then
    return 'same_device';
  end if;

  -- One referral per referred user; the unique constraint makes this a no-op
  -- on a second attempt.
  insert into public.referrals (referrer_id, referred_id, code_used)
  values (v_referrer, v_referred, btrim(p_code))
  on conflict (referred_id) do nothing;

  if not found then
    return 'already_referred';
  end if;

  return 'ok';
end;
$$;

-- Capture the signup device id once (never overwrite), for the same-device
-- fraud check above. Best-effort and self-scoped to auth.uid().
create or replace function public.set_signup_device_id(p_device_id text)
returns void
language plpgsql
security definer set search_path = public
as $$
begin
  if auth.uid() is null or p_device_id is null or btrim(p_device_id) = '' then
    return;
  end if;
  update public.users
  set signup_device_id = p_device_id
  where id = auth.uid() and signup_device_id is null;
end;
$$;
