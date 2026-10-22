extension ScanItem {
    /// Below this the model is unsure, and Tomi asks instead of assuming. The one place that says so.
    public static let sureConfidence = 0.7

    /// Whether the item starts ticked on the list the cook confirms. An unsure item, or one that matched no
    /// ingredient, is not counted until the cook ticks it or types what it really is.
    public var startsTicked: Bool {
        guard ingredient != nil else {
            return false
        }
        return confidence >= Self.sureConfidence
    }
}
