import Foundation

/// Variants of the backend's teaching example that change only its quiz.
enum TeachingQuizJSON {
    /// The example as teaching schema 1 sent it, with answers the app must ignore.
    /// The index points past the choices and the explanation is blank, which schema 1 once refused.
    static var schemaOneWithAnswers: String {
        TeachingJSON.liveSuggestion
            .replacingOccurrences(of: #""choices": ["#, with: #""answerIndex": 9, "explanation": " ", "choices": ["#)
    }

    /// The example with the first question's choices replaced.
    static func firstQuestion(choices: [String]) throws -> String {
        let data = Data(TeachingJSON.liveSuggestion.utf8)
        guard let suggestion = try JSONSerialization.jsonObject(with: data) as? [String: Any],
            let edited = replacingFirstChoices(of: suggestion, with: choices)
        else { return "{}" }
        let encoded = try JSONSerialization.data(withJSONObject: edited)
        guard let text = String(bytes: encoded, encoding: .utf8) else { return "{}" }
        return text
    }

    private static func replacingFirstChoices(of suggestion: [String: Any], with choices: [String]) -> [String: Any]? {
        guard var teaching = suggestion["teaching"] as? [String: Any],
            var quiz = teaching["quiz"] as? [[String: Any]]
        else { return nil }
        quiz[0]["choices"] = choices
        teaching["quiz"] = quiz
        var edited = suggestion
        edited["teaching"] = teaching
        return edited
    }
}
