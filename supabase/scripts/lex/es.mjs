// Spanish lexicon pack for the exercise-name generator.
// Terminology follows Spanish lifting-community usage (press de banca, sentadilla,
// peso muerto, jalón, dominadas, curl, aperturas, prensa, etc.).

const EQUIP = {
  barbell: ' con barra',
  dumbbell: ' con mancuernas',
  cable: ' en polea',
  lever: ' en máquina',
  smith: ' en máquina Smith',
  ez: ' con barra Z',
  sled: ' en máquina',
  machine: ' en máquina',
  bodyweight: '',
};

// Movement heads: english (lowercased) -> { es, g:'m'|'f', n:'s'|'p' }.
const HEADS = {
  // curls
  'bicep curl': { es: 'curl de bíceps', g: 'm', n: 's' },
  'biceps curl': { es: 'curl de bíceps', g: 'm', n: 's' },
  'bicep curls': { es: 'curl de bíceps', g: 'm', n: 's' },
  'biceps curls': { es: 'curl de bíceps', g: 'm', n: 's' },
  'inner biceps curl': { es: 'curl de bíceps concentrado', g: 'm', n: 's' },
  'hammer curl': { es: 'curl martillo', g: 'm', n: 's' },
  'concentration curl': { es: 'curl concentrado', g: 'm', n: 's' },
  'preacher curl': { es: 'curl en banco Scott', g: 'm', n: 's' },
  'drag curl': { es: 'drag curl', g: 'm', n: 's' },
  'reverse curl': { es: 'curl invertido', g: 'm', n: 's' },
  'reverse preacher curl': { es: 'curl en banco Scott invertido', g: 'm', n: 's' },
  'wrist curl': { es: 'curl de muñeca', g: 'm', n: 's' },
  'reverse wrist curl': { es: 'curl de muñeca invertido', g: 'm', n: 's' },
  'finger curl': { es: 'curl de dedos', g: 'm', n: 's' },
  'finger curls': { es: 'curl de dedos', g: 'm', n: 's' },
  'zottman curl': { es: 'curl Zottman', g: 'm', n: 's' },
  'inner curl': { es: 'curl concentrado', g: 'm', n: 's' },
  'high curl': { es: 'curl alto', g: 'm', n: 's' },
  'curl': { es: 'curl', g: 'm', n: 's' },
  'curls': { es: 'curl', g: 'm', n: 's' },
  // presses
  'bench press': { es: 'press de banca', g: 'm', n: 's' },
  'chest press': { es: 'press de pecho', g: 'm', n: 's' },
  'inner chest press': { es: 'press de pecho interno', g: 'm', n: 's' },
  'shoulder press': { es: 'press de hombros', g: 'm', n: 's' },
  'arnold press': { es: 'press Arnold', g: 'm', n: 's' },
  'military press': { es: 'press militar', g: 'm', n: 's' },
  'overhead press': { es: 'press militar', g: 'm', n: 's' },
  'skull press': { es: 'press francés', g: 'm', n: 's' },
  'skullcrusher': { es: 'press francés', g: 'm', n: 's' },
  'pallof press': { es: 'press Pallof', g: 'm', n: 's' },
  'leg press': { es: 'prensa de piernas', g: 'f', n: 's' },
  'calf press': { es: 'prensa de gemelos', g: 'f', n: 's' },
  'hammer press': { es: 'press agarre martillo', g: 'm', n: 's' },
  'elbow press': { es: 'press de codos', g: 'm', n: 's' },
  'close grip press': { es: 'press con agarre cerrado', g: 'm', n: 's' },
  'press': { es: 'press', g: 'm', n: 's' },
  // rows
  'bent over row': { es: 'remo inclinado', g: 'm', n: 's' },
  'upright row': { es: 'remo al mentón', g: 'm', n: 's' },
  'seated row': { es: 'remo sentado', g: 'm', n: 's' },
  'high row': { es: 'remo alto', g: 'm', n: 's' },
  'low seated row': { es: 'remo sentado bajo', g: 'm', n: 's' },
  'rear delt row': { es: 'remo para deltoides posterior', g: 'm', n: 's' },
  't-bar row': { es: 'remo en T', g: 'm', n: 's' },
  'reverse t-bar row': { es: 'remo en T invertido', g: 'm', n: 's' },
  'incline row': { es: 'remo inclinado', g: 'm', n: 's' },
  'inverted row': { es: 'remo invertido', g: 'm', n: 's' },
  'back row': { es: 'remo', g: 'm', n: 's' },
  'vertical row': { es: 'remo vertical', g: 'm', n: 's' },
  'elevated row': { es: 'remo elevado', g: 'm', n: 's' },
  'upper row': { es: 'remo alto', g: 'm', n: 's' },
  'unilateral row': { es: 'remo unilateral', g: 'm', n: 's' },
  'row': { es: 'remo', g: 'm', n: 's' },
  // raises
  'lateral raise': { es: 'elevación lateral', g: 'f', n: 's' },
  'rear lateral raise': { es: 'elevación lateral posterior', g: 'f', n: 's' },
  'bent arm lateral raise': { es: 'elevación lateral con brazo flexionado', g: 'f', n: 's' },
  'front raise': { es: 'elevación frontal', g: 'f', n: 's' },
  'front shoulder raise': { es: 'elevación frontal de hombros', g: 'f', n: 's' },
  'rear delt raise': { es: 'elevación de deltoides posterior', g: 'f', n: 's' },
  'calf raise': { es: 'elevación de gemelos', g: 'f', n: 's' },
  'calf raises': { es: 'elevación de gemelos', g: 'f', n: 's' },
  'donkey calf raise': { es: 'elevación de gemelos tipo burro', g: 'f', n: 's' },
  'toe raise': { es: 'elevación de gemelos', g: 'f', n: 's' },
  'leg raise': { es: 'elevación de piernas', g: 'f', n: 's' },
  'leg hip raise': { es: 'elevación de cadera', g: 'f', n: 's' },
  'hip raise': { es: 'elevación de cadera', g: 'f', n: 's' },
  'knee raise': { es: 'elevación de rodillas', g: 'f', n: 's' },
  'oblique knee raise': { es: 'elevación de rodillas oblicua', g: 'f', n: 's' },
  'shoulder raise': { es: 'elevación de hombros', g: 'f', n: 's' },
  'incline raise': { es: 'elevación inclinada', g: 'f', n: 's' },
  'alternate raise': { es: 'elevación alterna', g: 'f', n: 's' },
  'standing leg raise': { es: 'elevación de pierna de pie', g: 'f', n: 's' },
  'raise': { es: 'elevación', g: 'f', n: 's' },
  // extensions
  'triceps extension': { es: 'extensión de tríceps', g: 'f', n: 's' },
  'tricep extension': { es: 'extensión de tríceps', g: 'f', n: 's' },
  'leg extension': { es: 'extensión de cuádriceps', g: 'f', n: 's' },
  'hip extension': { es: 'extensión de cadera', g: 'f', n: 's' },
  'bench extension': { es: 'extensión en banco', g: 'f', n: 's' },
  'single extension': { es: 'extensión a un brazo', g: 'f', n: 's' },
  'extension': { es: 'extensión', g: 'f', n: 's' },
  // pulldowns / pull
  'lat pulldown': { es: 'jalón al pecho', g: 'm', n: 's' },
  'lateral pulldown': { es: 'jalón al pecho', g: 'm', n: 's' },
  'front lat pulldown': { es: 'jalón al pecho', g: 'm', n: 's' },
  'front pulldown': { es: 'jalón al pecho', g: 'm', n: 's' },
  'rear pulldown': { es: 'jalón tras nuca', g: 'm', n: 's' },
  'straight arm pulldown': { es: 'jalón con brazos rectos', g: 'm', n: 's' },
  'underhand pulldown': { es: 'jalón con agarre supino', g: 'm', n: 's' },
  'wide pulldown': { es: 'jalón con agarre ancho', g: 'm', n: 's' },
  'pulldown': { es: 'jalón', g: 'm', n: 's' },
  // pushdowns
  'triceps pushdown': { es: 'extensión de tríceps', g: 'f', n: 's' },
  'tricep pushdown': { es: 'extensión de tríceps', g: 'f', n: 's' },
  'side triceps pushdown': { es: 'extensión de tríceps lateral', g: 'f', n: 's' },
  'pushdown': { es: 'extensión de tríceps', g: 'f', n: 's' },
  // bodyweight
  'pull-up': { es: 'dominada', g: 'f', n: 's' },
  'pull-ups': { es: 'dominada', g: 'f', n: 's' },
  'chin-up': { es: 'dominada supina', g: 'f', n: 's' },
  'chin-ups': { es: 'dominada supina', g: 'f', n: 's' },
  'push-up': { es: 'flexión', g: 'f', n: 's' },
  'push-ups': { es: 'flexión', g: 'f', n: 's' },
  'pull in': { es: 'pull-in', g: 'm', n: 's' },
  'pull through': { es: 'pull through', g: 'm', n: 's' },
  // squats
  'squat': { es: 'sentadilla', g: 'f', n: 's' },
  'squats': { es: 'sentadilla', g: 'f', n: 's' },
  'back squat': { es: 'sentadilla trasera', g: 'f', n: 's' },
  'front squat': { es: 'sentadilla frontal', g: 'f', n: 's' },
  'front chest squat': { es: 'sentadilla frontal', g: 'f', n: 's' },
  'bench squat': { es: 'sentadilla al cajón', g: 'f', n: 's' },
  'bench front squat': { es: 'sentadilla frontal al cajón', g: 'f', n: 's' },
  'hack squat': { es: 'hack squat', g: 'm', n: 's' },
  'split squat': { es: 'sentadilla partida', g: 'f', n: 's' },
  'split squats': { es: 'sentadilla partida', g: 'f', n: 's' },
  'side split squat': { es: 'sentadilla partida lateral', g: 'f', n: 's' },
  'zercher squat': { es: 'sentadilla Zercher', g: 'f', n: 's' },
  'pistol squat': { es: 'sentadilla pistol', g: 'f', n: 's' },
  'goblet squat': { es: 'sentadilla goblet', g: 'f', n: 's' },
  'chair squat': { es: 'sentadilla en silla', g: 'f', n: 's' },
  'sit squat': { es: 'sentadilla', g: 'f', n: 's' },
  'wide squat': { es: 'sentadilla con piernas anchas', g: 'f', n: 's' },
  'one leg squat': { es: 'sentadilla a una pierna', g: 'f', n: 's' },
  'olympic squat': { es: 'sentadilla olímpica', g: 'f', n: 's' },
  'full squat': { es: 'sentadilla profunda', g: 'f', n: 's' },
  'quarter squat': { es: 'sentadilla a un cuarto', g: 'f', n: 's' },
  'high bar squat': { es: 'sentadilla con barra alta', g: 'f', n: 's' },
  'low bar squat': { es: 'sentadilla con barra baja', g: 'f', n: 's' },
  'frankenstein squat': { es: 'sentadilla Frankenstein', g: 'f', n: 's' },
  // deadlifts
  'deadlift': { es: 'peso muerto', g: 'm', n: 's' },
  'conventional deadlift': { es: 'peso muerto convencional', g: 'm', n: 's' },
  'romanian deadlift': { es: 'peso muerto rumano', g: 'm', n: 's' },
  'sumo deadlift': { es: 'peso muerto sumo', g: 'm', n: 's' },
  'stiff leg deadlift': { es: 'peso muerto a piernas rígidas', g: 'm', n: 's' },
  'stiff legged deadlift': { es: 'peso muerto a piernas rígidas', g: 'm', n: 's' },
  'straight leg deadlift': { es: 'peso muerto a piernas rígidas', g: 'm', n: 's' },
  // chest fly / crossover
  'fly': { es: 'aperturas', g: 'f', n: 'p' },
  'reverse fly': { es: 'aperturas invertidas', g: 'f', n: 'p' },
  'pec deck fly': { es: 'contractora', g: 'f', n: 's' },
  'crossover variation': { es: 'cruce en polea', g: 'm', n: 's' },
  'crossovers': { es: 'cruces en polea', g: 'm', n: 'p' },
  // core
  'crunch': { es: 'crunch', g: 'm', n: 's' },
  'reverse crunch': { es: 'crunch invertido', g: 'm', n: 's' },
  'tuck reverse crunch': { es: 'crunch invertido agrupado', g: 'm', n: 's' },
  'tuck crunch': { es: 'crunch agrupado', g: 'm', n: 's' },
  'cross body crunch': { es: 'crunch cruzado', g: 'm', n: 's' },
  'sit-up': { es: 'abdominal', g: 'm', n: 's' },
  'situp': { es: 'abdominal', g: 'm', n: 's' },
  'twisting sit-up': { es: 'abdominal con giro', g: 'm', n: 's' },
  'twisting situp': { es: 'abdominal con giro', g: 'm', n: 's' },
  'jackknife sit-up': { es: 'abdominal navaja', g: 'm', n: 's' },
  'side bend': { es: 'flexión lateral', g: 'f', n: 's' },
  'side bent': { es: 'flexión lateral', g: 'f', n: 's' },
  'twist': { es: 'rotación de tronco', g: 'f', n: 's' },
  'seated twist': { es: 'rotación de tronco sentado', g: 'f', n: 's' },
  'standing twist': { es: 'rotación de tronco de pie', g: 'f', n: 's' },
  'spine twist': { es: 'rotación de columna', g: 'f', n: 's' },
  'russian twist': { es: 'giro ruso', g: 'm', n: 's' },
  'plank': { es: 'plancha', g: 'f', n: 's' },
  'front plank': { es: 'plancha frontal', g: 'f', n: 's' },
  'side plank': { es: 'plancha lateral', g: 'f', n: 's' },
  'flutter kicks': { es: 'patada de tijera', g: 'f', n: 's' },
  'cocoons': { es: 'cocoons', g: 'm', n: 'p' },
  'butt ups': { es: 'elevación de glúteos', g: 'f', n: 's' },
  'elbow to knee': { es: 'codo a rodilla', g: 'm', n: 's' },
  'hip thrust': { es: 'hip thrust', g: 'm', n: 's' },
  'hip thrusts': { es: 'hip thrust', g: 'm', n: 's' },
  'hyperextension': { es: 'hiperextensión', g: 'f', n: 's' },
  // shoulders / other
  'shrug': { es: 'encogimiento de hombros', g: 'm', n: 's' },
  'gripless shrug': { es: 'encogimiento de hombros sin agarre', g: 'm', n: 's' },
  'pullover': { es: 'pullover', g: 'm', n: 's' },
  'bent arm pullover': { es: 'pullover con brazos flexionados', g: 'm', n: 's' },
  'extension pullover': { es: 'pullover con extensión', g: 'm', n: 's' },
  'kickback': { es: 'patada de tríceps', g: 'f', n: 's' },
  'tricep kickback': { es: 'patada de tríceps', g: 'f', n: 's' },
  'good morning': { es: 'good morning', g: 'm', n: 's' },
  'step-up': { es: 'subida al cajón', g: 'f', n: 's' },
  'lunge': { es: 'zancada', g: 'f', n: 's' },
  'rear lunge': { es: 'zancada hacia atrás', g: 'f', n: 's' },
  'dip': { es: 'fondo', g: 'm', n: 's' },
  'chest dip': { es: 'fondo de pecho', g: 'm', n: 's' },
  'triceps dip': { es: 'fondo de tríceps', g: 'm', n: 's' },
  'tricep dip': { es: 'fondo de tríceps', g: 'm', n: 's' },
  'triceps dips': { es: 'fondo de tríceps', g: 'm', n: 's' },
  'seated dip': { es: 'fondo sentado', g: 'm', n: 's' },
  'hip adduction': { es: 'aducción de cadera', g: 'f', n: 's' },
  'hip abduction': { es: 'abducción de cadera', g: 'f', n: 's' },
  'shoulder internal rotation': { es: 'rotación interna de hombro', g: 'f', n: 's' },
  'shoulder external rotation': { es: 'rotación externa de hombro', g: 'f', n: 's' },
  'internal rotation': { es: 'rotación interna', g: 'f', n: 's' },
  'external rotation': { es: 'rotación externa', g: 'f', n: 's' },
  'rear kick': { es: 'patada hacia atrás', g: 'f', n: 's' },
  'rotary calf': { es: 'elevación de gemelos rotatoria', g: 'f', n: 's' },
};

