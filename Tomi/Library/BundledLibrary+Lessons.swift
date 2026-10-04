import Foundation
import TomiCore

/// Lessons in a bundle. Xcode copies the library folder flat, so a lesson is found by its file name alone:
/// `<lesson id>.lesson.json`. The catalog and the ingredient table do not end that way and are never picked up.
extension BundledLibrary {
    /// Every lesson file of the bundle that passes validation, sorted by lesson id.
    /// Without a catalog and an ingredient table no lesson can be checked, so none is returned.
    nonisolated static func lessons(in bundle: Bundle = .main) -> [Lesson] {
        guard let catalog = catalog(in: bundle), let table = ingredientTable(in: bundle) else {
            return []
        }
        let reader = LessonFileReader(catalog: catalog, table: table)
        return reader.lessons(at: lessonFiles(in: bundle))
    }

    /// The files named like a lesson, valid or not.
    nonisolated static func lessonFiles(in bundle: Bundle = .main) -> [URL] {
        guard let files = bundle.urls(forResourcesWithExtension: "json", subdirectory: nil) else {
            return []
        }
        return files.filter { $0.lastPathComponent.hasSuffix(Lesson.fileNameSuffix) }
    }
}
