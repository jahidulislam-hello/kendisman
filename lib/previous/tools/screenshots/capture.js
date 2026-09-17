// App Store screenshot capture for Fitzella.
// Renders the Expo web build in real Chromium at iPhone 6.5" logical size
// (414x896) with deviceScaleFactor 3 -> PNGs are exactly 1242x2688, which is
// the App Store Connect 6.5" requirement.
const { chromium } = require('playwright');
const path = require('path');

const APP = process.env.SHOT_APP_URL || 'http://localhost:8081';
const EMAIL = process.env.SHOT_EMAIL;
const PASSWORD = process.env.SHOT_PASSWORD;
const OUT = process.env.SHOT_OUT || __dirname;

// Logical (CSS point) size of the target device. At deviceScaleFactor 3 the
// output PNG is 3x these numbers:
//   414 x 896 -> 1242 x 2688  (App Store 6.5")
//   430 x 932 -> 1290 x 2796  (App Store 6.9")
const LOGICAL_W = Number(process.env.SHOT_W || 414);
const LOGICAL_H = Number(process.env.SHOT_H || 896);

if (!EMAIL || !PASSWORD) {
  console.error(
    'Missing credentials. Set SHOT_EMAIL and SHOT_PASSWORD to a test account\n' +
      'with logged workout data, e.g.\n\n' +
      '  SHOT_EMAIL=you+test@example.com SHOT_PASSWORD=... node capture.js\n'
  );
  process.exit(1);
}

const wait = (page, ms) => page.waitForTimeout(ms);

// The web build has no iOS safe-area inset, so at an exact 896pt viewport the
// bottom tab labels get clipped. Render 20pt taller and clip that slack off
// the (empty) top, so the output is still exactly 1242x2688 but the tab bar
// is fully visible -- matching how it looks on a real device.
const SLACK = 20;
const VIEW_W = LOGICAL_W;
const VIEW_H = LOGICAL_H + SLACK;
const CLIP = { x: 0, y: SLACK, width: LOGICAL_W, height: LOGICAL_H };

async function shot(page, name) {
  await wait(page, 1200);
  const file = path.join(OUT, name);
  await page.screenshot({ path: file, clip: CLIP });
  console.log('  saved', name);
}

// The paywall content is short and top-aligned, so a plain full-frame shot
// leaves a large dead band below it. Clip tightly to the content (the "Close"
// header down to the "Privacy Policy" footer), then re-composite that centered,
// full-width, on a frame the exact target size (LOGICAL_W x LOGICAL_H -> 3x),
// padding it with the paywall's own background so the join is seamless. This is
// the "clip to bbox + pad to 1290x2796" approach -- deterministic, no image lib,
// no dependence on react-native-web's internal flex layout. Falls back to a
// plain shot if the text anchors can't be found, so it can never make it worse.
async function capturePaywall(page, context) {
  await wait(page, 1200);
  const info = await page.evaluate((h) => {
    const leaf = (t) =>
      [...document.querySelectorAll('*')].find(
        (el) => el.textContent.trim() === t && el.children.length === 0,
      );
    // Background colour of the paywall (sampled from an empty lower point, which
    // is the full-height modal container's background) so padding matches.
    let bg = 'rgb(0,0,0)';
    let el = document.elementFromPoint(5, h - 20);
    while (el) {
      const c = getComputedStyle(el).backgroundColor;
      if (c && c !== 'rgba(0, 0, 0, 0)' && c !== 'transparent') {
        bg = c;
        break;
      }
      el = el.parentElement;
    }
    const top = leaf('Close'); // paywall header, unique to this screen
    const bottom = leaf('Privacy Policy') || leaf('Terms of Service');
    if (!top || !bottom) return { ok: false, bg };
    return {
      ok: true,
      bg,
      top: Math.max(0, Math.floor(top.getBoundingClientRect().top) - 12),
      bottom: Math.ceil(bottom.getBoundingClientRect().bottom) + 14,
    };
  }, VIEW_H);

  if (!info.ok) {
    console.log('  paywall anchors not found -- falling back to plain shot');
    await shot(page, '04-paywall.png');
    return;
  }

  const clipH = Math.min(info.bottom - info.top, VIEW_H);
  const content = await page.screenshot({ clip: { x: 0, y: info.top, width: LOGICAL_W, height: clipH } });
  const dataUrl = 'data:image/png;base64,' + content.toString('base64');

  // Second page inherits the context's deviceScaleFactor (3), so a LOGICAL_W x
  // LOGICAL_H viewport screenshots at exactly the target pixels. width:LOGICAL_W
  // renders the 3x content clip at native resolution, full-width, centered.
  const frame = await context.newPage();
  await frame.setViewportSize({ width: LOGICAL_W, height: LOGICAL_H });
  await frame.setContent(
    `<!doctype html><html><body style="margin:0;padding:0;width:${LOGICAL_W}px;height:${LOGICAL_H}px;` +
      `background:${info.bg};display:flex;align-items:center;justify-content:center;overflow:hidden;">` +
      `<img src="${dataUrl}" style="width:${LOGICAL_W}px;height:auto;display:block;" /></body></html>`,
  );
  await frame.waitForTimeout(300);
  await frame.screenshot({ path: path.join(OUT, '04-paywall.png') });
  await frame.close();
  console.log('  saved 04-paywall.png (recomposited, centered)');
}

