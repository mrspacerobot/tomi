import TomiCore

/// The screens reached from home.
enum HomeRoute: Hashable {
    case scan
    case settings
    case question(ProfileQuestion)
    case suggestion(Suggestion)
    case introduction(Suggestion)
    case preparation(Suggestion)
}
