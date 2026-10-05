import SwiftUI

/// The cook's saved progress on the placeholder first screen: XP and techniques mastered.
/// The home screen replaces it with the streak, the rank and the menu.
struct WelcomeProgress: View {
    let summary: ProgressSummary

    var body: some View {
        VStack(spacing: Spacing.xSmall) {
            Text(.welcomeXp(summary.game.xp))
                .textStyle(.label)
                .accessibilityIdentifier("welcome-xp")
            if let masteredCount = summary.masteredCount {
                Text(.welcomeMastered(masteredCount))
                    .textStyle(.description)
                    .accessibilityIdentifier("welcome-mastered")
            }
        }
    }
}

#Preview {
    if let summary = SavedProgressModel.previewWithProgress().summary {
        WelcomeProgress(summary: summary)
    }
}
