-- Library names that do not match an animation folder still need that
-- folder's public GIF. Copy the clip URLs from the catalog row that already
-- points at the matching assets/animation folder. catalog_id stays on the
-- animation row so the unique index is unchanged.

update public.exercises as legacy
set gif_url = animation.gif_url,
    gif_url_180 = animation.gif_url_180,
    gif_url_360 = animation.gif_url_360,
    gif_url_720 = animation.gif_url_720,
    gif_url_1080 = animation.gif_url_1080
from (
  values
    ('Barbell Back Squat', '14361301'),
    ('Barbell Row', '00271301'),
    ('Bodyweight Squat', '11971301'),
    ('Conventional Deadlift', '00321301'),
    ('Dumbbell Bicep Curl', '02941301'),
    ('Dumbbell Shoulder Press', '04051301'),
    ('Lat Pulldown', '01981301'),
    ('Leg Press', '07391301'),
    ('Overhead Press', '11621301'),
    ('Plank', '04631301'),
    ('Romanian Deadlift', '01161301'),
    ('Tricep Dip', '08141301')
) as link(legacy_name, catalog_id)
join public.exercises as animation
  on animation.catalog_id = link.catalog_id
where legacy.name = link.legacy_name
  and legacy.is_custom = false
  and legacy.gif_url_180 is null;
