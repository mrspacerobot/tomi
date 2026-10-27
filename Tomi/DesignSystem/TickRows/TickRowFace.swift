import SwiftUI

/// How a tick row looks: box, name, leader and note over a hairline, on a wash band when it is ticked.
/// The row runs from edge to edge of the screen and keeps the screen margin itself, so the band can bleed.
struct TickRowFace: View {
    /// The kit sets the box and the words a little inside the ends of the rule under them, and leaves less
    /// room under the words than over them (`.b-opt`).
    static let contentInset: CGFloat = 2
    static let bottomPadding: CGFloat = 14
    /// The box stops growing here, so that at the largest text sizes the room goes to the words.
    static let largestBox = DynamicTypeSize.accessibility1

    let name: String
    let note: String?
    let isSelected: Bool
    var isCrossedOut = false

    var body: some View {
        HStack(alignment: .top, spacing: Spacing.small) {
            TickBox(isTicked: isSelected)
                .dynamicTypeSize(...Self.largestBox)
            TickRowWords(name: name, note: note, isSelected: isSelected, isCrossedOut: isCrossedOut)
        }
        .padding(.top, Spacing.medium)
        .padding(.bottom, Self.bottomPadding)
        .padding(.horizontal, Spacing.screenMargin + Self.contentInset)
        .frame(maxWidth: .infinity, minHeight: TouchTarget.minimum, alignment: .leading)
        .background(band)
        .overlay(alignment: .bottom) {
            Hairline()
                .padding(.horizontal, ruleInset)
        }
        .contentShape(.rect)
    }

    /// The rule under a ticked row runs to the edges with its band; under any other it keeps the margin.
    private var ruleInset: CGFloat {
        if isSelected {
            return 0
        }
        return Spacing.screenMargin
    }

    private var band: Color {
        if isSelected {
            return ColorRole.wash.color
        }
        return .clear
    }
}

#Preview {
    VStack(spacing: 0) {
        ForEach(Array(TickRowSample.equipment.enumerated()), id: \.offset) { index, sample in
            TickRowFace(name: sample.name, note: sample.note, isSelected: index == 0)
        }
    }
    .background(ColorRole.paper.color)
}
