import TomiCore

extension AnswersDraft {
    /// A new cook's answers over the fake server's lists.
    static func preview() -> AnswersDraft {
        let data = FakeServerData(library: BundledLessonLibrary())
        return AnswersDraft(answers: CookProfile(), options: data.options)
    }
}
