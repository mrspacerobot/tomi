#if DEBUG
    import SwiftUI

    /// A card with a heading and actions like the episode guide.
    struct GalleryBox: View {
        let model: GalleryModel

        var body: some View {
            ShowCard {
                VStack(alignment: .leading, spacing: ShowSize.gap) {
                    ShowLowerThird(title: .sampleBoxFlag)
                    Text(.sampleBoxTitle)
                        .textStyle(.cardTitle)
                        .accessibilityIdentifier("gallery-box-title")
                    Text(.sampleBoxDescription).textStyle(.showNote)
                    GalleryBoxButtons(model: model)
                }
            }
        }
    }

    #Preview {
        GalleryBox(model: GalleryModel())
            .padding()
            .background { ShowStage() }
    }
#endif
