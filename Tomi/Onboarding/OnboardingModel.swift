import Observation
import OSLog
import TomiCore

/// The onboarding screens' state: where the cook is, what they answered, and saving every answer as it is given.
/// Nothing moves forward unless the answer was saved, so what the cook sees is always what Tomi remembers.
@Observable
final class OnboardingModel {
    private static let logger = Logger(category: .progress)

    private(set) var step = OnboardingStep.welcome
    private(set) var dietChoice: DietChoice?
    private(set) var avoidAnswer: AvoidAnswer
    /// True when the last answer could not be saved. The screen says so and stays where it is.
    private(set) var couldNotSave = false

    private let store: any ProgressStore
    private let now: () -> Date
    private var profile: CookProfile

    /// Throws when saved data cannot be read, so the answers are never started from the defaults.
    init(store: any ProgressStore, now: @escaping () -> Date) throws {
        self.store = store
        self.now = now
        let saved = try store.profile()
        profile = saved
        dietChoice = DietChoice(saved: saved.preferences.diet)
        avoidAnswer = AvoidAnswer(saved: saved.preferences.avoid)
    }

    var progressCompleted: Int {
        step.question ?? 0
    }

    var canContinue: Bool {
        avoidAnswer.isAnswered
    }

    func start() {
        step = .diet
    }

    func back() {
        guard let previous = step.previous else {
            return
        }
        couldNotSave = false
        step = previous
    }

    func choose(_ choice: DietChoice) {
        dietChoice = choice
        profile.preferences.diet = choice.diet
        if save() {
            step = .avoid
        }
    }

    func tapAvoid(_ item: AvoidItemID) {
        avoidAnswer.tap(item)
    }

    func tapNone() {
        avoidAnswer.tapNone()
    }

    /// Saves what the cook avoids. The screens after this one come with the next onboarding pull request.
    func continueFromAvoid() {
        guard canContinue else {
            return
        }
        profile.preferences.avoid = avoidAnswer.avoided
        _ = save()
    }

    private func save() -> Bool {
        do {
            try store.saveProfile(profile, at: now())
            couldNotSave = false
        } catch {
            Self.logger.error("An onboarding answer could not be saved: \(String(describing: error), privacy: .public)")
            couldNotSave = true
        }
        return !couldNotSave
    }
}
