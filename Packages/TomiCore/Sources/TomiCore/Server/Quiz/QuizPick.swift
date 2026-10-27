import Foundation

/// The body of `POST /v1/quiz-answers`: the choice the cook picked for one question, by its index from 0.
/// It carries no result of its own; the server alone says whether the pick is right.
public struct QuizPick: Hashable, Encodable, Sendable {
    public let sitting: QuizSitting
    public let questionID: String
    public let choice: Int

    public init(sitting: QuizSitting, questionID: String, choice: Int) {
        self.sitting = sitting
        self.questionID = questionID
        self.choice = choice
    }

    enum CodingKeys: String, CodingKey {
        case entryID = "entryId"
        case recipeID = "recipeId"
        case graphVersion
        case questionID = "questionId"
        case choice
    }

    /// The entry id goes in lower case, as the server writes it.
    public func encode(to encoder: any Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try values.encode(sitting.entryID.uuidString.lowercased(), forKey: .entryID)
        try values.encode(sitting.recipeID, forKey: .recipeID)
        try values.encode(sitting.graphVersion, forKey: .graphVersion)
        try values.encode(questionID, forKey: .questionID)
        try values.encode(choice, forKey: .choice)
    }
}
