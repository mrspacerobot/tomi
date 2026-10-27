/// What a cook entry cooked: a graph recipe in the graph version it came from. The server takes nothing else, so a
/// cook of a bundled lesson has no dish and cannot be sent.
public struct CookedDish: Hashable, Codable, Sendable {
    public let recipe: RecipeID
    public let graphVersion: String

    public init(recipe: RecipeID, graphVersion: String) {
        self.recipe = recipe
        self.graphVersion = graphVersion
    }

    enum CodingKeys: String, CodingKey {
        case recipe = "recipeId"
        case graphVersion
    }

    /// A dish with any other field is refused, as the server refuses it, so a lesson id is never read as a dish.
    public init(from decoder: any Decoder) throws {
        let all = try decoder.container(keyedBy: AnyCodingKey.self)
        guard all.allKeys.allSatisfy({ CodingKeys(stringValue: $0.stringValue) != nil }) else {
            throw DecodingError.dataCorrupted(
                .init(codingPath: decoder.codingPath, debugDescription: "Not a graph recipe.")
            )
        }
        let values = try decoder.container(keyedBy: CodingKeys.self)
        recipe = try values.decode(RecipeID.self, forKey: .recipe)
        graphVersion = try values.decode(String.self, forKey: .graphVersion)
    }
}
