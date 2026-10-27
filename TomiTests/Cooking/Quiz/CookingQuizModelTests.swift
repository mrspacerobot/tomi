import Foundation
import Testing
import TomiCore

@testable import Tomi

/// The quiz screen's decisions against the fake server and its invented quiz. The model sends what the cook ticked,
/// shows what the server says, and holds no right choice and no score of its own.
@MainActor
@Suite struct CookingQuizModelTests {
    func api(offline: Bool = false, graphChanged: Bool = false, quiz: FakeQuiz? = nil) throws -> FakeTomiAPI {
        let invented = try quiz ?? FakeQuizFixture.quiz()
        return FakeTomiAPI(
            library: BundledLessonLibrary(),
            configuration: FakeTomiAPIConfiguration(
                guidedCooking: true,
                quiz: invented,
                quizOffline: offline,
                quizGraphChanged: graphChanged
            )
        )
    }

    /// The invented quiz as tonight's guided suggestion asks it, answered by a fake server marking from `quiz`.
    func model(offline: Bool = false, quiz: FakeQuiz? = nil) async throws -> CookingQuizModel {
        try await model(over: try api(offline: offline, quiz: quiz))
    }

    func model(over server: FakeTomiAPI) async throws -> CookingQuizModel {
        let asked = try await api().suggestions(.init(ingredients: [], scanID: nil)).special
        let round = try #require(asked?.quiz(entryID: UUID()))
        return CookingQuizModel(round: round, api: server)
    }

    @Test func nothingIsCheckedBeforeAChoiceIsTicked() async throws {
        let quiz = try await model()
        #expect(!quiz.canCheck)
        await quiz.check()
        #expect(quiz.round.ruledOut.isEmpty)
        #expect(!quiz.round.isAnsweredRight)
    }

    @Test func aWrongPickIsRuledOutWithoutAnExplanation() async throws {
        let quiz = try await model()
        quiz.tick(1)
        await quiz.check()
        #expect(quiz.round.ruledOut == [1])
        #expect(quiz.round.explanation == nil)
        #expect(quiz.problem == nil)
    }

    @Test func aRightPickAfterAWrongOneShowsTheServersExplanation() async throws {
        let quiz = try await model()
        quiz.tick(2)
        await quiz.check()
        quiz.tick(0)
        await quiz.check()
        #expect(quiz.round.isAnsweredRight)
        #expect(quiz.round.explanation == "In the test kitchen Tomi stirs with a wooden spoon.")
    }

    @Test func everyQuestionAnsweredRightReachesTheEnd() async throws {
        let quiz = try await model()
        for choice in [0, 1] {
            quiz.tick(choice)
            await quiz.check()
            quiz.advance()
        }
        #expect(quiz.round.isFinished)
    }

    @Test func offlineTheQuizSaysItNeedsAConnectionAndKeepsTheTick() async throws {
        let quiz = try await model(offline: true)
        quiz.tick(0)
        await quiz.check()
        #expect(quiz.problem == .offline)
        #expect(quiz.round.ticked == 0)
        #expect(quiz.canCheck)
    }

    @Test func aChangedGraphCannotBeTriedAgain() {
        let changed = BackendError.server(status: 409, APIError(codeName: "graph_version_changed", message: "New."))
        #expect(CookingQuizProblem(changed) == .graphChanged)
        #expect(!CookingQuizProblem.graphChanged.canTryAgain)
        #expect(CookingQuizProblem.offline.canTryAgain)
    }

    /// The graph moved on, so the same pick would be checked against a quiz that no longer exists.
    @Test func afterTheGraphChangedNoPickIsSentAgain() async throws {
        let server = try api(graphChanged: true)
        let quiz = try await model(over: server)
        quiz.tick(0)
        await quiz.check()
        #expect(quiz.problem == .graphChanged)
        #expect(!quiz.canCheck)
        await quiz.check()
        #expect(await server.quizPicksReceived == 1)
        #expect(!quiz.round.isAnsweredRight)
    }

    @Test func anOfflinePickIsSentAgainWhenTheCookTriesAgain() async throws {
        let server = try api(offline: true)
        let quiz = try await model(over: server)
        quiz.tick(0)
        await quiz.check()
        await quiz.check()
        #expect(await server.quizPicksReceived == 2)
    }

    @Test func anyOtherFailureIsNotReadAsAnAnswer() async throws {
        let unknown = try FakeQuiz.decode(from: #"{"questions": []}"#)
        let quiz = try await model(quiz: unknown)
        quiz.tick(0)
        await quiz.check()
        #expect(quiz.problem == .failed)
        #expect(quiz.round.ruledOut.isEmpty)
        #expect(!quiz.round.isAnsweredRight)
    }
}
