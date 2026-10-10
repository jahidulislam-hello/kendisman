/**
 * Reads assets/animation/<catalogId>/*.gif (180, 360, 720, 1080) and:
 *   1. Writes supabase/migrations/20261008120000_exercise_animation_gifs.sql
 *   2. With SUPABASE_SERVICE_ROLE_KEY, creates the public exercise-gifs bucket,
 *      uploads every GIF, then inserts or updates exercise rows.
 *
 *   node supabase/scripts/upload-exercise-gifs.mjs
 *   node supabase/scripts/upload-exercise-gifs.mjs --sql-only
 *   node supabase/scripts/upload-exercise-gifs.mjs --upload
 */
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '../..');
const animationDir = path.join(root, 'assets', 'animation');
const migrationPath = path.join(
  root,
  'supabase',
  'migrations',
  '20261008120000_exercise_animation_gifs.sql',
);
const supabaseUrl = (
  process.env.SUPABASE_URL || 'https://wpknvsnroppszmkofmdk.supabase.co'
).replace(/\/$/, '');
const serviceKey = process.env.SUPABASE_SERVICE_ROLE_KEY || '';
const allResolutions = [180, 360, 720, 1080];
const uploadResolutions = (process.env.GIF_RESOLUTIONS || '180,360,720,1080')
  .split(',')
  .map((value) => Number(value.trim()))
  .filter((value) => allResolutions.includes(value));
const resolutions = allResolutions;

const regionMap = {
  'upper-arms': 'arms',
  'upper-arm': 'arms',
  forearms: 'arms',
  forearm: 'arms',
  triceps: 'arms',
  hands: 'arms',
  hand: 'arms',
  back: 'back',
  chest: 'chest',
  thighs: 'legs',
  thigh: 'legs',
  hips: 'legs',
  hip: 'legs',
  calves: 'legs',
  calf: 'legs',
  waist: 'core',
  shoulders: 'shoulders',
  shoulder: 'shoulders',
  neck: 'neck',
  cardio: 'cardio',
};

function equipmentFor(rawName) {
  const word = (rawName.split('-')[0] || '').toLowerCase();
  if (word === 'barbell' || word === 'ez') return 'barbell';
  if (word === 'dumbbell') return 'dumbbell';
  if (word === 'cable') return 'cable';
  if (word === 'lever' || word === 'smith' || word === 'sled') return 'machine';
  return 'bodyweight';
}

function displayName(rawHyphenated) {
  let raw = rawHyphenated
    .replace(/-(male|female)$/i, '')
    .replace(/-m$/i, '')
    .replace(/-(a|s)?fix\d?$/i, '');
  raw = raw.replace(/^(\d+)-(\d+)-/, '$1/$2 ');
  const words = raw.replace(/-/g, ' ').replace(/\s+/g, ' ').trim().split(' ').filter(Boolean);
  const small = new Set(['a', 'of', 'the', 'and', 'to', 'in', 'on', 'for', 'with']);
  let name = words
    .map((word, index) => {
      const lower = word.toLowerCase();
      if (lower === 'ez') return 'EZ';
      if (lower === 'ii' || lower === 'iii' || lower === 'iv') return lower.toUpperCase();
      if (index > 0 && small.has(lower)) return lower;
      return lower[0].toUpperCase() + lower.slice(1);
    })
    .join(' ');
  name = name
    .replace(/\bRevers\b/g, 'Reverse')
    .replace(/\bSit Up\b/g, 'Sit-Up')
    .replace(/\bPush Up\b/g, 'Push-Up')
    .replace(/\bPull Up\b/g, 'Pull-Up')
    .replace(/\bChin Up\b/g, 'Chin-Up');
  return name;
}

function normName(value) {
  return value.toLowerCase().replace(/[^a-z0-9]/g, '');
}

