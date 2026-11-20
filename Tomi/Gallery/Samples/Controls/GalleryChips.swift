#if DEBUG
    import SwiftUI

    /// Every state of a chip, in the order of the handoff. Tap one to switch it or to take it off the list.
    struct GalleryChips: View {
        let model: GalleryModel

        var body: some View {
            FlowLayout {
                ForEach(model.shownChips, id: \.self) { chip in
                    Chip(name: String(localized: chip.name), kind: model.kind(of: chip)) {
                        model.tap(chip)
                    }
                    .accessibilityIdentifier(chip.identifier)
                }
            }
        }
    }

    #Preview {
        GalleryChips(model: GalleryModel())
            .padding()
            .background { ShowStage() }
    }
#endif
