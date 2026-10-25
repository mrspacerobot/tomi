import Testing

@testable import Tomi

struct CompanionKeyframesTests {
    let track = CompanionKeyframes<Double>(
        duration: 2,
        easing: .linear,
        frames: [.init(at: 0, value: 0), .init(at: 0.5, value: 10), .init(at: 1, value: 0)]
    )

    @Test func aKeyframeIsReachedExactly() {
        #expect(track.value(at: 0) == 0)
        #expect(track.value(at: 1) == 10)
    }

    @Test func valuesBetweenKeyframesAreBlended() {
        #expect(abs(track.value(at: 0.5) - 5) < 0.0001)
        #expect(abs(track.value(at: 1.5) - 5) < 0.0001)
    }

    @Test func theTrackRepeatsEveryDuration() {
        #expect(abs(track.value(at: 0.7) - track.value(at: 4.7)) < 0.0001)
        #expect(abs(track.value(at: 0.7) - track.value(at: -1.3)) < 0.0001)
    }

    @Test func aDelayShiftsTheTrack() {
        #expect(abs(track.value(at: 1.2, delay: 0.2) - 10) < 0.0001)
    }

    @Test func easingsStartAndEndInPlace() {
        for easing in [CompanionEasing.linear, .ease, .easeInOut, .bounce, .pop] {
            #expect(abs(easing.value(at: 0)) < 0.001)
            #expect(abs(easing.value(at: 1) - 1) < 0.001)
        }
    }

    @Test func theBounceEasingOvershootsLikeTheConcept() {
        let peak = stride(from: 0.0, through: 1.0, by: 0.01).map { CompanionEasing.bounce.value(at: $0) }.max()
        #expect(peak! > 1.05)
    }

    @Test func easeInOutIsHalfwayAtTheMiddle() {
        #expect(abs(CompanionEasing.easeInOut.value(at: 0.5) - 0.5) < 0.001)
    }
}
