import Testing

@testable import TomiCore

/// What Tomi assumes before the cook has answered anything.
@Suite struct CookPreferencesDefaultTests {
    let preferences = CookPreferences()

    @Test func theCookEatsEverythingAndAvoidsNothing() {
        #expect(preferences.diet == nil)
        #expect(preferences.avoid.isEmpty)
    }

    @Test func noCuisineHasAnAnswerYet() {
        #expect(preferences.cuisines.answers.isEmpty)
        #expect(preferences.cuisines.preference(for: "italian") == .try)
    }

    @Test func noEquipmentIsChosenSoTheLibraryDecides() {
        #expect(preferences.chosenEquipment == nil)
    }

    @Test func theCookKnowsTheBasics() {
        #expect(preferences.experience == .basics)
    }

    @Test func theTableIsSetForTwo() {
        #expect(preferences.servings == 2)
        #expect(CookPreferences.defaultServings == 2)
    }

    @Test func theWeeklyGoalIsTheGameDefault() {
        #expect(preferences.weeklyGoal == GameRules.defaultWeeklyGoal)
    }

    @Test func theCupboardIsEmpty() {
        #expect(preferences.cupboardStaples.isEmpty)
    }

    @Test func noUnitsAreChosenSoTheLocaleDecides() {
        #expect(preferences.chosenUnits == nil)
    }

    @Test func theClosedListsHoldExactlyTheAnswersOnTheScreens() {
        #expect(Experience.allCases == [.never, .basics, .comfortable])
        #expect(CuisinePreference.allCases == [.love, .try, .never])
    }
}
