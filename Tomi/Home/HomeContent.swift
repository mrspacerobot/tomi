import SwiftUI

/// The masthead, the cook's progress and the buttons of home.
struct HomeContent: View {
    let flow: AppFlowModel
    let progress: SavedProgressModel
    @Binding var path: [HomeRoute]

    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.xLarge) {
                HomeMascot()
                WelcomeMasthead(catalog: flow.services.library.catalog)
                if let summary = progress.summary {
                    WelcomeProgress(summary: summary)
                }
                HomeButtons(path: $path)
            }
            .padding(Spacing.xLarge)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ColorRole.paper.color)
    }
}
