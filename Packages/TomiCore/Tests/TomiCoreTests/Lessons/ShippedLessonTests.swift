import Foundation
import Testing

@testable import TomiCore

/// Checks the lessons the app ships, so a content mistake fails here without needing the simulator.
@Suite struct ShippedLessonTests {
    @Test func theTwoExampleLessonsShip() throws {
        let ids = try ShippedLessons.files().map { try ShippedLessons.lesson(at: $0).id }
        #expect(ids.contains(ShippedLessons.searedChicken))
        #expect(ids.contains(ShippedLessons.omelette))
    }

    /// Decoding validates: an unknown ingredient, scene, skill or level in any shipped file fails here.
    @Test func everyShippedLessonIsValid() throws {
        for file in try ShippedLessons.files() {
            #expect(throws: Never.self, "\(file.lastPathComponent)") {
                try ShippedLessons.lesson(at: file)
            }
        }
    }

    /// The app finds lessons by this name in a flat bundle, so the name must be unique and say which lesson it is.
    @Test func everyFileIsNamedByItsLessonIDAndSitsInTheFolderOfItsSkill() throws {
        for file in try ShippedLessons.files() {
            let lesson = try ShippedLessons.lesson(at: file)
            #expect(file.lastPathComponent == lesson.fileName)
            #expect(file.deletingLastPathComponent().lastPathComponent == lesson.skill.rawValue)
        }
    }

    @Test func everyShippedLessonHasItsOwnID() throws {
        let ids = try ShippedLessons.files().map { try ShippedLessons.lesson(at: $0).id }
        #expect(Set(ids).count == ids.count)
    }

    @Test func everyShippedLessonHasTagsFromTheShippedTable() throws {
        let table = try ShippedIngredientTable.load()
        for file in try ShippedLessons.files() {
            let lesson = try ShippedLessons.lesson(at: file)
            #expect(try lesson.isAllowed(by: CookPreferences(), in: table))
            for swap in lesson.swaps {
                #expect(throws: Never.self) {
                    try lesson.applying(swap).tags(in: table)
                }
            }
        }
    }

    /// Equipment is an id with no list in the library yet (#86), so nothing else would catch a mistyped one:
    /// the lesson would ask for something no kitchen has and never be shown.
    @Test func everyShippedLessonAsksOnlyForEquipmentOfTheKitchenScreen() throws {
        let kitchenScreen: Set<EquipmentID> = [
            "stovetop", "oven", "microwave", "thermometer", "blender", "rice-cooker",
        ]
        for file in try ShippedLessons.files() {
            let lesson = try ShippedLessons.lesson(at: file)
            #expect(lesson.equipment.isSubset(of: kitchenScreen), "\(lesson.id.rawValue)")
        }
    }

    /// The app would draw an unknown scene plain, so nothing else catches a mistyped one in our own lessons.
    @Test func noShippedLessonNamesASceneThisBuildCannotDraw() throws {
        for file in try ShippedLessons.files() {
            let lesson = try ShippedLessons.lesson(at: file)
            #expect(lesson.unknownSceneNames.isEmpty, "\(lesson.id.rawValue)")
        }
    }
}
