import FluidAudio
import OSLog
import TomiCore

/// Speaks with Kokoro, a neural voice that runs on the phone. It is the voice Tomi is meant to have.
/// A line is spoken a sentence at a time: the first plays while the next is still being made.
final class KokoroSpeaker: Speaker {
    nonisolated private static let logger = Logger(subsystem: "com.mrspacerobot.tomi", category: "voice")
    private let voice: String
    private let manager: KokoroAneManager
    private let player = SpeechPlayer()
    private var isLoaded = false
    private var turn = 0

    init(voice: String) {
        self.voice = voice
        manager = KokoroAneManager(defaultVoice: voice)
    }

    func speak(_ line: String) async throws {
        stop()
        turn += 1
        let mine = turn
        try AudioPlayback.prepare()
        try await withTaskCancellationHandler {
            try await load()
            try await sayEach(SpokenSentences.split(line), turn: mine)
        } onCancel: {
            Task { @MainActor in self.stop() }
        }
    }

    func stop() {
        turn += 1
        player.stop()
    }

    private func sayEach(_ sentences: [String], turn mine: Int) async throws {
        for sentence in sentences {
            let result = try await manager.synthesizeDetailed(text: sentence, voice: voice)
            guard mine == turn else {
                return
            }
            try player.enqueue(result.samples)
        }
        await player.finishPlaying()
    }

    /// Without the shipped files the engine downloads them when it can. Only a build that skipped the fetch needs that.
    private func installBundledModel() {
        do {
            try KokoroModelFiles.installBundled()
        } catch {
            Self.logger.error(
                "The shipped voice model could not be set up: \(String(describing: error), privacy: .public)"
            )
        }
    }

    /// The first call fetches and prepares the model, which takes a while, so later lines are quick.
    private func load() async throws {
        if isLoaded {
            return
        }
        installBundledModel()
        try await manager.initialize()
        isLoaded = true
        Self.logger.info("The Kokoro voice is ready")
    }
}
