import Testing

@testable import TomiCore

/// The contrast ratio of the Web Content Accessibility Guidelines, which decides whether text can be read.
@Suite struct ContrastTests {
    static let black = RGBColor(red: 0, green: 0, blue: 0)
    static let white = RGBColor(red: 1, green: 1, blue: 1)
    static let ink = RGBColor(red: 23.0 / 255, green: 42.0 / 255, blue: 110.0 / 255)
    static let paper = RGBColor(red: 251.0 / 255, green: 250.0 / 255, blue: 245.0 / 255)
    static let grey = RGBColor(red: 119.0 / 255, green: 119.0 / 255, blue: 119.0 / 255)

    @Test func blackOnWhiteIsTheHighestContrastThereIs() {
        #expect(abs(Self.black.contrastRatio(with: Self.white) - 21) < 0.001)
    }

    @Test func aColourOnItselfHasNoContrast() {
        #expect(Self.ink.contrastRatio(with: Self.ink) == 1)
    }

    @Test func whiteIsTheBrightestColourAndBlackTheDarkest() {
        #expect(Self.white.relativeLuminance == 1)
        #expect(Self.black.relativeLuminance == 0)
    }

    @Test func itDoesNotMatterWhichColourIsTheText() {
        #expect(Self.ink.contrastRatio(with: Self.paper) == Self.paper.contrastRatio(with: Self.ink))
    }

    @Test func inkOnPaperGivesTheRatioOfTheDesign() {
        #expect(abs(Self.ink.contrastRatio(with: Self.paper) - 12.62) < 0.01)
    }

    @Test func greenCountsForMoreBrightnessThanRedAndRedMoreThanBlue() {
        let red = RGBColor(red: 1, green: 0, blue: 0)
        let green = RGBColor(red: 0, green: 1, blue: 0)
        let blue = RGBColor(red: 0, green: 0, blue: 1)
        #expect(green.relativeLuminance > red.relativeLuminance)
        #expect(red.relativeLuminance > blue.relativeLuminance)
    }

    @Test func bodyTextNeedsFourAndAHalfToOne() {
        #expect(ContrastRule.minimumForBodyText == 4.5)
        #expect(ContrastRule.isReadableAsBodyText(Self.ink, on: Self.paper))
        #expect(!ContrastRule.isReadableAsBodyText(Self.paper, on: Self.white))
    }

    /// Grey #777777 on white is 4.48 to 1: the well-known pair that looks fine and just fails.
    @Test func aPairJustUnderTheMinimumIsNotReadable() {
        #expect(!ContrastRule.isReadableAsBodyText(Self.grey, on: Self.white))
    }
}
