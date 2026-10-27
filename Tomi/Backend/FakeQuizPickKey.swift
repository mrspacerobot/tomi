import Foundation

/// A question within one cook: the first pick under it is the score.
nonisolated struct FakeQuizPickKey: Hashable, Sendable {
    let entryID: UUID
    let questionID: String
}
