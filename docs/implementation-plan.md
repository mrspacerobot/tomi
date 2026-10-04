# Tomi for iPhone: implementation plan

Status on 2 October 2026: design approved (direction "Tasting menu"), project scaffold built, Phase 0 partly done. This document is the build plan. Product background and business reasoning are in [plan.md](plan.md). Coding rules are in [../AGENTS.md](../AGENTS.md). Mockups are in [design/](design/).

## Goal

A native iPhone app where a cook answers a short onboarding, shows Tomi their fridge, corrects the ingredient list, and cooks a lesson from a reviewed library, hands-free, with timers and Ask Tomi. Progress (XP, streak, mastered techniques) survives a relaunch and syncs through iCloud.

## Decisions

| Topic | Decision |
|---|---|
| Platform | iOS 27, iPhone only, portrait. SwiftUI, SwiftData, Swift 6 strict concurrency |
| Design | Direction B, "Tasting menu": navy ink on paper, red stamp, the skill path as a menu of four courses and twelve dishes. Not a Duolingo look |
| Dependencies | No third-party dependencies in the app |
| Project | A standard Xcode project committed to git, with synchronized folders |
| Test phone | iPhone 15 Pro or newer (Apple Intelligence) |
| Everyday AI | Apple Foundation Models on the phone: ingredient spotting, ranking and adapting lessons, Ask Tomi, voice commands. Available in the iOS 27 simulator on the development Mac |
| Curriculum | Classical French technique and its kitchen words (mirepoix, roux, deglaze, monter au beurre, beurre blanc), without presenting the app as "French cooking". Twelve techniques in four courses (Foundations, Heat control, Sauces, Putting it together), each with levels |
| Lessons | Written in bulk by a top Claude model into a reviewed library. One file per lesson. Never generated live in version 1 |
| Tomi and step scenes | Drawn and animated in SwiftUI code from shared parts, behind one small interface so a richer mascot can replace it later |
| Onboarding | Nine screens: welcome, diet, things to avoid, cuisines, kitchen, experience and weekly goal, table and units, camera primer, done. Notifications are asked at the first timer, the cupboard at the first scan |
| Cuisines | Love, happy to try, or never, from day one. "Never" hides those dishes, including alternatives. Cuisines never gate skills. More arrive later as "guest menus" |
| Pantry | Saved cupboard staples, switchable per evening, plus typing anything the photo missed |
| Unsure ingredients | Not counted until the cook confirms them |
| Backend | Local first. iCloud (CloudKit) sync, a hosted signed lesson library, and one small Go service for anonymous ratings and usage events, all switched on before TestFlight. Own accounts and sync only if Android or web arrives |
| Languages | English first. All text in a string catalog |
| Plate photo | Optional, offered on the celebration card ("Show me the plate"). The streak day, XP and stamp are earned by finishing the lesson, never by the photo. Tomi makes one warm remark about what the technique should show, never a score and never a claim that the dish is cooked through or safe. The photo is kept with the dish on the menu and stays on the phone. Without Apple Intelligence it is kept with no remark. Mockup: `round3.html`, `lp-plate` |
| Streak and rank | The streak is the everyday hook and leads on home; rank is the slow, long goal behind it |
| Weekly streak | The cook sets a goal of 1 to 7 cooking days a week (default 3). The streak counts consecutive weeks with the goal met. Days, not cooks, so two lessons in one evening count once. The week in progress never breaks the streak, and each week is judged by the goal recorded with its cooks, so raising the goal never wipes an earned streak. Weeks follow the phone's calendar. The goal is asked on the experience screen (`ob-level`) and can be changed in Settings |
| Rank ladder | Novice, Commis, Cook, Saucier, Sous, Chef, Patron, Toque at 0, 150, 400, 900, 1,800, 3,300, 6,000 and 11,000 XP: Commis in the first week, Toque after about a year at three or four cooks a week. Then open-ended: Toque II, III and on, every 3,000 XP, about one a season. All in `GameRules` |

### Open decisions (default used until the owner decides)

