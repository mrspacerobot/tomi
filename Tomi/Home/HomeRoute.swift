import TomiCore

/// The screens reached from home.
enum HomeRoute: Hashable {
    case scan
    case settings
    case question(ProfileQuestion)
    case suggestion(Suggestion)
    case introduction(Suggestion)
    case preparation(Suggestion)
    case steps(CookingSession)
    case quiz(CookingSession)

    /// The recipe detail a cooking flow comes back to.
    var isSuggestion: Bool {
        switch self {
        case .suggestion: true
        default: false
        }
    }
}
