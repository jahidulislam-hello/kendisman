-- Per-user light/dark theme preference. 'system' (the default) follows the
-- device's Appearance setting; 'light'/'dark' force a fixed scheme. Mirrors
-- the other display preferences already on the users row (unit_preference,
-- sex) -- a plain enumerated text column the client reads on profile load and
-- writes from Settings.
alter table public.users
  add column theme_preference text not null default 'system'
    check (theme_preference in ('light', 'dark', 'system'));
