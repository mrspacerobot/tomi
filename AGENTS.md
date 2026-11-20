# Tomi: rules for anyone writing code here

Tomi is a native iPhone app (SwiftUI, iOS 27) that teaches cooking from what is in your fridge. This file is the steering document for humans and coding agents. Read it before changing anything. If a rule here is wrong, change the rule in the same pull request, do not quietly ignore it.

- What we are building and in what order: `docs/implementation-plan.md`
- Backend responsibilities and remaining API contracts: `docs/backend-spec.md`
- What it must look like: `docs/design/` (approved mockups, the "Cooking Show", approved 20 November 2026: rounds 13 to 15, tokens and show words in `docs/design/cooking-show-handoff.html`)
- Work items: GitHub issues, grouped by milestone. One issue is one pull request.

## Before you call anything done

```
./scripts/check.sh          # the fast check, while you work
./scripts/check.sh --full   # the full check, before a pull request is called ready
```

The fast check runs the formatter's lint, SwiftLint (size limits, hard-coded text, banned calls), the rules package tests, the app build and the app's unit tests in the simulator. Run it while you work. The full check runs all of that and then the UI tests, which drive whole flows in the simulator and take most of the time. A pull request is ready only when `./scripts/check.sh --full` passed on its final code. The app is built once and every test run starts from that build. The UI tests run one at a time on this Mac: when another checkout or the CI runner is running them, the full check says who and since when, and waits. Never work around the wait; parallel UI test runs overload the Mac and make tests fail (#147). Every step prints how long it took. Tools needed once: Xcode 27 and `brew install swiftlint`. It must pass with no warnings you introduced. Then run the app in the simulator and look at what you changed, in light and dark, next to the mockup. If something looks off, even something you did not touch, fix it or open an issue.

Report honestly: if a check fails or you skipped a step, say so.

For every UI task, embed screenshots of the working screen in the pull request description, in light and dark. Capture each changed screen or meaningful state from the running app built from the final code, using fake data. Label the screen/state, device, iOS version and text size. Mockups and SwiftUI previews do not count. Keep the screenshots current after revisions. See `docs/agent-on-pull-requests.md` for capture and posting instructions. If screenshots cannot be captured or posted, explain the blocker in the description and leave the pull request in draft. No automated check reads the description, so this rule is enforced by review: the owner merges a UI pull request only when its description shows current light and dark captures of the final build, and a reviewer reports missing or stale ones as P1.

**Every pull request to `main` runs the check automatically** (`.github/workflows/check.yml`), on the owner's Mac. It shows on the pull request as "Check". A draft pull request runs the fast check; a pull request that is ready for review runs the full check on every push, and every push to `main` runs the full check too. If the Mac is busy, asleep or off, the check waits and runs when the Mac is free. GitHub cannot require a green check on this repository, so the rule is written here instead: the owner merges only when the full check on the final commit is green. Running `./scripts/check.sh --full` yourself first is still required; the automatic run is the proof, not the first try.

## Running the app

One build runs against three backends, chosen when it launches:

| Mode | Sign-in | Server | Xcode scheme | Script |
|---|---|---|---|---|
| cloud (default) | the real Supabase project | the deployed Cloud Run server | Tomi | `scripts/run.sh cloud` |
| local | the real Supabase project | `tomi-backend` on this Mac, `localhost:8080` | Tomi Local | `scripts/run.sh local` |
| fake | fake, a plain button | in memory, with an in-memory store | Tomi Fake | `scripts/run.sh fake` |

- `scripts/run.sh` builds, installs and launches on the simulator named by `TOMI_SIMULATOR` (default "iPhone 17"). Extra arguments are passed to the app, for example `scripts/run.sh fake --fake-signed-in --appearance-dark`.
- Use **fake** to look at screens: it needs no account and no network. Use **cloud** to try a real sign-in. Use **local** to try a server change before it is deployed; start `tomi-backend` with `SUPABASE_URL` set to the Supabase project, so it accepts the app's real tokens.
- Sign in with email and password, or with Apple, in cloud and local. Sign in with Apple also needs the Apple provider enabled in Supabase with the bundle id `com.mrspacerobot.tomi` as a client id.
- **On a phone:** every target signs automatically with the owner's team (`DEVELOPMENT_TEAM` in the project). Sign in to Xcode with the owner's Apple account, turn on Developer Mode on the phone, pick it as the destination and run the Tomi scheme.
- **To friends:** `scripts/testflight.sh` archives a Release build with a build number from the clock and uploads it to App Store Connect (`Config/TestFlightExportOptions.plist`). Testers are added in App Store Connect under TestFlight. The app is iPhone only, and `ITSAppUsesNonExemptEncryption` answers export compliance: it uses only standard HTTPS.
- UI tests always launch with `--fake-backend` and never reach the network.

## How we work: tests first

1. **Write the failing test first.** For a rule, a unit test in `Packages/TomiCore`. For a screen or flow, a UI test that drives the app the way a cook would. Watch it fail for the right reason, then write the code.
2. **For UI, prefer end-to-end tests.** A flow is proven by a UI test that taps through it in the simulator (onboarding to first special, cooking a recipe's steps to the end), not by tests of view internals. Keep unit tests for logic, UI tests for behaviour.
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

- **The skill menu is the server's, never Swift.** Courses, skills, prerequisites and levels live in tomi-backend's `library/catalog.json`, which the server judges progress with and sends in `GET /v1/options`. The app holds no copy of it and reads the menu only from that answer (the fake server's menu is the fixture `fake-options.json`). No Swift file may name a specific skill or course; anything special about one (a starter skill, say) is a field in the data.
- **Tomi's server owns the food knowledge.** The Rust backend (`tomi-backend`) holds the ingredient table with its facts, the diets, the avoid items, the cuisines, the equipment list, the filters that decide what a cook may eat, the fridge scan and the ranking of tonight's special. The app holds none of these lists and none of these rules: it shows what `GET /v1/options` sends, sends back the ids the cook picked, and shows the suggestions of `POST /v1/lessons/suggest`, each with its recipe already adapted for the cook by the server's code. No Swift file names a diet, avoid item, fact, ingredient, piece of equipment or cuisine, and no enum or list of them exists in the app.
- **One food check stays on the phone, as a guard.** A suggestion is shown only when the server says it checked it for the cook's diet and for every item they avoid (`Suggestion.isChecked(for:)`, `TonightsMenu`). It decides nothing about food; it refuses a suggestion whose check does not cover the cook. Do not add any other food rule to the app.
- **Optional graph teaching never gates recipe browsing.** Malformed, unknown or incompatible teaching is discarded while the checked suggestion remains readable. Introduction and preparation require valid graph teaching and no substitutions or omissions. Starting requires a successful fresh profile read, a new `Suggestion.isChecked(for:)` check, and an exact avoid-list match; failure or any changed restriction asks for new suggestions. Preparation leads to guided steps (#154): the server's adapted steps one at a time, rechecked the same way before they begin, and recording nothing yet (progress and the quiz belong to the server, #157).
- **Recipe amounts are numbers with a unit from a closed list** (`Amount`, `AmountUnit`, `RecipeAmount`). Never write an amount, a temperature or a unit into step text: code must be able to scale and format it.
- **Skill and course ids are permanent,** like saved fields: the server's cook log and the phone's unsent cooks keep them forever. Never rename or reuse one. Levels are numbered from 1 and a published number never changes meaning.
- **A model never adds to the lists.** Skills and levels are added only by a person, in a reviewed change to the catalog (canonical in tomi-backend's `library/catalog.json`); facts, avoid items, diets, ingredients and equipment only by a person on the server. The server's model only reads fridge photos; deterministic server code ranks recipes and applies graph-listed adaptations.
- **Food-safety facts come only from the safety table.** No temperature, time or allergen claim may be hard-coded in a view, a prompt or a lesson step without passing that check. Tomi never judges from a photo whether food is cooked through or safe to eat.
- **Game numbers live on the server** (`progress::game` in tomi-backend): XP per cook, cooks to complete a level, XP per rank, the weekly goal range. The app holds none: it shows the numbers of the server's progress snapshot and the goal range of `GET /v1/options`. Until the stepper reads that range (#178), `CookProfile` keeps the days of one week (`weeklyGoalRange`, 1 to 7) and the server's default for a new profile; no other game number exists in the app.
- **The quiz is run by the server, and the app never reads its answers.** The server sends each question with its choices, receives each pick (`POST /v1/quiz-answers`) and says whether it was right; the explanation comes only once the cook is right. The first answer to each question is the score, retries only teach. The quiz needs a connection. No quiz answer or answer index exists in app code or fixtures, and no request carries `quizCorrect` (the stored field of that name stays, because stored fields are permanent, and is never sent). One older copy remains until its removal, and nothing new may read it: a server on teaching schema 1 still sends `answerIndex`, which the app no longer reads (#164) and the server stops sending under schema 1 (mrspacerobot/tomi-backend#42).

## Design system

- **No raw colours, fonts, spacing or radii in screens.** Use the tokens and components in `Tomi/DesignSystem`. If a token is missing, add it there, in light and dark. SwiftLint fails the build on a raw colour, a raw font, or a number for padding, spacing, a corner radius or a line weight outside that folder.
- **The look is the Cooking Show** (approved 20 November 2026, epic #201): Tomi hosts a cooking show, in a morning show (light) and an evening show (dark). The mockups are `docs/design/round13-cooking-show-all.html`, `round14-photos.html` and `round15-missing-screens.html`. Screens still in the old "Tasting menu" look (`round1.html` to `round3.html`) move to it under #201; nothing new is built in the old look.
- **The tokens are the handoff table of `docs/design/cooking-show-handoff.html`.** A colour is a `ColorRole`, with its light and dark value in `Tomi/DesignSystem/Tokens.xcassets`. Text is set with `textStyle(_:)` and a `TextStyle`, which grows with the cook's text size. Spacing, radii, line weights and touch targets are `Spacing`, `Radius`, `RuleWeight` and `TouchTarget`. Until #194 replaces them, the tokens in code are still round 3's.
- **The show words are listed once,** in the Show words table of `docs/design/cooking-show-handoff.html` ("episode" is a skill, "season" a course, "off air" offline, and so on). A screen uses those words with those meanings; a new show word is added to that table in the same pull request. The words themselves live in the string catalog like any other text.
- **Text must be readable in light and dark.** Every pair of text and ground is listed in `ColorRole.bodyTextPairings`, and a test holds each to 4.5 to 1 (`ContrastRule` in TomiCore) in both appearances. A component that sets text on a new fill adds its pairing there first. If a pair fails, change the colour, never the test.
- **The fonts are bundled:** Gloock, Newsreader and Figtree today, Lilita One and Nunito once #194 moves to the Cooking Show, with their licence texts, in `Tomi/Resources/Fonts`, listed in `Config/Tomi-Info.plist` and named only in `Typeface`. A test fails when a cut does not load, because a missing font falls back to the system font without a word.
- **Reuse before you build.** Search `DesignSystem` first. The second time something is needed, extract it into a component instead of copying it.
- **Illustrations are drawn in code** from shared parts. No image or model assets for Tomi or the scenes. Tomi uses SwiftUI. The step scenes of the design kit (`docs/design/src/scenes3.py`) are drawn in code again when a graph step needs one, never a fitting-ish stand-in. The one exception is the app icon, which iOS only takes as an image: `AppIconArtwork` draws it from the same parts, `scripts/render-app-icon.sh` renders it into `AppIcon.appiconset`, and a test fails when the shipped files differ from the drawing (`docs/app-icon.md`). Never edit the icon files by hand. Tomi is one flat broadcast cartoon everywhere (#137, `docs/design/companion.md`): `TomiCompanion` animates him in a state (`CompanionState`), `CompanionSlot` places the animated companion on a screen such as onboarding, and `TomiMascot` prints him in a still pose. His pose and timing are plain values with unit tests (`CompanionPose`, `CompanionMotion`), sampled from the animation timeline, never the wall clock. He never opens a microphone or an AI session. Motion stops when the view is hidden or the scene inactive, Reduce Motion shows each state's complete still pose, and the drawing is hidden from VoiceOver.
- **Every view has a `#Preview`** with fake data, and renders correctly at the largest Dynamic Type size.

## Architecture

- **Feature folders.** Code is grouped by feature (`Onboarding`, `Home`, `Player`), not by kind. Once a feature folder or a TomiCore domain folder holds more than about 12 files, group them in subfolders by screen or role (for example `Suggestions/Menu`, `Suggestions/Detail`, `Suggestions/Formatting`). The subfolder names say where to look, and the test folders mirror them.
- **Three layers.** Screens (SwiftUI) call app services. Services call TomiCore and Apple frameworks. TomiCore imports nothing from Apple's UI, data or AI frameworks.
- **All rules the app keeps live in `Packages/TomiCore`:** reading the server's answers (including its progress snapshot, its cook-entry results and its quiz answers), the outbox of unsent cooks (which are pending, what each server result does to one, when to try again), the checked-suggestion guard, and what a tap changes in the profile. If it can be decided without a screen, it belongs there with a test. Food rules and progress rules (XP, rank, streak, levels, unlocks, mastery, grants, focus) belong on the server, never here.
- **The app computes no progress.** XP, rank, streak, levels, unlocks, mastery, grants and focus are worked out only by the server and shown from its snapshot. TomiCore has no `Game` folder and declares no `...Rules` type; an architecture test (`ServerGameRuleTests`) fails if either comes back. The phone's cook log is read only as the outbox of unsent cooks.
- **TomiCore is grouped by domain folder,** and its tests mirror the same folders: `Preferences`, `Server` (the server's answers and requests, in subfolders `Errors`, `Options`, `Profile`, `Scan`, `Suggestions`, `Recipe`, and `Progress` for the progress snapshot and cook-entry results, #158), `Progress` (the phone's cook log, read as the outbox of unsent cooks, #159, and what Home shows of the server's snapshot), `Design` (colour contrast) and `Utils` (small shared helpers). Subfolders inside a domain are allowed and expected. No Swift file sits in the root of `Sources/TomiCore` or `Tests/TomiCoreTests`. It stays one package and one module; folders are free, a second module is not.
- **The rules above are tests, not hopes.** `Packages/TomiCore/Tests/TomiCoreTests/Architecture` reads the source and fails when: the rules package imports anything but Foundation; app code imports a service framework (Speech, AVFoundation, SwiftData, CloudKit, AlarmKit, UIKit, PhotosUI, ImageIO, AuthenticationServices, Security, CryptoKit) outside its service folder (`Tomi/Voice`, `Tomi/Camera`, `Tomi/Persistence`, `Tomi/Timers`, `Tomi/Auth`); a Swift file sits in the root of the rules package; the rules package has a `Game` folder or declares a `...Rules` type; or a stored record has a property that is neither optional nor defaulted, a unique constraint, or a field the plan does not list. SwiftLint fails on `Calendar.current`, `Locale.current`, `Date()` and the like inside the rules package. When a rule here changes, change its test in the same pull request.
- **The server, sign-in, voice, camera, clock and storage sit behind protocols.** Each has a real implementation and a fake: `TomiAPI` (`URLSessionTomiAPI`, `FakeTomiAPI`), `AuthService` (`SupabaseAuthService`, `FakeAuthService`). The progress endpoints and the quiz are methods of `TomiAPI` too, and the outbox uploader (#162) is a service over `TomiAPI` and the store. Screens never import Speech, AVFoundation, SwiftData or AuthenticationServices directly. UI tests launch with `--fake-backend` (and `--fake-signed-in`, `--fake-no-suggestions`) and never reach the network.
- **No AI runs on the phone.** No Foundation Models: the server reads fridge photos and ranks dishes. When it cannot (`503 ai_unavailable`), the cook types what they have.
- **Sign-in is Supabase Auth with Sign in with Apple,** without a third-party SDK: Apple's identity token and the raw nonce go to `{SUPABASE_URL}/auth/v1/token?grant_type=id_token`, tokens are kept in the Keychain and renewed before expiry or after a 401. Request the email scope so Supabase Auth can store the contact address, including Apple's private relay address. Every call to the server carries `Authorization: Bearer <access token>`.
- **Addresses and keys come from build settings** (`TOMI_API_BASE_URL`, `TOMI_SUPABASE_URL`, `TOMI_SUPABASE_PUBLISHABLE_KEY` and, in Debug only, `TOMI_LOCAL_API_BASE_URL`, read through the Info.plist by `BackendConfiguration`). The committed values are the deployed Cloud Run server and the Supabase project; the URL and the publishable key are meant to ship in the app. Never type one into a Swift file. The app never holds a Supabase secret key, a service-role key or the database password.
- **Home shows the server's progress snapshot (#163).** `ProgressModel` shows the snapshot saved last at once, asks `GET /v1/progress` when Home appears or the app becomes active, keeps the answer as it was sent, and reads the store again after each upload. `HomeMenuProgress` joins the server's menu names to the snapshot's skills by id; a skill the snapshot does not name stays unknown, never zero or locked. Offline, `ShownProgress` keeps the last snapshot and names the unsent cooks in a note; it never adds them to a number. Nothing on the phone computes progress. It is learning progress, not server recipe eligibility. Current suggestions remain in the scan flow until the separate home-result integration is built.
- **The server's cook log is the source of truth** (decided 26 October 2026), per Supabase account. The server computes XP, rank, streak, levels, unlocks and mastery from it on demand and sends them as a versioned progress snapshot (`GET /v1/progress`, and in the answer to `POST /v1/cook-entries`). The phone keeps only the cooks not yet sent (the outbox) and the last snapshot, and never computes or predicts XP, rank, streak or mastery. Offline, it shows the last snapshot with a note that the pending cooks will count when the cook is back online.
- **A cook is written to the outbox first.** Each cook entry gets a client-made UUID when it is written and keeps it across every retry; the server is idempotent on that id. The server takes one cook entry per request (`POST /v1/cook-entries`), and only a graph recipe (`recipeId` with `graphVersion`): a cook of a bundled lesson has no dish, so it stays on the phone, is never sent and is never counted as waiting. The uploader sends the oldest pending cook, then the next, with retry and backoff, and acts on the result of each: `accepted` and `duplicate` forget the entry, `conflict` (same id, different body: the first accepted copy wins and the second changes nothing) forgets it and logs the id and code, `rejected` marks it refused and never retries it. A request the server cannot read (`422`) keeps every entry and is not sent again until the next launch. Each entry carries its own IANA time zone; the request carries the current calendar (`timeZone`, `firstWeekday`).
- **Saved data must stay iCloud-safe:** every stored property optional or defaulted, no unique constraints, changes additive only. Never rename or remove a stored field after release. The stored fields are listed in `docs/implementation-plan.md` (Saved data): a new field is added there in the same pull request.
- **Stored records hold no rules.** A SwiftData record in `Tomi/Persistence` only copies its fields to and from its plain twin in TomiCore (`SavedProfile`, `SavedCookEntry`, `SavedProgressSnapshot`), which has the same field names. `ProgressSnapshotRecord` keeps the server's snapshot exactly as it arrived, and TomiCore reads it (`lastSnapshot`). Each cook record keeps the IANA time zone it was cooked in, written when it is saved. How a record is read, how two records from two devices become one answer, and when a record is refused are decided in TomiCore and tested there without a store. Nothing is unique in the store, so every read must give the same answer for the same records in any order, with a cook entry counted once. `SavedActiveLesson` and its record are the bookmark of the removed lesson player: kept because stored fields are permanent, never read or written.
- **The server's profile is the source of truth for the cook's answers.** The stored `ProfileRecord` is the phone's copy of it (`ProfileCache`), used when cooking offline; it never decides what the cook may eat. A profile change sends only the changed fields with the version read (`ProfilePatch`); on `409 version_conflict` the cook's change is made again on the newer profile, and removing a diet or avoid item is sent with `allowWeakerRestrictions` only after the cook confirmed it on screen.
- **Saved data fails closed.** When the store cannot be opened or read, the store throws and the app shows that saved data is unavailable (`RootView`). Never carry on as if there were no unsent cooks, and never show a snapshot that cannot be read as zero progress.
- **Conflicting copies never depend on arrival order.** When different records share the newest id and timestamp, ordinary profile answers must be given again, with every saved food restriction kept. Identical copies still read once.
- **UI tests never touch the cook's own store.** They launch with `--store-in-memory`, or `--store-ui-test-file` when a test relaunches the app, and `--seed-known-state` for a known starting state (`StoreLaunchOptions`, `KnownState`). A test's progress comes from the fake server's fixture snapshots (`Tomi/Resources/Fixtures/progress-*.json`), chosen with `--fake-progress-new-cook` (the default) or `--fake-progress-returning`, and `--fake-cook-entries-offline` fails both progress calls as unreachable (`FakeProgressServer`); `KnownState` seeds unsent cooks and the returning fixture as the server's last snapshot, a signed-in cook's fake server keeps serving the fixture the phone saved last unless an argument names one, and the fake server never computes XP. They start as a new cook with `--store-start-empty`, and see light or dark with `--appearance-light` or `--appearance-dark` (`AppearanceLaunchOption`), because `XCUIDevice.appearance` has no effect on the simulator.
- **No third-party dependencies in the app** without the owner's approval.
- **Proof of concept: there is no consent step, and every fridge photo is kept.** The owner's decision, for testing by the owner and friends invited through TestFlight (decided 19 October 2026). A fridge photo is sent to the server as a small JPEG (long side at most `JPEGConverter.largestSide`, compressed to `JPEGConverter.quality`) with its own place, time and camera details, and the server keeps it as it arrived. **Before the app is offered to anyone outside TestFlight, a consent step must come first**: what is kept named in a text the cook agrees to, a way to withdraw that deletes it, and a privacy review. Chat and voice never leave the phone.

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

- The app shows a suggestion only when its `checked` diet equals the cook's diet and its `checked` avoid list holds every item the cook avoids. A profile, check or suggestion that cannot be read is refused, never read as "eats everything".
- The app holds no food rule of its own: no diet, avoid, fact, ingredient, equipment or cuisine list, and no filter. Food rules are reviewed in the server's repository.
- The phone applies no swap of its own. The server adapts each graph recipe in code and sends it with the changes it made (`recipe`, `changes`): the app shows that one recipe and the "What changed for you" list, adds no food-safety wording of its own and shows safety points only as the server names them. A suggestion without a readable `recipe` or `changes` is left out, as is any that cannot be read in full is left out, never read as allowed or empty. The guided steps record the cook (#186): finishing the last step writes a finished cook, leaving earlier a stopped-early one, under the entry id the quiz uses.
- A temperature, a cooking time claimed as safe, or a "safe to eat" statement comes only from the safety table. Tomi never judges from a photo whether food is cooked through.

**Unsent cooks, progress and the quiz**

Progress rules are reviewed in tomi-backend (its rules on the cook log: the same id counts once, no result depends on arrival order, an unknown skill or level is ignored for mastery, stopped early counts for nothing, the cook's calendar is passed in). On the phone:

- A cook is written to the outbox before anything else happens with it, and keeps its UUID across every retry. A new id for a retried cook is a P0: it can count twice.
- An entry leaves the outbox only on `accepted`, `duplicate` or `conflict`. It is never retried after `rejected`. A network failure, a server error or an unknown status keeps it.
- No screen shows XP, rank, streak or mastery that did not come from a server snapshot. Adding pending cooks to a number, or predicting one, is a bug.
- A snapshot that cannot be read, or is of an unknown schema version, is never shown as zero; the app says progress is unavailable.
- No quiz answer or answer index exists in the app, and no request carries one or `quizCorrect`.
- Inside TomiCore, `Calendar.current`, `Date()` and fixed lengths such as seven times 24 hours are bugs; the calendar and the clock are passed in.
- No progress rule lives in the app. A change that works out XP, rank, streak, levels, unlocks, mastery, grants or focus on the phone, or adds a game folder or a rules type to TomiCore, is a P1.

**Saved data and ids**

- A stored field or an id (skill, course, level number, lesson, ingredient, fact, diet, avoid item, equipment, cuisine) is permanent. Renaming, removing or reusing one is a P0. New fields are optional or have a default.
- Reading saved data must survive a missing field and a value from a newer version, without crashing and without weakening a safety filter.

**Content**

- No Swift file names a specific skill, course, ingredient, fact, diet, avoid item, piece of equipment or cuisine. No game number lives in the app (until #178, only the weekly goal's days of a week and default in `CookProfile`).

**Tests**

- Every rule changed or added has a test that fails when the rule is broken. Name the change that would slip through if one does not.
- A test never depends on the real clock, time zone, locale, network, camera or model.

**Pull request evidence**

- A pull request that changes the UI has current light and dark screenshots of the running app in its description, labelled with screen/state, device, iOS version and text size. No automated check verifies this, so the reviewer does. If the UI changed after the captures were posted, or they are missing, it is a P1.

A reviewer never merges and never pushes to `main`.
