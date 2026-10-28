/// The server's answer to one quiz pick. `isScored` is true for the first pick of a question in a cook, the one
/// that counts; a later pick only teaches. The explanation is kept only when the pick is right, so a wrong pick
/// never shows anything that could give the right choice away.
public struct QuizVerdict: Hashable, Decodable, Sendable {
    public let questionID: String
    public let isCorrect: Bool
    public let isScored: Bool
    public let explanation: String?

    enum CodingKeys: String, CodingKey {
        case questionID = "questionId"
        case isCorrect = "correct"
        case isScored = "scored"
        case explanation
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        questionID = try values.decode(String.self, forKey: .questionID)
        isCorrect = try values.decode(Bool.self, forKey: .isCorrect)
        isScored = try values.decode(Bool.self, forKey: .isScored)
        explanation = try Self.explanation(in: values, isCorrect: isCorrect)
    }

    private static func explanation(in values: KeyedDecodingContainer<CodingKeys>, isCorrect: Bool) throws -> String? {
        guard isCorrect else {
            return nil
        }
        return try values.decodeIfPresent(String.self, forKey: .explanation)
    }

    /// Whether this is the answer to that pick, and not to another question.
    public func answers(_ pick: QuizPick) -> Bool {
        questionID == pick.questionID
    }
}
