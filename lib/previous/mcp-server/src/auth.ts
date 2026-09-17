import { createHash, randomBytes } from 'node:crypto';
import type { AuthInfo } from '@modelcontextprotocol/sdk/server/auth/types.js';
import { serviceClient } from './supabase';
import { env } from './env';
import { isUnitPreference, UnitPreference } from './units';

// Token auth for Phase 1. A per-user opaque token is stored only as its sha256
// hash (see the mcp_api_tokens migration); the raw token is the bearer ChatGPT
// sends. Identity is resolved ENTIRELY from that token via the mcp_authenticate
// RPC, which in one atomic call: rejects unknown/revoked/expired tokens, enforces
// a fixed-window per-token rate limit, and returns the user id + unit preference.
// No tool ever sees a caller-supplied user id.

export const TOKEN_PREFIX = 'ftz_';

/** Generates a fresh raw token and its storage hash. The raw is shown once. */
export function generateToken(): { raw: string; hash: string } {
  const raw = TOKEN_PREFIX + randomBytes(32).toString('base64url');
  return { raw, hash: hashToken(raw) };
}

export function hashToken(raw: string): string {
  return createHash('sha256').update(raw).digest('hex');
}

export interface ResolvedUser {
  userId: string;
  unitPreference: UnitPreference;
}

// Stored in AuthInfo.extra so tool handlers can read the resolved identity
// without ever touching the raw token again.
type AuthExtra = {
  userId: string;
  unitPreference: UnitPreference;
  rateLimited: boolean;
};

/**
 * withMcpAuth verifier. Returns an AuthInfo for a structurally valid, non-revoked
 * token (even when rate-limited — that is flagged in `extra` and enforced per
 * tool so it surfaces as a clear "try again" error rather than a bare 401), and
 * `undefined` for a missing/unknown/revoked/expired token (→ 401).
 */
export async function verifyToken(
  _req: Request,
  bearerToken?: string
): Promise<AuthInfo | undefined> {
  if (!bearerToken) return undefined;

  const { data, error } = await serviceClient().rpc('mcp_authenticate', {
    p_token_hash: hashToken(bearerToken),
    p_limit: env.rateLimit(),
    p_window_seconds: env.rateWindowSeconds(),
  });
  if (error) throw new Error(`Auth backend error: ${error.message}`);

  const row = Array.isArray(data) ? data[0] : null;
  if (!row || !row.user_id) return undefined; // unknown / revoked / expired

  const unit = isUnitPreference(row.unit_preference) ? row.unit_preference : 'lb';
  const extra: AuthExtra = {
    userId: row.user_id as string,
    unitPreference: unit,
    rateLimited: row.allowed === false,
  };
  return { token: bearerToken, clientId: 'fitzella-mcp', scopes: [], extra };
}

/** Raised by requireUser; carries an HTTP-ish hint for the tool error text. */
export class AuthError extends Error {}

/**
 * Called at the top of every tool handler. Pulls the resolved identity out of the
 * request's AuthInfo and enforces the rate-limit flag. Throwing here turns into a
 * tool error the model can read, without leaking the token.
 */
export function requireUser(extra: { authInfo?: AuthInfo }): ResolvedUser {
  const info = extra.authInfo;
  const data = info?.extra as AuthExtra | undefined;
  if (!info || !data?.userId) {
    throw new AuthError('Not authenticated. Provide a valid Fitzella API token.');
  }
  if (data.rateLimited) {
    throw new AuthError(
      `Rate limit exceeded (${env.rateLimit()} requests per ${env.rateWindowSeconds()}s). Try again shortly.`
    );
  }
  return { userId: data.userId, unitPreference: data.unitPreference };
}
