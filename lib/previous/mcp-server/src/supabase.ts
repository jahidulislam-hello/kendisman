import { createClient, SupabaseClient } from '@supabase/supabase-js';
import { env } from './env';

// Service-role client — bypasses RLS. It is created lazily and lives only on the
// server. Because it bypasses RLS, EVERY query built on top of it must scope to a
// token-resolved user id by hand (see queries.ts); there is no database-level
// safety net here, which is exactly why no tool accepts a caller-supplied user_id.

let client: SupabaseClient | null = null;

export function serviceClient(): SupabaseClient {
  if (!client) {
    client = createClient(env.supabaseUrl(), env.supabaseServiceRoleKey(), {
      auth: { persistSession: false, autoRefreshToken: false },
    });
  }
  return client;
}
