/// One dish the server offers for tonight: a lesson of the library, adapted with the swaps it lists.
/// Everything about who may eat it was decided by the server; `checked` says for which diet and avoid list.
public struct Offer: Identifiable, Hashable, Codable, Sendable {
    public let lessonID: LessonID
    /// The revision of the lesson the server offered. The player opens only this revision.
    public let revision: Int
    public let title: String
    public var minutes = 0
    public var skill = OfferSkill(id: SkillID(rawValue: ""), name: "")
    public var level = NamedLevel(number: SkillLevel.firstNumber, name: "")
    /// The dish's ingredients after the swaps, with their names.
    public var ingredients: [NamedOption] = []
    public var swaps: [OfferSwap] = []
    /// Ingredients of the dish the cook did not say they have.
    public var missing: [NamedOption] = []
    /// One line from the server's model about why this dish, or nil when it ranked without one.
    public var reason: String?
    public var checked = CheckedRestrictions(diet: nil, avoid: [])

    public init(lessonID: LessonID, revision: Int, title: String) {
        self.lessonID = lessonID
        self.revision = revision
        self.title = title
    }

    public var id: LessonID {
        lessonID
    }

    enum CodingKeys: String, CodingKey {
        case lessonID = "lessonId"
        case revision, title, minutes, skill, level, ingredients, swaps, missing, reason, checked
    }
}
