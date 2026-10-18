import Testing

@testable import Tomi

/// Motion is sampled from elapsed render time, so every rule here can be checked without a screen or a clock.
struct CompanionMotionTests {
    @Test(arguments: CompanionState.allCases)
    func aStillPoseDoesNotChangeWithTime(state: CompanionState) {
        let first = CompanionMotion.pose(state: state, elapsed: 0, moving: false)
        let later = CompanionMotion.pose(state: state, elapsed: 2.7, moving: false)
        #expect(first == later)
        #expect(first == state.stillPose)
    }

    @Test(arguments: CompanionState.allCases)
    func everyStateMovesWhenAllowed(state: CompanionState) {
        let samples = stride(from: 0.0, through: 3.0, by: 0.1).map { elapsed in
            CompanionMotion.pose(state: state, elapsed: elapsed, moving: true)
        }
        let first = samples[0]
        #expect(samples.contains { $0 != first })
    }

    @Test func everyStateLooksDifferentWhenStill() {
        for first in CompanionState.allCases {
            for second in CompanionState.allCases where first != second {
                #expect(first.stillPose != second.stillPose)
            }
        }
    }

    @Test func reducedMotionOrInvisibilityOrInactivityStopsMovement() {
        #expect(!CompanionMotionPolicy.moves(reduced: true, active: true, visible: true))
        #expect(!CompanionMotionPolicy.moves(reduced: false, active: false, visible: true))
        #expect(!CompanionMotionPolicy.moves(reduced: false, active: true, visible: false))
        #expect(CompanionMotionPolicy.moves(reduced: false, active: true, visible: true))
    }

    @Test func idleSquashesBeforeItStretchesIntoTheHop() {
        let squash = CompanionMotion.pose(state: .idle, elapsed: 0.12 * 1.6, moving: true).body
        let stretch = CompanionMotion.pose(state: .idle, elapsed: 0.30 * 1.6, moving: true).body
        #expect(squash.stretchX > 1)
        #expect(squash.stretchY < 1)
        #expect(stretch.stretchY > 1)
        #expect(stretch.lift < -10)
    }

    @Test func theEyesBlinkBrieflyAndOpenAgain() {
        let open = CompanionMotion.pose(state: .idle, elapsed: 1, moving: true).face.eyes.openness
        let shut = CompanionMotion.pose(state: .idle, elapsed: 0.95 * 3.4, moving: true).face.eyes.openness
        #expect(open == 1)
        #expect(shut < 0.2)
    }
}
