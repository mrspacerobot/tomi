import SwiftUI

/// A glyph drawn as a line in the colour of the text around it. It grows with the cook's text size and is
/// hidden from VoiceOver: the words next to it say what it means.
struct Icon: View {
    let glyph: IconGlyph
    @ScaledMetric private var side: CGFloat

    init(_ glyph: IconGlyph, size: IconSize) {
        self.glyph = glyph
        _side = ScaledMetric(wrappedValue: size.points, relativeTo: .body)
    }

    var body: some View {
        let weight = glyph.strokeWeight * side / IconGlyph.gridSize
        IconShape(glyph: glyph)
            .stroke(style: StrokeStyle(lineWidth: weight, lineCap: .round, lineJoin: .round))
            .frame(width: side, height: side)
            .accessibilityHidden(true)
    }
}

#Preview {
    HStack(spacing: Spacing.medium) {
        ForEach(IconGlyph.allCases, id: \.self) { glyph in
            Icon(glyph, size: .medium)
        }
    }
    .foregroundStyle(ColorRole.stageGold.color)
    .padding()
    .background { ShowStage() }
}
