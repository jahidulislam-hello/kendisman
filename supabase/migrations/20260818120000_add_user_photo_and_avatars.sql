-- Profile photo: a public avatar URL stored on the user row, plus a public
-- storage bucket for the uploaded image. Public (unlike progress-photos) so the
-- avatar renders across the app from a plain URL without minting signed links.

alter table public.users add column if not exists photo_url text;

insert into storage.buckets (id, name, public)
values ('avatars', 'avatars', true)
on conflict (id) do nothing;

-- Storage RLS: reads are public (the bucket is public); writes are restricted to
-- the owner's own {user_id}/ folder. Re-uploading over the same path needs
-- UPDATE as well as INSERT.
create policy "avatars_storage_insert_own" on storage.objects
  for insert with check (
    bucket_id = 'avatars' and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "avatars_storage_update_own" on storage.objects
  for update using (
    bucket_id = 'avatars' and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "avatars_storage_delete_own" on storage.objects
  for delete using (
    bucket_id = 'avatars' and (storage.foldername(name))[1] = auth.uid()::text
  );
