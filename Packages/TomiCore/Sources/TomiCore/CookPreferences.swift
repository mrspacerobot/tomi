import Foundation

/// Everything the cook tells Tomi about themselves, so that Tomi only offers dishes that suit them.
/// A new value holds the defaults. Every saved field falls back to its default when missing,
/// and field names are permanent: add fields, never rename or remove one.
public struct CookPreferences: Hashable, Codable, Sendable {
    public static let defaultServings = 2
    public static let minimumServings = 1

    /// The diet the cook keeps, or nil when they eat everything.
    public var diet: DietID?
    public var avoid: Set<AvoidItemID> = []
    public var cuisines = CuisinePreferences()
    /// The equipment the cook ticked, or nil while they have not answered:
    /// then `equipment(assumingUntilChosen:)` follows what the library says a kitchen has.
    public var chosenEquipment: Set<EquipmentID>?
    public var experience = Experience.basics
    /// People at the table most nights. Change it with `setServings`, which keeps it at one or more.
    public private(set) var servings = CookPreferences.defaultServings
    /// The units the cook picked, or nil while they have not picked: then `units(for:)` follows the locale.
    public var chosenUnits: Units?
    /// Cooking days a week. Change it with `setWeeklyGoal`, which keeps it inside `GameRules.weeklyGoalOptions`.
    public private(set) var weeklyGoal = GameRules.defaultWeeklyGoal
    /// Ingredients the cook always has at home, so a scan need not find them.
    public var cupboardStaples: Set<IngredientID> = []

    public init() {}

    /// The units to show amounts in: the cook's choice, or what their locale expects.
    public func units(for locale: Locale) -> Units {
        if let chosenUnits {
            return chosenUnits
        }
        return Units.standard(for: locale)
    }

    /// What the cook's kitchen has: their own answer, or the library's standard kitchen until they give one.
    public func equipment(assumingUntilChosen standardKitchen: Set<EquipmentID>) -> Set<EquipmentID> {
        if let chosenEquipment {
            return chosenEquipment
        }
        return standardKitchen
    }

    public mutating func setServings(_ servings: Int) {
        self.servings = max(servings, CookPreferences.minimumServings)
    }

    public mutating func setWeeklyGoal(_ goal: Int) {
        weeklyGoal = GameRules.clampedWeeklyGoal(goal)
    }

    /// The names of the saved fields. Permanent once released.
    enum CodingKeys: String, CodingKey {
        case diet
        case avoid
        case cuisines
        case chosenEquipment = "equipment"
        case experience
        case servings
        case chosenUnits = "units"
        case weeklyGoal
        case cupboardStaples
    }
}
