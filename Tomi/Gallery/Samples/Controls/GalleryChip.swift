#if DEBUG
    import Foundation

    /// The chips the gallery shows, one for each state the design draws.
    nonisolated enum GalleryChip: String, CaseIterable, Sendable {
        case locked
        case staple
        case spare
        case tonight
        case removable
        case unsure

        /// What UI tests find the chip by.
        var identifier: String {
            "gallery-chip-\(rawValue)"
        }

        /// How the chip is drawn when it is on its list and switched on.
        var kind: ChipKind {
            switch self {
            case .locked: .locked
            case .staple, .spare, .tonight: .on
            case .removable: .removable
            case .unsure: .unsure
            }
        }

        /// How the chip is drawn when it is switched off. Nil for a chip that cannot be switched.
        var offKind: ChipKind? {
            switch self {
            case .staple, .spare: .off
            case .tonight: .offTonight
            case .locked, .removable, .unsure: nil
            }
        }
    }
#endif
