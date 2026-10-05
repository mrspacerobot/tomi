import SwiftUI
import TomiCore

struct WelcomeMasthead: View {
    /// Nil only if the bundled library failed to load; the line counting the menu is then left out.
    let catalog: SkillCatalog?

    var body: some View {
        VStack(spacing: Spacing.small) {
            Text(.welcomeKicker)
                .textStyle(.label)
            Text(.welcomeTitle)
                .textStyle(.displayXL)
                .accessibilityIdentifier("welcome-title")
            if let catalog {
                Text(.welcomeSubtitle(catalog.skills.count, catalog.courses.count))
                    .textStyle(.description)
                    .accessibilityIdentifier("welcome-subtitle")
            }
        }
        .multilineTextAlignment(.center)
    }
}

#Preview {
    WelcomeMasthead(catalog: BundledLibrary.catalog())
}
