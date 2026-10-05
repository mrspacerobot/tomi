import SwiftUI
import TomiCore

/// The first decision of every launch: with saved data that can be read, the app; without it, only the notice.
/// Every screen that depends on the cook's answers belongs under the first branch.
struct RootView: View {
    let catalog: SkillCatalog?
    let progress: SavedProgressModel

    var body: some View {
        if let summary = progress.summary {
            WelcomeView(catalog: catalog, summary: summary)
        } else {
            SavedDataUnavailableView()
        }
    }
}

#Preview("Saved progress") {
    RootView(catalog: BundledLibrary.catalog(), progress: .previewWithProgress())
}

#Preview("Saved data unavailable") {
    RootView(catalog: BundledLibrary.catalog(), progress: .previewUnavailable())
}
