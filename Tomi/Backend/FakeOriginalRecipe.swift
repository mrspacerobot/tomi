import Foundation
import TomiCore

/// The graph's own recipe for a lesson: its ingredient lines in metric, its steps and its equipment, unchanged.
nonisolated struct FakeOriginalRecipe {
    let lesson: Lesson

    var wire: FakeSuggestion.Wire {
        [
            "ingredients": lesson.ingredients.map(line),
            "steps": lesson.steps.map(step),
            "equipment": lesson.equipment.map { FakeGraphID.equipment($0.rawValue) }.sorted(),
            "yields": ["unit": "serving", "value": 2],
        ]
    }

    private func line(_ ingredient: LessonIngredient) -> FakeSuggestion.Wire {
        [
            "thing": FakeGraphID.ingredient(ingredient.ingredient.rawValue),
            "part": ingredient.ingredient.rawValue,
            "amount": ["unit": ingredient.metric.unit.rawValue, "value": ingredient.metric.value],
        ]
    }

    private func step(_ step: LessonStep) -> FakeSuggestion.Wire {
        var wire: FakeSuggestion.Wire = ["text": LessonText.resolved(step.text)]
        if let seconds = step.timerSeconds {
            wire["time"] = ["unit": "second", "value": seconds]
        }
        return wire
    }
}
