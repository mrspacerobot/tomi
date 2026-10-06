import Foundation
import Observation

/// What the voice try-out screen knows: the line being typed, the lines already said and whether the last one failed.
@Observable
final class VoiceTryoutModel {
    var draft = ""
    private(set) var said: [String] = []
    private(set) var didFail = false
    private(set) var isSpeaking = false
    private let speaker: any Speaker
    private var latestRequest = 0

    init(speaker: any Speaker, said: [String] = []) {
        self.speaker = speaker
        self.said = said
    }

    func speak() async {
        let line = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !line.isEmpty else {
            return
        }
        draft = ""
        await say(line)
    }

    /// A second line stops the first, and the first then returns, or fails, while the second is still being said.
    /// Only the latest request may say that Tomi has stopped speaking or could not speak.
    func say(_ line: String) async {
        latestRequest += 1
        let mine = latestRequest
        isSpeaking = true
        didFail = false
        let failed = await failsToSpeak(line)
        guard mine == latestRequest else {
            return
        }
        didFail = failed
        isSpeaking = false
    }

    func stop() {
        speaker.stop()
    }

    /// A line that was cancelled did not fail: the cook, or the next line, asked for it to stop.
    private func failsToSpeak(_ line: String) async -> Bool {
        do {
            try await speaker.speak(line)
            remember(line)
            return false
        } catch is CancellationError {
            return false
        } catch {
            return true
        }
    }

    private func remember(_ line: String) {
        if !said.contains(line) {
            said.append(line)
        }
    }
}
