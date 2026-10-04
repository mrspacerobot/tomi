/// The same answers for one ingredient, by id. An id the table does not list is an error, never a pass.
extension IngredientTable {
    public func avoidItems(for id: IngredientID) throws -> Set<AvoidItemID> {
        let ingredient = try ingredient(id)
        return avoidItems(triggeredBy: ingredient.facts)
    }

    public func diets(allowing id: IngredientID) throws -> Set<DietID> {
        let ingredient = try ingredient(id)
        return diets(allowing: ingredient.facts)
    }

    public func isAllowed(_ id: IngredientID, by preferences: CookPreferences) throws -> Bool {
        let ingredient = try ingredient(id)
        return allows(ingredient.facts, for: preferences)
    }
}
