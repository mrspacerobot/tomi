import Foundation
import Observation
import TomiCore

/// The quiz of one cook. It sends the ticked choice to the server and shows what the server says: right or wrong,
/// and the explanation once right. It holds no right choice and keeps no score; the server scores the first pick
/// of each question. Without the server there is no quiz, and the cook may carry on without it.
@MainActor
@Observable
final class CookingQuizModel {
    private(set) var round: QuizRound
    private(set) var isChecking = false
    private(set) var problem: CookingQuizProblem?
    /// How many picks the server has answered or failed to answer, so the screen can read out each new result.
    private(set) var results = 0
    private let api: any TomiAPI

    init(round: QuizRound, api: any TomiAPI) {
        self.round = round
        self.api = api
    }

    var canCheck: Bool {
        round.pick != nil && !isChecking && problem != .graphChanged
    }

    func tick(_ choice: Int) {
        guard !isChecking else { return }
        round.tick(choice)
    }

    func check() async {
        guard canCheck, let pick = round.pick else { return }
        isChecking = true
        defer { finishCheck() }
        do {
            let verdict = try await api.answerQuiz(pick)
            problem = nil
            round.mark(verdict, for: pick)
        } catch {
            problem = CookingQuizProblem(error)
        }
    }

    private func finishCheck() {
        isChecking = false
        results += 1
    }

    /// What the screen says under the choices: the problem, else the server's word on the last pick.
    var outcome: CookingQuizOutcome? {
        if let problem {
            return .problem(problem)
        }
        if round.isAnsweredRight {
            return .right(round.explanation)
        }
        if round.ruledOut.isEmpty {
            return nil
        }
        return .wrong
    }

    func advance() {
        round.advance()
    }
}
