extension CookProgress {
    /// How many techniques of the menu the cook has mastered, by cooking or by their experience answer.
    public var masteredCount: Int {
        skills.count { $0.isMastered }
    }
}
