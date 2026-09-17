// Brazilian Portuguese lexicon pack for the exercise-name generator.
// Terminology follows BR gym usage (supino, agachamento, levantamento terra,
// rosca, remada, puxada, cadeira extensora/flexora, desenvolvimento, crucifixo).

const EQUIP = {
  barbell: ' com barra',
  dumbbell: ' com halteres',
  cable: ' na polia',
  lever: ' na máquina',
  smith: ' no Smith',
  ez: ' com barra W',
  sled: ' na máquina',
  machine: ' na máquina',
  bodyweight: '',
};
// Machine-name self-references: don't append " na máquina" when the movement
// name already is the machine (cadeira extensora, leg press, panturrilha...).
const MACHINE_SELF = /(leg press|cadeira|mesa flexora|flexora|panturrilha|crucifixo|voador|pec|hack)/i;

const HEADS = {
  // rosca (curls)
  'bicep curl': { pt: 'rosca direta', g: 'f', n: 's' },
  'biceps curl': { pt: 'rosca direta', g: 'f', n: 's' },
  'bicep curls': { pt: 'rosca direta', g: 'f', n: 's' },
  'biceps curls': { pt: 'rosca direta', g: 'f', n: 's' },
  'inner biceps curl': { pt: 'rosca concentrada', g: 'f', n: 's' },
  'inner curl': { pt: 'rosca concentrada', g: 'f', n: 's' },
  'hammer curl': { pt: 'rosca martelo', g: 'f', n: 's' },
  'concentration curl': { pt: 'rosca concentrada', g: 'f', n: 's' },
  'preacher curl': { pt: 'rosca Scott', g: 'f', n: 's' },
  'reverse preacher curl': { pt: 'rosca Scott invertida', g: 'f', n: 's' },
  'drag curl': { pt: 'drag curl', g: 'm', n: 's' },
  'reverse curl': { pt: 'rosca inversa', g: 'f', n: 's' },
  'wrist curl': { pt: 'rosca de punho', g: 'f', n: 's' },
  'reverse wrist curl': { pt: 'rosca de punho inversa', g: 'f', n: 's' },
  'finger curl': { pt: 'rosca de dedos', g: 'f', n: 's' },
  'finger curls': { pt: 'rosca de dedos', g: 'f', n: 's' },
  'zottman curl': { pt: 'rosca Zottman', g: 'f', n: 's' },
  'high curl': { pt: 'rosca alta', g: 'f', n: 's' },
  'curl': { pt: 'rosca', g: 'f', n: 's' },
  'curls': { pt: 'rosca', g: 'f', n: 's' },
  // supino / desenvolvimento (presses)
  'bench press': { pt: 'supino reto', g: 'm', n: 's' },
  'incline bench press': { pt: 'supino inclinado', g: 'm', n: 's' },
  'decline bench press': { pt: 'supino declinado', g: 'm', n: 's' },
  'chest press': { pt: 'supino', g: 'm', n: 's' },
  'inner chest press': { pt: 'supino interno', g: 'm', n: 's' },
  'shoulder press': { pt: 'desenvolvimento', g: 'm', n: 's' },
  'arnold press': { pt: 'desenvolvimento Arnold', g: 'm', n: 's' },
  'military press': { pt: 'desenvolvimento militar', g: 'm', n: 's' },
  'overhead press': { pt: 'desenvolvimento militar', g: 'm', n: 's' },
  'skull press': { pt: 'tríceps testa', g: 'm', n: 's' },
  'skullcrusher': { pt: 'tríceps testa', g: 'm', n: 's' },
  'pallof press': { pt: 'press Pallof', g: 'm', n: 's' },
  'leg press': { pt: 'leg press', g: 'm', n: 's' },
  'calf press': { pt: 'panturrilha', g: 'f', n: 's' },
  'hammer press': { pt: 'supino martelo', g: 'm', n: 's' },
  'close grip press': { pt: 'supino fechado', g: 'm', n: 's' },
  'elbow press': { pt: 'supino de cotovelos', g: 'm', n: 's' },
  'press': { pt: 'supino', g: 'm', n: 's' },
  // remada (rows)
  'bent over row': { pt: 'remada curvada', g: 'f', n: 's' },
  'upright row': { pt: 'remada alta', g: 'f', n: 's' },
  'seated row': { pt: 'remada sentada', g: 'f', n: 's' },
  'low seated row': { pt: 'remada baixa sentada', g: 'f', n: 's' },
  'high row': { pt: 'remada alta', g: 'f', n: 's' },
  'rear delt row': { pt: 'remada para deltoides posterior', g: 'f', n: 's' },
  't-bar row': { pt: 'remada cavalinho', g: 'f', n: 's' },
  'reverse t-bar row': { pt: 'remada cavalinho invertida', g: 'f', n: 's' },
  'incline row': { pt: 'remada inclinada', g: 'f', n: 's' },
  'inverted row': { pt: 'remada invertida', g: 'f', n: 's' },
  'back row': { pt: 'remada', g: 'f', n: 's' },
  'vertical row': { pt: 'remada vertical', g: 'f', n: 's' },
  'elevated row': { pt: 'remada elevada', g: 'f', n: 's' },
  'upper row': { pt: 'remada alta', g: 'f', n: 's' },
  'unilateral row': { pt: 'remada unilateral', g: 'f', n: 's' },
  'row': { pt: 'remada', g: 'f', n: 's' },
  // elevação (raises)
  'lateral raise': { pt: 'elevação lateral', g: 'f', n: 's' },
  'rear lateral raise': { pt: 'elevação lateral posterior', g: 'f', n: 's' },
  'bent arm lateral raise': { pt: 'elevação lateral com braço flexionado', g: 'f', n: 's' },
  'front raise': { pt: 'elevação frontal', g: 'f', n: 's' },
  'front shoulder raise': { pt: 'elevação frontal de ombros', g: 'f', n: 's' },
  'rear delt raise': { pt: 'elevação de deltoides posterior', g: 'f', n: 's' },
  'calf raise': { pt: 'elevação de panturrilha', g: 'f', n: 's' },
  'calf raises': { pt: 'elevação de panturrilha', g: 'f', n: 's' },
  'donkey calf raise': { pt: 'panturrilha burrinho', g: 'f', n: 's' },
  'toe raise': { pt: 'elevação de panturrilha', g: 'f', n: 's' },
  'leg raise': { pt: 'elevação de pernas', g: 'f', n: 's' },
  'leg hip raise': { pt: 'elevação de quadril', g: 'f', n: 's' },
  'hip raise': { pt: 'elevação de quadril', g: 'f', n: 's' },
  'knee raise': { pt: 'elevação de joelhos', g: 'f', n: 's' },
  'oblique knee raise': { pt: 'elevação de joelhos oblíqua', g: 'f', n: 's' },
  'shoulder raise': { pt: 'elevação de ombros', g: 'f', n: 's' },
  'incline raise': { pt: 'elevação inclinada', g: 'f', n: 's' },
  'alternate raise': { pt: 'elevação alternada', g: 'f', n: 's' },
  'standing leg raise': { pt: 'elevação de perna em pé', g: 'f', n: 's' },
  'raise': { pt: 'elevação', g: 'f', n: 's' },
  // extensões
  'triceps extension': { pt: 'extensão de tríceps', g: 'f', n: 's' },
  'tricep extension': { pt: 'extensão de tríceps', g: 'f', n: 's' },
  'hip extension': { pt: 'extensão de quadril', g: 'f', n: 's' },
  'bench extension': { pt: 'extensão no banco', g: 'f', n: 's' },
  'single extension': { pt: 'extensão unilateral', g: 'f', n: 's' },
  'extension': { pt: 'extensão', g: 'f', n: 's' },
  // puxada (pulldowns)
  'lat pulldown': { pt: 'puxada frontal', g: 'f', n: 's' },
  'lateral pulldown': { pt: 'puxada frontal', g: 'f', n: 's' },
  'front lat pulldown': { pt: 'puxada frontal', g: 'f', n: 's' },
  'front pulldown': { pt: 'puxada frontal', g: 'f', n: 's' },
  'rear pulldown': { pt: 'puxada atrás da nuca', g: 'f', n: 's' },
  'straight arm pulldown': { pt: 'puxada com braços estendidos', g: 'f', n: 's' },
  'underhand pulldown': { pt: 'puxada supinada', g: 'f', n: 's' },
  'wide pulldown': { pt: 'puxada aberta', g: 'f', n: 's' },
  'pulldown': { pt: 'puxada', g: 'f', n: 's' },
  // tríceps na polia (pushdowns)
  'triceps pushdown': { pt: 'tríceps na polia', g: 'm', n: 's' },
  'tricep pushdown': { pt: 'tríceps na polia', g: 'm', n: 's' },
  'side triceps pushdown': { pt: 'tríceps na polia lateral', g: 'm', n: 's' },
  'pushdown': { pt: 'tríceps na polia', g: 'm', n: 's' },
  // peso corporal
  'pull-up': { pt: 'barra fixa', g: 'f', n: 's' },
  'pull-ups': { pt: 'barra fixa', g: 'f', n: 's' },
  'chin-up': { pt: 'barra fixa supinada', g: 'f', n: 's' },
  'chin-ups': { pt: 'barra fixa supinada', g: 'f', n: 's' },
  'push-up': { pt: 'flexão', g: 'f', n: 's' },
  'push-ups': { pt: 'flexão', g: 'f', n: 's' },
  'pull in': { pt: 'pull-in', g: 'm', n: 's' },
  'pull through': { pt: 'pull through', g: 'm', n: 's' },
  // agachamento (squats)
  'squat': { pt: 'agachamento', g: 'm', n: 's' },
  'squats': { pt: 'agachamento', g: 'm', n: 's' },
  'back squat': { pt: 'agachamento por trás', g: 'm', n: 's' },
  'front squat': { pt: 'agachamento frontal', g: 'm', n: 's' },
  'front chest squat': { pt: 'agachamento frontal', g: 'm', n: 's' },
  'bench squat': { pt: 'agachamento no banco', g: 'm', n: 's' },
  'bench front squat': { pt: 'agachamento frontal no banco', g: 'm', n: 's' },
  'hack squat': { pt: 'agachamento hack', g: 'm', n: 's' },
  'split squat': { pt: 'agachamento afundo', g: 'm', n: 's' },
  'split squats': { pt: 'agachamento afundo', g: 'm', n: 's' },
  'side split squat': { pt: 'agachamento afundo lateral', g: 'm', n: 's' },
  'zercher squat': { pt: 'agachamento Zercher', g: 'm', n: 's' },
  'pistol squat': { pt: 'agachamento pistol', g: 'm', n: 's' },
  'goblet squat': { pt: 'agachamento goblet', g: 'm', n: 's' },
  'chair squat': { pt: 'agachamento na cadeira', g: 'm', n: 's' },
  'sit squat': { pt: 'agachamento', g: 'm', n: 's' },
  'wide squat': { pt: 'agachamento com pernas afastadas', g: 'm', n: 's' },
  'one leg squat': { pt: 'agachamento unilateral', g: 'm', n: 's' },
  'olympic squat': { pt: 'agachamento olímpico', g: 'm', n: 's' },
  'full squat': { pt: 'agachamento profundo', g: 'm', n: 's' },
  'quarter squat': { pt: 'agachamento parcial', g: 'm', n: 's' },
  'high bar squat': { pt: 'agachamento com barra alta', g: 'm', n: 's' },
  'low bar squat': { pt: 'agachamento com barra baixa', g: 'm', n: 's' },
  'frankenstein squat': { pt: 'agachamento Frankenstein', g: 'm', n: 's' },
  // levantamento terra (deadlifts)
  'deadlift': { pt: 'levantamento terra', g: 'm', n: 's' },
  'conventional deadlift': { pt: 'levantamento terra convencional', g: 'm', n: 's' },
  'romanian deadlift': { pt: 'levantamento terra romeno', g: 'm', n: 's' },
  'sumo deadlift': { pt: 'levantamento terra sumô', g: 'm', n: 's' },
  'stiff leg deadlift': { pt: 'stiff', g: 'm', n: 's' },
  'stiff legged deadlift': { pt: 'stiff', g: 'm', n: 's' },
  'straight leg deadlift': { pt: 'stiff', g: 'm', n: 's' },
  // crucifixo / peito
  'fly': { pt: 'crucifixo', g: 'm', n: 's' },
  'reverse fly': { pt: 'crucifixo invertido', g: 'm', n: 's' },
  'pec deck fly': { pt: 'voador', g: 'm', n: 's' },
  'crossover variation': { pt: 'crossover', g: 'm', n: 's' },
  'crossovers': { pt: 'crossover', g: 'm', n: 's' },
  // core
  'crunch': { pt: 'abdominal', g: 'm', n: 's' },
  'reverse crunch': { pt: 'abdominal invertido', g: 'm', n: 's' },
  'tuck reverse crunch': { pt: 'abdominal invertido agrupado', g: 'm', n: 's' },
  'tuck crunch': { pt: 'abdominal agrupado', g: 'm', n: 's' },
  'cross body crunch': { pt: 'abdominal cruzado', g: 'm', n: 's' },
  'sit-up': { pt: 'abdominal', g: 'm', n: 's' },
  'situp': { pt: 'abdominal', g: 'm', n: 's' },
  'twisting sit-up': { pt: 'abdominal com rotação', g: 'm', n: 's' },
  'twisting situp': { pt: 'abdominal com rotação', g: 'm', n: 's' },
  'jackknife sit-up': { pt: 'abdominal canivete', g: 'm', n: 's' },
  'side bend': { pt: 'flexão lateral', g: 'f', n: 's' },
  'side bent': { pt: 'flexão lateral', g: 'f', n: 's' },
  'twist': { pt: 'rotação de tronco', g: 'f', n: 's' },
  'seated twist': { pt: 'rotação de tronco sentado', g: 'f', n: 's' },
  'standing twist': { pt: 'rotação de tronco em pé', g: 'f', n: 's' },
  'spine twist': { pt: 'rotação de coluna', g: 'f', n: 's' },
  'russian twist': { pt: 'russian twist', g: 'm', n: 's' },
  'plank': { pt: 'prancha', g: 'f', n: 's' },
  'front plank': { pt: 'prancha frontal', g: 'f', n: 's' },
  'side plank': { pt: 'prancha lateral', g: 'f', n: 's' },
  'flutter kicks': { pt: 'tesoura', g: 'f', n: 's' },
  'cocoons': { pt: 'cocoons', g: 'm', n: 'p' },
  'butt ups': { pt: 'elevação de glúteos', g: 'f', n: 's' },
  'elbow to knee': { pt: 'cotovelo ao joelho', g: 'm', n: 's' },
  'hip thrust': { pt: 'elevação pélvica', g: 'f', n: 's' },
  'hip thrusts': { pt: 'elevação pélvica', g: 'f', n: 's' },
  'hyperextension': { pt: 'hiperextensão', g: 'f', n: 's' },
  // ombros / outros
  'shrug': { pt: 'encolhimento de ombros', g: 'm', n: 's' },
  'gripless shrug': { pt: 'encolhimento de ombros sem pegada', g: 'm', n: 's' },
  'pullover': { pt: 'pullover', g: 'm', n: 's' },
  'bent arm pullover': { pt: 'pullover com braços flexionados', g: 'm', n: 's' },
  'extension pullover': { pt: 'pullover com extensão', g: 'm', n: 's' },
  'kickback': { pt: 'tríceps coice', g: 'm', n: 's' },
  'tricep kickback': { pt: 'tríceps coice', g: 'm', n: 's' },
  'good morning': { pt: 'good morning', g: 'm', n: 's' },
  'step-up': { pt: 'subida no banco', g: 'f', n: 's' },
  'lunge': { pt: 'afundo', g: 'm', n: 's' },
  'rear lunge': { pt: 'afundo para trás', g: 'm', n: 's' },
  'dip': { pt: 'mergulho', g: 'm', n: 's' },
  'chest dip': { pt: 'mergulho para peito', g: 'm', n: 's' },
  'triceps dip': { pt: 'mergulho para tríceps', g: 'm', n: 's' },
  'tricep dip': { pt: 'mergulho para tríceps', g: 'm', n: 's' },
  'triceps dips': { pt: 'mergulho para tríceps', g: 'm', n: 's' },
  'seated dip': { pt: 'mergulho sentado', g: 'm', n: 's' },
  'hip adduction': { pt: 'adução de quadril', g: 'f', n: 's' },
  'hip abduction': { pt: 'abdução de quadril', g: 'f', n: 's' },
  'shoulder internal rotation': { pt: 'rotação interna de ombro', g: 'f', n: 's' },
  'shoulder external rotation': { pt: 'rotação externa de ombro', g: 'f', n: 's' },
  'internal rotation': { pt: 'rotação interna', g: 'f', n: 's' },
  'external rotation': { pt: 'rotação externa', g: 'f', n: 's' },
  'rear kick': { pt: 'coice para trás', g: 'm', n: 's' },
  'rotary calf': { pt: 'panturrilha rotativa', g: 'f', n: 's' },
};

