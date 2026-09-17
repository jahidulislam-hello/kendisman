-- Adds a user-supplied How-To image URL to exercises, kept separate from the
-- existing GymVisual gif_url so the demo GIFs stay as a fallback for any
-- exercise without a custom image. The app renders image_url ?? gif_url.
alter table public.exercises add column if not exists image_url text;
comment on column public.exercises.image_url is 'Public URL of a user-supplied How-To photo/illustration. Preferred over gif_url in the app; gif_url (GymVisual demo) stays as the fallback for unmatched exercises.';
