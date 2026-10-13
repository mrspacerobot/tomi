import SwiftUI

/// The switch to let Tomi keep the photo, shown only when this build has the text the server asks for.
struct KeepPhotoSwitch: View {
    @Bindable var model: ScanModel

    var body: some View {
        if model.offersToKeepPhoto {
            Toggle(isOn: $model.keepsPhoto) { DatasetConsentWords() }
                .accessibilityIdentifier("consent-dataset")
        }
    }
}

#Preview {
    KeepPhotoSwitch(model: ScanModel.preview())
        .padding(Spacing.screenMargin)
        .background(ColorRole.paper.color)
}
