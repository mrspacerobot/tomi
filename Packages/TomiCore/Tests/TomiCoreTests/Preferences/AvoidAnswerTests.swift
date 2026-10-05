import Testing

@testable import TomiCore

/// The "anything to avoid?" question: ticks, and "None of these" as a deliberate answer of its own.
@Suite struct AvoidAnswerTests {
    @Test func aNewAnswerIsNotAnsweredYet() {
        let answer = AvoidAnswer()

        #expect(!answer.isAnswered)
        #expect(answer.avoided.isEmpty)
    }

    @Test func tickingAnItemAnswersAndAvoidsIt() {
        var answer = AvoidAnswer()

        answer.tap("nuts")

        #expect(answer.isAnswered)
        #expect(answer.avoided == ["nuts"])
        #expect(answer.isTicked("nuts"))
    }

    @Test func tickingAnItemAgainUnticksItAndTheQuestionIsOpenAgain() {
        var answer = AvoidAnswer()

        answer.tap("nuts")
        answer.tap("nuts")

        #expect(!answer.isAnswered)
        #expect(answer.avoided.isEmpty)
    }

    @Test func noneOfTheseAnswersWithNothingToAvoid() {
        var answer = AvoidAnswer()

        answer.tapNone()

        #expect(answer.isAnswered)
        #expect(answer.isNoneTicked)
        #expect(answer.avoided.isEmpty)
    }

    @Test func noneOfTheseClearsEveryTick() {
        var answer = AvoidAnswer()
        answer.tap("nuts")
        answer.tap("dairy")

        answer.tapNone()

        #expect(answer.avoided.isEmpty)
        #expect(!answer.isTicked("nuts"))
        #expect(answer.isNoneTicked)
    }

    @Test func tickingAnItemClearsNoneOfThese() {
        var answer = AvoidAnswer()
        answer.tapNone()

        answer.tap("nuts")

        #expect(!answer.isNoneTicked)
        #expect(answer.avoided == ["nuts"])
    }

    @Test func tappingNoneOfTheseAgainOpensTheQuestionAgain() {
        var answer = AvoidAnswer()

        answer.tapNone()
        answer.tapNone()

        #expect(!answer.isAnswered)
        #expect(!answer.isNoneTicked)
    }

    /// Saved preferences cannot tell "none" from "not asked yet", so an empty list reads as not answered.
    @Test func savedItemsAreTickedAndAnEmptySavedListIsNotAnswered() {
        #expect(AvoidAnswer(saved: ["nuts", "soy"]).avoided == ["nuts", "soy"])
        #expect(AvoidAnswer(saved: ["nuts"]).isAnswered)
        #expect(!AvoidAnswer(saved: []).isAnswered)
    }

    /// An item an older table lists and this one does not must survive being edited, never be dropped.
    @Test func aSavedItemIsKeptWhenAnotherIsTicked() {
        var answer = AvoidAnswer(saved: ["from-a-newer-app"])

        answer.tap("nuts")

        #expect(answer.avoided == ["from-a-newer-app", "nuts"])
    }
}
