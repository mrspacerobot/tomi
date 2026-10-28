import Foundation

/// One cook's quiz: the cook entry the picks are recorded under, and the recipe and graph version it was taught
/// from. The entry id is made when cooking begins and later sent as the cook entry's id, so the server can tell
/// the score of the cook from the first pick of each question.
public struct QuizSitting: Hashable, Sendable {
    public let entryID: UUID
    public let recipeID: RecipeID
    public let graphVersion: String

    public init(entryID: UUID, recipeID: RecipeID, graphVersion: String) {
        self.entryID = entryID
        self.recipeID = recipeID
        self.graphVersion = graphVersion
    }
}
