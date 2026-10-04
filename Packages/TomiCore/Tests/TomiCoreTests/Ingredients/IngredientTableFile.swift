import Foundation

@testable import TomiCore

/// The text of an ingredient table file for decoding tests: a small valid table whose parts a test can replace.
struct IngredientTableFile {
    var schemaVersion = IngredientTable.supportedSchemaVersion
    var facts = #"["soy", "gluten", "meat"]"#
    var avoidItems = #"[{"id": "soy", "name": {"en": "Soy"}, "triggeredBy": ["soy"]}]"#
    var diets = #"[{"id": "vegan", "name": {"en": "Vegan"}, "summary": {"en": "Plants"}, "excludes": ["meat"]}]"#
    var ingredients = #"[{"id": "garlic", "name": {"en": "Garlic"}, "contains": []}]"#

    var data: Data {
        let lists = #""facts": \#(facts), "avoidItems": \#(avoidItems), "diets": \#(diets)"#
        return Data(#"{"schemaVersion": \#(schemaVersion), \#(lists), "ingredients": \#(ingredients)}"#.utf8)
    }
}

extension IngredientTableFile {
    init(schemaVersion: Int, ingredients: String) {
        self.schemaVersion = schemaVersion
        self.ingredients = ingredients
    }
}
