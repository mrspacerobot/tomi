import SwiftUI

/// The red pen tick, placed over a tick box the way the kit places it: a little in from the left and
/// starting above the box (`.bx svg`).
struct TickMark: View {
    /// How far the tick sits from the top left corner of its box, at the default text size.
    static let offset = CGSize(width: 1, height: -9)

    /// How much larger than the default the box is drawn.
    let scale: CGFloat

    var body: some View {
        let weight = HandTick.strokeWeight * scale
        HandTick()
            .stroke(
                ColorRole.stampRedMark.color,
                style: StrokeStyle(lineWidth: weight, lineCap: .round, lineJoin: .round)
            )
            .frame(width: HandTick.gridSize * scale, height: HandTick.gridSize * scale)
            .offset(x: Self.offset.width * scale, y: Self.offset.height * scale)
    }
}

#Preview {
    TickMark(scale: 2)
        .padding(Spacing.xxLarge)
        .background(ColorRole.paper.color)
}
