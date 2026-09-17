// German lexicon pack for the exercise-name generator.
// German gym terminology (Bankdrücken, Kniebeuge, Kreuzheben, Latzug, Rudern,
// Seitheben, Bizepscurl, Trizepsdrücken). Modifiers are used adverbially and
// stay invariant, so no gender agreement is needed -- every MOD is a phrase.

const EQUIP = {
  barbell: ' mit Langhantel',
  dumbbell: ' mit Kurzhanteln',
  cable: ' am Kabel',
  lever: ' an der Maschine',
  smith: ' an der Multipresse',
  ez: ' mit SZ-Stange',
  sled: ' an der Maschine',
  machine: ' an der Maschine',
  bodyweight: '',
};
// Machine self-names: don't append " an der Maschine" when the movement name
// already is the machine (Beinstrecker, Beinpresse, Beinbeuger, Butterfly...).
const MACHINE_SELF = /(Beinstrecker|Beinbeuger|Beinpresse|Wadenpresse|Butterfly|Brustpresse|Hackenschmidt)/i;

const H = (de) => ({ de });
const HEADS = {
  'bicep curl': H('Bizepscurl'), 'biceps curl': H('Bizepscurl'),
  'bicep curls': H('Bizepscurl'), 'biceps curls': H('Bizepscurl'),
  'inner biceps curl': H('Konzentrationscurl'), 'inner curl': H('Konzentrationscurl'),
  'hammer curl': H('Hammercurl'),
  'concentration curl': H('Konzentrationscurl'),
  'preacher curl': H('Scott-Curl'),
  'reverse preacher curl': H('Scott-Curl im Untergriff'),
  'drag curl': H('Drag Curl'),
  'reverse curl': H('Reverse-Curl'),
  'wrist curl': H('Handgelenkcurl'),
  'reverse wrist curl': H('Handgelenkcurl umgekehrt'),
  'finger curl': H('Fingercurl'), 'finger curls': H('Fingercurl'),
  'zottman curl': H('Zottman-Curl'),
  'high curl': H('High Curl'),
  'curl': H('Curl'), 'curls': H('Curl'),
  'bench press': H('Bankdrücken'),
  'incline bench press': H('Schrägbankdrücken'),
  'decline bench press': H('Negativ-Bankdrücken'),
  'chest press': H('Brustpresse'),
  'inner chest press': H('Brustpresse innen'),
  'shoulder press': H('Schulterdrücken'),
  'arnold press': H('Arnold Press'),
  'military press': H('Military Press'),
  'overhead press': H('Schulterdrücken'),
  'skull press': H('Stirndrücken'), 'skullcrusher': H('Stirndrücken'),
  'pallof press': H('Pallof Press'),
  'leg press': H('Beinpresse'),
  'calf press': H('Wadenpresse'),
  'hammer press': H('Hammerdrücken'),
  'close grip press': H('enges Bankdrücken'),
  'elbow press': H('Ellbogendrücken'),
  'press': H('Drücken'),
  'bent over row': H('vorgebeugtes Rudern'),
  'upright row': H('aufrechtes Rudern'),
  'seated row': H('Rudern sitzend'),
  'low seated row': H('tiefes Rudern sitzend'),
  'high row': H('hohes Rudern'),
  'rear delt row': H('Rudern für hintere Schulter'),
  't-bar row': H('T-Bar-Rudern'),
  'reverse t-bar row': H('T-Bar-Rudern umgekehrt'),
  'incline row': H('Rudern schräg'),
  'inverted row': H('umgekehrtes Rudern'),
  'back row': H('Rudern'),
  'vertical row': H('vertikales Rudern'),
  'elevated row': H('erhöhtes Rudern'),
  'upper row': H('hohes Rudern'),
  'unilateral row': H('einarmiges Rudern'),
  'row': H('Rudern'),
  'lateral raise': H('Seitheben'),
  'rear lateral raise': H('Seitheben vorgebeugt'),
  'bent arm lateral raise': H('Seitheben mit gebeugtem Arm'),
  'front raise': H('Frontheben'),
  'front shoulder raise': H('Frontheben'),
  'rear delt raise': H('Reverse Butterfly'),
  'calf raise': H('Wadenheben'), 'calf raises': H('Wadenheben'),
  'donkey calf raise': H('Donkey-Wadenheben'),
  'toe raise': H('Zehenheben'),
  'leg raise': H('Beinheben'),
  'leg hip raise': H('Beckenheben'),
  'hip raise': H('Beckenheben'),
  'knee raise': H('Knieheben'),
  'oblique knee raise': H('seitliches Knieheben'),
  'shoulder raise': H('Schulterheben'),
  'incline raise': H('Heben schräg'),
  'alternate raise': H('wechselndes Heben'),
  'standing leg raise': H('Beinheben stehend'),
  'raise': H('Heben'),
  'triceps extension': H('Trizepsstrecken'), 'tricep extension': H('Trizepsstrecken'),
  'hip extension': H('Hüftstrecken'),
  'bench extension': H('Strecken auf der Bank'),
  'single extension': H('einarmiges Strecken'),
  'extension': H('Strecken'),
  'lat pulldown': H('Latzug'), 'lateral pulldown': H('Latzug'),
  'front lat pulldown': H('Latzug zur Brust'), 'front pulldown': H('Latzug zur Brust'),
  'rear pulldown': H('Nackenziehen'),
  'straight arm pulldown': H('Latzug mit gestreckten Armen'),
  'underhand pulldown': H('Latzug im Untergriff'),
  'wide pulldown': H('Latzug breit'),
  'pulldown': H('Latzug'),
  'triceps pushdown': H('Trizepsdrücken'), 'tricep pushdown': H('Trizepsdrücken'),
  'side triceps pushdown': H('seitliches Trizepsdrücken'),
  'pushdown': H('Trizepsdrücken'),
  'pull-up': H('Klimmzug'), 'pull-ups': H('Klimmzug'),
  'chin-up': H('Klimmzug im Untergriff'), 'chin-ups': H('Klimmzug im Untergriff'),
  'push-up': H('Liegestütz'), 'push-ups': H('Liegestütz'),
  'pull in': H('Pull-in'), 'pull through': H('Pull Through'),
  'squat': H('Kniebeuge'), 'squats': H('Kniebeuge'),
  'back squat': H('Kniebeuge'),
  'front squat': H('Frontkniebeuge'), 'front chest squat': H('Frontkniebeuge'),
  'bench squat': H('Kniebeuge zur Bank'), 'bench front squat': H('Frontkniebeuge zur Bank'),
  'hack squat': H('Hack-Kniebeuge'),
  'split squat': H('Split-Kniebeuge'), 'split squats': H('Split-Kniebeuge'),
  'side split squat': H('seitliche Split-Kniebeuge'),
  'zercher squat': H('Zercher-Kniebeuge'),
  'pistol squat': H('Pistol Squat'),
  'goblet squat': H('Goblet-Kniebeuge'),
  'chair squat': H('Kniebeuge auf Stuhl'),
  'sit squat': H('Kniebeuge'),
  'wide squat': H('breite Kniebeuge'),
  'one leg squat': H('einbeinige Kniebeuge'),
  'olympic squat': H('olympische Kniebeuge'),
  'full squat': H('tiefe Kniebeuge'),
  'quarter squat': H('Viertelkniebeuge'),
  'high bar squat': H('High-Bar-Kniebeuge'),
  'low bar squat': H('Low-Bar-Kniebeuge'),
  'frankenstein squat': H('Frankenstein-Kniebeuge'),
  'deadlift': H('Kreuzheben'),
  'conventional deadlift': H('konventionelles Kreuzheben'),
  'romanian deadlift': H('rumänisches Kreuzheben'),
  'sumo deadlift': H('Sumo-Kreuzheben'),
  'stiff leg deadlift': H('gestrecktes Kreuzheben'),
  'stiff legged deadlift': H('gestrecktes Kreuzheben'),
  'straight leg deadlift': H('gestrecktes Kreuzheben'),
  'fly': H('Fliegende'),
  'reverse fly': H('Reverse Fliegende'),
  'pec deck fly': H('Butterfly'),
  'crossover variation': H('Cable Crossover'),
  'crossovers': H('Cable Crossover'),
  'crunch': H('Crunch'),
  'reverse crunch': H('umgekehrter Crunch'),
  'tuck reverse crunch': H('umgekehrter Crunch angehockt'),
  'tuck crunch': H('Crunch angehockt'),
  'cross body crunch': H('Cross-Body-Crunch'),
  'sit-up': H('Sit-up'), 'situp': H('Sit-up'),
  'twisting sit-up': H('Sit-up mit Drehung'), 'twisting situp': H('Sit-up mit Drehung'),
  'jackknife sit-up': H('Klappmesser'),
  'side bend': H('Seitbeuge'), 'side bent': H('Seitbeuge'),
  'twist': H('Rumpfdrehung'),
  'seated twist': H('Rumpfdrehung sitzend'),
  'standing twist': H('Rumpfdrehung stehend'),
  'spine twist': H('Wirbelsäulendrehung'),
  'russian twist': H('Russian Twist'),
  'plank': H('Plank'),
  'front plank': H('Unterarmstütz'),
  'side plank': H('seitlicher Unterarmstütz'),
  'flutter kicks': H('Flutter Kicks'),
  'cocoons': H('Cocoons'),
  'butt ups': H('Beckenheben'),
  'elbow to knee': H('Ellbogen zum Knie'),
  'hip thrust': H('Hip Thrust'), 'hip thrusts': H('Hip Thrust'),
  'hyperextension': H('Hyperextension'),
  'shrug': H('Nackenheben'),
  'gripless shrug': H('Nackenheben ohne Griff'),
  'pullover': H('Überzüge'),
  'bent arm pullover': H('Überzüge mit gebeugten Armen'),
  'extension pullover': H('Überzüge mit Strecken'),
  'kickback': H('Trizepskickback'),
  'tricep kickback': H('Trizepskickback'),
  'good morning': H('Good Morning'),
  'step-up': H('Step-up'),
  'lunge': H('Ausfallschritt'),
  'rear lunge': H('Ausfallschritt rückwärts'),
  'dip': H('Dip'),
  'chest dip': H('Brust-Dip'),
  'triceps dip': H('Trizeps-Dip'), 'tricep dip': H('Trizeps-Dip'), 'triceps dips': H('Trizeps-Dip'),
  'seated dip': H('Dip sitzend'),
  'hip adduction': H('Hüftadduktion'),
  'hip abduction': H('Hüftabduktion'),
  'shoulder internal rotation': H('Innenrotation der Schulter'),
  'shoulder external rotation': H('Außenrotation der Schulter'),
  'internal rotation': H('Innenrotation'),
  'external rotation': H('Außenrotation'),
  'rear kick': H('Beinkick rückwärts'),
  'rotary calf': H('Wadenheben rotierend'),
};

