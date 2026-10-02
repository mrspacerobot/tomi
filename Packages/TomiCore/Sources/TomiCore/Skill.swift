/// A course on Tomi's menu. Each course groups three techniques.
/// Display names live in the app's string catalog, not here.
public enum Course: Int, CaseIterable, Codable, Sendable {
    case foundations
    case heatControl
    case buildingFlavor
    case puttingItTogether
}

public enum SkillID: String, CaseIterable, Codable, Sendable {
    case knife, eggs, boil
    case saute, sear, rice
    case roast, pansauce, emulsion
    case pasta, braise, balance
}

/// One technique on the menu, such as searing or pan sauces.
public struct Skill: Identifiable, Hashable, Sendable {
    public let id: SkillID
    public let course: Course
    /// Techniques that must be mastered before this one is served.
    public let prerequisites: [SkillID]

    public init(id: SkillID, course: Course, prerequisites: [SkillID] = []) {
        self.id = id
        self.course = course
        self.prerequisites = prerequisites
    }
}
