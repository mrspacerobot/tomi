import SwiftUI
import Testing
import TomiCore

@testable import Tomi

/// The states of the primary and the secondary button: each can be told from the others and can be read.
@Suite struct ButtonLookTests {
    static let states = [true, false]

    @Test(arguments: TomiButtonKind.allCases, states)
    func theWordsOfAnEnabledButtonAreACheckedPairing(kind: TomiButtonKind, isPressed: Bool) {
        let look = ButtonLook.look(of: kind, isPressed: isPressed, isEnabled: true)
        let ground = look.fill ?? .paper
        #expect(ColorRole.bodyTextPairings.contains(TextPairing(text: look.text, ground: ground)))
    }

    @Test(arguments: TomiButtonKind.allCases)
    func aPressedButtonLooksDifferentFromOneAtRest(kind: TomiButtonKind) {
        let resting = ButtonLook.look(of: kind, isPressed: false, isEnabled: true)
        let pressed = ButtonLook.look(of: kind, isPressed: true, isEnabled: true)
        #expect(resting != pressed)
    }

    @Test(arguments: TomiButtonKind.allCases, states)
    func aDisabledButtonLooksTheSameWhateverItsKind(kind: TomiButtonKind, isPressed: Bool) {
        let look = ButtonLook.look(of: kind, isPressed: isPressed, isEnabled: false)
        #expect(look == ButtonLook.disabled)
        #expect(look != ButtonLook.look(of: kind, isPressed: false, isEnabled: true))
        #expect(ColorRole.bodyTextPairings.contains(TextPairing(text: look.text, ground: .paper)))
    }

    /// The pressed primary button lets the ground through its fill, which is a colour no role names.
    @Test(arguments: [ColorScheme.light, .dark], ColorRole.grounds)
    @MainActor func theWordsOfAPressedPrimaryButtonCanBeRead(scheme: ColorScheme, ground: ColorRole) {
        let look = ButtonLook.look(of: .primary, isPressed: true, isEnabled: true)
        let fill = ColorRole.primaryFill.rgb(in: scheme)
            .laid(over: ground.rgb(in: scheme), opacity: look.fillOpacity)
        #expect(look.fillOpacity < 1)
        #expect(ContrastRule.isReadableAsBodyText(look.text.rgb(in: scheme), on: fill))
    }
}
