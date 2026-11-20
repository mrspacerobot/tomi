nonisolated extension ColorRole {
    /// The roles text may be set in on a ground. Every default colour of a `TextStyle` is one of these.
    static var textRoles: Set<ColorRole> {
        Set(bodyTextPairings.map(\.text))
    }

    private static let tastingMenuTextRoles: [ColorRole] = [.ink, .inkFaded, .cobalt, .stampRed]

    /// The round 3 grounds shared by the original button and chip styles.
    static let grounds: [ColorRole] = [.paper, .wash]

    /// The name on a locked chip, which is filled with cobalt (`.r-chip.lock` in the design kit).
    static let lockedChip = TextPairing(text: .onPrimary, ground: .cobalt)

    /// Every pair of text and ground used for body text. A test holds each to the contrast rule in light and
    /// dark, so a component that sets text on another fill adds its pairing here first.
    static var bodyTextPairings: [TextPairing] {
        var pairings = [TextPairing(text: .onPrimary, ground: .primaryFill), lockedChip] + cookingShowTextPairings
        for ground in grounds {
            for text in tastingMenuTextRoles {
                pairings.append(TextPairing(text: text, ground: ground))
            }
        }
        return pairings
    }
}
