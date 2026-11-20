#if DEBUG
    import SwiftUI

    /// The primary and the secondary button, live, and under them how often they were tapped.
    struct GalleryButtons: View {
        let model: GalleryModel

        var body: some View {
            VStack(spacing: Spacing.small) {
                Button(action: model.countTap) {
                    Text(.sampleButtonPrimary)
                }
                .buttonStyle(ShowPrimaryButtonStyle())
                .accessibilityIdentifier("gallery-button-primary")
                GalleryScanButton(model: model)
                GalleryStillButtons(model: model)
                Text(.galleryButtonTaps(model.taps))
                    .textStyle(.showLede)
                    .accessibilityIdentifier("gallery-button-taps")
            }
        }
    }

    #Preview {
        GalleryButtons(model: GalleryModel())
            .padding()
            .background { ShowStage() }
    }
#endif
