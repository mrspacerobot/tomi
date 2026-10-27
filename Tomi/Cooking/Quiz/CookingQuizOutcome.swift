/// What the quiz says under the choices after a pick was sent.
nonisolated enum CookingQuizOutcome: Equatable {
    /// The server said the pick is right, with its explanation when it sent one.
    case right(String?)
    /// The server said the last pick is wrong. The cook tries another choice.
    case wrong
    /// The pick could not be checked.
    case problem(CookingQuizProblem)
}