const P = (de) => ({ type: 'phrase', de });
const MODS = {
  'incline': P('schräg'), 'decline': P('negativ'),
  'seated': P('sitzend'), 'lying': P('liegend'), 'supine': P('liegend'),
  'kneeling': P('kniend'), 'standing': P('stehend'), 'bent over': P('vorgebeugt'),
  'reverse': P('umgekehrt'), 'inverted': P('umgekehrt'),
  'front': P('vorne'), 'rear': P('hintere'), 'side': P('seitlich'),
  'wide': P('breit'), 'narrow': P('eng'),
  'alternate': P('wechselnd'), 'alternating': P('wechselnd'),
  'straight': P('gestreckt'), 'high': P('hoch'), 'low': P('tief'),
  'middle': P('mittig'), 'inner': P('innen'), 'outer': P('außen'),
  'upper': P('oberer'), 'full': P('tief'), 'olympic': P('olympisch'),
  'elevated': P('erhöht'), 'vertical': P('vertikal'), 'horizontal': P('horizontal'),
  'cross body': P('über Kreuz'), 'crossover': P('über Kreuz'), 'parallel': P('parallel'),
  'hammer': P('Hammergriff'), 'hammer grip': P('im Hammergriff'),
  'close grip': P('im engen Griff'), 'wide grip': P('im weiten Griff'),
  'reverse grip': P('im Untergriff'), 'neutral grip': P('im neutralen Griff'),
  'narrow grip': P('im engen Griff'), 'parallel grip': P('im parallelen Griff'),
  'supinated grip': P('im Untergriff'), 'pronated grip': P('im Obergriff'),
  'clean grip': P('im Clean-Griff'), 'shoulder grip': P('schulterbreit'),
  'overhand': P('im Obergriff'), 'underhand': P('im Untergriff'),
  'one arm': P('einarmig'), 'one-arm': P('einarmig'), 'single arm': P('einarmig'),
  'two arm': P('beidarmig'), 'single leg': P('einbeinig'), 'one leg': P('einbeinig'),
  'behind neck': P('im Nacken'), 'behind head': P('hinter dem Kopf'),
  'behind back': P('hinter dem Rücken'), 'behind the head': P('hinter dem Kopf'),
  'back of the head': P('hinter dem Kopf'), 'overhead': P('über Kopf'),
  'straight leg': P('mit gestrecktem Bein'), 'straight arm': P('mit gestreckten Armen'),
  'stiff leg': P('mit gestreckten Beinen'),
  'palms up': P('Handflächen nach oben'), 'palms in': P('Handflächen zueinander'),
  'palm rotational': P('mit Handgelenkdrehung'),
  'floor': P('am Boden'), 'over bench': P('über der Bank'),
  'high pulley': P('am oberen Kabel'), 'forward angled': P('nach vorn geneigt'),
  'wide stance': P('breiter Stand'), 'narrow stance': P('enger Stand'),
  'rope': P('mit Seil'), '45°': P('45°'), '30°': P('30°'), '3/4': P('3/4'),
  'to': P(''), 'to skull': P(''), 'extra': P(''), 'leg': P(''),
  'bar': P('mit Stange'), 'bench': P('auf der Bank'), 'wrist': P('Handgelenk'),
  'neutral': P('im neutralen Griff'), 'preacher': P('am Scott-Pult'), 'peacher': P('am Scott-Pult'),
  'upright': P('aufrecht'), 'hack': P('an der Hackenschmidt'), 'hanging': P('hängend'),
  't-bar': P('T-Bar'), 'machine': P('an der Maschine'), 'twisting': P('mit Drehung'),
  'walking': P('gehend'), 'weighted': P('mit Gewicht'), 'pike': P('im Pike'),
  'bent arm': P('mit gebeugtem Arm'), 'straight back': P('mit geradem Rücken'),
  'underhand grip': P('im Untergriff'), 'twin handle': P('mit Doppelgriff'),
  'wide hand': P('mit weiter Handstellung'), 'bent knees': P('mit gebeugten Knien'),
  'and hold': P('mit Halten'), 'flat bench': P('auf der Flachbank'),
  'with support': P('mit Unterstützung'), 'to bench': P('zur Bank'),
  'on forearms': P('auf den Unterarmen'), 'on dip cage': P('am Dip-Ständer'),
  'on high parallel bars': P('am hohen Barren'), 'on parallel bars': P('am Barren'),
  'on leg press': P('an der Beinpresse'),
};

