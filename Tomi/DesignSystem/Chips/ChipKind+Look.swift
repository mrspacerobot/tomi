import CoreGraphics

/// What each state of a chip is drawn with, value for value from `.r-chip` in the design kit.
nonisolated extension ChipKind {
    /// Nil when the ground shows through.
    var fill: ColorRole? {
        switch self {
        case .locked: .cobalt
        case .on: .wash
        case .off, .offTonight: nil
        case .removable, .unsure: .paper
        }
    }

    var outline: ColorRole {
        switch self {
        case .locked, .on, .removable: .cobalt
        case .off, .offTonight: .leader
        case .unsure: .stampRed
        }
    }

    var text: ColorRole {
        switch self {
        case .locked: .onPrimary
        case .on, .removable, .unsure: .ink
        case .off, .offTonight: .inkFaded
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
