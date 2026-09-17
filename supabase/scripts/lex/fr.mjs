// French lexicon pack for the exercise-name generator.
// French gym terminology (développé couché, soulevé de terre, tirage vertical,
// rowing, traction, écarté, fente, curl biceps, extension triceps).

const EQUIP = {
  barbell: ' à la barre',
  dumbbell: ' aux haltères',
  cable: ' à la poulie',
  lever: ' à la machine',
  smith: ' à la Smith',
  ez: ' à la barre EZ',
  sled: ' à la machine',
  machine: ' à la machine',
  bodyweight: '',
};
const MACHINE_SELF = /(presse à cuisses|presse à mollets)/i;

const HEADS = {
  'bicep curl': { fr: 'curl biceps', g: 'm', n: 's' },
  'biceps curl': { fr: 'curl biceps', g: 'm', n: 's' },
  'bicep curls': { fr: 'curl biceps', g: 'm', n: 's' },
  'biceps curls': { fr: 'curl biceps', g: 'm', n: 's' },
  'inner biceps curl': { fr: 'curl concentration', g: 'm', n: 's' },
  'inner curl': { fr: 'curl concentration', g: 'm', n: 's' },
  'hammer curl': { fr: 'curl marteau', g: 'm', n: 's' },
  'concentration curl': { fr: 'curl concentration', g: 'm', n: 's' },
  'preacher curl': { fr: 'curl au pupitre', g: 'm', n: 's' },
  'reverse preacher curl': { fr: 'curl au pupitre inversé', g: 'm', n: 's' },
  'drag curl': { fr: 'drag curl', g: 'm', n: 's' },
  'reverse curl': { fr: 'curl inversé', g: 'm', n: 's' },
  'wrist curl': { fr: 'curl poignet', g: 'm', n: 's' },
  'reverse wrist curl': { fr: 'curl poignet inversé', g: 'm', n: 's' },
  'finger curl': { fr: 'curl des doigts', g: 'm', n: 's' },
  'finger curls': { fr: 'curl des doigts', g: 'm', n: 's' },
  'zottman curl': { fr: 'curl Zottman', g: 'm', n: 's' },
  'high curl': { fr: 'curl haut', g: 'm', n: 's' },
  'curl': { fr: 'curl', g: 'm', n: 's' },
  'curls': { fr: 'curl', g: 'm', n: 's' },
  'bench press': { fr: 'développé couché', g: 'm', n: 's' },
  'incline bench press': { fr: 'développé incliné', g: 'm', n: 's' },
  'decline bench press': { fr: 'développé décliné', g: 'm', n: 's' },
  'chest press': { fr: 'développé poitrine', g: 'm', n: 's' },
  'inner chest press': { fr: 'développé poitrine interne', g: 'm', n: 's' },
  'shoulder press': { fr: 'développé épaules', g: 'm', n: 's' },
  'arnold press': { fr: 'développé Arnold', g: 'm', n: 's' },
  'military press': { fr: 'développé militaire', g: 'm', n: 's' },
  'overhead press': { fr: 'développé militaire', g: 'm', n: 's' },
  'skull press': { fr: 'barre au front', g: 'f', n: 's' },
  'skullcrusher': { fr: 'barre au front', g: 'f', n: 's' },
  'pallof press': { fr: 'press Pallof', g: 'm', n: 's' },
  'leg press': { fr: 'presse à cuisses', g: 'f', n: 's' },
  'calf press': { fr: 'presse à mollets', g: 'f', n: 's' },
  'hammer press': { fr: 'développé marteau', g: 'm', n: 's' },
  'close grip press': { fr: 'développé serré', g: 'm', n: 's' },
  'elbow press': { fr: 'développé coudes', g: 'm', n: 's' },
  'press': { fr: 'développé', g: 'm', n: 's' },
  'bent over row': { fr: 'rowing buste penché', g: 'm', n: 's' },
  'upright row': { fr: 'tirage menton', g: 'm', n: 's' },
  'seated row': { fr: 'rowing assis', g: 'm', n: 's' },
  'low seated row': { fr: 'tirage horizontal bas assis', g: 'm', n: 's' },
  'high row': { fr: 'rowing haut', g: 'm', n: 's' },
  'rear delt row': { fr: 'rowing deltoïde postérieur', g: 'm', n: 's' },
  't-bar row': { fr: 'rowing T-bar', g: 'm', n: 's' },
  'reverse t-bar row': { fr: 'rowing T-bar inversé', g: 'm', n: 's' },
  'incline row': { fr: 'rowing incliné', g: 'm', n: 's' },
  'inverted row': { fr: 'rowing inversé', g: 'm', n: 's' },
  'back row': { fr: 'rowing', g: 'm', n: 's' },
  'vertical row': { fr: 'tirage vertical', g: 'm', n: 's' },
  'elevated row': { fr: 'rowing surélevé', g: 'm', n: 's' },
  'upper row': { fr: 'rowing haut', g: 'm', n: 's' },
  'unilateral row': { fr: 'rowing unilatéral', g: 'm', n: 's' },
  'row': { fr: 'rowing', g: 'm', n: 's' },
  'lateral raise': { fr: 'élévation latérale', g: 'f', n: 's' },
  'rear lateral raise': { fr: 'élévation latérale buste penché', g: 'f', n: 's' },
  'bent arm lateral raise': { fr: 'élévation latérale bras fléchi', g: 'f', n: 's' },
  'front raise': { fr: 'élévation frontale', g: 'f', n: 's' },
  'front shoulder raise': { fr: 'élévation frontale', g: 'f', n: 's' },
  'rear delt raise': { fr: 'oiseau', g: 'm', n: 's' },
  'calf raise': { fr: 'extension des mollets', g: 'f', n: 's' },
  'calf raises': { fr: 'extension des mollets', g: 'f', n: 's' },
  'donkey calf raise': { fr: 'extension des mollets à l’âne', g: 'f', n: 's' },
  'toe raise': { fr: 'extension des mollets', g: 'f', n: 's' },
  'leg raise': { fr: 'relevé de jambes', g: 'm', n: 's' },
  'leg hip raise': { fr: 'relevé de bassin', g: 'm', n: 's' },
  'hip raise': { fr: 'relevé de bassin', g: 'm', n: 's' },
  'knee raise': { fr: 'relevé de genoux', g: 'm', n: 's' },
  'oblique knee raise': { fr: 'relevé de genoux oblique', g: 'm', n: 's' },
  'shoulder raise': { fr: 'élévation des épaules', g: 'f', n: 's' },
  'incline raise': { fr: 'élévation inclinée', g: 'f', n: 's' },
  'alternate raise': { fr: 'élévation alternée', g: 'f', n: 's' },
  'standing leg raise': { fr: 'relevé de jambe debout', g: 'm', n: 's' },
  'raise': { fr: 'élévation', g: 'f', n: 's' },
  'triceps extension': { fr: 'extension triceps', g: 'f', n: 's' },
  'tricep extension': { fr: 'extension triceps', g: 'f', n: 's' },
  'leg extension': { fr: 'leg extension', g: 'm', n: 's' },
  'leg curl': { fr: 'leg curl', g: 'm', n: 's' },
  'hip extension': { fr: 'extension de hanche', g: 'f', n: 's' },
  'bench extension': { fr: 'extension au banc', g: 'f', n: 's' },
  'single extension': { fr: 'extension unilatérale', g: 'f', n: 's' },
  'extension': { fr: 'extension', g: 'f', n: 's' },
  'lat pulldown': { fr: 'tirage vertical', g: 'm', n: 's' },
  'lateral pulldown': { fr: 'tirage vertical', g: 'm', n: 's' },
  'front lat pulldown': { fr: 'tirage vertical devant', g: 'm', n: 's' },
  'front pulldown': { fr: 'tirage vertical devant', g: 'm', n: 's' },
  'rear pulldown': { fr: 'tirage nuque', g: 'm', n: 's' },
  'straight arm pulldown': { fr: 'tirage bras tendus', g: 'm', n: 's' },
  'underhand pulldown': { fr: 'tirage vertical en supination', g: 'm', n: 's' },
  'wide pulldown': { fr: 'tirage vertical prise large', g: 'm', n: 's' },
  'pulldown': { fr: 'tirage vertical', g: 'm', n: 's' },
  'triceps pushdown': { fr: 'extension triceps', g: 'f', n: 's' },
  'tricep pushdown': { fr: 'extension triceps', g: 'f', n: 's' },
  'side triceps pushdown': { fr: 'extension triceps latérale', g: 'f', n: 's' },
  'pushdown': { fr: 'extension triceps', g: 'f', n: 's' },
  'pull-up': { fr: 'traction', g: 'f', n: 's' },
  'pull-ups': { fr: 'traction', g: 'f', n: 's' },
  'chin-up': { fr: 'traction en supination', g: 'f', n: 's' },
  'chin-ups': { fr: 'traction en supination', g: 'f', n: 's' },
  'push-up': { fr: 'pompe', g: 'f', n: 's' },
  'push-ups': { fr: 'pompe', g: 'f', n: 's' },
  'pull in': { fr: 'pull-in', g: 'm', n: 's' },
  'pull through': { fr: 'pull through', g: 'm', n: 's' },
  'squat': { fr: 'squat', g: 'm', n: 's' },
  'squats': { fr: 'squat', g: 'm', n: 's' },
  'back squat': { fr: 'squat barre nuque', g: 'm', n: 's' },
  'front squat': { fr: 'squat avant', g: 'm', n: 's' },
  'front chest squat': { fr: 'squat avant', g: 'm', n: 's' },
  'bench squat': { fr: 'squat sur banc', g: 'm', n: 's' },
  'bench front squat': { fr: 'squat avant sur banc', g: 'm', n: 's' },
  'hack squat': { fr: 'hack squat', g: 'm', n: 's' },
  'split squat': { fr: 'split squat', g: 'm', n: 's' },
  'split squats': { fr: 'split squat', g: 'm', n: 's' },
  'side split squat': { fr: 'split squat latéral', g: 'm', n: 's' },
  'zercher squat': { fr: 'squat Zercher', g: 'm', n: 's' },
  'pistol squat': { fr: 'pistol squat', g: 'm', n: 's' },
  'goblet squat': { fr: 'goblet squat', g: 'm', n: 's' },
  'chair squat': { fr: 'squat sur chaise', g: 'm', n: 's' },
  'sit squat': { fr: 'squat', g: 'm', n: 's' },
  'wide squat': { fr: 'squat jambes écartées', g: 'm', n: 's' },
  'one leg squat': { fr: 'squat sur une jambe', g: 'm', n: 's' },
  'olympic squat': { fr: 'squat olympique', g: 'm', n: 's' },
  'full squat': { fr: 'squat complet', g: 'm', n: 's' },
  'quarter squat': { fr: 'quart de squat', g: 'm', n: 's' },
  'high bar squat': { fr: 'squat barre haute', g: 'm', n: 's' },
  'low bar squat': { fr: 'squat barre basse', g: 'm', n: 's' },
  'frankenstein squat': { fr: 'squat Frankenstein', g: 'm', n: 's' },
  'deadlift': { fr: 'soulevé de terre', g: 'm', n: 's' },
  'conventional deadlift': { fr: 'soulevé de terre classique', g: 'm', n: 's' },
  'romanian deadlift': { fr: 'soulevé de terre roumain', g: 'm', n: 's' },
  'sumo deadlift': { fr: 'soulevé de terre sumo', g: 'm', n: 's' },
  'stiff leg deadlift': { fr: 'soulevé de terre jambes tendues', g: 'm', n: 's' },
  'stiff legged deadlift': { fr: 'soulevé de terre jambes tendues', g: 'm', n: 's' },
  'straight leg deadlift': { fr: 'soulevé de terre jambes tendues', g: 'm', n: 's' },
  'fly': { fr: 'écarté', g: 'm', n: 's' },
  'reverse fly': { fr: 'oiseau', g: 'm', n: 's' },
  'pec deck fly': { fr: 'pec deck', g: 'm', n: 's' },
  'crossover variation': { fr: 'cross over à la poulie', g: 'm', n: 's' },
  'crossovers': { fr: 'cross over à la poulie', g: 'm', n: 's' },
  'crunch': { fr: 'crunch', g: 'm', n: 's' },
  'reverse crunch': { fr: 'crunch inversé', g: 'm', n: 's' },
  'tuck reverse crunch': { fr: 'crunch inversé groupé', g: 'm', n: 's' },
  'tuck crunch': { fr: 'crunch groupé', g: 'm', n: 's' },
  'cross body crunch': { fr: 'crunch croisé', g: 'm', n: 's' },
  'sit-up': { fr: 'redressement assis', g: 'm', n: 's' },
  'situp': { fr: 'redressement assis', g: 'm', n: 's' },
  'twisting sit-up': { fr: 'redressement assis avec rotation', g: 'm', n: 's' },
  'twisting situp': { fr: 'redressement assis avec rotation', g: 'm', n: 's' },
  'jackknife sit-up': { fr: 'couteau', g: 'm', n: 's' },
  'side bend': { fr: 'flexion latérale', g: 'f', n: 's' },
  'side bent': { fr: 'flexion latérale', g: 'f', n: 's' },
  'twist': { fr: 'rotation du buste', g: 'f', n: 's' },
  'seated twist': { fr: 'rotation du buste assis', g: 'f', n: 's' },
  'standing twist': { fr: 'rotation du buste debout', g: 'f', n: 's' },
  'spine twist': { fr: 'rotation de la colonne', g: 'f', n: 's' },
  'russian twist': { fr: 'russian twist', g: 'm', n: 's' },
  'plank': { fr: 'planche', g: 'f', n: 's' },
  'front plank': { fr: 'gainage', g: 'm', n: 's' },
  'side plank': { fr: 'gainage latéral', g: 'm', n: 's' },
  'flutter kicks': { fr: 'battements de jambes', g: 'm', n: 's' },
  'cocoons': { fr: 'cocoons', g: 'm', n: 's' },
  'butt ups': { fr: 'relevé de bassin', g: 'm', n: 's' },
  'elbow to knee': { fr: 'coude au genou', g: 'm', n: 's' },
  'hip thrust': { fr: 'hip thrust', g: 'm', n: 's' },
  'hip thrusts': { fr: 'hip thrust', g: 'm', n: 's' },
  'hyperextension': { fr: 'hyperextension', g: 'f', n: 's' },
  'shrug': { fr: 'haussement d’épaules', g: 'm', n: 's' },
  'gripless shrug': { fr: 'haussement d’épaules sans prise', g: 'm', n: 's' },
  'pullover': { fr: 'pull-over', g: 'm', n: 's' },
  'bent arm pullover': { fr: 'pull-over bras fléchis', g: 'm', n: 's' },
  'extension pullover': { fr: 'pull-over avec extension', g: 'm', n: 's' },
  'kickback': { fr: 'kickback triceps', g: 'm', n: 's' },
  'tricep kickback': { fr: 'kickback triceps', g: 'm', n: 's' },
  'good morning': { fr: 'good morning', g: 'm', n: 's' },
  'step-up': { fr: 'montée sur banc', g: 'f', n: 's' },
  'lunge': { fr: 'fente', g: 'f', n: 's' },
  'rear lunge': { fr: 'fente arrière', g: 'f', n: 's' },
  'dip': { fr: 'dips', g: 'm', n: 's' },
  'chest dip': { fr: 'dips pectoraux', g: 'm', n: 's' },
  'triceps dip': { fr: 'dips triceps', g: 'm', n: 's' },
  'tricep dip': { fr: 'dips triceps', g: 'm', n: 's' },
  'triceps dips': { fr: 'dips triceps', g: 'm', n: 's' },
  'seated dip': { fr: 'dips assis', g: 'm', n: 's' },
  'hip adduction': { fr: 'adduction de hanche', g: 'f', n: 's' },
  'hip abduction': { fr: 'abduction de hanche', g: 'f', n: 's' },
  'shoulder internal rotation': { fr: 'rotation interne d’épaule', g: 'f', n: 's' },
  'shoulder external rotation': { fr: 'rotation externe d’épaule', g: 'f', n: 's' },
  'internal rotation': { fr: 'rotation interne', g: 'f', n: 's' },
  'external rotation': { fr: 'rotation externe', g: 'f', n: 's' },
  'rear kick': { fr: 'coup de pied arrière', g: 'm', n: 's' },
  'rotary calf': { fr: 'mollets rotatifs', g: 'm', n: 's' },
};

