import SwiftUI

/// Two tall white eyes with big pupils and a gleam, or two closed happy arcs.
enum CompanionEyesPart {
    /// Centres of the cook's left and right eye.
    static let centers = [CGPoint(x: 84, y: 126), CGPoint(x: 116, y: 126)]
    private static let radius = CGSize(width: 15, height: 19)
    /// The pupils sit a little towards the nose, which reads as looking at the cook.
    private static let inward: CGFloat = 3
    private static let drop: CGFloat = 4

    static func draw(_ eyes: CompanionEyes, in context: GraphicsContext, palette: CompanionPalette) {
        for center in centers {
            let eye = CompanionEyeDrawing(eyes: eyes, center: center)
            if eyes.happy {
                context.ink(happyArc(at: center), pen: CompanionPen(color: palette.feature, style: CompanionInk.brow))
            } else {
                drawOpen(eye, in: context, palette: palette)
            }
        }
    }

    private static func drawOpen(_ eye: CompanionEyeDrawing, in context: GraphicsContext, palette: CompanionPalette) {
        var lid = context
        lid.translateBy(x: eye.center.x, y: eye.center.y)
        lid.scaleBy(x: 1, y: eye.eyes.openness)
        lid.translateBy(x: -eye.center.x, y: -eye.center.y)
        let white = white(at: eye.center)
        lid.fill(white, with: .color(palette.white))
        var inside = lid
        inside.clip(to: white)
        drawPupil(eye, in: inside, palette: palette)
        lid.ink(white, pen: CompanionPen(color: palette.feature, style: CompanionInk.feature))
    }

    private static func drawPupil(_ eye: CompanionEyeDrawing, in context: GraphicsContext, palette: CompanionPalette) {
        let size = CGFloat(eye.eyes.pupil)
        let towardNose = towardNose(from: eye.center)
        let center = CGPoint(x: eye.center.x + towardNose + eye.eyes.look.x, y: eye.center.y + drop + eye.eyes.look.y)
        context.fill(circle(at: center, radius: size), with: .color(palette.feature))
        let gleam = CGPoint(x: center.x + size * 0.3, y: center.y - size * 0.43)
        context.fill(circle(at: gleam, radius: size * 0.32), with: .color(palette.white))
    }

    private static func towardNose(from center: CGPoint) -> CGFloat {
        if center.x < CompanionGrid.middle {
            return inward
        }
        return -inward
    }

    private static func white(at center: CGPoint) -> Path {
        Path(
            ellipseIn: CGRect(
                x: center.x - radius.width,
                y: center.y - radius.height,
                width: radius.width * 2,
                height: radius.height * 2
            )
        )
    }

    private static func circle(at center: CGPoint, radius: CGFloat) -> Path {
        Path(ellipseIn: CGRect(x: center.x - radius, y: center.y - radius, width: radius * 2, height: radius * 2))
    }

    private static func happyArc(at center: CGPoint) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: center.x - 13, y: center.y + 3))
        path.addQuadCurve(
            to: CGPoint(x: center.x + 13, y: center.y + 3),
            control: CGPoint(x: center.x, y: center.y - 16)
        )
        return path
    }
}
