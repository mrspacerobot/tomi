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

    @Test func theSettingsChooseTheEngine() {
        let kokoro = VoiceService.speaker(for: VoiceSettings(engine: .kokoro, voice: "any_voice"))
        let system = VoiceService.speaker(for: VoiceSettings(engine: .system, voice: "any_voice"))
        #expect(kokoro is FallbackSpeaker)
        #expect(system is SystemSpeaker)
    }

    @Test func withoutVoiceSettingsOnlyTheSystemVoiceIsUsed() {
        let speaker = VoiceService.speaker(arguments: [], bundle: testBundle)
        #expect(speaker is SystemSpeaker)
    }
}
