#if DEBUG
    import SwiftUI

    /// A disabled primary button for the gallery accessibility checks.
    struct GalleryStillButtons: View {
        let model: GalleryModel

        var body: some View {
            Button(action: model.countTap) {
                Text(.sampleButtonDisabled)
            }
            .buttonStyle(ShowPrimaryButtonStyle())
            .disabled(true)
            .accessibilityIdentifier("gallery-button-disabled")

        }
    }

    #Preview {
        VStack(spacing: Spacing.small) {
            GalleryStillButtons(model: GalleryModel())
        }
        .padding()
        .background { ShowStage() }
    }
#endif
