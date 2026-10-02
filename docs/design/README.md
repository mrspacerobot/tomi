# Tomi design mockups

Static HTML mockups, approved by the owner. Open a file in a browser. They are the visual specification for the app.

| File | What it holds | How to read it |
|---|---|---|
| `round3.html` | Lesson player, step scenes, Ask Tomi, voice, skill detail, profile, settings, edge states, dark theme, and the **handoff section** (tokens and components) | The source of truth for tokens, components and every screen it shows |
| `round2.html` | Onboarding, home before a scan, scan flow | Current, except: the notification and cupboard screens moved out of onboarding (see `round3.html`, ids `lp-notify` and `scan-review-first`), and unsure ingredients are not counted until confirmed |
| `round1.html` | Three directions compared | Only direction B, "Tasting menu", applies. It has the light home screen with a special (`dir-b-home`). Ignore A and C |

Every screen has a stable `id` (for example `ob-cuisines`, `home-empty`, `lp-quiz-wrong`). Issues refer to screens by file and id.

`src/` holds the Python scripts that generated the pages. They are kept for reference and are not part of the app.
