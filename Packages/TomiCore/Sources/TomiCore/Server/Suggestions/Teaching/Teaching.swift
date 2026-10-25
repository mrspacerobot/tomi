/// Optional graph-authored teaching content attached to a checked recipe suggestion.
public struct Teaching: Hashable, Decodable, Sendable {
    public let graphVersion: String
    public let graphChannel: TeachingChannel
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
        self.init(metadata: metadata, content: content)
    }

    private init(metadata: TeachingMetadata, content: TeachingContent) {
        graphVersion = metadata.graphVersion
        graphChannel = metadata.graphChannel
        technique = content.technique
        introduction = content.introduction
        if metadata.isProduction {
            quiz = content.reviewedQuiz
        } else {
            quiz = content.quiz
        }
    }
}
