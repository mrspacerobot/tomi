/// The profile in the server's JSON, under the same names as the stored fields of `SavedProfile`.
/// The diet and the avoid list must be readable or the whole profile is refused: guessing "eats everything"
/// would let the app show a dish the cook cannot eat. Any other field that is missing, or holds a value
/// this build does not know, keeps its default.
extension CookProfile: Codable {
    enum CodingKeys: String, CodingKey {
        case diet, avoid, cuisinesLoved, cuisinesToTry, cuisinesNever, cupboardStaples, cupboardAnswered
        case equipment
        case experience, servings, units, weeklyGoal, focusSkill
        case isOnboardingDone = "onboardingDone"
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        try readRestrictions(from: container)
        readLists(from: container)
        readKitchen(from: container)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try writeLists(into: &container)
        try writeKitchen(into: &container)
    }

    private mutating func readRestrictions(from container: KeyedDecodingContainer<CodingKeys>) throws {
        guard container.contains(.diet) else {
            let context = DecodingError.Context(codingPath: container.codingPath, debugDescription: "No diet.")
            throw DecodingError.keyNotFound(CodingKeys.diet, context)
        }
        diet = try container.decodeIfPresent(OptionID.self, forKey: .diet)
        avoid = try container.decode(Set<OptionID>.self, forKey: .avoid)
    }

    private mutating func readLists(from container: KeyedDecodingContainer<CodingKeys>) {
        cuisinesLoved = container.value(Set<OptionID>.self, forKey: .cuisinesLoved) ?? []
        cuisinesToTry = container.value(Set<OptionID>.self, forKey: .cuisinesToTry) ?? []
        cuisinesNever = container.value(Set<OptionID>.self, forKey: .cuisinesNever) ?? []
        cupboardStaples = container.value(Set<OptionID>.self, forKey: .cupboardStaples) ?? []
        equipment = container.value(Set<OptionID>.self, forKey: .equipment)
        cupboardAnswered = container.value(Bool.self, forKey: .cupboardAnswered) ?? false
    }

    private mutating func readKitchen(from container: KeyedDecodingContainer<CodingKeys>) {
        experience = container.knownValue(Experience.self, forKey: .experience) ?? experience
        units = container.knownValue(Units.self, forKey: .units)
        setServings(container.value(Int.self, forKey: .servings) ?? servings)
        setWeeklyGoal(container.value(Int.self, forKey: .weeklyGoal) ?? weeklyGoal)
        focusSkill = container.value(SkillID.self, forKey: .focusSkill)
        isOnboardingDone = container.value(Bool.self, forKey: .isOnboardingDone) ?? false
    }

    /// Lists are written sorted, so the same answers always give the same JSON. An unset value is written
    /// as null, because that is how the server is told to clear it.
    private func writeLists(into container: inout KeyedEncodingContainer<CodingKeys>) throws {
        try container.encode(diet, forKey: .diet)
        try container.encode(avoid.sorted(), forKey: .avoid)
        try container.encode(cuisinesLoved.sorted(), forKey: .cuisinesLoved)
        try container.encode(cuisinesToTry.sorted(), forKey: .cuisinesToTry)
        try container.encode(cuisinesNever.sorted(), forKey: .cuisinesNever)
        try container.encode(cupboardStaples.sorted(), forKey: .cupboardStaples)
        try container.encode(cupboardAnswered, forKey: .cupboardAnswered)
        try container.encode(equipment?.sorted(), forKey: .equipment)
    }

    private func writeKitchen(into container: inout KeyedEncodingContainer<CodingKeys>) throws {
        try container.encode(experience, forKey: .experience)
        try container.encode(servings, forKey: .servings)
        try container.encode(units, forKey: .units)
        try container.encode(weeklyGoal, forKey: .weeklyGoal)
        try container.encode(focusSkill, forKey: .focusSkill)
        try container.encode(isOnboardingDone, forKey: .isOnboardingDone)
    }
}
