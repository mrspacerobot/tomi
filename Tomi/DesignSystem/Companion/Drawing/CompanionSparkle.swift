import SwiftUI

/// A four-pointed twinkle with softly pinched sides.
struct CompanionSparkle {
    let center: CGPoint
    let radius: CGFloat

    func path(scale: Double) -> Path {
        let tips = tips(size: radius * CGFloat(scale))
        var path = Path()
        path.move(to: point(tips[0]))
        for index in 1...4 {
            let next = tips[index % 4]
            path.addQuadCurve(to: point(next), control: point(pinched(tips[index - 1], next)))
        }
        path.closeSubpath()
        return path
    }

    /// Top, right, bottom and left points, around the centre.
    private func tips(size: CGFloat) -> [CGPoint] {
        [CGPoint(x: 0, y: -size), CGPoint(x: size, y: 0), CGPoint(x: 0, y: size), CGPoint(x: -size, y: 0)]
    }

    /// A control point close to the centre, between two tips, so the sides curve inwards.
    private func pinched(_ first: CGPoint, _ second: CGPoint) -> CGPoint {
        let pull: CGFloat = 0.2
        return CGPoint(x: (first.x + second.x) * pull, y: (first.y + second.y) * pull)
    }

    private func point(_ offset: CGPoint) -> CGPoint {
        CGPoint(x: center.x + offset.x, y: center.y + offset.y)
    }
}
