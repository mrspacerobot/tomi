import SwiftUI
import Testing
import TomiCore

@testable import Tomi

/// The colours that ship in the asset catalog, read the way a screen gets them.
@Suite struct ColorTokenTests {
    static let schemes: [ColorScheme] = [.light, .dark]

    @Test(arguments: ColorRole.bodyTextPairings, schemes)
    @MainActor func bodyTextCanBeReadOnItsGround(pairing: TextPairing, scheme: ColorScheme) {
        let text = pairing.text.rgb(in: scheme)
        let ground = pairing.ground.rgb(in: scheme)
        let ratio = text.contrastRatio(with: ground)
        #expect(
            ContrastRule.isReadableAsBodyText(text, on: ground),
            "\(pairing.text) on \(pairing.ground) in \(scheme) is \(ratio) to 1"
        )
    }

    @Test func theGroundsAndTheFilledComponentsArePairedWithText() {
        let grounds = Set(ColorRole.bodyTextPairings.map(\.ground))
        #expect(
            grounds == [
                .paper, .wash, .primaryFill, .cobalt, .stage, .stageGlow, .showSurface, .showRed, .showGold,
                .showChipFill, .showTabHighlight, .showCorrect, .showError, .showBlue,
            ]
        )
    }

    @Test(arguments: TextStyle.allCases)
    func everyTextStyleIsSetInAColourThatIsCheckedForContrast(style: TextStyle) {
        #expect(ColorRole.textRoles.contains(style.defaultColor))
    }

    /// Guards the reading of the catalog itself: paper is #FBFAF5 in light and night ink #0E1736 in dark.
    @MainActor @Test func theGroundIsPaperInLightAndNightInkInDark() {
        let paper = RGBColor(red: 251.0 / 255, green: 250.0 / 255, blue: 245.0 / 255)
        let nightInk = RGBColor(red: 14.0 / 255, green: 23.0 / 255, blue: 54.0 / 255)
        #expect(ColorRole.paper.rgb(in: .light).contrastRatio(with: paper) < 1.01)
        #expect(ColorRole.paper.rgb(in: .dark).contrastRatio(with: nightInk) < 1.01)
    }

    @Test(arguments: [
        ColorRole.paper, .wash, .ink, .cobalt, .inkFaded, .rule, .leader, .stampRed, .onPrimary, .companionLine,
        .companionGlow,
    ])
    @MainActor func aRoleThatChangesWithTheAppearanceHasADarkValue(role: ColorRole) {
        #expect(role.rgb(in: .light) != role.rgb(in: .dark))
    }
}
