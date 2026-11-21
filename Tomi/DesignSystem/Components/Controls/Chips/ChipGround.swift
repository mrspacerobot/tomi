import SwiftUI

/// The fill and the edge of a chip, behind its name.
struct ChipGround: View {
    let kind: ChipKind

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: Radius.chip)
        let edge = StrokeStyle(lineWidth: RuleWeight.outline, dash: kind.outlineDash)
        shape
            .fill(kind.fill.color)
            .overlay(shape.strokeBorder(kind.outline.color, style: edge))
    }

}

#Preview {
    VStack(spacing: Spacing.xSmall) {
        ForEach(ChipKind.allCases, id: \.self) { kind in
            ChipGround(kind: kind)
                .frame(width: TouchTarget.chip * 2, height: TouchTarget.chip)
        }
    }
    .padding()
    .background { ShowStage() }
}
