import Foundation

@testable import TomiCore

extension Suggestion {
    /// A graph suggestion for a recipe id, checked as given.
    static func sample(id: RecipeID = "recipe/soft-scrambled-eggs", checked: CheckedRestrictions) -> Suggestion {
        var diet = "null"
        if let named = checked.diet {
            diet = "\"\(named.rawValue)\""
        }
        let avoid = checked.avoid.sorted().map { "\"\($0.rawValue)\"" }.joined(separator: ", ")
        let restrictions = "{\"diet\": \(diet), \"avoid\": [\(avoid)]}"
        let text = GraphJSON.suggestion(checked: restrictions)
            .replacing("\"recipeId\": \"recipe/soft-scrambled-eggs\"", with: "\"recipeId\": \"\(id.rawValue)\"")
        return (try? ServerJSON.decode(Suggestion.self, from: text))!
    }
}
