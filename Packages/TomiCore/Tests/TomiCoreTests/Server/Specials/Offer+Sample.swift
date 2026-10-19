import Foundation

@testable import TomiCore

extension Offer {
    /// A graph offer for a recipe id, checked as given.
    static func sample(id: RecipeID = "recipe/soft-scrambled-eggs", checked: CheckedRestrictions) -> Offer {
        var diet = "null"
        if let named = checked.diet {
            diet = "\"\(named.rawValue)\""
        }
        let avoid = checked.avoid.sorted().map { "\"\($0.rawValue)\"" }.joined(separator: ", ")
        let restrictions = "{\"diet\": \(diet), \"avoid\": [\(avoid)]}"
        let text = GraphJSON.offer(checked: restrictions)
            .replacing("\"recipeId\": \"recipe/soft-scrambled-eggs\"", with: "\"recipeId\": \"\(id.rawValue)\"")
        return (try? ServerJSON.decode(Offer.self, from: text))!
    }
}
