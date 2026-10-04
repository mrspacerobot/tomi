/// One way a lesson can be wrong. The validator lists them all so a library build can report every problem.
/// Steps are found by where they sit in the lesson, counting from 0.
public enum LessonIssue: Hashable, Sendable {
    case blankID
    /// The skill is not in the skill catalog.
    case unknownSkill(SkillID)
    /// The skill has no level with this number.
    case unknownLevel(SkillID, Int)
    case blankCuisine
    case revisionNotPositive
    case minutesNotPositive
    /// This text has no English.
    case missingText(LessonTextField)
    case noIngredients
    case duplicateIngredient(IngredientID)
    /// The ingredient is not in the ingredient table, so nothing is known about who may eat it.
    case unknownIngredient(IngredientID)
    /// The amount of this ingredient in this unit system is zero, negative or not a number.
    case amountNotPositive(IngredientID, Units)
    /// The amount of this ingredient for this unit system uses a unit of the other one, such as grams for cups.
    case unitOutsideSystem(IngredientID, Units)
    /// The lesson names a main food that is not a `DishMain`, so its scenes could not be drawn.
    case unknownMain(String)
    case noSteps
    /// The step names a scene that is not a `StepScene`.
    case unknownScene(step: Int, String)
    case timerNotPositive(step: Int)
    /// The step's timer runs longer than `LessonStep.longestTimerSeconds`.
    case timerTooLong(step: Int)
    /// The quiz has fewer than `LessonQuiz.fewestAnswers` answers.
    case tooFewAnswers
    /// The quiz does not say which answer is right.
    case noCorrectAnswer
    /// The quiz names a right answer that is not in its list.
    case correctAnswerOutOfRange(Int)
    /// A swap replaces an ingredient the lesson does not use.
    case swapOfIngredientNotInLesson(IngredientID)
    /// A swap brings in an ingredient that is not in the ingredient table.
    case unknownSwapReplacement(IngredientID)
    /// A swap brings in an ingredient the lesson already uses, which would list it twice.
    case swapReplacementAlreadyInLesson(IngredientID)
}
