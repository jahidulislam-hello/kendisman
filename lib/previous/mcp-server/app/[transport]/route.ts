import { createMcpHandler, withMcpAuth } from 'mcp-handler';
import { registerTools } from '../../src/tools';
import { verifyToken } from '../../src/auth';

// Node runtime: we use node:crypto and the Supabase service client, and there is
// no Redis (stateless streamable HTTP), so no edge/KV wiring is needed.
export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';
export const maxDuration = 60;

// Streamable HTTP MCP handler. basePath "/" + the [transport] segment means the
// endpoint ChatGPT connects to is https://<host>/mcp.
const handler = createMcpHandler(
  (server) => {
    registerTools(server);
  },
  {
    // Shared guidance surfaced to the model (kept under 512 chars).
    instructions:
      'Read-only access to the signed-in Fitzella user\'s strength-training data. Every tool resolves the user from the auth token — never pass a user id. Weights are returned in the user\'s own unit (lb or kg), named explicitly in each response; do not convert or assume. Requests are rate limited per token.',
  },
  { basePath: '/' }
);

// Phase 1 auth: our own per-user bearer token (not OAuth). verifyToken resolves
// identity + enforces the rate limit; a missing/invalid/revoked token → 401.
const authedHandler = withMcpAuth(handler, verifyToken, { required: true });

export { authedHandler as GET, authedHandler as POST, authedHandler as DELETE };
