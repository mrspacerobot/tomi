/// One piece of equipment on the kitchen question, as the server sends it.
public struct EquipmentOption: Identifiable, Hashable, Codable, Sendable {
    public let id: OptionID
    public let name: String
    public let summary: String
    /// Whether the server takes a kitchen to have it until the cook answers. The kitchen question starts ticked here.
    public let assumed: Bool

    public init(id: OptionID, name: String, summary: String, assumed: Bool) {
        self.id = id
        self.name = name
        self.summary = summary
        self.assumed = assumed
    }
}
