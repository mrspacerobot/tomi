import Testing

@testable import TomiCore

/// Which avoid items food triggers. They are worked out from its facts, never written beside them.
@Suite struct IngredientAvoidTests {
    let table = IngredientTable.fixture()

    @Test(arguments: ["dairy", "pork", "nuts", "alcohol"])
    func aFactTriggersTheAvoidItemThatListsIt(name: String) {
        let fact = IngredientFactID(rawValue: name)
        #expect(table.avoidItems(triggeredBy: [fact]) == [AvoidItemID(rawValue: name)])
    }

    @Test(arguments: ["meat", "fish", "egg"] as [IngredientFactID])
    func aFactNoAvoidItemListsTriggersNothing(fact: IngredientFactID) {
        #expect(table.avoidItems(triggeredBy: [fact]).isEmpty)
    }

    @Test func foodWithNoFactsTriggersNothing() {
        #expect(table.avoidItems(triggeredBy: []).isEmpty)
    }

    @Test func foodTriggersEveryItemItsFactsReach() {
        #expect(table.avoidItems(triggeredBy: ["dairy", "nuts", "meat"]) == ["dairy", "nuts"])
    }

    @Test func anItemIsTriggeredByAnyOneOfItsFacts() {
        let animal = AvoidItem.fixture("animal", triggeredBy: ["meat", "fish"])
        let table = IngredientTable.fixture().with(avoidItems: [animal])
        #expect(table.avoidItems(triggeredBy: ["fish"]) == ["animal"])
        #expect(table.avoidItems(triggeredBy: ["dairy"]).isEmpty)
    }
}
