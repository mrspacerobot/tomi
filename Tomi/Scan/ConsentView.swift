import SwiftUI

/// Asked before the first scan: the photo goes to Tomi's server to be read. Keeping it is a separate
/// choice, off unless the cook turns it on. The words are the text of version `ConsentText.version`.
struct ConsentView: View {
    @Bindable var model: ScanModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.large) {
                Text(.consentScanTitle)
                    .textStyle(.displayL)
                    .accessibilityIdentifier("consent-title")
                Text(.consentScanBody)
                    .textStyle(.body)
                Toggle(isOn: $model.keepsPhoto) { DatasetConsentWords() }
                    .accessibilityIdentifier("consent-dataset")
                if let problem = model.problem {
                    ProblemView(problem: problem)
                }
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
