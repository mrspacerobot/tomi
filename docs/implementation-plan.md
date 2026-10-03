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
| Onboarding | Nine screens: welcome, diet, things to avoid, cuisines, kitchen, experience, table and units, camera primer, done. Notifications are asked at the first timer, the cupboard at the first scan |
| Cuisines | Love, happy to try, or never, from day one. "Never" hides those dishes, including alternatives. Cuisines never gate skills. More arrive later as "guest menus" |
| Pantry | Saved cupboard staples, switchable per evening, plus typing anything the photo missed |
| Unsure ingredients | Not counted until the cook confirms them |
| Backend | Local first. iCloud (CloudKit) sync, a hosted signed lesson library, and one small Go service for anonymous ratings and usage events, all switched on before TestFlight. Own accounts and sync only if Android or web arrives |
| Languages | English first. All text in a string catalog |

### Open decisions (default used until the owner decides)

| Question | Default |
|---|---|
| XP per cooked dish | 50, plus 10 for a correct quiz (the prototype's values; mockups show 40) |
| Rank ladder | Novice, Commis, Cook, Saucier, Sous, Chef, Patron, Toque, 150 XP each. At this rate a regular cook reaches Toque in about six weeks, so steeper or open-ended steps are likely |
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
  Library/             BundledLibrary: reads the shipped library
  Resources/           Assets, fonts, Localizable.xcstrings, Library/ (catalog.json, lessons/)
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

- The skill catalog is part of the library, not the app: `catalog.json` holds courses, skills, prerequisites, levels and their names, with a schema version and a library version. A new technique or level ships with the library, without an app release. The validator checks unique ids, known and non-empty courses, prerequisites that exist and come earlier on the menu, levels numbered 1 to n, and English text everywhere.
- Each skill has levels, from the first version of the technique to the hardest (roux: white for béchamel, blond for velouté, brown). The next level opens once the one before is cooked.
- One file per lesson, grouped by skill, plus an index built by the generator carrying the library and schema versions. The index holds every field the filter needs, so a full lesson is read only once it is picked.
- Each lesson has a stable id, a revision, a skill and level, a cuisine, ingredients, equipment, steps (each naming a scene from the closed scene list), a quiz, and swaps.
- Diet and allergen tags are computed from the ingredient table, never typed and never produced by a model.
- A swap is a reviewed substitution that removes an allergen or changes the diet (butter to olive oil removes dairy).
- Coverage rule: every skill has several lessons for every diet, even after any one cuisine is excluded. The generator reports gaps.
- The library ships in the app and can be replaced by a newer signed download, so a lesson can be fixed or withdrawn the same day.

## Saved data

| Model | Fields |
|---|---|
| Profile | focus skill, voice on, diet, avoid list, cuisine preferences, cupboard staples, equipment, servings, units, onboarding done |
| CookLog | lesson id, lesson revision, skill, level, date, swaps used, quiz correct, XP earned, rating |
| ActiveLesson | the adapted lesson, tonight's ingredient list, current step |

The cook log is the source of truth. XP, rank, streak and mastery are computed from it. Every record has a stable id and timestamp. All fields are optional or defaulted and changes are additive, so the layout is safe for iCloud.

## Phases

Each phase ends with something runnable. GitHub milestones mirror these.

| # | Phase | Done when |
|---|---|---|
| 0 | Toolchain and scaffold | The app runs in the simulator and on the owner's iPhone, checks run from the command line, and five real fridge photos have been read by the on-device model |
| 1 | Design pass | Done. Mockups approved in `docs/design/` |
| 2 | Rules and design system | Every rule is in TomiCore with tests, and a gallery of every component matches the mockups in light and dark |
| 3 | Onboarding, home, menu, saved progress | A fresh install walks through onboarding, answers survive a force-quit, and "vegetarian" changes the example special |
| 4 | Lesson player | The example lesson can be cooked start to finish, earning XP, a streak day and a stamp |
| A | Milestone | A real app in Tomi's own design, no AI yet |
| 5 | Lesson library | The app picks among real library lessons for a typed list, and a vegan nut-free profile is never shown a dish it cannot eat |
| 6 | Fridge scan | A real fridge photo produces a sensible special, and the same flow works without Apple Intelligence |
| 7 | Ask Tomi | Safety questions are always answered from the table, in any phrasing tried |
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
- **Allergens are a safety feature.** Tags come from one code-owned table, unknown ingredients fail the build, the filter runs again after AI adaptation, and the app never claims a dish is "safe".
- **Diets and cuisines multiply the library** to roughly 150 to 200 lessons. Generation is cheap; human spot-checking is the real cost.
- **A live iCloud layout can only grow.** The saved-data design is a review point before TestFlight.
- **Not every iPhone has Apple Intelligence.** The typed path and code-only ranking must always work.
- **Motion carries the reward.** The stamp press and the menu line inking in cannot be judged from stills and need an early prototype.
