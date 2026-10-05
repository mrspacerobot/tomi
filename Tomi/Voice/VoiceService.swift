import Foundation

/// Builds the speaker the app uses: the neural voice, with the system voice behind it.
enum VoiceService {
    /// Tests and previews ask for the fake with the launch argument, so they never need a model or a speaker.
    static func speaker(
        arguments: [String] = ProcessInfo.processInfo.arguments,
        bundle: Bundle = .main
    ) -> any Speaker {
        if arguments.contains("-fake-speaker") {
            return FakeSpeaker()
        }
        let system = SystemSpeaker()
        guard let settings = VoiceSettings.bundled(in: bundle) else {
            return system
        }
        return FallbackSpeaker(primary: KokoroSpeaker(voice: settings.kokoroVoice), fallback: system)
    }
}