// Adjective modifiers with gender/number forms.
const A = (ms, fs, mp, fp) => ({ type: 'adj', f: { ms, fs, mp, fp } });
// Invariant prepositional-phrase modifiers, appended after adjectives.
const P = (es) => ({ type: 'phrase', es });

const MODS = {
  'incline': A('inclinado', 'inclinada', 'inclinados', 'inclinadas'),
  'decline': A('declinado', 'declinada', 'declinados', 'declinadas'),
  // position words describe the lifter, not the exercise noun -> invariant
  'seated': P('sentado'),
  'lying': P('tumbado'),
  'supine': P('tumbado'),
  'kneeling': P('arrodillado'),
  'standing': P('de pie'),
  'bent over': P('inclinado'),
  'reverse': A('invertido', 'invertida', 'invertidos', 'invertidas'),
  'inverted': A('invertido', 'invertida', 'invertidos', 'invertidas'),
  'front': A('frontal', 'frontal', 'frontales', 'frontales'),
  'rear': A('posterior', 'posterior', 'posteriores', 'posteriores'),
  'side': A('lateral', 'lateral', 'laterales', 'laterales'),
  'wide': A('ancho', 'ancha', 'anchos', 'anchas'),
  'narrow': A('estrecho', 'estrecha', 'estrechos', 'estrechas'),
  'alternate': A('alterno', 'alterna', 'alternos', 'alternas'),
  'alternating': A('alterno', 'alterna', 'alternos', 'alternas'),
  'straight': A('recto', 'recta', 'rectos', 'rectas'),
  'high': A('alto', 'alta', 'altos', 'altas'),
  'low': A('bajo', 'baja', 'bajos', 'bajas'),
  'middle': A('medio', 'media', 'medios', 'medias'),
  'inner': A('interno', 'interna', 'internos', 'internas'),
  'outer': A('externo', 'externa', 'externos', 'externas'),
  'upper': A('superior', 'superior', 'superiores', 'superiores'),
  'full': A('completo', 'completa', 'completos', 'completas'),
  'olympic': A('olímpico', 'olímpica', 'olímpicos', 'olímpicas'),
  'elevated': A('elevado', 'elevada', 'elevados', 'elevadas'),
  'vertical': A('vertical', 'vertical', 'verticales', 'verticales'),
  'horizontal': A('horizontal', 'horizontal', 'horizontales', 'horizontales'),
  'cross body': A('cruzado', 'cruzada', 'cruzados', 'cruzadas'),
  'crossover': A('cruzado', 'cruzada', 'cruzados', 'cruzadas'),
  'parallel': A('paralelo', 'paralela', 'paralelos', 'paralelas'),
  'hammer': P('agarre martillo'),
  'hammer grip': P('con agarre martillo'),
  // grips / positions as phrases
  'close grip': P('con agarre cerrado'),
  'wide grip': P('con agarre ancho'),
  'reverse grip': P('con agarre invertido'),
  'neutral grip': P('con agarre neutro'),
  'narrow grip': P('con agarre estrecho'),
  'parallel grip': P('con agarre paralelo'),
  'supinated grip': P('con agarre supino'),
  'pronated grip': P('con agarre prono'),
  'clean grip': P('con agarre de cargada'),
  'shoulder grip': P('con agarre a la anchura de hombros'),
  'overhand': P('con agarre prono'),
  'underhand': P('con agarre supino'),
  'one arm': P('a una mano'),
  'one-arm': P('a una mano'),
  'single arm': P('a una mano'),
  'two arm': P('a dos manos'),
  'single leg': P('a una pierna'),
  'one leg': P('a una pierna'),
  'behind neck': P('tras nuca'),
  'behind head': P('tras nuca'),
  'behind back': P('por detrás de la espalda'),
  'behind the head': P('tras nuca'),
  'back of the head': P('tras nuca'),
  'overhead': P('por encima de la cabeza'),
  'straight leg': P('con pierna recta'),
  'straight arm': P('con brazos rectos'),
  'stiff leg': P('a piernas rígidas'),
  'palms up': P('con palmas arriba'),
  'palms in': P('con palmas enfrentadas'),
  'palm rotational': P('con giro de muñeca'),
  'floor': P('en el suelo'),
  'over bench': P('sobre el banco'),
  'high pulley': P('en polea alta'),
  'forward angled': P('inclinado hacia adelante'),
  'wide stance': P('con postura ancha'),
  'narrow stance': P('con postura estrecha'),
  'rope': P('con cuerda'),
  '45°': P('a 45°'),
  '30°': P('a 30°'),
  '3/4': P('a 3/4'),
  // connectors / redundant words to drop
  'to': P(''),
  'to skull': P(''),
  'extra': P(''),
  'leg': P(''),
  // extra single/compound modifiers surfaced by the coverage report
  'bar': P('con barra'),
  'bench': P('en banco'),
  'wrist': P('de muñeca'),
  'neutral': P('con agarre neutro'),
  'preacher': P('en banco Scott'),
  'peacher': P('en banco Scott'),
  'upright': P('de pie'),
  'hack': P('en máquina hack'),
  'hanging': P('en suspensión'),
  't-bar': P('en T'),
  'machine': P('en máquina'),
  'twisting': P('con giro'),
  'walking': P('caminando'),
  'weighted': P('con lastre'),
  'pike': P('en pica'),
  'bent arm': P('con brazo flexionado'),
  'straight back': P('con espalda recta'),
  'underhand grip': P('con agarre supino'),
  'twin handle': P('con maneral doble'),
  'wide hand': P('con manos anchas'),
  // trailing location / qualifier phrases
  'bent knees': P('con rodillas flexionadas'),
  'and hold': P('con retención'),
  'flat bench': P('en banco plano'),
  'with support': P('con apoyo'),
  'to bench': P('al cajón'),
  'on forearms': P('sobre antebrazos'),
  'on dip cage': P('en jaula de fondos'),
  'on high parallel bars': P('en paralelas altas'),
  'on parallel bars': P('en paralelas'),
  'on leg press': P('en prensa'),
};

