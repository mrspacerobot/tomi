import AVFoundation

/// Speaks with the voices built into the phone. Plain, but always there, so it is the fallback of every other voice.
/// Callbacks name the utterance they are about, and only the one being spoken now counts: a late callback of a
/// line that was interrupted must not end the line that replaced it.
final class SystemSpeaker: NSObject, Speaker, AVSpeechSynthesizerDelegate {
    private let synthesizer = AVSpeechSynthesizer()
    private var finished: CheckedContinuation<Void, Never>?
    private var active: ObjectIdentifier?

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    func speak(_ line: String) async throws {
        interrupt()
        try AudioPlayback.prepare()
        let utterance = AVSpeechUtterance(string: line)
        await withTaskCancellationHandler {
            await sayAndWait(utterance)
        } onCancel: {
            let identifier = ObjectIdentifier(utterance)
            Task { @MainActor in self.stop(ifSpeaking: identifier) }
        }
        try Task.checkCancellation()
    }

    func stop() {
        interrupt()
        AudioPlayback.release()
    }

    private func stop(ifSpeaking identifier: ObjectIdentifier) {
        if active == identifier {
            stop()
        }
    }

    private func sayAndWait(_ utterance: AVSpeechUtterance) async {
        await withCheckedContinuation { continuation in
            active = ObjectIdentifier(utterance)
            finished = continuation
            synthesizer.speak(utterance)
        }
    }

    private func interrupt() {
        synthesizer.stopSpeaking(at: .immediate)
        finish()
    }

    private func finish() {
        active = nil
        finished?.resume()
        finished = nil
    }

    private func utteranceEnded(_ identifier: ObjectIdentifier) {
        guard active == identifier else {
            return
        }
        finish()
        AudioPlayback.release()
    }

    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        let identifier = ObjectIdentifier(utterance)
        Task { @MainActor in utteranceEnded(identifier) }
    }

    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        let identifier = ObjectIdentifier(utterance)
        Task { @MainActor in utteranceEnded(identifier) }
    }
}
