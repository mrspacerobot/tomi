import Foundation
import Testing

@testable import TomiCore

/// A dish is a graph recipe at its graph version, and nothing else. The server takes no cook of a bundled lesson,
/// so a payload that names a lesson, or both, is refused and never read as the recipe it also names.
@Suite struct CookedDishTests {
    func read(_ text: String) throws -> CookedDish {
        try ServerJSON.decode(CookedDish.self, from: text)
    }

    @Test func aRecipeWithItsGraphVersionIsADish() throws {
        let dish = try read(#"{"recipeId": "recipe/omelette", "graphVersion": "g1"}"#)
        #expect(dish == CookedDish(recipe: "recipe/omelette", graphVersion: "g1"))
    }

    @Test(arguments: [
        #"{"lessonId": "eggs-scrambled-1"}"#,
        #"{"lessonId": "eggs-scrambled-1", "recipeId": "omelette"}"#,
        #"{"lessonId": "eggs-scrambled-1", "graphVersion": "g1"}"#,
        #"{"lessonId": "eggs-scrambled-1", "recipeId": "omelette", "graphVersion": "g1"}"#,
        #"{"recipeId": "omelette", "graphVersion": "g1", "note": "x"}"#,
    ])
    func aDishWithAnyOtherFieldIsRefused(text: String) {
        #expect(throws: (any Error).self) { try read(text) }
    }

    @Test(arguments: [#"{"recipeId": "omelette"}"#, #"{"graphVersion": "g1"}"#, "{}"])
    func aDishWithoutItsRecipeOrGraphVersionIsRefused(text: String) {
        #expect(throws: (any Error).self) { try read(text) }
    }

    @Test func aDishIsWrittenAsTheServerReadsIt() throws {
        let dish = CookedDish(recipe: "recipe/omelette", graphVersion: "g1")
        let written = try ProgressJSON.object(of: JSONEncoder().encode(dish))
        #expect(written == ["recipeId": "recipe/omelette", "graphVersion": "g1"])
    }
}
