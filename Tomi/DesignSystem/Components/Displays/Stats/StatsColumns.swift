import SwiftUI

/// A card of stats and an optional progress rule.
struct StatsColumns: View {
    /// Three, in reading order.
    let stats: [Stat]
    /// From 0 to 1. Nil leaves the rule under the columns out.
    var progress: Double?

    var body: some View {
        ShowCard {
            VStack(spacing: ShowSize.gap) {
                StatsCells(stats: stats)
                if let progress { FractionRule(fraction: progress) }
            }
        }
    }
}

#Preview("Light") {
    VStack(spacing: Spacing.xLarge) {
        StatsColumns(stats: Stat.samples, progress: Stat.sampleProgress)
        StatsColumns(stats: Stat.samples)
    }
    .padding()
    .background { ShowStage() }
}

#Preview("Dark, largest text") {
    ScrollView {
        StatsColumns(stats: Stat.samples, progress: Stat.sampleProgress)
            .padding()
    }
    .background { ShowStage() }
    .preferredColorScheme(.dark)
    .dynamicTypeSize(.accessibility5)
}
