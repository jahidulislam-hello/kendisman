-- The original migration deliberately left ai_coach_notes with no insert
-- policy, on the assumption (spec Section 6) that the progression engine
-- would run server-side. For this MVP step the engine runs client-side in
-- the mobile app, so the client needs to write the notes it generates for
-- its own sessions. Revisit -- tighten this back to service-role-only --
-- once progression logic moves into a Supabase Edge Function.
create policy "ai_coach_notes_insert_own" on public.ai_coach_notes
  for insert with check (
    exists (
      select 1 from public.workout_sessions s
      where s.id = ai_coach_notes.session_id and s.user_id = auth.uid()
    )
  );
