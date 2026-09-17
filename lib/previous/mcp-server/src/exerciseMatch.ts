// Fuzzy-matches a free-text exercise name (from ChatGPT) to our library, reusing
// the same normalize + token-overlap scoring as the app's CSV import so results
// are consistent. Equipment words are kept as tokens on purpose.

export interface LibraryExercise {
  id: string;
  name: string;
  muscle_group: string;
}

export function normalizeExerciseName(name: string): string {
  return name
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, ' ')
    .trim()
    .replace(/\s+/g, ' ');
}

function similarity(aNorm: string, bNorm: string): number {
  if (aNorm === bNorm) return 1;
  const a = new Set(aNorm ? aNorm.split(' ') : []);
  const b = new Set(bNorm ? bNorm.split(' ') : []);
  if (a.size === 0 || b.size === 0) return 0;
  let inter = 0;
  for (const t of a) if (b.has(t)) inter++;
  const union = a.size + b.size - inter;
  return 0.5 * (inter / Math.min(a.size, b.size)) + 0.5 * (inter / union);
}

const THRESHOLD = 0.5;

export interface MatchResult {
  matched: LibraryExercise | null;
  score: number;
  suggestions: string[]; // next-best names when no confident match
}

/** Best library match for a query name, with fallback suggestions. */
export function matchExercise(query: string, library: LibraryExercise[]): MatchResult {
  const q = normalizeExerciseName(query);
  const scored = library
    .map((e) => ({ e, score: similarity(q, normalizeExerciseName(e.name)) }))
    .sort((a, b) => b.score - a.score || a.e.name.length - b.e.name.length);

  const best = scored[0];
  if (best && best.score >= THRESHOLD) {
    return { matched: best.e, score: best.score, suggestions: [] };
  }
  return {
    matched: null,
    score: best?.score ?? 0,
    suggestions: scored.slice(0, 5).map((s) => s.e.name),
  };
}
