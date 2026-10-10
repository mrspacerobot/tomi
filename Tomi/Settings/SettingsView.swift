import SwiftUI

/// Every question about the cook, to change an answer, the photo consents, and signing out.
struct SettingsView: View {
    let flow: AppFlowModel

    var body: some View {
        List {
            QuestionLinks()
            PhotoConsentSection(flow: flow)
            SignOutButton(flow: flow)
        }
        .navigationTitle(Text(.settingsTitle))
        .scrollContentBackground(.hidden)
        .background(ColorRole.paper.color)
    }
}

#Preview {
    NavigationStack {
        SettingsView(flow: .preview())
    }
}
