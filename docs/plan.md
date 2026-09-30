# Tomi: research, business model and product plan

Summary of the planning work done on 30 September 2026. Numbers are rough estimates unless a source is linked. Re-check prices and platform details before relying on them.

---

## 1. The idea

A cooking app that combines:

1. **Practical:** "This is in my fridge. What can I cook tonight?"
2. **Learning:** a Duolingo-style skill path with streaks, XP and short lessons, so each meal teaches one technique.

## 2. Market check

Apps exist for each half, but we found none that connects them.

**Learning apps (the "Duolingo" half)**
- [Parsnip](https://www.hngry.tv/articles/parnsip-builds-the-duolingo-for-home-cooking/): 400+ skill levels, streaks, AI-generated lessons. Closest to Tomi, but not built around your fridge.
- [Zest](https://www.launch.co/post/investment-spotlight-zest-la29): skill levels 1–6, quizzes, badges, aimed at Gen Z.
- Culinario: Duolingo-style fundamentals (salt, fat, acid, heat).
- [Seasoned](https://mwm.ai/apps/seasoned/6772698565): gamified meal planning with XP (launched May 2026).

**Fridge scanner apps (the practical half)**
- [CookScope](https://apps.apple.com/app/id6759489206), [SnapChef](https://apps.apple.com/app/id6783267721), [FridgeFlow AI](https://www.producthunt.com/products/fridgeflow-ai), [Fridgey](https://apps.apple.com/us/app/-/id6760131643), [FridgeGuru](https://apps.appfollow.io/ios/fridgeguru-instant-recipes/6744972829?country=do), [FridgeSnap AI](https://apps.apple.com/us/app/-/id6751930901)
- They take a photo and suggest recipes. At most they have a single "beginner / intermediate / pro" setting. None tracks which techniques you've learned or picks tonight's recipe to practice the next one.

**The gap:** "Here's your fridge, so tonight's lesson is pan sauces, using your chicken thighs and that half lemon."

## 3. Revenue scenarios

Assumptions: freemium, about $7/month or $50/year, about $40/year kept after app store fees, and 2–5% of active users paying (3% used below).

| Scenario | Active users | Paying | Revenue per year |
|---|---|---|---|
| Side project | 5,000 | 150 | ~$6K |
| Decent traction | 50,000 | 1,500 | ~$60K |
| Real success | 500,000 | 15,000 | ~$600K |
| Breakout | 5M+ | 150K+ | $6M+ |

- Most consumer apps land in the first row. Getting users is harder than building the app.
- Cooking apps struggle to keep users. Streaks and a skill path are designed to fix that.
- Extra income options: grocery affiliate links for missing ingredients, sponsored recipes, a premium coaching tier.
- **Cheapest validation:** short TikTok/Reels clips ("I pointed my phone at my fridge and it taught me pan sauces") plus a waitlist.

## 4. AI costs

### If everything ran on the Claude API

| Action | Haiku 4.5 | Sonnet 5.5 | Opus 5.5 |
|---|---|---|---|
| Fridge photo → full lesson | ~1¢ | ~2.5¢ | ~5¢ |
| One chat question | ~0.15¢ | ~0.3¢ | ~0.6¢ |

API prices per million tokens (input/output): Haiku 4.5 $1/$5, Sonnet 5.5 $2/$10, Opus 5.5 $4/$20, Fable 5.1 $10/$50.

- An active user (~15 scans and ~65 questions a month) costs about $0.25–0.60 a month, against about $3.30 a month of revenue per paying user.
- **The risk is free users.** At 50,000 users with 3% paying, cloud AI would cost about $43K a year against about $60K of revenue. Free usage must be capped.

### Running models locally

| Setup | AI cost per year (50K-user example) |
|---|---|
| Everything in the cloud | ~$43K |
| Chat and ingredient spotting on the phone, lessons from the cloud | ~$15–20K |
| On-device plus a lesson library, cloud only as a fallback | ~$4–8K |
| **iOS 27 plan (below)** | **~$0 ongoing** plus a one-time library cost |

Renting GPU servers to run open models only pays off at a large scale. Skip it.

## 5. Platform: native iPhone app (iOS 27)

As of WWDC 2026, Apple's **Foundation Models framework** covers almost everything Tomi needs, for free ([Apple WWDC26 iOS guide](https://developer.apple.com/wwdc26/guides/ios/)):

- **On-device model:** free, private, works offline. It supports **image input** (it can look at a fridge photo), typed output (`@Generable`), and **tool calling** (the AI can trigger app actions).
- **Private Cloud Compute:** Apple's larger model, at "no cloud API cost" for members of the App Store Small Business Program with fewer than 2 million downloads.
- **`LanguageModel` protocol:** swap in Claude or Gemini for any single task with one line of code.
- **Speech:** SpeechAnalyzer and SpeechTranscriber (on-device listening, iOS 26+), SpeechDetector (notices when you start and stop talking), AVSpeechSynthesizer (Tomi's voice).

### Costs to build

| Item | Cost |
|---|---|
| Xcode | Free, but **requires a Mac** |
| Running on your own iPhone | Free with an Apple ID (re-install every 7 days) |
| AI, speech and voice | $0 |
| Apple Developer Program (TestFlight, App Store, Small Business Program) | $99/year |

**Blockers and risks**
- A Mac is required. Current development machine is Windows.
- Apple's AI needs a recent iPhone that supports Apple Intelligence (historically iPhone 15 Pro and newer). Confirm for iOS 27.
- The on-device model's recipe quality is untested.
- Limits on the free cloud model aren't documented on Apple's page.

### Hands-free voice loop

```
User speaks → SpeechAnalyzer (text) → Foundation Models session
            → tool calls: nextStep(), startTimer(minutes:), repeatStep()
            → AVSpeechSynthesizer (Tomi speaks) → listen again
```

Check common commands ("next", "repeat", "timer") with simple matching first, and only use AI for everything else. Keep a "hold to talk" button as a backup for noisy kitchens.

## 6. What AI does and doesn't do

| Task | Approach |
|---|---|
| Spot ingredients in the photo | On-device model with image input. Always show editable chips. |
| Pick tonight's lesson | Code filters the library, AI ranks and adapts (substitutions, servings) |
| Brand-new recipe when nothing matches | Claude (Opus 5.5) live, ~5–10¢; paid plan only; saved back into the library |
| Ask Tomi chat | On-device model, given the current recipe and step |
| Voice commands | On-device model with tool calling |
| Food-safety answers (temperatures, allergens) | **Looked up in our own fact table**, never invented by AI |
| "Is my chicken done?" from a photo | **Not built.** Say "use a thermometer" instead. |
| Quiz questions | Written with the library and checked, not generated live |
| Skill tree, XP, streaks, timers, reminders, saving progress | Plain Swift (SwiftData, local notifications) |

## 7. Recipe strategy: a smart model builds the library

Generate lessons **once, in bulk**, with a top Claude model, then reuse them for every user for free.

| Model | 500 full lessons (Batch API, 50% off) |
|---|---|
| Claude Opus 5.5 | ~$22 |
| Claude Fable 5.1 | ~$55 |

Quality checks for every generated lesson:
1. A fixed structure (structured outputs) for steps, times, temperatures and quiz
2. Code checks against a food-safety table (meat temperatures, sensible cooking times, allergen flags)
3. A second-model review ("Is the quiz answer correct? Do the steps match the ingredients?")
4. Human spot checks, especially early on
5. User 👍/👎 after cooking. Low-rated lessons get fixed or removed.

## 8. Naming

- Chosen: **Tomi**, named after the mascot the way Duolingo's owl is its brand. Short and works in any language.
- Rejected: "Anyone Can Cook". A [US trademark application for a cooking app](https://trademark.justia.com/owners/cavoli-ltd-6182572) exists, it's a Kitchen Stories cookbook title, and it's Pixar's *Ratatouille* motto.
- Tagline idea: *"If you can open a fridge, you can cook."*
- Before launch: run a proper trademark and App Store name check for "Tomi".

## 9. Next steps

1. [ ] Get access to a Mac (own, borrowed or rented) and confirm the test iPhone supports Apple Intelligence on iOS 27.
2. [ ] Write the lesson-generation script (runs on Windows) and a **test batch of 10 "Pan sauces" lessons** (~$1) to judge quality.
3. [ ] Scaffold the Xcode project: camera scan → ingredient chips, lesson player with step animations, skill path, SwiftData progress.
4. [ ] Add Ask Tomi chat and the hands-free voice loop.
5. [ ] Test the on-device model against a set of ~30 real fridge photos and questions.
6. [ ] Record short demo videos and start a waitlist to test demand.
7. [ ] Join the Apple Developer Program ($99/year) when ready for TestFlight testers.
