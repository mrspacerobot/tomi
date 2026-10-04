@testable import TomiCore

extension LessonStep {
    /// A step with English text, no tip and no timer.
    static func fixture(scene: StepScene) -> LessonStep {
        LessonStep(text: LocalizedText(["en": "Do this"]), tip: nil, sceneName: scene.rawValue, timerSeconds: nil)
    }
}

extension LessonQuiz {
    /// Three answers, the second one right.
    static func fixture() -> LessonQuiz {
        LessonQuiz(
            question: LocalizedText(["en": "Why?"]),
            answers: [LocalizedText(["en": "One"]), LocalizedText(["en": "Two"]), LocalizedText(["en": "Three"])],
            correctAnswer: 1,
            explanation: LocalizedText(["en": "Because"])
        )
    }
}
