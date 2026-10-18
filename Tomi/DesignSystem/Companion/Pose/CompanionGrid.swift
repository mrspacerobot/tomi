import CoreGraphics

/// The square-ish page Tomi is drawn on. The figure uses the concept sketch's 200 by 240 units; the grid adds
/// room above for the celebration jump, the thought dots and the sparkles, and at the sides for the gloves.
nonisolated enum CompanionGrid {
    static let size = CGSize(width: 240, height: 270)
    /// Where the sketch's origin sits on the grid.
    static let figureOrigin = CGPoint(x: 20, y: 30)
    /// The point between the feet that the body hops, squashes and leans about, in figure units.
    static let ground = CGPoint(x: 100, y: 229)
    /// The vertical centre line the figure is mirrored about, in figure units.
    static let middle: CGFloat = 100

    /// The scale and top-left corner that fit the grid inside `frame`, centred and never stretched.
    static func fit(in frame: CGSize) -> CompanionFit {
        let scale = min(frame.width / size.width, frame.height / size.height)
        let origin = CGPoint(
            x: (frame.width - size.width * scale) / 2,
            y: (frame.height - size.height * scale) / 2
        )
        return CompanionFit(scale: scale, origin: origin)
    }
}
