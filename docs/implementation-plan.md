# Tomi for iPhone: implementation plan

Status on 10 October 2026: design approved (direction "Tasting menu"), project scaffold built, Phase 0 partly done. The app is becoming a thin client of Tomi's Rust backend (`tomi-backend`): the backend owns the food lists, the profile, the fridge scan and tonight's special, and (decided 26 October 2026) the cook log, every progress rule and the quiz. This document is the build plan. Product background and business reasoning are in [plan.md](plan.md). Coding rules are in [../AGENTS.md](../AGENTS.md). Mockups are in [design/](design/).

## Goal

A native iPhone app where a cook answers a short onboarding, shows Tomi their fridge, corrects the ingredient list, and cooks a lesson from a reviewed library, hands-free, with timers and Ask Tomi. Progress (XP, rank, weekly streak, mastered techniques) is the server's, per Supabase account, so it follows the cook to any device: the phone sends each cook to the server and shows the server's progress snapshot, offline with a note that pending cooks will count once back online. Today the app still computes progress from a local cook log, until the steps of [Progress and the quiz on the server](#progress-and-the-quiz-on-the-server-157) replace it. CloudKit sync is off.

## Decisions

| Topic | Decision |
|---|---|
| Platform | iOS 27, iPhone only, portrait. SwiftUI, SwiftData, Swift 6 strict concurrency |
| Design | Direction B, "Tasting menu": navy ink on paper, red stamp, the skill path as a menu of four courses and twelve dishes. Not a Duolingo look |
| Dependencies | No third-party dependencies in the app |
| Project | A standard Xcode project committed to git, with synchronized folders |
| Pull request evidence | Every PR uses `.github/pull_request_template.md`. UI tasks embed current screenshots of the running app in light and dark; capture or posting blockers keep the PR in draft. Capture and posting instructions are in `agent-on-pull-requests.md` |
| Test phone | Any iPhone that runs iOS 27. No on-device AI is needed |
| Everyday AI | On Tomi's server, not the phone: reading fridge photos. Deterministic server code ranks tonight's suggestions. No Foundation Models in the app. When the server's model is unavailable (`503 ai_unavailable`) the cook types and the server ranks by ingredient overlap. Ask Tomi and voice are not decided yet |
| Food knowledge | The server owns the ingredient table, facts, diets, avoid items, cuisines, equipment and every filter. The app holds no such list or rule: it shows `GET /v1/options` and sends back ids. Its one food check is a guard: a suggestion is shown only if the server checked it for the cook's diet and every avoid item |
| Sign-in | Supabase Auth with Sign in with Apple, without a third-party SDK. Request email so Supabase Auth can store the contact address, including Apple's private relay address. Tokens in the Keychain |
| Fridge photos | Sent to the server as a small JPEG (1280 px on the long side, quality 0.6) under 10 MB, with the photo's place and time. Proof of concept: the server keeps every photo and nothing asks the cook yet. Friends test it through TestFlight without one; a consent step must come before the app is offered outside TestFlight |
| Curriculum | Classical French technique and its kitchen words (mirepoix, roux, deglaze, monter au beurre, beurre blanc), without presenting the app as "French cooking". Twelve techniques in four courses (Foundations, Heat control, Sauces, Putting it together), each with levels |
| Lessons | Written in bulk by a top Claude model into a reviewed library. One file per lesson. Never generated live in version 1 |
| Tomi and step scenes | Code-drawn in SwiftUI. Tomi is a flat broadcast cartoon (direction A of `docs/design/companion-directions.html`, #137): thick ink line, a face that fills the body, rubber-hose limbs with white gloves, squash and stretch. One drawing serves the animated companion (idle, listening, thinking, explaining and celebrating) and the printed mascot, which holds a still pose. It replaces the RealityKit companion of #94. Callers supply the state; the companion opens no microphone or AI session |
| Onboarding | Nine screens: welcome, diet, things to avoid, cuisines, kitchen, experience and weekly goal, table and units, camera primer, done. Notifications are asked at the first timer. The cupboard is in settings for now; asking it at the first scan is still to be built |
| Cuisines | Love, happy to try, or never, from day one. "Never" hides those dishes, including alternatives. Cuisines never gate skills. More arrive later as "guest menus" |
| Pantry | Saved cupboard staples, switchable per evening, plus typing anything the photo missed |
| Unsure ingredients | Not counted until the cook confirms them |
| Backend | Tomi's Rust API on Cloud Run with Supabase (Auth, Postgres, storage). It keeps the cook's profile, the cook log, every progress rule and the quiz. The phone keeps a copy of the profile, an outbox of unsent cooks and the last progress snapshot |
| Languages | English first. All text in a string catalog |
| Plate photo | Optional, offered on the celebration card ("Show me the plate"). The streak day, XP and stamp are earned by finishing the lesson, never by the photo. Tomi makes one warm remark about what the technique should show, never a score and never a claim that the dish is cooked through or safe. The photo is kept with the dish on the menu and stays on the phone. How the remark is made, now that no AI runs on the phone, is not decided. Mockup: `round3.html`, `lp-plate` |
| Progress and quiz | Decided 26 October 2026: the server owns the cook log, the progress rules (XP, rank, weekly streak, levels, unlocks, mastery, grants, focus) and the game numbers, per Supabase account. The phone is a thin client: it writes each cook to an outbox with a client-made UUID, uploads it with retry and backoff (`POST /v1/cook-entries`, idempotent on the id), and shows the server's snapshot (`GET /v1/progress`). It never predicts XP or rank. The quiz is run by the server (`POST /v1/quiz-answers`): correct answers never leave it, the first answer counts, and the quiz needs a connection. The phone never sends `quizCorrect`. Details in [the section below](#progress-and-the-quiz-on-the-server-157) |
| Streak and rank | The streak is the everyday hook and leads on home; rank is the slow, long goal behind it |
| Weekly streak | The cook sets a goal of 1 to 7 cooking days a week (default 3). The streak counts consecutive weeks with the goal met. Days, not cooks, so two lessons in one evening count once. The week in progress never breaks the streak, and each week is judged by the goal recorded with its cooks, so raising the goal never wipes an earned streak. Weeks follow the cook's calendar: each cook entry stores its own IANA time zone and past weeks are judged by it; the current week is judged by the time zone and first weekday sent with the request. The server computes it. The goal is asked on the experience screen (`ob-level`) and can be changed in Settings |
| Rank ladder | Novice, Commis, Cook, Saucier, Sous, Chef, Patron, Toque at 0, 150, 400, 900, 1,800, 3,300, 6,000 and 11,000 XP: Commis in the first week, Toque after about a year at three or four cooks a week. Then open-ended: Toque II, III and on, every 3,000 XP, about one a season. The server's game module holds these numbers with versioned rules. TomiCore's `GameRules` still holds a copy until its removal (#167), after the server's ports of its tests prove parity |

### Open decisions (default used until the owner decides)

| Question | Default |
|---|---|
| XP per cooked dish | 50, plus 10 for a correct quiz (the prototype's values; mockups show 40). The server's numbers |
| Wrong quiz answer | Costs nothing. Only the first answer to each question scores; retrying teaches |
| Rank names | Sent by the server, localized like course names, so a title changes without an app release. Alternative: kept in the string catalog by `rank.id` |
| Cook logs already on development phones | Uploaded through the outbox with `lessonId`. No TestFlight build ever wrote one |
| A cook the server acknowledged | Deleted from the phone; the server is the source of truth |
| Unsent cooks | Never expire |
| "I stopped early" | Does not count toward the streak |
| Hands-free mode | Keeps a slim Next button so touch always works |
| Onboarding extras | Weeknight time budget is not asked |
| Voice upload | Chat and voice stay on the phone. Fridge photos already go to the server under the proof-of-concept decision above |

## Architecture

Current app responsibilities (backend target and remaining contracts: [backend-spec.md](backend-spec.md)):

1. **Screens** (SwiftUI): onboarding, home and menu, scan, lesson player, Ask Tomi, profile and settings.
2. **App services**: TomiAPI (Tomi's server over URLSession), AuthService (Supabase with Sign in with Apple), ProgressStore (SwiftData: profile copy, cook log as the outbox of unsent cooks, and the last progress snapshot), the outbox uploader (#162), LessonLibrary, Voice (speech in and out), Timers (AlarmKit). Each sits behind a protocol with a fake for previews and tests.
3. **TomiCore** (plain Swift package): skill catalog schema and validator, lesson schema, the server's answers and requests (including the progress snapshot, cook-entry results and quiz answers), the outbox rules, and the checked-suggestion guard. No food rules and no progress rules: those are the server's. The old progress rules (`Game`, the rule files of `Progress`) stay only until #167.

```
Tomi.xcodeproj
Tomi/                  app target
  DesignSystem/        tokens (ColorRole and Tokens.xcassets, TextStyle, Spacing, Radius, RuleWeight), components, TomiMascot
  Onboarding/ Home/ Menu/ Scan/ Player/ Scenes/ AskTomi/ Voice/ Settings/
  Auth/                AuthService (protocol), SupabaseAuthService, Keychain token store, Sign in with Apple button, fakes
  Backend/             TomiAPI (protocol), URLSessionTomiAPI over APIClient, FakeTomiAPI, BackendConfiguration
  Flow/                AppServices, AppFlowModel (sign in, onboarding, home), ProfileModel and its cache
  Persistence/         SwiftData records, ProgressStore (protocol), SwiftDataProgressStore, InMemoryProgressStore
  Progress/            the progress the screens read: the server's last snapshot and the outbox count (ProgressModel, #163)
  Library/             LessonLibrary (protocol), BundledLessonLibrary over the file reader BundledLibrary, FakeLessonLibrary
  Resources/           Assets, fonts, Localizable.xcstrings, Library/ (catalog.json, lessons/<skill>/<lesson id>.lesson.json)
Config/                Tomi-Info.plist: the bundled fonts and the backend addresses taken from build settings
TomiTests/ TomiUITests/
Packages/TomiCore/     current rules and schema; retain local safety guard and offline decoding
../tomi-backend/        Separate Rust Tomi API repository
docs/ prototype/
```

### Shared components

`Tomi/DesignSystem` supplies `TomiButtonStyle`, `TickRow`, `Chip`, `UseTag`, `StatsColumns`,
`DoubleRuledBox`, `ProgressRule` and their shared rules and icons. The states follow the component cards
in `docs/design/round3.html`; interactive states have localized accessibility words and at least 44-point
touch targets. At accessibility text sizes tick-row notes and stats stack, chip names wrap, and box flags
grow with their text. Selection rules live in TomiCore (`Selection`).

Chips use SwiftUI's `Layout` protocol through `FlowLayout`; its required four-parameter
`placeSubviews(in:proposal:subviews:cache:)` is the exception documented in `AGENTS.md` and the layout
folder's lint configuration. `FlowCursor` holds the tested placement arithmetic.

A debug build launched with `--component-gallery` opens a small interactive gallery for component UI tests
and visual comparison. `--gallery-section` opens at a named section for screenshots. Release builds contain
no gallery screen or launch-argument handling. The full gallery remains #12.

The debug gallery also opens the animated cartoon companion (#137). `TomiCompanion` accepts a
`CompanionState` and an optional Reduce Motion override. It is drawn in a SwiftUI `Canvas` from shared
parts, samples its pose from the animation timeline's elapsed time, pauses when hidden or inactive, and
shows a distinct, complete still pose for each state when Reduce Motion is on. `TomiMascot` draws the same
character holding a still pose. See [the companion handoff](design/companion.md) for the character, its
states, its motion and inspection steps.

### From fridge photo to tonight's special

1. Photo (or typed list). The app sends a JPEG to `POST /v1/scans`; the server's model returns items, each matched to an ingredient of its table or not.
2. The cook confirms: sure items start ticked, unsure and unmatched ones do not count until ticked; typed words go to `POST /v1/ingredients/resolve`, and the cook picks when one is ambiguous. The server adds the cupboard staples.
3. `POST /v1/lessons/suggest`: the server filters the cooking graph's recipes by the cook's level, diet, things to avoid, cuisine "never" and kitchen, plans the safe swaps and omissions, writes the recipe already adapted for the cook (`recipe`, `changes`), ranks them and says what it checked. Since tomi-backend #17 a suggestion is a graph recipe with its safe plan, not a lesson file.
4. The app shows the special and up to two alternatives that pass the checked-restrictions guard, with swaps, missing ingredients and the reason. No dish yet is a kind empty state, never an error.
5. The lesson player opens the lesson file on the phone at the offered revision, with the offered swaps, and works offline. Graph suggestions have no lesson file; how to cook one is decided in #135 before it is built.

Without the server's model (`503 ai_unavailable`) step 1 falls back to typing; deterministic server code ranks by ingredient overlap.

## Lesson library

The files and validators below describe the current bundled library. The Rust service will publish reviewed, versioned library and safety snapshots as specified in [backend-spec.md](backend-spec.md); the app keeps compatible reviewed lessons for offline cooking.

- The skill catalog is part of the library, not the app: `catalog.json` holds courses, skills, prerequisites, levels and their names, with a schema version and a library version. A new technique or level ships with the library, without an app release. The validator checks at least one course, ids that are not blank and are unique, known and non-empty courses, prerequisites that exist and come earlier on the menu, levels numbered 1 to n, and English text everywhere.
- Each skill has levels, from the first version of the technique to the hardest (roux: white for béchamel, blond for velouté, brown). When a level is complete, when a skill is served (unlocked) or mastered, which skill is the focus, and what the "comfortable" experience answer grants are the server's progress rules, written down in tomi-backend (`docs/progress.md`). TomiCore's `ProgressRules` still applies today's copy of them until #167; the app shows what the server's snapshot says.
- One file per lesson, grouped by skill: `lessons/<skill>/<lesson id>.lesson.json`. The app bundle is flat, so the `.lesson.json` ending is what marks a lesson file and the id in the name keeps it unique. An index built by the generator, carrying the library and schema versions and every field the filter needs, comes with the generator (#32); until then the app reads every lesson file.
- Each lesson (schema version 1, `Lesson` in TomiCore) has a stable id, a revision, a skill and level, a cuisine, a title, a time in minutes, why-this and concept text, ingredients, equipment, steps, a quiz, and swaps. All words are `LocalizedText`, English required.
- Each ingredient line names an ingredient of the table and its amount twice, in metric and in cups. An amount is a number and a unit from a closed list (gram, millilitre, cup, tablespoon, teaspoon, piece), never free text, so code can scale servings and format units. Step text names no amounts.
- Each step has text, an optional tip, a scene from the closed scene list (`StepScene`) and an optional timer in seconds, four hours at most (`LessonStep.longestTimerSeconds`). The quiz has a question, two or more answers, the position of the right one and an explanation. This is the bundled lesson format only, kept until #156; a graph recipe's quiz is run by the server and its answers never reach the app.
- The app's validator (`Lesson.issues(in:)`, against the catalog) lists every problem the player would trip on: a blank id or cuisine, an unknown skill or level, a revision or time below 1, no ingredients, a duplicate ingredient, an amount that is not positive or uses a unit of the other system, no steps, an unknown scene or main, a timer that is not positive or runs over four hours, fewer than two answers, a missing or out-of-range correct answer, a swap of an ingredient the lesson lacks, a swap replacement already in the lesson, and missing English text. Whether every ingredient and piece of equipment exists is checked by the server against its own tables. A file from another schema version, or with a field the schema does not have, is rejected before that.
- Every step names a scene from the closed scene list, and the lesson names its main food (`DishMain`: chicken, tofu, omelette), which the scenes that show the food draw. A scene must show what the step does, with the right vessel and tool. When none fits, the scene is drawn in the kit first: there is no blank or fallback drawing. A lesson that names a scene or main an older app does not know is not shown there until the app is updated, so new scenes ship in the app before a library uses them.
- A model never adds to the lists. Skills and levels are added only by a person in `catalog.json`; facts, avoid items, diets, ingredients and equipment only by a person on the server. Diet and allergen tags and coverage per diet are the server's.
- A swap is a reviewed substitution of one ingredient of the lesson for another, with its own amounts (butter to olive oil). The server picks swaps and checks the swapped dish; the player applies only swaps the suggestion names and the lesson lists (`Lesson.applying(listed:)`).
- The app reads the library through the `LessonLibrary` protocol (catalog, lessons). `BundledLessonLibrary` reads the app bundle; a lesson file that fails validation is skipped and logged, never shown, and without a catalog no lesson is served. `FakeLessonLibrary` serves previews and tests.
- The library ships in the app and can be replaced by a newer signed download, so a lesson can be fixed or withdrawn the same day.

## Saved data

This section describes the current SwiftData implementation and its safe migration inputs. The Rust service's target records and ownership are in [backend-spec.md](backend-spec.md). The server's cook log is the source of truth for progress; on the phone the cook log becomes the outbox of cooks not yet acknowledged by the server (#159, #161, #162). Do not remove a local cook entry until the server has acknowledged it.

The store is SwiftData, behind the `ProgressStore` protocol (`Tomi/Persistence`). Screens see only the protocol; `SwiftDataProgressStore` is the store on the phone, `InMemoryProgressStore` the fake for previews and tests, and `UnavailableProgressStore` the one Tomi holds when the real store could not be opened.

The stored records and their fields. These names, and the names of the four record types, are permanent once released: fields are added, never renamed, removed or reused. Every field is optional and nothing is unique.

| Record | Stored fields |
|---|---|
| `ProfileRecord` | `stableID`, `updatedAt`, `diet`, `avoid`, `cuisinesLoved`, `cuisinesToTry`, `cuisinesNever`, `cupboardStaples`, `cupboardAnswered`, `equipment`, `experience`, `servings`, `units`, `weeklyGoal`, `focusSkill`, `onboardingDone` |
| `CookLogRecord` | `stableID`, `lesson`, `skill`, `level`, `date`, `stoppedEarly`, `quizCorrect`, `weeklyGoal`, `refusedCode`, `timeZone`, `account` |
| `ActiveLessonRecord` | `stableID`, `updatedAt`, `lesson`, `lessonRevision`, `swappedOut`, `swappedIn`, `ingredients`, `currentStep` |
| `ProgressSnapshotRecord` | `stableID`, `receivedAt`, `body` |

Added in #162: `account` on `CookLogRecord`, the id of the signed-in account that cooked it (the `sub` of its access token, read by `AuthSession.accountID`). Only that account sends the cook (`pendingCookEntries(for:)`), so cooks saved by one cook are never uploaded with the credentials of the next cook who signs in on the same phone, where the server would credit them to the wrong account. A cook saved without an account, or before the field existed, stays on the phone and is never sent.

Added in #161: `refusedCode` and `timeZone` on `CookLogRecord`, and the record `ProgressSnapshotRecord`. `refusedCode` is the server's problem code when it rejected the entry, so it is never sent again. `timeZone` is the IANA identifier of the zone the cook was made in, written when the cook is saved (owner's decision: the server judges each past week by every entry's own zone, so a cook who travels before the phone is back online still counts on the day they cooked). `ProgressSnapshotRecord` holds the server's snapshot JSON exactly as received (`body`) and when the phone received it (`receivedAt`), so the record holds no rule.

Ids of the library (diet, avoid items, cuisines, ingredients, equipment, skill, lesson) are stored as their strings, lists of ids as lists of strings, and `experience` and `units` as their raw values. Still to be added, each by the issue that first produces the value, as new optional fields: voice on (profile); lesson revision, swaps used, rating and plate photo file name (cook log). XP is not a field and never will be: the server works it out. A quiz result will not be a new field either: the server scores the quiz itself, and the existing `quizCorrect` field is never sent to it.

Each record has a plain twin in TomiCore (`SavedProfile`, `SavedCookEntry`, `SavedActiveLesson`, `SavedProgressSnapshot`) with the same field names. The SwiftData records only copy fields to and from the twin; every rule for reading them is in TomiCore and tested there without a store:

- **Profile.** The record is the phone's copy of the server's profile (`ProfileCache`), written after every fetch and save, and read for offline cooking (and, until #167, for the old progress rules). It never decides what the cook may eat. Of several records the one changed last is read (`cachedProfile`); conflicting copies with the same stamp give the defaults until the next fetch. Saving writes into the newest record and deletes the others. Every field is still written, none is unused yet, and none may be removed.
- **Cook log.** The outbox of unsent cooks: an entry is written before anything else happens with the cook, keeps its id across every retry, and is deleted once the server answers `accepted`, `duplicate` or `conflict`; after `rejected` it stays, marked refused, and is never sent again. `cookLog` reads every record that has all a cook entry needs, each id once, oldest first, by one fixed order that does not depend on how the store hands the records over. A record that lacks its id, lesson, skill, level, date, ending or weekly goal is left out, counts for nothing and stays in the store. A skill or level this app does not know is kept and sent; the server judges it. `pendingCookEntries` is the log without the cooks marked refused (any copy refused refuses the cook), and `outboxBatch(calendar:)` sends each cook with its own `timeZone`; a cook saved before the zone was recorded, or with a zone this phone cannot read, is sent with the zone of the calendar passed in. Forgetting and refusing reach every copy of a cook.
- **Progress snapshot.** The last snapshot the server sent, kept for showing progress offline. Saving writes into the newest record and deletes the others. Of several records the one received last is read (`lastSnapshot`); a body that cannot be read, or conflicting copies with the same stamp, give no snapshot, never zeros, and the phone asks the server again. A snapshot is kept only when it is no older than the one kept (`SnapshotKeeping`, by the moment the server computed it), so a read that crosses an upload on the way never brings back older numbers.
- **Lesson in progress.** The store keeps a bookmark, not a copy of the lesson: the lesson id and revision, the swaps applied (what went out and what came in), tonight's ingredients and the step. `ActiveLesson.resumed(from:)` builds the dish again from the library. A lesson that was withdrawn or corrected since, a swap the lesson does not list or a step it does not have is not resumed. Whenever the server's diet or avoid list differs from the cached copy, the bookmark is forgotten, because only the server can check a dish. Of two bookmarks the one changed last is read.

Saved data fails closed. When the store cannot be opened or read, every call of the store throws, and the app shows a notice instead of its screens (`RootView`). It never carries on with default preferences, because the defaults say the cook eats everything.

Conflicting copies with the same newest timestamp and stable id have no unambiguous newest record. A profile then asks for ordinary answers again while keeping every saved diet and avoid restriction; a conflicting lesson bookmark is not resumed. Identical copies still read as one record. Neither answer depends on the order the copies arrive in.

iCloud sync is not switched on. The current store opens with CloudKit off and its records were laid out for iCloud. Progress no longer needs it: the server's cook log follows the cook's account.

For UI tests, launch arguments choose the store: `--store-in-memory` starts with an empty store in memory, `--store-ui-test-file` keeps the store in a file of its own between launches, `--store-unavailable` starts as if the store could not be opened, `--store-ui-test-unwritable-file` asks SwiftData for a file it cannot create, and `--seed-known-state` empties the store and fills it with a known state built from the menu (`KnownState`). Once the server owns progress, a test's progress comes from the fake server's fixture snapshots, handed over unchanged (#160): `--fake-progress-new-cook` (the default, every number zero) or `--fake-progress-returning` (tomi-backend's `docs/examples/progress.json`, copied verbatim), and `--fake-cook-entries-offline` fails `GET /v1/progress` and `POST /v1/cook-entries` as unreachable. The fake answers every cook it is sent `accepted` and counts nothing. The known state seeds unsent cooks and, as the server's last answer, the returning fixture's snapshot (#163). Like the answers saved on the phone, the fake server of a signed-in cook holds the progress the phone saved last when it is one of its fixtures, so a relaunch shows the same progress after the server is asked again; a fixture named by argument wins. Seeding is ignored for the cook's own store. A requested file that SwiftData changes to memory is refused, even when its configuration already says memory before the container opens.

Plate photos are files in the app's own storage on the phone. Only the file name is in the cook log. Neither the log nor the photos currently sync through iCloud. Sending cook entries to the server never sends the photo; another device can show the dish without its local plate photo.

The server's cook log is the source of truth. XP, rank, streak and mastery are computed from it by the server and shown from its snapshot; the phone never computes or predicts them. Since #163 the screens show only the server's snapshot; `GameStateRules` in TomiCore is no longer called by any screen and goes with #167. Every record has a stable id and a time, and the same id is the same cook, counted once by the server. All fields are optional and changes are additive, so the layout is safe for iCloud.

The cook's answers are one value, `CookProfile` in TomiCore, with the server's JSON names (the same as the stored fields). Experience and units are closed lists in code, because code decides what they do; diets, avoid items, cuisines, equipment and cupboard staples are `OptionID`s from the server's lists, which the app neither names nor interprets. Reading the server's profile refuses it when the diet or avoid list cannot be read, so the app never assumes "eats everything"; any other field that is missing or unknown keeps its default. The cupboard question works like the kitchen: the options list about 22 everyday `staples` (not every ingredient), each marked `assumed` or not; until `cupboardAnswered` is true the server counts the assumed ones as at home and ignores `cupboardStaples`, so the screen starts from them and the first save sets `cupboardAnswered` (`CookProfile.cupboard(assumedUntilAnswered:)`). Saved staples that are not in the list show as removable extras, and typed words go through `POST /v1/ingredients/resolve`. A change is sent as `PATCH /v1/profile` with only the changed fields and the version read (`ProfilePatch`); `409 version_conflict` makes the cook's change again on the newer profile (`ProfilePatch.rebased(on:)`); removing a diet or avoid item is refused with `409 weakens_restrictions` until the cook confirms on screen and the app sends `allowWeakerRestrictions`.

## Guided cooking introduction and preparation (#152)

The first graph-native cooking slice decodes optional teaching and provides introduction plus preparation screens. It does not reuse bundled `LessonID` records or add saved fields. Teaching must be compatible with an unchanged server-adapted recipe; draft content is labelled. A fresh profile fetch, checked-suggestion validation and exact avoid-list match are required to begin preparation, so changes in either direction require new suggestions. Guided steps, quiz, session persistence and rewards belong to later slices.

## Progress and the quiz on the server (#157)

Owner decision, 26 October 2026. The cook log, every game and progress rule (XP, rank, weekly streak, levels, unlocks, mastery, grants, focus) and the game numbers move to tomi-backend, per Supabase account. The contract is tomi-backend's `docs/progress.md` (mrspacerobot/tomi-backend#35).

- **Thin client.** The phone shows the server's versioned progress snapshot (`GET /v1/progress`, also returned by `POST /v1/cook-entries`) and computes nothing from it beyond display. It never predicts XP or rank.
- **Cook entries, not events.** A cook is a cook entry with a client-made UUID, written to the phone's outbox first and uploaded with retry and backoff. The server is idempotent on the entry id: a second copy with the same body is a `duplicate`; with a different body the first accepted copy wins, the second is answered `conflict`, changes nothing and is logged.
- **Uploader (#162).** `CookEntryUploader` sends the outbox on launch once the cook is signed in, when the app becomes active, right after a cook is saved, and when its backoff timer ends (`CookOutbox.retryDelay`, waited out through an injected `Sleeper`, never the clock read directly). One upload runs at a time, batch after batch until the outbox is empty; a second trigger while it runs starts nothing. Each answer's snapshot is kept as the server sent it (`CookEntriesResponse.snapshotBody`). A network or server failure, or an answer that changes no cook, keeps every cook and sets the timer; a `422` keeps every cook and sends nothing more until the next launch; signed out, the cooks wait for the next sign-in. After each try the uploader counts it (`finishedTries`), and Home reads the snapshot and the outbox again.
- **Offline.** The app shows the last snapshot plus a note that pending cooks will count when the cook is back online. With no snapshot yet it says progress shows once online. A snapshot that cannot be read is never shown as zero.
- **Calendar.** Each entry stores its own IANA time zone, and past weeks are judged by each entry's zone. The current week is judged by the `timeZone` and `firstWeekday` sent with the request.
- **Quiz.** Server-run. The server sends questions and choices without answers (teaching schema 2), receives each pick (`POST /v1/quiz-answers`) and answers right or wrong; correct answers never leave the server. The first answer to each question is the score, retries only teach. The quiz needs a connection. The phone never sends `quizCorrect`.
- **Catalog.** tomi-backend's `library/catalog.json` is the canonical catalog; the app's copy stays only while the bundled library exists (#156).
- **Until #167** the old TomiCore rules (`Game`, the rule files of `Progress`, `Experience+GrantedSkills`) and the screens that use them stay as they are. Nothing new is built on them.

Order. Backend: mrspacerobot/tomi-backend#35 -> mrspacerobot/tomi-backend#36 -> mrspacerobot/tomi-backend#37, mrspacerobot/tomi-backend#38, mrspacerobot/tomi-backend#39 -> mrspacerobot/tomi-backend#40 -> mrspacerobot/tomi-backend#41; quiz mrspacerobot/tomi-backend#42 -> mrspacerobot/tomi-backend#43 -> mrspacerobot/tomi-backend#44. App: #157 (this decision) -> #158 -> #159, #160 -> #161 -> #162 -> #163 -> #167; quiz #164 -> #165 -> #166. #28 (finish) comes after #162 and #166; #156 (remove the bundled player and library) comes last, after #167 and #166.

## Phases

Each phase ends with something runnable. GitHub milestones mirror these.

| # | Phase | Done when |
|---|---|---|
| 0 | Toolchain and scaffold | The app runs in the simulator and on the owner's iPhone, checks run from the command line, and five real fridge photos have been read by the server's model |
| 1 | Design pass | Done. Mockups approved in `docs/design/` |
| 2 | Rules and design system | Every rule is in TomiCore with tests, and a gallery of every component matches the mockups in light and dark |
| 3 | Onboarding, home, menu, saved progress | A fresh install walks through onboarding, answers survive a force-quit, and "vegetarian" changes the example special |
| 4 | Lesson player | The example lesson can be cooked start to finish, earning XP, a day toward the weekly goal and a stamp |
| A | Milestone | A real app in Tomi's own design, no AI yet |
| 5 | Lesson library | The app picks among real library lessons for a typed list, and a vegan nut-free profile is never shown a dish it cannot eat |
| 6 | Fridge scan | A real fridge photo produces a sensible special, and the same flow works by typing when the server's model is unavailable. A plate photo can be kept after a cook |
| 7 | Ask Tomi | Safety questions are always answered from the table, in any phrasing tried. Tomi remarks on a plate photo without ever judging doneness |
| 8 | Hands-free voice | A lesson can be finished without touching the phone, with an extractor fan running |
| B | Milestone | Everything in the README works on device |
| 9 | Sync, backend, proof and polish | The Rust service owns reviewed content, the cook log, progress, the quiz and ratings; the app shows the server's progress, cooks made offline upload without loss or double counting, and a friend cooks from TestFlight |

## Verification

- Rules: unit tests in TomiCore, written first.
- Flows: UI tests that tap through the app in the simulator against fake AI, camera and clock.
- Screens: run in the simulator after every change and compare with the mockup, light and dark, small and large phones, largest text size.
- UI pull requests: embed screenshots of each changed screen or meaningful state from the final running app, in light and dark, with fake data. Keep the description and screenshots current after revisions, following `agent-on-pull-requests.md`.
- Real AI, camera and microphone: a short checklist for the owner to run on the iPhone at the end of each AI phase.

## Risks

- **The server's model may read fridges badly.** The model sits behind the server, so it can be replaced without an app release.
- **Allergens are a safety feature.** Tags come from one reviewed table that only a person changes, an unknown ingredient, diet or avoid item refuses the dish, the filter runs again after AI adaptation, and the app never claims a dish is "safe".
- **Diets and cuisines multiply the library** to roughly 150 to 200 lessons. Generation is cheap; human spot-checking is the real cost.
- **A live iCloud layout can only grow.** The saved-data design is a review point before TestFlight.
- **The server may be unreachable.** Cooking a lesson already on the phone works offline; scanning and tonight's special need the server, and the typed path must always work when only the model is down.
- **Motion carries the reward.** The stamp press and the menu line inking in cannot be judged from stills and need an early prototype.

## Consolidated onboarding (#124)

After sign-in, a new cook sees the welcome and the animated companion, then the server-backed questions. Each screen places the companion with a `CompanionSlot`; the diet greeting uses its explaining state. The server remains the source of all food options and saved profile answers. The former local-food onboarding is superseded.

## Home overview foundation (#150)

Home follows the approved round2 `home-empty` hierarchy: compact masthead and date, streak/rank/next-rank columns, an empty double-ruled special with scan/direct typing/cupboard edit, and the server-ordered course menu. The server owns progress and the game rules: since #163 Home shows the server's last snapshot as it was sent, read back from the store at once and asked for again when Home appears or the app becomes active (`ProgressModel`). It does not imply server-synced progress or eligibility for a recipe.

The rules package joins the server's course and skill names to the snapshot's skills by skill id (`HomeMenuProgress`); a skill the snapshot does not name, or a missing prerequisite the menu does not name, stays unknown, never locked or zero. The level diamonds are the snapshot's `cooksToComplete`; the only arithmetic on the phone lays the given `xp`, `startsAt` and `nextAt` along the rank bar (`RankBar`). The rank name is the server's `rank.name`, with the server's `tier` after it past the first tier (wording parked by the owner). When the server cannot be reached, Home keeps the last snapshot and a kind note (`ShownProgress`, `ProgressNote`): unsent cooks "will count when you're back online", never added to a number; without any snapshot only "Your progress will show when you're online", never zeros; and a snapshot past its `weekEndsAt` hides this week's days. A saved-data read failure keeps the existing unavailable notice. Home refreshes its date and progress when it appears or the app becomes active.

The special remains empty in this slice. Scan results and their alternatives remain in the existing scan route; returning them to the same Home card is a separate follow-up. Skill details, prior-dish shortcuts, guided cooking, recipe time totals, prospective XP and remote progress are not added by this change.
