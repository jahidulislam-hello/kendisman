-- Per-set type: warm-up, normal working set, failure, or drop set. Defaults to
-- 'normal' so every existing set and every set logged before this stays a
-- normal working set. Stored on each logged set; the UI shows W/F/D in place of
-- the set number (normal sets keep their sequential number).
alter table public.logged_sets
  add column if not exists set_type text not null default 'normal'
    check (set_type in ('warmup', 'normal', 'failure', 'drop'));
