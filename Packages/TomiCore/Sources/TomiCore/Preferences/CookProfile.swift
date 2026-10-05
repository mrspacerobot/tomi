/// Everything Tomi keeps about the cook between launches, apart from the cook log:
/// their answers, the technique they chose to work on, and whether they have been through onboarding.
/// A new value is what Tomi assumes before the cook has answered anything.
public struct CookProfile: Hashable, Sendable {
    public var preferences = CookPreferences()
    /// The technique the cook picked to cook next, or nil when the menu order decides.
    /// `CookProgress.focus(preferring:)` reads it.
    public var focusSkill: SkillID?
    public var isOnboardingDone = false

    public init() {}
}
