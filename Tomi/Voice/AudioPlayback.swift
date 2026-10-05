import AVFoundation
import OSLog

/// Sets the phone up to play speech, so it is heard in silent mode, and gives the audio back afterwards.
/// Music keeps playing, quieter, while Tomi talks. A podcast or audiobook pauses and carries on when Tomi is done.
enum AudioPlayback {
    nonisolated private static let logger = Logger(subsystem: "com.mrspacerobot.tomi", category: "voice")

    static func prepare() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(
            .playback,
            mode: .spokenAudio,
            options: [.duckOthers, .interruptSpokenAudioAndMixWithOthers]
        )
        try session.setActive(true)
    }

    /// Tells the other audio that Tomi is done. It fails while sound is still playing, and then the next
    /// line or the next stop tries again.
    static func release() {
        do {
            try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            logger.info("The audio session stayed active: \(String(describing: error), privacy: .public)")
        }
    }
}