const A = (ms, fs, mp, fp) => ({ type: 'adj', f: { ms, fs, mp, fp } });
const P = (pt) => ({ type: 'phrase', pt });

const MODS = {
  'incline': A('inclinado', 'inclinada', 'inclinados', 'inclinadas'),
  'decline': A('declinado', 'declinada', 'declinados', 'declinadas'),
  'seated': P('sentado'),
  'lying': P('deitado'),
  'supine': P('deitado'),
  'kneeling': P('ajoelhado'),
  'standing': P('em pé'),
  'bent over': P('curvado'),
  'reverse': A('invertido', 'invertida', 'invertidos', 'invertidas'),
  'inverted': A('invertido', 'invertida', 'invertidos', 'invertidas'),
  'front': A('frontal', 'frontal', 'frontais', 'frontais'),
  'rear': A('posterior', 'posterior', 'posteriores', 'posteriores'),
  'side': A('lateral', 'lateral', 'laterais', 'laterais'),
  'wide': A('largo', 'larga', 'largos', 'largas'),
  'narrow': A('estreito', 'estreita', 'estreitos', 'estreitas'),
  'alternate': A('alternado', 'alternada', 'alternados', 'alternadas'),
  'alternating': A('alternado', 'alternada', 'alternados', 'alternadas'),
  'straight': A('reto', 'reta', 'retos', 'retas'),
  'high': A('alto', 'alta', 'altos', 'altas'),
  'low': A('baixo', 'baixa', 'baixos', 'baixas'),
  'middle': A('médio', 'média', 'médios', 'médias'),
  'inner': A('interno', 'interna', 'internos', 'internas'),
  'outer': A('externo', 'externa', 'externos', 'externas'),
  'upper': A('superior', 'superior', 'superiores', 'superiores'),
  'full': A('completo', 'completa', 'completos', 'completas'),
  'olympic': A('olímpico', 'olímpica', 'olímpicos', 'olímpicas'),
  'elevated': A('elevado', 'elevada', 'elevados', 'elevadas'),
  'vertical': A('vertical', 'vertical', 'verticais', 'verticais'),
  'horizontal': A('horizontal', 'horizontal', 'horizontais', 'horizontais'),
  'cross body': A('cruzado', 'cruzada', 'cruzados', 'cruzadas'),
  'crossover': A('cruzado', 'cruzada', 'cruzados', 'cruzadas'),
  'parallel': A('paralelo', 'paralela', 'paralelos', 'paralelas'),
  'inverted grip': P('com pegada invertida'),
  'hammer': P('pegada martelo'),
  'hammer grip': P('com pegada martelo'),
  'close grip': P('com pegada fechada'),
  'wide grip': P('com pegada aberta'),
  'reverse grip': P('com pegada invertida'),
  'neutral grip': P('com pegada neutra'),
  'narrow grip': P('com pegada fechada'),
  'parallel grip': P('com pegada paralela'),
  'supinated grip': P('com pegada supinada'),
  'pronated grip': P('com pegada pronada'),
  'clean grip': P('com pegada de clean'),
  'shoulder grip': P('com pegada na largura dos ombros'),
  'overhand': P('com pegada pronada'),
  'underhand': P('com pegada supinada'),
  'one arm': P('unilateral'),
  'one-arm': P('unilateral'),
  'single arm': P('unilateral'),
  'two arm': P('com os dois braços'),
  'single leg': P('unilateral'),
  'one leg': P('unilateral'),
  'behind neck': P('atrás da nuca'),
  'behind head': P('atrás da nuca'),
  'behind back': P('atrás das costas'),
  'behind the head': P('atrás da nuca'),
  'back of the head': P('atrás da nuca'),
  'overhead': P('acima da cabeça'),
  'straight leg': P('com perna reta'),
  'straight arm': P('com braços estendidos'),
  'stiff leg': P('com pernas rígidas'),
  'palms up': P('com palmas para cima'),
  'palms in': P('com palmas voltadas'),
  'palm rotational': P('com rotação de punho'),
  'floor': P('no chão'),
  'over bench': P('sobre o banco'),
  'high pulley': P('na polia alta'),
  'forward angled': P('inclinado para frente'),
  'wide stance': P('com base ampla'),
  'narrow stance': P('com base estreita'),
  'rope': P('com corda'),
  '45°': P('a 45°'),
  '30°': P('a 30°'),
  '3/4': P('a 3/4'),
  'to': P(''),
  'to skull': P(''),
  'extra': P(''),
  'leg': P(''),
  'bar': P('com barra'),
  'bench': P('no banco'),
  'wrist': P('de punho'),
  'neutral': P('com pegada neutra'),
  'preacher': P('no banco Scott'),
  'peacher': P('no banco Scott'),
  'upright': P('em pé'),
  'hack': P('na máquina hack'),
  'hanging': P('na barra'),
  't-bar': P('cavalinho'),
  'machine': P('na máquina'),
  'twisting': P('com rotação'),
  'walking': P('caminhando'),
  'weighted': P('com carga'),
  'pike': P('em pike'),
  'bent arm': P('com braço flexionado'),
  'straight back': P('com costas retas'),
  'underhand grip': P('com pegada supinada'),
  'twin handle': P('com pegador duplo'),
  'wide hand': P('com mãos afastadas'),
  'bent knees': P('com joelhos flexionados'),
  'and hold': P('com sustentação'),
  'flat bench': P('no banco reto'),
  'with support': P('com apoio'),
  'to bench': P('no banco'),
  'on forearms': P('sobre os antebraços'),
  'on dip cage': P('na paralela'),
  'on high parallel bars': P('nas paralelas altas'),
  'on parallel bars': P('nas paralelas'),
  'on leg press': P('no leg press'),
};

