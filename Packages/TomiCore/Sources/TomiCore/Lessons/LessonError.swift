/// Why a lesson file could not be used, or a swap could not be applied.
public enum LessonError: Error, Equatable {
    /// Written for a newer or older app. Nothing past the version number was read.
    case unsupportedSchemaVersion(Int)
    /// The lesson with this id has these problems. It must not be shown.
    case invalid(LessonID, [LessonIssue])
    /// A swap was applied to a lesson that does not use the ingredient it replaces.
    case swapOfIngredientNotInLesson(IngredientID)
    /// An offer or a bookmark named a swap the lesson does not list.
    case swapNotListed(AppliedSwap)
}
