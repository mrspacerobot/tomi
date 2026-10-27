/// How the fake server fails every quiz pick, when a flow needs it to.
nonisolated enum FakeQuizFailure: Equatable {
    /// As if the phone had no connection.
    case offline
    /// `409 graph_version_changed`, as when the server's graph moved on since the suggestion.
    case graphChanged

    /// What the app sees for every pick.
    var error: BackendError {
        switch self {
        case .offline: .unreachable
        case .graphChanged: .server(status: 409, APIError(codeName: "graph_version_changed", message: "New."))
        }
    }
}
