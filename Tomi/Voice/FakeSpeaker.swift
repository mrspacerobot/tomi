/// A speaker for previews and tests. It says nothing aloud and remembers what it was asked to say.
final class FakeSpeaker: Speaker {
    private(set) var spoken: [String] = []
    private(set) var stopCount = 0
    var failure: (any Error)?

    func speak(_ line: String) async throws {
        if let failure {
            throw failure
        }
        spoken.append(line)
    }

    func stop() {
        stopCount += 1
    }
}
