-- Progress photos gain an optional pose so the Measure tab can group them by
-- Front / Side / Back (matching poses line up for before/after comparison).
-- Nullable: existing photos and any logged without a pose stay uncategorized and
-- only appear under the "All" filter.
alter table public.progress_photos
  add column if not exists pose text check (pose in ('front', 'side', 'back'));
