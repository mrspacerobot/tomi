import Foundation
import Testing

@testable import TomiCore

/// One question at a time: a ticked choice is sent, a wrong pick is ruled out and tried again, and only a right
/// one moves the cook on. The round keeps no score and never knows the right choice before the server says it.
@Suite struct QuizRoundTests {
    @Test func aRoundBeginsAtTheFirstQuestionWithNothingTicked() throws {
        let round = try QuizRoundSample.round()
        #expect(round.current.id == QuizRoundSample.spoon)
        #expect(round.position == 1)
        #expect(round.count == 2)
        #expect(round.ticked == nil)
        #expect(round.pick == nil)
    }

    @Test func aTickedChoiceIsSentUnderTheSitting() throws {
        var round = try QuizRoundSample.round()
        round.tick(1)
        #expect(round.pick == QuizPick(sitting: QuizJSON.sitting, questionID: QuizRoundSample.spoon, choice: 1))
    }

    @Test(arguments: [-1, 3])
    func aChoiceTheQuestionDoesNotHaveIsNeverTicked(choice: Int) throws {
        var round = try QuizRoundSample.round()
        round.tick(choice)
        #expect(round.ticked == nil)
    }

    @Test func aWrongPickIsRuledOutAndCannotBeTickedAgain() throws {
        var round = try QuizRoundSample.round()
        round.tick(1)
        round.mark(try QuizRoundSample.verdict(QuizRoundSample.spoon, correct: false), for: try #require(round.pick))
        #expect(round.ruledOut == [1])
        #expect(round.ticked == nil)
        #expect(!round.isAnsweredRight)
        round.tick(1)
        #expect(round.ticked == nil)
    }

    @Test func aRightPickKeepsTheExplanationAndNothingElseCanBeTicked() throws {
        var round = try QuizRoundSample.round()
        round.tick(0)
        round.mark(try QuizRoundSample.verdict(QuizRoundSample.spoon, correct: true), for: try #require(round.pick))
        #expect(round.isAnsweredRight)
        #expect(round.explanation == "Invented explanation.")
        round.tick(2)
        #expect(round.ticked == 0)
        #expect(round.pick == nil)
    }

    @Test func theRoundMovesOnOnlyOnceRight() throws {
        var round = try QuizRoundSample.round()
        round.advance()
        #expect(round.position == 1)
        round.tick(0)
        round.mark(try QuizRoundSample.verdict(QuizRoundSample.spoon, correct: true), for: try #require(round.pick))
        round.advance()
        #expect(round.current.id == QuizRoundSample.bell)
        #expect(round.ticked == nil)
        #expect(round.explanation == nil)
        #expect(!round.isFinished)
    }

    @Test func afterTheLastQuestionIsRightTheRoundIsFinished() throws {
        var round = try QuizRoundSample.round()
        for question in [QuizRoundSample.spoon, QuizRoundSample.bell] {
            round.tick(0)
            round.mark(try QuizRoundSample.verdict(question, correct: true), for: try #require(round.pick))
            round.advance()
        }
        #expect(round.isFinished)
        #expect(round.pick == nil)
    }

    @Test func noQuestionsIsNoRound() {
        #expect(QuizRound(sitting: QuizJSON.sitting, questions: []) == nil)
    }
}
