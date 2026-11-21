#if DEBUG
    import SwiftUI

    /// A heading and its components. The key of the heading is the id the gallery scrolls to.
    struct GallerySection<Content: View>: View {
        let title: LocalizedStringResource
        @ViewBuilder let content: Content

        var body: some View {
            VStack(alignment: .leading, spacing: Spacing.small) {
                Text(title)
                    .textStyle(.showLabel)
                    .padding(.horizontal, Spacing.screenMargin)
                    .accessibilityAddTraits(.isHeader)
                content
                    .padding(.horizontal, Spacing.screenMargin)
            }
            .id(title.key)
        }

    }

    #Preview {
        GallerySection(title: .gallerySectionProgress) {
            ProgressRule(completed: 2, total: 6)
        }
        .background { ShowStage() }
    }
#endif
