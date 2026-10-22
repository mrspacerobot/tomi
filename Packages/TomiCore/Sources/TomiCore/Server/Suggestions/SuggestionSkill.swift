/// The technique a suggestion teaches, with its name in the cook's language.
public struct SuggestionSkill: Hashable, Codable, Sendable {
    public let id: SkillID
    public let name: String

    public init(id: SkillID, name: String) {
        self.id = id
        self.name = name
    }
}
