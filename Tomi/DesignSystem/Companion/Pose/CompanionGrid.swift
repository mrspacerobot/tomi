import CoreGraphics

/// The page Tomi is drawn on. The figure uses the concept sketch's 200 by 240 units; the grid adds room above
/// for the celebration jump, the thought dots and the sparkles, and at the sides for the gloves.
///
/// A screen gives Tomi a frame, and Tomi himself fills it: `figureBox` (toque to shoes, glove to glove at
/// rest) is fitted to the frame, and the rest of the grid spills over its edges, so a jump or a sparkle is
/// never what makes him small.
nonisolated enum CompanionGrid {
    static let size = CGSize(width: 240, height: 270)
    /// Where the sketch's origin sits on the grid.
    static let figureOrigin = CGPoint(x: 20, y: 30)
    /// The part of the grid fitted to a frame: Tomi at rest, in grid units.
    static let figureBox = CGRect(x: 30, y: 50, width: 180, height: 212)
    /// The point between the feet that the body hops, squashes and leans about, in figure units.
    static let ground = CGPoint(x: 100, y: 229)
    /// The vertical centre line the figure is mirrored about, in figure units.
    static let middle: CGFloat = 100

    /// Where the whole grid goes, relative to a frame, so that the figure box fills the frame, centred and
    /// never stretched. The grid usually reaches past the frame's edges.
    static func canvas(in frame: CGSize) -> CGRect {
        let scale = min(frame.width / figureBox.width, frame.height / figureBox.height)
        let left = (frame.width - figureBox.width * scale) / 2 - figureBox.minX * scale
        let top = (frame.height - figureBox.height * scale) / 2 - figureBox.minY * scale
        return CGRect(x: left, y: top, width: size.width * scale, height: size.height * scale)
    }

    /// The scale and top-left corner that fit the whole grid inside `canvas`, centred and never stretched.
    static func fit(in canvas: CGSize) -> CompanionFit {
        let scale = min(canvas.width / size.width, canvas.height / size.height)
        let origin = CGPoint(
            x: (canvas.width - size.width * scale) / 2,
            y: (canvas.height - size.height * scale) / 2
        )
        return CompanionFit(scale: scale, origin: origin)
    }
}
