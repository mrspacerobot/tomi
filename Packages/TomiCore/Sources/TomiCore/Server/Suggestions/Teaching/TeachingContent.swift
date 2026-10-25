/// Decodes graph teaching content and independently filters optional quiz payloads.
struct TeachingContent {
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
            questions.allSatisfy({
                isValidTeachingQuestionID($0.id) && $0.id.hasPrefix("\(technique.id)/quiz/")
            })
        else { return nil }
        return questions
    }
}
