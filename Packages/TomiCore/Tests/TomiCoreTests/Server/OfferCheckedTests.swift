import Testing

@testable import TomiCore

/// The thin guard: an offer is shown only when the server checked it for the cook's diet and every avoid item.
@Suite struct OfferCheckedTests {
    static func offer(diet: OptionID?, avoid: Set<OptionID>) -> Offer {
        var offer = Offer(lessonID: "garlic-butter", revision: 1, title: "Garlic butter")
        offer.checked = CheckedRestrictions(diet: diet, avoid: avoid)
        return offer
    }

    static func cook(diet: OptionID?, avoid: Set<OptionID>) -> CookProfile {
        var profile = CookProfile()
        profile.diet = diet
        profile.avoid = avoid
        return profile
    }

    @Test func anOfferCheckedForTheSameDietAndAvoidListIsShown() {
        let offer = Self.offer(diet: "vegan", avoid: ["nuts", "sesame"])
        #expect(offer.isChecked(for: Self.cook(diet: "vegan", avoid: ["nuts", "sesame"])))
    }

    @Test func anOfferCheckedForMoreAvoidItemsThanTheCookHasIsShown() {
        let offer = Self.offer(diet: nil, avoid: ["nuts", "sesame"])
        #expect(offer.isChecked(for: Self.cook(diet: nil, avoid: ["nuts"])))
    }

    @Test func aCookWhoEatsEverythingSeesAnOfferCheckedForNoDiet() {
        #expect(Self.offer(diet: nil, avoid: []).isChecked(for: CookProfile()))
    }

    /// The cook said vegan; an offer checked for no diet may hold meat.
    @Test func anOfferCheckedForNoDietIsHiddenFromACookWithADiet() {
        #expect(!Self.offer(diet: nil, avoid: []).isChecked(for: Self.cook(diet: "vegan", avoid: [])))
    }

    @Test func anOfferCheckedForAnotherDietIsHidden() {
        let offer = Self.offer(diet: "vegetarian", avoid: [])
        #expect(!offer.isChecked(for: Self.cook(diet: "vegan", avoid: [])))
        #expect(!offer.isChecked(for: CookProfile()))
    }

    @Test func anOfferNotCheckedForEveryAvoidItemIsHidden() {
        let offer = Self.offer(diet: nil, avoid: ["nuts"])
        #expect(!offer.isChecked(for: Self.cook(diet: nil, avoid: ["nuts", "sesame"])))
    }
}
