import CoreGraphics

/// The spacing scale of the design, in points. Screens space and pad with these, never with a number.
nonisolated enum Spacing {
    /// No space at all, for stacks whose parts must touch.
    static let none: CGFloat = 0
    static let xxSmall: CGFloat = 4
    static let xSmall: CGFloat = 8
    static let small: CGFloat = 12
    static let medium: CGFloat = 16
    static let large: CGFloat = 20
    static let xLarge: CGFloat = 24
    static let xxLarge: CGFloat = 32

    /// The side margin of a screen.
    static let screenMargin = large
    /// The narrower side margin of lesson steps and footers.
    static let stepMargin = medium
}
