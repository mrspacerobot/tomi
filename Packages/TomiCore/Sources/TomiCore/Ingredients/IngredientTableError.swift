/// Why an ingredient table could not be used, or could not answer.
public enum IngredientTableError: Error, Equatable {
    /// Written for a newer or older app. Nothing past the version number was read.
    case unsupportedSchemaVersion(Int)
    case invalid([IngredientIssue])
    /// The table was asked about an ingredient it does not list. Nothing is known about it,
    /// so it must not be served: the caller handles this instead of getting an answer.
    case unknownIngredient(IngredientID)
}
