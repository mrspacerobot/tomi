/// A page of the lesson player: what to get out, each step, then the question.
enum PlayerPage: Equatable {
    case ingredients
    case step(Int)
    case quiz
}
