import Foundation
import OSLog

/// Which engine and which voice Tomi speaks with. It is data in a file, not a constant in code,
/// so another voice or another engine is a data change.
nonisolated struct VoiceSettings: Decodable, Equatable {
    private static let logger = Logger(subsystem: "com.mrspacerobot.tomi", category: "voice")
    let engine: VoiceEngine
    /// The name the engine knows the voice by. The system engine uses the phone's default voice and ignores it.
    let voice: String

    /// Rejects a file with no voice name, because an empty name would fail only when Tomi first speaks.
    static func decode(from data: Data) throws -> VoiceSettings {
        let settings = try JSONDecoder().decode(VoiceSettings.self, from: data)
        let name = settings.voice.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else {
            throw SpeakerError.invalidSettings
        }
        return settings
    }

    /// The settings that ship in the app, or nil if the file is missing or invalid, which the app's tests rule out.
    static func bundled(in bundle: Bundle = .main) -> VoiceSettings? {
        do {
            guard let url = bundle.url(forResource: "voice", withExtension: "json") else {
                throw CocoaError(.fileNoSuchFile)
            }
            return try decode(from: Data(contentsOf: url))
        } catch {
            logger.error("The voice settings could not be read: \(String(describing: error), privacy: .public)")
            return nil
        }
    }
}
