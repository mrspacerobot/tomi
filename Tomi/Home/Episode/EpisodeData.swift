import TomiCore

struct EpisodeData {
    let course: OptionCourse
    let option: OptionSkill
    let progress: HomeSkillProgress

    static func find(_ id: SkillID, options: [OptionCourse], snapshot: [SnapshotSkill]?) -> EpisodeData? {
        let menu = HomeMenuProgress.make(options: options, skills: snapshot)
        guard let course = options.first(where: { $0.skills.contains(where: { $0.id == id }) }),
            let option = course.skills.first(where: { $0.id == id }),
            let progress = menu.courses.first(where: { $0.id == course.id })?.skills.first(where: { $0.id == id })
        else { return nil }
        return EpisodeData(course: course, option: option, progress: progress)
    }
}
