import Foundation

/// Builds the speaker the app uses, as `voice.json` says, with the system voice behind it.
enum VoiceService {
    /// Tests and previews ask for the fake with the launch argument, so they never need a model or a speaker.
    static func speaker(
        arguments: [String] = ProcessInfo.processInfo.arguments,
        bundle: Bundle = .main
    ) -> any Speaker {
        if arguments.contains("-fake-speaker") {
            return FakeSpeaker()
        }
        guard let settings = VoiceSettings.bundled(in: bundle) else {
            return SystemSpeaker()
        }
        return speaker(for: settings)
    }

    static func speaker(for settings: VoiceSettings) -> any Speaker {
        switch settings.engine {
        case .system:
            return SystemSpeaker()
        case .kokoro:
            return FallbackSpeaker(primary: KokoroSpeaker(voice: settings.voice), fallback: SystemSpeaker())
        }
    }
}
