import TomiCore

/// What the phone cooks from: the skill menu and the lesson files, so a lesson can be cooked offline.
/// Which lesson suits the cook is decided by Tomi's server; the library only holds the files.
/// Screens and services ask this, and never care whether the content shipped in the app or was downloaded.
nonisolated protocol LessonLibrary: Sendable {
    /// The skill menu, or nil when the library has none that can be read.
    var catalog: SkillCatalog? { get }
    /// Every lesson that passed validation against this library's catalog, sorted by id.
    /// A lesson that failed is left out, never shown.
    var lessons: [Lesson] { get }
}

extension LessonLibrary {
    /// The lesson at exactly this revision, or nil when the phone does not have it.
    nonisolated func lesson(_ id: LessonID, revision: Int) -> Lesson? {
        lessons.first { $0.id == id && $0.revision == revision }
    }
}