// Full-core overrides for idioms / oddballs the composer would mangle.
const OVERRIDES = {
  'air bike': 'bicicleta de aire',
  'lying femoral': 'curl femoral tumbado',
  'lying leg curl': 'curl femoral tumbado',
  'kneeling leg curl': 'curl femoral arrodillado',
  'standing leg curl': 'curl femoral de pie',
  'seated leg curl': 'curl femoral sentado',
  'inverse leg curl': 'curl femoral inverso',
  'lying single extension': 'extensión de tríceps tumbado a un brazo',
  'concentration extension': 'extensión concentrada',
  'donkey calf raise': 'elevación de gemelos tipo burro',
  'rotary calf': 'elevación de gemelos rotatoria',
  'gripper hands': 'agarre de manos en máquina',
  'gripless shrug': 'encogimiento de hombros sin agarre',
  'rear decline bridge': 'puente declinado',
  'reverse hyper': 'hiperextensión inversa',
  'good morning': 'good morning',
  'seated good morning': 'good morning sentado',
  'stiff leg good morning': 'good morning a piernas rígidas',
  'russian twist': 'giro ruso',
  'spine twist': 'rotación de columna',
  'half wipers': 'limpiaparabrisas parciales',
  'wipers': 'limpiaparabrisas',
  'lying lifting': 'elevación tumbado',
  'crossover variation': 'cruce en polea',
  'standing up straight crossovers': 'cruces en polea de pie',
  'upper chest crossovers': 'cruces en polea para pecho superior',
  'cross over high reverse fly': 'aperturas invertidas altas en cruce',
  'cross over reverse fly': 'aperturas invertidas en cruce',
  'cross over lateral pulldown': 'jalón al pecho en cruce',
  'standing cross over high reverse fly': 'aperturas invertidas altas en cruce de pie',
  'standing rear kick': 'patada hacia atrás de pie',
  'standing hip extension': 'extensión de cadera de pie',
  'standing leg raise': 'elevación de pierna de pie',
  'seated hip abduction': 'abducción de cadera sentado',
  'seated hip adduction': 'aducción de cadera sentado',
  'side hip abduction': 'abducción de cadera lateral',
  'side hip adduction': 'aducción de cadera lateral',
  'hip adduction': 'aducción de cadera',
  'toe raise': 'elevación de puntas',
  'front raise and pullover': 'elevación frontal y pullover',
  'curl with multipurpose v bar': 'curl con barra en V',
  'crunch floor': 'crunch en el suelo',
  'reverse hyper on flat bench': 'hiperextensión inversa en banco plano',
  '45° leg wide press': 'prensa de piernas a 45° con postura ancha',
  'calf press on leg press': 'prensa de gemelos en prensa de piernas',
  'low bar squat with rack': 'sentadilla con barra baja en rack',
  'biceps curl reverse': 'curl de bíceps invertido',
};

