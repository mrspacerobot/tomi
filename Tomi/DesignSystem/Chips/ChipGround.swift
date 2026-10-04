import SwiftUI

/// The fill and the edge of a chip, behind its name.
struct ChipGround: View {
    let kind: ChipKind

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: Radius.chip)
        let edge = StrokeStyle(lineWidth: RuleWeight.outline, dash: kind.outlineDash)
        shape
            .fill(fill)
            .overlay(shape.strokeBorder(kind.outline.color, style: edge))
    }

    private var fill: Color {
        guard let role = kind.fill else {
            return .clear
        }
        return role.color
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
    .background(ColorRole.paper.color)
}