const A = (ms, fs, mp, fp) => ({ type: 'adj', f: { ms, fs, mp, fp } });
const P = (fr) => ({ type: 'phrase', fr });
const MODS = {
  'incline': A('incliné', 'inclinée', 'inclinés', 'inclinées'),
  'decline': A('décliné', 'déclinée', 'déclinés', 'déclinées'),
  'seated': P('assis'), 'lying': P('allongé'), 'supine': P('allongé'),
  'kneeling': P('à genoux'), 'standing': P('debout'), 'bent over': P('buste penché'),
  'reverse': A('inversé', 'inversée', 'inversés', 'inversées'),
  'inverted': A('inversé', 'inversée', 'inversés', 'inversées'),
  'inverse': A('inversé', 'inversée', 'inversés', 'inversées'),
  'front': P('avant'), 'rear': P('arrière'),
  'side': A('latéral', 'latérale', 'latéraux', 'latérales'),
  'wide': A('large', 'large', 'larges', 'larges'),
  'narrow': A('serré', 'serrée', 'serrés', 'serrées'),
  'alternate': A('alterné', 'alternée', 'alternés', 'alternées'),
  'alternating': A('alterné', 'alternée', 'alternés', 'alternées'),
  'straight': A('tendu', 'tendue', 'tendus', 'tendues'),
  'high': A('haut', 'haute', 'hauts', 'hautes'),
  'low': A('bas', 'basse', 'bas', 'basses'),
  'middle': A('central', 'centrale', 'centraux', 'centrales'),
  'inner': A('interne', 'interne', 'internes', 'internes'),
  'outer': A('externe', 'externe', 'externes', 'externes'),
  'upper': A('supérieur', 'supérieure', 'supérieurs', 'supérieures'),
  'full': A('complet', 'complète', 'complets', 'complètes'),
  'olympic': A('olympique', 'olympique', 'olympiques', 'olympiques'),
  'elevated': A('surélevé', 'surélevée', 'surélevés', 'surélevées'),
  'vertical': A('vertical', 'verticale', 'verticaux', 'verticales'),
  'horizontal': A('horizontal', 'horizontale', 'horizontaux', 'horizontales'),
  'cross body': P('croisé'), 'crossover': P('croisé'),
  'parallel': A('parallèle', 'parallèle', 'parallèles', 'parallèles'),
  'hammer': P('prise marteau'), 'hammer grip': P('en prise marteau'),
  'close grip': P('prise serrée'), 'wide grip': P('prise large'),
  'reverse grip': P('en supination'), 'neutral grip': P('prise neutre'),
  'narrow grip': P('prise serrée'), 'parallel grip': P('prise parallèle'),
  'supinated grip': P('en supination'), 'pronated grip': P('en pronation'),
  'clean grip': P('prise épaulé'), 'shoulder grip': P('prise largeur d’épaules'),
  'overhand': P('en pronation'), 'underhand': P('en supination'),
  'one arm': P('un bras'), 'one-arm': P('un bras'), 'single arm': P('un bras'),
  'two arm': P('deux bras'), 'single leg': P('une jambe'), 'one leg': P('une jambe'),
  'behind neck': P('nuque'), 'behind head': P('nuque'), 'behind back': P('derrière le dos'),
  'behind the head': P('nuque'), 'back of the head': P('nuque'), 'overhead': P('au-dessus de la tête'),
  'straight leg': P('jambe tendue'), 'straight arm': P('bras tendus'), 'stiff leg': P('jambes tendues'),
  'palms up': P('paumes vers le haut'), 'palms in': P('paumes face à face'),
  'palm rotational': P('avec rotation du poignet'),
  'floor': P('au sol'), 'over bench': P('sur banc'), 'high pulley': P('à la poulie haute'),
  'forward angled': P('incliné vers l’avant'), 'wide stance': P('jambes écartées'),
  'narrow stance': P('jambes serrées'), 'rope': P('à la corde'),
  '45°': P('45°'), '30°': P('30°'), '3/4': P('3/4'),
  'to': P(''), 'to skull': P(''), 'extra': P(''), 'leg': P(''),
  'bar': P('à la barre'), 'bench': P('au banc'), 'wrist': P('poignet'),
  'neutral': P('prise neutre'), 'preacher': P('au pupitre'), 'peacher': P('au pupitre'),
  'upright': P('debout'), 'hack': P('à la machine hack'), 'hanging': P('suspendu'),
  't-bar': P('T-bar'), 'machine': P('à la machine'), 'twisting': P('avec rotation'),
  'walking': P('marché'), 'weighted': P('lesté'), 'pike': P('en pike'),
  'bent arm': P('bras fléchi'), 'straight back': P('dos droit'),
  'underhand grip': P('en supination'), 'twin handle': P('poignée double'),
  'wide hand': P('mains écartées'), 'bent knees': P('genoux fléchis'),
  'and hold': P('avec maintien'), 'flat bench': P('au banc plat'),
  'with support': P('avec appui'), 'to bench': P('au banc'),
  'on forearms': P('sur les avant-bras'), 'on dip cage': P('à la station à dips'),
  'on high parallel bars': P('aux barres parallèles hautes'), 'on parallel bars': P('aux barres parallèles'),
  'on leg press': P('à la presse'),
};

