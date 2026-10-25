/// A stable graph question and its answer details.
public struct TeachingQuestion: Hashable, Decodable, Sendable {
    public let id: String
    public let question: String
    public let choices: [String]
    public let answerIndex: Int
    public let explanation: String
    public let tier: TeachingTier

    enum CodingKeys: String, CodingKey { case id, question, choices, answerIndex, explanation, tier }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        question = try values.decode(String.self, forKey: .question)
        choices = try values.decode([String].self, forKey: .choices)
        answerIndex = try values.decode(Int.self, forKey: .answerIndex)
        explanation = try values.decode(String.self, forKey: .explanation)
        tier = try values.decode(TeachingTier.self, forKey: .tier)
        try validate(in: values)
    }

    private func validate(in values: KeyedDecodingContainer<CodingKeys>) throws {
        guard id.contains("/quiz/"), !question.isEmpty, choices.count >= 2,
            choices.allSatisfy({ !$0.isEmpty }), choices.indices.contains(answerIndex), !explanation.isEmpty
        else {
            throw DecodingError.dataCorruptedError(forKey: .id, in: values, debugDescription: "Invalid question.")
        }
    }
}
