nonisolated extension ColorRole {
    static var textRoles: Set<ColorRole> {
        Set(bodyTextPairings.map(\.text))
    }

    /// Every pair of text and ground used for body text, checked in both appearances.
    static let bodyTextPairings: [TextPairing] = [
        TextPairing(text: .stageInk, ground: .stage),
        TextPairing(text: .stageInk, ground: .stageGlow),
        TextPairing(text: .stageMuted, ground: .stage),
        TextPairing(text: .stageMuted, ground: .stageGlow),
        TextPairing(text: .stageGold, ground: .stage),
        TextPairing(text: .stageGold, ground: .stageGlow),
        TextPairing(text: .showInk, ground: .showSurface),
        TextPairing(text: .showMuted, ground: .showSurface),
        TextPairing(text: .showRed, ground: .showSurface),
        TextPairing(text: .showChecked, ground: .showSurface),
        TextPairing(text: .showWhite, ground: .showRed),
        TextPairing(text: .showBulb, ground: .showRed),
        TextPairing(text: .showInk, ground: .showGold),
        TextPairing(text: .showInk, ground: .showChipFill),
        TextPairing(text: .showRed, ground: .showTabHighlight),
        TextPairing(text: .showInk, ground: .showCorrect),
        TextPairing(text: .showWhite, ground: .showError),
        TextPairing(text: .showWhite, ground: .showBlue),
        TextPairing(text: .showWhite, ground: .curtainRed),
        TextPairing(text: .showWhite, ground: .curtainLight),
        TextPairing(text: .showWhite, ground: .curtainShade),
        TextPairing(text: .showWhite, ground: .showSign),
    ]
}
