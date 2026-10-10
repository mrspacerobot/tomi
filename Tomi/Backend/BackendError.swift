import TomiCore

/// Why a call to Tomi's server or to sign-in did not give an answer the app can use.
nonisolated enum BackendError: Error, Equatable {
    /// The build has no server address: see `BackendConfiguration`.
    case notConfigured
    /// Nobody is signed in, or the session could not be renewed. The cook signs in again.
    case notSignedIn
    /// The server answered with an error it explained.
    case server(status: Int, APIError)
    /// The server answered with something the app could not read.
    case unreadableResponse(status: Int)
    /// The phone could not reach the server.
    case unreachable

    /// The server's error code, when it sent one this build knows.
    var code: APIErrorCode? {
        guard case .server(_, let error) = self else {
            return nil
        }
        return error.code
    }
}
