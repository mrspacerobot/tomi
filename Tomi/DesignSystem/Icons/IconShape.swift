import SwiftUI

/// The outline of a glyph, scaled from the kit's grid to the space it is given.
nonisolated struct IconShape: Shape {
    let glyph: IconGlyph

    func path(in rect: CGRect) -> Path {
        let scale = CGAffineTransform(
            scaleX: rect.width / IconGlyph.gridSize,
            y: rect.height / IconGlyph.gridSize
        )
        return glyph.path.applying(scale).offsetBy(dx: rect.minX, dy: rect.minY)
    }
}
