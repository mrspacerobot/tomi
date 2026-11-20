#if DEBUG
    import SwiftUI

    /// The components a cook reads: use tags, the stats columns, the double-ruled box and the progress rule.
    struct GalleryDisplays: View {
        let model: GalleryModel

        var body: some View {
            GallerySection(title: .gallerySectionTags) {
                GalleryTags()
            }
            GallerySection(title: .gallerySectionStats) {
                StatsColumns(stats: Stat.samples, progress: Stat.sampleProgress)
            }
            GallerySection(title: .gallerySectionBox) {
                GalleryBox(model: model)
            }
            GallerySection(title: .gallerySectionProgress) {
                GalleryProgress(model: model)
            }
        }
    }

    #Preview {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xxLarge) {
                GalleryDisplays(model: GalleryModel())
            }
        }
        .background { ShowStage() }
    }
#endif
