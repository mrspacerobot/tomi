# Tomi's animated companion

Issue #94 adds a native 3D character for cooking conversations; onboarding (#15) also shows it. The printed mascot, its
remaining moods (#11), and the lesson scenes stay separate. The approved `round3.html` tomato
chef supplies the identity: tomato-red body, cobalt facial features, periwinkle leaves, cream
three-lobed toque, small hands and feet. Rounded shared geometry and matte materials give the
same character depth; no model, texture or third-party package is downloaded.

## Interface and motion

`TomiCompanion` takes a `CompanionState`, a `turned` inspection choice and a `reduceMotion`
override. The five states are idle, listening, thinking, explaining and celebrating. Callers
supply state and adjacent localized status; the drawing is decorative and hidden from VoiceOver.
The component opens no microphone, camera or model and reads no cook data.

The rig owns the body, shoulder pivots, hands, eyes, brows and smiling mouth. Coordinated poses
change gaze, head angle, arm position and expression. Breathing, blinks, explaining gestures and
a restrained celebration bounce use elapsed render time, never a wall clock. Pose transitions ease
from the current pose, including the thinking hand's depth and when interrupted by another state.
Thinking pairs a hand at the cheek with an upward glance, gently lifted inner brows and a quiet
smile. The relaxed head angle and open expression should read as considerate curiosity.

Reduce Motion shows each state's complete still pose immediately. Hidden or inactive views cancel
the render subscription; a visible, active view resumes it. The subscription captures the rig weakly.
Pigments and studio lighting stay the same in both themes, on the design system's paper background.

## Inspect the running app

Build a Debug configuration and launch with `--component-gallery --store-in-memory`, then tap
"Meet animated Tomi". Choose each mood, turn the character, return to the components and reopen it.
The gallery and its launch handling are excluded from Release.

For direct inspection, `--companion-gallery --store-in-memory` opens the same gallery as a cover
of the component gallery, so Back still works. Optional arguments are `--companion-state` followed
by one of the five state raw values, `--companion-turn`, and `--companion-reduce-motion`.

Compare the identity with `docs/design/round3.html`, section `tomi-moods`. Inspect light and dark,
small and large iPhones and the largest accessibility text size. The controls remain scrollable,
stack into one column at accessibility text sizes, expose selection in words to VoiceOver and
keep 44-point touch targets. Review
motion live in the simulator; screenshots show expressions and layout, not animation quality.

Tests cover gallery navigation, state and depth controls, rendered character presence, largest
text, distinct still poses, reduced/inactive/hidden motion policy, pose changes and expression.

## In onboarding

Onboarding screens do not create a `TomiCompanion` each. A screen places a `CompanionSlot` (state and side,
sizes in `MascotSize`) and the flow draws one companion with `CompanionHost` at the slot, so the same
RealityView stays alive from the welcome to the diet question. Creating a new one just as the previous one
went away left it blank for about five seconds in the simulator. A screen with no slot leaves it invisible.
The welcome uses idle at the larger size; the diet greeting speaks, so it uses explaining at the smaller size.
