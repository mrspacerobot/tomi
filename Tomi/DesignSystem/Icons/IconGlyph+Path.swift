import SwiftUI

/// The outlines, copied point for point from the kit's 24 point grid.
nonisolated extension IconGlyph {
    var path: Path {
        switch self {
        case .check: Self.checkPath
        case .plus: Self.plusPath
        case .close: Self.closePath
        case .lock: Self.lockPath
        case .camera: Self.cameraPath
        case .question: Self.questionPath
        }
    }

    private static let checkPath = Path { path in
        path.addLines([CGPoint(x: 5, y: 12.5), CGPoint(x: 9.5, y: 17), CGPoint(x: 19, y: 7.5)])
    }

    private static let plusPath = Path { path in
        path.addLines([CGPoint(x: 12, y: 5), CGPoint(x: 12, y: 19)])
        path.addLines([CGPoint(x: 5, y: 12), CGPoint(x: 19, y: 12)])
    }

    private static let closePath = Path { path in
        path.addLines([CGPoint(x: 6, y: 6), CGPoint(x: 18, y: 18)])
        path.addLines([CGPoint(x: 18, y: 6), CGPoint(x: 6, y: 18)])
    }

    private static let lockPath = Path { path in
        path.addPath(lockShackle)
        path.addRoundedRect(in: CGRect(x: 5, y: 11, width: 14, height: 9.5), cornerSize: CGSize(width: 2, height: 2))
    }

    private static let lockShackle = Path { path in
        let top = CGPoint(x: 12, y: 8)
        path.move(to: CGPoint(x: 7.5, y: 11))
        path.addLine(to: CGPoint(x: 7.5, y: 8))
        path.addArc(center: top, radius: 4.5, startAngle: .degrees(180), endAngle: .degrees(0), clockwise: false)
        path.addLine(to: CGPoint(x: 16.5, y: 11))
    }

    private static let cameraPath = Path { path in
        let top = [CGPoint(x: 4, y: 8.5), CGPoint(x: 7.2, y: 8.5), CGPoint(x: 8.8, y: 6), CGPoint(x: 15.2, y: 6)]
        let rest = [CGPoint(x: 16.8, y: 8.5), CGPoint(x: 20, y: 8.5), CGPoint(x: 20, y: 19), CGPoint(x: 4, y: 19)]
        path.addLines(top + rest)
        path.closeSubpath()
        path.addEllipse(in: CGRect(x: 8.6, y: 10, width: 6.8, height: 6.8))
    }

    /// Not in the kit as a glyph: the kit sets a question mark in type. Drawn here so the mark is not a word.
    private static let questionPath = Path { path in
        let middle = CGPoint(x: 12, y: 9)
        path.move(to: CGPoint(x: 8, y: 9))
        path.addArc(center: middle, radius: 4, startAngle: .degrees(180), endAngle: .degrees(50), clockwise: false)
        path.addQuadCurve(to: CGPoint(x: 12, y: 15), control: CGPoint(x: 12, y: 13))
        path.addLines([CGPoint(x: 12, y: 19.4), CGPoint(x: 12, y: 19.5)])
    }
}
