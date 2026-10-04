extension LessonStep {
    /// The problems of the step that sits at this position in its lesson, counting from 0.
    func issues(at position: Int) -> [LessonIssue] {
        var issues: [LessonIssue] = []
        if scene == nil {
            issues.append(.unknownScene(step: position, sceneName))
        }
        if let timerSeconds {
            issues += timerIssues(seconds: timerSeconds, at: position)
        }
        return issues
    }

    /// A step without a timer leaves the field out. A timer of zero is a slip, and one of days is a typo.
    private func timerIssues(seconds: Int, at position: Int) -> [LessonIssue] {
        if seconds < 1 {
            return [.timerNotPositive(step: position)]
        }
        if seconds > LessonStep.longestTimerSeconds {
            return [.timerTooLong(step: position)]
        }
        return []
    }
}
