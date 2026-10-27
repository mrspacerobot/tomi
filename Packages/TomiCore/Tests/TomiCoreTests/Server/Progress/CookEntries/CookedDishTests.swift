import Foundation
import Testing

@testable import TomiCore

/// A dish names exactly one recipe or one lesson. A payload that names both is refused, never read as the lesson,
/// which would lose the recipe it also names.
@Suite struct CookedDishTests {
    func read(_ text: String) throws -> CookedDish {
        try ServerJSON.decode(CookedDish.self, from: text)
    }

    @Test func aLessonAloneIsALesson() throws {
        #expect(try read(#"{"lessonId": "eggs-scrambled-1"}"#) == .lesson("eggs-scrambled-1"))
    }

    @Test func aRecipeWithItsGraphVersionIsARecipe() throws {
        let dish = try read(#"{"recipeId": "omelette", "graphVersion": "g1"}"#)
        #expect(dish == .recipe("omelette", graphVersion: "g1"))
    }

    @Test(arguments: [
        #"{"lessonId": "eggs-scrambled-1", "recipeId": "omelette"}"#,
        #"{"lessonId": "eggs-scrambled-1", "graphVersion": "g1"}"#,
        #"{"lessonId": "eggs-scrambled-1", "recipeId": "omelette", "graphVersion": "g1"}"#,
    ])
    func aLessonCombinedWithARecipeIsRefused(text: String) {
        #expect(throws: (any Error).self) { try read(text) }
    }

    @Test(arguments: [#"{"recipeId": "omelette"}"#, #"{"graphVersion": "g1"}"#, "{}"])
    func aRecipeWithoutItsGraphVersionOrAnEmptyDishIsRefused(text: String) {
        #expect(throws: (any Error).self) { try read(text) }
    }

    @Test func aRecipeIsWrittenBackAsARecipeAndNeverAsALesson() throws {
        let dish = CookedDish.recipe("omelette", graphVersion: "g1")
        let written = try ProgressJSON.object(of: JSONEncoder().encode(dish))
        #expect(written["recipeId"] as? String == "omelette")
        #expect(written["lessonId"] == nil)
    }
}
