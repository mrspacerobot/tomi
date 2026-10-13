import SwiftUI

/// Asked before the first scan: the photo goes to Tomi's server to be read. Keeping it is a separate
/// choice, off unless the cook turns it on. The words are the texts of the versions `ConsentText.version(for:)` names.
struct ConsentView: View {
    @Bindable var model: ScanModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.large) {
                ScanHeader(title: .consentScanTitle, identifier: "consent-title", problem: model.problem)
                Text(.consentScanBody)
                    .textStyle(.body)
                KeepPhotoSwitch(model: model)
                ConsentButtons(model: model)
            }
            .padding(Spacing.screenMargin)
        }
    }
}

#Preview {
    ConsentView(model: ScanModel.preview())
        .background(ColorRole.paper.color)
}
