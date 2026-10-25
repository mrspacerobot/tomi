import SwiftUI

extension CompanionPalette {
    /// The outline and limb colour at a weight.
    func line(_ style: StrokeStyle) -> CompanionPen {
        CompanionPen(color: line, style: style)
    }

    /// The face colour at a weight.
    func feature(_ style: StrokeStyle) -> CompanionPen {
        CompanionPen(color: feature, style: style)
    }

    /// The soft white shine at a weight.
    func shine(_ style: StrokeStyle) -> CompanionPen {
        CompanionPen(color: white.opacity(CompanionInk.shineOpacity), style: style)
    }
}
