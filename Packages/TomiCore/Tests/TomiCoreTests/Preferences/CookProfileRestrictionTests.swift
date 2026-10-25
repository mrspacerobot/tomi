import Testing

@testable import TomiCore

/// When the diet or avoid list changes, whatever was checked for the old answers must be checked again.
@Suite struct CookProfileRestrictionTests {
    @Test func theSameAnswersHaveTheSameRestrictions() {
        let profile = CookProfile.fixtureWithEveryAnswerChanged()
        #expect(profile.hasSameRestrictions(as: .fixtureWithEveryAnswerChanged()))
    }

    @Test func otherAnswersDoNotChangeTheRestrictions() {
        var other = CookProfile()
        other.setWeeklyGoal(6)
        other.cuisinesNever = ["thai"]
        #expect(other.hasSameRestrictions(as: CookProfile()))
    }

    @Test func aNewDietChangesThem() {
        var vegan = CookProfile()
        vegan.diet = "vegan"
        #expect(!vegan.hasSameRestrictions(as: CookProfile()))
        #expect(!CookProfile().hasSameRestrictions(as: vegan))
    }

    @Test func anAddedOrRemovedAvoidItemChangesThem() {
        var nuts = CookProfile()
        nuts.avoid = ["nuts"]
        #expect(!nuts.hasSameRestrictions(as: CookProfile()))
        #expect(!CookProfile().hasSameRestrictions(as: nuts))
    }
}
