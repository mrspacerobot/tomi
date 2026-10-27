import Foundation

/// What the launch arguments say about the fake server's quiz. Only UI tests and `scripts/run.sh fake` pass them.
nonisolated struct FakeQuizOptions: Equatable {
    /// Followed by an invented quiz with its right choices (`TomiUITests/Fixtures/fake-quiz.json`) in base64, so its
    /// quotes and line breaks survive every way of launching: the guided suggestion asks it and the fake server
    /// marks picks from it.
    static let fixtureArgument = "--fake-quiz"
    /// Every quiz pick fails as if the phone had no connection.
    static let offlineArgument = "--fake-quiz-offline"
    /// Every quiz pick is answered as if the server's graph had changed since the suggestion.
    static let graphChangedArgument = "--fake-quiz-graph-changed"

    /// The quiz's text, or nil when none was handed over or it is not base64.
    let fixture: String?
    let isOffline: Bool
    let isGraphChanged: Bool

    /// The failure the arguments ask for. Offline wins when both are given.
    var failure: FakeQuizFailure? {
        if isOffline {
            return .offline
        }
        if isGraphChanged {
            return .graphChanged
        }
        return nil
    }

    init(arguments: [String]) {
        fixture = Self.text(base64: Self.value(after: Self.fixtureArgument, in: arguments))
        isOffline = arguments.contains(Self.offlineArgument)
        isGraphChanged = arguments.contains(Self.graphChangedArgument)
    }

    private static func text(base64: String?) -> String? {
        guard let base64, let data = Data(base64Encoded: base64) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }

    private static func value(after argument: String, in arguments: [String]) -> String? {
        guard let position = arguments.firstIndex(of: argument), position + 1 < arguments.count else {
            return nil
        }
        return arguments[position + 1]
    }
}
