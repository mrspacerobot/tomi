/// Optional graph-authored teaching content attached to a checked recipe suggestion.
public struct Teaching: Hashable, Decodable, Sendable {
    public let graphVersion: String
    public let graphChannel: String
    public let technique: TeachingTechnique
    public let introduction: TeachingIntroduction
    public let quiz: [TeachingQuestion]?

    enum CodingKeys: String, CodingKey {
        case schemaVersion, graphVersion, graphChannel, language, technique, introduction, quiz
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let metadata = try TeachingMetadata(values: values)
        let content = try TeachingContent(values: values)
        try metadata.validate(content, in: values)
        graphVersion = metadata.graphVersion
        graphChannel = metadata.graphChannel
        technique = content.technique
        introduction = content.introduction
        quiz = metadata.isProduction ? content.reviewedQuiz : content.quiz
    }
}

private struct TeachingMetadata {
    let graphVersion: String
    let graphChannel: String
    var isProduction: Bool { graphChannel == "production" }

    init(values: KeyedDecodingContainer<Teaching.CodingKeys>) throws {
        let version = try values.decode(Int.self, forKey: .schemaVersion)
        let language = try values.decode(String.self, forKey: .language)
        try Self.validateSchema(version, language, in: values)
        graphVersion = try values.decode(String.self, forKey: .graphVersion)
        graphChannel = try values.decode(String.self, forKey: .graphChannel)
        guard !graphVersion.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw DecodingError.dataCorruptedError(
                forKey: .graphVersion,
                in: values,
                debugDescription: "Missing graph version."
            )
        }
    }

    private static func validateSchema(
        _ version: Int,
        _ language: String,
        in values: KeyedDecodingContainer<Teaching.CodingKeys>
    ) throws {
        guard version == 1, language == "en" else {
            throw DecodingError.dataCorruptedError(
                forKey: .schemaVersion,
                in: values,
                debugDescription: "Unsupported teaching."
            )
        }
    }

    func validate(_ content: TeachingContent, in values: KeyedDecodingContainer<Teaching.CodingKeys>) throws {
        try validateChannel(in: values)
        try validateTiers(content, in: values)
    }

    private func validateChannel(in values: KeyedDecodingContainer<Teaching.CodingKeys>) throws {
        guard graphChannel == "draft" || graphChannel == "production" else {
            throw DecodingError.dataCorruptedError(
                forKey: .graphChannel,
                in: values,
                debugDescription: "Unknown channel."
            )
        }
    }

    private func validateTiers(
        _ content: TeachingContent,
        in values: KeyedDecodingContainer<Teaching.CodingKeys>
    ) throws {
        guard !isProduction || content.isReviewed else {
            throw DecodingError.dataCorruptedError(
                forKey: .graphChannel,
                in: values,
                debugDescription: "Unreviewed production teaching."
            )
        }
    }
}

private struct TeachingContent {
    let technique: TeachingTechnique
    let introduction: TeachingIntroduction
    let quiz: [TeachingQuestion]?

    var isReviewed: Bool {
        technique.tier.isReviewed && introduction.tier.isReviewed
    }

    var reviewedQuiz: [TeachingQuestion]? {
        guard let quiz, !quiz.isEmpty, quiz.allSatisfy({ $0.tier.isReviewed }) else { return nil }
        return quiz
    }

    init(values: KeyedDecodingContainer<Teaching.CodingKeys>) throws {
        technique = try values.decode(TeachingTechnique.self, forKey: .technique)
        introduction = try values.decode(TeachingIntroduction.self, forKey: .introduction)
        let decodedQuiz = try? values.decodeIfPresent([TeachingQuestion].self, forKey: .quiz)
        quiz = Self.validQuiz(decodedQuiz ?? nil, technique: technique)
    }

    private static func validQuiz(_ questions: [TeachingQuestion]?, technique: TeachingTechnique) -> [TeachingQuestion]?
    {
        guard let questions, !questions.isEmpty else { return nil }
        let identifiers = questions.map(\.id)
        guard Set(identifiers).count == identifiers.count,
            questions.allSatisfy({ $0.id.hasPrefix("\(technique.id)/quiz/") })
        else { return nil }
        return questions
    }
}
