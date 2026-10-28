/// How a cook ended, as the server records it. A stopped-early cook counts for nothing there.
/// The quiz is not part of it: the server scores the quiz itself, and the phone never sends a quiz result.
public enum CookOutcome: String, Hashable, Codable, Sendable {
    case finished
    case stoppedEarly

    public init(_ result: CookResult) {
        switch result {
        case .finished:
            self = .finished
        case .stoppedEarly:
            self = .stoppedEarly
        }
    }
}
