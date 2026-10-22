import Foundation

/// Small server answers for the decoding tests, written as the server writes them.
enum ServerJSON {
    static func decode<Value: Decodable>(_ type: Value.Type, from text: String) throws -> Value {
        try JSONDecoder().decode(type, from: Data(text.utf8))
    }

    static let options =
        #"{"libraryVersion": 3, "diets": [{"id": "vegan", "name": "Vegan", "summary": "No animals"}], "#
        + #""avoidItems": [{"id": "nuts", "name": "Nuts", "kind": "allergen"}], "#
        + #""cuisines": [{"id": "thai", "name": "Thai"}], "#
        + #""equipment": [{"id": "oven", "name": "Oven", "summary": "Bakes", "assumed": true}, "#
        + #"{"id": "wok", "name": "Wok", "summary": "Tosses", "assumed": false}], "#
        + #""experience": [{"id": "basics", "name": "Basics", "summary": "Some"}], "#
        + #""units": [{"id": "metric", "name": "Grams", "summary": "g"}], "#
        + #""staples": [{"id": "salt", "name": "Salt", "assumed": true}], "#
        + #""ingredients": [{"id": "salt", "name": "Salt"}], "#
        + #""courses": [{"id": "basics", "title": "Basics", "skills": [{"id": "eggs", "name": "Eggs", "#
        + #""summary": "Crack", "prerequisites": [], "levels": [{"number": 1, "name": "Soft"}]}]}]}"#
}