function parseGif(filename) {
  const catalogId = filename.slice(0, 8);
  const resolutionMatch = filename.match(/_(\d+)\.gif$/i);
  const resolution = resolutionMatch ? Number(resolutionMatch[1]) : null;
  let base = filename.replace(/\.gif$/i, '').replace(/_\d+$/, '');
  let parts = base.split('_');
  if (parts.length > 1 && /^(a|s)?fix\d?$/i.test(parts[parts.length - 1])) {
    parts.pop();
  }

  const regionToken = parts.length >= 2 ? parts[parts.length - 1] : null;
  const namePart = parts.length >= 2 ? parts.slice(0, -1).join('_') : base;
  const rawName = namePart
    .replace(/^\d{8}-/, '')
    .replace(/-(a|s)?fix\d?$/i, '')
    .replace(/»rip/gi, 'Grip');
  const name = displayName(rawName);

  let muscleGroup = 'other';
  if (regionToken) {
    const region = regionToken.toLowerCase().replace(/-(a|s)?fix\d?$/i, '');
    muscleGroup = regionMap[region] || region;
  } else if (catalogId === '12231301') {
    muscleGroup = 'back';
  }

  return {
    catalogId,
    resolution,
    filename,
    name,
    muscleGroup,
    equipmentType: equipmentFor(rawName),
    norm: normName(name),
  };
}

function storageFileName(filename) {
  return filename.replace(/»rip/gi, 'Grip').replaceAll('°', 'deg');
}

function publicGifUrl(catalogId, filename) {
  const encoded = encodeURIComponent(storageFileName(filename))
    .replaceAll('(', '%28')
    .replaceAll(')', '%29');
  return `${supabaseUrl}/storage/v1/object/public/exercise-gifs/${catalogId}/${encoded}`;
}

function sqlQuote(value) {
  return `'${String(value).replaceAll("'", "''")}'`;
}

export function loadAnimationRecords() {
  const folders = fs
    .readdirSync(animationDir, { withFileTypes: true })
    .filter((entry) => entry.isDirectory());
  const byNorm = new Map();
  const skipped = [];

  for (const folder of folders) {
    const files = fs
      .readdirSync(path.join(animationDir, folder.name))
      .filter((name) => name.toLowerCase().endsWith('.gif'));
    const parsed = files.map(parseGif).filter((row) => row.name);
    if (parsed.length === 0) {
      skipped.push({ folder: folder.name, reason: 'no gif' });
      continue;
    }
    const sample = parsed[0];
    const present = new Set(parsed.map((row) => row.resolution));
    const missing = resolutions.filter((resolution) => !present.has(resolution));
    if (missing.length > 0) {
      skipped.push({ folder: folder.name, reason: `missing ${missing.join(',')}` });
    }
    if (byNorm.has(sample.norm)) {
      skipped.push({
        folder: folder.name,
        reason: `duplicate name "${sample.name}"`,
      });
      continue;
    }
    const paths = {};
    const filenames = {};
    for (const file of files) {
      const row = parseGif(file);
      if (!resolutions.includes(row.resolution)) continue;
      paths[row.resolution] = path.join(animationDir, folder.name, file);
      filenames[row.resolution] = file;
    }
    byNorm.set(sample.norm, {
      ...sample,
      paths,
      filenames,
      urls: Object.fromEntries(
        resolutions.map((resolution) => [
          resolution,
          publicGifUrl(sample.catalogId, filenames[resolution]),
        ]),
      ),
    });
  }

  return { records: [...byNorm.values()], skipped };
}

