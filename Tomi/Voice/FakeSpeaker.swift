/// A speaker for previews and tests. It says nothing aloud and remembers what it was asked to say.
/// With `holdsLines` on, a line is not finished until the test calls `finishOldestLine()` or `failOldestLine(with:)`.
final class FakeSpeaker: Speaker {
    private(set) var spoken: [String] = []
    private(set) var stopCount = 0
    private var held: [CheckedContinuation<Void, any Error>] = []
    var failure: (any Error)?
    var holdsLines = false

    var heldLineCount: Int {
        held.count
    }

    func speak(_ line: String) async throws {
        if let failure {
            throw failure
        }
        spoken.append(line)
        if holdsLines {
            try await withCheckedThrowingContinuation { held.append($0) }
        }
    }

    func stop() {
        stopCount += 1
    }

    func finishOldestLine() {
        guard !held.isEmpty else {
            return
        }
        held.removeFirst().resume()
    }

    func failOldestLine(with error: any Error) {
        guard !held.isEmpty else {
            return
        }
        held.removeFirst().resume(throwing: error)
    }
}
