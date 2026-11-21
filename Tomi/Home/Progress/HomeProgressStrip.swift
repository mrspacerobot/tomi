import SwiftUI
import TomiCore

/// The cook's streak, rank and way to the next rank, exactly as the server's snapshot gives them.
struct HomeProgressStrip: View {
    let snapshot: ProgressSnapshot
    /// False once the snapshot's week is over: its days this week are then hidden.
    let showsThisWeek: Bool

    var body: some View {
        ShowCard {
            VStack(spacing: ShowSize.gap) {
                StatsCells(stats: stats)
                ProgressView(value: snapshot.rankBar.fraction).tint(ColorRole.showRed.color)
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityValue(Text(.homeProgressTotals(snapshot.xp, mastered: snapshot.masteredCount)))
        .accessibilityIdentifier("home-progress-strip")
    }

    private var stats: [Stat] {
        [streakStat, rankStat, nextRankStat]
    }

    private var streakStat: Stat {
        Stat(
            label: String(localized: .homeStreakLabel),
            value: String(localized: .homeStreakWeeks(snapshot.streak.weeks)),
            detail: String(localized: streakDetail)
        )
    }

    private var streakDetail: LocalizedStringResource {
        guard showsThisWeek else { return .homeStreakNewWeek }
        return .homeStreakDays(snapshot.streak.daysThisWeek, snapshot.streak.goal)
    }

    private var rankStat: Stat {
        Stat(
            label: String(localized: .homeRankLabel),
            value: snapshot.rank.words,
            detail: String(localized: .homeRankTotalXp(snapshot.xp))
        )
    }

    private var nextRankStat: Stat {
        let bar = snapshot.rankBar
        return Stat(
            label: String(localized: .homeNextRankLabel),
            value: String(localized: .homeRankRemainingXp(bar.remaining)),
            detail: String(localized: .homeRankXpProgress(bar.earned, bar.needed))
        )
    }
}

#Preview {
    if let snapshot = ShownProgress.previewReturning()?.snapshot {
        HomeProgressStrip(snapshot: snapshot, showsThisWeek: true)
            .padding()
            .background { ShowStage() }
    }
}
