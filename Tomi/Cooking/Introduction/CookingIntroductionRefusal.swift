import Foundation

/// A user-facing refusal while starting preparation.
enum CookingIntroductionRefusal: Int, Identifiable {
    case restrictionsChanged
    case profileUnavailable

    var id: Int { rawValue }
}
