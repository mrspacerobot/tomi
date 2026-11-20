/// Behavior switches for deterministic fake-server flows in previews and UI tests.
nonisolated struct FakeTomiAPIConfiguration: Equatable {
    let suggestionsNothing: Bool
    let guidedCooking: Bool
    /// How each fresh read of the cook's profile answers.
    let profileRefresh: FakeProfileRefreshOptions
    /// The invented quiz the guided suggestion asks and the fake marks picks from. Nil: the suggestion has no quiz.
    let quiz: FakeQuiz?
    /// How every quiz pick fails. Nil: picks are marked from the invented quiz.
    let quizFailure: FakeQuizFailure?
    /// How the progress routes answer: which fixture snapshot, or failing as if offline.
    var progressServer: FakeProgressServer
    /// Every suggestion names the fake dish photo, as the server does when a reviewed photo matches the cook's version.
    var dishPhotos = false

    init(
        suggestionsNothing: Bool = false,
        guidedCooking: Bool = false,
        profileRefresh: FakeProfileRefreshOptions = FakeProfileRefreshOptions(),
        quiz: FakeQuiz? = nil,
        quizFailure: FakeQuizFailure? = nil,
        progressServer: FakeProgressServer = FakeProgressServer()
    ) {
        self.suggestionsNothing = suggestionsNothing
        self.guidedCooking = guidedCooking
        self.profileRefresh = profileRefresh
        self.quiz = quiz
        self.quizFailure = quizFailure
        self.progressServer = progressServer
    }
}
