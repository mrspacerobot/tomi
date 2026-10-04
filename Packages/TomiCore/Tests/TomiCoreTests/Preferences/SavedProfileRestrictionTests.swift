import Testing

@testable import TomiCore

/// Stored diet and avoid answers are never weakened on the way back, whoever wrote them.
@Suite struct SavedProfileRestrictionTests {
    let table = IngredientTable.fixture()

    @Test func aDietUnknownHereIsKeptSoTheTableRefusesEverything() {
        var saved = SavedProfile()
        saved.diet = "keto"
        let preferences = saved.profile.preferences
        #expect(preferences.diet == "keto")
        #expect(!table.understands(preferences))
    }

    @Test func anAvoidItemUnknownHereIsKeptSoTheTableRefusesEverything() {
        var saved = SavedProfile()
        saved.avoid = ["nuts", "lupin"]
        let preferences = saved.profile.preferences
        #expect(preferences.avoid == ["nuts", "lupin"])
        #expect(!table.understands(preferences))
    }

    @Test func aBlankDietStaysTheUnreadableDietAndNeverBecomesNoDiet() {
        var saved = SavedProfile()
        saved.diet = ""
        #expect(saved.profile.preferences.diet == DietID.unreadable)
        #expect(!table.understands(saved.profile.preferences))
    }

    @Test func aBlankAvoidItemStaysTheUnreadableItem() {
        var saved = SavedProfile()
        saved.avoid = [""]
        #expect(saved.profile.preferences.avoid == [AvoidItemID.unreadable])
        #expect(!table.understands(saved.profile.preferences))
    }

    @Test func anUnreadableAnswerSurvivesBeingSavedAgain() {
        var profile = CookProfile()
        profile.preferences.diet = DietID.unreadable
        profile.preferences.avoid = [AvoidItemID.unreadable]
        let savedAgain = SavedProfile(profile).profile.preferences
        #expect(savedAgain.diet == DietID.unreadable)
        #expect(savedAgain.avoid == [AvoidItemID.unreadable])
    }

    @Test func knownRestrictionsAreUnderstoodAfterTheRoundTrip() {
        var profile = CookProfile()
        profile.preferences = .fixture(diet: "vegan", avoid: ["nuts"])
        let preferences = SavedProfile(profile).profile.preferences
        #expect(preferences == profile.preferences)
        #expect(table.understands(preferences))
    }
}
