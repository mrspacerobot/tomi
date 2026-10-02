import SwiftUI
import TomiCore

struct WelcomeMasthead: View {
    var body: some View {
        VStack(spacing: 6) {
            Text(.welcomeKicker)
                .textStyle(.kicker)
            Text(.welcomeTitle)
                .textStyle(.title)
                .accessibilityIdentifier("welcome-title")
            Text(.welcomeSubtitle(SkillCatalog.all.count, Course.allCases.count))
                .textStyle(.subtitle)
                .accessibilityIdentifier("welcome-subtitle")
        }
    }
}

#Preview {
    WelcomeMasthead()
}
