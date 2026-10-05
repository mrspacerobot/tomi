import Foundation
import Testing

@testable import Tomi

@Suite struct VoiceSettingsTests {
    @Test func theShippedSettingsNameAVoice() throws {
        let settings = try #require(VoiceSettings.bundled())
        #expect(!settings.kokoroVoice.isEmpty)
    }

    @Test func aVoiceNameIsReadFromTheFile() throws {
        let data = Data(#"{"kokoroVoice": "any_voice"}"#.utf8)
        #expect(try VoiceSettings.decode(from: data).kokoroVoice == "any_voice")
    }

    @Test(arguments: ["", "not json", "{}", #"{"kokoroVoice": ""}"#, #"{"kokoroVoice": "  "}"#])
    func anUnreadableFileIsRejected(contents: String) {
        #expect(throws: (any Error).self) { try VoiceSettings.decode(from: Data(contents.utf8)) }
    }
}
