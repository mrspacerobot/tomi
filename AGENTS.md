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
- **Lessons are files, never Swift.** One file per lesson under `Tomi/Resources/Library/lessons/<skill>/`, named by its lesson id, loaded through `LessonLibrary`. Xcode copies the library into the app flat, so every file name in it must be unique. The app must not care whether a lesson came from the bundle or a download.
- **Content words travel with the content.** Course, skill and level names and lesson text are `LocalizedText` in the library, English required, other languages optional. Screen words stay in the string catalog.
- **Skill and course ids are permanent,** like saved fields: cook logs keep them forever. Never rename or reuse one. Levels are numbered from 1 and a published number never changes meaning.
- **The catalog and lesson schemas live in TomiCore** and are shared with the generator. Changing one means bumping its schema version and updating the validator and its tests. The shipped files are checked by tests in TomiCore and in the app.
- **Diet and allergen tags are computed by code** from the ingredient table. They are never typed by a person or produced by a model. An ingredient missing from the table fails the build.
- **Food-safety facts come only from the safety table.** No temperature, time or allergen claim may be hard-coded in a view, a prompt or a lesson step without passing that check. Tomi never judges from a photo whether food is cooked through or safe to eat.
- **Game numbers live in one place** (`GameRules` in TomiCore): XP per cook, cooks to complete a level, XP per rank. No magic numbers in views.
- **Step scenes are a closed list.** A lesson may only name a scene that exists in the scene kit.

## Design system

- **No raw colours, fonts, spacing or radii in screens.** Use the tokens and components in `Tomi/DesignSystem`. If a token is missing, add it there, in light and dark.
- **Reuse before you build.** Search `DesignSystem` first. The second time something is needed, extract it into a component instead of copying it.
- **Illustrations are drawn in code** from shared parts. No image assets for Tomi or the scenes.
- **Every view has a `#Preview`** with fake data, and renders correctly at the largest Dynamic Type size.

## Architecture

- **Feature folders.** Code is grouped by feature (`Onboarding`, `Home`, `Player`), not by kind.
- **Three layers.** Screens (SwiftUI) call app services. Services call TomiCore and Apple frameworks. TomiCore imports nothing from Apple's UI, data or AI frameworks.
- **All rules live in `Packages/TomiCore`:** skills, unlocks, mastery, XP, streak, lesson matching, diet and allergen filtering. If it can be decided without a screen, it belongs there with a test.
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
