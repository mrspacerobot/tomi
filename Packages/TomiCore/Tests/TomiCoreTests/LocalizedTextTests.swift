import Testing

@testable import TomiCore

@Suite struct LocalizedTextTests {
    let text = LocalizedText(["en": "Stocks", "fr": "Fonds", "pt-BR": "Caldos"])

    @Test func anExactLanguageMatchWins() {
        #expect(text.resolved(preferredLanguages: ["pt-BR", "fr"]) == "Caldos")
    }

    @Test(arguments: ["fr-CA", "fr_CA"])
    func aRegionalLanguageFallsBackToItsBaseLanguage(language: String) {
        #expect(text.resolved(preferredLanguages: [language]) == "Fonds")
    }

    @Test func theFirstLanguageWithTextWins() {
        #expect(text.resolved(preferredLanguages: ["ja-JP", "fr", "pt-BR"]) == "Fonds")
    }

    @Test(arguments: [["ja-JP"], []])
    func anyOtherLanguageFallsBackToEnglish(languages: [String]) {
        #expect(text.resolved(preferredLanguages: languages) == "Stocks")
    }

    @Test func textWithNoMatchAndNoEnglishIsEmpty() {
        #expect(LocalizedText(["fr": "Fonds"]).resolved(preferredLanguages: ["ja"]) == "")
    }

    @Test(arguments: [LocalizedText(["en": "  "]), LocalizedText(["en": ""]), LocalizedText(["fr": "Fonds"])])
    func blankOrAbsentEnglishCountsAsMissing(text: LocalizedText) {
        #expect(text.isMissingSourceText)
    }

    @Test func englishTextIsNotMissing() {
        #expect(!text.isMissingSourceText)
    }
}
