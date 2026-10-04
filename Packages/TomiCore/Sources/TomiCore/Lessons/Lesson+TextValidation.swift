/// Every word the cook reads must exist in English, the language all others fall back to.
extension Lesson {
    var textIssues: [LessonIssue] {
        var issues: [LessonIssue] = []
        for entry in cardTexts + stepTexts + quizTexts where entry.text.isMissingSourceText {
            issues.append(.missingText(entry.field))
        }
        return issues
    }

    private typealias FieldText = (field: LessonTextField, text: LocalizedText)

    private var cardTexts: [FieldText] {
        [(.title, title), (.whyThis, whyThis), (.concept, concept)]
    }

    /// A tip is optional, so only a tip that was written is checked.
    private var stepTexts: [FieldText] {
        var texts: [FieldText] = []
        for (position, step) in steps.enumerated() {
            texts.append((.stepText(step: position), step.text))
            if let tip = step.tip {
                texts.append((.stepTip(step: position), tip))
            }
        }
        return texts
    }

    private var quizTexts: [FieldText] {
        var texts: [FieldText] = [(.quizQuestion, quiz.question)]
        for (position, answer) in quiz.answers.enumerated() {
            texts.append((.quizAnswer(answer: position), answer))
        }
        texts.append((.quizExplanation, quiz.explanation))
        return texts
    }
}
