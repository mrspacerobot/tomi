import Foundation

/// Small server answers for the decoding tests, written as the server writes them.
enum ServerJSON {
    static func decode<Value: Decodable>(_ type: Value.Type, from text: String) throws -> Value {
        try JSONDecoder().decode(type, from: Data(text.utf8))
    }

    static let offer =
        #"{"lessonId": "garlic-butter", "revision": 2, "title": "Garlic butter", "minutes": 20, "#
        + #""skill": {"id": "eggs", "name": "Eggs"}, "level": {"number": 1, "name": "Soft"}, "#
        + #""ingredients": [{"id": "garlic", "name": "Garlic"}, {"id": "olive-oil", "name": "Olive oil"}], "#
        + #""swaps": [{"removed": {"id": "butter", "name": "Butter"}, "#
        + #""added": {"id": "olive-oil", "name": "Olive oil"}}], "#
        + #""missing": [{"id": "garlic", "name": "Garlic"}], "reason": "Quick tonight.", "#
        + #""checked": {"diet": "vegan", "avoid": ["nuts"]}}"#

    static let options =
        #"{"libraryVersion": 3, "diets": [{"id": "vegan", "name": "Vegan", "summary": "No animals"}], "#
        + #""avoidItems": [{"id": "nuts", "name": "Nuts", "kind": "allergen"}], "#
        + #""cuisines": [{"id": "thai", "name": "Thai"}], "#
        + #""equipment": [{"id": "oven", "name": "Oven", "summary": "Bakes", "assumed": true}, "#
        + #"{"id": "wok", "name": "Wok", "summary": "Tosses", "assumed": false}], "#
        + #""experience": [{"id": "basics", "name": "Basics", "summary": "Some"}], "#
        + #""units": [{"id": "metric", "name": "Grams", "summary": "g"}], "#
        + #""ingredients": [{"id": "salt", "name": "Salt"}], "#
        + #""courses": [{"id": "basics", "title": "Basics", "skills": [{"id": "eggs", "name": "Eggs", "#
        + #""summary": "Crack", "prerequisites": [], "levels": [{"number": 1, "name": "Soft"}]}]}]}"#
}
