import Foundation
import TomiCore

/// The quiz route's bodies as the server writes them (tomi-backend `docs/examples/quiz-answer.json`).
/// The request is the backend's example word for word. The answers use an invented question and explanation,
/// so no fixture tells which choice of a real graph question is right.
enum QuizJSON {
    static let sitting = QuizSitting(
        entryID: UUID(uuidString: "4e2c2a0e-7e6b-4c7a-9c2b-6e0a3d1f9a11")!,
        recipeID: "recipe/soft-scrambled-eggs",
        graphVersion: "2026.10.22-8aa9532"
    )

    static let request =
        #"{"entryId": "4e2c2a0e-7e6b-4c7a-9c2b-6e0a3d1f9a11", "recipeId": "recipe/soft-scrambled-eggs", "#
        + #""graphVersion": "2026.10.22-8aa9532", "questionId": "technique/scramble/quiz/purpose", "choice": 0}"#

    static let right =
        #"{"questionId": "technique/scramble/quiz/fake-spoon", "correct": true, "scored": true, "#
        + #""explanation": "In the test kitchen Tomi stirs with a wooden spoon."}"#

    static let rightWithoutExplanation =
        #"{"questionId": "technique/scramble/quiz/fake-spoon", "correct": true, "scored": false}"#

    static let wrong =
        #"{"questionId": "technique/scramble/quiz/fake-spoon", "correct": false, "scored": true, "#
        + #""explanation": null}"#

    static let wrongWithAnExplanation =
        #"{"questionId": "technique/scramble/quiz/fake-spoon", "correct": false, "scored": true, "#
        + #""explanation": "Sent by mistake."}"#

    static let withoutCorrect =
        #"{"questionId": "technique/scramble/quiz/fake-spoon", "scored": true, "explanation": null}"#

    static let withoutScored =
        #"{"questionId": "technique/scramble/quiz/fake-spoon", "correct": true, "explanation": null}"#
}
