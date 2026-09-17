-- Profile bio fields for the new Account / Body Profile screens.
-- username: display name the user can set (not enforced-unique -- it's a label,
--   not a login handle; auth is still by email).
-- date_of_birth: birthday (date only).
-- height_cm: height in canonical centimetres (displayed as cm or inches per the
--   user's unit preference, mirroring how weight is stored canonically in lb).
-- All nullable with no default -- existing rows and new sign-ups simply have
-- them unset until the user fills them in. The existing users_update_own
-- row-level policy already covers these columns (RLS is row-, not column-scoped).
alter table public.users
  add column if not exists username text,
  add column if not exists date_of_birth date,
  add column if not exists height_cm numeric;
