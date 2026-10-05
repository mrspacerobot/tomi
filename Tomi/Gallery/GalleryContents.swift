#if DEBUG
    import SwiftUI

    /// The title of the gallery and its sections, one under the other.
    struct GalleryContents: View {
        let model: GalleryModel

        var body: some View {
            VStack(alignment: .leading, spacing: Spacing.xxLarge) {
                Text(.galleryTitle)
                    .textStyle(.displayL)
                    .padding(.horizontal, Spacing.screenMargin)
                    .accessibilityAddTraits(.isHeader)
                    .accessibilityIdentifier("gallery-title")
                GalleryActions(model: model)
                GalleryDisplays(model: model)
            }
            .padding(.vertical, Spacing.xLarge)
        }
    }

    #Preview {
        ScrollView {
            GalleryContents(model: GalleryModel())
        }
        .background(ColorRole.paper.color)
    }
#endif
