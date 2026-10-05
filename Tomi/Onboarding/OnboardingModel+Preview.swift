import Foundation

/// Fake onboarding state for previews. Nothing is read from or saved to the phone.
extension OnboardingModel {
    static func preview(at step: OnboardingStep = .welcome) -> OnboardingModel? {
        guard let model = try? OnboardingModel(store: InMemoryProgressStore(), now: Date.init) else {
            return nil
        }
        if step != .welcome {
            model.start()
        }
        if step == .avoid {
            model.choose(.everything)
        }
        return model
    }
}
