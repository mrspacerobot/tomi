import Testing

@testable import TomiCore

/// Every piece of text the cook reads needs English, wherever it sits in the lesson.
@Suite struct LessonTextValidationTests {
    static let missing = [LocalizedText([:]), LocalizedText(["en": " "]), LocalizedText(["fr": "Bonjour"])]

    @Test(arguments: missing)
    func theTitleNeedsEnglish(text: LocalizedText) {
        var lesson = Lesson.fixture()
        lesson.title = text
        #expect(lesson.issuesInTheFixtureLibrary() == [.missingText(.title)])
    }

    @Test(arguments: missing)
    func theReasonAndTheConceptNeedEnglish(text: LocalizedText) {
        var lesson = Lesson.fixture()
        lesson.whyThis = text
        lesson.concept = text
        #expect(lesson.issuesInTheFixtureLibrary() == [.missingText(.whyThis), .missingText(.concept)])
    }

    @Test(arguments: missing)
    func everyStepNeedsEnglish(text: LocalizedText) {
        var lesson = Lesson.fixture()
        lesson.steps[1].text = text
        #expect(lesson.issuesInTheFixtureLibrary() == [.missingText(.stepText(step: 1))])
    }

    @Test(arguments: missing)
    func aTipThatIsWrittenNeedsEnglish(text: LocalizedText) {
        var lesson = Lesson.fixture()
        lesson.steps[0].tip = text
        #expect(lesson.issuesInTheFixtureLibrary() == [.missingText(.stepTip(step: 0))])
    }

    @Test func aStepMayHaveATip() {
        var lesson = Lesson.fixture()
        lesson.steps[0].tip = LocalizedText(["en": "A tip"])
        #expect(lesson.issuesInTheFixtureLibrary().isEmpty)
    }

    @Test(arguments: missing)
    func theQuizNeedsEnglish(text: LocalizedText) {
        var lesson = Lesson.fixture()
        lesson.quiz.question = text
        lesson.quiz.answers[2] = text
        lesson.quiz.explanation = text
        let expected: [LessonIssue] = [
            .missingText(.quizQuestion), .missingText(.quizAnswer(answer: 2)), .missingText(.quizExplanation),
        ]
        #expect(lesson.issuesInTheFixtureLibrary() == expected)
    }
}
