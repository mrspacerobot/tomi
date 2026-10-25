import SwiftUI

/// Opens the cook's answers.
struct HomeSettingsButton: View {
    @Binding var path: [HomeRoute]

    var body: some View {
        Button {
            path.append(.settings)
        } label: {
            Text(.homeSettings)
        }
        .buttonStyle(.tomiSecondary)
        .accessibilityIdentifier("home-settings")
    }
}
