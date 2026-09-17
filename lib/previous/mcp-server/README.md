# Fitzella MCP server (OpenAI Apps SDK)

A **separate, read-only** service that exposes a Fitzella user's workout data to
ChatGPT via the OpenAI Apps SDK. It is **not** part of the React Native app; it
reads the same Supabase project. Deploy target: **Vercel**.

**Phase 1** (this): read-only tools, per-user **token** auth, developer-mode
testing. No OAuth yet, no writes.

## Endpoint

Streamable HTTP MCP at **`/mcp`** (Next.js App Router route `app/[transport]/route.ts`,
`mcp-handler` with `basePath: "/"`). Node runtime.

## Tools (all read-only, none take a `user_id`)

| Tool | Input | Returns |
|---|---|---|
| `get_recent_workouts` | `limit?` (1–50, def 10) | recent sessions → exercises → sets |
| `get_exercise_history` | `exercise_name`, `since?` | every set for one exercise over time (name fuzzy-matched) |
| `get_personal_records` | — | heaviest working set + Epley 1RM per exercise |
| `get_training_volume` | `days?` (1–365, def 30) | working-set volume by muscle group |
| `get_body_measurements` | `type?`, `since?` | bodyweight / body-fat / circumferences |

Weights are returned in the user's `unit_preference` (`lb`/`kg`) with the unit
**named in every payload**; circumferences use the paired length unit (kg→cm,
lb→in).

## Security model

- **Identity comes only from the token.** No tool accepts a `user_id`. Each request
  runs `mcp_authenticate(token_hash, limit, window)` (one atomic RPC) that rejects
  unknown/revoked/expired tokens, enforces a fixed-window per-token rate limit, and
  returns the resolved `user_id` + `unit_preference`.
- **Raw tokens are never stored** — only their sha256 hash.
- **Service-role key is server-only** and bypasses RLS, so `src/queries.ts` scopes
  every query to the resolved `user_id` by hand. Never expose the key to a client
  or a `NEXT_PUBLIC_*` var.
- **Revocation:** `update mcp_api_tokens set revoked_at = now() where token_hash = '…'`.
- **Rate limit:** `MCP_RATE_LIMIT` requests per `MCP_RATE_WINDOW_SECONDS` (default 60/60).

## Environment

Copy `.env.example` → `.env` and fill in:

- `SUPABASE_URL` — `https://ifqohqltbqslqvdqwokg.supabase.co`
- `SUPABASE_SERVICE_ROLE_KEY` — Supabase dashboard → Project Settings → API → `service_role`
- `MCP_RATE_LIMIT`, `MCP_RATE_WINDOW_SECONDS` — optional

## Database

Table + RPC live in the main repo migration
`supabase/migrations/20260726160000_add_mcp_tokens.sql` (already applied to the
shared Supabase project).

## Mint a token (Phase 1 testing)

```bash
npm install
cp .env.example .env      # fill in SUPABASE_SERVICE_ROLE_KEY
npm run mint-token -- vermonski+iostest1@gmail.com "ChatGPT dev"
# prints the raw token ONCE
```

Optionally verify the data layer without deploying:

```bash
npx tsx scripts/selftest.ts vermonski+iostest1@gmail.com
```

## Deploy to Vercel

1. New Vercel project, **Root Directory = `mcp-server`** (framework auto-detected: Next.js).
2. Add env vars `SUPABASE_URL` and `SUPABASE_SERVICE_ROLE_KEY` (Production + Preview).
3. Deploy → your endpoint is `https://<project>.vercel.app/mcp`.

## Connect in ChatGPT (developer mode)

1. ChatGPT → **Settings → Security/Connectors → enable Developer mode**.
2. Add a connector with the URL `https://<project>.vercel.app/mcp` and the minted
   token as the bearer credential.
3. Review the discovered tools and try them.

For local iteration, expose the dev server (`npm run dev`, port 3005) over HTTPS
with a tunnel, or test with **MCP Inspector** using an `Authorization: Bearer <token>`
header — the doc's recommended pre-submission check.

## Not in Phase 1

OAuth 2.1 (production auth + the ChatGPT account-linking UI), any write tools, and
custom UI components. Those are later phases.
