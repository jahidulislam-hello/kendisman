// Deletes the calling user's account entirely. The client can't do this
// itself -- auth.admin.deleteUser requires the service-role key, which
// never ships to the app. Deleting the auth.users row cascades through
// every dependent table (public.users, routines, programs,
// workout_sessions, logged_sets, ai_coach_notes, chat_messages,
// progress_photos -- see the "on delete cascade" foreign keys in
// supabase/migrations), so no manual per-table cleanup is needed for the DB.
//
// Storage is the exception: storage.objects has no foreign key back to the
// user, so deleting the auth row leaves the actual uploaded files behind.
// We therefore delete the user's progress-photo objects explicitly first,
// before removing the account.
import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient, SupabaseClient } from "@supabase/supabase-js";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

const PROGRESS_PHOTOS_BUCKET = "progress-photos";
// storage list() caps at 100 rows/page by default; page through so a user
// with many photos still has all of them removed.
const STORAGE_PAGE_SIZE = 100;

// Removes every object under the user's folder (paths are `${userId}/<file>`,
// see progressPhotos.ts). Best-effort: a storage hiccup here must not trap a
// user in an account they can't delete, so failures are logged and the
// caller still proceeds to delete the account. Returns whether cleanup was
// fully successful, for logging.
async function deleteUserPhotos(admin: SupabaseClient, userId: string): Promise<boolean> {
  const bucket = admin.storage.from(PROGRESS_PHOTOS_BUCKET);
  let offset = 0;
  let allRemoved = true;

  // Loop pages until a short page signals the folder is exhausted.
  for (;;) {
    const { data: files, error: listError } = await bucket.list(userId, {
      limit: STORAGE_PAGE_SIZE,
      offset,
    });
    if (listError) {
      console.error("delete-account: failed to list photos", listError);
      return false;
    }
    if (!files || files.length === 0) break;

    const paths = files.map((f) => `${userId}/${f.name}`);
    const { error: removeError } = await bucket.remove(paths);
    if (removeError) {
      console.error("delete-account: failed to remove photos", removeError);
      allRemoved = false;
    }

    if (files.length < STORAGE_PAGE_SIZE) break;
    // Files just removed no longer count toward the listing, so the next
    // page starts at 0 again rather than advancing past them.
    offset = removeError ? offset + files.length : 0;
  }

  return allRemoved;
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }

  try {
    const supabaseClient = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_ANON_KEY")!,
      { global: { headers: { Authorization: req.headers.get("Authorization")! } } }
    );

    const {
      data: { user },
      error: authError,
    } = await supabaseClient.auth.getUser();

    if (authError || !user) {
      return new Response(JSON.stringify({ error: "Unauthorized" }), {
        status: 401,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const supabaseAdmin = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
    );

    // Remove the user's storage objects first -- these aren't reachable by
    // the DB cascade below, so they'd otherwise be orphaned forever.
    const photosRemoved = await deleteUserPhotos(supabaseAdmin, user.id);
    if (!photosRemoved) {
      // Logged inside deleteUserPhotos; we still delete the account so a
      // storage problem can't leave the user unable to remove it.
      console.error("delete-account: proceeding despite incomplete photo cleanup", { userId: user.id });
    }

    const { error: deleteError } = await supabaseAdmin.auth.admin.deleteUser(user.id);
    if (deleteError) throw deleteError;

    return new Response(JSON.stringify({ success: true }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (error) {
    console.error("delete-account error:", error);
    return new Response(JSON.stringify({ error: "Internal error" }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
