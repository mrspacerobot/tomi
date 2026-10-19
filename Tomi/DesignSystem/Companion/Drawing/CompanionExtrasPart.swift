import SwiftUI

/// Thought dots rising to the upper right, and yolk sparkles around a celebration.
enum CompanionExtrasPart {
    private static let dots = [
        CGRect(x: 156, y: 54, width: 10, height: 10),
        CGRect(x: 169, y: 36, width: 14, height: 14),
        CGRect(x: 186, y: 13, width: 19, height: 19),
    ]
    private static let sparkles = [
        CompanionSparkle(center: CGPoint(x: 30, y: 58), radius: 10),
        CompanionSparkle(center: CGPoint(x: 172, y: 36), radius: 9),
        CompanionSparkle(center: CGPoint(x: 190, y: 66), radius: 5.5),
    ]

    static func draw(_ extras: CompanionExtras, in context: GraphicsContext, palette: CompanionPalette) {
        let strengths = [extras.thought.first, extras.thought.second, extras.thought.third]
        for (rect, strength) in zip(dots, strengths) where strength > 0 {
            context.fill(Path(ellipseIn: rect), with: .color(palette.line.opacity(strength)))
        }
        guard extras.sparkle > 0 else { return }
        let pen = CompanionPen(color: palette.line, style: CompanionInk.detail)
        for sparkle in sparkles {
            context.fillAndInk(sparkle.path(scale: extras.sparkle), fill: palette.sparkle, pen: pen)
        }
    }
}
