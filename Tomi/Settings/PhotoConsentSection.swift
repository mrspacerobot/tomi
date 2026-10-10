import SwiftUI

/// Withdrawing the photo consents. Withdrawing the dataset consent also deletes every kept photo on the server.
struct PhotoConsentSection: View {
    let flow: AppFlowModel

    var body: some View {
        Section {
            WithdrawConsentButton(purpose: .photoDataset, words: .settingsWithdrawDataset, flow: flow)
            WithdrawConsentButton(purpose: .photoScan, words: .settingsWithdrawScan, flow: flow)
        } header: {
            Text(.settingsPhotos)
        }
    }
}