function migrationSql(records) {
  const values = records
    .map((row) => {
      return `(${[
        sqlQuote(row.norm),
        sqlQuote(row.catalogId),
        sqlQuote(row.name),
        sqlQuote(row.muscleGroup),
        sqlQuote(row.equipmentType),
        sqlQuote(row.urls[360]),
        sqlQuote(row.urls[180]),
        sqlQuote(row.urls[360]),
        sqlQuote(row.urls[720]),
        sqlQuote(row.urls[1080]),
      ].join(', ')})`;
    })
    .join(',\n  ');

  return `-- Public demonstration GIFs for the add-exercise library.
-- Each assets/animation folder has four files (180, 360, 720, 1080).
-- Binaries live in the public exercise-gifs bucket at {catalog_id}/{original-gif-filename}.
-- gif_url stays the 360p clip. gif_url_180 is the add-exercise thumbnail.

alter table public.exercises
  add column if not exists catalog_id text,
  add column if not exists gif_url_180 text,
  add column if not exists gif_url_360 text,
  add column if not exists gif_url_720 text,
  add column if not exists gif_url_1080 text;

comment on column public.exercises.catalog_id is
  'GymVisual catalog id. Storage object prefix in the exercise-gifs bucket.';
comment on column public.exercises.gif_url_180 is
  'Public 180p demonstration GIF. Used as the add-exercise thumbnail.';
comment on column public.exercises.gif_url_360 is
  'Public 360p demonstration GIF.';
comment on column public.exercises.gif_url_720 is
  'Public 720p demonstration GIF.';
comment on column public.exercises.gif_url_1080 is
  'Public 1080p demonstration GIF.';

create unique index if not exists exercises_catalog_id_key
  on public.exercises (catalog_id)
  where catalog_id is not null;

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('exercise-gifs', 'exercise-gifs', true, 10485760, array['image/gif'])
on conflict (id) do update
set public = true,
    file_size_limit = excluded.file_size_limit,
    allowed_mime_types = excluded.allowed_mime_types;

drop policy if exists "exercise_gifs_public_read" on storage.objects;
create policy "exercise_gifs_public_read" on storage.objects
  for select to public
  using (bucket_id = 'exercise-gifs');

with source(norm_name, catalog_id, name, muscle_group, equipment_type, gif_url, gif_url_180, gif_url_360, gif_url_720, gif_url_1080) as (
  values
  ${values}
),
matched as (
  select distinct on (source.catalog_id)
    public.exercises.id,
    source.catalog_id,
    source.name,
    source.gif_url,
    source.gif_url_180,
    source.gif_url_360,
    source.gif_url_720,
    source.gif_url_1080
  from source
  join public.exercises
    on public.exercises.catalog_id = source.catalog_id
    or (
      public.exercises.is_custom = false
      and public.exercises.catalog_id is null
      and lower(regexp_replace(public.exercises.name, '[^a-zA-Z0-9]', '', 'g')) = source.norm_name
    )
  order by source.catalog_id, public.exercises.catalog_id nulls last, public.exercises.created_at
)
update public.exercises
set name = matched.name,
    catalog_id = matched.catalog_id,
    gif_url = matched.gif_url,
    gif_url_180 = matched.gif_url_180,
    gif_url_360 = matched.gif_url_360,
    gif_url_720 = matched.gif_url_720,
    gif_url_1080 = matched.gif_url_1080
from matched
where public.exercises.id = matched.id;

insert into public.exercises (
  name, muscle_group, equipment_type, is_custom, catalog_id,
  gif_url, gif_url_180, gif_url_360, gif_url_720, gif_url_1080
)
select
  source.name,
  source.muscle_group,
  source.equipment_type,
  false,
  source.catalog_id,
  source.gif_url,
  source.gif_url_180,
  source.gif_url_360,
  source.gif_url_720,
  source.gif_url_1080
from (
  values
  ${values}
) as source(norm_name, catalog_id, name, muscle_group, equipment_type, gif_url, gif_url_180, gif_url_360, gif_url_720, gif_url_1080)
where not exists (
  select 1
  from public.exercises
  where catalog_id = source.catalog_id
     or (
       is_custom = false
       and lower(regexp_replace(name, '[^a-zA-Z0-9]', '', 'g')) = source.norm_name
     )
);

notify pgrst, 'reload schema';
`;
}

async function storageRequest(method, objectPath, body, contentType) {
  const response = await fetch(`${supabaseUrl}/storage/v1/${objectPath}`, {
    method,
    headers: {
      authorization: `Bearer ${serviceKey}`,
      apikey: serviceKey,
      ...(contentType ? { 'content-type': contentType } : {}),
      ...(method === 'POST' && objectPath.startsWith('object/')
        ? { 'x-upsert': 'true' }
        : {}),
    },
    body,
  });
  if (!response.ok) {
    const detail = await response.text();
    throw new Error(`${method} ${objectPath} failed (${response.status}): ${detail}`);
  }
  return response;
}

async function ensureBucket() {
  const response = await fetch(`${supabaseUrl}/storage/v1/bucket`, {
    method: 'POST',
    headers: {
      authorization: `Bearer ${serviceKey}`,
      apikey: serviceKey,
      'content-type': 'application/json',
    },
    body: JSON.stringify({
      id: 'exercise-gifs',
      name: 'exercise-gifs',
      public: true,
      file_size_limit: 10485760,
      allowed_mime_types: ['image/gif'],
    }),
  });
  const detail = await response.text();
  if (response.ok || response.status === 409 || detail.includes('already exists')) return;
  throw new Error(`Could not create exercise-gifs bucket (${response.status}): ${detail}`);
}