const NOEQUIP = new Set([
  'leg extension', 'seated leg curl', 'lying leg curl', 'standing leg curl',
  'kneeling leg curl', 'inverse leg curl', 'lying femoral',
]);

const OVERRIDES = {
  'air bike': 'Air Bike',
  'lying femoral': 'Beinbeuger liegend',
  'lying leg curl': 'Beinbeuger liegend',
  'kneeling leg curl': 'Beinbeuger kniend',
  'standing leg curl': 'Beinbeuger stehend',
  'seated leg curl': 'Beinbeuger sitzend',
  'inverse leg curl': 'umgekehrter Beinbeuger',
  'leg extension': 'Beinstrecker',
  'lying single extension': 'Trizepsstrecken liegend einarmig',
  'concentration extension': 'Konzentrationsstrecken',
  'donkey calf raise': 'Donkey-Wadenheben',
  'rotary calf': 'Wadenheben rotierend',
  'gripper hands': 'Grifftraining',
  'gripless shrug': 'Nackenheben ohne Griff',
  'rear decline bridge': 'Brücke negativ',
  'reverse hyper': 'Reverse Hyperextension',
  'good morning': 'Good Morning',
  'seated good morning': 'Good Morning sitzend',
  'stiff leg good morning': 'Good Morning mit gestreckten Beinen',
  'russian twist': 'Russian Twist',
  'spine twist': 'Wirbelsäulendrehung',
  'half wipers': 'Scheibenwischer halb',
  'wipers': 'Scheibenwischer',
  'lying lifting': 'Heben liegend',
  'crossover variation': 'Cable Crossover',
  'standing up straight crossovers': 'Cable Crossover stehend',
  'upper chest crossovers': 'Cable Crossover für obere Brust',
  'cross over high reverse fly': 'Reverse Fliegende hoch über Kreuz',
  'cross over reverse fly': 'Reverse Fliegende über Kreuz',
  'cross over lateral pulldown': 'Latzug über Kreuz',
  'standing cross over high reverse fly': 'Reverse Fliegende hoch über Kreuz stehend',
  'standing rear kick': 'Beinkick rückwärts stehend',
  'standing hip extension': 'Hüftstrecken stehend',
  'standing leg raise': 'Beinheben stehend',
  'seated hip abduction': 'Hüftabduktion sitzend',
  'seated hip adduction': 'Hüftadduktion sitzend',
  'side hip abduction': 'Hüftabduktion seitlich',
  'side hip adduction': 'Hüftadduktion seitlich',
  'hip adduction': 'Hüftadduktion',
  'toe raise': 'Zehenheben',
  'front raise and pullover': 'Frontheben und Überzug',
  'curl with multipurpose v bar': 'Curl mit V-Stange',
  'crunch floor': 'Crunch am Boden',
  'reverse hyper on flat bench': 'Reverse Hyperextension auf der Flachbank',
  '45° leg wide press': 'Beinpresse 45° mit breitem Stand',
  'calf press on leg press': 'Wadenpresse an der Beinpresse',
  'low bar squat with rack': 'Low-Bar-Kniebeuge im Rack',
  'biceps curl reverse': 'umgekehrter Bizepscurl',
};

