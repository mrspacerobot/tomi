#if DEBUG
    import SwiftUI

    /// The states of a button a finger cannot hold still for a screenshot: disabled, and both kinds pressed.
    /// The pressed ones are pictures of the state, so VoiceOver skips them.
    struct GalleryStillButtons: View {
        let model: GalleryModel

        var body: some View {
            Button(action: model.countTap) {
                Text(.sampleButtonDisabled)
            }
            .buttonStyle(.tomiPrimary)
            .disabled(true)
            .accessibilityIdentifier("gallery-button-disabled")
            ForEach(TomiButtonKind.allCases, id: \.self) { kind in
                ButtonFace(kind: kind, isPressed: true) {
                    Text(.galleryStatePressed)
                }
                .accessibilityHidden(true)
            }
        }
    }

    #Preview {
        VStack(spacing: Spacing.small) {
            GalleryStillButtons(model: GalleryModel())
        }
        .padding()
        .background(ColorRole.paper.color)
    }
#endif
