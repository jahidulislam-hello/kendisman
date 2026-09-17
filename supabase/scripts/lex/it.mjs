// Italian lexicon pack for the exercise-name generator.
// Italian gym terminology (panca piana, stacco da terra, rematore, alzate
// laterali, lat machine, croci, curl bicipiti, estensioni tricipiti).

const EQUIP = {
  barbell: ' con bilanciere',
  dumbbell: ' con manubri',
  cable: ' ai cavi',
  lever: ' alla macchina',
  smith: ' al multipower',
  ez: ' con bilanciere EZ',
  sled: ' alla macchina',
  machine: ' alla macchina',
  bodyweight: '',
};
const MACHINE_SELF = /(leg press|leg extension|leg curl|pectoral machine|lat machine|chest press)/i;

const HEADS = {
  'bicep curl': { it: 'curl bicipiti', g: 'm', n: 's' },
  'biceps curl': { it: 'curl bicipiti', g: 'm', n: 's' },
  'bicep curls': { it: 'curl bicipiti', g: 'm', n: 's' },
  'biceps curls': { it: 'curl bicipiti', g: 'm', n: 's' },
  'inner biceps curl': { it: 'curl di concentrazione', g: 'm', n: 's' },
  'inner curl': { it: 'curl di concentrazione', g: 'm', n: 's' },
  'hammer curl': { it: 'curl a martello', g: 'm', n: 's' },
  'concentration curl': { it: 'curl di concentrazione', g: 'm', n: 's' },
  'preacher curl': { it: 'curl alla panca Scott', g: 'm', n: 's' },
  'reverse preacher curl': { it: 'curl alla panca Scott inverso', g: 'm', n: 's' },
  'drag curl': { it: 'drag curl', g: 'm', n: 's' },
  'reverse curl': { it: 'curl inverso', g: 'm', n: 's' },
  'wrist curl': { it: 'curl ai polsi', g: 'm', n: 's' },
  'reverse wrist curl': { it: 'curl ai polsi inverso', g: 'm', n: 's' },
  'finger curl': { it: 'curl delle dita', g: 'm', n: 's' },
  'finger curls': { it: 'curl delle dita', g: 'm', n: 's' },
  'zottman curl': { it: 'curl Zottman', g: 'm', n: 's' },
  'high curl': { it: 'curl alto', g: 'm', n: 's' },
  'curl': { it: 'curl', g: 'm', n: 's' },
  'curls': { it: 'curl', g: 'm', n: 's' },
  'bench press': { it: 'panca piana', g: 'f', n: 's' },
  'incline bench press': { it: 'panca inclinata', g: 'f', n: 's' },
  'decline bench press': { it: 'panca declinata', g: 'f', n: 's' },
  'chest press': { it: 'chest press', g: 'f', n: 's' },
  'inner chest press': { it: 'chest press interna', g: 'f', n: 's' },
  'shoulder press': { it: 'lento avanti', g: 'm', n: 's' },
  'arnold press': { it: 'arnold press', g: 'm', n: 's' },
  'military press': { it: 'military press', g: 'm', n: 's' },
  'overhead press': { it: 'lento avanti', g: 'm', n: 's' },
  'skull press': { it: 'french press', g: 'f', n: 's' },
  'skullcrusher': { it: 'french press', g: 'f', n: 's' },
  'pallof press': { it: 'pallof press', g: 'm', n: 's' },
  'leg press': { it: 'leg press', g: 'f', n: 's' },
  'calf press': { it: 'calf press', g: 'm', n: 's' },
  'hammer press': { it: 'distensioni a martello', g: 'f', n: 'p' },
  'close grip press': { it: 'panca presa stretta', g: 'f', n: 's' },
  'elbow press': { it: 'distensioni gomiti', g: 'f', n: 'p' },
  'press': { it: 'distensioni', g: 'f', n: 'p' },
  'bent over row': { it: 'rematore busto flesso', g: 'm', n: 's' },
  'upright row': { it: 'tirata al mento', g: 'f', n: 's' },
  'seated row': { it: 'pulley', g: 'm', n: 's' },
  'low seated row': { it: 'pulley basso', g: 'm', n: 's' },
  'high row': { it: 'rematore alto', g: 'm', n: 's' },
  'rear delt row': { it: 'rematore deltoidi posteriori', g: 'm', n: 's' },
  't-bar row': { it: 'rematore T-bar', g: 'm', n: 's' },
  'reverse t-bar row': { it: 'rematore T-bar inverso', g: 'm', n: 's' },
  'incline row': { it: 'rematore inclinato', g: 'm', n: 's' },
  'inverted row': { it: 'rematore inverso', g: 'm', n: 's' },
  'back row': { it: 'rematore', g: 'm', n: 's' },
  'vertical row': { it: 'tirata verticale', g: 'f', n: 's' },
  'elevated row': { it: 'rematore rialzato', g: 'm', n: 's' },
  'upper row': { it: 'rematore alto', g: 'm', n: 's' },
  'unilateral row': { it: 'rematore unilaterale', g: 'm', n: 's' },
  'row': { it: 'rematore', g: 'm', n: 's' },
  'lateral raise': { it: 'alzate laterali', g: 'f', n: 'p' },
  'rear lateral raise': { it: 'alzate laterali busto flesso', g: 'f', n: 'p' },
  'bent arm lateral raise': { it: 'alzate laterali braccio flesso', g: 'f', n: 'p' },
  'front raise': { it: 'alzate frontali', g: 'f', n: 'p' },
  'front shoulder raise': { it: 'alzate frontali', g: 'f', n: 'p' },
  'rear delt raise': { it: 'alzate posteriori', g: 'f', n: 'p' },
  'calf raise': { it: 'calf', g: 'm', n: 's' },
  'calf raises': { it: 'calf', g: 'm', n: 's' },
  'donkey calf raise': { it: 'calf donkey', g: 'm', n: 's' },
  'toe raise': { it: 'calf', g: 'm', n: 's' },
  'leg raise': { it: 'sollevamento gambe', g: 'm', n: 's' },
  'leg hip raise': { it: 'sollevamento bacino', g: 'm', n: 's' },
  'hip raise': { it: 'sollevamento bacino', g: 'm', n: 's' },
  'knee raise': { it: 'sollevamento ginocchia', g: 'm', n: 's' },
  'oblique knee raise': { it: 'sollevamento ginocchia obliquo', g: 'm', n: 's' },
  'shoulder raise': { it: 'sollevamento spalle', g: 'm', n: 's' },
  'incline raise': { it: 'alzate inclinate', g: 'f', n: 'p' },
  'alternate raise': { it: 'alzate alternate', g: 'f', n: 'p' },
  'standing leg raise': { it: 'sollevamento gamba in piedi', g: 'm', n: 's' },
  'raise': { it: 'alzate', g: 'f', n: 'p' },
  'triceps extension': { it: 'estensioni tricipiti', g: 'f', n: 'p' },
  'tricep extension': { it: 'estensioni tricipiti', g: 'f', n: 'p' },
  'leg extension': { it: 'leg extension', g: 'm', n: 's' },
  'leg curl': { it: 'leg curl', g: 'm', n: 's' },
  'hip extension': { it: 'estensione dell’anca', g: 'f', n: 's' },
  'bench extension': { it: 'estensioni alla panca', g: 'f', n: 'p' },
  'single extension': { it: 'estensione singola', g: 'f', n: 's' },
  'extension': { it: 'estensione', g: 'f', n: 's' },
  'lat pulldown': { it: 'lat machine', g: 'f', n: 's' },
  'lateral pulldown': { it: 'lat machine', g: 'f', n: 's' },
  'front lat pulldown': { it: 'lat machine avanti', g: 'f', n: 's' },
  'front pulldown': { it: 'lat machine avanti', g: 'f', n: 's' },
  'rear pulldown': { it: 'lat machine dietro', g: 'f', n: 's' },
  'straight arm pulldown': { it: 'pulldown a braccia tese', g: 'm', n: 's' },
  'underhand pulldown': { it: 'lat machine presa inversa', g: 'f', n: 's' },
  'wide pulldown': { it: 'lat machine presa larga', g: 'f', n: 's' },
  'pulldown': { it: 'lat machine', g: 'f', n: 's' },
  'triceps pushdown': { it: 'push-down', g: 'm', n: 's' },
  'tricep pushdown': { it: 'push-down', g: 'm', n: 's' },
  'side triceps pushdown': { it: 'push-down laterale', g: 'm', n: 's' },
  'pushdown': { it: 'push-down', g: 'm', n: 's' },
  'pull-up': { it: 'trazioni', g: 'f', n: 'p' },
  'pull-ups': { it: 'trazioni', g: 'f', n: 'p' },
  'chin-up': { it: 'trazioni presa inversa', g: 'f', n: 'p' },
  'chin-ups': { it: 'trazioni presa inversa', g: 'f', n: 'p' },
  'push-up': { it: 'piegamenti', g: 'm', n: 'p' },
  'push-ups': { it: 'piegamenti', g: 'm', n: 'p' },
  'pull in': { it: 'pull-in', g: 'm', n: 's' },
  'pull through': { it: 'pull through', g: 'm', n: 's' },
  'squat': { it: 'squat', g: 'm', n: 's' },
  'squats': { it: 'squat', g: 'm', n: 's' },
  'back squat': { it: 'squat', g: 'm', n: 's' },
  'front squat': { it: 'front squat', g: 'm', n: 's' },
  'front chest squat': { it: 'front squat', g: 'm', n: 's' },
  'bench squat': { it: 'squat alla panca', g: 'm', n: 's' },
  'bench front squat': { it: 'front squat alla panca', g: 'm', n: 's' },
  'hack squat': { it: 'hack squat', g: 'm', n: 's' },
  'split squat': { it: 'split squat', g: 'm', n: 's' },
  'split squats': { it: 'split squat', g: 'm', n: 's' },
  'side split squat': { it: 'split squat laterale', g: 'm', n: 's' },
  'zercher squat': { it: 'zercher squat', g: 'm', n: 's' },
  'pistol squat': { it: 'pistol squat', g: 'm', n: 's' },
  'goblet squat': { it: 'goblet squat', g: 'm', n: 's' },
  'chair squat': { it: 'squat alla sedia', g: 'm', n: 's' },
  'sit squat': { it: 'squat', g: 'm', n: 's' },
  'wide squat': { it: 'squat gambe larghe', g: 'm', n: 's' },
  'one leg squat': { it: 'squat su una gamba', g: 'm', n: 's' },
  'olympic squat': { it: 'squat olimpico', g: 'm', n: 's' },
  'full squat': { it: 'squat completo', g: 'm', n: 's' },
  'quarter squat': { it: 'quarto di squat', g: 'm', n: 's' },
  'high bar squat': { it: 'squat high bar', g: 'm', n: 's' },
  'low bar squat': { it: 'squat low bar', g: 'm', n: 's' },
  'frankenstein squat': { it: 'squat Frankenstein', g: 'm', n: 's' },
  'deadlift': { it: 'stacco da terra', g: 'm', n: 's' },
  'conventional deadlift': { it: 'stacco da terra convenzionale', g: 'm', n: 's' },
  'romanian deadlift': { it: 'stacco rumeno', g: 'm', n: 's' },
  'sumo deadlift': { it: 'stacco sumo', g: 'm', n: 's' },
  'stiff leg deadlift': { it: 'stacco a gambe tese', g: 'm', n: 's' },
  'stiff legged deadlift': { it: 'stacco a gambe tese', g: 'm', n: 's' },
  'straight leg deadlift': { it: 'stacco a gambe tese', g: 'm', n: 's' },
  'fly': { it: 'croci', g: 'f', n: 'p' },
  'reverse fly': { it: 'croci inverse', g: 'f', n: 'p' },
  'pec deck fly': { it: 'pectoral machine', g: 'f', n: 's' },
  'crossover variation': { it: 'croci ai cavi', g: 'f', n: 'p' },
  'crossovers': { it: 'croci ai cavi', g: 'f', n: 'p' },
  'crunch': { it: 'crunch', g: 'm', n: 's' },
  'reverse crunch': { it: 'crunch inverso', g: 'm', n: 's' },
  'tuck reverse crunch': { it: 'crunch inverso raccolto', g: 'm', n: 's' },
  'tuck crunch': { it: 'crunch raccolto', g: 'm', n: 's' },
  'cross body crunch': { it: 'crunch incrociato', g: 'm', n: 's' },
  'sit-up': { it: 'sit-up', g: 'm', n: 's' },
  'situp': { it: 'sit-up', g: 'm', n: 's' },
  'twisting sit-up': { it: 'sit-up con torsione', g: 'm', n: 's' },
  'twisting situp': { it: 'sit-up con torsione', g: 'm', n: 's' },
  'jackknife sit-up': { it: 'jackknife', g: 'm', n: 's' },
  'side bend': { it: 'flessioni laterali', g: 'f', n: 'p' },
  'side bent': { it: 'flessioni laterali', g: 'f', n: 'p' },
  'twist': { it: 'torsione del busto', g: 'f', n: 's' },
  'seated twist': { it: 'torsione del busto seduto', g: 'f', n: 's' },
  'standing twist': { it: 'torsione del busto in piedi', g: 'f', n: 's' },
  'spine twist': { it: 'torsione della colonna', g: 'f', n: 's' },
  'russian twist': { it: 'russian twist', g: 'm', n: 's' },
  'plank': { it: 'plank', g: 'm', n: 's' },
  'front plank': { it: 'plank', g: 'm', n: 's' },
  'side plank': { it: 'plank laterale', g: 'm', n: 's' },
  'flutter kicks': { it: 'flutter kick', g: 'm', n: 's' },
  'cocoons': { it: 'cocoon', g: 'm', n: 's' },
  'butt ups': { it: 'sollevamento bacino', g: 'm', n: 's' },
  'elbow to knee': { it: 'gomito al ginocchio', g: 'm', n: 's' },
  'hip thrust': { it: 'hip thrust', g: 'm', n: 's' },
  'hip thrusts': { it: 'hip thrust', g: 'm', n: 's' },
  'hyperextension': { it: 'iperestensione', g: 'f', n: 's' },
  'shrug': { it: 'scrollate', g: 'f', n: 'p' },
  'gripless shrug': { it: 'scrollate senza presa', g: 'f', n: 'p' },
  'pullover': { it: 'pullover', g: 'm', n: 's' },
  'bent arm pullover': { it: 'pullover braccia flesse', g: 'm', n: 's' },
  'extension pullover': { it: 'pullover con estensione', g: 'm', n: 's' },
  'kickback': { it: 'kickback tricipiti', g: 'm', n: 's' },
  'tricep kickback': { it: 'kickback tricipiti', g: 'm', n: 's' },
  'good morning': { it: 'good morning', g: 'm', n: 's' },
  'step-up': { it: 'step-up', g: 'm', n: 's' },
  'lunge': { it: 'affondo', g: 'm', n: 's' },
  'rear lunge': { it: 'affondo indietro', g: 'm', n: 's' },
  'dip': { it: 'dip', g: 'm', n: 's' },
  'chest dip': { it: 'dip pettorali', g: 'm', n: 's' },
  'triceps dip': { it: 'dip tricipiti', g: 'm', n: 's' },
  'tricep dip': { it: 'dip tricipiti', g: 'm', n: 's' },
  'triceps dips': { it: 'dip tricipiti', g: 'm', n: 's' },
  'seated dip': { it: 'dip seduto', g: 'm', n: 's' },
  'hip adduction': { it: 'adduzione dell’anca', g: 'f', n: 's' },
  'hip abduction': { it: 'abduzione dell’anca', g: 'f', n: 's' },
  'shoulder internal rotation': { it: 'rotazione interna spalla', g: 'f', n: 's' },
  'shoulder external rotation': { it: 'rotazione esterna spalla', g: 'f', n: 's' },
  'internal rotation': { it: 'rotazione interna', g: 'f', n: 's' },
  'external rotation': { it: 'rotazione esterna', g: 'f', n: 's' },
  'rear kick': { it: 'calcio all’indietro', g: 'm', n: 's' },
  'rotary calf': { it: 'calf rotatorio', g: 'm', n: 's' },
};

