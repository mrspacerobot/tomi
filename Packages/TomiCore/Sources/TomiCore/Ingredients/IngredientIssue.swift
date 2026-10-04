/// One way an ingredient table can be wrong. The validator lists them all so a library build can report every problem.
public enum IngredientIssue: Hashable, Sendable {
    /// An empty table would make every ingredient unknown.
    case noIngredients
    /// A blank id is found by where it sits in the list, counting from 0, since it has no name to report.
    case blankIngredientID(position: Int)
    case duplicateIngredient(IngredientID)
    /// The ingredient's name has no English text.
    case missingIngredientName(IngredientID)
    /// The ingredient's `contains` list holds a value that is not an `IngredientFact`.
    /// It is rejected rather than dropped, because a dropped fact would read as "does not contain".
    case unknownFact(IngredientID, String)
}
