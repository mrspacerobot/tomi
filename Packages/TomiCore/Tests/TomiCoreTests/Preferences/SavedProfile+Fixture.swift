import Foundation

@testable import TomiCore

extension SavedProfile {
    /// A stored profile with these food answers, changed on the given day of October.
    static func fixture(diet: DietID?, avoid: Set<AvoidItemID> = [], changedOn day: Int) -> SavedProfile {
        var profile = CookProfile()
        profile.preferences = .fixture(diet: diet, avoid: avoid)
        var saved = SavedProfile(profile)
        saved.stableID = UUID()
        saved.updatedAt = StreakTestCalendar().date(.october(day))
        return saved
    }
}
