import SwiftUI

/// The row of dots that leads the eye from a name to what is said about it, as on a printed menu. It takes
/// the room that is left in a row, and sits a little above the baseline of the words beside it.
struct DottedLeader: View {
    /// How far above the baseline the kit lifts the dots (`.b-opt .ld`).
    nonisolated static let lift: CGFloat = 5

    var body: some View {
        let dots = StrokeStyle(lineWidth: RuleWeight.leader, lineCap: .round, dash: [0, RuleWeight.leader * 2])
        LeaderLine()
            .stroke(ColorRole.showMuted.color, style: dots)
            .frame(minWidth: Spacing.small, maxWidth: .infinity)
            .frame(height: RuleWeight.leader)
            .padding(.horizontal, RuleWeight.leader / 2)
            .alignmentGuide(.firstTextBaseline) { $0[.bottom] + Self.lift }
            .accessibilityHidden(true)
    }
}

#Preview {
    HStack(alignment: .firstTextBaseline, spacing: Spacing.xSmall) {
        Text(.sampleTickOvenName)
            .textStyle(.cardTitle)
        DottedLeader()
        Text(.sampleTickOvenNote)
            .textStyle(.showLede)
    }
    .padding()
    .background { ShowStage() }
}