const A = (ms, fs, mp, fp) => ({ type: 'adj', f: { ms, fs, mp, fp } });
const P = (it) => ({ type: 'phrase', it });
const MODS = {
  'incline': A('inclinato', 'inclinata', 'inclinati', 'inclinate'),
  'decline': A('declinato', 'declinata', 'declinati', 'declinate'),
  'seated': P('seduto'), 'lying': P('sdraiato'), 'supine': P('supino'),
  'kneeling': P('in ginocchio'), 'standing': P('in piedi'), 'bent over': P('busto flesso'),
  'reverse': A('inverso', 'inversa', 'inversi', 'inverse'),
  'inverted': A('inverso', 'inversa', 'inversi', 'inverse'),
  'inverse': A('inverso', 'inversa', 'inversi', 'inverse'),
  'front': P('avanti'), 'rear': A('posteriore', 'posteriore', 'posteriori', 'posteriori'),
  'side': A('laterale', 'laterale', 'laterali', 'laterali'),
  'wide': A('largo', 'larga', 'larghi', 'larghe'),
  'narrow': A('stretto', 'stretta', 'stretti', 'strette'),
  'alternate': A('alternato', 'alternata', 'alternati', 'alternate'),
  'alternating': A('alternato', 'alternata', 'alternati', 'alternate'),
  'straight': A('teso', 'tesa', 'tesi', 'tese'),
  'high': A('alto', 'alta', 'alti', 'alte'),
  'low': A('basso', 'bassa', 'bassi', 'basse'),
  'middle': A('centrale', 'centrale', 'centrali', 'centrali'),
  'inner': A('interno', 'interna', 'interni', 'interne'),
  'outer': A('esterno', 'esterna', 'esterni', 'esterne'),
  'upper': A('superiore', 'superiore', 'superiori', 'superiori'),
  'full': A('completo', 'completa', 'completi', 'complete'),
  'olympic': A('olimpico', 'olimpica', 'olimpici', 'olimpiche'),
  'elevated': A('rialzato', 'rialzata', 'rialzati', 'rialzate'),
  'vertical': A('verticale', 'verticale', 'verticali', 'verticali'),
  'horizontal': A('orizzontale', 'orizzontale', 'orizzontali', 'orizzontali'),
  'cross body': P('incrociato'), 'crossover': P('incrociato'),
  'parallel': A('parallelo', 'parallela', 'paralleli', 'parallele'),
  'hammer': P('presa a martello'), 'hammer grip': P('presa a martello'),
  'close grip': P('presa stretta'), 'wide grip': P('presa larga'),
  'reverse grip': P('presa inversa'), 'neutral grip': P('presa neutra'),
  'narrow grip': P('presa stretta'), 'parallel grip': P('presa parallela'),
  'supinated grip': P('presa supina'), 'pronated grip': P('presa prona'),
  'clean grip': P('presa da clean'), 'shoulder grip': P('presa alle spalle'),
  'overhand': P('presa prona'), 'underhand': P('presa supina'),
  'one arm': P('un braccio'), 'one-arm': P('un braccio'), 'single arm': P('un braccio'),
  'two arm': P('due braccia'), 'single leg': P('una gamba'), 'one leg': P('una gamba'),
  'behind neck': P('dietro la nuca'), 'behind head': P('dietro la nuca'),
  'behind back': P('dietro la schiena'), 'behind the head': P('dietro la nuca'),
  'back of the head': P('dietro la nuca'), 'overhead': P('sopra la testa'),
  'straight leg': P('gamba tesa'), 'straight arm': P('braccia tese'), 'stiff leg': P('gambe tese'),
  'palms up': P('palmi in alto'), 'palms in': P('palmi affacciati'),
  'palm rotational': P('con rotazione del polso'),
  'floor': P('a terra'), 'over bench': P('sulla panca'), 'high pulley': P('al cavo alto'),
  'forward angled': P('inclinato in avanti'), 'wide stance': P('gambe larghe'),
  'narrow stance': P('gambe strette'), 'rope': P('alla corda'),
  '45°': P('45°'), '30°': P('30°'), '3/4': P('3/4'),
  'to': P(''), 'to skull': P(''), 'extra': P(''), 'leg': P(''),
  'bar': P('al bilanciere'), 'bench': P('alla panca'), 'wrist': P('polso'),
  'neutral': P('presa neutra'), 'preacher': P('alla panca Scott'), 'peacher': P('alla panca Scott'),
  'upright': P('in piedi'), 'hack': P('alla hack'), 'hanging': P('alla sbarra'),
  't-bar': P('T-bar'), 'machine': P('alla macchina'), 'twisting': P('con torsione'),
  'walking': P('camminato'), 'weighted': P('zavorrato'), 'pike': P('a pike'),
  'bent arm': P('braccio flesso'), 'straight back': P('schiena dritta'),
  'underhand grip': P('presa inversa'), 'twin handle': P('doppia impugnatura'),
  'wide hand': P('mani larghe'), 'bent knees': P('ginocchia flesse'),
  'and hold': P('con tenuta'), 'flat bench': P('panca piana'),
  'with support': P('con appoggio'), 'to bench': P('alla panca'),
  'on forearms': P('sugli avambracci'), 'on dip cage': P('alle parallele'),
  'on high parallel bars': P('alle parallele alte'), 'on parallel bars': P('alle parallele'),
  'on leg press': P('alla leg press'),
};

