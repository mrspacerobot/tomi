import Foundation
import TomiCore

/// Reads the exact backend suggestion fixture for deterministic introduction and preparation UI tests.
nonisolated enum FakeGuidedSuggestion {
    static func read(profile: CookProfile) throws -> Suggestion {
        let source = try fixtureData()
        let patched = try patchRestrictions(in: source, for: profile)
        let data = try JSONSerialization.data(withJSONObject: patched)
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
}
