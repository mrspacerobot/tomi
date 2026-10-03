# Tomi design mockups

Static HTML mockups, approved by the owner. Open a file in a browser. They are the visual specification for the app.

| File | What it holds | How to read it |
|---|---|---|
| `round3.html` | Lesson player, step scenes, Ask Tomi, voice, skill detail, profile, settings, edge states, dark theme, and the **handoff section** (tokens and components) | The source of truth for tokens, components and every screen it shows |
| `round2.html` | Onboarding, home before a scan, scan flow | Current, except: the notification and cupboard screens moved out of onboarding (see `round3.html`, ids `lp-notify` and `scan-review-first`), and unsure ingredients are not counted until confirmed |
| `round1.html` | Three directions compared | Only direction B, "Tasting menu", applies. It has the light home screen with a special (`dir-b-home`). Ignore A and C |

The mockups show the layout, not the content. Technique, course and level names come from `Tomi/Resources/Library/catalog.json`, which has moved on from the names drawn here (the mockups still say "Knife basics" and "Boil & blanch"). Streaks are weekly and ranks follow `GameRules`; the streak and rank figures in the mockups were updated to match.

Every screen has a stable `id` (for example `ob-cuisines`, `home-empty`, `lp-quiz-wrong`). Issues refer to screens by file and id.

`src/` holds the Python scripts that generated the pages. They are kept for reference and are not part of the app.
