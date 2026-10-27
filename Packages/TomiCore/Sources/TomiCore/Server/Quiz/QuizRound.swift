/// Where a cook is in the quiz of one cook: the question asked, the choice ticked, the picks the server said were
/// wrong, and its explanation once a pick is right. The round never knows the right choice and keeps no score: the
/// server scores the first pick of each question. A wrong pick is ruled out and the cook tries again; only a right
/// one lets the cook move on.
public struct QuizRound: Hashable, Sendable {
    public let sitting: QuizSitting
    public let questions: [TeachingQuestion]
    private var index = 0
    public private(set) var ticked: Int?
    public private(set) var ruledOut: Set<Int> = []
    public private(set) var isAnsweredRight = false
    public private(set) var explanation: String?
    public private(set) var isFinished = false

    /// Nil for a quiz with no questions: there is nothing to ask.
    public init?(sitting: QuizSitting, questions: [TeachingQuestion]) {
        guard !questions.isEmpty else { return nil }
        self.sitting = sitting
        self.questions = questions
    }

    public var current: TeachingQuestion { questions[index] }

    /// The place in the quiz, counted from one for the cook.
    public var position: Int { index + 1 }

    public var count: Int { questions.count }

    public var isLast: Bool { index == questions.count - 1 }

    /// The pick to send: the ticked choice, until the server has said the question is answered right.
    public var pick: QuizPick? {
        guard let ticked, !isAnsweredRight, !isFinished else { return nil }
        return QuizPick(sitting: sitting, questionID: current.id, choice: ticked)
    }

    /// Ticks a choice of the question, unless it was ruled out, is not one of its choices, or the question is done.
    public mutating func tick(_ choice: Int) {
        guard current.choices.indices.contains(choice), !ruledOut.contains(choice), !isAnsweredRight else { return }
        ticked = choice
    }

    /// Takes the server's word on a pick. A verdict for another question, or for a pick that is no longer the one
    /// ticked, changes nothing.
    public mutating func mark(_ verdict: QuizVerdict, for sent: QuizPick) {
        guard sent == pick, verdict.answers(sent) else { return }
        if verdict.isCorrect {
            isAnsweredRight = true
            explanation = verdict.explanation
            return
        }
        ruledOut.insert(sent.choice)
        ticked = nil
    }

    /// On to the next question once this one is answered right, or to the end after the last.
    public mutating func advance() {
        guard isAnsweredRight else { return }
        if isLast {
            isFinished = true
            return
        }
        self = QuizRound(sitting: sitting, questions: questions, index: index + 1)
    }

    private init(sitting: QuizSitting, questions: [TeachingQuestion], index: Int) {
        self.sitting = sitting
        self.questions = questions
        self.index = index
    }
}
