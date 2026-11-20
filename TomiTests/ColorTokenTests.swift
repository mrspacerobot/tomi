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
                .stage, .stageGlow, .showSurface, .showRed, .showGold,
                .showChipFill, .showTabHighlight, .showCorrect, .showError, .showBlue, .curtainRed, .curtainLight,
                .curtainShade, .showSign,
            ]
        )
    }

    @Test(arguments: TextStyle.allCases)
    func everyTextStyleIsSetInAColourThatIsCheckedForContrast(style: TextStyle) {
        #expect(ColorRole.textRoles.contains(style.defaultColor))
    }

    /// Guards the reading of the asset catalog against the approved stage colors.
    @MainActor @Test func theStageUsesTheMorningAndEveningColors() {
        let morning = RGBColor(red: 1, green: 235.0 / 255, blue: 210.0 / 255)
        let evening = RGBColor(red: 36.0 / 255, green: 18.0 / 255, blue: 46.0 / 255)
        #expect(ColorRole.stage.rgb(in: .light).contrastRatio(with: morning) < 1.01)
        #expect(ColorRole.stage.rgb(in: .dark).contrastRatio(with: evening) < 1.01)
    }

    @Test(arguments: [
        ColorRole.stage, .stageGlow, .stageInk, .stageMuted, .stageGold, .showSurface, .showChipFill, .showTabHighlight,
    ])
    @MainActor func aRoleThatChangesWithTheAppearanceHasADarkValue(role: ColorRole) {
        #expect(role.rgb(in: .light) != role.rgb(in: .dark))
    }
}
