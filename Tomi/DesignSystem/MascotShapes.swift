import SwiftUI

/// Tomi's outlines on a square grid of `gridSize` points.
enum MascotShapes {
    static let gridSize: CGFloat = 120
    static let eyeCenters: [CGFloat] = [47, 73]

    static let shadow = Path(ellipseIn: CGRect(x: 30, y: 108, width: 60, height: 10))
    static let body = Path(ellipseIn: CGRect(x: 24, y: 38, width: 72, height: 72))
    static let toqueBand = Path(roundedRect: CGRect(x: 40, y: 36, width: 40, height: 11), cornerRadius: 3)

    static let leaf = Path { path in
        path.move(to: CGPoint(x: 86, y: 44))
        path.addCurve(to: CGPoint(x: 106, y: 44), control1: CGPoint(x: 94, y: 38), control2: CGPoint(x: 102, y: 40))
        path.addCurve(to: CGPoint(x: 94, y: 54), control1: CGPoint(x: 100, y: 45), control2: CGPoint(x: 96, y: 49))
        path.closeSubpath()
    }

    static let mouth = Path { path in
        path.move(to: CGPoint(x: 50, y: 83))
        path.addQuadCurve(to: CGPoint(x: 70, y: 83), control: CGPoint(x: 60, y: 94))
        path.closeSubpath()
    }

    static let toqueCrown = Path { path in
        path.move(to: CGPoint(x: 40, y: 42))
        path.addCurve(to: CGPoint(x: 43, y: 21), control1: CGPoint(x: 27, y: 40), control2: CGPoint(x: 28, y: 20))
        path.addCurve(to: CGPoint(x: 77, y: 21), control1: CGPoint(x: 45, y: 7), control2: CGPoint(x: 75, y: 7))
        path.addCurve(to: CGPoint(x: 80, y: 42), control1: CGPoint(x: 92, y: 20), control2: CGPoint(x: 93, y: 40))
        path.closeSubpath()
    }

    static func eye(centerX: CGFloat) -> Path {
        Path(ellipseIn: CGRect(x: centerX - 8, y: 60, width: 16, height: 16))
    }

    static func pupil(centerX: CGFloat) -> Path {
        Path(ellipseIn: CGRect(x: centerX - 2.7, y: 65.3, width: 8.4, height: 8.4))
    }
}
