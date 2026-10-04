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
                .buttonStyle(.tomiPrimary)
                .accessibilityIdentifier("gallery-button-primary")
                GalleryScanButton(model: model)
                GalleryStillButtons(model: model)
                Text(.galleryButtonTaps(model.taps))
                    .textStyle(.description)
                    .accessibilityIdentifier("gallery-button-taps")
            }
        }
    }

    #Preview {
        GalleryButtons(model: GalleryModel())
            .padding()
            .background(ColorRole.paper.color)
    }
#endif
