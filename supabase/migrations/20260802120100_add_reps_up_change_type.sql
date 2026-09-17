-- Range-aware progression adds a 'reps_up' outcome (double progression: step reps
-- toward the top of the range before adding weight). ai_coach_notes.change_type is
-- the enum public.coach_note_change_type, so the new value must be registered here
-- to keep the DB in sync with packages/progression-engine's ChangeType.
alter type public.coach_note_change_type add value if not exists 'reps_up';
