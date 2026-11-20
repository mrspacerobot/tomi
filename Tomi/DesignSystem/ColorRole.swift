/// Every colour of the design, including the Cooking Show palette in the design handoff.
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
    /// Tomi's shoes.
    case companionShoe
    /// The shaded side of Tomi's tomato body.
    case companionShade
    /// Tomi's cheeks and tongue.
    case companionBlush
    /// The soft warm glow around Tomi on night ink. Clear on paper, where a glow would blur his outline.
    case companionGlow

    case stage
    case stageGlow
    case stageInk
    case stageMuted
    case stageGold
    case showSurface
    case showInk
    case showMuted
    case showAccent
    case showRed
    case showWhite
    case showLip
    case showGold
    case showBulb
    case showSign
    case showShadow
    case showScrim
    case showChipFill
    case showTabHighlight
    case showCorrect
    case showNotQuite
    case showError
    case showChecked
    case showBlue
    case hostInk
    case hostShade
    case hostBlush
    case hostShoe
    case hostMouth
    case hostTongue
}
