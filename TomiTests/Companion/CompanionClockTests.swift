import Foundation
import Testing

@testable import Tomi

/// The clock counts from the first frame drawn and eases a change of state from the pose on screen.
@MainActor struct CompanionClockTests {
    let first = Date(timeIntervalSinceReferenceDate: 1000)

    @Test func theFirstFrameIsTheStartOfTheMotion() {
        let clock = CompanionClock()
        let pose = clock.pose(state: .idle, at: first, moving: true)
        #expect(pose == CompanionMotion.pose(state: .idle, elapsed: 0, moving: true))
    }

    @Test func laterFramesAreCountedFromTheFirst() {
        let clock = CompanionClock()
        _ = clock.pose(state: .idle, at: first, moving: true)
        let pose = clock.pose(state: .idle, at: first.addingTimeInterval(0.5), moving: true)
        #expect(pose == CompanionMotion.pose(state: .idle, elapsed: 0.5, moving: true))
    }

    @Test func aChangeOfStateEasesFromThePoseOnScreen() {
        let clock = CompanionClock()
        let before = clock.pose(state: .idle, at: first, moving: true)
        let next = clock.pose(state: .celebrating, at: first, moving: true)
        #expect(next == before)
        let easing = clock.pose(state: .celebrating, at: first.addingTimeInterval(0.1), moving: true)
        #expect(easing != CompanionMotion.pose(state: .celebrating, elapsed: 0.1, moving: true))
        let settled = clock.pose(state: .celebrating, at: first.addingTimeInterval(1), moving: true)
        #expect(settled == CompanionMotion.pose(state: .celebrating, elapsed: 1, moving: true))
    }

    @Test func timeWhileStoppedDoesNotCountSoTomiResumesWhereHeStopped() {
        let clock = CompanionClock()
        _ = clock.pose(state: .idle, at: first, moving: true)
        _ = clock.pose(state: .idle, at: first.addingTimeInterval(0.5), moving: true)
        _ = clock.pose(state: .idle, at: first.addingTimeInterval(10), moving: false)
        let resumed = clock.pose(state: .idle, at: first.addingTimeInterval(20), moving: true)
        #expect(resumed == CompanionMotion.pose(state: .idle, elapsed: 0.5, moving: true))
        let next = clock.pose(state: .idle, at: first.addingTimeInterval(20.1), moving: true)
        #expect(next == CompanionMotion.pose(state: .idle, elapsed: 0.6, moving: true))
    }

    @Test func aFrameDatedEarlierThanTheLastDoesNotRunTimeBackwards() {
        let clock = CompanionClock()
        _ = clock.pose(state: .idle, at: first, moving: true)
        _ = clock.pose(state: .idle, at: first.addingTimeInterval(0.4), moving: true)
        let earlier = clock.pose(state: .idle, at: first.addingTimeInterval(0.1), moving: true)
        #expect(earlier == CompanionMotion.pose(state: .idle, elapsed: 0.4, moving: true))
    }

    @Test func aChangeSeenOnALaterFrameStartsItsEaseOnThatFrame() {
        let clock = CompanionClock()
        let before = clock.pose(state: .idle, at: first, moving: true)
        let changed = clock.pose(state: .celebrating, at: first.addingTimeInterval(0.2), moving: true)
        #expect(changed == before)
    }

    @Test func withoutMotionANewStateShowsAtOnce() {
        let clock = CompanionClock()
        _ = clock.pose(state: .idle, at: first, moving: false)
        #expect(clock.pose(state: .thinking, at: first, moving: false) == CompanionState.thinking.stillPose)
    }
}
