// Centralized env access + validation. Throws at first use if a required secret
// is missing, so a misconfigured deploy fails loudly instead of silently
// serving errors.

function required(name: string): string {
  const value = process.env[name];
  if (!value) throw new Error(`Missing required environment variable: ${name}`);
  return value;
}

function intEnv(name: string, fallback: number): number {
  const raw = process.env[name];
  if (!raw) return fallback;
  const n = parseInt(raw, 10);
  return Number.isFinite(n) && n > 0 ? n : fallback;
}

export const env = {
  supabaseUrl: () => required('SUPABASE_URL'),
  supabaseServiceRoleKey: () => required('SUPABASE_SERVICE_ROLE_KEY'),
  rateLimit: () => intEnv('MCP_RATE_LIMIT', 60),
  rateWindowSeconds: () => intEnv('MCP_RATE_WINDOW_SECONDS', 60),
};
