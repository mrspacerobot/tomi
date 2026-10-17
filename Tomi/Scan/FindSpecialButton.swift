import SwiftUI

/// Asks for tonight's special with what the cook confirmed. The cupboard staples are added by the server.
struct FindSpecialButton: View {
    let model: ScanModel

    var body: some View {
        Button {
            Task { await model.findSpecial() }
        } label: {
            Text(.confirmFind)
        }
        .buttonStyle(.tomiPrimary)
        .accessibilityIdentifier("confirm-find")
    }
}
