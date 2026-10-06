import Foundation

extension Lesson {
    /// Reads a lesson file and accepts it only if this build understands its layout and it passes validation
    /// against the lists of the same library: the skill catalog, the ingredient table and the equipment list.
    public static func decode(from data: Data, lists: LibraryLists) throws -> Lesson {
        try checkSchemaVersion(of: data)
        _ = try JSONDecoder().decode(LessonFieldCheck.self, from: data)
        let lesson = try JSONDecoder().decode(Lesson.self, from: data)
        let issues = lesson.issues(in: lists)
        guard issues.isEmpty else {
            throw LessonError.invalid(lesson.id, issues)
        }
        return lesson
    }

    /// Reads the version alone, so a layout from another schema is rejected before any of it is decoded.
    private static func checkSchemaVersion(of data: Data) throws {
        let version = try JSONDecoder().decode(CatalogSchemaHeader.self, from: data).schemaVersion
        guard version == supportedSchemaVersion else {
            throw LessonError.unsupportedSchemaVersion(version)
        }
    }
}
