/// The recipe the server wrote for this cook, with every swap made and every left-out part gone, and checked
/// again against their diet and avoid list. The cook reads and follows this one; the app changes nothing in it.
/// Every list is required: a list that is missing must never read as an empty one.
public struct AdaptedRecipe: Hashable, Decodable, Sendable {
    public let yields: RecipeAmount
    public let ingredients: [AdaptedIngredient]
    public let steps: [AdaptedStep]
}
