import Foundation
import TomiCore

/// One lesson as the fake server offers it, written as the real server writes a graph offer and then read the
/// way the app reads the real one. The recipe is the lesson's own text. The first swap the lesson lists is applied;
/// a lesson with no swap has its last ingredient left out. Every ingredient but the first is missing.
nonisolated struct FakeOffer {
    typealias Wire = [String: Any]

    let lesson: Lesson

    func offer(checkedFor profile: CookProfile) throws -> Offer {
        let data = try JSONSerialization.data(withJSONObject: wire(checkedFor: profile))
        return try JSONDecoder().decode(Offer.self, from: data)
    }

    private func wire(checkedFor profile: CookProfile) -> Wire {
        [
            "recipeId": FakeGraphID.recipe(lesson.id.rawValue),
            "title": LessonText.resolved(lesson.title),
            "sourceRecipe": FakeSourceRecipe(lesson: lesson).wire,
            "skill": ["id": lesson.skill.rawValue, "name": lesson.skill.rawValue],
            "level": ["number": lesson.level, "name": String(lesson.level)],
            "safePlan": FakeSafePlan(lesson: lesson).wire,
            "reason": LessonText.resolved(lesson.whyThis),
            "checked": checked(for: profile),
        ]
    }

    private func checked(for profile: CookProfile) -> Wire {
        var checked: Wire = ["avoid": profile.avoid.map(\.rawValue).sorted()]
        checked["diet"] = profile.diet?.rawValue ?? NSNull()
        return checked
    }
}
