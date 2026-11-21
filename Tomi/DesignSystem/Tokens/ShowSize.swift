import CoreGraphics

/// Shared measurements from the handoff's 282-pixel frame, scaled to the 402-point reference phone.
nonisolated enum ShowSize {
    static let edge: CGFloat = 20
    static let controlEdge: CGFloat = 23
    static let footer: CGFloat = 31
    static let compact: CGFloat = 6
    static let gap: CGFloat = 11
    static let rowGap: CGFloat = 17
    static let cardVertical: CGFloat = 14
    static let cardHorizontal: CGFloat = 20
    static let controlPadding: CGFloat = 18
    static let chipHorizontal: CGFloat = 17
    static let chipVertical: CGFloat = 10
    static let lowerThirdVertical: CGFloat = 7
    static let lowerThirdHorizontal: CGFloat = 14
    static let marqueeBorder: CGFloat = 10
    static let marqueeHorizontal: CGFloat = 14
    static let marqueeVertical: CGFloat = 11
    static let bulbSpacing: CGFloat = 20
    static let bulbDiameter: CGFloat = 7
    static let buttonLip: CGFloat = 6
    static let tabHeight: CGFloat = 74
    static let tabHighlightWidth: CGFloat = 57
    static let tabHighlightHeight: CGFloat = 49
    static let tabIcon: CGFloat = 30
    static let backIcon: CGFloat = 20
}
