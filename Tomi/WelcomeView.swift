import SwiftUI
import TomiCore

/// Placeholder first screen for the project scaffold. Replaced by onboarding and home in later phases.
struct WelcomeView: View {
    let catalog: SkillCatalog?

    var body: some View {
        VStack(spacing: 20) {
            TomiMascot()
                .frame(width: 180, height: 180)
                .accessibilityLabel(Text(.mascotLabel))
            WelcomeMasthead(catalog: catalog)
            Text("hello")
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.paper)
    }
}

#Preview {
    WelcomeView(catalog: BundledLibrary.catalog())
}