// paren -> localized (or '' to drop, e.g. dataset "Male")
function paren(inner) {
  const map = {
    'male': '', 'female': '',
    'back pov': '', 'front pov': '',
    'plate loaded': 'de discos',
    'bench press machine': 'máquina de press',
    'on bench': 'en banco', 'on flat bench': 'en banco plano',
    'on knee': 'en rodilla', 'knees bent': 'rodillas flexionadas',
    'bent knee': 'rodilla flexionada', 'bent leg': 'pierna flexionada',
    'leg straight': 'pierna recta', 'straight': 'recto',
    'straight leg': 'pierna recta', 'straight arm': 'brazo recto',
    'with rope attachment': 'con cuerda', 'rope attachment': 'con cuerda',
    'sz bar': 'barra Z', 'v bar': 'barra en V', 'v bar attachment': 'barra en V',
    'bent bar': 'barra curva',
    'neutral grip': 'agarre neutro', 'narrow parallel grip': 'agarre paralelo estrecho',
    'clean grip': 'agarre de cargada',
    'on stability ball': 'en fitball', 'with medicine ball': 'con balón medicinal',
    'rack support': 'con soporte', 'inside squat cage': 'en jaula de sentadilla',
    'on hip': 'sobre la cadera', 'pistol': 'pistol', 'chest pad': 'con respaldo',
    'on parallel bars': 'en paralelas', 'on high parallel bars': 'en paralelas altas',
    'on dip cage': 'en jaula de fondos', 'on pull-up cable machine': 'en máquina de poleas',
    'narrow parallel grip)': 'agarre paralelo estrecho',
  };
  const key = inner.toLowerCase();
  if (key in map) return map[key];
  return inner; // preserve unknown fragments verbatim
}

function agree(mod, head) {
  const key = (head.g === 'm' ? 'm' : 'f') + (head.n === 'p' ? 'p' : 's');
  return mod.f[key];
}

// Parse a token span into modifier adjectives + prepositional phrases,
// longest-first. Returns null if any token is unrecognized.
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
        else if (m.es) phrases.push(m.es); // '' = drop (connectors like "to")
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
  // longest movement head at any position (leading + trailing tokens are mods)
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
  return [head.es, ...adjs, ...phrases].join(' ');
}

function render(core, equip) {
  const over = OVERRIDES[core.toLowerCase()];
  let phrase = over != null ? over : translateCore(core);
  if (phrase == null) return null;
  if (equip && EQUIP[equip]) phrase += EQUIP[equip];
  return phrase;
}

export function ES(makeComposer) {
  const pack = { versionWord: 'variante ', paren, render };
  return { ...pack, translate: makeComposer(pack) };
}
