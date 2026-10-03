/// Something the cook does not eat, whether for an allergy, a belief or taste. A closed list:
/// the ingredient table tags every ingredient with these same values.
/// The raw values are saved, so never rename or reuse one.
public enum AvoidItem: String, CaseIterable, Hashable, Codable, Sendable {
    case nuts
    case dairy
    case gluten
    case eggs
    case shellfish
    case fish
    case soy
    case sesame
    case pork
    case alcohol
}
