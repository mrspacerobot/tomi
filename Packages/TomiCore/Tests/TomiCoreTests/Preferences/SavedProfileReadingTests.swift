import Testing

@testable import TomiCore

/// A stored profile is read field by field, whatever version of the app wrote it.
@Suite struct SavedProfileReadingTests {
    @Test func aRecordWithNoFieldsGivesTheDefaults() {
        #expect(SavedProfile().profile == CookProfile())
    }

    @Test func everyAnswerSurvivesBeingSavedAndReadBack() {
        var profile = CookProfile()
        profile.preferences = .fixtureWithEveryAnswerChanged()
        profile.focusSkill = "roux"
        profile.isOnboardingDone = true
        #expect(SavedProfile(profile).profile == profile)
    }

    @Test func theDefaultsSurviveBeingSavedAndReadBack() {
        #expect(SavedProfile(CookProfile()).profile == CookProfile())
    }

    @Test func aCuisineAnsweredTrySurvivesToo() {
        var profile = CookProfile()
        profile.preferences.cuisines.set(.try, for: "thai")
        #expect(SavedProfile(profile).profile.preferences.cuisines.answers == ["thai": .try])
    }

    @Test func anEmptyKitchenIsAnAnswerAndAMissingOneIsNot() {
        var saved = SavedProfile()
        #expect(saved.profile.preferences.chosenEquipment == nil)
        saved.equipment = []
        #expect(saved.profile.preferences.chosenEquipment == [])
    }

    @Test func anExperienceOnlyANewerAppKnowsKeepsTheDefault() {
        var saved = SavedProfile()
        saved.experience = "professional"
        #expect(saved.profile.preferences.experience == .basics)
    }

    @Test func unitsOnlyANewerAppKnowsAreLeftToTheLocale() {
        var saved = SavedProfile()
        saved.units = "imperial"
        #expect(saved.profile.preferences.chosenUnits == nil)
    }

    @Test func servingsAndWeeklyGoalOutsideTheirRangeAreBroughtBackIn() {
        var saved = SavedProfile()
        saved.servings = 0
        saved.weeklyGoal = 12
        #expect(saved.profile.preferences.servings == CookPreferences.minimumServings)
        #expect(saved.profile.preferences.weeklyGoal == GameRules.weeklyGoalOptions.upperBound)
    }

    @Test func aCuisineSavedUnderTwoAnswersTakesTheOneThatOffersItLeast() {
        var saved = SavedProfile()
        saved.cuisinesLoved = ["thai", "italian"]
        saved.cuisinesToTry = ["italian"]
        saved.cuisinesNever = ["thai"]
        let cuisines = saved.profile.preferences.cuisines
        #expect(cuisines.preference(for: "thai") == .never)
        #expect(cuisines.preference(for: "italian") == .love)
    }

    @Test func theSameAnswersAlwaysSaveTheSameLists() {
        var profile = CookProfile()
        profile.preferences.avoid = ["pork", "nuts", "alcohol"]
        #expect(SavedProfile(profile).avoid == ["alcohol", "nuts", "pork"])
    }
}