function paren(inner) {
  const map = {
    'male': '', 'female': '', 'back pov': '', 'front pov': '',
    'plate loaded': 'Steckgewichte', 'bench press machine': 'Bankdrück-Maschine',
    'on bench': 'auf der Bank', 'on flat bench': 'auf der Flachbank',
    'on knee': 'am Knie', 'knees bent': 'Knie gebeugt',
    'bent knee': 'gebeugtes Knie', 'bent leg': 'gebeugtes Bein',
    'leg straight': 'gestreckt', 'straight': 'gestreckt',
    'straight leg': 'gestrecktes Bein', 'straight arm': 'gestreckter Arm',
    'with rope attachment': 'mit Seil', 'rope attachment': 'mit Seil',
    'sz bar': 'SZ-Stange', 'v bar': 'V-Stange', 'v bar attachment': 'V-Stange',
    'bent bar': 'gebogene Stange',
    'neutral grip': 'neutraler Griff', 'narrow parallel grip': 'enger paralleler Griff',
    'clean grip': 'Clean-Griff',
    'on stability ball': 'auf dem Gymnastikball', 'with medicine ball': 'mit Medizinball',
    'rack support': 'mit Ablage', 'inside squat cage': 'im Squat-Rack',
    'on hip': 'an der Hüfte', 'pistol': 'Pistol', 'chest pad': 'mit Brustpolster',
    'on parallel bars': 'am Barren', 'on high parallel bars': 'am hohen Barren',
    'on dip cage': 'am Dip-Ständer', 'on pull-up cable machine': 'am Kabelturm',
  };
  const key = inner.toLowerCase();
  if (key in map) return map[key];
  return inner;
}

