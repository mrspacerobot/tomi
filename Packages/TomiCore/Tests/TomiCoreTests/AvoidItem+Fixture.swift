@testable import TomiCore

extension AvoidItem {
    /// An avoid item with an English name, triggered by the given facts.
    static func fixture(_ id: AvoidItemID, triggeredBy facts: Set<IngredientFactID>) -> AvoidItem {
        AvoidItem(id: id, name: LocalizedText(["en": "Avoid \(id.rawValue)"]), triggeredBy: facts)
    }

    func with(name: LocalizedText) -> AvoidItem {
        AvoidItem(id: id, name: name, triggeredBy: triggeredBy)
    }
}
