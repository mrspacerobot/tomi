import SwiftUI

/// Every question about the cook, to change an answer, and signing out.
struct SettingsView: View {
    let flow: AppFlowModel

    var body: some View {
        List {
            ForEach(ProfileQuestion.allCases, id: \.self) { question in
                NavigationLink(value: HomeRoute.question(question)) {
                    Text(question.title)
                        .textStyle(.body)
                }
                .accessibilityIdentifier("settings-" + question.identifier)
            }
            Button(role: .destructive) {
                Task { await flow.signOut() }
            } label: {
                Text(.settingsSignOut)
            }
            .accessibilityIdentifier("settings-sign-out")
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
