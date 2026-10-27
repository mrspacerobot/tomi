/// Behavior switches for deterministic fake-server flows in previews and UI tests.
nonisolated struct FakeTomiAPIConfiguration {
    let suggestionsNothing: Bool
    let guidedCooking: Bool
    let profileRefreshFails: Bool
    let profileRefreshChanges: Bool
    let profileRefreshWaits: Bool
    /// The invented quiz the guided suggestion asks and the fake marks picks from. Nil: the suggestion has no quiz.
    let quiz: FakeQuiz?
    /// Every quiz pick fails as if the phone had no connection.
    let quizOffline: Bool

    init(
        suggestionsNothing: Bool = false,
        guidedCooking: Bool = false,
        profileRefreshFails: Bool = false,
        profileRefreshChanges: Bool = false,
        profileRefreshWaits: Bool = false,
        quiz: FakeQuiz? = nil,
        quizOffline: Bool = false
    ) {
        self.suggestionsNothing = suggestionsNothing
        self.guidedCooking = guidedCooking
        self.profileRefreshFails = profileRefreshFails
        self.profileRefreshChanges = profileRefreshChanges
        self.profileRefreshWaits = profileRefreshWaits
        self.quiz = quiz
        self.quizOffline = quizOffline
    }
}
