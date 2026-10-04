import Testing

@testable import TomiCore

@Suite struct LessonValidationTests {
    @Test func theFixtureIsValid() {
        #expect(Lesson.fixture().issuesInTheFixtureLibrary().isEmpty)
    }

    @Test(arguments: ["", "  "])
    func aLessonIDIsNeverBlank(id: String) {
        var lesson = Lesson.fixture()
        lesson.id = LessonID(rawValue: id)
        #expect(lesson.issuesInTheFixtureLibrary() == [.blankID])
    }

    @Test func theSkillMustBeOnTheMenu() {
        var lesson = Lesson.fixture()
        lesson.skill = "juggling"
        #expect(lesson.issuesInTheFixtureLibrary() == [.unknownSkill("juggling")])
    }

    @Test(arguments: [0, 3, -1])
    func theLevelMustBeOneTheSkillHas(level: Int) {
        var lesson = Lesson.fixture()
        lesson.level = level
        #expect(lesson.issuesInTheFixtureLibrary() == [.unknownLevel("eggs", level)])
    }

    @Test func theCuisineIsNeverBlank() {
        var lesson = Lesson.fixture()
        lesson.cuisine = " "
        #expect(lesson.issuesInTheFixtureLibrary() == [.blankCuisine])
    }

    @Test(arguments: [0, -2])
    func theRevisionCountsFromOne(revision: Int) {
        var lesson = Lesson.fixture()
        lesson.revision = revision
        #expect(lesson.issuesInTheFixtureLibrary() == [.revisionNotPositive])
    }

    @Test(arguments: [0, -20])
    func theCookingTimeIsMoreThanNothing(minutes: Int) {
        var lesson = Lesson.fixture()
        lesson.minutes = minutes
        #expect(lesson.issuesInTheFixtureLibrary() == [.minutesNotPositive])
    }

    @Test func aLessonHasAtLeastOneIngredient() {
        var lesson = Lesson.fixture()
        lesson.ingredients = []
        #expect(lesson.issuesInTheFixtureLibrary() == [.noIngredients])
    }

    @Test func aLessonHasAtLeastOneStep() {
        var lesson = Lesson.fixture()
        lesson.steps = []
        #expect(lesson.issuesInTheFixtureLibrary() == [.noSteps])
    }

    @Test func everyProblemIsReportedAtOnce() {
        var lesson = Lesson.fixture()
        lesson.skill = "juggling"
        lesson.ingredients.append(.fixture("dragon-fruit"))
        lesson.steps[0].sceneName = "juggle"
        lesson.quiz.correctAnswer = nil
        let expected: [LessonIssue] = [
            .unknownSkill("juggling"), .unknownIngredient("dragon-fruit"), .unknownScene(step: 0, "juggle"),
            .noCorrectAnswer,
        ]
        #expect(lesson.issuesInTheFixtureLibrary() == expected)
    }
}
