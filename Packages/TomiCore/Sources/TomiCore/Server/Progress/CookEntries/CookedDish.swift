/// What a cook entry cooked: a graph recipe in the graph version it came from,
/// or a bundled lesson, for the development logs already on phones. Exactly one of the two.
public enum CookedDish: Hashable, Codable, Sendable {
    case recipe(RecipeID, graphVersion: String)
    case lesson(LessonID)

    enum CodingKeys: String, CodingKey {
        case recipeID = "recipeId"
        case graphVersion
        case lessonID = "lessonId"
    }

    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        guard values.contains(.lessonID) else {
            let recipe = try values.decode(RecipeID.self, forKey: .recipeID)
            self = .recipe(recipe, graphVersion: try values.decode(String.self, forKey: .graphVersion))
            return
        }
        guard !values.contains(.recipeID), !values.contains(.graphVersion) else {
            throw DecodingError.dataCorruptedError(forKey: .lessonID, in: values, debugDescription: "Two dishes.")
        }
        self = .lesson(try values.decode(LessonID.self, forKey: .lessonID))
    }

    public func encode(to encoder: any Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .recipe(let recipe, let graphVersion):
            try values.encode(recipe, forKey: .recipeID)
            try values.encode(graphVersion, forKey: .graphVersion)
        case .lesson(let lesson):
            try values.encode(lesson, forKey: .lessonID)
        }
    }
}
