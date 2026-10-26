import Foundation

/// One cook entry as `POST /v1/cook-entries` takes it. The id is the one the phone made when cooking began,
/// sent unchanged in every batch, so the server counts the cook once however often it arrives.
/// There is no quiz result, XP or total in it: the server works all of those out itself.
public struct CookEntryPayload: Hashable, Codable, Sendable {
    public static let currentSchemaVersion = 1

    public let schemaVersion: Int
    public let id: UUID
    public let cookedAt: ServerInstant
    /// The IANA zone the cook was made in. The server judges each past week by every entry's own zone.
    public let timeZone: String
    public let dish: CookedDish
    public let skill: SkillID
    public let level: Int
    public let outcome: CookOutcome
    /// The cook's weekly goal when the cook was made, so a later change never judges a past week again.
    public let weeklyGoal: Int

    enum CodingKeys: String, CodingKey {
        case schemaVersion, id, cookedAt, timeZone, dish, skill, level, outcome, weeklyGoal
    }

    /// Written as the server writes it, the id in lower case, so the same cook is always the same text.
    public func encode(to encoder: any Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try values.encode(schemaVersion, forKey: .schemaVersion)
        try values.encode(id.uuidString.lowercased(), forKey: .id)
        try values.encode(cookedAt, forKey: .cookedAt)
        try values.encode(timeZone, forKey: .timeZone)
        try values.encode(dish, forKey: .dish)
        try values.encode(skill, forKey: .skill)
        try values.encode(level, forKey: .level)
        try values.encode(outcome, forKey: .outcome)
        try values.encode(weeklyGoal, forKey: .weeklyGoal)
    }
}
