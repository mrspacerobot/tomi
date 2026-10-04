/// One step deeper into a technique, such as "Blond roux for velouté" as level 2 of roux.
/// Lessons name a skill and a level; the next level opens once the one before is cooked.
public struct SkillLevel: Hashable, Codable, Sendable {
    /// The number of every skill's first level.
    public static let firstNumber = 1

    /// Counts from 1. Lessons refer to a level by this number, so it never changes once published.
    public let number: Int
    public let name: LocalizedText

    public init(number: Int, name: LocalizedText) {
        self.number = number
        self.name = name
    }
}
