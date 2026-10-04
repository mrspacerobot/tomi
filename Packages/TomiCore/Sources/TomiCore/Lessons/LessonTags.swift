/// Who may eat a lesson's dish. Never written in a lesson file and never typed by a person:
/// `Lesson.tags(in:)` works it out from the ingredient table.
/// To ask about one cook use `Lesson.isAllowed(by:in:)`, which also refuses a restriction the table does not list.
public struct LessonTags: Hashable, Sendable {
    /// Every fact that at least one ingredient of the dish has.
    public let facts: Set<IngredientFactID>
    /// The diets that rule out none of those facts. A cook with no diet is always allowed, and is not listed.
    public let suitableDiets: Set<DietID>
    /// Every avoid item that at least one of those facts triggers.
    public let avoidItems: Set<AvoidItemID>
}
