import Testing

@testable import Tomi

@MainActor
@Suite struct FallbackSpeakerTests {
    let primary = FakeSpeaker()
    let fallback = FakeSpeaker()

    @Test func theFirstChoiceSpeaksWhenItWorks() async throws {
        let speaker = FallbackSpeaker(primary: primary, fallback: fallback)
        try await speaker.speak("Heat the pan.")
        #expect(primary.spoken == ["Heat the pan."])
        #expect(fallback.spoken.isEmpty)
    }

    @Test func theFallbackSpeaksWhenTheFirstChoiceFails() async throws {
        primary.failure = SpeakerError.unavailable
        let speaker = FallbackSpeaker(primary: primary, fallback: fallback)
        try await speaker.speak("Heat the pan.")
        #expect(fallback.spoken == ["Heat the pan."])
    }

    @Test func aFailingFirstChoiceIsTriedAgainOnTheNextLine() async throws {
        primary.failure = SpeakerError.unavailable
        let speaker = FallbackSpeaker(primary: primary, fallback: fallback)
        try await speaker.speak("One.")
        primary.failure = nil
        try await speaker.speak("Two.")
        #expect(primary.spoken == ["Two."])
        #expect(fallback.spoken == ["One."])
    }

    @Test func whenBothFailTheCallerHearsAboutIt() async {
        primary.failure = SpeakerError.unavailable
        fallback.failure = SpeakerError.unavailable
        let speaker = FallbackSpeaker(primary: primary, fallback: fallback)
        await #expect(throws: SpeakerError.self) { try await speaker.speak("Heat the pan.") }
    }

    @Test func aCancelledLineDoesNotStartTheFallback() async {
        primary.failure = CancellationError()
        let speaker = FallbackSpeaker(primary: primary, fallback: fallback)
        await #expect(throws: CancellationError.self) { try await speaker.speak("Heat the pan.") }
        #expect(fallback.spoken.isEmpty)
    }

    @Test func stoppingStopsBothChoices() {
        let speaker = FallbackSpeaker(primary: primary, fallback: fallback)
        speaker.stop()
        #expect(primary.stopCount == 1)
        #expect(fallback.stopCount == 1)
    }
}
