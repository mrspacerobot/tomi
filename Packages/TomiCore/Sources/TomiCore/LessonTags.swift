/// Who may eat a lesson's dish. Never written in a lesson file and never typed by a person:
/// `Lesson.tags(in:)` works it out from the ingredient table.
public struct LessonTags: Hashable, Sendable {
    /// The diets that allow every ingredient of the dish.
    public let suitableDiets: Set<Diet>
    /// Every avoid-list item that at least one ingredient of the dish triggers.
    public let avoidItems: Set<AvoidItem>

    /// Whether this cook may be shown the dish: their diet suits it and it triggers nothing they avoid.
    public func allow(_ preferences: CookPreferences) -> Bool {
        guard suitableDiets.contains(preferences.diet) else {
            return false
        }
        return avoidItems.isDisjoint(with: preferences.avoid)
    }
}
