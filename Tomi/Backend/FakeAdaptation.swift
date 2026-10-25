import Foundation
import TomiCore

/// What the fake server does to a lesson's recipe for one cook: the first listed swap is made, or else the last
/// ingredient that a step names is left out together with the steps that name it. The real server does this in code
/// from the graph; the fake imitates the result only.
nonisolated struct FakeAdaptation {
    /// An ingredient line of the recipe: the part of the dish it was in the lesson, and what is used now.
    struct Line {
        let part: IngredientID
        let used: LessonIngredient
    }

    /// A step of the recipe as the cook reads it.
    struct Step {
        let text: String
        let seconds: Int?
    }

    let lesson: Lesson
    let swap: LessonSwap?
    let leftOut: LessonIngredient?

    init(lesson: Lesson, wantsSwap: Bool) {
        self.lesson = lesson
        var chosen: LessonSwap?
        if wantsSwap {
            chosen = lesson.swaps.first
        }
        swap = chosen
        leftOut = Self.leftOutIngredient(of: lesson, swapped: chosen != nil)
    }

    var lines: [Line] {
        let kept = lesson.ingredients.filter { $0 != leftOut }
        return kept.map { Line(part: $0.ingredient, used: used(for: $0)) }
    }

    var steps: [Step] {
        let kept = lesson.steps.filter { !mentionsLeftOut($0) }
        return kept.map { Step(text: text(of: $0), seconds: $0.timerSeconds) }
    }

    private func used(for line: LessonIngredient) -> LessonIngredient {
        guard let swap, swap.ingredient == line.ingredient else {
            return line
        }
        return swap.replacement
    }

    private func text(of step: LessonStep) -> String {
        let words = LessonText.resolved(step.text)
        guard let swap else {
            return words
        }
        let original = Self.words(of: swap.ingredient)
        return words.replacing(original, with: Self.words(of: swap.replacement.ingredient))
    }

    private func mentionsLeftOut(_ step: LessonStep) -> Bool {
        guard let leftOut else {
            return false
        }
        return Self.mentions(step, leftOut.ingredient)
    }

    private static func leftOutIngredient(of lesson: Lesson, swapped: Bool) -> LessonIngredient? {
        guard !swapped else {
            return nil
        }
        return lesson.ingredients.last { line in
            lesson.steps.contains { mentions($0, line.ingredient) }
        }
    }

    private static func mentions(_ step: LessonStep, _ ingredient: IngredientID) -> Bool {
        LessonText.resolved(step.text).contains(words(of: ingredient))
    }

    /// The ingredient as a cook writes it in a sentence: its id made into lower-case words.
    static func words(of ingredient: IngredientID) -> String {
        FakeOptions.name(of: ingredient.rawValue).lowercased()
    }
}
