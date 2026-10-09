/// A technique of the menu as the server sends it with the options.
public struct OptionSkill: Identifiable, Hashable, Codable, Sendable {
    public let id: SkillID
    public let name: String
    public var summary = ""
    public var prerequisites: [SkillID] = []
    public var levels: [NamedLevel] = []

    public init(id: SkillID, name: String) {
        self.id = id
        self.name = name
    }
}
