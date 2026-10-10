-- The client writes public.users.photo_url after uploading to the avatars
-- bucket, but authenticated never received UPDATE on that column. PostgREST
-- rejected the save with permission denied before the own-row policy ran.

grant update (photo_url) on public.users to authenticated;

-- Upsert of {userId}/avatar.<ext> needs the owner to read and replace their
-- own object. The public bucket URL still serves the image to the app.
drop policy if exists "avatars_storage_select_own" on storage.objects;
create policy "avatars_storage_select_own" on storage.objects
  for select to authenticated
  using (
    bucket_id = 'avatars'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

drop policy if exists "avatars_storage_update_own" on storage.objects;
create policy "avatars_storage_update_own" on storage.objects
  for update to authenticated
  using (
    bucket_id = 'avatars'
    and (storage.foldername(name))[1] = auth.uid()::text
  )
  with check (
    bucket_id = 'avatars'
    and (storage.foldername(name))[1] = auth.uid()::text
  );
