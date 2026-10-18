# Tomi: rules for anyone writing code here

Tomi is a native iPhone app (SwiftUI, iOS 27) that teaches cooking from what is in your fridge. This file is the steering document for humans and coding agents. Read it before changing anything. If a rule here is wrong, change the rule in the same pull request, do not quietly ignore it.

- What we are building and in what order: `docs/implementation-plan.md`
- Backend responsibilities and remaining API contracts: `docs/backend-spec.md`
- What it must look like: `docs/design/` (approved mockups, direction "Tasting menu")
- Work items: GitHub issues, grouped by milestone. One issue is one pull request.

## Before you call anything done

```
./scripts/check.sh
```

It runs the formatter's lint, SwiftLint (size limits, hard-coded text, banned calls), the rules package tests, and the app's unit and UI tests in the simulator. Tools needed once: Xcode 27 and `brew install swiftlint`. It must pass with no warnings you introduced. Then run the app in the simulator and look at what you changed, in light and dark, next to the mockup. If something looks off, even something you did not touch, fix it or open an issue.

Report honestly: if a check fails or you skipped a step, say so.

For every UI task, embed screenshots of the working screen in the pull request description, in light and dark. Capture each changed screen or meaningful state from the running app built from the final code, using fake data. Label the screen/state, device, iOS version and text size. Mockups and SwiftUI previews do not count. Keep the screenshots current after revisions. See `docs/agent-on-pull-requests.md` for capture and posting instructions. If screenshots cannot be captured or posted, explain the blocker in the description and leave the pull request in draft. No automated check reads the description, so this rule is enforced by review: the owner merges a UI pull request only when its description shows current light and dark captures of the final build, and a reviewer reports missing or stale ones as P1.

**Every pull request to `main` runs the same check automatically** (`.github/workflows/check.yml`), on the owner's Mac. It shows on the pull request as "Check". If the Mac is busy, asleep or off, the check waits and runs when the Mac is free. GitHub cannot require a green check on this repository, so the rule is written here instead: the owner merges only when the check is green. Running it yourself first is still required; the automatic run is the proof, not the first try.

## Running the app

One build runs against three backends, chosen when it launches:

| Mode | Sign-in | Server | Xcode scheme | Script |
|---|---|---|---|---|
| cloud (default) | the real Supabase project | the deployed Cloud Run server | Tomi | `scripts/run.sh cloud` |
| local | the real Supabase project | `tomi-backend` on this Mac, `localhost:8080` | Tomi Local | `scripts/run.sh local` |
| fake | fake, a plain button | in memory, with an in-memory store | Tomi Fake | `scripts/run.sh fake` |

- `scripts/run.sh` builds, installs and launches on the simulator named by `TOMI_SIMULATOR` (default "iPhone 17"). Extra arguments are passed to the app, for example `scripts/run.sh fake --fake-signed-in --appearance-dark`.
- Use **fake** to look at screens: it needs no account and no network. Use **cloud** to try a real sign-in. Use **local** to try a server change before it is deployed; start `tomi-backend` with `SUPABASE_URL` set to the Supabase project, so it accepts the app's real tokens.
- Sign in with email and password in cloud and local. Sign in with Apple needs the paid developer account.
- UI tests always launch with `--fake-backend` and never reach the network.

## How we work: tests first

1. **Write the failing test first.** For a rule, a unit test in `Packages/TomiCore`. For a screen or flow, a UI test that drives the app the way a cook would. Watch it fail for the right reason, then write the code.
2. **For UI, prefer end-to-end tests.** A flow is proven by a UI test that taps through it in the simulator (onboarding to first special, cooking a lesson to the stamp), not by tests of view internals. Keep unit tests for logic, UI tests for behaviour.
3. **Bug fixes start with a reproduction.** Reproduce it end to end first, as the user would hit it, then add the test that fails, then fix.
4. **UI tests never depend on a real model, camera, clock or network.** They run against the fake implementations (see Architecture). A flaky test is a bug: fix it, never retry or skip it.
5. **Every acceptance criterion in the issue maps to at least one test.**

