import TomiCore

/// The screens reached from home.
enum HomeRoute: Hashable {
    case scan
    case type
    case settings
    case question(ProfileQuestion)
    case suggestion(Suggestion)
}
