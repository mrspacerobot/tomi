import Testing

@testable import TomiCore

@Suite struct SpokenSentencesTests {
    @Test func aLineBecomesOneSentenceEach() {
        let line = "Heat the pan. Add the butter! Is it foaming? Good."
        #expect(
            SpokenSentences.split(line) == ["Heat the pan.", "Add the butter!", "Is it foaming?", "Good."]
        )
    }

    @Test func aDecimalDoesNotEndASentence() {
        #expect(SpokenSentences.split("Cook for 2.5 minutes. Stir.") == ["Cook for 2.5 minutes.", "Stir."])
    }

    @Test func aLineWithoutAFullStopIsOneSentence() {
        #expect(SpokenSentences.split("Stir gently") == ["Stir gently"])
    }

    @Test func extraSpacesAndLineBreaksAreDropped() {
        #expect(SpokenSentences.split("  Stir.\n\n  Taste.  ") == ["Stir.", "Taste."])
    }

    @Test(arguments: ["", "   ", "\n"])
    func nothingToSayGivesNoSentences(line: String) {
        #expect(SpokenSentences.split(line).isEmpty)
    }

    @Test func anEllipsisEndsASentence() {
        #expect(SpokenSentences.split("Wait… Now flip it.") == ["Wait…", "Now flip it."])
    }
}
