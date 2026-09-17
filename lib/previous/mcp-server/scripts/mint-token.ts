import { generateToken } from '../src/auth';
import { serviceClient } from '../src/supabase';

// Mints a per-user API token for Phase 1 testing. The raw token is printed ONCE;
// only its sha256 hash is stored. Usage:
//   npm run mint-token -- <email> ["label"]

async function main() {
  try {
    (process as unknown as { loadEnvFile?: (p: string) => void }).loadEnvFile?.('.env');
  } catch {
    /* .env optional if the vars are already in the environment */
  }

  const email = process.argv[2];
  const label = process.argv[3] ?? 'ChatGPT (dev)';
  if (!email) {
    console.error('Usage: npm run mint-token -- <email> ["label"]');
    process.exit(1);
  }

  const sb = serviceClient();
  const { data: user, error } = await sb.from('users').select('id, email').eq('email', email).single();
  if (error || !user) {
    console.error(`No user found for ${email}: ${error?.message ?? 'not found'}`);
    process.exit(1);
  }

  const { raw, hash } = generateToken();
  const { error: insErr } = await sb
    .from('mcp_api_tokens')
    .insert({ user_id: user.id, token_hash: hash, label });
  if (insErr) {
    console.error(`Failed to store token: ${insErr.message}`);
    process.exit(1);
  }

  console.log(`\n✅ Token minted for ${email} (label: "${label}")`);
  console.log('   Shown ONCE — only its hash is stored. Use it as the Bearer token:\n');
  console.log(`   ${raw}\n`);
  console.log('   Revoke later with:');
  console.log(`   update mcp_api_tokens set revoked_at = now() where token_hash = '${hash}';\n`);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
