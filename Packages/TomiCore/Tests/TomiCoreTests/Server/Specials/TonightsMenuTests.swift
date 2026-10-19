import Testing

@testable import TomiCore

/// What the cook is shown of `POST /v1/lessons/suggest`: checked offers only, a special and at most two alternatives.
@Suite struct TonightsMenuTests {
    let vegan = OfferCheckedTests.cook(diet: "vegan", avoid: [])

    func offer(_ id: RecipeID, diet: OptionID?) -> Offer {
        Offer.sample(id: id, checked: CheckedRestrictions(diet: diet, avoid: []))
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
        #expect(menu.special?.recipeID == "a")
        #expect(menu.alternatives.map(\.recipeID) == ["b"])
    }

    @Test func anUncheckedSpecialGivesWayToTheFirstCheckedAlternative() {
        let all = response(special: offer("a", diet: nil), alternatives: [offer("b", diet: "vegan")])
        let menu = TonightsMenu(all, for: vegan)
        #expect(menu.special?.recipeID == "b")
        #expect(menu.alternatives.isEmpty)
    }

    @Test func noMoreThanTwoAlternativesAreShown() {
        let alternatives = ["b", "c", "d"].map { offer(RecipeID(rawValue: $0), diet: "vegan") }
        let menu = TonightsMenu(response(special: offer("a", diet: "vegan"), alternatives: alternatives), for: vegan)
        #expect(menu.alternatives.map(\.recipeID) == ["b", "c"])
    }

    @Test func nothingCheckedIsAnEmptyMenu() {
        let menu = TonightsMenu(response(special: offer("a", diet: nil), alternatives: []), for: vegan)
        #expect(menu.isEmpty)
        #expect(TonightsMenu(SpecialsResponse(), for: vegan).isEmpty)
    }
}
