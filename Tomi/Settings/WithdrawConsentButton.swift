import SwiftUI
import TomiCore

/// A button that withdraws one consent on the server, then says it is done.
struct WithdrawConsentButton: View {
    let purpose: ConsentPurpose
    let words: LocalizedStringResource
    let flow: AppFlowModel
    @State private var isWithdrawn = false

    var body: some View {
        Button {
            Task { await withdraw() }
        } label: {
            Text(words)
        }
        .disabled(isWithdrawn)
        .accessibilityIdentifier("settings-withdraw-" + purpose.rawValue)
    }

    private func withdraw() async {
        do {
            try await flow.services.api.withdraw(purpose)
            isWithdrawn = true
        } catch {
            isWithdrawn = false
        }
    }
}
