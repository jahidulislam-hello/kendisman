-- Demonstration GIFs (GymVisual 1301 pack) wired into exercises as thumbnails.
--
-- The GIF binaries live in the public `exercise-gifs` storage bucket, matched
-- to exercises by name and populated with a one-time seed (a temporary anon
-- INSERT policy that was dropped immediately after upload -- the bucket keeps
-- only public read). 16 of the 17 exercises matched; Pike Push-Up has no
-- animation in the pack and is deliberately left null rather than shown a
-- mismatched clip.

alter table public.exercises add column if not exists gif_url text;

comment on column public.exercises.gif_url is
  'Public URL of a demonstration GIF (GymVisual 1301 pack) in the exercise-gifs storage bucket. Null when no matching animation exists for the exercise.';
