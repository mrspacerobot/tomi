/// Where a launch is: signing in, answering the first questions, or at home.
enum AppStage: Equatable {
    case starting
    case signedOut
    case onboarding
    case home
    /// The profile could not be loaded. The cook can try again.
    case failed
}
