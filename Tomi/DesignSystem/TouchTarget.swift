import CoreGraphics

/// The heights of things a cook taps, in points. Nothing tappable is smaller than `minimum`.
nonisolated enum TouchTarget {
    static let minimum: CGFloat = 44
    static let button: CGFloat = 52
    static let smallButton = minimum
    static let chip = minimum
}
