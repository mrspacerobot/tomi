import Foundation

@testable import TomiCore

/// Every id written in the library the app ships: the words no Swift file may name.
/// The diets, avoid items, cuisines, equipment and ingredients themselves live on the server; the ones the shipped
/// lessons name are caught here too.
enum ShippedContentIDs {
    static func all() throws -> Set<String> {
        var ids = try catalogIDs()
        ids.formUnion(try lessonIDs())
        return ids
    }

    private static func catalogIDs() throws -> Set<String> {
        let catalog = try SkillCatalog.decode(from: Data(contentsOf: ShippedCatalogTests.catalogURL))
        let courses = catalog.courses.map(\.id.rawValue)
        let skills = catalog.skills.map(\.id.rawValue)
        return Set(courses + skills)
    }

    private static func lessonIDs() throws -> Set<String> {
        var ids: Set<String> = []
        for file in try ShippedLessons.files() {
            let lesson = try ShippedLessons.lesson(at: file)
            ids.insert(lesson.id.rawValue)
            ids.insert(lesson.cuisine.rawValue)
            ids.formUnion(lesson.equipment.map(\.rawValue))
            ids.formUnion(ingredientIDs(of: lesson))
        }
        return ids
    }

    private static func ingredientIDs(of lesson: Lesson) -> Set<String> {
        var ids = Set(lesson.ingredients.map(\.ingredient.rawValue))
        ids.formUnion(lesson.swaps.map(\.replacement.ingredient.rawValue))
        return ids
    }
}
