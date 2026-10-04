/// One dish that teaches one level of one technique.
/// It is content, not code: one file per lesson in the lesson library, read with `decode(from:catalog:table:)`.
/// Diets and avoid items are not fields: `tags(in:)` works them out from the ingredient table.
public struct Lesson: Identifiable, Hashable, Codable, Sendable {
    /// The lesson layout this build understands. Bump it, and the validator, when the layout changes.
    public static let supportedSchemaVersion = 1

    public var schemaVersion: Int
    public var id: LessonID
    /// Counts from 1 and goes up each time the lesson is corrected, so a cook log can say which text was cooked.
    public var revision: Int
    public var skill: SkillID
    /// The level of the skill this lesson teaches, counting from 1.
    public var level: Int
    public var cuisine: CuisineID
    public var title: LocalizedText
    /// How long the whole dish takes, from the first step to the plate.
    public var minutes: Int
    /// Why Tomi serves this dish now.
    public var whyThis: LocalizedText
    /// The idea behind the technique, in a few sentences.
    public var concept: LocalizedText
    public var ingredients: [LessonIngredient]
    public var equipment: Set<EquipmentID>
    /// The dish's main food as the file writes it. It is kept as written, so that a name outside the closed list
    /// reaches the validator and is reported with its lesson, instead of failing somewhere in decoding.
    public var mainName: String
    public var steps: [LessonStep]
    public var quiz: LessonQuiz
    public var swaps: [LessonSwap]

    /// The names of the fields in the file. A file with any other field is rejected.
    enum CodingKeys: String, CodingKey {
        case schemaVersion
        case id
        case revision
        case skill
        case level
        case cuisine
        case title
        case minutes
        case whyThis
        case concept
        case ingredients
        case equipment
        case mainName = "main"
        case steps
        case quiz
        case swaps
    }
}
