import TomiCore

/// A library that holds exactly what it is given, for previews and tests. It reads no files.
nonisolated struct FakeLessonLibrary: LessonLibrary {
    var catalog: SkillCatalog?
    var lessons: [Lesson] = []
}
