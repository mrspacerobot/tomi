import Foundation
import OSLog
import TomiCore

/// Reads lesson files against the skill catalog of one library.
/// A file that cannot be read, fails validation or is named after another lesson is skipped and logged:
/// one bad lesson must never stop the app or reach a cook.
nonisolated struct LessonFileReader {
    private static let logger = Logger(category: .library)

    let catalog: SkillCatalog

    /// The lessons of the files that are fit to serve, sorted by lesson id.
    func lessons(at files: [URL]) -> [Lesson] {
        var lessons: [Lesson] = []
        for file in files {
            if let lesson = lesson(at: file) {
                lessons.append(lesson)
            }
        }
        return lessons.sorted { $0.id < $1.id }
    }

    /// The lesson in this file, or nil, with the reason logged, when it is not fit to serve.
    func lesson(at file: URL) -> Lesson? {
        let name = file.lastPathComponent
        do {
            let lesson = try Lesson.decode(from: Data(contentsOf: file), catalog: catalog)
            return lessonIfNamedByItsID(lesson, fileName: name)
        } catch {
            let reason = String(describing: error)
            Self.logger.error("The lesson file \(name, privacy: .public) was skipped: \(reason, privacy: .public)")
            return nil
        }
    }

    /// A file named after another lesson is a copy gone wrong, and would let two files claim one id.
    private func lessonIfNamedByItsID(_ lesson: Lesson, fileName: String) -> Lesson? {
        guard fileName == lesson.fileName else {
            Self.logger.error("The lesson file \(fileName, privacy: .public) was skipped: it is not named by its id.")
            return nil
        }
        return lesson
    }
}
