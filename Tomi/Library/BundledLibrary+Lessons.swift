import Foundation
import TomiCore

/// Lessons in a bundle. Xcode copies the library folder flat, so a lesson is found by its file name alone:
/// `<lesson id>.lesson.json`. The catalog, the ingredient table and the equipment list do not end that way
/// and are never picked up.
extension BundledLibrary {
    /// Every lesson file of the bundle that passes validation, sorted by lesson id.
    /// Without a catalog, an ingredient table and an equipment list no lesson can be checked, so none is returned.
    nonisolated static func lessons(in bundle: Bundle = .main) -> [Lesson] {
        guard let lists = lists(in: bundle) else {
            return []
        }
        let reader = LessonFileReader(lists: lists)
        return reader.lessons(at: lessonFiles(in: bundle))
    }

    /// The lists every lesson of the bundle is checked against, or nil when any one of them cannot be read.
    nonisolated static func lists(in bundle: Bundle = .main) -> LibraryLists? {
        guard let catalog = catalog(in: bundle), let table = ingredientTable(in: bundle) else {
            return nil
        }
        guard let equipment = equipmentList(in: bundle) else {
            return nil
        }
        return LibraryLists(catalog: catalog, ingredientTable: table, equipmentList: equipment)
    }

    /// The files named like a lesson, valid or not.
    nonisolated static func lessonFiles(in bundle: Bundle = .main) -> [URL] {
        guard let files = bundle.urls(forResourcesWithExtension: "json", subdirectory: nil) else {
            return []
        }
        return files.filter { $0.lastPathComponent.hasSuffix(Lesson.fileNameSuffix) }
    }
}
