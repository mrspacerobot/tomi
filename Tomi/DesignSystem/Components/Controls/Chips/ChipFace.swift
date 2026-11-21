import SwiftUI

/// How a chip looks: its mark, its name, a cross if a tap removes it, and its ground.
struct ChipFace: View {
    /// The space between the mark and the name, and beside the cross (`.r-chip` in the design kit).
    static let gap: CGFloat = 6

    let name: String
    let kind: ChipKind

    var body: some View {
        HStack(spacing: Self.gap) {
            ChipLead(kind: kind)
            Text(name)
                .strikethrough(kind.isStruckThrough)
            if kind.isRemovable {
                Icon(.close, size: .small)
                    .foregroundStyle(ColorRole.showMuted.color)
                    .padding(.horizontal, Spacing.xxSmall)
            }
        }
        .textStyle(.showText, color: kind.text)
        .padding(.leading, kind.leadingPadding)
        .padding(.trailing, kind.trailingPadding)
        .padding(.vertical, Spacing.xSmall)
        .frame(minHeight: TouchTarget.chip)
        .background(ChipGround(kind: kind))
        .contentShape(.rect)
    }
}

#Preview {
    VStack(alignment: .leading, spacing: Spacing.xSmall) {
        ForEach(ChipKind.allCases, id: \.self) { kind in
            ChipFace(name: String(localized: .sampleChipOn), kind: kind)
        }
    }
    .padding()
    .background { ShowStage() }
}
