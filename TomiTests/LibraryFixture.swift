import Foundation
import Testing
import TomiCore

@testable import Tomi

/// Throwaway libraries built from the files the app ships, so a test can add one lesson file that is wrong.
enum LibraryFixture {
    static let omelette: LessonID = "spinach-hard-cheese-omelette"
    static let searedChicken: LessonID = "seared-chicken-lemon-butter-pan-sauce"

    static let catalogFile = "catalog.json"
    static let ingredientTableFile = "ingredients.json"
    static let equipmentListFile = "equipment.json"

    /// A bundle with the shipped catalog, ingredient table and equipment list, and these lesson files by file name.
    static func bundle(lessonFiles: [String: Data]) throws -> Bundle {
        var files = try listFiles()
        for (name, contents) in lessonFiles {
            files[name] = contents
        }
        return try Bundle.fixture(files: files)
    }

    /// The three list files the app ships, by file name.
    static func listFiles() throws -> [String: Data] {
        [
            catalogFile: try BundledLibrary.catalogData(),
            ingredientTableFile: try BundledLibrary.ingredientTableData(),
            equipmentListFile: try BundledLibrary.equipmentListData(),
        ]
    }

    /// The shipped omelette, a lesson known to be valid.
    static func shippedOmelette() throws -> Lesson {
        try #require(BundledLibrary.lessons().first { $0.id == omelette })
    }

    static func file(_ lesson: Lesson) throws -> Data {
        try JSONEncoder().encode(lesson)
    }
}
