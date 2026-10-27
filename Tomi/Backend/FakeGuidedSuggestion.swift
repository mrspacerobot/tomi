import Foundation
import TomiCore

/// Reads the exact backend suggestion fixture for deterministic guided cooking previews and UI tests.
nonisolated enum FakeGuidedSuggestion {
    /// The backend's example as it is, its graph questions included, for previews.
    static func read(profile: CookProfile) throws -> Suggestion {
        try decode(try patchRestrictions(in: try fixtureData(), for: profile))
    }

    /// The example asking the invented quiz in place of the graph's, or no quiz without one, for the fake server.
    static func read(profile: CookProfile, quiz: FakeQuiz?) throws -> Suggestion {
        var patched = try patchRestrictions(in: try fixtureData(), for: profile)
        try replaceQuiz(in: &patched, with: quiz)
        return try decode(patched)
    }

    private static func decode(_ suggestion: [String: Any]) throws -> Suggestion {
        let data = try JSONSerialization.data(withJSONObject: suggestion)
        return try JSONDecoder().decode(Suggestion.self, from: data)
    }

    private static func fixtureData() throws -> Data {
        guard
            let url = Bundle.main.url(
                forResource: "teaching-suggestion",
                withExtension: "json"
            )
        else { throw CocoaError(.fileNoSuchFile) }
        return try Data(contentsOf: url)
    }

    private static func patchRestrictions(in data: Data, for profile: CookProfile) throws -> [String: Any] {
        guard var suggestion = try JSONSerialization.jsonObject(with: data) as? [String: Any],
            var checked = suggestion["checked"] as? [String: Any]
        else { throw CocoaError(.coderReadCorrupt) }
        checked["diet"] = profile.diet.map { $0.rawValue as Any } ?? NSNull()
        checked["avoid"] = profile.avoid.map(\.rawValue).sorted()
        suggestion["checked"] = checked
        return suggestion
    }

    /// The fake never asks the graph's own questions, whose right choices it does not know.
    private static func replaceQuiz(in suggestion: inout [String: Any], with quiz: FakeQuiz?) throws {
        guard var teaching = suggestion["teaching"] as? [String: Any] else { throw CocoaError(.coderReadCorrupt) }
        teaching["quiz"] = quiz?.teachingQuestions
        suggestion["teaching"] = teaching
    }
}
