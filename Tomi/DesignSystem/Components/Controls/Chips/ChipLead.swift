import SwiftUI

/// The mark before the name of a chip: a lock, a tick, a plus, the unsure mark, or nothing.
struct ChipLead: View {
    /// How far the kit pulls the unsure mark towards the edge of the chip (`.r-chip.q em`).
    static let unsureMarkInset: CGFloat = -3

    let kind: ChipKind

    var body: some View {
        if kind == .unsure {
            UnsureMark()
                .padding(.leading, Self.unsureMarkInset)
        } else if let glyph = kind.leadingGlyph {
            Icon(glyph, size: .small)
        }
    }
}

#Preview {
    HStack(spacing: Spacing.medium) {
        ForEach(ChipKind.allCases, id: \.self) { kind in
            ChipLead(kind: kind)
        }
    }
    .foregroundStyle(ColorRole.showInk.color)
    .padding()
    .background { ShowStage() }
}
