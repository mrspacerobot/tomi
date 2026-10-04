import CoreGraphics

/// What each use tag is drawn with, value for value from `.r-use` and `.r-miss` in the design kit.
nonisolated extension UseTagKind {
    var text: ColorRole {
        switch self {
        case .fridge: .cobalt
        case .cupboard: .inkFaded
        case .missing: .stampRed
        }
    }

    var outline: ColorRole {
        switch self {
        case .fridge: .cobalt
        case .cupboard: .leader
        case .missing: .stampRed
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
