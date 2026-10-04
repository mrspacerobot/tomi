/// Reads saved preferences written by any version of the app, older or newer.
extension CookPreferences {
    /// Starts from the defaults and takes each saved field this build understands.
    /// A missing field, or a value only a newer app knows, keeps its default instead of failing.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        readFood(from: container)
        readKitchen(from: container)
    }

    private mutating func readFood(from container: KeyedDecodingContainer<CodingKeys>) {
        diet = container.knownValue(Diet.self, forKey: .diet) ?? diet
        avoid = container.knownValues(AvoidItemID.self, forKey: .avoid) ?? avoid
        cuisines = container.value(CuisinePreferences.self, forKey: .cuisines) ?? cuisines
        cupboardStaples = container.knownValues(IngredientID.self, forKey: .cupboardStaples) ?? cupboardStaples
    }

    private mutating func readKitchen(from container: KeyedDecodingContainer<CodingKeys>) {
        equipment = container.knownValues(Equipment.self, forKey: .equipment) ?? equipment
        experience = container.knownValue(Experience.self, forKey: .experience) ?? experience
        chosenUnits = container.knownValue(Units.self, forKey: .chosenUnits)
        setServings(container.value(Int.self, forKey: .servings) ?? servings)
        setWeeklyGoal(container.value(Int.self, forKey: .weeklyGoal) ?? weeklyGoal)
    }
}
