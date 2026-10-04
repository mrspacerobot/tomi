/// One way an ingredient table can be wrong. The validator lists them all so a library build can report every problem.
/// A blank id is found by where it sits in its list, counting from 0, since it has no name to report.
public enum IngredientIssue: Hashable, Sendable {
    /// An empty table would make every ingredient unknown.
    case noIngredients
    case blankIngredientID(position: Int)
    case blankFactID(position: Int)
    case blankAvoidItemID(position: Int)
    case blankDietID(position: Int)
    case duplicateIngredient(IngredientID)
    case duplicateFact(IngredientFactID)
    case duplicateAvoidItem(AvoidItemID)
    case duplicateDiet(DietID)
    /// The name has no English text.
    case missingIngredientName(IngredientID)
    case missingAvoidItemName(AvoidItemID)
    /// The diet's name or its summary has no English text.
    case missingDietText(DietID)
    /// A fact that the table's `facts` list does not declare. It is rejected rather than dropped,
    /// because a dropped fact would read as "does not contain".
    case undeclaredIngredientFact(IngredientID, IngredientFactID)
    case undeclaredAvoidItemFact(AvoidItemID, IngredientFactID)
    case undeclaredDietFact(DietID, IngredientFactID)
    /// An avoid item that no fact triggers would let a cook tick it and still be served everything.
    case avoidItemTriggersNothing(AvoidItemID)
    /// A diet that rules nothing out would let a cook choose it and still be served everything.
    case dietExcludesNothing(DietID)
}
