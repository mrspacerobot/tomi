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

    init(speaker: any Speaker) {
        self.speaker = speaker
    }

    func speak() async {
        let line = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !line.isEmpty else {
            return
        }
        draft = ""
        await say(line)
    }

    func say(_ line: String) async {
        isSpeaking = true
        didFail = false
        defer { isSpeaking = false }
        await trySpeaking(line)
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
