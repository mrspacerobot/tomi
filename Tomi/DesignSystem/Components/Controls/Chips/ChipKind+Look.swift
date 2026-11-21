import CoreGraphics

/// Palette and marks for the ingredient chip states shown in the debug gallery.
nonisolated extension ChipKind {
    var fill: ColorRole {
        switch self {
        case .locked: .showSign
        case .on: .showRed
        case .off, .offTonight: .showChipFill
        case .removable, .unsure: .showSurface
        }
    }

    var outline: ColorRole {
        switch self {
        case .locked: .showSign
        case .on, .unsure: .showRed
        case .off, .offTonight, .removable: .showMuted
        }
    }

    var text: ColorRole {
        switch self {
        case .locked, .on: .showWhite
        case .off, .offTonight, .removable, .unsure: .showInk
        }
    }

    /// The drawing before the name. The unsure chip has its own mark instead.
    var leadingGlyph: IconGlyph? {
        switch self {
        case .locked: .lock
        case .on: .check
        case .off: .plus
        case .offTonight, .removable, .unsure: nil
        }
    }

    /// A chip that a tap takes off its list carries a cross after the name.
    var isRemovable: Bool {
        self == .removable || self == .unsure
    }

    var isStruckThrough: Bool {
        self == .offTonight
    }

    /// The lengths of line and gap of the edge. Empty for a solid edge.
    var outlineDash: [CGFloat] {
        if self == .unsure {
            return [4, 3]
        }
        return []
    }

    var leadingPadding: CGFloat {
        switch self {
        case .removable: 13
        default: 10
        }
    }

    var trailingPadding: CGFloat {
        if isRemovable {
            return 4
        }
        return 13
    }
}
