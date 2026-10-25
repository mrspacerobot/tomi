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

    static let valid =
        #""teaching":{"schemaVersion":1,"graphVersion":"fixture","graphChannel":"draft","language":"en","#
        + #""technique":{"id":"technique/scramble","name":"Scramble","tier":"drafted"},"#
        + #""introduction":{"concept":"Gentle curds","what":"Stir gently.","why":"Notice texture.","tier":"drafted"},"#
        + #""quiz":null}"#

    static let invalidQuiz =
        #""teaching":{"schemaVersion":1,"graphVersion":"fixture","graphChannel":"draft","language":"en", "#
        + #""technique":{"id":"technique/scramble","name":"Scramble","tier":"drafted"},"#
        + #""introduction":{"concept":"Gentle curds","what":"Stir gently.","why":"Notice texture.","tier":"drafted"},"#
        + #""quiz":[{"id":"bad","question":"Which?","choices":["A","B"],"answerIndex":8,"#
        + #""explanation":"Text","tier":"drafted"}]}"#
}
