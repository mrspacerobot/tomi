/// The stored fields a cook record must have to be read as a cook entry.
enum RequiredCookField: CaseIterable {
    case stableID, lesson, skill, level, date, stoppedEarly, weeklyGoal
}
