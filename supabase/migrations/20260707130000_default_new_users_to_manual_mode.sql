-- New users now default to 'manual' mode, not 'ai_suggest'.
--
-- The original default (see the superseded comment on this column) predates
-- subscription tier enforcement: it was chosen to "showcase the AI
-- differentiator immediately." But subscription_tier still defaults to
-- 'free', and free doesn't unlock ai_suggest -- so every brand-new signup
-- landed in a mode their tier didn't actually allow. Defaulting to manual
-- keeps a new user's mode and tier consistent from the first row created.
--
-- Existing rows are intentionally left untouched -- this only changes the
-- default applied to future inserts.
alter table public.users alter column mode set default 'manual';

comment on column public.users.mode is
  'Default is manual: keeps a brand-new free-tier signup''s mode consistent '
  'with what their tier actually unlocks (see subscriptionTiers.ts). '
  'Upgrading to ai_suggest/ai_coach is a deliberate user action via Settings '
  'once they''re on a paid tier.';
