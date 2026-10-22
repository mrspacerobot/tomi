/// One ingredient line of the recipe written for this cook: the food in use (the recipe's own or its stand-in),
/// the part of the dish it belongs to, how much, and the forms it is prepared in.
public struct AdaptedIngredient: Hashable, Decodable, Sendable {
    public let part: String
    public let food: NamedOption
    public let amount: RecipeAmount
    public let forms: [NamedOption]

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        part = try container.decode(String.self, forKey: .part)
        food = try NamedOption(from: decoder)
        amount = try container.decode(RecipeAmount.self, forKey: .amount)
        forms = try container.decode([NamedOption].self, forKey: .forms)
    }

    enum CodingKeys: String, CodingKey {
        case part, amount, forms
    }
}
