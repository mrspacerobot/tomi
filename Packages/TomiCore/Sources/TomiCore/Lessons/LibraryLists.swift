/// The lists of one library that every lesson of it is checked against:
/// the skill catalog, the ingredient table and the equipment list.
/// They travel together, so a lesson is never judged by the lists of another library.
public struct LibraryLists: Hashable, Sendable {
    public var catalog: SkillCatalog
    public var ingredientTable: IngredientTable
    public var equipmentList: EquipmentList

    public init(catalog: SkillCatalog, ingredientTable: IngredientTable, equipmentList: EquipmentList) {
        self.catalog = catalog
        self.ingredientTable = ingredientTable
        self.equipmentList = equipmentList
    }
}
