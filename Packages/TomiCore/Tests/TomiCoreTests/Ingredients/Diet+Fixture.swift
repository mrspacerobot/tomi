@testable import TomiCore

extension Diet {
    /// A diet with English text that rules out the given facts.
    static func fixture(_ id: DietID, excludes facts: Set<IngredientFactID>) -> Diet {
        let name = LocalizedText(["en": "Diet \(id.rawValue)"])
        return Diet(id: id, name: name, summary: LocalizedText(["en": "What it rules out"]), excludes: facts)
    }

    func with(name: LocalizedText) -> Diet {
        Diet(id: id, name: name, summary: summary, excludes: excludes)
    }

    func with(summary: LocalizedText) -> Diet {
        Diet(id: id, name: name, summary: summary, excludes: excludes)
    }
}
