#if DEBUG
    import SwiftUI

    /// The three use tags of a dish: from the fridge, from the cupboard, and missing.
    struct GalleryTags: View {
        var body: some View {
            FlowLayout(spacing: ChipFace.gap) {
                UseTag(name: String(localized: .sampleTagFridge), kind: .fridge)
                    .accessibilityIdentifier("gallery-tag-fridge")
                UseTag(name: String(localized: .sampleTagCupboard), kind: .cupboard)
                    .accessibilityIdentifier("gallery-tag-cupboard")
                UseTag(name: String(localized: .sampleTagMissing), kind: .missing)
                    .accessibilityIdentifier("gallery-tag-missing")
            }
        }
    }

    #Preview {
        GalleryTags()
            .padding()
            .background { ShowStage() }
    }
#endif
