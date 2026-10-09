import Testing

@testable import TomiCore

/// The stored copy of the profile is read field by field, whatever version of the app wrote it.
@Suite struct SavedProfileReadingTests {
    @Test func aRecordWithNoFieldsGivesTheDefaults() {
        #expect(SavedProfile().profile == CookProfile())
    }

    @Test func everyAnswerSurvivesBeingSavedAndReadBack() {
        let profile = CookProfile.fixtureWithEveryAnswerChanged()
        #expect(SavedProfile(profile).profile == profile)
    }

    @Test func theDefaultsSurviveBeingSavedAndReadBack() {
        #expect(SavedProfile(CookProfile()).profile == CookProfile())
    }

    @Test func anEmptyKitchenIsAnAnswerAndAMissingOneIsNot() {
        var saved = SavedProfile()
        #expect(saved.profile.equipment == nil)
        saved.equipment = []
        #expect(saved.profile.equipment == [])
    }

    @Test func anExperienceOnlyANewerAppKnowsKeepsTheDefault() {
        var saved = SavedProfile()
        saved.experience = "professional"
        #expect(saved.profile.experience == .basics)
    }

    @Test func unitsOnlyANewerAppKnowsAreLeftToTheLocale() {
        var saved = SavedProfile()
        saved.units = "imperial"
        #expect(saved.profile.units == nil)
    }

    @Test func servingsAndWeeklyGoalOutsideTheirRangeAreBroughtBackIn() {
        var saved = SavedProfile()
        saved.servings = 0
        saved.weeklyGoal = 12
        #expect(saved.profile.servings == CookProfile.minimumServings)
        #expect(saved.profile.weeklyGoal == GameRules.weeklyGoalOptions.upperBound)
    }

    @Test func theSameAnswersAlwaysSaveTheSameLists() {
        var profile = CookProfile()
        profile.avoid = ["pork", "nuts", "alcohol"]
        #expect(SavedProfile(profile).avoid == ["alcohol", "nuts", "pork"])
    }
}
