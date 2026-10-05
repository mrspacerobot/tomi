import SwiftUI
import TomiCore

/// The first decision of every launch: with saved data that can be read, the app; without it, only the notice.
/// Every screen that depends on the cook's answers belongs under the first branch.
struct RootView: View {
    let catalog: SkillCatalog?
    let progress: SavedProgressModel
    let ingredientTable: IngredientTable?
    let onboarding: OnboardingModel?

    var body: some View {
        if let summary = progress.summary {
            app(summary)
        } else {
            SavedDataUnavailableView()
        }
    }

    @ViewBuilder private func app(_ summary: ProgressSummary) -> some View {
        if summary.isOnboardingDone {
            WelcomeView(catalog: catalog, summary: summary)
        } else if let onboarding, let ingredientTable {
            OnboardingFlow(model: onboarding, table: ingredientTable)
        } else {
            SavedDataUnavailableView()
        }
    }
}

#Preview("Saved progress") {
    RootView(
        catalog: BundledLibrary.catalog(),
        progress: .previewWithProgress(),
        ingredientTable: BundledLibrary.ingredientTable(),
        onboarding: .preview()
    )
}

#Preview("Saved data unavailable") {
    RootView(
        catalog: BundledLibrary.catalog(),
        progress: .previewUnavailable(),
        ingredientTable: BundledLibrary.ingredientTable(),
        onboarding: nil
    )
}
