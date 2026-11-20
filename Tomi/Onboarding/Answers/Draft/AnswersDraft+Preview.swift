import TomiCore

extension AnswersDraft {
    /// A new cook's answers over the fake server's lists.
    static func preview(saved avoid: Set<OptionID> = []) -> AnswersDraft {
        let data = FakeServerData()
        let api = FakeTomiAPI()
        var answers = CookProfile()
        answers.avoid = avoid
        return AnswersDraft(answers: answers, options: data.options, api: api)
    }
}