const NOEQUIP = new Set([]);

const OVERRIDES = {
  'air bike': 'air bike',
  'lying femoral': 'leg curl sdraiato',
  'lying single extension': 'estensione tricipiti sdraiato un braccio',
  'concentration extension': 'estensione di concentrazione',
  'donkey calf raise': 'calf donkey',
  'rotary calf': 'calf rotatorio',
  'gripper hands': 'allenamento della presa',
  'gripless shrug': 'scrollate senza presa',
  'rear decline bridge': 'ponte declinato',
  'reverse hyper': 'iperestensione inversa',
  'good morning': 'good morning',
  'seated good morning': 'good morning seduto',
  'stiff leg good morning': 'good morning a gambe tese',
  'russian twist': 'russian twist',
  'spine twist': 'torsione della colonna',
  'half wipers': 'tergicristallo parziale',
  'wipers': 'tergicristallo',
  'lying lifting': 'sollevamento sdraiato',
  'crossover variation': 'croci ai cavi',
  'standing up straight crossovers': 'croci ai cavi in piedi',
  'upper chest crossovers': 'croci ai cavi parte alta',
  'cross over high reverse fly': 'croci inverse alte ai cavi incrociati',
  'cross over reverse fly': 'croci inverse ai cavi incrociati',
  'cross over lateral pulldown': 'lat machine ai cavi incrociati',
  'standing cross over high reverse fly': 'croci inverse alte ai cavi incrociati in piedi',
  'standing rear kick': 'calcio all’indietro in piedi',
  'standing hip extension': 'estensione dell’anca in piedi',
  'standing leg raise': 'sollevamento gamba in piedi',
  'seated hip abduction': 'abduzione dell’anca seduto',
  'seated hip adduction': 'adduzione dell’anca seduto',
  'side hip abduction': 'abduzione dell’anca laterale',
  'side hip adduction': 'adduzione dell’anca laterale',
  'hip adduction': 'adduzione dell’anca',
  'toe raise': 'calf',
  'front raise and pullover': 'alzate frontali e pullover',
  'curl with multipurpose v bar': 'curl con barra a V',
  'crunch floor': 'crunch a terra',
  'reverse hyper on flat bench': 'iperestensione inversa sulla panca piana',
  '45° leg wide press': 'leg press a 45° gambe larghe',
  'calf press on leg press': 'calf alla leg press',
  'low bar squat with rack': 'squat low bar al rack',
  'biceps curl reverse': 'curl bicipiti inverso',
};

