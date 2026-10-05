import Foundation
import Testing

@testable import Tomi

@MainActor
@Suite struct VoiceServiceTests {
    private final class TestBundleToken {}
    private let testBundle = Bundle(for: TestBundleToken.self)

    @Test func theFakeSpeakerIsChosenOnRequest() {
        let speaker = VoiceService.speaker(arguments: ["-fake-speaker"], bundle: .main)
        #expect(speaker is FakeSpeaker)
    }

    @Test func theShippedVoiceFallsBackToTheSystemVoice() {
        let speaker = VoiceService.speaker(arguments: [], bundle: .main)
        #expect(speaker is FallbackSpeaker)
    }

    @Test func withoutVoiceSettingsOnlyTheSystemVoiceIsUsed() {
        let speaker = VoiceService.speaker(arguments: [], bundle: testBundle)
        #expect(speaker is SystemSpeaker)
    }
}