## Text and translation

- **No user-facing text in Swift files.** Every word the cook can see or VoiceOver can read lives in `Tomi/Resources/Localizable.xcstrings`. SwiftLint fails the build on string literals in `Text`, `Button`, labels, titles and alerts.
- **Keys are semantic and dotted:** `screen.element` or `thing.id.field`, for example `welcome.title`, `onboarding.diet.title`. Never use the English sentence as the key.
- **Use the generated symbols:** `Text(.welcomeTitle)`, `Text(.welcomeSubtitle(12, 4))`. They are compile-checked, so a renamed or missing key breaks the build instead of shipping blank.
- **Every key has a comment** telling a translator where it appears and what the placeholders are.
- **Never build sentences by joining pieces.** Use one key with placeholders. Use the catalog's plural variations for counts.
- **Format numbers, dates, durations, temperatures and quantities with formatters** (`Measurement`, `Duration`, `.formatted()`), never by hand. Metric or cups comes from the cook's setting.
- **Casing is styling.** Store "Chez Tomi", apply `.textCase(.uppercase)`.
- **Changing wording must never need a code change.** If you find yourself editing Swift to fix a typo, the text is in the wrong place.
- Copy rules: Tomi's voice is warm, short and plain. Use a plain hyphen, never the em dash.

## Content is data, not code

- **The skill menu is a file, never Swift.** Courses, skills, prerequisites and levels live in `Tomi/Resources/Library/catalog.json`, read through `SkillCatalog.decode(from:)`. No Swift file may name a specific skill or course; anything special about one (a starter skill, say) is a field in the data.
- **Tomi's server owns the food knowledge.** The Rust backend (`tomi-backend`) holds the ingredient table with its facts, the diets, the avoid items, the cuisines, the equipment list, the filters that decide what a cook may eat, the fridge scan and the ranking of tonight's special. The app holds none of these lists and none of these rules: it shows what `GET /v1/options` sends, sends back the ids the cook picked, and shows the offers of `POST /v1/lessons/suggest`. No Swift file names a diet, avoid item, fact, ingredient, piece of equipment or cuisine, and no enum or list of them exists in the app.
- **One food check stays on the phone, as a guard.** An offer is shown only when the server says it checked it for the cook's diet and for every item they avoid (`Offer.isChecked(for:)`, `TonightsMenu`). It decides nothing about food; it refuses an offer whose check does not cover the cook. Do not add any other food rule to the app.
- **Lessons are files, never Swift.** One file per lesson under `Tomi/Resources/Library/lessons/<skill>/`, named `<lesson id>.lesson.json`, read through `Lesson.decode(from:catalog:)` and served by `LessonLibrary`, so a lesson can be cooked offline. Xcode copies the library into the app flat, so the `.lesson.json` ending is how a lesson is told from `catalog.json`, and the lesson id in the name keeps every file name unique. A file that fails validation, or is not named by its id, is skipped and logged, never shown. The app must not care whether a lesson came from the bundle or a download.
- **Lesson amounts are numbers with a unit from a closed list** (`Amount`, `AmountUnit`), written once in metric and once in cups for each ingredient. Never write an amount, a temperature or a unit into step text: code must be able to scale and format it.
- **Content words travel with the content.** Course, skill and level names and lesson text are `LocalizedText` in the library, English required, other languages optional. Screen words stay in the string catalog.
- **Skill and course ids are permanent,** like saved fields: cook logs keep them forever. Never rename or reuse one. Levels are numbered from 1 and a published number never changes meaning.
- **The catalog and lesson schemas live in TomiCore.** Changing one means bumping its schema version and updating the validator and its tests. On the phone a lesson is checked only for what cooking it needs (skill and level on the menu, amounts, steps, scenes, main, quiz, swaps that replace an ingredient of the lesson); whether its ingredients and equipment exist is the server's check of its library.
- **A model never adds to the lists.** Skills and levels are added only by a person, in a reviewed change to `catalog.json`; facts, avoid items, diets, ingredients and equipment only by a person on the server. The server's model only reads fridge photos, ranks existing lessons and applies swaps a lesson already lists.
- **Food-safety facts come only from the safety table.** No temperature, time or allergen claim may be hard-coded in a view, a prompt or a lesson step without passing that check. Tomi never judges from a photo whether food is cooked through or safe to eat.
- **Game numbers live in one place** (`GameRules` in TomiCore): XP per cook, cooks to complete a level, XP per rank. No magic numbers in views.
- **Step scenes are a closed list** (`StepScene` in TomiCore, the actions drawn in `docs/design/src/scenes3.py`). Every step names one, and it must show what the step does, with the right vessel and tool. Never pick the nearest scene that exists: a wrong picture misleads and passes every check. If no scene fits, the scene is drawn first and the lesson waits for it. There is no blank or fallback drawing.
- **A lesson names its main food** (`DishMain`, also a closed list from the kit: chicken, tofu, omelette). Scenes that show the food, such as sear, flip, roll, rest and plate, draw that main, so an omelette lesson never shows a chicken thigh.
- **A new scene or main is drawn in the kit first,** then added to `StepScene` or `DishMain` (additive only, raw values permanent), and released in the app before any library uses it. A lesson that names one an older app does not know is not shown there until that app is updated.

