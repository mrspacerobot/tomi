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

    /// A second line stops the first, and the first then returns while the second is still being said.
    /// Only the latest request may say that Tomi has stopped speaking.
    func say(_ line: String) async {
        latestRequest += 1
        let mine = latestRequest
        isSpeaking = true
        didFail = false
        await trySpeaking(line)
        if mine == latestRequest {
            isSpeaking = false
        }
    }

    func stop() {
        speaker.stop()
    }

    private func trySpeaking(_ line: String) async {
        do {
            try await speaker.speak(line)
            remember(line)
        } catch is CancellationError {
            return
        } catch {
            didFail = true
        }
    }

    private func remember(_ line: String) {
        if !said.contains(line) {
            said.append(line)
        }
    }
}
