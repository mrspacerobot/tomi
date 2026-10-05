/// The onboarding screens that exist so far, in the order a cook meets them.
/// The cook answers seven questions in all (`questionCount`); later pull requests add the rest.
enum OnboardingStep: Int, CaseIterable {
    case welcome
    case diet
    case avoid

    /// Questions in the whole of onboarding, which the progress along the top counts out of.
    static let questionCount = 7

    /// The question this screen asks, from 1, or nil for the welcome.
    var question: Int? {
        if self == .welcome {
            return nil
        }
        return rawValue
    }

    var previous: OnboardingStep? {
        OnboardingStep(rawValue: rawValue - 1)
    }

    var next: OnboardingStep? {
        OnboardingStep(rawValue: rawValue + 1)
    }
}
