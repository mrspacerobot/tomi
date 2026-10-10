# Tomi

**Duolingo for cooking, starting from what's in your fridge.**

Snap a photo of your fridge. Tomi, a tomato chef mascot, picks tonight's recipe so it uses what you already have *and* practices the next skill on your cooking skill path. You cook along with illustrated, voice-guided steps, answer a quick quiz, and earn XP and streaks as you go.

> Status: native iPhone app in progress. Design approved, project scaffold built. See the [implementation plan](docs/implementation-plan.md), the [design mockups](docs/design/) and the [rules for contributors](AGENTS.md). The web prototype below is the original proof of concept.

## Try the prototype

- **Live version (with AI):** https://claude.ai/artifact/BrdEu3wKwsLi4wUEyfoAoa
  Open it on claude.ai while signed in. The AI features run on the viewer's own Claude account, so the prototype costs nothing to run.
- **Offline demo:** open [`prototype/index.html`](prototype/index.html) in any browser. Without claude.ai, the AI features are switched off, but the example lesson, skill path, lesson player, timers and voice all work.

### What the prototype does

- **Fridge scan:** take or upload a photo (plus optional pantry items). The AI identifies ingredients and builds one lesson.
- **Skill path:** 12 skills in 4 units (Foundations → Heat control → Building flavor → Putting it together). Each skill needs 2 cooks to master and unlocks the next ones.
- **Lesson player:** intro to the technique, one step per screen with an animated illustration (sear, flip, pour, stir, boil, chop, whisk, season, oven, plate, thermometer), step timers with an alarm, Tomi's tips, a quiz, and a confetti celebration.
- **Voice:** Tomi reads each step aloud using the device's built-in voice.
- **Ask Tomi:** a chat about the current recipe and step ("How do I know it's done?", "What can I use instead?").
- **Game layer:** XP, levels, day streaks, progress rings, crowns for mastered skills.

Progress is saved in the browser (localStorage) for now.

## Repository layout

```
Tomi.xcodeproj         Xcode project (open this)
Tomi/                  The iPhone app (SwiftUI)
TomiTests/             Unit tests
TomiUITests/           End-to-end UI tests
Packages/TomiCore/     Rules and data types, plain Swift, with tests
scripts/check.sh       Every check a change must pass
AGENTS.md              Rules for people and coding agents
docs/                  Product plan, implementation plan, design mockups
prototype/index.html   Original single-file web prototype
```

## Key decisions so far

| Topic | Decision |
|---|---|
| Name | **Tomi**, after the mascot. "Anyone Can Cook" was rejected: it's already under US trademark application for a cooking app and is Pixar's *Ratatouille* motto. |
| Platform | Native iPhone app (Swift / SwiftUI, iOS 27) |
| Design | "Tasting menu": the skill path is a menu of four courses and twelve dishes |
| Everyday AI | On Tomi's server (the Rust backend): fridge scan and tonight's ranking. The photo is sent only with the cook's consent. The app is a thin client of the server for food knowledge |
| Sign-in | Supabase Auth with Sign in with Apple |
| Voice | Apple SpeechAnalyzer (listening) + AVSpeechSynthesizer (speaking), both on-device and free |
| Recipes | Written in bulk by a top Claude model into a reviewed lesson library, not generated live for every user |
| Rules and game logic | Plain Swift code, no AI |

Full details: **[docs/plan.md](docs/plan.md)**.
