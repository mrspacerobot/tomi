/// One everyday ingredient on the cupboard question, as the server sends it.
public struct StapleOption: Identifiable, Hashable, Codable, Sendable {
    public let id: OptionID
    public let name: String
    /// Whether the server counts it as at home until the cook answers. The cupboard question starts ticked here.
    public let assumed: Bool

    public init(id: OptionID, name: String, assumed: Bool) {
        self.id = id
        self.name = name
        self.assumed = assumed
    }
}
