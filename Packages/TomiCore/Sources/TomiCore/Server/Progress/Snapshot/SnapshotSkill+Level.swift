extension SnapshotSkill {
    /// The level the server says the cook is on. Nil when the snapshot does not list it.
    public var levelInProgress: SnapshotLevel? {
        levels.first { $0.number == currentLevel }
    }
}
