# Previous Fitzella backend reference

The **Expo / React Native frontend was removed**. This folder keeps product/docs
history only.

## Canonical backend (use this)

All Supabase migrations, edge functions, seed, and scripts now live at:

```
../../supabase/
```

That tree was ported from this previous app and applied to project
`wpknvsnroppszmkofmdk`. The Flutter client under `../../lib/` (excluding this
folder) is the only frontend.

## Still here

- `STATUS.md` — pre-submission notes from the Expo app
- `docs/` — onboarding / test plans
- `ironcoach-technical-spec.md` — original product/engineering spec
- `mcp-server/` — optional ChatGPT MCP service (not the mobile UI)
- `tools/` — import/screenshot tooling (not the mobile UI)

## Deploy notes

Edge functions under `../../supabase/functions/` still need to be deployed to
the remote project (requires `supabase login` + `supabase functions deploy`).
Auth Site URL / Redirect URLs in the dashboard should include:

`io.fitzella.app://login-callback/`
