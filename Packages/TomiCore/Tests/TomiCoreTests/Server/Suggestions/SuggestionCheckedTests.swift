import Testing

@testable import TomiCore

/// The thin guard: a suggestion is shown only when the server checked it for the cook's diet and every avoid item.
@Suite struct SuggestionCheckedTests {
    static func suggestion(diet: OptionID?, avoid: Set<OptionID>) -> Suggestion {
        let restrictions = CheckedRestrictions(diet: diet, avoid: avoid)
        return Suggestion.sample(checked: restrictions)
    }

    static func cook(diet: OptionID?, avoid: Set<OptionID>) -> CookProfile {
        var profile = CookProfile()
        profile.diet = diet
        profile.avoid = avoid
        return profile
    }

    @Test func anSuggestionCheckedForTheSameDietAndAvoidListIsShown() {
        let suggestion = Self.suggestion(diet: "vegan", avoid: ["nuts", "sesame"])
        #expect(suggestion.isChecked(for: Self.cook(diet: "vegan", avoid: ["nuts", "sesame"])))
    }

    @Test func anSuggestionCheckedForMoreAvoidItemsThanTheCookHasIsShown() {
        let suggestion = Self.suggestion(diet: nil, avoid: ["nuts", "sesame"])
        #expect(suggestion.isChecked(for: Self.cook(diet: nil, avoid: ["nuts"])))
    }

    @Test func aCookWhoEatsEverythingSeesAnSuggestionCheckedForNoDiet() {
        #expect(Self.suggestion(diet: nil, avoid: []).isChecked(for: CookProfile()))
    }

    /// The cook said vegan; a suggestion checked for no diet may hold meat.
    @Test func anSuggestionCheckedForNoDietIsHiddenFromACookWithADiet() {
        #expect(!Self.suggestion(diet: nil, avoid: []).isChecked(for: Self.cook(diet: "vegan", avoid: [])))
    }

    @Test func anSuggestionCheckedForAnotherDietIsHidden() {
        let suggestion = Self.suggestion(diet: "vegetarian", avoid: [])
        #expect(!suggestion.isChecked(for: Self.cook(diet: "vegan", avoid: [])))
        #expect(!suggestion.isChecked(for: CookProfile()))
    }

    @Test func anSuggestionNotCheckedForEveryAvoidItemIsHidden() {
        let suggestion = Self.suggestion(diet: nil, avoid: ["nuts"])
        #expect(!suggestion.isChecked(for: Self.cook(diet: nil, avoid: ["nuts", "sesame"])))
    }
}
