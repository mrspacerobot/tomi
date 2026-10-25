import CoreGraphics

/// Which part of Tomi's grid the app icon shows: his head and toque, as large as a home screen allows, with
/// his gloves beside him and the tops of his legs, so he still reads as Tomi at 60 points.
nonisolated enum AppIconFraming {
    /// The side of the icon in pixels at scale 1, the one size iOS asks of an app icon.
    static let side: CGFloat = 1024

    /// The square of `CompanionGrid` the icon shows, in grid units.
    static let crop = CGRect(x: 25, y: 44, width: 190, height: 190)

    /// Grid units to a square of the given side.
    static func scale(toSide side: CGFloat) -> CGFloat {
        side / crop.width
    }

    /// Where a point of the grid lands on the full-size icon, in pixels from the top left.
    static func pixel(of gridPoint: CGPoint) -> CGPoint {
        let scale = scale(toSide: side)
        return CGPoint(x: (gridPoint.x - crop.minX) * scale, y: (gridPoint.y - crop.minY) * scale)
    }
}
