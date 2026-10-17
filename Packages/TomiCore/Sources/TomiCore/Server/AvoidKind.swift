/// The group of an avoid item. An unknown or missing value is an allergen: the group a cook looks at first.
public enum AvoidKind: String, Hashable, Codable, Sendable {
    case allergen
    case choice

    public init(from decoder: any Decoder) throws {
        let value = try decoder.singleValueContainer().decode(String.self)
        self = AvoidKind(rawValue: value) ?? .allergen
    }
}
