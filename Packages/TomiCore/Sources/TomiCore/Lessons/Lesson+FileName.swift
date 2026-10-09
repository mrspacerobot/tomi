/// How a lesson file is named. The app's bundle is flat, so the name alone must tell a lesson from the
/// catalog, and must be unique: it is the lesson id followed by this suffix.
extension Lesson {
    public static let fileNameSuffix = ".lesson.json"

    /// The name of the file this lesson lives in, such as `spinach-hard-cheese-omelette.lesson.json`.
    public var fileName: String {
        id.rawValue + Lesson.fileNameSuffix
    }
}
