-- Progress photos for the Body Measurements screen: users take/upload a picture
-- that's stored (privately) in Supabase Storage, with a row here tracking its
-- object path and the date it was taken.
--
-- The image bytes live in the `progress-photos` storage bucket under a
-- per-user folder ({user_id}/...); this table is the queryable index (dates,
-- ordering) and the thing RLS lists from. The bucket is private, so the client
-- reads images through short-lived signed URLs.

create table public.progress_photos (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users (id) on delete cascade,
  -- Object path within the progress-photos bucket, e.g. "<user_id>/<uuid>.jpg".
  storage_path text not null,
  -- Local calendar day the photo represents; defaults to today.
  taken_on date not null default current_date,
  created_at timestamptz not null default now()
);

-- Newest-first grid, scoped to one user.
create index progress_photos_user_taken_idx on public.progress_photos (user_id, taken_on desc, created_at desc);

alter table public.progress_photos enable row level security;

create policy "progress_photos_all_own" on public.progress_photos
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- Private bucket: nothing is world-readable, so a leaked path is useless without
-- a signed URL the owner generates.
insert into storage.buckets (id, name, public)
values ('progress-photos', 'progress-photos', false)
on conflict (id) do nothing;

-- Storage RLS: a user can only touch objects under their own {user_id}/ folder.
-- foldername(name)[1] is the first path segment, which our client sets to the
-- uploader's id.
create policy "progress_photos_storage_select_own" on storage.objects
  for select using (
    bucket_id = 'progress-photos' and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "progress_photos_storage_insert_own" on storage.objects
  for insert with check (
    bucket_id = 'progress-photos' and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "progress_photos_storage_delete_own" on storage.objects
  for delete using (
    bucket_id = 'progress-photos' and (storage.foldername(name))[1] = auth.uid()::text
  );
