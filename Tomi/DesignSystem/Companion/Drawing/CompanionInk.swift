import SwiftUI

/// Line weights of the cartoon, in grid units, so they scale with Tomi. Thick and round, like a brush line.
enum CompanionInk {
    static let outline = style(5)
    static let feature = style(4)
    static let limb = style(6)
    static let brow = style(5)
    static let detail = style(2.5)
    static let fine = style(1.8)
    /// The glow's blur, in grid units.
    static let glowRadius: CGFloat = 7
    /// How strong the glow is.
    static let glowOpacity = 0.6
    /// How strong the shine on the tomato and the shoes is.
    static let shineOpacity = 0.55
    /// How strong the cheeks are.
    static let blushOpacity = 0.5

    private static func style(_ width: CGFloat) -> StrokeStyle {
        StrokeStyle(lineWidth: width, lineCap: .round, lineJoin: .round)
    }
}
