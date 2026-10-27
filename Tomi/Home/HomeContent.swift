import SwiftUI

/// The masthead, the cook's progress and the buttons of home.
struct HomeContent: View {
    let flow: AppFlowModel
    let progress: SavedProgressModel
    @Binding var path: [HomeRoute]
    let now: Date

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xLarge) {
                HomeMasthead(path: $path, date: now)
                progressStrip
                HomeSpecialCard(path: $path, profile: flow.profile.profile, options: flow.profile.options)
                skillMenu
            }
            .padding(Spacing.screenMargin)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ColorRole.paper.color)
    }

    @ViewBuilder private var progressStrip: some View {
        if let summary = progress.summary {
            HomeProgressStrip(summary: summary)
        }
    }

    @ViewBuilder private var skillMenu: some View {
        if let options = flow.profile.options {
            HomeSkillMenu(
                options: options.courses,
                catalog: flow.services.library.catalog,
                progress: progress.summary?.skillProgress
            )
        }
    }
}
