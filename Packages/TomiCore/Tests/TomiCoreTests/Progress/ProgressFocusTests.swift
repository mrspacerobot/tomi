import Testing

@testable import TomiCore

/// The focus is the skill Tomi cooks next: the cook's choice while it can be cooked, otherwise the next on the menu.
@Suite struct ProgressFocusTests {
    let log = ProgressTestLog()

    @Test func aServedUnmasteredChoiceIsKept() {
        #expect(log.progress([]).focus(preferring: "eggs") == "eggs")
    }

    @Test func withoutAChoiceTheFocusIsTheFirstServedSkillOnTheMenu() {
        #expect(log.progress([]).focus(preferring: nil) == "knife")
    }

    @Test func aLockedChoiceFallsBackToTheFirstServedSkill() {
        #expect(log.progress([]).focus(preferring: "roux") == "knife")
    }

    @Test func aMasteredChoiceFallsBackToTheFirstServedUnmasteredSkill() {
        let entries = log.cooks(2, of: "knife", level: 1) + log.cooks(2, of: "knife", level: 2)
        #expect(log.progress(entries).focus(preferring: "knife") == "eggs")
    }

    @Test func aChoiceTheCatalogDoesNotKnowFallsBack() {
        #expect(log.progress([]).focus(preferring: "sous-vide") == "knife")
    }

    @Test func theFallbackSkipsLockedAndMasteredSkillsInMenuOrder() {
        let skills: [Skill] = [
            .fixture("knife", in: "basics"),
            .fixture("eggs", in: "basics", needs: ["roux"]),
            .fixture("roux", in: "sauces"),
        ]
        let log = ProgressTestLog(catalog: .fixture(skills: skills))
        let knifeMastered = log.cooks(2, of: "knife", level: 1) + log.cooks(2, of: "knife", level: 2)
        #expect(log.progress(knifeMastered).focus(preferring: "eggs") == "roux")
    }

    @Test func thereIsNoFocusWhenEverythingIsMastered() {
        #expect(log.progress(log.cooksCompletingEverything()).focus(preferring: "knife") == nil)
    }
}
