#if DEBUG
    import SwiftUI

    /// A heading and the component under it. A component that runs from edge to edge of the screen, such
    /// as a tick row, keeps the screen margin itself and is not given one here. The key of the heading is
    /// the id the gallery scrolls to.
    struct GallerySection<Content: View>: View {
        let title: LocalizedStringResource
        var isFullBleed = false
        @ViewBuilder let content: Content

        var body: some View {
            VStack(alignment: .leading, spacing: Spacing.small) {
                Text(title)
                    .textStyle(.label)
                    .padding(.horizontal, Spacing.screenMargin)
                    .accessibilityAddTraits(.isHeader)
                content
                    .padding(.horizontal, margin)
            }
            .id(title.key)
        }

        private var margin: CGFloat {
            if isFullBleed {
                return .zero
            }
            return Spacing.screenMargin
        }
    }

    #Preview {
        GallerySection(title: .gallerySectionProgress) {
            ProgressRule(completed: 2, total: 6)
        }
        .background(ColorRole.paper.color)
    }
#endif
