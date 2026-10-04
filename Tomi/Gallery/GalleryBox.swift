#if DEBUG
    import SwiftUI

    /// The double-ruled box filled the way the first evening of home fills it.
    struct GalleryBox: View {
        let model: GalleryModel

        var body: some View {
            DoubleRuledBox(flag: .sampleBoxFlag) {
                Text(.sampleBoxTitle)
                    .textStyle(.title)
                    .accessibilityIdentifier("gallery-box-title")
                Text(.sampleBoxDescription)
                    .textStyle(.description)
                GalleryBoxButtons(model: model)
            }
        }
    }

    #Preview {
        GalleryBox(model: GalleryModel())
            .padding()
            .background(ColorRole.paper.color)
    }
#endif
