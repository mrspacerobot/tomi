import Foundation

/// Which part of a production payload is the one below review.
enum TeachingPart: Int, CaseIterable {
    case technique
    case introduction
}

enum ProductionTeachingJSON {
    /// Every tier of the teaching is reviewed, except the one part given, which gets `tier`.
    static func reviewed(except part: TeachingPart, tier: String) -> String {
        let live = TeachingJSON.liveSuggestion
        guard let teaching = live.range(of: #""graphChannel": "draft""#) else { return "{}" }
        let head = String(live[..<teaching.lowerBound])
        let tail = String(live[teaching.lowerBound...])
        return head + replacingTier(number: part.rawValue, in: allReviewedProduction(tail), with: tier)
    }

    private static func allReviewedProduction(_ teaching: String) -> String {
        let production = teaching.replacingOccurrences(
            of: #""graphChannel": "draft""#,
            with: #""graphChannel": "production""#
        )
        return production.replacingOccurrences(of: #""tier": "drafted""#, with: #""tier": "reviewed""#)
    }

    private static func replacingTier(number: Int, in text: String, with tier: String) -> String {
        let reviewed = #""tier": "reviewed""#
        let ranges = text.ranges(of: reviewed)
        guard number < ranges.count else { return text }
        return text.replacingCharacters(in: ranges[number], with: #""tier": "\#(tier)""#)
    }
}
