import Foundation

@testable import TomiCore

/// The lessons the app ships, read straight from the app's resources so no simulator is needed.
enum ShippedLessons {
    static let folder = ShippedLibrary.folder.appending(path: "lessons")

    static let searedChicken: LessonID = "seared-chicken-lemon-butter-pan-sauce"
    static let omelette: LessonID = "spinach-hard-cheese-omelette"

    /// Every file under the lessons folder, in any skill folder, sorted by path.
    static func files() throws -> [URL] {
        var files: [URL] = []
        for skillFolder in try contents(of: folder) {
            files.append(contentsOf: try contents(of: skillFolder))
        }
        return files.sorted { $0.path() < $1.path() }
    }

    /// Decodes and validates one file against the shipped catalog and the shipped ingredient table.
    static func lesson(at file: URL) throws -> Lesson {
        let catalog = try SkillCatalog.decode(from: Data(contentsOf: ShippedCatalogTests.catalogURL))
        let table = try ShippedIngredientTable.load()
        return try Lesson.decode(from: Data(contentsOf: file), catalog: catalog, table: table)
    }

    static func lesson(_ id: LessonID) throws -> Lesson {
        for file in try files() where file.lastPathComponent == id.rawValue + Lesson.fileNameSuffix {
            return try lesson(at: file)
        }
        throw CocoaError(.fileNoSuchFile)
    }

    private static func contents(of folder: URL) throws -> [URL] {
        try FileManager.default.contentsOfDirectory(at: folder, includingPropertiesForKeys: nil)
    }
}
