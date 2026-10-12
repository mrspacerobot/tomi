/// The body of `POST /v1/lessons/suggest`: the ingredients the cook confirmed, and the scan they came from.
public struct SpecialsRequest: Hashable, Codable, Sendable {
    public let ingredients: [OptionID]
    public let scanID: ScanID?

    /// The ingredients are sent sorted, so the same evening always sends the same request.
    public init(ingredients: Set<OptionID>, scanID: ScanID?) {
        self.ingredients = ingredients.sorted()
        self.scanID = scanID
    }

    enum CodingKeys: String, CodingKey {
        case ingredients
        case scanID = "scanId"
    }
}
