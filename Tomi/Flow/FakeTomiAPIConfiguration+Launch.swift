extension FakeTomiAPIConfiguration {
    /// The fake server's behaviour the launch arguments ask for.
    nonisolated init(arguments: [String]) {
        let quiz = FakeQuizOptions(arguments: arguments)
        self.init(
            suggestionsNothing: arguments.contains(BackendLaunchOptions.fakeNoSuggestionsArgument),
            guidedCooking: arguments.contains(BackendLaunchOptions.fakeGuidedArgument),
            profileRefresh: FakeProfileRefreshOptions(arguments: arguments),
            quiz: quiz.inventedQuiz,
            quizFailure: quiz.failure,
            progressServer: FakeProgressServer(arguments: arguments)
        )
    }
}
