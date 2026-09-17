# App Store screenshot capture

Renders the Expo **web** build in real Chromium (Playwright) at iPhone 6.5"
logical size (414x896) with `deviceScaleFactor: 3`, producing PNGs that are
exactly **1242x2688** — the App Store Connect 6.5" requirement.

## Run

```bash
# 1. Start the dev server (from the repo root, in its own terminal)
npm run web --workspace=mobile     # serves http://localhost:8081

# 2. Install once (only needed the first time / after a clean checkout)
cd tools/screenshots
npm install
npx playwright install chromium

# 3. Capture -- credentials come from the environment, not the source
SHOT_EMAIL=you+test@example.com SHOT_PASSWORD=... node capture.js
```

On Windows PowerShell:

```powershell
$env:SHOT_EMAIL = "you+test@example.com"
$env:SHOT_PASSWORD = "..."
node capture.js
```

| Variable | Required | Default |
|---|---|---|
| `SHOT_EMAIL` | yes | — |
| `SHOT_PASSWORD` | yes | — |
| `SHOT_APP_URL` | no | `http://localhost:8081` |
| `SHOT_W` / `SHOT_H` | no | `414` / `896` (logical points) |
| `SHOT_OUT` | no | this folder |

### Device sizes

`SHOT_W` / `SHOT_H` are **logical points**; output is 3x that (the script
renders at `deviceScaleFactor: 3`). The two sizes App Store Connect wants:

| Display | `SHOT_W` x `SHOT_H` | Output PNG |
|---|---|---|
| 6.5" (iPhone 11 Pro Max) | `414` x `896` — the default | 1242 x 2688 |
| 6.9" (iPhone 16 Pro Max) | `430` x `932` | 1290 x 2796 |

```bash
# 6.9" set into a folder on the Desktop
SHOT_EMAIL=... SHOT_PASSWORD=... \
SHOT_W=430 SHOT_H=932 \
SHOT_OUT="$HOME/Desktop/fitzella-appstore-screenshots-69" \
node capture.js
```

Use a **test account with logged workout data** — the screens are only worth
capturing when they show real sets, streaks, and history rather than empty
states. The script exits with a clear message if the two required variables
aren't set.

Five PNGs land in this folder:

| File | Screen |
|---|---|
| `01-home.png` | Home dashboard |
| `02-set-logging.png` | Set logging (SET/WEIGHT/REPS/RPE table) |
| `03-progress.png` | Exercise Detail — PR, Est. 1RM, progress chart |
| `03b-calendar.png` | Calendar month view |
| `04-paywall.png` | Paywall — Fitzella Premium $9.99/mo |

The script signs in with the account from `SHOT_EMAIL` / `SHOT_PASSWORD` so
the screens show real logged data rather than empty states. It reloads
between captures — inactive tab screens stay mounted and tabs are
lazy, so switching tabs from inside a nested stack screen doesn't reliably
activate the target.

## The paywall shot needs a temporary RevenueCat stub

`04-paywall.png` will otherwise render the "subscriptions aren't available
right now" state. RevenueCat's native module **does not exist on web**, so
`fetchOfferings()` returns `null` and the paywall hides its purchase card.

To capture the real `$9.99/mo` card, temporarily add this at the top of
`fetchOfferings()` in `mobile/src/lib/purchases.ts`, then **revert it before
committing**:

```ts
if (Platform.OS === 'web') {
  return {
    all: {
      default: {
        availablePackages: [
          { identifier: '$rc_monthly', product: { priceString: '$9.99/mo' } },
          { identifier: '$rc_annual', product: { priceString: '$59.99/yr' } },
        ],
      },
    },
    current: null,
  } as unknown as PurchasesOfferings;
}
```

`git checkout -- mobile/src/lib/purchases.ts` puts it back.

## Two web-only rendering corrections (not app bugs)

The script applies these so the web render matches how the app actually lays
out on device — neither reflects a real iOS problem:

1. **Bottom safe area.** Web has no iOS safe-area inset, so at an exact 896pt
   viewport the tab bar labels clip. The script renders 20pt taller and clips
   that slack off the (empty) top, keeping the output exactly 1242x2688.
2. **`min-width: 0` on text inputs.** react-native-web gives `<input>` an
   intrinsic default width, so the `flex: 1` weight/reps cells refuse to
   shrink and shove the RPE + check columns off-screen. Real RN has no
   intrinsic input width. The script also pins the RPE cells to their real
   46pt width so they can't collapse.

## Notes

- `node_modules/` and generated `*.png` are gitignored — only `capture.js`,
  this README, and `../../../../.gitignore` are committed.
- Chromium itself installs to a global Playwright cache, not into this folder.
- Screen 3: with sparse test data the Exercise Detail chart can be a flat
  line (same weight across sessions). `03b-calendar.png` is usually the
  stronger third store screenshot.
