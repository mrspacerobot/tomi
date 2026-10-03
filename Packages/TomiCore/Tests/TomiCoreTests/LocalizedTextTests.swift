import Testing

@testable import TomiCore

@Suite struct LocalizedTextTests {
    let text = LocalizedText(["en": "Stocks", "fr": "Fonds", "pt-BR": "Caldos"])

    @Test func anExactLanguageMatchWins() {
        #expect(text.resolved(preferredLanguages: ["pt-BR", "fr"]) == "Caldos")
    }

    @Test func aRegionalLanguageFallsBackToItsBaseLanguage() {
        #expect(text.resolved(preferredLanguages: ["fr-CA"]) == "Fonds")
    }

    @Test func anyOtherLanguageFallsBackToEnglish() {
        #expect(text.resolved(preferredLanguages: ["ja-JP"]) == "Stocks")
    }

    @Test func blankEnglishCountsAsMissing() {
        #expect(LocalizedText(["en": "  "]).isMissingSourceText)
        #expect(!text.isMissingSourceText)
    }
}
