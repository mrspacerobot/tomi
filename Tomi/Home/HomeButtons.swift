import SwiftUI

/// Show Tomi the fridge, or change the answers.
struct HomeButtons: View {
    @Binding var path: [HomeRoute]

    var body: some View {
        VStack(spacing: Spacing.small) {
            Button { path.append(.scan) } label: { Text(.homeScan) }
                .buttonStyle(.tomiPrimary)
                .accessibilityIdentifier("home-scan")
            Button { path.append(.settings) } label: { Text(.homeSettings) }
                .buttonStyle(.tomiSecondary)
                .accessibilityIdentifier("home-settings")
        }
    }
}
