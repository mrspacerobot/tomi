#if DEBUG
    import SwiftUI

    /// The secondary button with a drawing before its words, as the handoff shows it.
    struct GalleryScanButton: View {
        let model: GalleryModel

        var body: some View {
            Button(action: model.countTap) {
                Icon(.camera, size: .medium)
                Text(.sampleButtonSecondary)
            }
            .buttonStyle(.tomiSecondary)
            .accessibilityIdentifier("gallery-button-secondary")
        }
    }

    #Preview {
        GalleryScanButton(model: GalleryModel())
            .padding()
            .background(ColorRole.paper.color)
    }
#endif
