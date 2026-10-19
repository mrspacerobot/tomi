import Testing

@testable import TomiCore

/// What the cook is shown of `POST /v1/lessons/suggest`: checked suggestions, a special and two alternatives.
@Suite struct TonightsMenuTests {
    let vegan = SuggestionCheckedTests.cook(diet: "vegan", avoid: [])

    func suggestion(_ id: RecipeID, diet: OptionID?) -> Suggestion {
        Suggestion.sample(id: id, checked: CheckedRestrictions(diet: diet, avoid: []))
    }

    func response(special: Suggestion?, alternatives: [Suggestion]) -> SpecialsResponse {
        var response = SpecialsResponse()
        response.special = special
        response.alternatives = alternatives
        return response
    }

    @Test func checkedSuggestionsAreShownInTheServersOrder() {
        let all = response(special: suggestion("a", diet: "vegan"), alternatives: [suggestion("b", diet: "vegan")])
        let menu = TonightsMenu(all, for: vegan)
        #expect(menu.special?.recipeID == "a")
        #expect(menu.alternatives.map(\.recipeID) == ["b"])
    }

    @Test func anUncheckedSpecialGivesWayToTheFirstCheckedAlternative() {
        let all = response(special: suggestion("a", diet: nil), alternatives: [suggestion("b", diet: "vegan")])
        let menu = TonightsMenu(all, for: vegan)
        #expect(menu.special?.recipeID == "b")
        #expect(menu.alternatives.isEmpty)
    }

    @Test func noMoreThanTwoAlternativesAreShown() {
        let alternatives = ["b", "c", "d"].map { suggestion(RecipeID(rawValue: $0), diet: "vegan") }
        let menu = TonightsMenu(
            response(special: suggestion("a", diet: "vegan"), alternatives: alternatives),
            for: vegan
        )
        #expect(menu.alternatives.map(\.recipeID) == ["b", "c"])
    }

    @Test func nothingCheckedIsAnEmptyMenu() {
        let menu = TonightsMenu(response(special: suggestion("a", diet: nil), alternatives: []), for: vegan)
        #expect(menu.isEmpty)
        #expect(TonightsMenu(SpecialsResponse(), for: vegan).isEmpty)
    }
}
