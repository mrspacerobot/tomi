/// Every list the cook picks from, as `GET /v1/options` sends it, in the language the app asked for.
/// Onboarding and settings are built from these lists alone: the app holds no diet, avoid item, cuisine,
/// equipment or ingredient of its own.
public struct LibraryOptions: Hashable, Codable, Sendable {
    public var libraryVersion = 0
    public var diets: [DescribedOption] = []
    public var avoidItems: [NamedOption] = []
    public var cuisines: [NamedOption] = []
    public var equipment: [EquipmentOption] = []
    public var experience: [DescribedOption] = []
    public var units: [DescribedOption] = []
    /// Every ingredient the server knows, for the cupboard question.
    public var ingredients: [NamedOption] = []
    public var courses: [OptionCourse] = []

    public init() {}

    /// The kitchen the server assumes until the cook answers: every piece marked as assumed.
    public var assumedEquipment: Set<OptionID> {
        Set(equipment.filter(\.assumed).map(\.id))
    }
}
