import Testing

@testable import Tomi

struct CompanionMotionTests {
    @Test func reducedMotionKeepsEveryPoseStill() {
        for state in CompanionState.allCases {
            let first = CompanionMotion.pose(state: state, elapsed: 0, moving: false)
            let later = CompanionMotion.pose(state: state, elapsed: 3, moving: false)
            #expect(first == later)
        }
    }

    @Test func animatedStatesChangeTheirBodyOrExpression() {
        for state in CompanionState.allCases {
            let first = CompanionMotion.pose(state: state, elapsed: 0, moving: true)
            let later = CompanionMotion.pose(state: state, elapsed: 1, moving: true)
            #expect(first != later)
        }
    }

    @Test func allStatesDifferWithoutMovement() {
        for first in CompanionState.allCases {
            for second in CompanionState.allCases where first != second {
                #expect(first.pose != second.pose)
            }
        }
    }

    @Test func reducedMotionOrInvisibilityOrInactivityPreventsMovement() {
        #expect(!CompanionMotionPolicy.moves(reduced: true, active: true, visible: true))
        #expect(!CompanionMotionPolicy.moves(reduced: false, active: false, visible: true))
        #expect(!CompanionMotionPolicy.moves(reduced: false, active: true, visible: false))
        #expect(CompanionMotionPolicy.moves(reduced: false, active: true, visible: true))
    }

    @Test @MainActor func aPausedRigIgnoresElapsedTimeAndResumesWhenActive() {
        let rig = CompanionRig()
        rig.configure(CompanionPresentation(state: .celebrating, moving: false))
        let paused = rig.body.transform
        rig.advance(by: 1)
        #expect(rig.body.transform == paused)
        rig.configure(CompanionPresentation(state: .celebrating, moving: true))
        rig.advance(by: 0.05)
        #expect(rig.body.transform != paused)
    }
}
