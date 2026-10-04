/// The cook's answer for each cuisine they have an opinion on.
/// Cuisines arrive with the library, so there is no fixed list here: a cuisine without an answer counts as "try".
public struct CuisinePreferences: Hashable, Codable, Sendable {
    /// Only the cuisines the cook has answered for.
    public private(set) var answers: [CuisineID: CuisinePreference] = [:]

    public init() {}

    public func preference(for cuisine: CuisineID) -> CuisinePreference {
        guard let answer = answers[cuisine] else {
            return .try
        }
        return answer
    }

    public mutating func set(_ preference: CuisinePreference, for cuisine: CuisineID) {
        answers[cuisine] = preference
    }
}
