/// Feedback timed by the caller's visual state. Reduce Motion changes the visuals and keeps these cues.
enum ShowHaptic: Equatable {
    case selection
    case correctAnswer
    case retryAnswer
    case timerTap
    case scoreTick(intensity: Double)
    case levelUnlocked
    case wrap
}
