import Foundation
import TomiCore

/// One lesson as the fake server suggests it, written as the real server writes a graph suggestion and then read the
/// way the app reads the real one. The recipe is the lesson's own text, adapted: a dish that wants a swap has the
/// first swap the lesson lists made, any other has an ingredient left out (`FakeAdaptation`).
nonisolated struct FakeSuggestion {
    typealias Wire = [String: Any]

    let lesson: Lesson
    let wantsSwap: Bool

    func suggestion(checkedFor profile: CookProfile) throws -> Suggestion {
        let data = try JSONSerialization.data(withJSONObject: wire(checkedFor: profile))
        return try JSONDecoder().decode(Suggestion.self, from: data)
    }

    private func wire(checkedFor profile: CookProfile) -> Wire {
        var wire = identity
        let adaptation = FakeAdaptation(lesson: lesson, wantsSwap: wantsSwap)
        let recipe = FakeRecipe(adaptation: adaptation)
        wire["recipe"] = recipe.recipeWire
        wire["changes"] = recipe.changesWire
        wire["safePlan"] = FakeSafePlan(adaptation: adaptation).wire
        wire["checked"] = checked(for: profile)
        return wire
    }

    /// The fields that do not depend on the cook or on the adaptation.
    private var identity: Wire {
        [
            "recipeId": FakeGraphID.recipe(lesson.id.rawValue),
            "title": LessonText.resolved(lesson.title),
            "skill": ["id": lesson.skill.rawValue, "name": lesson.skill.rawValue],
            "level": ["number": lesson.level, "name": String(lesson.level)],
            "reason": LessonText.resolved(lesson.whyThis),
        ]
    }

    private func checked(for profile: CookProfile) -> Wire {
        var checked: Wire = ["avoid": profile.avoid.map(\.rawValue).sorted()]
        checked["diet"] = profile.diet?.rawValue ?? NSNull()
        return checked
    }
}
