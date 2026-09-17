-- Schedules the send-notifications Edge Function to run every 15 minutes
-- via pg_cron + pg_net, so the reminder/streak logic runs even when no one
-- has the app open. This is the same mechanism the Supabase Dashboard's
-- "Cron Jobs" UI would set up -- doing it here as a migration instead so
-- it's version-controlled and doesn't need manual dashboard clicking.
--
-- The Authorization header uses the anon/publishable key, which is safe to
-- commit -- it's the same key already shipped inside the mobile app bundle
-- (mobile/.env's EXPO_PUBLIC_SUPABASE_ANON_KEY) and is meant to be public.
-- It does not grant access to anything the function itself doesn't already
-- gate with its own service-role logic and dedup checks.

create extension if not exists pg_cron with schema pg_catalog;
create extension if not exists pg_net;

grant usage on schema cron to postgres;
grant all privileges on all tables in schema cron to postgres;

select cron.schedule(
  'send-notifications-every-15-min',
  '*/15 * * * *',
  $$
  select net.http_post(
    url := 'https://ifqohqltbqslqvdqwokg.supabase.co/functions/v1/send-notifications',
    headers := jsonb_build_object(
      'Authorization', 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlmcW9ocWx0YnFzbHF2ZHF3b2tnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODI5MjI3NTYsImV4cCI6MjA5ODQ5ODc1Nn0.5tyswzAZQFdpz-6h50BymKUYYQldws_n9tDS6TYrZj0',
      'Content-Type', 'application/json'
    ),
    body := '{}'::jsonb
  );
  $$
);
