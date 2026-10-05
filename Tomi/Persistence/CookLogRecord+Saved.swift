import TomiCore

/// Copies the stored fields to the plain value TomiCore reads. No rule lives here.
extension CookLogRecord {
    var saved: SavedCookEntry {
        var saved = SavedCookEntry()
        saved.stableID = stableID
        saved.lesson = lesson
        saved.skill = skill
        saved.level = level
        saved.date = date
        saved.stoppedEarly = stoppedEarly
        saved.quizCorrect = quizCorrect
        saved.weeklyGoal = weeklyGoal
        return saved
    }
}