| Question | Default |
|---|---|
| XP per cooked dish | 50, plus 10 for a correct quiz (the prototype's values; mockups show 40) |
| Wrong quiz answer | Costs nothing, the question returns in a later lesson |
| "I stopped early" | Does not count toward the streak |
| Hands-free mode | Keeps a slim Next button so touch always works |
| Onboarding extras | Weeknight time budget is not asked |

## Architecture

Three layers:

1. **Screens** (SwiftUI): onboarding, home and menu, scan, lesson player, Ask Tomi, profile and settings.
2. **App services**: ProgressStore (SwiftData), LessonLibrary, TomiAI (Foundation Models), Voice (speech in and out), Timers (AlarmKit). Each sits behind a protocol with a fake for previews and tests.
3. **TomiCore** (plain Swift package): skill catalog schema and validator, progress rules, lesson schema, lesson matcher, ingredient table, safety table. Shared with the lesson generator.

```
Tomi.xcodeproj
Tomi/                  app target
  DesignSystem/        tokens, components, TomiMascot
  Onboarding/ Home/ Menu/ Scan/ Player/ Scenes/ AskTomi/ Voice/ Settings/
  AI/                  Foundation Models implementations
  Persistence/         SwiftData models, ProgressStore
  Library/             LessonLibrary (protocol), BundledLessonLibrary over the file reader BundledLibrary, FakeLessonLibrary
  Resources/           Assets, fonts, Localizable.xcstrings, Library/ (catalog.json, ingredients.json, lessons/<skill>/<lesson id>.lesson.json)
TomiTests/ TomiUITests/
Packages/TomiCore/     rules, schema, generator, tests
server/                Go service (later)
docs/ prototype/
```

### From fridge photo to tonight's special

1. Photo (or typed list).
2. On-device model returns a typed ingredient list.
3. The cook confirms: fridge items, unsure items, cupboard staples, anything typed.
4. Code filters the library by unlocked skill, diet, things to avoid, cuisine "never", equipment, ingredients.
5. On-device model ranks the short list and applies listed swaps and servings.
6. Code re-checks the result against the safety table and the avoid list.
7. The special appears on home with up to two alternatives.

Without Apple Intelligence: step 2 is skipped (typed list) and step 5 is replaced by ranking on ingredient overlap.

## Lesson library

- The skill catalog is part of the library, not the app: `catalog.json` holds courses, skills, prerequisites, levels and their names, with a schema version and a library version. A new technique or level ships with the library, without an app release. The validator checks at least one course, ids that are not blank and are unique, known and non-empty courses, prerequisites that exist and come earlier on the menu, levels numbered 1 to n, and English text everywhere.
- Each skill has levels, from the first version of the technique to the hardest (roux: white for béchamel, blond for velouté, brown). A level is complete after two finished cooks at it (`GameRules.cooksToCompleteLevel`), and the next level opens once every level before it is complete.
- A skill is served (unlocked) when level 1 of every prerequisite is complete, and mastered when all of its own levels are complete. Asking for every level of a prerequisite would hold the next techniques back for weeks.
- A finished cook always counts at the level its lesson taught, even if that level or skill was not open yet, so progress depends only on which cooks are in the log and never on the order two devices merged them. A cook stopped early never counts. A cook of a lesson this version's library does not know still counts, because the entry records its own skill and level; a cook of an unknown skill or level is ignored for progress.
- The focus (next up) is the cook's chosen skill while it is served and not mastered, otherwise the first such skill in menu order.
- A cook who answers "comfortable" in onboarding gets every technique of the first course on the menu as mastered. It is an input to the progress rules (`ProgressRules(catalog:experience:)`), read from the catalog, never a fake entry in the cook log, so it earns no XP and no streak. "Never" and "basics" grant nothing; they differ only in how much Tomi explains.
- One file per lesson, grouped by skill: `lessons/<skill>/<lesson id>.lesson.json`. The app bundle is flat, so the `.lesson.json` ending is what marks a lesson file and the id in the name keeps it unique. An index built by the generator, carrying the library and schema versions and every field the filter needs, comes with the generator (#32); until then the app reads every lesson file.
- Each lesson (schema version 1, `Lesson` in TomiCore) has a stable id, a revision, a skill and level, a cuisine, a title, a time in minutes, why-this and concept text, ingredients, equipment, steps, a quiz, and swaps. All words are `LocalizedText`, English required.
- Each ingredient line names an ingredient of the table and its amount twice, in metric and in cups. An amount is a number and a unit from a closed list (gram, millilitre, cup, tablespoon, teaspoon, piece), never free text, so code can scale servings and format units. Step text names no amounts.
- Each step has text, an optional tip, a scene from the closed scene list (`StepScene`) and an optional timer in seconds, four hours at most (`LessonStep.longestTimerSeconds`). The quiz has a question, two or more answers, the position of the right one and an explanation.
- The validator (`Lesson.issues(catalog:table:)`) lists every problem: a blank id or cuisine, an unknown skill or level, a revision or time below 1, no ingredients, a duplicate or unknown ingredient, an amount that is not positive or uses a unit of the other system, no steps, an unknown scene or main, a timer that is not positive or runs over four hours, fewer than two answers, a missing or out-of-range correct answer, a swap of an ingredient the lesson lacks, a swap replacement that is unknown or already in the lesson, and missing English text. A file from another schema version, or with a field the schema does not have, is rejected before that.
- Every step names a scene from the closed scene list, and the lesson names its main food (`DishMain`: chicken, tofu, omelette), which the scenes that show the food draw. A scene must show what the step does, with the right vessel and tool. When none fits, the scene is drawn in the kit first: there is no blank or fallback drawing. A lesson that names a scene or main an older app does not know is not shown there until the app is updated, so new scenes ship in the app before a library uses them.
- Diet and allergen tags are computed from the ingredient table (`Lesson.tags(in:)`), never typed, never stored in the lesson file and never produced by a model. An ingredient the table does not know is an error, never "suitable".
- The ingredient table (`ingredients.json`) declares everything about who may eat what: the list of facts an ingredient can have, the avoid items with the facts that trigger each, the diets with the facts each rules out, and every ingredient with its facts. Code names none of them, so a new avoid item or diet is a data change. The validator replaces the compiler: undeclared facts, unknown fields, an avoid item nothing triggers and a diet that rules nothing out all reject the file.
- The filter fails closed. An ingredient the table does not list is an error. A diet or avoid item in the cook's preferences that the table does not list, including one saved by a newer app or one that could not be read, makes every dish unavailable until the cook updates or answers again.
- A model never adds to the lists. Skills, levels, facts, avoid items, diets and ingredients are added only by a person in a reviewed change. The generator writes lessons only, from closed lists read out of the catalog and the ingredient table.
- A swap is a reviewed substitution of one ingredient of the lesson for another ingredient of the table, with its own amounts, that removes an allergen or changes the diet (butter to olive oil removes dairy). `Lesson.applying(_:)` gives the swapped lesson, and its tags are computed again.
- The app reads the library through the `LessonLibrary` protocol (catalog, ingredient table, lessons). `BundledLessonLibrary` reads the app bundle; a lesson file that fails validation is skipped and logged, never shown. `FakeLessonLibrary` serves previews and tests.
- Coverage rule: every skill has several lessons for every diet, even after any one cuisine is excluded. The generator reports gaps.
- The library ships in the app and can be replaced by a newer signed download, so a lesson can be fixed or withdrawn the same day.

## Saved data

| Model | Fields |
|---|---|
| Profile | focus skill, weekly goal, voice on, diet, avoid list, cuisine preferences, cupboard staples, equipment, experience, servings, units, onboarding done |
| CookLog | lesson id, lesson revision, skill, level, date, stopped early, weekly goal at the time, swaps used, quiz correct, XP earned, rating, plate photo file name |
| ActiveLesson | the adapted lesson, tonight's ingredient list, current step |

Plate photos are files in the app's own storage on the phone. Only the file name is in the cook log, so the log syncs through iCloud and the photos do not; on a second device the dish simply shows without a photo.

The cook log is the source of truth. XP, rank, streak and mastery are computed from it. Screens ask one place for the game: `GameStateRules` in TomiCore gives total XP, rank and streak for a log at a moment. An entry stopped early earns no XP, and an entry for a skill or level the menu no longer knows still earns XP and still counts for the streak. Every record has a stable id and timestamp, and the same id on two devices is the same cook, counted once. All fields are optional or defaulted and changes are additive, so the layout is safe for iCloud.

The cook's answers are one value, `CookPreferences` in TomiCore. Experience and units are closed lists in code, because code decides what they do. Diets, avoid items, equipment, cuisines and cupboard staples are ids that arrive with the library, so adding one is a data change, and a cuisine without an answer counts as "try". The diets and avoid items the onboarding screens offer, with their names, are listed in the ingredient table data next to the ingredients they describe. The equipment list, its names and the kitchen Tomi assumes until the cook answers are library data too. No diet means the cook eats everything. Equipment and units stay unset until the cook picks, and follow the library's standard kitchen and the locale until then. Reading saved preferences never fails on a single field: a missing field keeps its default, and a value only a newer app knows is dropped (from a closed list) or falls back to the default (a single answer). Diet and avoid answers are never weakened: every saved id is kept, and a field that is there but cannot be read becomes the blank id. A diet or avoid id the ingredient table does not know, the blank one included, makes every dish unavailable, so every library validator must reject blank ids.

## Phases

Each phase ends with something runnable. GitHub milestones mirror these.

| # | Phase | Done when |
|---|---|---|
| 0 | Toolchain and scaffold | The app runs in the simulator and on the owner's iPhone, checks run from the command line, and five real fridge photos have been read by the on-device model |
| 1 | Design pass | Done. Mockups approved in `docs/design/` |
| 2 | Rules and design system | Every rule is in TomiCore with tests, and a gallery of every component matches the mockups in light and dark |
| 3 | Onboarding, home, menu, saved progress | A fresh install walks through onboarding, answers survive a force-quit, and "vegetarian" changes the example special |
| 4 | Lesson player | The example lesson can be cooked start to finish, earning XP, a day toward the weekly goal and a stamp |
| A | Milestone | A real app in Tomi's own design, no AI yet |
| 5 | Lesson library | The app picks among real library lessons for a typed list, and a vegan nut-free profile is never shown a dish it cannot eat |
| 6 | Fridge scan | A real fridge photo produces a sensible special, and the same flow works without Apple Intelligence. A plate photo can be kept after a cook |
| 7 | Ask Tomi | Safety questions are always answered from the table, in any phrasing tried. Tomi remarks on a plate photo without ever judging doneness |
| 8 | Hands-free voice | A lesson can be finished without touching the phone, with an extractor fan running |
| B | Milestone | Everything in the README works on device |
| 9 | Sync, backend, proof and polish | iCloud sync, hosted library and ratings service are live, a friend installs from TestFlight and cooks dinner |

## Verification

- Rules: unit tests in TomiCore, written first.
- Flows: UI tests that tap through the app in the simulator against fake AI, camera and clock.
- Screens: run in the simulator after every change and compare with the mockup, light and dark, small and large phones, largest text size.
- Real AI, camera and microphone: a short checklist for the owner to run on the iPhone at the end of each AI phase.

## Risks

- **The on-device model may read fridges badly.** Tested in Phase 0 before any scan UI. The scanner sits behind a protocol, so Apple's cloud model or Claude can replace it.
- **Allergens are a safety feature.** Tags come from one reviewed table that only a person changes, an unknown ingredient, diet or avoid item refuses the dish, the filter runs again after AI adaptation, and the app never claims a dish is "safe".
- **Diets and cuisines multiply the library** to roughly 150 to 200 lessons. Generation is cheap; human spot-checking is the real cost.
- **A live iCloud layout can only grow.** The saved-data design is a review point before TestFlight.
- **Not every iPhone has Apple Intelligence.** The typed path and code-only ranking must always work.
- **Motion carries the reward.** The stamp press and the menu line inking in cannot be judged from stills and need an early prototype.
