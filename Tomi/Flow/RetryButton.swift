import SwiftUI

/// Tries to fetch the cook's answers again.
struct RetryButton: View {
    let flow: AppFlowModel

    var body: some View {
        Button {
            Task { await flow.start() }
        } label: {
            Text(.loadFailedRetry)
        }
        .buttonStyle(ShowPrimaryButtonStyle())
        .accessibilityIdentifier("load-failed-retry")
    }
}
