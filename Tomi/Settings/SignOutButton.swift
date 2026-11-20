import SwiftUI

/// Signs the cook out. Their answers stay on the server for the next sign-in.
struct SignOutButton: View {
    let flow: AppFlowModel

    var body: some View {
        Button(role: .destructive) {
            Task { await flow.signOut() }
        } label: {
            Text(.settingsSignOut)
                .textStyle(.showLede)
                .frame(minHeight: TouchTarget.minimum)
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("settings-sign-out")
    }
}