## Design system

- **No raw colours, fonts, spacing or radii in screens.** Use the tokens and components in `Tomi/DesignSystem`. If a token is missing, add it there, in light and dark. SwiftLint fails the build on a raw colour, a raw font, or a number for padding, spacing, a corner radius or a line weight outside that folder.
- **The tokens are the handoff table of `docs/design/round3.html`.** A colour is a `ColorRole`, with its light and dark value in `Tomi/DesignSystem/Tokens.xcassets`. Text is set with `textStyle(_:)` and a `TextStyle`, which grows with the cook's text size. Spacing, radii, line weights and touch targets are `Spacing`, `Radius`, `RuleWeight` and `TouchTarget`.
- **Text must be readable in light and dark.** Every pair of text and ground is listed in `ColorRole.bodyTextPairings`, and a test holds each to 4.5 to 1 (`ContrastRule` in TomiCore) in both appearances. A component that sets text on a new fill adds its pairing there first. If a pair fails, change the colour, never the test.
- **The fonts are bundled:** Gloock, Newsreader and Figtree, with their licence texts, in `Tomi/Resources/Fonts`, listed in `Config/Tomi-Info.plist` and named only in `Typeface`. A test fails when a cut does not load, because a missing font falls back to the system font without a word.
- **Reuse before you build.** Search `DesignSystem` first. The second time something is needed, extract it into a component instead of copying it.
- **Illustrations are drawn in code** from shared parts. No image assets for Tomi or the scenes. The printed mascot and step scenes use SwiftUI; the separate 3D conversation companion uses native RealityKit geometry (#94), behind `TomiCompanion` and its presentation states. It never opens a microphone or an AI session. Onboarding shows the companion instead of the printed mascot: one `CompanionHost` per flow draws it where a screen's `CompanionSlot` asks, so it is never created and destroyed per page (RealityKit takes seconds to show a companion created as the last one goes away). Both respect Reduce Motion and inactive or hidden screens. Onboarding retains the welcome and a persistent 3D companion host while its answers come from the server.
- **Every view has a `#Preview`** with fake data, and renders correctly at the largest Dynamic Type size.

## Architecture

- **Feature folders.** Code is grouped by feature (`Onboarding`, `Home`, `Player`), not by kind.
- **Three layers.** Screens (SwiftUI) call app services. Services call TomiCore and Apple frameworks. TomiCore imports nothing from Apple's UI, data or AI frameworks.
- **All rules the app keeps live in `Packages/TomiCore`:** skills, unlocks, mastery, XP, streak, reading the server's answers, the checked-offer guard, and what a tap changes in the profile. If it can be decided without a screen, it belongs there with a test. Food rules belong on the server, never here.
- **TomiCore is grouped by domain folder,** and its tests mirror the same folders: `Catalog` (skills, courses, levels), `Lessons`, `Preferences`, `Server` (the server's answers and requests), `Progress` (the cook log and what follows from it), `Game` (XP, rank, streak), `Design` (colour contrast) and `Utils` (small shared helpers). No Swift file sits in the root of `Sources/TomiCore` or `Tests/TomiCoreTests`. It stays one package and one module; folders are free, a second module is not.
- **The rules above are tests, not hopes.** `Packages/TomiCore/Tests/TomiCoreTests/Architecture` reads the source and fails when: the rules package imports anything but Foundation; app code imports a service framework (Speech, AVFoundation, SwiftData, CloudKit, AlarmKit, UIKit, PhotosUI, ImageIO, AuthenticationServices, Security, CryptoKit) outside its service folder (`Tomi/Voice`, `Tomi/Camera`, `Tomi/Persistence`, `Tomi/Timers`, `Tomi/Auth`); a Swift file names an id of the shipped library as a string; a Swift file sits in the root of the rules package; the scenes and mains in code differ from the ones the design kit draws; or a stored record has a property that is neither optional nor defaulted, a unique constraint, or a field the plan does not list. SwiftLint fails on `Calendar.current`, `Locale.current`, `Date()` and the like inside the rules package. When a rule here changes, change its test in the same pull request.
- **The server, sign-in, voice, camera, clock and storage sit behind protocols.** Each has a real implementation and a fake: `TomiAPI` (`URLSessionTomiAPI`, `FakeTomiAPI`), `AuthService` (`SupabaseAuthService`, `FakeAuthService`). Screens never import Speech, AVFoundation, SwiftData or AuthenticationServices directly. UI tests launch with `--fake-backend` (and `--fake-signed-in`, `--fake-no-specials`) and never reach the network.
- **No AI runs on the phone.** No Foundation Models: the server reads fridge photos and ranks dishes. When it cannot (`503 ai_unavailable`), the cook types what they have.
- **Sign-in is Supabase Auth with Sign in with Apple,** without a third-party SDK: Apple's identity token and the raw nonce go to `{SUPABASE_URL}/auth/v1/token?grant_type=id_token`, tokens are kept in the Keychain and renewed before expiry or after a 401. Request the email scope so Supabase Auth can store the contact address, including Apple's private relay address. Every call to the server carries `Authorization: Bearer <access token>`.
- **Addresses and keys come from build settings** (`TOMI_API_BASE_URL`, `TOMI_SUPABASE_URL`, `TOMI_SUPABASE_PUBLISHABLE_KEY` and, in Debug only, `TOMI_LOCAL_API_BASE_URL`, read through the Info.plist by `BackendConfiguration`). The committed values are the deployed Cloud Run server and the Supabase project; the URL and the publishable key are meant to ship in the app. Never type one into a Swift file. The app never holds a Supabase secret key, a service-role key or the database password.
- **The cook log is the source of truth.** XP, streak and mastery are computed from it, not stored as running totals.
- **Saved data must stay iCloud-safe:** every stored property optional or defaulted, no unique constraints, changes additive only. Never rename or remove a stored field after release. The stored fields are listed in `docs/implementation-plan.md` (Saved data): a new field is added there in the same pull request.
- **Stored records hold no rules.** A SwiftData record in `Tomi/Persistence` only copies its fields to and from its plain twin in TomiCore (`SavedProfile`, `SavedCookEntry`, `SavedActiveLesson`), which has the same field names. How a record is read, how two records from two devices become one answer, and when a record is refused are decided in TomiCore and tested there without a store. Nothing is unique in the store, so every read must give the same answer for the same records in any order, with a cook entry counted once.
- **The server's profile is the source of truth for the cook's answers.** The stored `ProfileRecord` is the phone's copy of it (`ProfileCache`), used by the progress rules and when cooking offline; it never decides what the cook may eat. When the server's diet or avoid list differs from the copy, the lesson in progress is forgotten, because only the server can check a dish. A profile change sends only the changed fields with the version read (`ProfilePatch`); on `409 version_conflict` the cook's change is made again on the newer profile, and removing a diet or avoid item is sent with `allowWeakerRestrictions` only after the cook confirmed it on screen.
- **Saved data fails closed.** When the store cannot be opened or read, the store throws and the app shows that saved data is unavailable (`RootView`). Never carry on as if the cook log were empty.
- **Conflicting copies never depend on arrival order.** When different records share the newest id and timestamp, ordinary profile answers must be given again, with every saved food restriction kept; a conflicting lesson bookmark is not resumed. Identical copies still read once.
- **UI tests never touch the cook's own store.** They launch with `--store-in-memory`, or `--store-ui-test-file` when a test relaunches the app, and `--seed-known-state` for a known starting state (`StoreLaunchOptions`, `KnownState`). They start as a new cook with `--store-start-empty`, and see light or dark with `--appearance-light` or `--appearance-dark` (`AppearanceLaunchOption`), because `XCUIDevice.appearance` has no effect on the simulator.
- **No third-party dependencies in the app** without the owner's approval.
- **Proof of concept: there is no consent step, and every fridge photo is kept.** The owner's decision, for testing with their own photos only. A fridge photo is sent to the server as a small JPEG (long side at most `JPEGConverter.largestSide`, compressed to `JPEGConverter.quality`) with its own place, time and camera details, and the server keeps it as it arrived. **Before any real cook uses the app, a consent step must come first**: what is kept named in a text the cook agrees to, a way to withdraw that deletes it, and a privacy review. Chat and voice never leave the phone.

## Code style: small enough to read at a glance

A person should understand any function without scrolling and any file without a map. The limits are deliberately tight and SwiftLint enforces them (`.swiftlint.yml`), so they are not a matter of opinion.

| Limit | Value |
|---|---|
| Function body | 10 lines |
| Closure body, including SwiftUI builders | 10 lines |
| Type body | 80 lines |
| File | 150 lines |
| Function parameters | 3 |
| Branching (cyclomatic complexity) | 5 |
| Nesting inside a function | 2 levels |
| Line | 120 characters |

- **One function, one job, one level of detail.** If you need "and" to describe it, split it. If you want a comment to label a block, that block is a function and the comment is its name.
- **When a limit is hit, extract and name.** Never raise a limit, and never disable a rule inline. A flat `switch` that maps every case to a value is the one shape allowed to be long, and it belongs in a computed property.
- **Split views into new `View` structs,** not computed properties or helper functions returning views.
- **One type per file,** named after the type. Extensions go in `Type+Purpose.swift`.
- **No duplication.** Before writing a helper, search for one. Shared logic goes to TomiCore, shared UI to DesignSystem. The second copy is the moment to extract.
- **At most three parameters.** More means a missing type: group them into a struct. The one exception is a function Apple's protocol dictates: SwiftUI's `Layout` requires `placeSubviews(in:proposal:subviews:cache:)`. Layouts live in `Tomi/DesignSystem/Layout`, where that folder's `.swiftlint.yml` allows four; their arithmetic sits in a plain type with a unit test.
- **Plain statements over clever expressions.** No ternaries. Do not pack `?.`, `??`, `.map` and closures into one line: unwrap with `guard let` or `if let`, give each step a name, and let the names tell the story. A reader who knows Java or Kotlin but not Swift should be able to follow it.
- **Typed values, not strings, in tests too.** A date is built from numbers (`.october(5)`), never parsed from text like `"2026-10-05"`.
- **Names say what, comments say why.** No abbreviations, no commented-out code, no TODO without an issue number.
- **No force unwraps, `try!` or `fatalError` in app code.** Handle the failure and show Tomi's words for it from the string catalog. Tests may force unwrap.
- **No `print`.** Use `Logger`. Never log photos, ingredients or chat text.
- **No magic strings.** A string that code compares, sorts or looks up by is an enum, a typed id or a constant, never a literal typed at the point of use. A value that must be the same everywhere is written once: the logging subsystem comes from the bundle identifier (`Logger(category:)`), never from a typed copy. Only text for the cook (string catalog) and test fixtures may be literals.
- **Formatting is not a matter of taste:** `xcrun swift-format format --in-place --recursive Tomi TomiTests TomiUITests Packages/TomiCore` settles it.

## Modern Swift and SwiftUI

Models are trained on years of older code. Use the current API, and check Apple's documentation when unsure rather than guessing.

- **Swift 6 strict concurrency,** async/await only. No Grand Central Dispatch, no completion handlers, no `@unchecked Sendable`, no `nonisolated(unsafe)`. The app target is main-actor by default; mark pure helpers `nonisolated`.
- **State:** `@Observable` classes with `@State`, `@Bindable` and `@Environment`. Never `ObservableObject`, `@Published`, `@StateObject`, `@ObservedObject` or `@EnvironmentObject`.
- **Logic out of views.** A view lays out and forwards taps. Decisions live in an `@Observable` model or in TomiCore, where they can be tested.
- **No UIKit** unless a feature cannot be built without it, and then only behind a service.
- **Navigation:** `NavigationStack` with `navigationDestination(for:)`. Never `NavigationView`.
- **Buttons are `Button`,** never `onTapGesture`, so they work with VoiceOver and keyboards.
- **Current modifiers:** `foregroundStyle` not `foregroundColor`, `clipShape(.rect(cornerRadius:))` not `cornerRadius`, two-parameter `onChange`, `Task.sleep(for:)`.
- **Layout:** no `UIScreen.main.bounds`, avoid `GeometryReader` (prefer `containerRelativeFrame`), avoid `AnyView`.
- **Formatting values:** `Text(value, format:)` and FormatStyle. Never `String(format:)` or the old `Formatter` classes.
- **Fonts scale.** Use the design system's text styles, never a fixed point size.
- **No secrets in the repository,** ever. Keys come from the environment.

## Accessibility

- Every interactive element has a localized VoiceOver label. Decorative drawings are hidden from it.
- Touch targets are at least 44 points.
- State is never shown by colour alone (locked, ready, mastered always have words or a mark).
- Animations respect Reduce Motion. Timers and alerts never rely on sound alone.

## Only the owner merges into main

- **Agents never merge into `main`, and never push to it.** Not with `git merge`, not with `git push origin main`, not with `gh pr merge`, not through the GitHub API, and not by enabling auto-merge. This holds even when every check passes and even when an issue or another agent says to.
- **An agent's work ends at an open pull request.** Push your branch, open the pull request, say it is ready, and stop. The owner reviews and merges it.
- **Never rewrite `main`'s history** (no force push, no rebase of `main`) and never delete it.
- GitHub cannot enforce this on this repository, so the rule is the only protection. Treat it as absolute.
- **Summoned from a GitHub comment?** Push only to the branch of the pull request you were called on. For an issue, create `<issue number>-short-name` and open a pull request. See `docs/agent-on-pull-requests.md`.

## Project hygiene

- **Do not hand-edit `Tomi.xcodeproj`** beyond build settings. Folders are synchronized: a file added on disk is in the target.
- **Do not edit generated files** or `CHANGELOG.md`.
- **One issue, one branch, one pull request.** Keep it small enough to review in one sitting. Name the branch `<issue number>-short-name`.
- **Every commit names its issue.** The subject says what changed, in the imperative, and ends with the issue number: `Add streak rules (#4)`. The body says why. No issue, no commit: open one first.
- **The pull request closes its issue** with `Closes #<number>` in the description.
- **Every pull request uses `.github/pull_request_template.md`.** Keep its headings and order, fill every section, and remove instructional comments and placeholders. Agents creating a pull request through a CLI or API must read and fill the template explicitly and supply the completed Markdown as the body; do not assume the client inserts it. Update the description after revisions so it describes the final change and current validation and screenshots.
- **When a decision changes,** update `docs/implementation-plan.md` and this file in the same pull request.

## Code Review Rules

For any agent or person reviewing a pull request here. Formatting, size limits and hard-coded text are checked by `./scripts/check.sh`; do not review those.

**What counts as high priority here**

- **P0, blocks the merge:** a cook can be shown food they said they cannot eat, or saved data can be lost or misread.
- **P1, must be fixed:** a rule gives a wrong result for some input, a rule has no test that would catch it being broken, or a decision changed without its test and its documentation.
- Report each finding with the input or order of events that goes wrong, what the code does, and what it should do. If you cannot construct one, ask it as a question.

**Food safety**

- The app shows an offer only when its `checked` diet equals the cook's diet and its `checked` avoid list holds every item the cook avoids. A profile, check or offer that cannot be read is refused, never read as "eats everything".
- The app holds no food rule of its own: no diet, avoid, fact, ingredient, equipment or cuisine list, and no filter. Food rules are reviewed in the server's repository.
- A swap is applied on the phone only when the offer names it and the lesson lists it (`Lesson.applying(listed:)`).
- A temperature, a cooking time claimed as safe, or a "safe to eat" statement comes only from the safety table. Tomi never judges from a photo whether food is cooked through.

**The cook log and what follows from it**

- Progress, XP, rank and streak are computed from the cook log on demand. A stored total is a bug.
- The same entry id arriving twice counts once. Two logs merged in either order give the same result. No result may depend on the order of the entries.
- An entry for a skill or level this version does not know is ignored for progress and never crashes. An entry for an unknown lesson still counts when its skill and level are known: the entry records both itself, and a newer library may add lessons to a technique an older app already has. An entry marked stopped early counts for nothing.
- Week and day arithmetic uses the `Calendar` passed in. Inside TomiCore, `Calendar.current`, `Date()` and fixed lengths such as seven times 24 hours are bugs: they break at a daylight saving change, a different first weekday, or in a test.

**Saved data and ids**

- A stored field or an id (skill, course, level number, lesson, ingredient, fact, diet, avoid item, equipment, cuisine) is permanent. Renaming, removing or reusing one is a P0. New fields are optional or have a default.
- Reading saved data must survive a missing field and a value from a newer version, without crashing and without weakening a safety filter.

**Content files**

- A change to the layout of a content file (catalog, lesson) needs a schema version bump, a validator rule and a test with a failing file.
- A file from an unknown schema version is rejected before anything else in it is read.
- Whatever the validator accepts, the app must be able to use. Whatever a comment or document says the validator checks, it must check.
- No Swift file names a specific skill, course, ingredient, fact, diet, avoid item, piece of equipment or cuisine. No game number lives outside `GameRules`.
- `catalog.json` is changed only by a person. A generated or model-written change that adds a skill or level is a P0, whatever the validator says.

**Tests**

- Every rule changed or added has a test that fails when the rule is broken. Name the change that would slip through if one does not.
- A test never depends on the real clock, time zone, locale, network, camera or model.

**Pull request evidence**

- A pull request that changes the UI has current light and dark screenshots of the running app in its description, labelled with screen/state, device, iOS version and text size. No automated check verifies this, so the reviewer does. If the UI changed after the captures were posted, or they are missing, it is a P1.

A reviewer never merges and never pushes to `main`.
