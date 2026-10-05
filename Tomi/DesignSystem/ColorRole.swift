import SwiftUI

/// Every colour of the design, named by what it is for (the handoff table of `docs/design/round3.html`).
/// Each has a light and a dark value in `Tokens.xcassets`, so a screen never picks a colour by appearance.
nonisolated enum ColorRole: CaseIterable, Sendable {
    /// The ground of every screen.
    case paper
    /// Selected rows, bands and plates.
    case wash
    /// Text.
    case ink
    /// Rules, outlines and links.
    case cobalt
    /// Secondary text.
    case inkFaded
    /// Hairlines. Decorative: never the only carrier of meaning.
    case rule
    /// Dotted leaders and inactive marks.
    case leader
    /// Red text and alerts.
    case stampRed
    /// The stamp and pen marks. Brighter than `stampRed` in light, so not for text.
    case stampRedMark
    /// Tomi's body. Never for text.
    case printRed
    /// The third ink, for highlights.
    case yolk
    /// Text on the primary button.
    case onPrimary
    /// The fill of the primary button.
    case primaryFill

    /// On the main actor, because the symbols Xcode makes for the asset catalog are.
    @MainActor var color: Color {
        switch self {
        case .paper: Color(.paper)
        case .wash: Color(.wash)
        case .ink: Color(.ink)
        case .cobalt: Color(.cobalt)
        case .inkFaded: Color(.inkFaded)
        case .rule: Color(.rule)
        case .leader: Color(.leader)
        case .stampRed: Color(.stampRed)
        case .stampRedMark: Color(.stampRedMark)
        case .printRed: Color(.printRed)
        case .yolk: Color(.yolk)
        case .onPrimary: Color(.onPrimary)
        case .primaryFill: Color(.primaryFill)
        }
    }
}
