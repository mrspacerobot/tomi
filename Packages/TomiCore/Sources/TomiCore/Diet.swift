/// What the cook eats. A closed list: a lesson is offered only when its computed diet tags allow it.
/// The raw values are saved, so never rename or reuse one.
public enum Diet: String, CaseIterable, Hashable, Codable, Sendable {
    case everything
    case vegetarian
    case vegan
    case pescatarian
}
