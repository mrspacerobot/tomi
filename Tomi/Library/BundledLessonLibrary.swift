import Foundation
import TomiCore

/// The library that ships inside the app, read once when it is made.
/// It wraps `BundledLibrary`, which knows how the files sit in a bundle; this type is what the rest of the app holds.
nonisolated struct BundledLessonLibrary: LessonLibrary {
    let catalog: SkillCatalog?
    let ingredientTable: IngredientTable?
    let lessons: [Lesson]

    /// Tests pass their own bundle to reach the failure paths.
    init(bundle: Bundle = .main) {
        catalog = BundledLibrary.catalog(in: bundle)
        ingredientTable = BundledLibrary.ingredientTable(in: bundle)
        lessons = BundledLibrary.lessons(in: bundle)
    }
}
