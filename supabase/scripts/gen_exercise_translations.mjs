// Generates exercise-name translation migrations from the canonical English
// list (exercise_names.en.txt) using a per-language, gender-aware composition
// lexicon. Exercise names are compositional -- [equipment] [modifiers]
// [movement] [(variant)] -- so we translate the movement head, agree + place
// the modifier adjectives, and append the equipment phrase, rather than
// hand-writing 2,600 strings inconsistently.
//
// Usage:  node gen_exercise_translations.mjs <locale>        # prints coverage report
//         node gen_exercise_translations.mjs <locale> --sql  # prints migration SQL
//
// The output SQL matches rows by English name (no hardcoded UUIDs) and only
// touches is_custom = false rows.

import { readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { dirname, join } from 'node:path';

const __dir = dirname(fileURLToPath(import.meta.url));
const NAMES = readFileSync(join(__dir, 'exercise_names.en.txt'), 'utf8')
  .split('\n')
  .map((s) => s.trim())
  .filter(Boolean);

// --- shared parsing -------------------------------------------------------

// Equipment prefixes, longest first. `suffix` is the localized trailing phrase
// per language; `null` means bodyweight/none (no equipment phrase appended).
const EQUIP = [
  { en: 'EZ Barbell', key: 'ez' },
  { en: 'EZ Bar', key: 'ez' },
  { en: 'Dumbbells', key: 'dumbbell' },
  { en: 'Dumbbell', key: 'dumbbell' },
  { en: 'Barbell', key: 'barbell' },
  { en: 'Cable', key: 'cable' },
  { en: 'Leverage', key: 'lever' },
  { en: 'Lever', key: 'lever' },
  { en: 'Smith Machine', key: 'smith' },
  { en: 'Smith', key: 'smith' },
  { en: 'Sled', key: 'sled' },
  { en: 'Machine', key: 'machine' },
  { en: 'Bodyweight', key: 'bodyweight' },
];

// Parenthetical / trailing variant fragments -> a language-neutral token we
// translate per language. Anything unrecognized is preserved verbatim.
function parseVariants(name) {
  let s = name;
  const variants = [];
  s = s.replace(/_back\b/gi, ''); // stray dataset glitch
  // (VERSION 2) / (Version 3) anywhere
  s = s.replace(/\s*\((?:VERSION|Version)\s*(\d+)\)/gi, (m, n) => { variants.push({ version: n }); return ''; });
  // trailing "Version 3" without parens
  s = s.replace(/\s+Version\s+(\d+)\s*$/i, (m, n) => { variants.push({ version: n }); return ''; });
  // trailing roman "II" == version 2
  s = s.replace(/\s+II\s*$/, () => { variants.push({ version: '2' }); return ''; });
  // remaining parentheticals, in order
  s = s.replace(/\s*\(([^)]*)\)/g, (m, inner) => { variants.push({ paren: inner.trim() }); return ''; });
  return { base: s.replace(/\s+/g, ' ').trim(), variants };
}

function parse(name) {
  const { base, variants } = parseVariants(name);
  let equip = null;
  let core = base;
  for (const e of EQUIP) {
    if (base === e.en) { equip = e.key; core = ''; break; }
    if (base.startsWith(e.en + ' ')) { equip = e.key; core = base.slice(e.en.length + 1); break; }
  }
  return { equip, core: core.trim(), variants };
}

// --- language packs -------------------------------------------------------
// Each pack: equip suffixes, variant words, movement heads (with grammatical
// gender + number), modifier adjectives (gender-aware), and a fewfull-core
// overrides for idioms the compositional path would get wrong.

const PACKS = {};

// helper to build a composer for romance languages (post-nominal adjectives)
// Shared composer. The per-language pack owns core translation + equipment
// placement via pack.render(core, equip); this only adds parenthetical
// variants and normalizes whitespace.
function romanceComposer(pack) {
  return function translate(name) {
    const { equip, core, variants } = parse(name);
    let phrase = pack.render(core, equip);
    if (phrase == null) return { text: null, missing: core };
    for (const v of variants) {
      if (v.version) phrase += ` (${pack.versionWord}${v.version})`;
      else if (v.paren) {
        const p = pack.paren(v.paren);
        if (p) phrase += ` (${p})`;
      }
    }
    return { text: phrase.replace(/\s+/g, ' ').trim(), missing: null };
  };
}

// (language packs are attached below, kept in separate files-in-spirit)
import { ES } from './lex/es.mjs';
PACKS.es = ES(romanceComposer);
import { PT } from './lex/pt.mjs';
PACKS.pt = PT(romanceComposer);
import { DE } from './lex/de.mjs';
PACKS.de = DE(romanceComposer);
import { FR } from './lex/fr.mjs';
PACKS.fr = FR(romanceComposer);
import { IT } from './lex/it.mjs';
PACKS.it = IT(romanceComposer);

// --- run ------------------------------------------------------------------
const locale = process.argv[2];
const emitSql = process.argv.includes('--sql');
const pack = PACKS[locale];
if (!pack) { console.error('unknown locale', locale); process.exit(1); }

const rows = [];
const missing = [];
for (const en of NAMES) {
  const { text, missing: miss } = pack.translate(en);
  if (miss || !text) { missing.push(miss || en); continue; }
  rows.push([en, text]);
}

if (emitSql) {
  const esc = (s) => s.replace(/'/g, "''");
  const values = rows.map(([en, tr]) => `  ('${esc(en)}', '${esc(tr)}')`).join(',\n');
  process.stdout.write(
`-- AUTO-GENERATED by supabase/scripts/gen_exercise_translations.mjs (${locale}).
-- Localized exercise-library names. Matches rows by English name; only
-- built-in (is_custom = false) exercises are translated.
insert into public.exercise_translations (exercise_id, locale, name)
select e.id, '${locale}', v.name
from public.exercises e
join (values
${values}
) as v(en, name) on v.en = e.name and e.is_custom = false
on conflict (exercise_id, locale) do update set name = excluded.name;
`);
} else {
  console.log(`locale=${locale}  translated=${rows.length}/${NAMES.length}  missing=${missing.length}`);
  if (missing.length) console.log('MISSING:\n' + missing.join('\n'));
}
