import SwiftUI

/// The separate choice to let Tomi keep the photo, and what that means.
struct DatasetConsentWords: View {
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xxSmall) {
            Text(.consentDatasetTitle)
                .textStyle(.option)
            Text(.consentDatasetBody)
                .textStyle(.description)
        }
    }
}

#Preview {
    DatasetConsentWords()
}
