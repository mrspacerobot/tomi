/// Server-ordered courses with local learning progress only where the menus agree.
public struct HomeMenuProgress: Equatable, Sendable {
    public let courses: [HomeCourseProgress]

    public static func make(options: [OptionCourse], catalog: SkillCatalog?, progress: CookProgress?) -> Self {
        let compatibility = HomeMenuCompatibility(options: options, catalog: catalog, progress: progress)
        return Self(courses: options.map(compatibility.course))
    }
}