async function uploadAll(records) {
  await ensureBucket();
  const jobs = [];
  for (const record of records) {
    for (const resolution of uploadResolutions) {
      const filePath = record.paths[resolution];
      if (!filePath) continue;
      jobs.push({
        filePath,
        objectPath: `object/exercise-gifs/${record.catalogId}/${storageFileName(record.filenames[resolution])}`,
      });
    }
  }

  let cursor = 0;
  let done = 0;
  async function worker() {
    while (cursor < jobs.length) {
      const job = jobs[cursor];
      cursor += 1;
      const bytes = fs.readFileSync(job.filePath);
      const url = new URL(`${supabaseUrl}/storage/v1/${job.objectPath}`);
      const response = await fetch(url, {
        method: 'POST',
        headers: {
          authorization: `Bearer ${serviceKey}`,
          apikey: serviceKey,
          'content-type': 'image/gif',
          'x-upsert': 'true',
        },
        body: bytes,
      });
      if (!response.ok) {
        const detail = await response.text();
        const message = `POST failed (${response.status}): ${detail}`;
        if (response.status === 401 || response.status === 403) {
          throw new Error(message);
        }
        console.error(message);
        continue;
      }
      done += 1;
      if (done % 50 === 0 || done === jobs.length) {
        console.log(`uploaded ${done}/${jobs.length}`);
      }
    }
  }

  await Promise.all(Array.from({ length: 6 }, () => worker()));
}

async function rest(method, resource, body, prefer) {
  const response = await fetch(`${supabaseUrl}/rest/v1/${resource}`, {
    method,
    headers: {
      authorization: `Bearer ${serviceKey}`,
      apikey: serviceKey,
      'content-type': 'application/json',
      ...(prefer ? { prefer } : {}),
    },
    body: body == null ? undefined : JSON.stringify(body),
  });
  if (!response.ok) {
    const detail = await response.text();
    throw new Error(`${method} ${resource} failed (${response.status}): ${detail}`);
  }
  if (response.status === 204) return null;
  const text = await response.text();
  return text ? JSON.parse(text) : null;
}

async function syncRows(records) {
  const probe = await fetch(
    `${supabaseUrl}/rest/v1/exercises?select=gif_url_180&limit=1`,
    {
      headers: {
        authorization: `Bearer ${serviceKey}`,
        apikey: serviceKey,
      },
    },
  );
  const columnsReady = probe.ok;
  if (!columnsReady) {
    console.log(
      'Resolution columns are not on the live table yet. Writing gif_url only. Apply the migration to store 180/360/720/1080 separately.',
    );
  }

  const existing = await rest(
    'GET',
    'exercises?select=id,name&is_custom=eq.false&limit=1000',
  );
  const byNorm = new Map(
    (existing || []).map((row) => [normName(row.name), row.id]),
  );

  for (const record of records) {
    const payload = columnsReady
      ? {
          catalog_id: record.catalogId,
          gif_url: record.urls[360],
          gif_url_180: record.urls[180],
          gif_url_360: record.urls[360],
          gif_url_720: record.urls[720],
          gif_url_1080: record.urls[1080],
        }
      : { gif_url: record.urls[180] };

    const existingId = byNorm.get(record.norm);
    if (existingId) {
      await rest(
        'PATCH',
        `exercises?id=eq.${existingId}`,
        payload,
        'return=minimal',
      );
      continue;
    }

    await rest(
      'POST',
      'exercises',
      {
        name: record.name,
        muscle_group: record.muscleGroup,
        equipment_type: record.equipmentType,
        is_custom: false,
        ...payload,
        ...(columnsReady ? {} : { gif_url: record.urls[180] }),
      },
      'return=minimal',
    );
  }
}

const sqlOnly = process.argv.includes('--sql-only');
const upload = process.argv.includes('--upload') || (!sqlOnly && serviceKey);

const { records, skipped } = loadAnimationRecords();
console.log(`exercises: ${records.length}`);
console.log(`skipped: ${skipped.length}`);
if (skipped.length > 0) {
  console.log(skipped.slice(0, 20));
}

if (!process.argv.includes('--upload-only')) {
  fs.writeFileSync(migrationPath, migrationSql(records));
  console.log(`wrote ${migrationPath}`);
}

if (upload) {
  if (!serviceKey) {
    console.error(
      'SUPABASE_SERVICE_ROLE_KEY is required to upload GIFs and write exercise rows.',
    );
    process.exitCode = 1;
  } else {
    await uploadAll(records);
    if (process.env.GIF_FILES_ONLY === '1') {
      console.log('file upload finished');
    } else {
      await syncRows(records);
      console.log('upload and exercise sync finished');
    }
  }
}
