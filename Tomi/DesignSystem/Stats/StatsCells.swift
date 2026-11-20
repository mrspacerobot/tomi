import SwiftUI

/// The stats side by side with a hairline between them. At the accessibility text sizes three columns
/// cannot hold their words, so the stats are stacked instead.
struct StatsCells: View {
    let stats: [Stat]
    var showStyle = false
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        let isStacked = dynamicTypeSize.isAccessibilitySize
        let layout = layout(isStacked: isStacked)
        layout {
            ForEach(Array(stats.enumerated()), id: \.offset) { index, stat in
                StatCell(stat: stat, showStyle: showStyle)
                    .overlay(alignment: dividerEdge(isStacked: isStacked)) {
                        if index > 0 {
                            StatDivider(isStacked: isStacked)
                        }
                    }
            }
        }
        .fixedSize(horizontal: false, vertical: true)
    }

    private func layout(isStacked: Bool) -> AnyLayout {
        if isStacked {
            return AnyLayout(VStackLayout(spacing: 0))
        }
        return AnyLayout(HStackLayout(spacing: 0))
    }

    /// The side of a stat its divider is drawn on: before it in a row, above it in a stack.
    private func dividerEdge(isStacked: Bool) -> Alignment {
        if isStacked {
            return .top
        }
        return .leading
    }
}

#Preview {
    StatsCells(stats: Stat.samples)
        .background(ColorRole.paper.color)
}
