import Foundation

/// One thing a cook may avoid, as the server lists it. The kind only decides which group the app shows it under.
public struct AvoidOption: Identifiable, Hashable, Codable, Sendable {
    public let id: OptionID
    public let name: String
    public let kind: AvoidKind

    public init(id: OptionID, name: String, kind: AvoidKind) {
        self.id = id
        self.name = name
        self.kind = kind
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case kind
    }

    /// An older server sends no kind. A kind this app does not know is read as an allergen too.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(OptionID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        let kind = try? container.decodeIfPresent(AvoidKind.self, forKey: .kind)
        self.kind = kind ?? .allergen
    }
}
