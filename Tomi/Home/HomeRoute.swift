import TomiCore

/// The screens reached from home.
enum HomeRoute: Hashable {
    case scan
    case type
    case settings
    case question(ProfileQuestion)
    case suggestion(Suggestion)
    case introduction(Suggestion)
    case preparation(Suggestion)
    case steps(Suggestion)

    /// The recipe detail a cooking flow comes back to.
    var isSuggestion: Bool {
        switch self {
        case .suggestion: true
        default: false
        }
    }
}