function paren(inner) {
  const map = {
    'male': '', 'female': '', 'back pov': '', 'front pov': '',
    'plate loaded': 'a dischi', 'bench press machine': 'macchina panca',
    'on bench': 'sulla panca', 'on flat bench': 'sulla panca piana',
    'on knee': 'al ginocchio', 'knees bent': 'ginocchia flesse',
    'bent knee': 'ginocchio flesso', 'bent leg': 'gamba flessa',
    'leg straight': 'gamba tesa', 'straight': 'teso',
    'straight leg': 'gamba tesa', 'straight arm': 'braccio teso',
    'with rope attachment': 'alla corda', 'rope attachment': 'alla corda',
    'sz bar': 'bilanciere EZ', 'v bar': 'barra a V', 'v bar attachment': 'barra a V',
    'bent bar': 'bilanciere curvo',
    'neutral grip': 'presa neutra', 'narrow parallel grip': 'presa parallela stretta',
    'clean grip': 'presa da clean',
    'on stability ball': 'sulla fitball', 'with medicine ball': 'con palla medica',
    'rack support': 'con appoggio', 'inside squat cage': 'nella gabbia',
    'on hip': 'all’anca', 'pistol': 'pistol', 'chest pad': 'con appoggio pettorale',
    'on parallel bars': 'alle parallele', 'on high parallel bars': 'alle parallele alte',
    'on dip cage': 'alle parallele', 'on pull-up cable machine': 'ai cavi',
  };
  const key = inner.toLowerCase();
  if (key in map) return map[key];
  return inner;
}

