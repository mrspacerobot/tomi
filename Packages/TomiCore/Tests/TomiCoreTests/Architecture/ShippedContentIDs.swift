import Foundation

@testable import TomiCore

/// Every id written in the library the app ships: the words no Swift file may name.
enum ShippedContentIDs {
    static func all() throws -> Set<String> {
        var ids = try catalogIDs()
        ids.formUnion(try ingredientTableIDs())
        ids.formUnion(try lessonIDs())
        return ids
    }

    private static func catalogIDs() throws -> Set<String> {
        let catalog = try SkillCatalog.decode(from: Data(contentsOf: ShippedCatalogTests.catalogURL))
        let courses = catalog.courses.map(\.id.rawValue)
        let skills = catalog.skills.map(\.id.rawValue)
        return Set(courses + skills)
    }

    private static func ingredientTableIDs() throws -> Set<String> {
        let table = try ShippedIngredientTable.load()
        var ids = Set(table.ingredients.map(\.id.rawValue))
        ids.formUnion(table.facts.map(\.rawValue))
        ids.formUnion(table.avoidItems.map(\.id.rawValue))
        ids.formUnion(table.diets.map(\.id.rawValue))
        return ids
    }

    private static func lessonIDs() throws -> Set<String> {
        var ids: Set<String> = []
        for file in try ShippedLessons.files() {
            let lesson = try ShippedLessons.lesson(at: file)
            ids.insert(lesson.id.rawValue)
            ids.insert(lesson.cuisine.rawValue)
            ids.formUnion(lesson.equipment.map(\.rawValue))
        }
        return ids
    }
}
