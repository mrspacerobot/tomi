/// A stable graph question and its choices. The right choice never reaches the app: the server holds it.
public struct TeachingQuestion: Hashable, Decodable, Sendable {
    public let id: String
    public let question: String
    public let choices: [String]
    public let tier: TeachingTier

    enum CodingKeys: String, CodingKey { case id, question, choices, tier }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        question = try values.decode(String.self, forKey: .question)
        choices = try values.decode([String].self, forKey: .choices)
        tier = try values.decode(TeachingTier.self, forKey: .tier)
        try validate(in: values)
    }

    private func validate(in values: KeyedDecodingContainer<CodingKeys>) throws {
        let distinctChoices = Set(choices)
        guard isValidTeachingQuestionID(id), !question.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
            choices.count >= 2, distinctChoices.count == choices.count,
            choices.allSatisfy({ !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty })
        else {
            throw DecodingError.dataCorruptedError(forKey: .id, in: values, debugDescription: "Invalid question.")
        }
    }
}
