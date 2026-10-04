import Foundation
import Testing
import TomiCore

@testable import Tomi

/// Throwaway libraries built from the files the app ships, so a test can add one lesson file that is wrong.
enum LibraryFixture {
    static let omelette: LessonID = "spinach-hard-cheese-omelette"
    static let searedChicken: LessonID = "seared-chicken-lemon-butter-pan-sauce"

    /// A bundle with the shipped catalog and ingredient table, and these lesson files by file name.
    static func bundle(lessonFiles: [String: Data]) throws -> Bundle {
        var files = lessonFiles
        files["catalog.json"] = try BundledLibrary.catalogData()
        files["ingredients.json"] = try BundledLibrary.ingredientTableData()
        return try Bundle.fixture(files: files)
    }

    /// The shipped omelette, a lesson known to be valid.
    static func shippedOmelette() throws -> Lesson {
        try #require(BundledLibrary.lessons().first { $0.id == omelette })
    }

    static func file(_ lesson: Lesson) throws -> Data {
        try JSONEncoder().encode(lesson)
    }
}
