#if DEBUG
    import SwiftUI

    /// The components a cook taps: buttons, tick rows for one answer and for several, and chips.
    struct GalleryActions: View {
        let model: GalleryModel

        var body: some View {
            GallerySection(title: .gallerySectionButtons) {
                GalleryButtons(model: model)
            }
            GallerySection(title: .gallerySectionTickSingle) {
                GalleryTickRows(
                    samples: TickRowSample.diets,
                    selection: model.diet,
                    identifier: "gallery-single",
                    onTap: model.tapDiet
                )
            }
            GallerySection(title: .gallerySectionTickMultiple) {
                GalleryTickRows(
                    samples: TickRowSample.equipment,
                    selection: model.equipment,
                    identifier: "gallery-multiple",
                    onTap: model.tapEquipment
                )
            }
            GallerySection(title: .gallerySectionChips) {
                GalleryChips(model: model)
            }
        }
    }

    #Preview {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xxLarge) {
                GalleryActions(model: GalleryModel())
            }
        }
        .background { ShowStage() }
    }
#endif
