const fs = require('fs');
const DIR = __dirname;

const names = fs.readFileSync(DIR + '/gif_names.txt', 'utf8').split('\n').map(s => s.trim()).filter(Boolean);

const EXISTING = ["Barbell Back Squat","Barbell Bench Press","Barbell Row","Bodyweight Squat","Conventional Deadlift","Dumbbell Bicep Curl","Dumbbell Incline Press","Dumbbell Lateral Raise","Dumbbell Triceps Extension","Lat Pulldown","Leg Press","Overhead Press","Pike Push-Up","Pull-Up","Push-Up","Tricep Dip","Walking Lunge"];

const norm = s => s.toLowerCase().replace(/[^a-z0-9]/g, '');
const tokens = s => s.toLowerCase().replace(/[^a-z0-9 ]/g, ' ').split(/\s+/).filter(Boolean);

// GymVisual region -> app muscle_group. neck/cardio => skip.
const REGION = {
  'upper-arms':'arms','upper-arm':'arms','forearms':'arms','forearm':'arms','triceps':'arms','hands':'arms','hand':'arms',
  'back':'back','chest':'chest',
  'thighs':'legs','thigh':'legs','hips':'legs','hip':'legs','calves':'legs','calf':'legs',
  'waist':'core','shoulders':'shoulders','shoulder':'shoulders',
  'neck':'__skip_neck__','cardio':'__skip_cardio__',
};
const EQUIP = w => {
  w = w.toLowerCase();
  if (w === 'barbell' || w === 'ez') return 'barbell';
  if (w === 'dumbbell') return 'dumbbell';
  if (w === 'cable') return 'cable';
  if (w === 'lever' || w === 'smith' || w === 'sled') return 'machine';
  return 'bodyweight';
};

const existKeys = new Set(EXISTING.map(norm));
const existTok = EXISTING.map(n => ({ name: n, t: new Set(tokens(n)) }));

const records = [];
const skipNeck = [], skipCardio = [], skipDupExisting = [], skipDupInternal = [], anomalies = [];
const seenInternal = new Set();

for (const fn of names) {
  const catalogId = fn.slice(0, 8);
  let base = fn.replace(/\.gif$/i, '').replace(/_\d+$/, ''); // strip .gif and _<res>
  let parts = base.split('_');
  // Drop a trailing standalone FIX-token (e.g. "..._waist_FIX")
  if (parts.length > 1 && /^(a|s)?fix\d?$/i.test(parts[parts.length - 1])) parts.pop();

  let region = null, namePart = base;
  if (parts.length >= 2) {
    region = parts[parts.length - 1];
    namePart = parts.slice(0, -1).join('_');
  } else {
    // no region token (the single anomaly) -> hand-assign below
    anomalies.push({ catalogId, fn, reason: 'no region token' });
  }

  // clean name: drop "<id>-" prefix, hyphens->spaces, collapse, title-case
  let rawName = namePart.replace(/^\d{8}-/, '');
  let name = rawName.replace(/-/g, ' ').replace(/\s+/g, ' ').trim()
    .split(' ').map(w => w ? w[0].toUpperCase() + w.slice(1) : w).join(' ');

  // muscle_group
  let mg;
  if (region == null) {
    if (catalogId === '12231301') mg = 'back'; // Underhand-Grip-Inverted-Back-Row
    else { anomalies.push({ catalogId, fn, reason: 'unmapped (no region, unknown)' }); continue; }
  } else {
    const r = region.toLowerCase().replace(/-(a|s)?fix\d?$/i, '');
    mg = REGION[r];
    if (!mg) { anomalies.push({ catalogId, fn, region, reason: 'unmapped region' }); continue; }
  }
  if (mg === '__skip_neck__') { skipNeck.push(name); continue; }
  if (mg === '__skip_cardio__') { skipCardio.push(name); continue; }

  const equipment = EQUIP((rawName.split('-')[0] || ''));
  const key = norm(name);

  if (existKeys.has(key)) { skipDupExisting.push(name); continue; }
  if (seenInternal.has(key)) { skipDupInternal.push(name); continue; }
  seenInternal.add(key);

  records.push({ catalogId, name, muscle_group: mg, equipment_type: equipment, key, tokens: new Set(tokens(name)) });
}

// Fuzzy review: a candidate whose token-set is a superset of an existing exercise's tokens
// (or vice-versa) is a likely variant worth eyeballing -- not auto-merged.
const review = [];
for (const r of records) {
  for (const e of existTok) {
    const eSubset = [...e.t].every(t => r.tokens.has(t));
    const rSubset = [...r.tokens].every(t => e.t.has(t));
    if ((eSubset || rSubset) && r.key !== norm(e.name)) {
      review.push(`- "${r.name}"  ~  existing "${e.name}"`);
      break;
    }
  }
}

// Outputs
const payload = records.map(({ catalogId, name, muscle_group, equipment_type }) => ({
  catalogId, name, muscle_group, equipment_type,
  gif_url: `https://ifqohqltbqslqvdqwokg.supabase.co/storage/v1/object/public/exercise-gifs/${catalogId}.gif`,
}));
fs.writeFileSync(DIR + '/manifest.json', JSON.stringify(payload, null, 0));
fs.writeFileSync(DIR + '/review-possible-duplicates.md',
  `# Possible duplicates for manual review (${review.length})\n\nNot auto-merged -- imported as separate exercises. Eyeball and delete any true dup later.\n\n` + review.sort().join('\n') + '\n');

const byGroup = {};
for (const r of records) byGroup[r.muscle_group] = (byGroup[r.muscle_group] || 0) + 1;

console.log('parsed lines        :', names.length);
console.log('INSERT set          :', records.length);
console.log('  by muscle_group   :', JSON.stringify(byGroup));
console.log('skip neck           :', skipNeck.length);
console.log('skip cardio         :', skipCardio.length, JSON.stringify(skipCardio));
console.log('skip dup vs existing:', skipDupExisting.length, JSON.stringify(skipDupExisting.slice(0,25)));
console.log('skip dup internal   :', skipDupInternal.length, JSON.stringify(skipDupInternal.slice(0,15)));
console.log('anomalies           :', JSON.stringify(anomalies));
console.log('review list size    :', review.length);
