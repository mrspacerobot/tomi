/// Behavior switches for deterministic fake-server flows in previews and UI tests.
nonisolated struct FakeTomiAPIConfiguration {
    let suggestionsNothing: Bool
    let guidedCooking: Bool
    let profileRefreshFails: Bool
    let profileRefreshChanges: Bool
    let profileRefreshWaits: Bool
    /// The profile read when the steps begin differs, after the one before preparation passed.
    let profileRefreshChangesLate: Bool
    /// The invented quiz the guided suggestion asks and the fake marks picks from. Nil: the suggestion has no quiz.
    let quiz: FakeQuiz?
    /// How every quiz pick fails. Nil: picks are marked from the invented quiz.
    let quizFailure: FakeQuizFailure?

    init(
        suggestionsNothing: Bool = false,
        guidedCooking: Bool = false,
        profileRefreshFails: Bool = false,
        profileRefreshChanges: Bool = false,
        profileRefreshWaits: Bool = false,
        profileRefreshChangesLate: Bool = false,
        quiz: FakeQuiz? = nil,
        quizFailure: FakeQuizFailure? = nil
    ) {
        self.suggestionsNothing = suggestionsNothing
        self.guidedCooking = guidedCooking
        self.profileRefreshFails = profileRefreshFails
        self.profileRefreshChanges = profileRefreshChanges
        self.profileRefreshWaits = profileRefreshWaits
        self.profileRefreshChangesLate = profileRefreshChangesLate
        self.quiz = quiz
        self.quizFailure = quizFailure
    }
}
