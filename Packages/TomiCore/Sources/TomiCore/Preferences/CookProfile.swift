import Foundation

/// Everything the cook tells Tomi about themselves, as Tomi's server keeps it (`GET /v1/profile`).
/// The server is the source of truth and decides what every id means; the app keeps a copy in its store
/// (`SavedProfile`) for cooking offline. A new value holds the server's defaults.
public struct CookProfile: Hashable, Sendable {
    public static let defaultServings = 2
    public static let minimumServings = 1
    /// The server's default for a new cook.
    public static let defaultWeeklyGoal = 3
    /// The days of one week a cook can aim to cook on. The stepper offers the server's own range once
    /// `GET /v1/options` sends it (#178).
    public static let weeklyGoalRange = 1...7

    /// The diet the cook keeps, or nil when they eat everything.
    public var diet: OptionID?
    public var avoid: Set<OptionID> = []
    public var cuisinesLoved: Set<OptionID> = []
    public var cuisinesToTry: Set<OptionID> = []
    public var cuisinesNever: Set<OptionID> = []
    /// Ingredients the cook always has at home, so a scan need not find them.
    public var cupboardStaples: Set<OptionID> = []
    /// Whether the cook has answered the cupboard question. Until then the server counts its assumed staples
    /// as at home and ignores `cupboardStaples`.
    public var cupboardAnswered = false
    /// The equipment the cook ticked, or nil while they have not answered the kitchen question.
    public var equipment: Set<OptionID>?
    public var experience = Experience.basics
    /// People at the table most nights. Change it with `setServings`, which keeps it at one or more.
    public private(set) var servings = CookProfile.defaultServings
    /// The units the cook picked, or nil while they have not picked: then `units(for:)` follows the locale.
    public var units: Units?
    /// Cooking days a week. Change it with `setWeeklyGoal`, which keeps it inside `weeklyGoalRange`.
    public private(set) var weeklyGoal = CookProfile.defaultWeeklyGoal
    /// The technique the cook picked to cook next, or nil when the menu order decides.
    public var focusSkill: SkillID?
    public var isOnboardingDone = false

    public init() {}

    /// The units to show amounts in: the cook's choice, or what their locale expects.
    public func units(for locale: Locale) -> Units {
        if let units {
            return units
        }
        return Units.standard(for: locale)
    }

    public mutating func setServings(_ servings: Int) {
        self.servings = max(servings, CookProfile.minimumServings)
    }

    public mutating func setWeeklyGoal(_ goal: Int) {
        let range = CookProfile.weeklyGoalRange
        weeklyGoal = min(max(goal, range.lowerBound), range.upperBound)
    }

    /// Whether the cook's diet and avoid list are the same in both. When they differ, anything checked for
    /// the old answers, such as the lesson in progress, must be checked by the server again before it is shown.
    public func hasSameRestrictions(as other: CookProfile) -> Bool {
        diet == other.diet && avoid == other.avoid
    }
}
