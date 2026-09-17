-- Lifetime (non-consumable) purchase support.
--
-- Lifetime is a one-time NON-CONSUMABLE purchase (iOS non-consumable IAP /
-- Android one-time product), NOT a subscription. In RevenueCat it grants the
-- SAME `pro` entitlement the subscription grants, so every existing gate keys
-- on `subscription_tier = 'premium'` and needs zero special-casing. This column
-- just records "this premium came from a lifetime purchase" so the UI can label
-- it and, crucially, so we have a durable server-side record that survives a
-- reinstall (the revenuecat-webhook sets it) -- restore is the highest-risk path
-- for a non-expiring purchase.
--
-- ENTITLEMENT BOUNDARY (read before re-enabling AI Coach):
--   Lifetime grants ONLY `pro` (unlimited logging). It intentionally does NOT
--   grant any future AI-Coach entitlement. When AI Coach is re-enabled it must
--   be a SEPARATE RevenueCat entitlement (e.g. `ai_coach`) that this lifetime
--   product is NOT attached to, so existing lifetime owners keep exactly what
--   they paid for and nothing is retroactively taken away. Keep the lifetime
--   store product attached to `pro` only in the RevenueCat dashboard.

alter table public.users
  add column if not exists is_lifetime boolean not null default false;

comment on column public.users.is_lifetime is
  'True when this account''s premium access came from the one-time lifetime '
  'non-consumable purchase (grants the `pro` entitlement only -- never a future '
  'AI-Coach entitlement). Set durably by the revenuecat-webhook on the '
  'NON_RENEWING_PURCHASE event and mirrored by the client entitlement sync. '
  'Independent of subscription_tier (which still gates access) and of '
  'is_reviewer (the review-account override).';