const NOEQUIP = new Set([
  'leg extension', 'seated leg curl', 'lying leg curl', 'standing leg curl',
  'kneeling leg curl', 'inverse leg curl', 'lying femoral',
]);

const OVERRIDES = {
  'air bike': 'bicicleta ergométrica',
  'lying femoral': 'mesa flexora',
  'lying leg curl': 'mesa flexora',
  'kneeling leg curl': 'flexora ajoelhado',
  'standing leg curl': 'flexora em pé',
  'seated leg curl': 'cadeira flexora',
  'inverse leg curl': 'flexora invertida',
  'leg extension': 'cadeira extensora',
  'lying single extension': 'extensão de tríceps deitado unilateral',
  'concentration extension': 'extensão concentrada',
  'donkey calf raise': 'panturrilha burrinho',
  'rotary calf': 'panturrilha rotativa',
  'gripper hands': 'pegada na máquina',
  'gripless shrug': 'encolhimento de ombros sem pegada',
  'rear decline bridge': 'ponte declinada',
  'reverse hyper': 'hiperextensão invertida',
  'good morning': 'good morning',
  'seated good morning': 'good morning sentado',
  'stiff leg good morning': 'good morning com pernas rígidas',
  'russian twist': 'russian twist',
  'spine twist': 'rotação de coluna',
  'half wipers': 'limpador de para-brisa parcial',
  'wipers': 'limpador de para-brisa',
  'lying lifting': 'elevação deitado',
  'crossover variation': 'crossover',
  'standing up straight crossovers': 'crossover em pé',
  'upper chest crossovers': 'crossover para peito superior',
  'cross over high reverse fly': 'crucifixo invertido alto no crossover',
  'cross over reverse fly': 'crucifixo invertido no crossover',
  'cross over lateral pulldown': 'puxada no crossover',
  'standing cross over high reverse fly': 'crucifixo invertido alto no crossover em pé',
  'standing rear kick': 'coice para trás em pé',
  'standing hip extension': 'extensão de quadril em pé',
  'standing leg raise': 'elevação de perna em pé',
  'seated hip abduction': 'abdução de quadril sentado',
  'seated hip adduction': 'adução de quadril sentado',
  'side hip abduction': 'abdução de quadril lateral',
  'side hip adduction': 'adução de quadril lateral',
  'hip adduction': 'adução de quadril',
  'toe raise': 'elevação de ponta',
  'front raise and pullover': 'elevação frontal e pullover',
  'curl with multipurpose v bar': 'rosca com barra em V',
  'crunch floor': 'abdominal no chão',
  'reverse hyper on flat bench': 'hiperextensão invertida no banco reto',
  '45° leg wide press': 'leg press a 45° com base ampla',
  'calf press on leg press': 'panturrilha no leg press',
  'low bar squat with rack': 'agachamento com barra baixa no rack',
  'biceps curl reverse': 'rosca direta invertida',
};