async function peek(page, label) {
  const txt = (await page.locator('body').innerText()).replace(/\n+/g, ' | ').slice(0, 160);
  console.log(`  [${label}] ${txt}`);
}

// Inactive tab screens stay mounted and tabs are lazy, so switching tabs from
// inside a nested stack screen doesn't reliably activate the target. Reloading
// resets to a clean Home before each capture (session persists in localStorage).
// react-native-web gives <input> an intrinsic default width, so `flex: 1`
// text cells refuse to shrink and push later columns (RPE, the check circle)
// off-screen. Real RN has no intrinsic input width, so this makes the web
// render match how the set table actually lays out on device.
async function applyWebFixes(page) {
  // No !important -- the per-input inline pin for the RPE column must win.
  await page.addStyleTag({ content: 'input { min-width: 0; }' }).catch(() => {});
}

async function reset(page) {
  await page.goto(APP, { waitUntil: 'load' });
  await page.waitForSelector('a[href^="/Tabs/"]', { timeout: 30000 });
  await applyWebFixes(page);
  await wait(page, 2500);
}

// The bottom tab bar renders as real <a href="/Tabs/..."> anchors.
async function tab(page, name) {
  await page.click(`a[href="/Tabs/${name}"]`);
  await wait(page, 1800);
}

// Rows/buttons are TouchableOpacity divs -- Playwright's real mouse events
// drive them fine, unlike a synthetic .click().
async function tapText(page, text) {
  await page.getByText(text, { exact: true }).first().click();
  await wait(page, 1800);
}

