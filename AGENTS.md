# Tomi: rules for anyone writing code here

Tomi is a native iPhone app (SwiftUI, iOS 27) that teaches cooking from what is in your fridge. This file is the steering document for humans and coding agents. Read it before changing anything. If a rule here is wrong, change the rule in the same pull request, do not quietly ignore it.

- What we are building and in what order: `docs/implementation-plan.md`
- What it must look like: `docs/design/` (approved mockups, direction "Tasting menu")
- Work items: GitHub issues, grouped by milestone. One issue is one pull request.

## Before you call anything done

```
./scripts/check.sh
```

It runs the formatter's lint, SwiftLint (size limits, hard-coded text, banned calls), the rules package tests, and the app's unit and UI tests in the simulator. Tools needed once: Xcode 27 and `brew install swiftlint`. It must pass with no warnings you introduced. Then run the app in the simulator and look at what you changed, in light and dark, next to the mockup. If something looks off, even something you did not touch, fix it or open an issue.

Report honestly: if a check fails or you skipped a step, say so.

**Every pull request to `main` runs the same check automatically** (`.github/workflows/check.yml`), on the owner's Mac. It shows on the pull request as "Check". If the Mac is busy, asleep or off, the check waits and runs when the Mac is free. GitHub cannot require a green check on this repository, so the rule is written here instead: the owner merges only when the check is green. Running it yourself first is still required; the automatic run is the proof, not the first try.

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
- **Lessons are files, never Swift.** One file per lesson under `Tomi/Resources/Library/lessons/<skill>/`, named `<lesson id>.lesson.json`, read through `Lesson.decode(from:catalog:table:)` and served by `LessonLibrary`. Xcode copies the library into the app flat, so the `.lesson.json` ending is how a lesson is told from `catalog.json` and `ingredients.json`, and the lesson id in the name keeps every file name unique. A file that fails validation, or is not named by its id, is skipped and logged, never shown. The app must not care whether a lesson came from the bundle or a download.
- **Lesson amounts are numbers with a unit from a closed list** (`Amount`, `AmountUnit`), written once in metric and once in cups for each ingredient. Never write an amount, a temperature or a unit into step text: code must be able to scale and format it.
- **Content words travel with the content.** Course, skill and level names and lesson text are `LocalizedText` in the library, English required, other languages optional. Screen words stay in the string catalog.
- **Skill and course ids are permanent,** like saved fields: cook logs keep them forever. Never rename or reuse one. Levels are numbered from 1 and a published number never changes meaning.
- **The catalog, ingredient table and lesson schemas live in TomiCore** and are shared with the generator. Changing one means bumping its schema version and updating the validator and its tests. The shipped files are checked by tests in TomiCore and in the app.
- **The ingredient table is a file, never Swift.** Every ingredient Tomi knows lives in `Tomi/Resources/Library/ingredients.json`, read through `IngredientTable.decode(from:)`. The same file declares the list of facts (`dairy`, `gluten`, ...), the avoid items with the facts that trigger each, and the diets with the facts each rules out. An ingredient has an id, a name and a `contains` list of declared facts. Every field is required: a plain plant ingredient writes `"contains": []`, so a forgotten list is an error and never "contains nothing". An undeclared fact, an unknown field, an avoid item that nothing triggers or a diet that rules nothing out rejects the whole file. No Swift file names a fact, a diet or an avoid item. All these ids are permanent, like skill ids: saved preferences keep them.
- **Diet and allergen tags are computed by code** from the ingredient table. They are never typed per dish by a person or produced by a model: what a dish triggers and which diets it suits are both worked out from its ingredients' `contains` lists, so they cannot disagree. A lesson file that carries a field for them is rejected. A lesson's tags are `Lesson.tags(in:)`, worked out again after a swap with `Lesson.applying(_:)`. When a fact is uncertain in real life, the table takes the stricter answer, and a variant that is known to be fine is its own ingredient (parmesan and vegetarian hard cheese, stock and vegetable stock). A generic ingredient that could hide an allergen is not listed at all: there is no "cooking oil", because it could be peanut, sesame or soy oil. A lesson names the oil it means.
- **Anything the table does not list refuses, never passes.** `IngredientTable` throws for an ingredient id it does not list. A diet or avoid item in the cook's preferences that it does not list makes every dish unavailable (`understands(_:)` says so), because it may be a restriction saved by a newer app or an answer that could not be read. The tests over the shipped files, in TomiCore and in the app, fail when the table is invalid or lacks an ingredient the app relies on: the cupboard staples and every ingredient of every shipped lesson. `./scripts/check.sh` and the "Check" on every pull request run those tests.
- **A model never adds to the lists.** Skills, levels, facts, avoid items, diets and ingredients are added only by a person, in a reviewed change to `catalog.json` or `ingredients.json`. The lesson generator writes lesson files and nothing else. It is handed the allowed skills, levels and ingredient ids as a closed list read from those two files, and the validator rejects any lesson that names something outside them. On the phone the model only ranks existing lessons and applies swaps a lesson already lists.
- **Food-safety facts come only from the safety table.** No temperature, time or allergen claim may be hard-coded in a view, a prompt or a lesson step without passing that check. Tomi never judges from a photo whether food is cooked through or safe to eat.
- **Lesson coverage is a ratchet.** `docs/lesson-coverage-gaps.txt` lists every level of every technique that has no lesson yet, per diet. A test fails when the shipped library has a gap that is not listed, and when a listed gap has been closed. After adding lessons, rewrite the list with `TOMI_UPDATE_COVERAGE=1 swift test --package-path Packages/TomiCore`. Never add a line by hand to make the test pass.
- **Game numbers live in one place** (`GameRules` in TomiCore): XP per cook, cooks to complete a level, XP per rank. No magic numbers in views.
- **Step scenes are a closed list** (`StepScene` in TomiCore, the actions drawn in `docs/design/src/scenes3.py`). Every step names one, and it must show what the step does, with the right vessel and tool. Never pick the nearest scene that exists: a wrong picture misleads and passes every check. If no scene fits, the scene is drawn first and the lesson waits for it. There is no blank or fallback drawing.
- **A lesson names its main food** (`DishMain`, also a closed list from the kit: chicken, tofu, omelette). Scenes that show the food, such as sear, flip, roll, rest and plate, draw that main, so an omelette lesson never shows a chicken thigh.
- **A new scene or main is drawn in the kit first,** then added to `StepScene` or `DishMain` (additive only, raw values permanent), and released in the app before any library uses it. A lesson that names one an older app does not know is not shown there until that app is updated.
- **Equipment is an id without a list yet** (#86). Until the library lists the equipment, a test over the shipped lessons allows only the equipment of the kitchen screen, because the lesson validator cannot check it.

## Design system

- **No raw colours, fonts, spacing or radii in screens.** Use the tokens and components in `Tomi/DesignSystem`. If a token is missing, add it there, in light and dark.
- **Reuse before you build.** Search `DesignSystem` first. The second time something is needed, extract it into a component instead of copying it.
- **Illustrations are drawn in code** from shared parts. No image assets for Tomi or the scenes.
- **Every view has a `#Preview`** with fake data, and renders correctly at the largest Dynamic Type size.

## Architecture

- **Feature folders.** Code is grouped by feature (`Onboarding`, `Home`, `Player`), not by kind.
- **Three layers.** Screens (SwiftUI) call app services. Services call TomiCore and Apple frameworks. TomiCore imports nothing from Apple's UI, data or AI frameworks.
- **All rules live in `Packages/TomiCore`:** skills, unlocks, mastery, XP, streak, lesson matching, diet and allergen filtering. If it can be decided without a screen, it belongs there with a test.
- **TomiCore is grouped by domain folder,** and its tests mirror the same folders: `Catalog` (skills, courses, levels), `Ingredients`, `Lessons`, `Preferences`, `Progress` (the cook log and what follows from it), `Game` (XP, rank, streak) and `Utils` (small shared helpers). No Swift file sits in the root of `Sources/TomiCore` or `Tests/TomiCoreTests`. It stays one package and one module; folders are free, a second module is not.
- **The rules above are tests, not hopes.** `Packages/TomiCore/Tests/TomiCoreTests/Architecture` reads the source and fails when: the rules package imports anything but Foundation; app code imports a service framework (FoundationModels, Speech, AVFoundation, SwiftData, CloudKit, AlarmKit, UIKit) outside its service folder (`Tomi/AI`, `Tomi/Voice`, `Tomi/Camera`, `Tomi/Persistence`, `Tomi/Timers`); a Swift file names an id of the shipped library as a string; a Swift file sits in the root of the rules package; or the scenes and mains in code differ from the ones the design kit draws. SwiftLint fails on `Calendar.current`, `Locale.current`, `Date()` and the like inside the rules package. When a rule here changes, change its test in the same pull request.
- **AI, voice, camera, clock and storage sit behind protocols.** Each has a real implementation and a fake. Screens never import FoundationModels, Speech, AVFoundation or SwiftData directly.
- **The app must work without Apple Intelligence.** Every AI feature has a typed or code-only fallback.
- **The cook log is the source of truth.** XP, streak and mastery are computed from it, not stored as running totals.
- **Saved data must stay iCloud-safe:** every stored property optional or defaulted, no unique constraints, changes additive only. Never rename or remove a stored field after release.
- **No third-party dependencies in the app** without the owner's approval.
- **Photos, chat and voice never leave the phone.**

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
- **At most three parameters.** More means a missing type: group them into a struct.
- **Plain statements over clever expressions.** No ternaries. Do not pack `?.`, `??`, `.map` and closures into one line: unwrap with `guard let` or `if let`, give each step a name, and let the names tell the story. A reader who knows Java or Kotlin but not Swift should be able to follow it.
- **Typed values, not strings, in tests too.** A date is built from numbers (`.october(5)`), never parsed from text like `"2026-10-05"`.
- **Names say what, comments say why.** No abbreviations, no commented-out code, no TODO without an issue number.
- **No force unwraps, `try!` or `fatalError` in app code.** Handle the failure and show Tomi's words for it from the string catalog. Tests may force unwrap.
- **No `print`.** Use `Logger`. Never log photos, ingredients or chat text.
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
- **When a decision changes,** update `docs/implementation-plan.md` and this file in the same pull request.

## Code Review Rules

For any agent or person reviewing a pull request here. Formatting, size limits and hard-coded text are checked by `./scripts/check.sh`; do not review those.

**What counts as high priority here**

- **P0, blocks the merge:** a cook can be shown food they said they cannot eat, or saved data can be lost or misread.
- **P1, must be fixed:** a rule gives a wrong result for some input, a rule has no test that would catch it being broken, or a decision changed without its test and its documentation.
- Report each finding with the input or order of events that goes wrong, what the code does, and what it should do. If you cannot construct one, ask it as a question.

**Food safety**

- An ingredient, diet, avoid item or ingredient fact that is unknown, missing or cannot be read must make the dish unavailable. It must never be read as "allowed", "suitable" or "contains nothing". This holds for values written by a newer version of the app too.
- Diet and allergen tags are computed from the ingredient table every time. They are never stored in a lesson file, typed by a person, or produced by a model.
- After anything changes a lesson's ingredients (a swap, an AI adaptation, a different serving size), the lesson is checked against the cook's diet and avoid list again before it is shown.
- A temperature, a cooking time claimed as safe, or a "safe to eat" statement comes only from the safety table. Tomi never judges from a photo whether food is cooked through.

**The cook log and what follows from it**

- Progress, XP, rank and streak are computed from the cook log on demand. A stored total is a bug.
- The same entry id arriving twice counts once. Two logs merged in either order give the same result. No result may depend on the order of the entries.
- An entry for a skill, level or lesson this version does not know is ignored for progress and never crashes. An entry marked stopped early counts for nothing.
- Week and day arithmetic uses the `Calendar` passed in. Inside TomiCore, `Calendar.current`, `Date()` and fixed lengths such as seven times 24 hours are bugs: they break at a daylight saving change, a different first weekday, or in a test.

**Saved data and ids**

- A stored field or an id (skill, course, level number, lesson, ingredient, fact, diet, avoid item, equipment, cuisine) is permanent. Renaming, removing or reusing one is a P0. New fields are optional or have a default.
- Reading saved data must survive a missing field and a value from a newer version, without crashing and without weakening a safety filter.

**Content files**

- A change to the layout of a content file (catalog, ingredients, lesson) needs a schema version bump, a validator rule and a test with a failing file.
- A file from an unknown schema version is rejected before anything else in it is read.
- Whatever the validator accepts, the app must be able to use. Whatever a comment or document says the validator checks, it must check.
- No Swift file names a specific skill, course, ingredient, fact, diet, avoid item or cuisine. No game number lives outside `GameRules`.
- `catalog.json` and `ingredients.json` are changed only by a person. A generated or model-written change that adds a skill, level, fact, avoid item, diet or ingredient is a P0, whatever the validator says.

**Tests**

- Every rule changed or added has a test that fails when the rule is broken. Name the change that would slip through if one does not.
- A test never depends on the real clock, time zone, locale, network, camera or model.

A reviewer never merges and never pushes to `main`.
