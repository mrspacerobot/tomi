/// One thing an ingredient is or holds that decides who may eat it. A closed list: the ingredient table may
/// only use these values in `contains`, and the avoid-list items and the diets are worked out from them.
/// The raw values are written in the library, so never rename or reuse one.
public enum IngredientFact: String, CaseIterable, Hashable, Codable, Sendable {
    /// The flesh of a land animal or bird, and anything made from it, such as a meat stock.
    case meat
    /// Pork is meat as well: `Ingredient.isMeat` is true without `meat` being written.
    case pork
    case fish
    case shellfish
    case dairy
    case egg
    /// Made by a living animal that is not harmed for it, such as honey. Fine for a vegetarian, not for a vegan.
    case animalProduct
    /// Taken from a killed animal without being its flesh: gelatin, animal rennet, the finings of a wine.
    /// Not fine for a vegetarian.
    case slaughterProduct
    case alcohol
    case nuts
    case gluten
    case soy
    case sesame

    /// The avoid-list item this fact triggers, or nil for a fact that only decides diets.
    public var avoidItem: AvoidItem? {
        switch self {
        case .meat, .animalProduct, .slaughterProduct: nil
        case .pork: .pork
        case .fish: .fish
        case .shellfish: .shellfish
        case .dairy: .dairy
        case .egg: .eggs
        case .alcohol: .alcohol
        case .nuts: .nuts
        case .gluten: .gluten
        case .soy: .soy
        case .sesame: .sesame
        }
    }

    /// The diets that still allow an ingredient with this fact.
    public var allowingDiets: Set<Diet> {
        switch self {
        case .meat, .pork, .slaughterProduct: [.everything]
        case .fish, .shellfish: [.everything, .pescatarian]
        case .dairy, .egg, .animalProduct: [.everything, .vegetarian, .pescatarian]
        case .alcohol, .nuts, .gluten, .soy, .sesame: [.everything, .vegetarian, .vegan, .pescatarian]
        }
    }
}