(async () => {
  const browser = await chromium.launch();
  const context = await browser.newContext({
    viewport: { width: VIEW_W, height: VIEW_H },
    deviceScaleFactor: 3,
    colorScheme: 'dark',
  });
  const page = await context.newPage();
  page.on('pageerror', (e) => console.log('  [pageerror]', e.message.split('\n')[0]));

  console.log('Loading app...');
  await page.goto(APP, { waitUntil: 'load' });
  await wait(page, 6000); // Metro first-bundle

  // --- Sign in -------------------------------------------------------
  if (await page.locator('input[placeholder="Email"]').count()) {
    console.log('Signing in...');
    // The auth screen now DEFAULTS to sign-up (commit dac991f). On that screen
    // the submit button is "Sign up" and the only "Sign in" text is the switch
    // link -- so we must flip to sign-in mode first, otherwise the fields belong
    // to the signup form and there's no "Sign in" button to submit.
    const toSignIn = page.getByText('Already have an account? Sign in', { exact: true });
    if (await toSignIn.count()) {
      await toSignIn.first().click().catch(() => {});
      await wait(page, 800);
    }
    await page.fill('input[placeholder="Email"]', EMAIL);
    await page.fill('input[placeholder="Password"]', PASSWORD);
    // In sign-in mode "Sign in" appears twice (heading + button); try each until
    // the tab bar shows up, working backwards since the button follows the heading.
    const matches = page.getByText('Sign in', { exact: true });
    const count = await matches.count();
    for (let i = count - 1; i >= 0; i--) {
      await matches.nth(i).click().catch(() => {});
      await wait(page, 5000);
      if (await page.locator('a[href^="/Tabs/"]').count()) break;
    }
  } else {
    console.log('Already signed in.');
  }
  await page.waitForSelector('a[href^="/Tabs/"]', { timeout: 30000 });
  await applyWebFixes(page);
  console.log('  signed in.');

  // --- 1. Home dashboard ---------------------------------------------
  console.log('1/4 Home dashboard');
  await tab(page, 'Home');
  await shot(page, '01-home.png');

  // --- 2. Workout / set logging --------------------------------------
  console.log('2/4 Set logging');
  await reset(page);
  await tab(page, 'Workout');
  await tapText(page, 'Barbell Row');
  // Fill the set table so the shot reads as a real mid-workout screen.
  const inputs = page.locator('input');
  const n = await inputs.count();
  console.log('  set-table inputs:', n);
  const values = ['135', '8', '7', '135', '8', '8', '145', '6', '9'];
  for (let i = 0; i < Math.min(n, values.length); i++) {
    try {
      await inputs.nth(i).fill(values[i]);
    } catch {}
  }
  await page.evaluate(() => {
    // Columns are [weight, reps, rpe] per row. Let weight/reps flex (min-width
    // 0, as on native) but pin RPE to its real 46pt width so it can't collapse.
    const inputs = [...document.querySelectorAll('input')];
    inputs.forEach((el, i) => {
      el.style.minWidth = '0px';
      if (i % 3 === 2) {
        el.style.width = '46px';
        el.style.minWidth = '46px';
        el.style.flexShrink = '0';
      }
    });
    // Focusing the RPE cell scrolls the row horizontally -- blur and reset.
    if (document.activeElement instanceof HTMLElement) document.activeElement.blur();
    document.querySelectorAll('*').forEach((el) => {
      if (el.scrollLeft) el.scrollLeft = 0;
    });
    window.scrollTo(0, 0);
  });
  await shot(page, '02-set-logging.png');

  // --- 3. Progress / Exercise Detail ---------------------------------
  // Barbell Back Squat has 2 logged sessions for this account, so the
  // progress chart actually renders (Bench Press has only 1 -> empty state).
  console.log('3/4 Exercise detail');
  await reset(page);
  await tab(page, 'Progress');
  await wait(page, 2500);
  await tapText(page, 'Barbell Back Squat');
  await peek(page, 'detail');
  await shot(page, '03-progress.png');

  // Alternative for slot 3: the Calendar, which reads well with sparse data.
  console.log('3b Calendar (alternative)');
  await reset(page);
  await tab(page, 'Profile');
  await wait(page, 1500);
  await tapText(page, 'Calendar');
  await shot(page, '03b-calendar.png');

  // --- 4. Paywall -----------------------------------------------------
  console.log('4/4 Paywall');
  await reset(page);
  await tab(page, 'Profile');
  await wait(page, 1500);
  await tapText(page, 'Settings');
  await peek(page, 'settings');
  await page.getByText('Upgrade', { exact: false }).first().click();
  await wait(page, 3000);
  await peek(page, 'paywall');
  await capturePaywall(page, context);

  await browser.close();
  console.log('Done.');
})().catch((e) => {
  console.error('FAILED:', e.message.split('\n').slice(0, 3).join(' | '));
  process.exit(1);
});