function agree(mod, head) {
  const key = (head.g === 'm' ? 'm' : 'f') + (head.n === 'p' ? 'p' : 's');
  return mod.f[key];
}

function parseMods(tokens) {
  const adjs = [], phrases = [];
  let i = 0;
  while (i < tokens.length) {
    let matched = false;
    for (let L = Math.min(4, tokens.length - i); L >= 1; L--) {
      const cand = tokens.slice(i, i + L).join(' ').toLowerCase();
      if (MODS[cand]) {
        const m = MODS[cand];
        if (m.type === 'adj') adjs.push(m);
        else if (m.it) phrases.push(m.it);
        i += L; matched = true; break;
      }
    }
    if (!matched) return null;
  }
  return { adjs, phrases };
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
  const head = best.head;
  const adjs = [...lead.adjs, ...trail.adjs].map((m) => agree(m, head));
  const phrases = [...lead.phrases, ...trail.phrases];
  return [head.it, ...adjs, ...phrases].join(' ');
}

function render(core, equip) {
  const k = core.toLowerCase();
  let phrase, noEquip = false;
  if (k in OVERRIDES) { phrase = OVERRIDES[k]; noEquip = NOEQUIP.has(k); }
  else { phrase = translateCore(core); if (phrase == null) return null; }
  if (equip && EQUIP[equip] && !noEquip) {
    let suf = EQUIP[equip];
    if (equip === 'cable' && /cavi|lat machine|pulley/.test(phrase)) suf = '';
    else if ((equip === 'lever' || equip === 'machine' || equip === 'sled') && MACHINE_SELF.test(phrase)) suf = '';
    phrase += suf;
  }
  return phrase;
}

export function IT(makeComposer) {
  const pack = { versionWord: 'variante ', paren, render };
  return { ...pack, translate: makeComposer(pack) };
}
