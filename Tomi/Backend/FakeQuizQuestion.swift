/// One invented question of the fake quiz, with the right choice the real server keeps to itself.
nonisolated struct FakeQuizQuestion: Decodable, Equatable, Sendable {
    let id: String
    let question: String
    let choices: [String]
    let tier: String
    let rightChoice: Int
    let explanation: String

    /// The question as a suggestion carries it: what the cook reads and nothing that says which choice is right.
    var teachingQuestion: [String: Any] {
        ["id": id, "question": question, "choices": choices, "tier": tier]
    }

    func offers(_ choice: Int) -> Bool {
        choices.indices.contains(choice)
    }
}
