/// The result of checking whether a checked suggestion may enter preparation.
enum CookingIntroductionStartResult: Equatable {
    case ready
    case restrictionsChanged
    case profileUnavailable
    case unavailable
    case cancelled

    /// What the cook is told when the check is not passed. Nothing is said for a pass or for a check that was
    /// abandoned. A suggestion that can no longer be offered is read as changed restrictions: new ones are needed.
    var refusal: CookingIntroductionRefusal? {
        switch self {
        case .ready, .cancelled: nil
        case .restrictionsChanged, .unavailable: .restrictionsChanged
        case .profileUnavailable: .profileUnavailable
        }
    }
}
