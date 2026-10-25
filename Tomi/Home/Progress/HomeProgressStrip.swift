import SwiftUI
import TomiCore

/// The cook's streak, rank and progress to the next rank from the saved log.
struct HomeProgressStrip: View {
    let summary: ProgressSummary

    var body: some View {
        StatsColumns(stats: stats, progress: summary.game.rank.progress)
            .accessibilityElement(children: .contain)
            .accessibilityValue(totals)
            .accessibilityIdentifier("home-progress-strip")
    }

    private var stats: [Stat] {
        [streakStat, rankStat, nextRankStat]
    }

    private var streakStat: Stat {
        let streak = summary.game.streak
        return Stat(
            label: String(localized: .homeStreakLabel),
            value: String(localized: .homeStreakWeeks(streak.weeks)),
            detail: String(localized: .homeStreakDays(streak.daysThisWeek, streak.goal))
        )
    }

    private var rankStat: Stat {
        Stat(
            label: String(localized: .homeRankLabel),
            value: String(localized: summary.game.rank.title.localizationKey),
            detail: String(localized: .homeRankTotalXp(summary.game.xp))
        )
    }

    private var nextRankStat: Stat {
        let rank = summary.game.rank
        return Stat(
            label: String(localized: .homeNextRankLabel),
            value: String(localized: .homeRankRemainingXp(rank.nextAt - rank.xp)),
            detail: String(localized: .homeRankXpProgress(rank.xp - rank.startsAt, rank.nextAt - rank.startsAt))
        )
    }

    private var totals: String {
        guard let mastered = summary.masteredCount else {
            return String(localized: .homeRankTotalXp(summary.game.xp))
        }
        return String(localized: .homeProgressTotals(summary.game.xp, mastered))
    }
}

#Preview {
    if let summary = SavedProgressModel.previewWithProgress().summary {
        HomeProgressStrip(summary: summary)
            .padding()
            .background(ColorRole.paper.color)
    }
}
