# Tomi design mockups

Static HTML mockups, approved by the owner. Open a file in a browser. They are the visual specification for the app.

The approved look is the **Cooking Show** (20 November 2026, epic #201): rounds 13 to 15 and their handoff. Rounds 1 to 3 are the earlier "Tasting menu" look, which the app still wears until #201 moves every screen; use them only for screens and behaviour the Cooking Show rounds do not show. The rounds in between (4 to 12) were explorations and are not kept here.

| File | What it holds | How to read it |
|---|---|---|
| `cooking-show-handoff.html` | Every token the Cooking Show mockups use: colours in the morning (light) and evening (dark) show, type, radii, shadows, spacing, the haptics of the Feel section, and the show words | The source of truth for tokens and the show words |
| `round13-cooking-show-all.html` | All 37 screens in five parts: opening night (sign-in, onboarding), the guide (Home, skills, settings), fridge to dish, showtime (cooking, quiz), off air (errors). Lighting switch at the top | The source of truth for every screen it shows |
| `round14-photos.html` | Real photos in the show: the fridge photo labelled (8A to 8C) and the dish photo (9A to 9C) | A direction, not a decision: which option ships waits for tomi-backend#56. Photos and their licences are in `photos/` (`photos/CREDITS.md`) |
| `round15-missing-screens.html` | 18 more screens: launch, email confirmation, sign-in error, permission primers, changing one answer, Tomi's voice, rating, missing episode, streak lost, season finale, and sketches of later phases | Current for screens the app has today. New behaviour (rating, reminders, missing episode, season finale) and the later-phase sketches each need their own decision and issue first |
| `round3.html` | Lesson player, step scenes, Ask Tomi, voice, skill detail, profile, settings, edge states, dark theme, and the **handoff section** (tokens and components) | Tasting menu. Was the source of truth for tokens and components until the Cooking Show; still describes the tokens for screens awaiting their migration |
| `round2.html` | Onboarding, home before a scan, scan flow | Current, except: the notification and cupboard screens moved out of onboarding (see `round3.html`, ids `lp-notify` and `scan-review-first`), and unsure ingredients are not counted until confirmed |
| `round1.html` | Three directions compared | Only direction B, "Tasting menu", applies. It has the light home screen with a special (`dir-b-home`). Ignore A and C |
| `companion-directions.html` | Three directions for how Tomi looks and moves, with the 3D companion of #94 they replace | Only direction A, "Broadcast cartoon", applies (#137): the reference for Tomi's proportions, line, face, gloves and timing everywhere he is drawn. `companion.md` is its handoff |

The mockups show the layout, not the content. Technique, course and level names come from `Tomi/Resources/Library/catalog.json`, which has moved on from the names drawn here (the mockups still say "Knife basics" and "Boil & blanch"). Streaks are weekly and ranks follow the server's game rules (tomi-backend); the streak and rank figures in the mockups were updated to match.

Every screen of rounds 1 to 3 has a stable `id` (for example `ob-cuisines`, `home-empty`, `lp-quiz-wrong`). Issues refer to those screens by file and id. The Cooking Show rounds draw their screens with a script and have no ids: issues refer to them by file, part and screen name, for example round 13, part 2, "Episode guide". They open in the evening show; add `#day` to the address, or use the Lighting switch, for the morning show.

`src/` holds the Python scripts that generated the pages. They are kept for reference and are not part of the app.
