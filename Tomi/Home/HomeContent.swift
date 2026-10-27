import SwiftUI
import TomiCore

/// The masthead, the cook's progress and the buttons of home.
struct HomeContent: View {
    let flow: AppFlowModel
    let progress: ProgressModel
    @Binding var path: [HomeRoute]
    let now: Date

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xLarge) {
                HomeMasthead(path: $path, date: now)
                progressSection
                HomeSpecialCard(path: $path, profile: flow.profile.profile, options: flow.profile.options)
                skillMenu
            }
            .padding(Spacing.screenMargin)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ColorRole.paper.color)
    }

    @ViewBuilder private var progressSection: some View {
        if let shown = progress.shown {
            HomeProgressSection(shown: shown)
        }
    }

    @ViewBuilder private var skillMenu: some View {
        if let options = flow.profile.options {
            HomeSkillMenu(options: options.courses, skills: snapshotSkills)
        }
    }

    /// Nil before the first snapshot, so no technique reads as locked or unstarted.
    private var snapshotSkills: [SnapshotSkill]? {
        guard let shown = progress.shown, let snapshot = shown.snapshot else {
            return nil
        }
        return snapshot.skills
    }
}

#Preview {
    HomeContent(flow: .preview(), progress: .previewWithProgress(), path: .constant([]), now: .now)
}
