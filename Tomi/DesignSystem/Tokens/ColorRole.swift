/// Cooking Show colours and the palette used by the shipped icon.
/// Each has a light and a dark value in `Tokens.xcassets`, so a screen never picks a colour by appearance.
nonisolated enum ColorRole: CaseIterable, Sendable {
    /// The ground of the shipped app icon.
    case wash
    /// Tomi's body. Never for text.
    case printRed
    /// The third ink, for highlights.
    case yolk
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
    case curtainRed
    case curtainLight
    case curtainShade
    case stageFloor
    case stageFloorEdge
    case stageBeam
    case signalCyan
    case signalPink
}
