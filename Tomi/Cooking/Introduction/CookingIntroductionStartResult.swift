/// The result of checking whether a checked suggestion may enter preparation.
enum CookingIntroductionStartResult: Equatable {
    case ready
    case restrictionsChanged
    case profileUnavailable
    case unavailable
    case cancelled
}
