import Foundation
import Testing

@testable import TomiCore

/// A diet or avoid item the table does not list refuses everything, even food with no facts at all.
/// It may have been saved by a newer app, or be an answer that could not be read. Serving anything would ignore it.
@Suite struct IngredientUnknownRestrictionTests {
    let table = IngredientTable.fixture()
    let plain: Set<IngredientFactID> = []

    @Test func aDietTheTableDoesNotListRefusesEverything() {
        #expect(!table.allows(plain, for: .fixture(diet: "keto")))
    }

    @Test func anAvoidItemTheTableDoesNotListRefusesEverything() {
        #expect(!table.allows(plain, for: .fixture(diet: nil, avoid: ["dairy", "lupin"])))
    }

    @Test func anAnswerThatCouldNotBeReadRefusesEverything() {
        #expect(!table.allows(plain, for: .fixture(diet: DietID.unreadable)))
        #expect(!table.allows(plain, for: .fixture(diet: nil, avoid: [AvoidItemID.unreadable])))
    }

    @Test(arguments: [#"{"diet": "keto"}"#, #"{"avoid": ["lupin"]}"#, #"{"diet": 3}"#, #"{"avoid": "nuts"}"#])
    func savedPreferencesThisBuildCannotHonourRefuseEverything(saved: String) throws {
        let preferences = try JSONDecoder().decode(CookPreferences.self, from: Data(saved.utf8))
        #expect(!table.allows(plain, for: preferences))
        #expect(!table.understands(preferences))
    }

    @Test func theTableSaysWhetherItUnderstandsTheCook() {
        #expect(table.understands(CookPreferences()))
        #expect(table.understands(.fixture(diet: "vegan", avoid: ["dairy", "nuts"])))
        #expect(!table.understands(.fixture(diet: "keto")))
        #expect(!table.understands(.fixture(diet: "vegan", avoid: ["lupin"])))
    }

    @Test func anIngredientAskedForByIDIsRefusedToo() throws {
        #expect(try !table.isAllowed("garlic", by: .fixture(diet: "keto")))
        #expect(try !table.isAllowed("garlic", by: .fixture(diet: nil, avoid: ["lupin"])))
    }
}