const NOEQUIP = new Set(['lying femoral']);

const OVERRIDES = {
  'air bike': 'air bike',
  'lying femoral': 'leg curl allongé',
  'lying single extension': 'extension triceps allongé un bras',
  'concentration extension': 'extension concentration',
  'donkey calf raise': 'extension des mollets à l’âne',
  'rotary calf': 'mollets rotatifs',
  'gripper hands': 'travail de la poigne',
  'gripless shrug': 'haussement d’épaules sans prise',
  'rear decline bridge': 'pont décliné',
  'reverse hyper': 'hyperextension inversée',
  'good morning': 'good morning',
  'seated good morning': 'good morning assis',
  'stiff leg good morning': 'good morning jambes tendues',
  'russian twist': 'russian twist',
  'spine twist': 'rotation de la colonne',
  'half wipers': 'essuie-glaces partiels',
  'wipers': 'essuie-glaces',
  'lying lifting': 'relevé allongé',
  'crossover variation': 'cross over à la poulie',
  'standing up straight crossovers': 'cross over à la poulie debout',
  'upper chest crossovers': 'cross over pour haut des pectoraux',
  'cross over high reverse fly': 'oiseau haut à la poulie croisée',
  'cross over reverse fly': 'oiseau à la poulie croisée',
  'cross over lateral pulldown': 'tirage vertical à la poulie croisée',
  'standing cross over high reverse fly': 'oiseau haut à la poulie croisée debout',
  'standing rear kick': 'coup de pied arrière debout',
  'standing hip extension': 'extension de hanche debout',
  'standing leg raise': 'relevé de jambe debout',
  'seated hip abduction': 'abduction de hanche assis',
  'seated hip adduction': 'adduction de hanche assis',
  'side hip abduction': 'abduction de hanche latérale',
  'side hip adduction': 'adduction de hanche latérale',
  'hip adduction': 'adduction de hanche',
  'toe raise': 'extension des mollets',
  'front raise and pullover': 'élévation frontale et pull-over',
  'curl with multipurpose v bar': 'curl à la barre en V',
  'crunch floor': 'crunch au sol',
  'reverse hyper on flat bench': 'hyperextension inversée au banc plat',
  '45° leg wide press': 'presse à cuisses à 45° jambes écartées',
  'calf press on leg press': 'presse à mollets à la presse à cuisses',
  'low bar squat with rack': 'squat barre basse au rack',
  'biceps curl reverse': 'curl biceps inversé',
};

