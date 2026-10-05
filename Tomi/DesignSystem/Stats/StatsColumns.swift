import SwiftUI

/// The three stats under the masthead: a double rule, the columns, and under them, if the screen asks for
/// it, a rule filled by the share of the way to the next level (`.b-house` in the design kit).
struct StatsColumns: View {
    /// Three, in reading order.
    let stats: [Stat]
    /// From 0 to 1. Nil leaves the rule under the columns out.
    var progress: Double?

    var body: some View {
        VStack(spacing: 0) {
            DoubleRule()
            StatsCells(stats: stats)
            if let progress {
                FractionRule(fraction: progress)
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
    .background(ColorRole.paper.color)
}

#Preview("Dark, largest text") {
    ScrollView {
        StatsColumns(stats: Stat.samples, progress: Stat.sampleProgress)
            .padding()
    }
    .background(ColorRole.paper.color)
    .preferredColorScheme(.dark)
    .dynamicTypeSize(.accessibility5)
}