function paren(inner) {
  const map = {
    'male': '', 'female': '', 'back pov': '', 'front pov': '',
    'plate loaded': 'com anilhas', 'bench press machine': 'máquina de supino',
    'on bench': 'no banco', 'on flat bench': 'no banco reto',
    'on knee': 'no joelho', 'knees bent': 'joelhos flexionados',
    'bent knee': 'joelho flexionado', 'bent leg': 'perna flexionada',
    'leg straight': 'perna reta', 'straight': 'reto',
    'straight leg': 'perna reta', 'straight arm': 'braço estendido',
    'with rope attachment': 'com corda', 'rope attachment': 'com corda',
    'sz bar': 'barra W', 'v bar': 'barra em V', 'v bar attachment': 'barra em V',
    'bent bar': 'barra curva',
    'neutral grip': 'pegada neutra', 'narrow parallel grip': 'pegada paralela fechada',
    'clean grip': 'pegada de clean',
    'on stability ball': 'na bola', 'with medicine ball': 'com medicine ball',
    'rack support': 'com apoio', 'inside squat cage': 'no rack',
    'on hip': 'no quadril', 'pistol': 'pistol', 'chest pad': 'com apoio de peito',
    'on parallel bars': 'nas paralelas', 'on high parallel bars': 'nas paralelas altas',
    'on dip cage': 'na paralela', 'on pull-up cable machine': 'na máquina de polia',
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
        else if (m.pt) phrases.push(m.pt);
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
  return [head.pt, ...adjs, ...phrases].join(' ');
}

function render(core, equip) {
  const k = core.toLowerCase();
  let phrase, noEquip = false;
  if (k in OVERRIDES) { phrase = OVERRIDES[k]; noEquip = NOEQUIP.has(k); }
  else { phrase = translateCore(core); if (phrase == null) return null; }
  if (equip && EQUIP[equip] && !noEquip) {
    let suf = EQUIP[equip];
    if (equip === 'cable' && /polia|^puxada/.test(phrase)) suf = ''; // já indica polia (puxada, tríceps na polia)
    else if ((equip === 'lever' || equip === 'machine' || equip === 'sled') && MACHINE_SELF.test(phrase)) suf = '';
    phrase += suf;
  }
  return phrase;
}

export function PT(makeComposer) {
  const pack = { versionWord: 'variação ', paren, render };
  return { ...pack, translate: makeComposer(pack) };
}
