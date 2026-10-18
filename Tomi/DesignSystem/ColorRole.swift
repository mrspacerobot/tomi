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
    /// Tomi's thick outline and rubber-hose limbs: deep ink on paper, periwinkle on night ink.
    case companionLine
    /// Tomi's pupils, brows and mouth, always ink because they sit on his white eyes and tomato skin.
    case companionFeature
    /// Tomi's toque.
    case companionToque
    /// Tomi's gloves, eye whites and shine.
    case companionWhite
    /// The leaf by Tomi's toque.
    case companionLeaf
    /// Tomi's shoes.
    case companionShoe
    /// The shaded side of Tomi's tomato body.
    case companionShade
    /// Tomi's cheeks and tongue.
    case companionBlush
    /// The soft warm glow around Tomi on night ink. Clear on paper, where a glow would blur his outline.
    case companionGlow

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
        case .companionLine: Color(.companionLine)
        case .companionFeature: Color(.companionFeature)
        case .companionToque: Color(.companionToque)
        case .companionWhite: Color(.companionWhite)
        case .companionLeaf: Color(.companionLeaf)
        case .companionShoe: Color(.companionShoe)
        case .companionShade: Color(.companionShade)
        case .companionBlush: Color(.companionBlush)
        case .companionGlow: Color(.companionGlow)
        }
    }
}
