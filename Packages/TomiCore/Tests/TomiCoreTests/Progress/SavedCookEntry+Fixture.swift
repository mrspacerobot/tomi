@testable import TomiCore

extension SavedCookEntry {
    /// The same record with one stored field missing, as a broken record would have it.
    func without(_ field: RequiredCookField) -> SavedCookEntry {
        var record = self
        record.clear(field)
        return record
    }

    private mutating func clear(_ field: RequiredCookField) {
        switch field {
        case .stableID: stableID = nil
        case .lesson: lesson = nil
        case .skill: skill = nil
        case .level: level = nil
        case .date: date = nil
        case .stoppedEarly: stoppedEarly = nil
        case .weeklyGoal: weeklyGoal = nil
        }
    }
}
