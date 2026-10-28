import Testing

@testable import TomiCore

/// A verdict counts only for the pick it answers: one for another question, or for a choice no longer ticked,
/// changes nothing, so a late answer can never mark the wrong choice.
@Suite struct QuizRoundStaleVerdictTests {
    @Test func aVerdictForAnotherQuestionChangesNothing() throws {
        var round = try QuizRoundSample.round()
        round.tick(0)
        let pick = try #require(round.pick)
        round.mark(try QuizRoundSample.verdict(QuizRoundSample.bell, correct: true), for: pick)
        #expect(!round.isAnsweredRight)
        #expect(round.ticked == 0)
    }

    @Test func aVerdictForAnOlderPickChangesNothing() throws {
        var round = try QuizRoundSample.round()
        round.tick(1)
        let older = try #require(round.pick)
        round.tick(2)
        round.mark(try QuizRoundSample.verdict(QuizRoundSample.spoon, correct: false), for: older)
        #expect(round.ruledOut.isEmpty)
        #expect(round.ticked == 2)
    }
}
