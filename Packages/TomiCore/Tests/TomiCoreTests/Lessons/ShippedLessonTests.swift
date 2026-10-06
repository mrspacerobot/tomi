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

    /// Decoding validates: an unknown ingredient, piece of equipment, scene, skill or level in any shipped file
    /// fails here.
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
}
