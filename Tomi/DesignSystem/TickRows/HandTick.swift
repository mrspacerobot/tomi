import SwiftUI

/// The tick a pen makes: down a little, then up and out of the box (`TICK` in the design kit).
nonisolated struct HandTick: Shape {
    /// The side of the square grid the kit draws the tick on, in points.
    static let gridSize: CGFloat = 34
    /// How heavy the kit draws the line, on that grid.
    static let strokeWeight: CGFloat = 3

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 5, y: 19))
        path.addCurve(
            to: CGPoint(x: 12.5, y: 28.5),
            control1: CGPoint(x: 8, y: 21.5),
            control2: CGPoint(x: 10.5, y: 25)
        )
        path.addCurve(to: CGPoint(x: 31, y: 3), control1: CGPoint(x: 16, y: 19), control2: CGPoint(x: 22, y: 10))
        let scale = CGAffineTransform(scaleX: rect.width / Self.gridSize, y: rect.height / Self.gridSize)
        return path.applying(scale).offsetBy(dx: rect.minX, dy: rect.minY)
    }
}
