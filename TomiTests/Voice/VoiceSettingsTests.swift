import Foundation
import Testing

@testable import Tomi

@Suite struct VoiceSettingsTests {
    @Test func theShippedSettingsNameAnEngineAndAVoice() throws {
        let settings = try #require(VoiceSettings.bundled())
        #expect(!settings.voice.isEmpty)
    }

    @Test func anEngineAndAVoiceAreReadFromTheFile() throws {
        let data = Data(#"{"engine": "system", "voice": "any_voice"}"#.utf8)
        let settings = try VoiceSettings.decode(from: data)
        #expect(settings == VoiceSettings(engine: .system, voice: "any_voice"))
    }

    @Test(arguments: VoiceEngine.allCases)
    func everyEngineCanBeNamedInTheFile(engine: VoiceEngine) throws {
        let data = Data(#"{"engine": "\#(engine.rawValue)", "voice": "any_voice"}"#.utf8)
        #expect(try VoiceSettings.decode(from: data).engine == engine)
    }

    @Test(arguments: [
        "", "not json", "{}", #"{"voice": "am_fenrir"}"#, #"{"engine": "kokoro"}"#,
        #"{"engine": "kokoro", "voice": ""}"#, #"{"engine": "kokoro", "voice": "  "}"#,
        #"{"engine": "from-a-newer-app", "voice": "am_fenrir"}"#,
    ])
    func anUnreadableFileIsRejected(contents: String) {
        #expect(throws: (any Error).self) { try VoiceSettings.decode(from: Data(contents.utf8)) }
    }
}
