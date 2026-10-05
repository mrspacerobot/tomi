import SwiftUI
import TomiCore

/// Placeholder first screen for the project scaffold. Replaced by onboarding and home in later phases.
struct WelcomeView: View {
    let catalog: SkillCatalog?
    let summary: ProgressSummary

    var body: some View {
        VStack(spacing: Spacing.xLarge) {
            TomiMascot()
                .frame(width: MascotSize.welcome, height: MascotSize.welcome)
                .accessibilityLabel(Text(.mascotLabel))
            WelcomeMasthead(catalog: catalog)
            WelcomeProgress(summary: summary)
        }
        .padding(Spacing.xLarge)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ColorRole.paper.color)
    }
}

#Preview {
    if let summary = SavedProgressModel.previewWithProgress().summary {
        WelcomeView(catalog: BundledLibrary.catalog(), summary: summary)
    }
}

#Preview("Dark, largest text") {
    if let summary = SavedProgressModel.previewWithProgress().summary {
        WelcomeView(catalog: BundledLibrary.catalog(), summary: summary)
            .preferredColorScheme(.dark)
            .dynamicTypeSize(.accessibility5)
    }
}
