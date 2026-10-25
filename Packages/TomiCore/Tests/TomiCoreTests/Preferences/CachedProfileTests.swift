import Testing

@testable import TomiCore

/// The phone keeps a copy of the server's profile. Of several stored copies the newest is read, in any order.
@Suite struct CachedProfileTests {
    let monday = SavedProfile.fixture(weeklyGoal: 2, changedOn: 5)
    let tuesday = SavedProfile.fixture(weeklyGoal: 6, changedOn: 6)

    @Test func nothingStoredIsNoProfile() {
        let none: [SavedProfile] = []
        #expect(none.cachedProfile == nil)
    }

    @Test func theCopyChangedLastIsReadInEitherOrder() {
        #expect([monday, tuesday].cachedProfile?.weeklyGoal == 6)
        #expect([tuesday, monday].cachedProfile?.weeklyGoal == 6)
    }

    @Test func conflictingCopiesWithTheSameStampAreNotRead() {
        var other = monday
        other.weeklyGoal = 4
        #expect([monday, other].cachedProfile == nil)
        #expect([other, monday].cachedProfile == nil)
    }
}
