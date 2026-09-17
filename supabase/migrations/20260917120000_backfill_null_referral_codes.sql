-- Ensure every profile has a referral code (some rows were created without one).
update public.users
set referral_code = public.generate_referral_code()
where referral_code is null;
