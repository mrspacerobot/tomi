import Testing
import TomiCore

@testable import Tomi

/// What the cook confirms for tonight.
@MainActor
@Suite struct ConfirmListTests {
    let egg = NamedOption(id: "egg-test", name: "Egg")

    @Test func aTypedIngredientIsAddedTicked() {
        var list = ConfirmList()
        list.add(egg)
        #expect(list.confirmedIngredients == ["egg-test"])
    }

    @Test func addingAnIngredientTwiceTicksTheOneAlreadyThere() {
        var list = ConfirmList(items: [ConfirmItem(ScanItem(label: "eggs", ingredient: egg, confidence: 0.1))])
        #expect(list.confirmedIngredients.isEmpty)
        list.add(egg)
        #expect(list.items.count == 1)
        #expect(list.confirmedIngredients == ["egg-test"])
    }

    @Test func somethingThatMatchedNoIngredientCannotBeTicked() {
        let jar = ConfirmItem(ScanItem(label: "a jar", ingredient: nil, confidence: 1))
        var list = ConfirmList(items: [jar])
        list.toggle(jar.id)
        #expect(!list.items[0].isTicked)
        #expect(list.confirmedIngredients.isEmpty)
    }
}
