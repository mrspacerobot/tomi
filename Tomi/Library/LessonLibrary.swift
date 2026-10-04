import TomiCore

/// Everything Tomi teaches from: the skill menu, the ingredient table and the lessons.
/// Screens and services ask this, and never care whether the content shipped in the app or was downloaded.
nonisolated protocol LessonLibrary: Sendable {
    /// The skill menu, or nil when the library has none that can be read.
    var catalog: SkillCatalog? { get }
    /// The ingredient table, or nil when the library has none that can be read.
    /// Without a table no ingredient can be checked, so nothing may be served.
    var ingredientTable: IngredientTable? { get }
    /// Every lesson that passed validation against this library's catalog and table, sorted by id.
    /// A lesson that failed is left out, never shown.
    var lessons: [Lesson] { get }
}
