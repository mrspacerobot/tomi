import SwiftUI
import TomiCore

struct WelcomeMasthead: View {
    /// Nil only if the bundled library failed to load; the line counting the menu is then left out.
    let catalog: SkillCatalog?

    var body: some View {
        VStack(spacing: 6) {
            Text(.welcomeKicker)
                .textStyle(.kicker)
            Text(.welcomeTitle)
                .textStyle(.title)
                .accessibilityIdentifier("welcome-title")
            if let catalog {
                Text(.welcomeSubtitle(catalog.skills.count, catalog.courses.count))
                    .textStyle(.subtitle)
                    .accessibilityIdentifier("welcome-subtitle")
            }
        }
    }
}

#Preview {
    WelcomeMasthead(catalog: BundledLibrary.catalog())
}