function paren(inner) {
  const map = {
    'male': '', 'female': '', 'back pov': '', 'front pov': '',
    'plate loaded': 'à disques', 'bench press machine': 'machine à développé',
    'on bench': 'au banc', 'on flat bench': 'au banc plat',
    'on knee': 'au genou', 'knees bent': 'genoux fléchis',
    'bent knee': 'genou fléchi', 'bent leg': 'jambe fléchie',
    'leg straight': 'jambe tendue', 'straight': 'tendu',
    'straight leg': 'jambe tendue', 'straight arm': 'bras tendu',
    'with rope attachment': 'à la corde', 'rope attachment': 'à la corde',
    'sz bar': 'barre EZ', 'v bar': 'barre en V', 'v bar attachment': 'barre en V',
    'bent bar': 'barre coudée',
    'neutral grip': 'prise neutre', 'narrow parallel grip': 'prise parallèle serrée',
    'clean grip': 'prise épaulé',
    'on stability ball': 'sur swiss ball', 'with medicine ball': 'avec medicine ball',
    'rack support': 'avec appui', 'inside squat cage': 'dans la cage',
    'on hip': 'à la hanche', 'pistol': 'pistol', 'chest pad': 'avec appui pectoral',
    'on parallel bars': 'aux barres parallèles', 'on high parallel bars': 'aux barres parallèles hautes',
    'on dip cage': 'à la station à dips', 'on pull-up cable machine': 'à la poulie',
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
        else if (m.fr) phrases.push(m.fr);
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
  return [head.fr, ...adjs, ...phrases].join(' ');
}

function render(core, equip) {
  const k = core.toLowerCase();
  let phrase, noEquip = false;
  if (k in OVERRIDES) { phrase = OVERRIDES[k]; noEquip = NOEQUIP.has(k); }
  else { phrase = translateCore(core); if (phrase == null) return null; }
  if (equip && EQUIP[equip] && !noEquip) {
    let suf = EQUIP[equip];
    if (equip === 'barbell' && /barre/.test(phrase)) suf = '';
    else if (equip === 'cable' && /poulie|tirage/.test(phrase)) suf = '';
    else if ((equip === 'lever' || equip === 'machine' || equip === 'sled') && MACHINE_SELF.test(phrase)) suf = '';
    phrase += suf;
  }
  return phrase;
}

export function FR(makeComposer) {
  const pack = { versionWord: 'variante ', paren, render };
  return { ...pack, translate: makeComposer(pack) };
}
