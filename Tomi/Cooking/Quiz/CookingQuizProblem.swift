import TomiCore

/// Why a pick could not be checked. The quiz needs the server, so none of these is ever read as right or wrong.
nonisolated enum CookingQuizProblem: Equatable {
    /// The phone could not reach the server.
    case offline
    /// The server's graph changed since the suggestion: this quiz cannot be checked any more.
    case graphChanged
    /// Anything else: an error or an answer the app could not read.
    case failed

    init(_ error: any Error) {
        guard let backend = error as? BackendError else {
            self = .failed
            return
        }
        self = Self.problem(for: backend)
    }

    private static func problem(for error: BackendError) -> CookingQuizProblem {
        if error == .unreachable {
            return .offline
        }
        if error.code == .graphVersionChanged {
            return .graphChanged
        }
        return .failed
    }

    /// Whether checking the same pick again may work.
    var canTryAgain: Bool {
        self != .graphChanged
    }
}
