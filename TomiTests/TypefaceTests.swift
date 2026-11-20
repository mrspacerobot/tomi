import CoreText
import Foundation
import Testing

@testable import Tomi

/// The bundled fonts really load. A font that is missing falls back to the system font without a word,
/// so every cut is asked for by name and must come back as itself.
@Suite struct TypefaceTests {
    @Test(arguments: Typeface.allCases)
    func theCutIsRegisteredWithTheSystem(typeface: Typeface) {
        let font = CTFontCreateWithName(typeface.fontName as CFString, 17, nil)
        #expect(CTFontCopyPostScriptName(font) as String == typeface.fontName)
    }

    @Test(arguments: TextStyle.allCases)
    func everyTextStyleHasRoomForItsLines(style: TextStyle) {
        #expect(style.metrics.size > 0)
        #expect(style.metrics.lineHeight >= style.metrics.size)
    }

    @Test(arguments: ["LilitaOne-OFL", "Nunito-OFL"])
    func theLicenceOfEachFamilyShipsInTheApp(name: String) throws {
        let url = try #require(Bundle.main.url(forResource: name, withExtension: "txt"))
        let text = try String(contentsOf: url, encoding: .utf8)
        #expect(text.contains("SIL Open Font License"))
    }

}
