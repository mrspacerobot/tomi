import SwiftUI
import TomiCore

/// Placeholder first screen for the project scaffold. Replaced by onboarding and home in later phases.
struct WelcomeView: View {
    let catalog: SkillCatalog?

    var body: some View {
        VStack(spacing: Spacing.xLarge) {
            TomiMascot()
                .frame(width: MascotSize.welcome, height: MascotSize.welcome)
                .accessibilityLabel(Text(.mascotLabel))
            WelcomeMasthead(catalog: catalog)
        }
        .padding(Spacing.xLarge)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ColorRole.paper.color)
    }
}

#Preview {
    WelcomeView(catalog: BundledLibrary.catalog())
}

#Preview("Dark, largest text") {
    WelcomeView(catalog: BundledLibrary.catalog())
        .preferredColorScheme(.dark)
        .dynamicTypeSize(.accessibility5)
}
