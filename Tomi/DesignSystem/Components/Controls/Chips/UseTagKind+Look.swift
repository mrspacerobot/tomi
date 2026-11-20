import CoreGraphics

/// Colors and outlines for ingredient availability tags in the debug gallery.
nonisolated extension UseTagKind {
    var text: ColorRole {
        switch self {
        case .fridge: .showChecked
        case .cupboard: .showMuted
        case .missing: .showRed
        }
    }

    var outline: ColorRole {
        switch self {
        case .fridge: .showChecked
        case .cupboard: .showMuted
        case .missing: .showRed
        }
    }

    var outlineWeight: CGFloat {
        if self == .missing {
            return RuleWeight.outline
        }
        return RuleWeight.hairline
    }

    /// The lengths of line and gap of the edge. Empty for a solid edge.
    var outlineDash: [CGFloat] {
        if self == .missing {
            return [4, 3]
        }
        return []
    }

    var minimumHeight: CGFloat {
        if self == .missing {
            return 30
        }
        return 26
    }

    var sidePadding: CGFloat {
        if self == .missing {
            return 10
        }
        return 9
    }
}
