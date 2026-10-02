import SwiftUI

/// Placeholder first screen for the project scaffold. Replaced by onboarding and home in later phases.
struct WelcomeView: View {
    var body: some View {
        VStack(spacing: 20) {
            TomiMascot()
                .frame(width: 180, height: 180)
                .accessibilityLabel(Text(.mascotLabel))
            WelcomeMasthead()
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.paper)
    }
}

#Preview {
    WelcomeView()
}
