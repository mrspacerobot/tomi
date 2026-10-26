import Foundation

enum TeachingJSON {
    static var liveSuggestion: String {
        guard
            let url = Bundle.module.url(
                forResource: "teaching-suggestion",
                withExtension: "json"
            )
        else { return "{}" }
        return (try? String(contentsOf: url, encoding: .utf8)) ?? "{}"
    }

    static var productionWithDraftQuestion: String {
        var payload =
            liveSuggestion
            .replacingOccurrences(of: #""graphChannel": "draft""#, with: #""graphChannel": "production""#)
            .replacingOccurrences(of: #""tier": "drafted""#, with: #""tier": "reviewed""#)
        guard let quizStart = payload.range(of: #""quiz": ["#)?.upperBound,
            let tier = payload.range(of: #""tier": "reviewed""#, range: quizStart..<payload.endIndex)
        else { return "{}" }
        payload.replaceSubrange(tier, with: #""tier": "drafted""#)
        return payload
    }

    static var duplicateChoices: String {
        liveSuggestion.replacingOccurrences(
            of: #""Large, dry, rubbery curds.""#,
            with: #""Small, soft, creamy curds.""#
        )
    }

    static var emptyQuestionID: String {
        liveSuggestion.replacingOccurrences(
            of: #"technique/scramble/quiz/purpose"#,
            with: #"technique/scramble/quiz/"#
        )
    }

    static var blankQuestion: String {
        liveSuggestion.replacingOccurrences(
            of: #"Which texture is the aim of this scramble method?"#,
            with: #"   "#
        )
    }

    static var unsupportedPayloads: [String] {
        [
            liveSuggestion.replacingOccurrences(
                of: #""graphVersion": "2026.10.22-8aa9532""#,
                with: #""graphVersion": " ""#
            ),
            liveSuggestion.replacingOccurrences(of: #""graphChannel": "draft""#, with: #""graphChannel": "unknown""#),
            liveSuggestion.replacingOccurrences(of: #""language": "en""#, with: #""language": "fr""#),
            liveSuggestion.replacingOccurrences(of: #""tier": "drafted""#, with: #""tier": "future""#),
            liveSuggestion.replacingOccurrences(of: #""schemaVersion": 2"#, with: #""schemaVersion": 3"#),
            liveSuggestion.replacingOccurrences(of: #""schemaVersion": 2"#, with: #""schemaVersion": 0"#),
        ]
    }

    static let valid =
        #""teaching":{"schemaVersion":2,"graphVersion":"fixture","graphChannel":"draft","language":"en","#
        + #""technique":{"id":"technique/scramble","name":"Scramble","tier":"drafted"},"#
        + #""introduction":{"concept":"Gentle curds","what":"Stir gently.","why":"Notice texture.","tier":"drafted"},"#
        + #""quiz":null}"#

    static let invalidQuiz =
        #""teaching":{"schemaVersion":2,"graphVersion":"fixture","graphChannel":"draft","language":"en", "#
        + #""technique":{"id":"technique/scramble","name":"Scramble","tier":"drafted"},"#
        + #""introduction":{"concept":"Gentle curds","what":"Stir gently.","why":"Notice texture.","tier":"drafted"},"#
        + #""quiz":[{"id":"bad","question":"Which?","choices":["A","B"],"tier":"drafted"}]}"#
}
