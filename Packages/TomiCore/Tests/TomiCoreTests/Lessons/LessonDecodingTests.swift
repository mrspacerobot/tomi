import Foundation
import Testing

@testable import TomiCore

@Suite struct LessonDecodingTests {
    @Test func aValidLessonDecodes() throws {
        let lesson = try LessonFile.decode(LessonFile.text())
        #expect(lesson.id == "garlic-butter")
        #expect(lesson.revision == 2)
        #expect(lesson.skill == "eggs")
        #expect(lesson.level == 2)
        #expect(lesson.cuisine == "french")
        #expect(lesson.minutes == 20)
        #expect(lesson.equipment == ["stovetop"])
        #expect(lesson.title.resolved(preferredLanguages: []) == "Garlic butter")
    }

    @Test func theIngredientsDecodeWithBothAmounts() throws {
        let lesson = try LessonFile.decode(LessonFile.text())
        let butter = LessonIngredient(ingredient: "butter", metric: Amount(30, .gram), cups: Amount(2, .tablespoon))
        #expect(lesson.ingredients == [butter])
        #expect(lesson.swaps == [.fixture(replacing: "butter", with: "bacon")])
    }

    @Test func theStepsAndTheQuizDecode() throws {
        let lesson = try LessonFile.decode(LessonFile.text())
        let step = try #require(lesson.steps.first)
        #expect(step.scene == .stir)
        #expect(step.timerSeconds == 90)
        #expect(step.tip == LocalizedText(["en": "Slowly."]))
        #expect(lesson.quiz.answers.count == 2)
        #expect(lesson.quiz.correctAnswer == 1)
    }

    @Test func aStepNeedsNeitherATipNorATimer() throws {
        let lesson = try LessonFile.decode(LessonFile.text(step: #"{"text": {"en": "Plate."}, "scene": "plate"}"#))
        #expect(lesson.steps == [LessonStep(text: LocalizedText(["en": "Plate."]), sceneName: "plate")])
    }

    @Test func aLessonSurvivesARoundTripThroughJSON() throws {
        var lesson = Lesson.fixture()
        lesson.steps[0].tip = LocalizedText(["en": "A tip"])
        lesson.steps[0].timerSeconds = 30
        lesson.swaps = [.fixture(replacing: "butter", with: "bacon")]
        let decoded = try Lesson.decode(from: JSONEncoder().encode(lesson), catalog: .fixture())
        #expect(decoded == lesson)
    }

    @Test(arguments: [0, Lesson.supportedSchemaVersion + 1])
    func anUnknownSchemaVersionIsRejectedBeforeReadingTheRest(version: Int) {
        let file = #"{"schemaVersion": \#(version), "steps": "a shape from the future"}"#
        #expect(throws: LessonError.unsupportedSchemaVersion(version)) {
            try LessonFile.decode(file)
        }
    }

    @Test(arguments: [#"{"id": "garlic-butter"}"#, "not json", ""])
    func aFileWithoutASchemaVersionIsRejected(file: String) {
        #expect(throws: DecodingError.self) {
            try LessonFile.decode(file)
        }
    }

    @Test(arguments: ["diets", "avoid", "allergens", "vegetarian"])
    func aTagWrittenInTheFileIsRejectedBecauseTagsAreComputed(field: String) {
        #expect(throws: DecodingError.self) {
            try LessonFile.decode(LessonFile.text(extra: #", "\#(field)": ["vegan"]"#))
        }
    }

    @Test func anUnknownSceneIsReportedWithTheLessonIDNotADecodingCrash() {
        let juggle = #"{"text": {"en": "Juggle."}, "scene": "juggle"}"#
        #expect(throws: LessonError.invalid("garlic-butter", [.unknownScene(step: 0, "juggle")])) {
            try LessonFile.decode(LessonFile.text(step: juggle))
        }
    }

    @Test func anInvalidLessonIsRejectedWithEveryIssue() {
        let tooLong = #"{"text": {"en": ""}, "scene": "rest", "timerSeconds": 14401}"#
        let issues: [LessonIssue] = [.timerTooLong(step: 0), .missingText(.stepText(step: 0))]
        #expect(throws: LessonError.invalid("garlic-butter", issues)) {
            try LessonFile.decode(LessonFile.text(step: tooLong))
        }
    }

    @Test(arguments: ["pinch", "ounce", ""])
    func aUnitOutsideTheClosedListIsRejected(unit: String) {
        let file = LessonFile.text().replacing(#""unit": "gram""#, with: #""unit": "\#(unit)""#)
        #expect(throws: DecodingError.self) {
            try LessonFile.decode(file)
        }
    }
}
