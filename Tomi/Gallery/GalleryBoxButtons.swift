#if DEBUG
    import SwiftUI

    /// The two buttons inside the box: a primary one with a drawing, and a secondary one.
    struct GalleryBoxButtons: View {
        let model: GalleryModel

        var body: some View {
            Button(action: model.countTap) {
                Icon(.camera, size: .medium)
                Text(.sampleBoxScan)
            }
            .buttonStyle(.tomiPrimary)
            Button(action: model.countTap) {
                Text(.sampleBoxType)
            }
            .buttonStyle(.tomiSecondary)
        }
    }

    #Preview {
        VStack(spacing: Spacing.small) {
            GalleryBoxButtons(model: GalleryModel())
        }
        .padding()
        .background(ColorRole.paper.color)
    }
#endif
