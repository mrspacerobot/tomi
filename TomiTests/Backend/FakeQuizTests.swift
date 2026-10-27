import Foundation
import Testing
import TomiCore

@testable import Tomi

/// The fake server marks picks from the invented quiz it was handed, as the real one does from its graph.
@Suite struct FakeQuizTests {
    let sitting = QuizSitting(entryID: UUID(), recipeID: "recipe/fake", graphVersion: "fake")

    func api(quiz: FakeQuiz?, failure: FakeQuizFailure? = nil) -> FakeTomiAPI {
        FakeTomiAPI(
            library: BundledLessonLibrary(),
            configuration: FakeTomiAPIConfiguration(guidedCooking: true, quiz: quiz, quizFailure: failure)
        )
    }

    func pick(_ choice: Int, of question: String = FakeQuizFixture.spoon) -> QuizPick {
        QuizPick(sitting: sitting, questionID: question, choice: choice)
    }

    @Test func theRightChoiceIsRightWithItsExplanation() async throws {
        let verdict = try await api(quiz: try FakeQuizFixture.quiz()).answerQuiz(pick(0))
        #expect(verdict.isCorrect)
        #expect(verdict.isScored)
        #expect(verdict.explanation == "In the test kitchen Tomi stirs with a wooden spoon.")
    }

    @Test func aWrongChoiceIsWrongWithoutAnExplanation() async throws {
        let verdict = try await api(quiz: try FakeQuizFixture.quiz()).answerQuiz(pick(2))
        #expect(!verdict.isCorrect)
        #expect(verdict.explanation == nil)
    }

    @Test func onlyTheFirstPickOfAQuestionIsScored() async throws {
        let fake = api(quiz: try FakeQuizFixture.quiz())
        let first = try await fake.answerQuiz(pick(1))
        let retry = try await fake.answerQuiz(pick(0))
        let sameAgain = try await fake.answerQuiz(pick(1))
        #expect([first.isScored, retry.isScored, sameAgain.isScored] == [true, false, true])
        #expect(retry.isCorrect)
    }

    @Test func offlineEveryPickIsUnreachable() async throws {
        let fake = api(quiz: try FakeQuizFixture.quiz(), failure: .offline)
        await #expect(throws: BackendError.unreachable) {
            try await fake.answerQuiz(pick(0))
        }
    }

    @Test(arguments: [(FakeQuizFixture.spoon, 3), ("technique/scramble/quiz/unknown", 0)])
    func aPickTheQuizDoesNotHaveIsAnInvalidRequest(question: String, choice: Int) async throws {
        let fake = api(quiz: try FakeQuizFixture.quiz())
        await #expect {
            try await fake.answerQuiz(pick(choice, of: question))
        } throws: { error in
            (error as? BackendError)?.code == .invalidRequest
        }
    }

    @Test func theGuidedSuggestionAsksTheInventedQuestionsWithoutTheirAnswers() async throws {
        let response = try await api(quiz: try FakeQuizFixture.quiz()).suggestions(.init(ingredients: [], scanID: nil))
        let quiz = try #require(response.special?.teaching?.quiz)
        #expect(quiz.map(\.id) == [FakeQuizFixture.spoon, FakeQuizFixture.bell])
        #expect(quiz.first?.choices == ["A wooden spoon", "A whisk", "A ladle"])
    }

    @Test func withoutAQuizTheGuidedSuggestionHasNone() async throws {
        let response = try await api(quiz: nil).suggestions(.init(ingredients: [], scanID: nil))
        #expect(response.special?.teaching != nil)
        #expect(response.special?.teaching?.quiz == nil)
    }

    @Test func aQuizFixtureIsReadFromItsLaunchArgument() throws {
        let options = BackendLaunchOptions(arguments: ["--fake-backend", "--fake-quiz", try FakeQuizFixture.base64()])
        #expect(options.quiz.fixture == (try FakeQuizFixture.text()))
        #expect(!options.quiz.isOffline)
        #expect(BackendLaunchOptions(arguments: ["--fake-quiz-offline"]).quiz.isOffline)
        #expect(BackendLaunchOptions(arguments: ["--fake-quiz-graph-changed"]).quiz.isGraphChanged)
        #expect(!options.quiz.isGraphChanged)
        #expect(BackendLaunchOptions(arguments: ["--fake-quiz"]).quiz.fixture == nil)
        #expect(BackendLaunchOptions(arguments: ["--fake-quiz", "{not base64}"]).quiz.fixture == nil)
    }
}

/// The launch path the UI tests take: the quiz handed over by argument reaches tonight's guided suggestion.
@MainActor
@Suite struct FakeQuizLaunchTests {
    @Test func theLaunchArgumentGivesTheGuidedSuggestionTheInventedQuiz() async throws {
        let arguments = ["--fake-backend", "--fake-guided-cooking", "--fake-quiz", try FakeQuizFixture.base64()]
        let services = try #require(
            AppServices.forLaunch(BackendLaunchOptions(arguments: arguments), store: InMemoryProgressStore())
        )
        let special = try await services.api.suggestions(.init(ingredients: [], scanID: nil)).special
        #expect(special?.teaching?.quiz?.map(\.id) == [FakeQuizFixture.spoon, FakeQuizFixture.bell])
    }
}