function parseMods(tokens) {
  const phrases = [];
  let i = 0;
  while (i < tokens.length) {
    let matched = false;
    for (let L = Math.min(4, tokens.length - i); L >= 1; L--) {
      const cand = tokens.slice(i, i + L).join(' ').toLowerCase();
      if (MODS[cand]) { if (MODS[cand].de) phrases.push(MODS[cand].de); i += L; matched = true; break; }
    }
    if (!matched) return null;
  }
  return phrases;
}

function translateCore(core) {
  if (!core) return null;
  const tokens = core.split(' ');
  const n = tokens.length;
  let best = null;
  for (let start = 0; start < n; start++) {
    for (let len = n - start; len >= 1; len--) {
      const cand = tokens.slice(start, start + len).join(' ').toLowerCase();
      if (HEADS[cand]) { if (!best || len > best.len) best = { start, len, head: HEADS[cand] }; break; }
    }
  }
  if (!best) return null;
  const lead = parseMods(tokens.slice(0, best.start));
  const trail = parseMods(tokens.slice(best.start + best.len));
  if (!lead || !trail) return null;
  return [best.head.de, ...lead, ...trail].join(' ');
}

function render(core, equip) {
  const k = core.toLowerCase();
  let phrase, noEquip = false;
  if (k in OVERRIDES) { phrase = OVERRIDES[k]; noEquip = NOEQUIP.has(k); }
  else { phrase = translateCore(core); if (phrase == null) return null; }
  if (equip && EQUIP[equip] && !noEquip) {
    let suf = EQUIP[equip];
    if (equip === 'cable' && /Latzug|Kabel/.test(phrase)) suf = '';
    else if ((equip === 'lever' || equip === 'machine' || equip === 'sled') && MACHINE_SELF.test(phrase)) suf = '';
    phrase += suf;
  }
  return phrase;
}

export function DE(makeComposer) {
  const pack = { versionWord: 'Variante ', paren, render };
  return { ...pack, translate: makeComposer(pack) };
}
