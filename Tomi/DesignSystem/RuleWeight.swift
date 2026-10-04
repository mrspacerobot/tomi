import CoreGraphics

/// The line weights of the design, in points.
nonisolated enum RuleWeight {
    static let hairline: CGFloat = 1
    static let outline: CGFloat = 1.5
    /// The dots of a dotted leader.
    static let leader: CGFloat = 2
    /// The whole height of a double rule, which opens a block.
    static let double: CGFloat = 3
}
