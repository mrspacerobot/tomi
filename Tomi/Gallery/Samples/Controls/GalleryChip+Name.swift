#if DEBUG
    import Foundation

    extension GalleryChip {
        /// The made-up ingredient on the chip, the one the mockup shows in that state.
        var name: LocalizedStringResource {
            switch self {
            case .locked: .sampleChipLocked
            case .staple: .sampleChipOn
            case .spare: .sampleChipOff
            case .tonight: .sampleChipTonight
            case .removable: .sampleChipRemovable
            case .unsure: .sampleChipUnsure
            }
        }
    }
#endif
