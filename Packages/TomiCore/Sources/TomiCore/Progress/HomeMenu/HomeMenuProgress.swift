/// The menu in the server's course order, each technique joined by its id to the server's progress snapshot.
public struct HomeMenuProgress: Equatable, Sendable {
    public let courses: [HomeCourseProgress]

    /// `skills` is nil before the first snapshot arrived: every technique's progress is then unknown.
    public static func make(options: [OptionCourse], skills: [SnapshotSkill]?) -> Self {
        let join = HomeMenuJoin(options: options, skills: skills)
        return Self(courses: options.map(join.course))
    }
}
