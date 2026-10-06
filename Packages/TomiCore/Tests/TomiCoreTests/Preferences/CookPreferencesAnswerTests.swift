import Foundation
import Testing

@testable import TomiCore

/// Answers the cook changes: cuisines, units, and the two numbers that must stay in range.
@Suite struct CookPreferencesAnswerTests {
    @Test func aCuisineKeepsItsAnswerAndTheOthersStayOnTry() {
        var cuisines = CuisinePreferences()
        cuisines.set(.love, for: "italian")
        cuisines.set(.never, for: "thai")
        #expect(cuisines.preference(for: "italian") == .love)
        #expect(cuisines.preference(for: "thai") == .never)
        #expect(cuisines.preference(for: "mexican") == .try)
        #expect(cuisines.answers.count == 2)
    }

    @Test func aCuisineAnswerCanBeChanged() {
        var cuisines = CuisinePreferences()
        cuisines.set(.never, for: "thai")
        cuisines.set(.try, for: "thai")
        #expect(cuisines.preference(for: "thai") == .try)
    }

    @Test func unitsFollowTheLocaleUntilTheCookChooses() {
        let unitedStates = Locale(languageCode: .english, languageRegion: .unitedStates)
        let switzerland = Locale(languageCode: .german, languageRegion: .switzerland)
        let unitedKingdom = Locale(languageCode: .english, languageRegion: .unitedKingdom)
        var preferences = CookPreferences()
        #expect(preferences.units(for: unitedStates) == .cups)
        #expect(preferences.units(for: switzerland) == .metric)
        #expect(preferences.units(for: unitedKingdom) == .metric)
        preferences.chosenUnits = .metric
        #expect(preferences.units(for: unitedStates) == .metric)
    }

    @Test(arguments: [(1, 1), (7, 7), (4, 4), (0, 1), (-3, 1), (8, 7), (100, 7)])
    func theWeeklyGoalStaysInsideTheOptions(asked: Int, kept: Int) {
        var preferences = CookPreferences()
        preferences.setWeeklyGoal(asked)
        #expect(preferences.weeklyGoal == kept)
        #expect(GameRules.weeklyGoalOptions.contains(preferences.weeklyGoal))
    }

    @Test(arguments: [(1, 1), (6, 6), (0, 1), (-2, 1)])
    func theTableSeatsAtLeastOne(asked: Int, kept: Int) {
        var preferences = CookPreferences()
        preferences.setServings(asked)
        #expect(preferences.servings == kept)
    }
}
