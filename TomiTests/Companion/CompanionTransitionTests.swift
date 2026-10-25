import Testing

@testable import Tomi

/// A change of state eases from where Tomi was, so an arm never jumps across the body.
struct CompanionTransitionTests {
    let from = CompanionState.idle.stillPose
    let target = CompanionState.celebrating.stillPose

    @Test func aTransitionStartsFromTheOldPose() {
        let transition = CompanionTransition(from: from, startedAt: 10)
        #expect(transition.pose(toward: target, at: 10) == from)
    }

    @Test func aTransitionEndsOnTheNewPose() {
        let transition = CompanionTransition(from: from, startedAt: 10)
        #expect(transition.pose(toward: target, at: 10 + CompanionTransition.duration) == target)
        #expect(transition.isFinished(at: 10 + CompanionTransition.duration))
    }

    @Test func halfwayTheArmIsBetweenBothPoses() {
        let transition = CompanionTransition(from: from, startedAt: 0)
        let middle = transition.pose(toward: target, at: CompanionTransition.duration / 2)
        let lowest = min(from.leftArm.hand.y, target.leftArm.hand.y)
        let highest = max(from.leftArm.hand.y, target.leftArm.hand.y)
        #expect(middle.leftArm.hand.y > lowest)
        #expect(middle.leftArm.hand.y < highest)
        #expect(!transition.isFinished(at: CompanionTransition.duration / 2))
    }
}
