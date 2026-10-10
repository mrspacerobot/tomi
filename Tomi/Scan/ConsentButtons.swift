import SwiftUI

/// Agree and scan, or type instead without sending a photo.
struct ConsentButtons: View {
    let model: ScanModel

    var body: some View {
        VStack(spacing: Spacing.small) {
            Button {
                Task { await model.agree() }
            } label: {
                Text(.consentScanAgree)
            }
            .buttonStyle(.tomiPrimary)
            .accessibilityIdentifier("consent-agree")
            Button(action: model.typeInstead) { Text(.scanTypeInstead) }
                .buttonStyle(.tomiSecondary)
                .accessibilityIdentifier("scan-type-instead")
        }
    }
}
