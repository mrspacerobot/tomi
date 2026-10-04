import Foundation

@testable import TomiCore

/// The text of a small lesson file for the fixture catalog and table, with one part that a test can change.
enum LessonFile {
    static let butterLine =
        #"{"ingredient": "butter", "metric": {"value": 30, "unit": "gram"}, "#
        + #""cups": {"value": 2, "unit": "tablespoon"}}"#
    static let stirStep = #"{"text": {"en": "Stir."}, "tip": {"en": "Slowly."}, "scene": "stir", "timerSeconds": 90}"#
    static let quiz =
        #"{"question": {"en": "Why?"}, "answers": [{"en": "One"}, {"en": "Two"}], "correctAnswer": 1, "#
        + #""explanation": {"en": "Because"}}"#

    /// A valid file. `extra` is written as one more field of the lesson, with its leading comma.
    static func text(schemaVersion: Int = Lesson.supportedSchemaVersion, step: String = stirStep, extra: String = "")
        -> String
    {
        #"{"schemaVersion": \#(schemaVersion), "id": "garlic-butter", "revision": 2, "skill": "eggs", "level": 2, "#
            + #""cuisine": "french", "title": {"en": "Garlic butter"}, "minutes": 20, "#
            + #""whyThis": {"en": "Why"}, "concept": {"en": "What"}, "ingredients": [\#(butterLine)], "#
            + #""equipment": ["stovetop"], "main": "tofu", "steps": [\#(step)], "quiz": \#(quiz), "#
            + #""swaps": [{"replace": "butter", "with": \#(baconLine)}]\#(extra)}"#
    }

    static let baconLine = butterLine.replacing("butter", with: "bacon")

    static func data(_ text: String) -> Data {
        Data(text.utf8)
    }

    /// Decodes against the fixture catalog and the fixture table.
    static func decode(_ text: String) throws -> Lesson {
        try Lesson.decode(from: data(text), catalog: .fixture(), table: .fixture())
    }
}
