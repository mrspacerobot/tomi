import SwiftUI

/// Named text styles. The full set from the design handoff arrives with the design system.
enum TextStyle {
    case kicker
    case title
    case subtitle

    var font: Font {
        switch self {
        case .kicker: .caption.weight(.semibold)
        case .title: .system(.largeTitle, design: .serif)
        case .subtitle: .system(.body, design: .serif).italic()
        }
    }

    var color: Color {
        switch self {
        case .kicker: Theme.cobalt
        case .title: Theme.ink
        case .subtitle: Theme.inkFaded
        }
    }

    var tracking: CGFloat {
        self == .kicker ? 2 : 0
    }

    var textCase: Text.Case? {
        self == .kicker ? .uppercase : nil
    }
}
