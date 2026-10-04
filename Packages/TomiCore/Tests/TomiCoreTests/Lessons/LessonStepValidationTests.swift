import Testing

@testable import TomiCore

@Suite struct LessonStepValidationTests {
    @Test func aSceneOutsideTheClosedListIsReportedWithItsStep() {
        var lesson = Lesson.fixture()
        lesson.steps[1].sceneName = "juggle"
        #expect(lesson.steps[1].scene == nil)
        #expect(lesson.issuesInTheFixtureLibrary() == [.unknownScene(step: 1, "juggle")])
    }

    @Test(arguments: StepScene.allCases)
    func everySceneOfTheKitIsAccepted(scene: StepScene) {
        var lesson = Lesson.fixture()
        lesson.steps[0] = .fixture(scene: scene)
        #expect(lesson.steps[0].scene == scene)
        #expect(lesson.issuesInTheFixtureLibrary().isEmpty)
    }

    @Test(arguments: [0, -60])
    func aTimerRunsForMoreThanNothing(seconds: Int) {
        var lesson = Lesson.fixture()
        lesson.steps[0].timerSeconds = seconds
        #expect(lesson.issuesInTheFixtureLibrary() == [.timerNotPositive(step: 0)])
    }

    @Test func theLongestTimerIsFourHours() {
        #expect(LessonStep.longestTimerSeconds == 4 * 60 * 60)
        var lesson = Lesson.fixture()
        lesson.steps[1].timerSeconds = LessonStep.longestTimerSeconds
        #expect(lesson.issuesInTheFixtureLibrary().isEmpty)
        lesson.steps[1].timerSeconds = LessonStep.longestTimerSeconds + 1
        #expect(lesson.issuesInTheFixtureLibrary() == [.timerTooLong(step: 1)])
    }

    @Test func aQuizNamesItsCorrectAnswer() {
        var lesson = Lesson.fixture()
        lesson.quiz.correctAnswer = nil
        #expect(lesson.issuesInTheFixtureLibrary() == [.noCorrectAnswer])
    }

    @Test(arguments: [-1, 3, 99])
    func theCorrectAnswerIsOneOfTheAnswers(index: Int) {
        var lesson = Lesson.fixture()
        lesson.quiz.correctAnswer = index
        #expect(lesson.issuesInTheFixtureLibrary() == [.correctAnswerOutOfRange(index)])
    }

    @Test(arguments: [0, 2])
    func theFirstAndTheLastAnswerMayBeCorrect(index: Int) {
        var lesson = Lesson.fixture()
        lesson.quiz.correctAnswer = index
        #expect(lesson.issuesInTheFixtureLibrary().isEmpty)
    }

    @Test func aQuizOffersAChoice() {
        var lesson = Lesson.fixture()
        lesson.quiz.answers = [LocalizedText(["en": "One"])]
        lesson.quiz.correctAnswer = 0
        #expect(lesson.issuesInTheFixtureLibrary() == [.tooFewAnswers])
    }
}
