import Testing

@testable import TomiCore

/// Two devices can each save a profile before iCloud brings them together. Reading them gives one profile,
/// the same in either order, and never with fewer restrictions than any of the records.
@Suite struct SavedProfileMergingTests {
    @Test func noRecordsGiveNoProfile() {
        let none: [SavedProfile] = []
        #expect(none.mergedProfile == nil)
    }

    @Test func oneRecordIsReadAsItIs() {
        let saved = SavedProfile.fixture(diet: "vegan", avoid: ["nuts"], changedOn: 5)
        #expect([saved].mergedProfile == saved.profile)
    }

    @Test func theRecordChangedLastGivesTheOrdinaryAnswers() {
        var older = SavedProfile.fixture(diet: nil, changedOn: 5)
        older.weeklyGoal = 2
        older.onboardingDone = false
        var newer = SavedProfile.fixture(diet: nil, changedOn: 6)
        newer.weeklyGoal = 5
        newer.onboardingDone = true
        let merged = [older, newer].mergedProfile
        #expect(merged?.preferences.weeklyGoal == 5)
        #expect(merged?.isOnboardingDone == true)
        #expect([newer, older].mergedProfile == merged)
    }

    @Test func everyAvoidItemOfEveryRecordIsKept() {
        let phone = SavedProfile.fixture(diet: nil, avoid: ["nuts"], changedOn: 5)
        let tablet = SavedProfile.fixture(diet: nil, avoid: ["pork"], changedOn: 6)
        #expect([phone, tablet].mergedProfile?.preferences.avoid == ["nuts", "pork"])
        #expect([tablet, phone].mergedProfile?.preferences.avoid == ["nuts", "pork"])
    }

    @Test func aNewerRecordWithoutADietDoesNotDropTheDietOfAnOlderOne() {
        let phone = SavedProfile.fixture(diet: "vegan", changedOn: 5)
        let tablet = SavedProfile.fixture(diet: nil, changedOn: 6)
        #expect([phone, tablet].mergedProfile?.preferences.diet == "vegan")
        #expect([tablet, phone].mergedProfile?.preferences.diet == "vegan")
    }

    @Test func twoRecordsWithTheSameDietKeepIt() {
        let phone = SavedProfile.fixture(diet: "vegan", changedOn: 5)
        let tablet = SavedProfile.fixture(diet: "vegan", changedOn: 6)
        #expect([phone, tablet].mergedProfile?.preferences.diet == "vegan")
    }

    @Test func twoDifferentDietsRefuseEverythingUntilTheCookAnswersAgain() {
        let phone = SavedProfile.fixture(diet: "vegan", changedOn: 5)
        let tablet = SavedProfile.fixture(diet: "pescatarian", changedOn: 6)
        let merged = [phone, tablet].mergedProfile
        #expect(merged?.preferences.diet == DietID.unreadable)
        #expect([tablet, phone].mergedProfile == merged)
        #expect(!IngredientTable.fixture().understands(merged!.preferences))
    }

    @Test func recordsChangedAtTheSameMomentAreOrderedByTheirIds() {
        var first = SavedProfile.fixture(diet: nil, changedOn: 5)
        first.weeklyGoal = 2
        var second = SavedProfile.fixture(diet: nil, changedOn: 5)
        second.weeklyGoal = 6
        #expect([first, second].mergedProfile == [second, first].mergedProfile)
    }

    @Test func aRecordWithoutATimeIsTheOldest() {
        var undated = SavedProfile.fixture(diet: nil, changedOn: 5)
        undated.updatedAt = nil
        undated.weeklyGoal = 7
        var dated = SavedProfile.fixture(diet: nil, changedOn: 5)
        dated.weeklyGoal = 1
        #expect([undated, dated].mergedProfile?.preferences.weeklyGoal == 1)
        #expect([dated, undated].mergedProfile?.preferences.weeklyGoal == 1)
    }

    @Test func conflictingCopiesKeepRestrictionsAndAskForTheOrdinaryAnswersAgain() {
        let first = SavedProfile.fixture(diet: "vegan", avoid: ["nuts"], changedOn: 5)
        var second = first
        second.weeklyGoal = 6
        second.avoid = ["pork"]
        let merged = [first, second].mergedProfile
        #expect(merged?.preferences.diet == "vegan")
        #expect(merged?.preferences.avoid == ["nuts", "pork"])
        #expect(merged?.isOnboardingDone == false)
        #expect(merged?.preferences.weeklyGoal == CookPreferences().weeklyGoal)
        #expect([second, first].mergedProfile == merged)
    }
}
