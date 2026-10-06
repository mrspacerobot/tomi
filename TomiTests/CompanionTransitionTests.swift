import Testing

@testable import Tomi

struct CompanionTransitionTests {
    @Test @MainActor func thinkingHandDepthEasesIntoThePose() {
        let rig = CompanionRig()
        let restingDepth = rig.rightArm.position.z
        rig.configure(CompanionPresentation(state: .thinking, moving: false))
        let thinkingDepth = rig.rightArm.position.z
        rig.configure(CompanionPresentation(state: .idle, moving: false))
        rig.configure(CompanionPresentation(state: .thinking, moving: true))
        rig.advance(by: 0.016)
        #expect(rig.rightArm.position.z < thinkingDepth)
        #expect(rig.rightArm.position.z > restingDepth)
    }

    @Test @MainActor func thinkingHandDepthEasesOutOfThePose() {
        let rig = CompanionRig()
        let restingDepth = rig.rightArm.position.z
        rig.configure(CompanionPresentation(state: .thinking, moving: false))
        let thinkingDepth = rig.rightArm.position.z
        rig.configure(CompanionPresentation(state: .idle, moving: true))
        rig.advance(by: 0.016)
        #expect(rig.rightArm.position.z < thinkingDepth)
        #expect(rig.rightArm.position.z > restingDepth)
    }

    @Test @MainActor func interruptedThinkingGestureReversesFromItsCurrentDepth() {
        let rig = CompanionRig()
        let restingDepth = rig.rightArm.position.z
        rig.configure(CompanionPresentation(state: .thinking, moving: true))
        rig.advance(by: 0.016)
        let intermediateDepth = rig.rightArm.position.z
        rig.configure(CompanionPresentation(state: .idle, moving: true))
        #expect(rig.rightArm.position.z == intermediateDepth)
        rig.advance(by: 0.016)
        #expect(rig.rightArm.position.z < intermediateDepth)
        #expect(rig.rightArm.position.z > restingDepth)
    }
}
