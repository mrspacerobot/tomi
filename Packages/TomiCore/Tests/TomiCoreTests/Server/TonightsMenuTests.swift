import Testing

@testable import TomiCore

/// What the cook is shown of `POST /v1/lessons/suggest`: checked offers only, a special and at most two alternatives.
@Suite struct TonightsMenuTests {
    let vegan = OfferCheckedTests.cook(diet: "vegan", avoid: [])

    func offer(_ id: LessonID, diet: OptionID?) -> Offer {
        var offer = Offer(lessonID: id, revision: 1, title: id.rawValue)
        offer.checked = CheckedRestrictions(diet: diet, avoid: [])
        return offer
    }

    func response(special: Offer?, alternatives: [Offer]) -> SpecialsResponse {
        var response = SpecialsResponse()
        response.special = special
        response.alternatives = alternatives
        return response
    }

    @Test func checkedOffersAreShownInTheServersOrder() {
        let all = response(special: offer("a", diet: "vegan"), alternatives: [offer("b", diet: "vegan")])
        let menu = TonightsMenu(all, for: vegan)
        #expect(menu.special?.lessonID == "a")
        #expect(menu.alternatives.map(\.lessonID) == ["b"])
    }

    @Test func anUncheckedSpecialGivesWayToTheFirstCheckedAlternative() {
        let all = response(special: offer("a", diet: nil), alternatives: [offer("b", diet: "vegan")])
        let menu = TonightsMenu(all, for: vegan)
        #expect(menu.special?.lessonID == "b")
        #expect(menu.alternatives.isEmpty)
    }

    @Test func noMoreThanTwoAlternativesAreShown() {
        let alternatives = ["b", "c", "d"].map { offer(LessonID(rawValue: $0), diet: "vegan") }
        let menu = TonightsMenu(response(special: offer("a", diet: "vegan"), alternatives: alternatives), for: vegan)
        #expect(menu.alternatives.map(\.lessonID) == ["b", "c"])
    }

    @Test func nothingCheckedIsAnEmptyMenu() {
        let menu = TonightsMenu(response(special: offer("a", diet: nil), alternatives: []), for: vegan)
        #expect(menu.isEmpty)
        #expect(TonightsMenu(SpecialsResponse(), for: vegan).isEmpty)
    }
}
