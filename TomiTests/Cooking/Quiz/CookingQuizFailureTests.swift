import Foundation
import Testing
import TomiCore

@testable import Tomi

/// What the quiz does after a pick could not be checked: a lost connection may be tried again, a changed graph may
/// not, because the same pick would be checked against a quiz that no longer exists.
@MainActor
@Suite struct CookingQuizFailureTests {
    func server(_ failure: FakeQuizFailure) throws -> FakeTomiAPI {
        FakeTomiAPI(
            library: BundledLessonLibrary(),
            configuration: FakeTomiAPIConfiguration(
                guidedCooking: true,
                quiz: try FakeQuizFixture.quiz(),
                quizFailure: failure
            )
        )
    }

    func model(over server: FakeTomiAPI) async throws -> CookingQuizModel {
        let asked = try await server.suggestions(.init(ingredients: [], scanID: nil)).special
        let round = try #require(asked?.quiz(entryID: UUID()))
        return CookingQuizModel(round: round, api: server)
    }

    @Test func afterTheGraphChangedNoPickIsSentAgain() async throws {
        let server = try server(.graphChanged)
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
        let server = try server(.offline)
        let quiz = try await model(over: server)
        quiz.tick(0)
        await quiz.check()
        await quiz.check()
        #expect(await server.quizPicksReceived == 2)
    }
}
