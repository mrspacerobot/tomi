import Testing

@testable import Tomi

/// The states of a chip and of a use tag: each can be read, and chips never differ by colour alone.
@Suite struct ChipLookTests {
    @Test(arguments: ChipKind.allCases)
    func theNameOnAChipIsACheckedPairing(kind: ChipKind) {
        let ground = kind.fill ?? .paper
        #expect(ColorRole.bodyTextPairings.contains(TextPairing(text: kind.text, ground: ground)))
    }

    /// What is left of a chip when every colour is taken away: its mark, its cross, the line through its
    /// name and whether its edge is dashed.
    private func shape(of kind: ChipKind) -> [String] {
        [
            String(describing: kind.leadingGlyph), String(kind.isRemovable), String(kind.isStruckThrough),
            String(kind.outlineDash.isEmpty),
        ]
    }

    @Test func noTwoStatesOfAChipDifferByColourAlone() {
        let shapes = ChipKind.allCases.map(shape(of:))
        #expect(Set(shapes).count == ChipKind.allCases.count)
    }

    @Test func onlyAChipThatIsSwitchedOnIsFilledWithTheWash() {
        let filled = ChipKind.allCases.filter { $0.fill == .wash }
        #expect(filled == [.on])
    }

    @Test(arguments: UseTagKind.allCases)
    func theNameOnAUseTagIsACheckedPairing(kind: UseTagKind) {
        #expect(ColorRole.bodyTextPairings.contains(TextPairing(text: kind.text, ground: .paper)))
    }

    @Test func aMissingIngredientIsMarkedByADashedEdgeAndNotOnlyByRed() {
        #expect(!UseTagKind.missing.outlineDash.isEmpty)
        #expect(UseTagKind.fridge.outlineDash.isEmpty)
        #expect(UseTagKind.cupboard.outlineDash.isEmpty)
    }
}
