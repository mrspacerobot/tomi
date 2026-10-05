import AVFoundation

/// Speaks with the voices built into the phone. Plain, but always there, so it is the fallback of every other voice.
final class SystemSpeaker: NSObject, Speaker, AVSpeechSynthesizerDelegate {
    private let synthesizer = AVSpeechSynthesizer()
    private var finished: CheckedContinuation<Void, Never>?

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    func speak(_ line: String) async throws {
        stop()
        try AudioPlayback.prepare()
        await withTaskCancellationHandler {
            await sayAndWait(line)
        } onCancel: {
            Task { @MainActor in self.stop() }
        }
        try Task.checkCancellation()
    }

    private func sayAndWait(_ line: String) async {
        await withCheckedContinuation { continuation in
            finished = continuation
            synthesizer.speak(AVSpeechUtterance(string: line))
        }
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
        finish()
    }

    private func finish() {
        finished?.resume()
        finished = nil
    }

    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        Task { @MainActor in finish() }
    }

    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        Task { @MainActor in finish() }
    }
}
