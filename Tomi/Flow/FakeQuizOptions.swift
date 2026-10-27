import Foundation

/// What the launch arguments say about the fake server's quiz. Only UI tests and `scripts/run.sh fake` pass them.
nonisolated struct FakeQuizOptions: Equatable {
    /// Followed by the text of an invented quiz with its right choices (`TomiUITests/Fixtures/fake-quiz.json`):
    /// the guided suggestion asks it and the fake server marks picks from it.
    static let fixtureArgument = "--fake-quiz"
    /// Every quiz pick fails as if the phone had no connection.
    static let offlineArgument = "--fake-quiz-offline"

    let fixture: String?
    let isOffline: Bool

    init(arguments: [String]) {
        fixture = Self.value(after: Self.fixtureArgument, in: arguments)
        isOffline = arguments.contains(Self.offlineArgument)
    }

    private static func value(after argument: String, in arguments: [String]) -> String? {
        guard let position = arguments.firstIndex(of: argument), position + 1 < arguments.count else {
            return nil
        }
        return arguments[position + 1]
    }
}
