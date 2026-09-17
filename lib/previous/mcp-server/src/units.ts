// Unit conversion + explicit labelling, ported from the app's lib/units.ts so the
// MCP output matches what the user sees in-app. Storage is canonical: weights in
// lb, circumferences in cm. Per the app's convention, the length unit is paired
// to the weight unit — kg users see cm, lb users see inches.

export type UnitPreference = 'lb' | 'kg';

const LB_PER_KG = 2.20462262;
const CM_PER_INCH = 2.54;

function round1(n: number): number {
  return Math.round(n * 10) / 10;
}

/** Canonical lb -> the user's weight unit, rounded to 1 decimal. */
export function weightInUnit(weightLb: number, unit: UnitPreference): number {
  return round1(unit === 'kg' ? weightLb / LB_PER_KG : weightLb);
}

export function weightUnitLabel(unit: UnitPreference): 'lb' | 'kg' {
  return unit;
}

/** kg users see cm, lb users see inches. */
export function lengthUnitLabel(unit: UnitPreference): 'cm' | 'in' {
  return unit === 'kg' ? 'cm' : 'in';
}

/** Canonical cm -> the user's length unit, rounded to 1 decimal. */
export function lengthInUnit(cm: number, unit: UnitPreference): number {
  return round1(unit === 'kg' ? cm : cm / CM_PER_INCH);
}

export function isUnitPreference(v: unknown): v is UnitPreference {
  return v === 'lb' || v === 'kg';
}
