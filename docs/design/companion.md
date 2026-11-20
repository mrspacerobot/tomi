# Tomi, the cartoon companion

Issue #137 redraws Tomi as a flat broadcast cartoon, direction A of the companion design round
(`companion-directions.html`, chosen by the owner on 18 October 2026). It replaces both the sphere-built
RealityKit companion of #94 and the old printed mascot. Tomi is drawn in one style everywhere.

## The character

Tomi stays a tomato chef in the Tasting menu palette: tomato body, cream toque, cobalt shoes. The owner
had the leaf removed on 19 October: it was too small to read, and the toque and tomato body carry him.
What changed is the drawing: a thick ink line, a face that fills the body (tall eyes with big pupils,
thick brows, a filled grin with a tongue), rubber-hose arms and legs with no elbows or knees, puffy white
gloves with a cuff and a thumb. The body is flat with one cel-shaded crescent and a shine,
and rosy cheeks. On night ink a soft warm glow lifts him off the ground; on paper there is no glow, so his
outline stays crisp. The look takes the qualities of the reference the owner gave (a lively
cartoon host), not the look of any existing character.

Proportions, line weights and timing come from the `poseA` sketch and the `a-*` keyframes of the concept page.
All units are those of the sketch (200 by 240), placed on a 240 by 270 grid (`CompanionGrid`) that leaves room
above for the celebration jump, the thought dots and the sparkles. A screen gives Tomi a frame and Tomi at rest
fills it, toque to shoes (`CompanionGrid.figureBox`); the rest of the grid spills past the frame's edges
(`CompanionOverflowLayout`), so a jump or a sparkle never makes him small. Frame sizes follow the mockups
(`MascotSize`): 174 points on the welcome, sign-in, home and starting screens, 89 beside the diet greeting,
106 beside the "nothing tonight" notice. On the welcome he stands on a 232-point wash disc, as in `ob-welcome`.

## The five states

| State | Still pose | Motion |
|---|---|---|
| idle | Right glove raised in a hello, friendly smile | Squash, stretch into a hop, land and settle (1.6 s, overshooting ease); the hand waves (1.1 s); blinks (3.4 s) |
| listening | Leaning in, a glove cupped by the side of the face (an open "C" of curled fingers towards the face), eyes wide, brows up, small smile | Leans further in and back like nodding along (2.4 s); the cupped hand moves with it; slower blinks |
| thinking | Glove at the chin, eyes glancing up, one brow raised, a "hmm" mouth, three thought dots | The hand taps the chin (0.9 s); the glance drifts; the dots pulse in turn (1.2 s, a fifth of a second apart) |
| explaining | Both gloves open to the sides, brows lifted, mouth mid-word | A small bob on each beat (0.8 s); the hands gesture in turn (1.6 s); brows lift on the stressed word; the mouth cycles through grin and round shapes every 0.13 s |
| celebrating | Both arms thrown up, happy closed eyes, wide open laugh, yolk sparkles | A deep squash, a big jump with a twist, a landing squash (1.2 s, overshooting ease); arms cheer; sparkles twinkle |

Each still pose carries its whole meaning, so Reduce Motion and the printed mascot lose nothing. Tests hold
that no two still poses are the same, both as numbers and as drawn pictures.

## How it is built

Everything is SwiftUI in `Tomi/DesignSystem/Companion`, with no image, model or third-party code.

- `Pose`: plain values for one moment: `CompanionPose` (body, both arms, face, extras), each part blendable
  (`CompanionBlendable`). `CompanionState.stillPose` gives each state's still pose.
- `Motion`: `CompanionKeyframes` is a repeating keyframe track like a CSS animation, with `CompanionEasing`
  cubic Bezier curves; the tracks hold the concept page's timings. `CompanionMotion.pose(state:elapsed:moving:)`
  samples a pose from elapsed seconds and gives the still pose when not moving. `CompanionTransition` eases
  from the pose on screen into a new state in 0.22 seconds. `CompanionClock` turns the timeline's frames into
  seconds of motion (`CompanionElapsed`), counted only between moving frames: time while stopped (inactive,
  hidden, Reduce Motion) does not count, so Tomi resumes where he stopped. A change of state starts its ease on
  the frame that sees it. All of it is unit tested without a screen.
- `Drawing`: one part per piece of the character (`CompanionBodyPart`,
  `CompanionToquePart`, `CompanionEyesPart`, `CompanionBrowsPart`, `CompanionMouthPart`, `CompanionArmPart`,
  `CompanionGlovePart`, `CompanionCupPart`, `CompanionLegPart`, `CompanionExtrasPart`), painted back to front by
  `CompanionDrawing` into a `Canvas`. Legs and brows are drawn once and mirrored. The left arm sits behind the
  body and the right in front, so a hand at the chin reads clearly.
- Colours are design tokens (`ColorRole.companion*`, `printRed` and `yolk`), with light and dark values in
  `Tokens.xcassets`. On night ink the outline and limbs turn periwinkle so they stay visible, while the face
  stays dark ink because it sits on the white eyes and the tomato. Line weights are in `CompanionInk`.

## Views

- `TomiCompanion(state:reduceMotion:)` animates with `TimelineView(.animation)` while the view is visible, its
  scene is active and Reduce Motion is off (`CompanionMotionPolicy`). Otherwise the timeline pauses and the
  still pose shows. It is decorative and hidden from VoiceOver; callers give any words beside it.
- `CompanionSlot(state:side:)` is the animated companion in a square on a screen, with the identifier
  `tomi-companion` for UI tests. Onboarding uses it: idle on the welcome, explaining beside the diet greeting,
  idle on the other questions.
- `TomiMascot(mood:)` is Tomi printed on a page: a still pose that never moves. Sign-in and home use the idle
  hello; the scan's "nothing tonight" and the starting screen use thinking.
- Sizes are in `MascotSize`.

The Cooking Show uses the same five poses and animation timeline with the palette from round 13.
Pass `appearance: .cookingShow` when moving a screen to the new look. `TomiHostHead` draws the shared
face and toque without arms or legs and fits the smaller portrait frame from the mockup. It is decorative,
and the tab or message around it carries the accessibility label.

The companion opens no microphone, camera or model and reads no cook data.

## Inspect the running app

Build a Debug configuration and launch with `--component-gallery --store-in-memory`, then tap "Meet animated
Tomi". Choose each mood and use "Hold still" to see its still pose. The gallery is excluded from Release.

`--companion-gallery --store-in-memory` opens the same gallery directly. Optional arguments are
`--companion-state` followed by a state's raw value, `--companion-still`, and `--companion-reduce-motion`.

Compare with `companion-directions.html`, direction A. Look at light and dark, small and large iPhones and the
largest accessibility text size, and review motion live in the simulator: screenshots show the poses, not the
timing.

Launch with `--show-host-gallery --fake-backend --store-in-memory` to compare all five still poses and
the compact head with round 13 in morning and evening lighting.
